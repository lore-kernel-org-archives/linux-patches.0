Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FAF7E
	for <patches@lists.linux.dev>; Thu,  3 Mar 2022 00:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646265793; x=1677801793;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PXuGfXojzUGtOg6FhOREhI+2NM5us/0wtFa7cTXnUi4=;
  b=IG5SSElcGsAczMXq+93YkeDX9iorgun1qL5HDwTgfyg8nQ0N5F+zWC7Q
   EGf0GUeC8XgVKma/MGBdY9zoF+L3eTOl9kBhJU31h1Ondt3XR/Le0rl4i
   gxd96w75EeK2yM/nuwDW6+j0+TuS9fDKBpDbqG+pIA4GZTAmg5gEUB8Je
   yjXOq0+JWexklAUNoAK88Xu01u9EW/5SGNxfnzstxPzv2DFw5p0BUtEbH
   Kp0cgVO6mPvaHCzKv6zTcgpy8gHxC0qf2rheCwxyXcB3j8REJrP+VZmH2
   oqDIQxe064YxNNDhdQPGeUic3ukn74EtVQBEQUzUlG8x1y2LcAIF6z+qE
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="253464816"
X-IronPort-AV: E=Sophos;i="5.90,150,1643702400"; 
   d="scan'208";a="253464816"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 16:02:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,150,1643702400"; 
   d="scan'208";a="641891445"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 02 Mar 2022 16:02:47 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 16:02:46 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 16:02:45 -0800
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.021;
 Wed, 2 Mar 2022 16:02:45 -0800
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
Subject: RE: [RFC 03/10] platform/x86/intel/ifs: Add driver for In-Field Scan
Thread-Topic: [RFC 03/10] platform/x86/intel/ifs: Add driver for In-Field Scan
Thread-Index: AQHYLaZdi8+klwhBg0WsNZ9Nl1bmr6ytRDmA//+COEA=
Date: Thu, 3 Mar 2022 00:02:45 +0000
Message-ID: <2002880f24ca430ab51e9ca8bb07097d@intel.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
	 <20220301195457.21152-4-jithu.joseph@intel.com>
 <f0e958c612ac4dab30ba458a08a7681e1114668f.camel@intel.com>
In-Reply-To: <f0e958c612ac4dab30ba458a08a7681e1114668f.camel@intel.com>
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

Pj4gK2NvbmZpZyBJTlRFTF9JRlMNCj4+ICsgICAgICAgdHJpc3RhdGUgIkludGVsIEluIEZpZWxk
IFNjYW4iDQo+PiArICAgICAgIGRlcGVuZHMgb24gWDg2ICYmIDY0QklUICYmIFNNUA0KPg0KPiBB
cmUgdGhlcmUgYWN0dWFsIENPTkZJR19TTVAgYW5kIENPTkZJR182NEJJVCBjb21waWxhdGlvbiBk
ZXBlbmRlbmNpZXMNCj4gaW4gdGhpcyBkcml2ZXI/IEl0IGxvb2tzIGxpa2UgdGhpcyBjb3VsZCBj
b21waWxlIHdpdGhvdXQgdGhvc2UgY29uZmlnDQo+IGRlcGVuZGVuY2llcy4NCg0KTWF5YmUgQ09O
RklHX1NNUCBpcyB0aGVyZSBhcyBhIGtpbmRuZXNzIHRvIGtlcm5lbCBidWlsZGluZyByb2JvdHMg
Oi0pDQoNClllcywgeW91IGNhbiBidWlsZCB0aGlzIGZvciBhIFVQIGtlcm5lbCAoSSBqdXN0IGRp
ZCwgYW5kIHRoZXJlIHdlcmUgbm8gYnVpbGQNCmVycm9ycykuIEJ1dCB3aHk/IE5vYm9keSBpcyBn
b2luZyB0byB0YWtlIHRoZWlyIGR1YWwgc29ja2V0IHNlcnZlciB3aXRoIG92ZXINCmEgaHVuZHJl
ZCBsb2dpY2FsIHByb2Nlc3NvcnMgYW5kIHJ1biBhIFVQIGtlcm5lbCBvbiBpdC4NCg0KUHJvYmFi
bHkgZGl0dG8gZm9yIDY0QklULiBJIGRpZG4ndCB0cnkgdGhlIGJ1aWxkIHdpdGhvdXQgdGhhdC4g
QnV0IG1pbmltdW0NCm1lbW9yeSBvbiB0aGVzZSBzeXN0ZW1zIGlzIGxhcmdlciB0aGFuIHN1cHBv
cnRlZCBieSAzMi1iaXQga2VybmVscy4NCg0KLVRvbnkNCg==
