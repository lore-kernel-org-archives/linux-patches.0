Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375E929CA
	for <patches@lists.linux.dev>; Thu, 27 Jan 2022 16:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643302447; x=1674838447;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ybxUvAtI2zNGLFznyN1Y3SuKrLBM5S6HWVAB/M0bYxw=;
  b=ZXeU/j5uAGQ/vWgk7qqCAbHZCN5pTVVsURAGejANbSNdtWtXlAFeUBf1
   YHZvZDkqO6aJA+g+a/soAGna0bzJd0M2RWaM6SAGzeDo55BtGfas7tAQc
   HdhUSNhEZAfFPqpKZudAEh9eNINe/nlKTo/j4HSH2pt5DZHci+N6F/fMR
   T7zNvfcfk6Jcd1UHUnrnRd7eFNH+WOWDW34+5KedqUu+LO5k+w8iguGhg
   a3rCCDYf96LyVgyRRmEDd2vL92F0ZmMaZWi0OMtuML2kjO3CoiQadvuAL
   k0Bamcoq8fCWk+YnsxeKnQUZCMcFdurRpkjLpyFpAFAl9SV0aiEpbYSNk
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="245750545"
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="245750545"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 08:52:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,321,1635231600"; 
   d="scan'208";a="495794343"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga002.jf.intel.com with ESMTP; 27 Jan 2022 08:52:45 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 27 Jan 2022 08:52:44 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 27 Jan 2022 08:52:44 -0800
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.020;
 Thu, 27 Jan 2022 08:52:44 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Smita Koralahalli Channabasappa
	<smita.koralahallichannabasappa@amd.com>, Wei Huang <wei.huang2@amd.com>, Tom
 Lendacky <thomas.lendacky@amd.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v2 2/6] x86/cpu: Merge Intel and AMD ppin_init() functions
Thread-Topic: [PATCH v2 2/6] x86/cpu: Merge Intel and AMD ppin_init()
 functions
Thread-Index: AQHYDu8DikL4mqOUK0y4S02wOfcLTKx3N7KA///mO/A=
Date: Thu, 27 Jan 2022 16:52:43 +0000
Message-ID: <73464511fcf942389f51095936942b2c@intel.com>
References: <20220107225442.1690165-1-tony.luck@intel.com>
 <20220121174743.1875294-1-tony.luck@intel.com>
 <20220121174743.1875294-3-tony.luck@intel.com> <YfJyS6/zXGIoasGO@zn.tnic>
In-Reply-To: <YfJyS6/zXGIoasGO@zn.tnic>
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

Pj4gKwlbWDg2X1ZFTkRPUl9BTURdID0gew0KPj4gKwkJLmZlYXR1cmUgPSBYODZfRkVBVFVSRV9B
TURfUFBJTiwNCj4+ICsJCS5tc3JfcHBpbl9jdGwgPSBNU1JfQU1EX1BQSU5fQ1RMLA0KPj4gKwkJ
Lm1zcl9wcGluID0gTVNSX0FNRF9QUElODQo+CQleXl5eXl5eXl4NCj4NCj4gWW91IGZvcmdvdCB0
byByZWJ1aWxkIGFmdGVyIHJlbW92aW5nIHRoYXQgZ3V5IGhlcmUgaW4gdGhlIHN0cnVjdA0KPiBk
ZWZpbml0aW9uLiBJJ2xsIGZpeCBpdCB1cCBub3cgc28gdGhhdCBJIGNhbiBjb250aW51ZSBnb2lu
ZyB0aHJvdWdoIHRoZW0NCj4gYnV0IHBscyBmaXggaW4gdGhlIG5leHQgc3VibWlzc2lvbiBzbyB0
aGF0IGFsbCBwYXRjaGVzIGJ1aWxkIHNlcGFyYXRlbHkuDQoNCk9vcHMuIFNvcnJ5LiBZZXMuIEkg
d2lsbCBtb3ZlIHRob3NlIGluaXRpYWxpemF0aW9ucyBvdXQgb2YgdGhpcyBwYXRjaA0KYW5kIGlu
dG8gdGhlIGxhdGVyIHBhdGNoIHdoZW4gdGhlIC5tc3JfcHBpbiBmaWVsZCBpcyBhZGRlZC4NCg0K
SSdsbCB3YWl0IG9uIHBvc3RpbmcgdjMgdW50aWwgeW91IGZpbmlzaCB3aXRoIHRoZSByZXN0IG9m
IHYyLg0KDQpUaGFua3MNCg0KLVRvbnkNCg0K
