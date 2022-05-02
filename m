Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B22D2F2A
	for <patches@lists.linux.dev>; Mon,  2 May 2022 17:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651512216; x=1683048216;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LU179n8muWviqqb25jsmrJha83hqn2FjKhu7EZ5iR2M=;
  b=MPweH+e4JhkJHQ2ct240bWvWRdizj4rRZaIY796PHPVlqM2dpC7UYjvS
   7ZsiHbeWzcqOriwoj4D4l979T7x7+tLG87K4VsVWU7z2m6p2vuNz+MYBh
   gKNFddwKetzSFSUpb+SpspyTJkBR68tPLZcGGGek4us20SWTLImE8bVXh
   NH8vZFuJIf5tX2mFcsKG8CYfOnU6pADxj7OG8kz5XZtk9f27V5E0jzTct
   FlZ7nhjpIyzeUci5iA9gRbt6c/eSEL5oOhjrnWEaDeMOPNnChpO3g3jKA
   1mV10WcVedqt2LbIH9/lioMFdzq9Clqt8Lk42/m+jLg8tumEpbAcIvLfV
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="249254164"
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="249254164"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2022 10:23:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,192,1647327600"; 
   d="scan'208";a="516195920"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 02 May 2022 10:23:35 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 2 May 2022 10:23:35 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 2 May 2022 10:23:34 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Mon, 2 May 2022 10:23:34 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Hans de Goede <hdegoede@redhat.com>, "markgross@kernel.org"
	<markgross@kernel.org>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
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
Thread-Index: AQHYWxYVdsKdZt61BUSHj1qB1cqAT60MLiKA//+uBGA=
Date: Mon, 2 May 2022 17:23:34 +0000
Message-ID: <6171e5bfd1c5402692dca346fc2a5350@intel.com>
References: <20220422200219.2843823-1-tony.luck@intel.com>
 <20220428153849.295779-1-tony.luck@intel.com>
 <13054c5c-ed48-b7a2-a800-25b9b1b1ab0d@redhat.com>
In-Reply-To: <13054c5c-ed48-b7a2-a800-25b9b1b1ab0d@redhat.com>
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

PiBJJ3ZlIHRha2VuIGEgcXVpY2sgbG9vayBhdCB0aGUgZW50aXJlIHNlcmllcyBhbmQgaXQgbG9v
a3MgZ29vZCB0byBtZS4NCj4NCj4gSSdtIGZpbmUgd2l0aCB0aGlzIGVudGlyZSBzZXJpZXMgZ2V0
dGluZyBtZXJnZWQgdGhyb3VnaCB0aGUgVElQDQo+IHRyZWUsIGhlcmUgaXMgbXkgYWNrIGZvciBt
ZXJnaW5nIHRoZSBkcml2ZXJzL3BsYXRmb3JtL3g4NiBiaXRzDQo+IHRocm91Z2ggdGhlIFRJUCB0
cmVlOg0KPg0KPiBBY2tlZC1ieTogSGFucyBkZSBHb2VkZSA8aGRlZ29lZGVAcmVkaGF0LmNvbT4N
Cg0KDQpIYW5zLA0KDQpUaGFua3MgZm9yIGxvb2tpbmcsIGFuZCBkb3VibGUgdGhhbmtzIGZvciB0
aGUgIkFjayIuDQoNCi1Ub255DQoNCg==
