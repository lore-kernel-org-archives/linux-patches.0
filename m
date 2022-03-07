Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079EA4350
	for <patches@lists.linux.dev>; Mon,  7 Mar 2022 21:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646688829; x=1678224829;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=P7fA5VAziyLx4eErnIxNtk976YKxMu7dfIcAeyiLxV0=;
  b=CtRBnAEk995hrpSLj8dkq0b8//iZBcS4hN5Heu9La8xxk/4tW+uY62er
   rmIKDt1Grhv+JE/SjhNmGNdOe00YefpNdEQeKVaSl7g4+6ijBu2q1k9Si
   lLOlVaVFvSgo7+0UGNW/RASGE6LjBoMxSLM8iqu3iYEWHNes7O0Z6wDQQ
   LDPLKsBMMRoB/p3j1sYwuT0tExMXkeVMip3u7KhxoPml5v4t8P4bwfkqM
   vfwZ2qvPVvstaS0gLKbGdsvI5rlwNLjdhN1qo7P82nK7Ht5K2t6UuoGkx
   ouLRXhCrYATESwtgw/vuFvf61qEjrfqD0R3GmnD74NU+ICjrxOomzEQ03
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10279"; a="253341718"
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="253341718"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2022 13:33:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,163,1643702400"; 
   d="scan'208";a="687687259"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 07 Mar 2022 13:33:48 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Mar 2022 13:33:47 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Mar 2022 13:33:46 -0800
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.021;
 Mon, 7 Mar 2022 13:33:46 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "Joseph, Jithu"
	<jithu.joseph@intel.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, "hdegoede@redhat.com"
	<hdegoede@redhat.com>, "markgross@kernel.org" <markgross@kernel.org>,
	"corbet@lwn.net" <corbet@lwn.net>, "Raj, Ashok" <ashok.raj@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "rostedt@goodmis.org"
	<rostedt@goodmis.org>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "bp@alien8.de" <bp@alien8.de>,
	"andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: RE: [RFC 08/10] platform/x86/intel/ifs: Add IFS sysfs interface
Thread-Topic: [RFC 08/10] platform/x86/intel/ifs: Add IFS sysfs interface
Thread-Index: AQHYLaZd5d+yEBuhdEqmhIRDOkET6qyu6T6AgAFSX4CABIOMgIAAGXcAgAABjACAAAs3AIAACG0AgAAIiACAAAmQgP//ejMg
Date: Mon, 7 Mar 2022 21:33:46 +0000
Message-ID: <5129ec667d734f3da4043ce1b7df0439@intel.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <20220301195457.21152-9-jithu.joseph@intel.com>
 <188492dc80c017375da76d444347b1d00c2031f6.camel@intel.com>
 <7b9c788e-21dc-eedc-a1b4-9c6877fa48fe@intel.com>
 <CAPcyv4h=qPFrP+mRqaZhkh5ZmYjuQawsqvf+-R036ZJVKBNK4Q@mail.gmail.com>
 <33d0e764-86d9-8504-17fa-14b31c87de4e@intel.com>
 <CAPcyv4g5bq9+u0iLjhpeJw8bkbCREUw60H2z_KfDz4hHCrKdFQ@mail.gmail.com>
 <7c620f8a-189e-5ac4-30fe-1fa14ba799ea@intel.com>
 <CAPcyv4iUuZ0aAWckWvwbxJJgt5tDJRpeonfE4DegWS6KPtJq8A@mail.gmail.com>
 <eab8177d-eb73-ec64-ec1f-4f2a51be8aee@intel.com> <YiZ5bYPvssUFYGZj@kroah.com>
In-Reply-To: <YiZ5bYPvssUFYGZj@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.401.20
x-originating-ip: [10.1.200.100]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

> > Also some context on test frequency: Hardware has  strict rate limiting=
 of tests.
> > Every core can be tested only once in every 30 minutes. So it is pointl=
ess to test at high frequency.
>
> What limits this, the kernel?

Microcode enforces the per-core repeat rate on the first implementation.

But this limit isn't architectural. Future implementations may not have
the same, or perhaps any, limit.

-Tony
