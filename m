Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945827E
	for <patches@lists.linux.dev>; Fri,  4 Mar 2022 16:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646412666; x=1677948666;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mWmPx97zjm9ODTjd5h2kI0rA786WlL+/LzccJtXuD48=;
  b=frhS+yM/Wzb0dX8Bl44vrraN8gYPMlBX/uRNjVA7XadUkYeTXpXjKqTq
   WmMX4sO4/hx/Ilbd1ixOCbBJzO/aYKlKZyw82FGHcQOQvv529WghDIAFY
   9seA7lcVgrWRMLQ88/6WLfqnfK18S08orQU0nL0Igzm+rHoQZzEm0lPH2
   bQRfckjZdQnDV7biNhcZ2LLlcz7LBZuSOv8D8ZGs+rA1H5BlKaT14YWpw
   Wk8tdYouhEHEaCqbHedjHAU/PVHYb+zO1Y1RygnClWGsla9zS/BcXiHGC
   34iwhPah5k4PfztGmRJLdxwF9aouGL2AhL4yM5JibAfyWrNTyVBrBqazv
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="317243019"
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="317243019"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 08:51:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,155,1643702400"; 
   d="scan'208";a="546275014"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga007.fm.intel.com with ESMTP; 04 Mar 2022 08:51:05 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 4 Mar 2022 08:51:05 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 4 Mar 2022 08:51:05 -0800
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.021;
 Fri, 4 Mar 2022 08:51:04 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "hdegoede@redhat.com"
	<hdegoede@redhat.com>, "markgross@kernel.org" <markgross@kernel.org>,
	"Joseph, Jithu" <jithu.joseph@intel.com>
CC: "corbet@lwn.net" <corbet@lwn.net>, "Raj, Ashok" <ashok.raj@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "rostedt@goodmis.org"
	<rostedt@goodmis.org>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>, "gregkh@linuxfoundation.org"
	<gregkh@linuxfoundation.org>, "andriy.shevchenko@linux.intel.com"
	<andriy.shevchenko@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: RE: [RFC 08/10] platform/x86/intel/ifs: Add IFS sysfs interface
Thread-Topic: [RFC 08/10] platform/x86/intel/ifs: Add IFS sysfs interface
Thread-Index: AQHYLaZd5d+yEBuhdEqmhIRDOkET6qyu6T6AgACInrA=
Date: Fri, 4 Mar 2022 16:51:04 +0000
Message-ID: <f0a2e1fab35a440ebf136862e8584cf0@intel.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
	 <20220301195457.21152-9-jithu.joseph@intel.com>
 <188492dc80c017375da76d444347b1d00c2031f6.camel@intel.com>
In-Reply-To: <188492dc80c017375da76d444347b1d00c2031f6.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.401.20
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

PiBEeW5hbWljIGNyZWF0aW9uIG9mIHN5c2ZzIGF0dHJpYnV0ZXMgc29tZXRpbWUgYWZ0ZXIgdGhl
IGRyaXZlciBsb2FkcyBpcw0KPiBub3QgZnJpZW5kbHkgZm9yIHNvbWV0aGluZyB0aGF0IGxpa2Vs
eSBvbmx5IG5lZWRzIHRoZSBtb2R1bGUgbG9hZGVkIGZvcg0KPiBhIHRlc3QgcnVuIGFuZCB0aGVu
IHVubG9hZGVkIGFnYWluLiBJIHRoaW5rIHRoaXMgZWZmb3J0IHdvdWxkIGJlIGJldHRlcg0KPiBz
ZXJ2ZWQgYnkgYnVpbGRpbmcgYSBzeXNmcyB0b3BvbG9neSByZWdpc3RlcmVkIHVuZGVybmVhdGgg
YW4gaWZzDQo+IHBsYXRmb3JtIGRldmljZS4NCg0KQWguIEFub3RoZXIgZ2FwIGluIHRoZSBEb2N1
bWVudGF0aW9uL3g4Ni9pZnMucnN0IHRoYXQgSSBuZWVkIHRvIGZpeC4NCg0KRXhwZWN0ZWQgdXNl
IGNhc2UgaXNuJ3QganVzdCAicnVuIHRoaXMgdGVzdCBvbmNlIHRvIGNoZWNrIHlvdXIgc3lzdGVt
DQpmb3Igc2lnbnMgb2Ygc2lsaWNvbiBhZ2luZyIuIEl0IGlzIGxvYWQgdGhpcyBhbmQgcnVuIHRo
ZSB0ZXN0cyBhdCByZWd1bGFyDQppbnRlcnZhbHMgdG8gY2F0Y2ggZGV2ZWxvcGluZyBwcm9ibGVt
cyBhcyBzb29uIGFzIHBvc3NpYmxlLg0KDQpJJ2xsIHNlZSBpZiBJIGNhbiBnZXQgdGhlIGFyY2hp
dGVjdHMgb2YgdGhlIGZlYXR1cmUgdG8gZ2l2ZSBzb21lIGlucHV0DQpvbiB3aGF0IHRoZXkgZXhw
ZWN0IHRvIGJlIGEgInJlZ3VsYXIgaW50ZXJ2YWwiIHRvIGJlIGluY2x1ZGVkIGluDQp0aGUgZG9j
dW1lbnRhdGlvbi4NCg0KTm90ZSB0aGF0IGV2ZW4gaWYgYSB1c2VyIG9ubHkgcGxhbnMgdG8gcnVu
IGluZnJlcXVlbnRseSwgdGhlcmUgaXNuJ3QNCm11Y2ggYmVuZWZpdCBmcm9tIHVubG9hZGluZyB0
aGUgbW9kdWxlLiBUaGUga2VybmVsIG1lbW9yeSB1c2VkDQpieSB0aGlzIGRyaXZlciBpcyBkd2Fy
ZmVkIGJ5IHRoZSBtZW1vcnkgcmVzZXJ2ZWQgYnkgQklPUyB0byBob2xkDQp0aGUgdmFsaWRhdGVk
IGNvcGllcyBvZiB0aGUgc2NhbiB0ZXN0cy4gUmVsb2FkaW5nIHRoZSB0ZXN0cyBmcm9tIHRoZQ0K
ZmlsZSB0YWtlcyBsb25nZXIgdGhhbiBhIHNpbmdsZSBydW4gb2YgdGhlIHRlc3RzICh0aG91Z2gg
cGVyaGFwcw0KdGhhdCBjYW4gYmUgYXZvaWRlZCBpZiByZWFkaW5nIHRoZSBNU1JzIGNhbiBjb25m
aXJtIHRoYXQgdGhlDQp0ZXN0cyBhbHJlYWR5IGxvYWRlZCBpbiByZXNlcnZlZCBtZW1vcnkpLg0K
DQotVG9ueQ0K
