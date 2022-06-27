Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B5A33FB
	for <patches@lists.linux.dev>; Mon, 27 Jun 2022 17:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656350879; x=1687886879;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0WByDonN5WjgTktzGxnKob49Bp4pihahF3HafDcF7+E=;
  b=YVI8jz+VJnCsdQXkFiS3j+GinMhjl+17w0RMoVc71UF3jM5BsjfYZMXV
   Yj3SxYPUQ0oZXWHKTJHDvJ/kCUvBWd89mb3HNy9qRDE4+eQw9SXwptx9K
   4uwSVOpMHg6IbyOvHnLPKdi58QcOJ+kmYLrTDCqvTHzhBzF4QNTEohZUf
   l44hK+i+HpLf896fSvGQ5KZmp5O5CJwd0VZMreuVqZj6Wn8QypjOUHiti
   56c0Uu6/7R2aM7yRmOoFrUFTI2Ege5kazjfYSDzhcuLrDe3G4qw3AXpcb
   uuA4jz5aWpFnOs1OyvFIAYWQ9mW5sAFAzzNNeWsht1WOpyzv8bgAJ0Mgn
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="282607044"
X-IronPort-AV: E=Sophos;i="5.92,226,1650956400"; 
   d="scan'208";a="282607044"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 10:27:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,226,1650956400"; 
   d="scan'208";a="916812712"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 27 Jun 2022 10:27:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 27 Jun 2022 10:27:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 27 Jun 2022 10:27:58 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Mon, 27 Jun 2022 10:27:58 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, Yazen Ghannam <yazen.ghannam@amd.com>
Subject: RE: [PATCH] RAS/CEC: Reduce default threshold to offline a page to
 "2"
Thread-Topic: [PATCH] RAS/CEC: Reduce default threshold to offline a page to
 "2"
Thread-Index: AQHYerRlyb6k64LVCESU0Ew6xDDN8q1j550A//+ysUA=
Date: Mon, 27 Jun 2022 17:27:57 +0000
Message-ID: <7da92773f7084c57814f7ef4d033bc53@intel.com>
References: <20220607212015.175591-1-tony.luck@intel.com>
 <YrnBWjkX82OhXAtL@zn.tnic>
In-Reply-To: <YrnBWjkX82OhXAtL@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

Pj4gMSkgQ2hhbmdlIHRocmVzaG9sZCB0byAiMiIuDQo+DQo+IEtpbmRhIHVuY29uZGl0aW9uYWwg
dGhhdC4uLiB3ZSBoYXZlbid0IHRhbGtlZCB0byBvdGhlciB2ZW5kb3JzIGV2ZW4uDQoNCkV4aXN0
aW5nIGRlZmF1bHQgaXMgMTAyMyAuLi4gd2hpY2ggaXMgbm90IGEgZ29vZCBjaG9pY2UgZm9yIGFu
eW9uZSAoZXhjZXB0DQpwZXJoYXBzIG9zdHJpY2hlcyB0aGF0IHdhbnQgdG8gYnVyeSB0aGVpciBo
ZWFkcyBpbiB0aGUgc2FuZCBhbiBpZ25vcmUgbWFyZ2luYWwNCkRJTU1zIGZvciBhcyBsb25nIGFz
IHBvc3NpYmxlKS4NCg0KU28gY2hhbmdpbmcgdGhlIHRocmVzaG9sZCB0byAiMiIgd291bGQgYmUg
YW4gaW1wcm92ZW1lbnQgaW4gYXQgbGVhc3QgYmVpbmcgcmlnaHQgZm9yDQpvbmUgdmVuZG9yLCBp
bnN0ZWFkIG9mIHdyb25nIGZvciBhbGwuDQoNCklmIHNvbWVvbmUgY29tZXMgdXAgd2l0aCBhIGRp
ZmZlcmVudCB2YWx1ZSBmb3IgYW5vdGhlciBDUFUgb3IgRElNTSB2ZW5kb3INCmNvbWJpbmF0aW9u
IC4uLiB3b3VsZCB3ZSBoYXZlIHRoZSBSQVNfQ0VDIGRyaXZlciBjaGVjayBib290X2NwdV9kYXRh
Lng4Nl92ZW5kb3INCmFuZCBTTUJJT1MgdG8gc2V0IGEgZGlmZmVyZW50IGRlZmF1bHQ/DQoNCj4+
IDIpIERvIHZlcnkgc21hcnQgcGxhdGZvcm0gZGVwZW5kZW50IHRoaW5ncw0KPg0KPiBJZiB5b3Ug
bWVhbiBBSSwgdGhhdCBwcm9iYWJseSB3b24ndCBoYXBwZW4gaW4gdGhlIGtlcm5lbC4NCg0KQWdy
ZWVkLiBZb3UgZG9uJ3QgZXZlbiBuZWVkIHRoZSAicHJvYmFibHkiLiBUaGlzIGlzbid0IGtlcm5l
bCBtYXRlcmlhbC4NCg0KTGludXggYWxyZWFkeSBoYWQgYSBob29rIGluIHRoZSBHSEVTIGNvZGUg
dG8gdGFrZSBhbiBlcnJvciByZWNvcmQgZnJvbQ0KdGhlIHBsYXRmb3JtIGFuZCBvZmZsaW5lIGEg
cGFnZS4gU28gdGhpcyAic21hcnQiIGNvZGUgY291bGQgYmUgZG9uZQ0KYnkgQklPUyBvciBCTUMg
anVzdCBwcm92aWRpbmcgdGhlIHJlc3VsdGluZyBsaXN0IG9mIHBhZ2VzIHRoYXQgc2hvdWxkDQpi
ZSB0YWtlbiBvZmZsaW5lIHRvIExpbnV4Lg0KDQotVG9ueQ0K
