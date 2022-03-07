Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B657E
	for <patches@lists.linux.dev>; Mon,  7 Mar 2022 17:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646675209; x=1678211209;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MIOZqOY86PC5jyX0VHsiHdfzcdqYJexCZN2Y/A/z7XU=;
  b=go6PYDuLsrsDaxlWDbM/m/1ovLqwXKrKI/4LCQ4dYVWSHxJF6Dl4HyWy
   pikKPUFBE1EMqcHj1+xwwNYfWN4Ljurlw0clk3133mfPMwapQuyuo0J1C
   WrcDku36v3olt/f/xMjegU0sIzNLKL4DySeheEhzA3h4tFPL7JVwKPP1W
   DXfgmhfLujvLuAwslPqgLhCRcy4kw/n478qVanELdOKHjSI+pz7jUkdLT
   wQYWHYAZcijrILy1YqT34Ta8g5TNgCsvThHqhUclGtKyyDF3K25RATRuC
   vqlWEp4wNuhLuK1j4ypSpJgrk9QpIK+3O9CCIcOrNCl9er0lbDOz4HXVF
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="241891284"
X-IronPort-AV: E=Sophos;i="5.90,162,1643702400"; 
   d="scan'208";a="241891284"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 09:46:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,162,1643702400"; 
   d="scan'208";a="610692182"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga004.fm.intel.com with ESMTP; 07 Mar 2022 09:46:48 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Mar 2022 09:46:46 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Mar 2022 09:46:45 -0800
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.021;
 Mon, 7 Mar 2022 09:46:45 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Joseph, Jithu"
	<jithu.joseph@intel.com>
CC: "hdegoede@redhat.com" <hdegoede@redhat.com>, "markgross@kernel.org"
	<markgross@kernel.org>, "corbet@lwn.net" <corbet@lwn.net>, "Raj, Ashok"
	<ashok.raj@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>, "Shankar, Ravi V"
	<ravi.v.shankar@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>, "gregkh@linuxfoundation.org"
	<gregkh@linuxfoundation.org>, "andriy.shevchenko@linux.intel.com"
	<andriy.shevchenko@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: RE: [RFC 07/10] platform/x86/intel/ifs: Create kthreads for online
 cpus for scan test
Thread-Topic: [RFC 07/10] platform/x86/intel/ifs: Create kthreads for online
 cpus for scan test
Thread-Index: AQHYLaZdiIBs/15S5Ua8Iei72+JPkKytlgQAgAKOhgCABI3OgP//h3pg
Date: Mon, 7 Mar 2022 17:46:44 +0000
Message-ID: <1503c7940a7149679025173a46dd0daf@intel.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <20220301195457.21152-8-jithu.joseph@intel.com>
 <09b5b05018a8600ca8fab896790ab16827c80e4e.camel@intel.com>
 <e282377b-8ee4-99fc-432f-2aa3441b2989@intel.com>
 <CAPcyv4gcfMZu38EAGBq59A-RPUmR3fFiamRiR6QaP=D1gPS+6A@mail.gmail.com>
In-Reply-To: <CAPcyv4gcfMZu38EAGBq59A-RPUmR3fFiamRiR6QaP=D1gPS+6A@mail.gmail.com>
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

Pj4gVGhlc2UgYXJlIHNvZnR3YXJlKGRyaXZlcikgZGVmaW5lZCBlcnJvciBjb2Rlcy4gUmVzdCBv
ZiB0aGUgZXJyb3IgY29kZXMgYXJlIHN1cHBsaWVkIGJ5DQo+PiB0aGUgaGFyZHdhcmUuIFNvZnR3
YXJlIGRlZmluZWQgZXJyb3IgY29kZXMgd2VyZSBrZXB0IGF0IHRoZSBvdGhlciBlbmQgdG8gcHJv
dmlkZSBhbXBsZSBzcGFjZQ0KPj4gaW4gY2FzZSAoZnV0dXJlKSBoYXJkd2FyZSBkZWNpZGVzIHRv
IHByb3ZpZGUgZXh0ZW5kIGVycm9yIGNvZGVzLg0KPg0KPiBXaHkgcHV0IHRoZW0gaW4gdGhlIHNh
bWUgbnVtYmVyIHNwYWNlPyBTZXBhcmF0ZSBzb2Z0d2FyZSByZXN1bHRzIGZyb20NCj4gdGhlIHJh
dyBoYXJkd2FyZSByZXN1bHRzIGFuZCBoYXZlIGEgc2VwYXJhdGUgbWVjaGFuaXNtIHRvIGNvbnZl
eSBlYWNoLg0KDQpXZSB3YW50ZWQgdG8gaW5jbHVkZSBpbiB0aGUgImRldGFpbHMiIGZpbGUsIHdo
aWNoIGlzIG90aGVyd2lzZSBhIGRpcmVjdCBjb3B5IG9mDQp0aGUgU0NBTl9TVEFUVVMgTVNSLiBN
YWtpbmcgc3VyZSB0aGUgc29mdHdhcmUgZXJyb3IgY29kZXMgZGlkbid0IG92ZXJsYXANCndpdGgg
YW55IGgvdyBnZW5lcmF0ZWQgY29kZXMgc2VlbWVkIGxpa2UgYSBnb29kIGlkZWEuDQoNCkJ1dCBt
YXliZSB3ZSBzaG91bGQgaGF2ZSBkb25lIHRoaXMgd2l0aCBhZGRpdGlvbmFsIHN0cmluZyB2YWx1
ZXMgaW4gdGhlIHN0YXR1cw0KZmlsZToNCg0KQ3VycmVudDoNCg0KcGFzcw0KdW50ZXN0ZWQNCmZh
aWwNCg0KQWRkIGEgY291cGxlIG9mIG5ldyBvcHRpb25zIGZvciB0aGUgcy93IGNhc2VzOg0KDQpz
d190aW1lb3V0DQpzd19yZXRyaWVzX2V4Y2VlZGVkDQoNCi1Ub255DQoNCg==
