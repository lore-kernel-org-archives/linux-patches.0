Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3092322E
	for <patches@lists.linux.dev>; Tue,  3 May 2022 16:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651593883; x=1683129883;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TOqujW17h1b62Lml6AZoxLlPLfSYjHro3qzoD1t/Ztk=;
  b=hB8mF/6fX0zV5X0GZyfQzRO2gvLgVlBzyKosSVAE315ulAYeKpMG5wpf
   eSR6uA0EsuCn0HLwceNLG51ZxGDfCnx1FNF2ejkwvXKiaI+MjcCiDty36
   HGN3zkO4rDuIG9VQ+ZWY7Hjd9xJEEpRS4/94ZGQ4oPXPAm0dJmKOB7YY9
   +NUdKlnP17VBgLVSFtwLA0UNbtdIjO9GSHliQsWMW4VnsSZt+csAXkW7L
   u9wDFcVVcRq2bKAalnNBXjGPKRdKNsbQYS2enzmLEUuplZDvMAPPx5JqB
   GOzrjGXbEsWrmCLq8zqvbXvEQmvbXeRvmUe9ORjSI4r19A/jwRzYlWIRH
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10336"; a="267393678"
X-IronPort-AV: E=Sophos;i="5.91,195,1647327600"; 
   d="scan'208";a="267393678"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 09:04:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,195,1647327600"; 
   d="scan'208";a="547666816"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 03 May 2022 09:04:41 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 3 May 2022 09:04:40 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 3 May 2022 09:04:40 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Tue, 3 May 2022 09:04:40 -0700
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
Thread-Index: AQHYWxYVdsKdZt61BUSHj1qB1cqAT60MLiKAgAGW8wD//5MXcA==
Date: Tue, 3 May 2022 16:04:40 +0000
Message-ID: <c30f82f1d4544ebb8a15da1f6fc033ac@intel.com>
References: <20220422200219.2843823-1-tony.luck@intel.com>
 <20220428153849.295779-1-tony.luck@intel.com>
 <13054c5c-ed48-b7a2-a800-25b9b1b1ab0d@redhat.com> <YnFK+gXFx0jQB1dz@zn.tnic>
In-Reply-To: <YnFK+gXFx0jQB1dz@zn.tnic>
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

PiBIbW0sIHNvIGxvb2tpbmcgYXQgdGhlIGRpZmZzdGF0IC0gdGhlIG1ham9yaXR5IG9mIHRoYXQg
aXMNCj4gZHJpdmVycy9wbGF0Zm9ybS94ODYvIHNvIEkgZ3Vlc3MgeW91ciB0cmVlIHdvdWxkIGJl
IGJldHRlciBzdWl0ZWQgZm9yDQo+IGl0Li4uDQoNCkNhbiB5b3UgY2hlY2sgdGhhdCBJIGZpeGVk
IHRoZSBpc3N1ZXMgaW4gcGFydCAwMS8xMCB0aGF0IHlvdSByZXBvcnRlZCBpbiB2MyBvZiB0aGlz
DQpzZXJpZXMgYW5kIGdpdmUgYW4gQWNrIHRvIEhhbnM/DQoNCi1Ub255DQo=
