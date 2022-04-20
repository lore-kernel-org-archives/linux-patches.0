Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505A31867
	for <patches@lists.linux.dev>; Wed, 20 Apr 2022 18:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650478107; x=1682014107;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=r82xGPoK3ahf1ghSuP5NKUG1BQLSZ7HM9W5TELKA3TA=;
  b=Gyx9YdO42MVGihRJ4g5jSleDVdB3IsLOFP5H9bQVVMQdOYJrxrSYM2xB
   q5la0mJGWpSWVhnvGGHWEpaN5s4L1AAYq2ufUYX4B+B0BkbOdmGJ5TS30
   QEbICsfwKfu6pyXaG8i+5GEZVyqhvNh9aeX3bhmTMVZWKwrR77EouLAqp
   hNZ/LNo1te5o5Yq6I1n3mXhQ6Fsrq6/g0+5iFaG/AqXHAvIyC4tdwXnIS
   sIaIUrx/GbBtL6pRv75y1oXayb/FUK/obdKIgZ4q5vloSU6aTyiJf97Gj
   9taRiE2IJzXFbdoi2ZXGLXfVgBlDfSgfrmaxp4jhT1ANMSK8lkaSHYU8X
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="264288358"
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="264288358"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2022 11:08:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,276,1643702400"; 
   d="scan'208";a="626162563"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga004.fm.intel.com with ESMTP; 20 Apr 2022 11:08:21 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 20 Apr 2022 11:08:21 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 20 Apr 2022 11:08:20 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Wed, 20 Apr 2022 11:08:20 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "Williams, Dan J" <dan.j.williams@intel.com>, Hans de Goede
	<hdegoede@redhat.com>, "markgross@kernel.org" <markgross@kernel.org>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, X86 ML
	<x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet
	<corbet@lwn.net>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Joseph, Jithu" <jithu.joseph@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, Linux Doc Mailing List
	<linux-doc@vger.kernel.org>, "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v3 03/11] platform/x86/intel/ifs: Create device for Intel
 IFS (In Field Scan)
Thread-Topic: [PATCH v3 03/11] platform/x86/intel/ifs: Create device for Intel
 IFS (In Field Scan)
Thread-Index: AQHYVAv92LA3gQ6+7UWRqBVIgiQr06z355WAgAAWzYCAAOUNAIAACuQAgACb+YD//4u7sIAAeViA//+LFxA=
Date: Wed, 20 Apr 2022 18:08:20 +0000
Message-ID: <cf53a8fa1e4e4c6885810ee8e4785b79@intel.com>
References: <20220407191347.9681-1-jithu.joseph@intel.com>
 <20220419163859.2228874-1-tony.luck@intel.com>
 <20220419163859.2228874-4-tony.luck@intel.com> <Yl7npfrVTPFEIivC@kroah.com>
 <CAPcyv4jzscs3Dg4QN0+XHRYdekBeqy1=dRX-mWCj1OXo8jS2vQ@mail.gmail.com>
 <Yl+66oyQhI0AkEDC@kroah.com> <YmAmebezoc8m6n2E@agluck-desk3.sc.intel.com>
 <YmBG44t4dYsUl4Aa@kroah.com> <578be5d8874f4942a58adf5f64c4e817@intel.com>
 <YmBLJf8JQkfSQGvA@kroah.com>
In-Reply-To: <YmBLJf8JQkfSQGvA@kroah.com>
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

>> Or is it ok for them all to sit at the top level of /sys/devices/virtual=
?
>
> How many do you have?
>
> And why is a directory needed for just one tiny driver type?

One today. Two tomorrow (internally ... next gen CPU).

Three eventually (That's how many are on the roadmap that I can see).

-Tony
