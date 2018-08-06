import { Component } from '@angular/core';
import { AngularFirestore } from 'angularfire2/firestore';
import { Observable } from 'rxjs';
import { switchMap } from 'rxjs/operators';
import { Breakpoints, BreakpointState, BreakpointObserver } from '@angular/cdk/layout';

@Component({
  selector: 'app-guest',
  templateUrl: './guest.component.html',
  styleUrls: ['./guest.component.css']
})

export class GuestComponent {
  items: Observable<any[]>;

  constructor(db: AngularFirestore) {
    this.items = db.collection('news',
    ref => ref.where('status', '==', true).orderBy('created', 'desc').limit(5)
  ).valueChanges();
    console.log(this.items);
  }
}
