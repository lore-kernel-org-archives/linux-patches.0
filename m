Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253623C35
	for <patches@lists.linux.dev>; Tue, 28 Jun 2022 16:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656435111; x=1687971111;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WPt6chq2E/pOwKzp338XFQQkNomggHH7+oPZVSHVD7U=;
  b=BzkZeBYeBnbVZ1WBFZUaHNkRuhGpPD+ClEQIjtuimr0MsfNxsATfVeKK
   3Eeo2oLxIlKUTGi7JiUbY/12rf/Tk8KgTRb9fskpEdv/tFkEDtrydhexc
   43MtGrBk9qwq5rn2qt0IA3pMlw66G/ieX266THt+3D7+nRBqjjdp/yjEY
   CJ4p8ChGXLEYSj1JtJ4qrC7M4tGtBtcZ98IYphcD4tRMT/mOpFs2n9CyX
   YHXkmz4zqgks+zKKfyH82KVe+rDd0KNrg/BfPk19PFA/7Cf2NslcsTh3h
   NXFw+a0Y/4A8TRm1d/PGdUz8r3FSZ1oesj2jI6SJ8l90FrZ1Rm9l0QH3O
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="261597138"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="261597138"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 09:51:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="693188414"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 28 Jun 2022 09:51:50 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 28 Jun 2022 09:51:49 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 28 Jun 2022 09:51:49 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Tue, 28 Jun 2022 09:51:49 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, Yazen Ghannam <yazen.ghannam@amd.com>
Subject: RE: [PATCH] RAS/CEC: Reduce default threshold to offline a page to
 "2"
Thread-Topic: [PATCH] RAS/CEC: Reduce default threshold to offline a page to
 "2"
Thread-Index: AQHYerRlyb6k64LVCESU0Ew6xDDN8q1j550A//+ysUCAAfXYAP//lk5g
Date: Tue, 28 Jun 2022 16:51:49 +0000
Message-ID: <8f580a2544d846c69c9941e151fa7cc3@intel.com>
References: <20220607212015.175591-1-tony.luck@intel.com>
 <YrnBWjkX82OhXAtL@zn.tnic> <7da92773f7084c57814f7ef4d033bc53@intel.com>
 <Yrsleko0MnGtwaaR@zn.tnic>
In-Reply-To: <Yrsleko0MnGtwaaR@zn.tnic>
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

Pj4gRXhpc3RpbmcgZGVmYXVsdCBpcyAxMDIzIC4uLiB3aGljaCBpcyBub3QgYSBnb29kIGNob2lj
ZSBmb3IgYW55b25lIChleGNlcHQNCj4+IHBlcmhhcHMgb3N0cmljaGVzIHRoYXQgd2FudCB0byBi
dXJ5IHRoZWlyIGhlYWRzIGluIHRoZSBzYW5kIGFuIGlnbm9yZSBtYXJnaW5hbA0KPj4gRElNTXMg
Zm9yIGFzIGxvbmcgYXMgcG9zc2libGUpLg0KPg0KPldoeSBpc24ndCB0aGF0IGEgZ29vZCBjaG9p
Y2U/DQoNCkl0IGZhaWxzIHRvIHVzZSB0aGUgY2FwYWJpbGl0aWVzIG9mIGgvdyBhbiBMaW51eCB0
byBhdm9pZCBhIGZhdGFsIGVycm9yIGluIHRoZSBmdXR1cmUuDQpDb3JyZWN0ZWQgZXJyb3JzIGFy
ZSAoc29tZXRpbWVzKSBhIHByZWRpY3RvciBvZiBtYXJnaW5hbC9hZ2luZyBtZW1vcnkuIENvcHlp
bmcNCmRhdGEgb3V0IG9mIGEgZmFpbGluZyBwYWdlIHdoaWxlIHRoZXJlIGFyZSBqdXN0IGNvcnJl
Y3RlZCBlcnJvcnMgY2FuIGF2b2lkIGxvc2luZw0KdGhhdCB3aG9sZSBwYWdlIGxhdGVyLg0KDQpB
IHNpbmdsZSBlcnJvciBpcyBwbGF1c2libHkgYSBwYXJ0aWNsZSBzdHJpa2UgY2F1c2luZyBhIGJp
dCBmbGlwLiBCdXQgYSBzZWNvbmQgZXJyb3INCmluIHRoZSBzYW1lIHBhZ2UgaXMgYSBsb25nIHNo
b3QgKG15IGRlc2t0b3AgaGFzIDY0RyBvZiBtZW1vcnksIHNvIDE2IG1pbGxpb24NCnBhZ2VzIC4u
LiB0aGF0J3MgYW4gYXdmdWwgbG90IG9mIG90aGVyIHRhcmdldHMgZm9yIGEgc2Vjb25kIHBhcnRp
Y2xlIHN0cmlrZSkuDQoNCj5JJ20gc3VyZSB0aGVyZSBhcmUgZXJyb3IgcmF0ZXMgd2hlcmUgdGhp
cyBmaXRzIGp1c3QgZmluZS4NCg0KRXhwbGFpbiBmdXJ0aGVyLiBBcGFydCBmcm9tIHRoZSAib3N0
cmljaCIgY2FzZSBJJ20gbm90IHN1cmUgd2hhdCB0aGV5IGFyZS4NCg0KPj4gU28gY2hhbmdpbmcg
dGhlIHRocmVzaG9sZCB0byAiMiIgd291bGQgYmUgYW4gaW1wcm92ZW1lbnQgaW4gYXQgbGVhc3QN
Cj4+IGJlaW5nIHJpZ2h0IGZvciBvbmUgdmVuZG9yLCBpbnN0ZWFkIG9mIHdyb25nIGZvciBhbGwu
DQo+DQo+U28gSSdtIHByZXR0eSBzdXJlIHRoYXQgaXMgbm90IG5lZWRlZCBvbiBBTUQgYXQgYWxs
Lg0KDQpJdCdzIGZhciBtb3JlIGEgcHJvcGVydHkgb2YgRElNTXMgdGhhbiBvZiB0aGUgQ1BVLiBV
bmxlc3MgQU1EIGFyZSB1c2luZw0Kc29tZSBERUNURUQgb3IgYmV0dGVyIGxldmVsIG9mIEVDQyBm
b3IgbWVtb3J5Lg0KDQotVG9ueQ0K
