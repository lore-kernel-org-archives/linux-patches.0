Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786032CA1
	for <patches@lists.linux.dev>; Mon, 31 Jan 2022 19:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643657397; x=1675193397;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FyfgtJ7CW08SAY0Nnz6Haxd0+5O2JOcKYd4gU3dlgjA=;
  b=WLZsXeig80sCgmxK5FAqC5g9ievFqCE9YnG/JHuuZHyR6i7yH/P01j99
   Q03JsjJZeLfFCIXLrUAmOpKk4M9bckVlRZkjwZ0zeLiRmR+hWAmP89FDk
   Fdty1ANEA8z75dw2xRVxxh9mtFDjXpchAA5v1EOmMqXITj5tbp1k0OZGc
   vZoCwJlpml8MfdAeaFnYnMnXEFgLK6i38hkHH2B1+yhYWrcwNjZPYA1VR
   NcPjDl6vWlPVBf++A1F3YyY3V3tNLB391OKXtK3ANVDdGsrYSaestJYUX
   /OQ+lpcgJDYldJZA8hXlRxgLDd8lh8ZAMrcqGG/g7QHEegZlfTiKsc163
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10244"; a="231105836"
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="231105836"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 11:29:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,331,1635231600"; 
   d="scan'208";a="479328571"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 31 Jan 2022 11:29:56 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 31 Jan 2022 11:29:56 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 31 Jan 2022 11:29:55 -0800
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.020;
 Mon, 31 Jan 2022 11:29:55 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Smita Koralahalli Channabasappa
	<smita.koralahallichannabasappa@amd.com>, Wei Huang <wei.huang2@amd.com>, Tom
 Lendacky <thomas.lendacky@amd.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v2 0/6] PPIN (Protected Processor Inventory Number)
 updates
Thread-Topic: [PATCH v2 0/6] PPIN (Protected Processor Inventory Number)
 updates
Thread-Index: AQHYDu8D4O0fiLdYEEuSQ7RARvcUdqx9pUeA///LWoCAAJWVAP//goCAgACL84D//32JIA==
Date: Mon, 31 Jan 2022 19:29:55 +0000
Message-ID: <30cc529e01b64ca7aa8efe0c89eb5ed0@intel.com>
References: <20220107225442.1690165-1-tony.luck@intel.com>
 <20220121174743.1875294-1-tony.luck@intel.com> <YffWtTq2y6K8+gHF@zn.tnic>
 <YfgbCFNeNEkypCmC@agluck-desk2.amr.corp.intel.com> <YfgoBgwgfoiKkPa9@zn.tnic>
 <YfgvPD6AUPIwQgyf@agluck-desk2.amr.corp.intel.com> <Yfg0JauShcFw1WPc@zn.tnic>
In-Reply-To: <Yfg0JauShcFw1WPc@zn.tnic>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

PiBMZW1tZSBiZSBjbGVhcjogSSdtIGJlaW5nIHRoZSBkZXZpbCdzIGFkdm9jYXRlIGhlcmUgb24g
cHVycG9zZSBiZWNhdXNlDQo+IEkgd2FudCB0byBtYWtlIHN1cmUgd2UgZG9uJ3Qgd2FsayBpbnRv
IHNvbWUgcHJpdmFjeSB0aGluZyB3ZSBoYXZlbid0DQo+IHRob3VnaHQgYWJvdXQgYXQgdGhlIHRp
bWUuDQoNClN1cmUuIEl0J3MgZ29vZCB0byBsb29rIGF0IHRoaXMgZnJvbSBvdGhlciBwZXJzcGVj
dGl2ZXMuICBUaGVyZSBtYXkgYmUgc29tZQ0Kc29mdHdhcmUtYXMtYS1zZXJ2aWNlIHRoaW5nIHdo
ZXJlIHRoZSBwcm92aWRlciBvZiB0aGUgc2VydmljZSBkb2Vzbid0IHdhbnQNCmEgc2ltcGxlIHdh
eSB0byByZXZlYWwgdGhhdCBqb2JzIGFyZSBiZWluZyBtaWdyYXRlZCBhcm91bmQgYSBwb29sIG9m
IHN5c3RlbXMuDQoNCj4gU28gSSBndWVzcyAwNDAwLCByb290OnJvb3Qgd291bGQgYmUgdGhlIGNv
cnJlY3QgdGhpbmcgdG8gZG8gLSBhZG1pbnMgY2FuDQo+IHRoZW4gY2hhbmdlIHBlcm1pc3Npb25z
IGxhdGVyIG9yIHNvLiBSYXRoZXIgdGhhbiBtYWtpbmcgaXQgcmVhZGFibGUgYnkNCj4gZXZlcnlv
bmUgYnkgZGVmYXVsdCBhbmQgbGVhdmluZyBpdCB0byBwZW9wbGUgdG8gdGlnaHRlbiBpdCBhZnRl
ciBib290Lg0KDQpZdXAuICBJZiBzb21lb25lIGhhcyBhIHRvb2wgdGhhdCBuZWVkcyBwcGluLCBi
dXQgdGhleSBkb24ndCB3YW50IHRvIHJ1bg0KYXMgcm9vdCB0aGV5IGNhbiBqdXN0IGFkZCBlaXRo
ZXIgb2Y6DQoNCgljaG93biBub3Ryb290YWRtaW4gL3N5cy9kZXZpY2VzL3N5c3RlbS9jcHUvY3B1
Ki90b3BvbG9neS9wcGluDQoNCm9yDQoNCgljaG1vZCA0NDQgL3N5cy9kZXZpY2VzL3N5c3RlbS9j
cHUvY3B1Ki90b3BvbG9neS9wcGluDQoNCnRvIHNvbWUgL2V0Yy9yYyogZmlsZS4NCg0KLVRvbnkN
Cg==
