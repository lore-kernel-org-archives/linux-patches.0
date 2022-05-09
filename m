Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC2D1FC0
	for <patches@lists.linux.dev>; Mon,  9 May 2022 17:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652115926; x=1683651926;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3scayCu6ID1aDNn8OBm96/lJRF8vjKYB0DQAdtKYOc0=;
  b=UlXWvPtfNxEBOrfzAsXStGt5U5015vkFlMVepKsj3gy0W85lfswwyTt7
   n5BS8vaYZUDQY+E/McO67f6+G/uYipC0aHgvziJNns1eYTj3d4qH3EwnS
   wQWUcrfv/JcpWpI4h4+PKkg9ayv/D6kLXWKlAnySwzmY58Pc13ZVq159U
   zHSEWM6gMlu8DwixgCVTPop4ktKuZRaY2U8SiTRQWyuPNbq7Q5doRQ/Eb
   G2tNhzECUXx1zrry5e2a505+wQWu7NEnkCjiiuhC8g7uR7mtF1WSlTiSz
   2cTD67A+pDKBk7GJCyWX5vn0eQv0pwzonknLkWelFSwcBXmg+kdnXWMnO
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="249646838"
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="249646838"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 10:05:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,211,1647327600"; 
   d="scan'208";a="602054410"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 09 May 2022 10:05:22 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 9 May 2022 10:05:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 9 May 2022 10:05:21 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Mon, 9 May 2022 10:05:21 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Hans de Goede <hdegoede@redhat.com>, Borislav Petkov <bp@alien8.de>
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
Thread-Index: AQHYWxYVdsKdZt61BUSHj1qB1cqAT60MLiKAgAGW8wCABKLQAP//o/BAgAClR4CABCX1EA==
Date: Mon, 9 May 2022 17:05:20 +0000
Message-ID: <05b3c44c62a944f793b66b2e8e8c0cfe@intel.com>
References: <20220422200219.2843823-1-tony.luck@intel.com>
 <20220428153849.295779-1-tony.luck@intel.com>
 <13054c5c-ed48-b7a2-a800-25b9b1b1ab0d@redhat.com> <YnFK+gXFx0jQB1dz@zn.tnic>
 <b18234d7-a1f4-d5a4-e59b-f5439c38c2d0@redhat.com>
 <15cca88b82cd46a3a2a98b7cf336a6ed@intel.com>
 <4fda831b-c132-53cd-cd75-4f46b45219ac@redhat.com>
In-Reply-To: <4fda831b-c132-53cd-cd75-4f46b45219ac@redhat.com>
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

Pj4gRG8geW91IHN0aWxsIHRha2UgcGF0Y2hlcyBhZnRlciAtcmM2Pw0KPg0KPiBJZiB0aGUgcGF0
Y2hlcyBhcmUgc2VuZCBzb29uICgxLTIgZGF5cykgYWZ0ZXIgcmM2IEkgY2FuIHN0aWxsIHRha2Ug
dGhlbS4NCg0KSGFucywNCg0KVjcgd2FzIHBvc3RlZCBGcmlkYXkuIEl0IHN1cnZpdmVkIG15IHdl
ZWtlbmQgdGVzdGluZywgYW5kIGFub3RoZXIgcm91bmQgb2YgdGdseCBzY3J1dGlueSAoZW5kaW5n
IHdpdGgNCmhpcyAiUmV2aWV3ZWQtYnkiIG9uIHRoZSBsYXR0ZXIgcGFydHMgb2YgdGhlIHNlcmll
cy4NCg0KTGV0IG1lIGtub3cgaWYgdGhlcmUgaXMgYW55dGhpbmcgZWxzZSB5b3UgbmVlZCB0byBn
ZXQgdGhlbSBhcHBsaWVkLg0KDQpUaGFua3MNCg0KLVRvbnkNCg==
