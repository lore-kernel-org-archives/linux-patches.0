Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1899A322E
	for <patches@lists.linux.dev>; Tue,  3 May 2022 16:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651595184; x=1683131184;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MQ85w7Epamx1hF9B682F4eoCXfpBJrXR4QrzZ3a76lg=;
  b=CYxpBoCVvyQHXTdSuAYxC1CsABC15mKxsVWJgpAh2yoVBDpqLbVyxLbM
   BA87KmX7S0rlKw7RJFo12ydVHJ2U94/di05RUvvWKzAbxAssbl4V5WrE4
   Vb3CjEXoHKP7kcp2IAu8si1k2FvlLbmuvgDIFExg+P4MVkqbXDTSnzVI9
   qGFIuVJ6jrwiN996Nvkfpt37A11Iw2HvtbH3cg/+rQfbqWRi7zq7Msruk
   a+bS35r0B/Wvzjpq72o1DAfOcf/vkH8U3qN6+zu+ZU5vSNOcKFxM9FgXR
   2qIR5/RYok2ur0S2OV8IuIpM1HkEJ9sMlloWlucyWRD8/JgqlfFJqzBjm
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="266365105"
X-IronPort-AV: E=Sophos;i="5.91,195,1647327600"; 
   d="scan'208";a="266365105"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 09:26:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,195,1647327600"; 
   d="scan'208";a="562277407"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 03 May 2022 09:26:22 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 3 May 2022 09:26:22 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 3 May 2022 09:26:21 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Tue, 3 May 2022 09:26:21 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, Hans de Goede <hdegoede@redhat.com>
CC: "markgross@kernel.org" <markgross@kernel.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
	"Joseph, Jithu" <jithu.joseph@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v5 00/10] Introduce In Field Scan driver
Thread-Topic: [PATCH v5 00/10] Introduce In Field Scan driver
Thread-Index: AQHYWxYVdsKdZt61BUSHj1qB1cqAT60MLiKAgAGW8wD//5MXcIAABnSA
Date: Tue, 3 May 2022 16:26:21 +0000
Message-ID: <ed069ff97fc5413795b43a00d88b7f8a@intel.com>
References: <20220422200219.2843823-1-tony.luck@intel.com>
 <20220428153849.295779-1-tony.luck@intel.com>
 <13054c5c-ed48-b7a2-a800-25b9b1b1ab0d@redhat.com> <YnFK+gXFx0jQB1dz@zn.tnic>
 <c30f82f1d4544ebb8a15da1f6fc033ac@intel.com>
In-Reply-To: <c30f82f1d4544ebb8a15da1f6fc033ac@intel.com>
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

PiBDYW4geW91IGNoZWNrIHRoYXQgSSBmaXhlZCB0aGUgaXNzdWVzIGluIHBhcnQgMDEvMTAgdGhh
dCB5b3UgcmVwb3J0ZWQgaW4gdjMgb2YgdGhpcw0KPiBzZXJpZXMgYW5kIGdpdmUgYW4gQWNrIHRv
IEhhbnM/DQoNCk9vcHMgLi4uIHJlYWRpbmcgZS1tYWlsIG91dCBvZiBvcmRlciAuLi4gSSBzZWUg
dGhhdCB5b3UgYWxyZWFkeSBnYXZlIHRoZSBBY2suICBUaGFua3MhDQoNCi1Ub255DQo=
