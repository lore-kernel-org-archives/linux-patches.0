Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3926FB1
	for <patches@lists.linux.dev>; Thu, 30 Mar 2023 14:58:28 +0000 (UTC)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-194-oEK8kR7MNXufi6_5iMJJKw-1; Thu, 30 Mar 2023 15:58:25 +0100
X-MC-Unique: oEK8kR7MNXufi6_5iMJJKw-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 30 Mar
 2023 15:58:24 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Thu, 30 Mar 2023 15:58:24 +0100
From: David Laight <David.Laight@ACULAB.COM>
To: "'y86-dev@protonmail.com'" <y86-dev@protonmail.com>, Miguel Ojeda
	<ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho
	<wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo
	<gary@garyguo.net>, =?utf-8?B?QmrDtnJuIFJveSBCYXJvbg==?=
	<bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>
CC: "rust-for-linux@vger.kernel.org" <rust-for-linux@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v3 12/13] rust: sync: reduce stack usage of
 `UniqueArc::try_new_uninit`
Thread-Topic: [PATCH v3 12/13] rust: sync: reduce stack usage of
 `UniqueArc::try_new_uninit`
Thread-Index: AQHZYo67xiEDbSa93U2SiSHlQgdRKq8TaqBw
Date: Thu, 30 Mar 2023 14:58:24 +0000
Message-ID: <7f55875c46ab4c4989323ede57f6e46d@AcuMS.aculab.com>
References: <20230329223239.138757-13-y86-dev@protonmail.com>
In-Reply-To: <20230329223239.138757-13-y86-dev@protonmail.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64

RnJvbTogeTg2LWRldkBwcm90b25tYWlsLmNvbQ0KPiBTZW50OiAyOSBNYXJjaCAyMDIzIDIzOjM0
DQo+IA0KPiBgVW5pcXVlQXJjOjp0cnlfbmV3X3VuaW5pdGAgY2FsbHMgYEFyYzo6dHJ5X25ldyhN
YXliZVVuaW5pdDo6dW5pbml0KCkpYC4NCj4gVGhpcyByZXN1bHRzIGluIHRoZSB1bmluaXRpYWxp
emVkIG1lbW9yeSBiZWluZyBwbGFjZWQgb24gdGhlIHN0YWNrLA0KPiB3aGljaCBtYXkgYmUgYXJi
aXRyYXJpbHkgbGFyZ2UgZHVlIHRvIHRoZSBnZW5lcmljIGBUYCBhbmQgdGh1cyBjb3VsZA0KPiBj
YXVzZSBhIHN0YWNrIG92ZXJmbG93IGZvciBsYXJnZSB0eXBlcy4NCg0KRG9lcyB0aGF0IG1lYW4g
cnVzdCBpcyB1c2luZyAodGhlIGVxdWl2YWxlbnQgb2YpIGFsbG9jYSgpID8NCg0KVGhhdCBpcyBi
YW5uZWQgZm9yIEMgY29kZSBpbiB0aGUga2VybmVsIGZvciBhbnkgc2l6ZXMuDQoNCglEYXZpZA0K
DQotDQpSZWdpc3RlcmVkIEFkZHJlc3MgTGFrZXNpZGUsIEJyYW1sZXkgUm9hZCwgTW91bnQgRmFy
bSwgTWlsdG9uIEtleW5lcywgTUsxIDFQVCwgVUsNClJlZ2lzdHJhdGlvbiBObzogMTM5NzM4NiAo
V2FsZXMpDQo=

