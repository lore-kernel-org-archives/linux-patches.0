Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DC71FC0
	for <patches@lists.linux.dev>; Mon,  9 May 2022 16:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652115118; x=1683651118;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZHf1aKrJPNEzW3CkgiZfux0Tgdcjxu6YIMeTHM4FNg8=;
  b=HqvzycxNJqhIv5kTYJJ6RtMy19OoAc83bCoeTFfdE5XW7nWOZQY2P95y
   j8puy348guhBTWS4ZcKRqgdwCS13mImhZ+JTVN0YgIHkkknHTyCDYGexU
   sRbfkTnqEog8r1WiS5WXLn3EToKkqilAqFq3868hQ3ThYvibgNszyeh1d
   TtfKWi8tW7nnyM7i5+a5/tHlfIJf7gwJeS49tTZx0WGt0HHRYbgy3Xqbc
   IjJPzakSSLcbC37/m2MOvC9taUCyLbqGdjUPxhzY6sDS+C+3z8uk5DYR1
   KZzRLZDcn0+cJHYjE5lnQA4yGh6rBcvoByaRidf5s0E3bUD41jk/YhysE
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="332142906"
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="332142906"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 09:51:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="710610178"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 09 May 2022 09:51:57 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 9 May 2022 09:51:57 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 9 May 2022 09:51:57 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Mon, 9 May 2022 09:51:57 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: "hdegoede@redhat.com" <hdegoede@redhat.com>, "markgross@kernel.org"
	<markgross@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
	"Joseph, Jithu" <jithu.joseph@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v7 06/12] platform/x86/intel/ifs: Check IFS Image sanity
Thread-Topic: [PATCH v7 06/12] platform/x86/intel/ifs: Check IFS Image sanity
Thread-Index: AQHYYZw4URI4jEBNME2Pw/7vY15Q9K0XNqMA//+PpSA=
Date: Mon, 9 May 2022 16:51:56 +0000
Message-ID: <ddd29688b88b4176957ef5dd8731d90a@intel.com>
References: <20220506014035.1173578-1-tony.luck@intel.com>
 <20220506225410.1652287-1-tony.luck@intel.com>
 <20220506225410.1652287-7-tony.luck@intel.com> <YnlB6iAp4fjM0Cw9@zn.tnic>
In-Reply-To: <YnlB6iAp4fjM0Cw9@zn.tnic>
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

PiBJcyB0aGUgY2hlY2tzdW0gdGhlIG9ubHkgcHJvdGVjdGlvbiBhZ2FpbnN0IHBlb3BsZSBsb2Fk
aW5nIGFyYml0cmFyeSBJRlMNCj4gaW1hZ2VzIG9yIGFyZSB0aG9zZSB0aGluZ3Mgc2lnbmVkIG9y
IGVuY3J5cHRlZCwganVzdCBsaWtlIHRoZSBtaWNyb2NvZGU/DQo+DQo+IEknZCBob3BlIHRoZXkg
cGFzcyB0aGUgc2FtZSBjaGVja3MgYXMgbWljcm9jb2RlLCB3aGVuIHRoZXkgZ2V0IGxvYWRlZCwN
Cj4gY29uc2lkZXJpbmcgdGhlIHNpbWlsYXJpdHkgb2YgaG93IHRoZXkncmUgaGFuZGxlZC4uLg0K
DQpUaGUgY2hlY2tzdW0gaXMganVzdCBhICJkaWQgdGhpcyBmaWxlIGdldCBjb3JydXB0ZWQgY2hl
Y2siLiBUaGUgZmlsZSBjb250YWlucw0KU0hBMjU2IGNoZWNrc3VtcyBmb3IgZWFjaCBvZiB0aGUg
Y2h1bmtzLiBUaGVzZSBjaGVja3N1bXMgYXJlIGRpZ2l0YWxseQ0Kc2lnbmVkLiBDaGVja2luZyBv
ZiB0aGVzZSBpcyBkb25lIGJ5IG1pY3JvY29kZSB3aGVuIHRoZSBmaWxlIGlzIGxvYWRlZCBpbnRv
DQpCSU9TIHJlc2VydmVkIG1lbW9yeSAod2hlcmUgaXQgaXMgaW5hY2Nlc3NpYmxlIHRvIE9TIGFu
ZCBJL08pLg0KDQotVG9ueQ0K
