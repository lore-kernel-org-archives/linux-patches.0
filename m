Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6F77C
	for <patches@lists.linux.dev>; Fri,  4 Mar 2022 21:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646427667; x=1677963667;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VjE5SQTXxcv9yH10VlgYyxJXzMzTnv0lxqg2YttM5ew=;
  b=htKXzBszp2XHRyh+qrEmAsNaVhJaVi4JJxwbN4zGe5Nf04/+RwtBQNFP
   cmvT/b1eUDCwer2cIZc+X5C+xevAVH4Q49jkgy94nosHdlHQlWxHF6A9/
   fv/lRel1PuKk7zslkHGqtUYoEhRzT2bDWZvuppFmemVirft/SalXhlmGp
   x585rYTRpaGhcWqTS2CxTXCMWgl+Y9SLup8aBXNYcPw3Ekxy6owVw76K3
   806eWvbkSjlZyR8r2ip+80+Nlxu8Nv3wBShGVHELJ3HIUQG+qqxaptsa2
   d31N/z1KTBXdktO04V9+ymHmpkF7ExN7wJJckFG2k95bPQun7dWV6xdz2
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="241487867"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="241487867"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 13:01:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="610056761"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 04 Mar 2022 13:01:06 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 4 Mar 2022 13:01:05 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 4 Mar 2022 13:01:04 -0800
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.021;
 Fri, 4 Mar 2022 13:01:04 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: "Joseph, Jithu" <jithu.joseph@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "hdegoede@redhat.com" <hdegoede@redhat.com>,
	"markgross@kernel.org" <markgross@kernel.org>
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
Thread-Index: AQHYLaZd5d+yEBuhdEqmhIRDOkET6qyu6T6AgAFSX4D//33N4A==
Date: Fri, 4 Mar 2022 21:01:03 +0000
Message-ID: <52a16a3eb3f54ec88f7a841baa7000fd@intel.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <20220301195457.21152-9-jithu.joseph@intel.com>
 <188492dc80c017375da76d444347b1d00c2031f6.camel@intel.com>
 <7b9c788e-21dc-eedc-a1b4-9c6877fa48fe@intel.com>
In-Reply-To: <7b9c788e-21dc-eedc-a1b4-9c6877fa48fe@intel.com>
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

Pj4gWW91IGNvdWxkIGp1c3QgY3V0IHRvIHRoZSBjaGFzZSBhbmQgZG86IHN5c2ZzX2VxKGJ1Ziwg
IjEiKQ0KPg0KPiBUaGFua3Mgd2lsbCB1c2UgdGhpcw0KDQokIGdpdCBncmVwIHN5c2ZzX2VxDQok
DQoNCkkgZG9uJ3Qgc2VlIHRoaXMgZGVmaW5lZCAob3IgdXNlZCkgYW55d2hlcmUgaW4gdGhlIGtl
cm5lbC4gSXMNCml0IHNwZWxsZWQgZGlmZmVyZW50bHkgZnJvbSBob3cgdHlwZWQgaGVyZT8NCg0K
LVRvbnkNCg0K
