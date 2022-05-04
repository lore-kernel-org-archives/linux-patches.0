Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1653E2583
	for <patches@lists.linux.dev>; Wed,  4 May 2022 16:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651681493; x=1683217493;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lIZS8L9hUURotYWnPIQEjJsG5uiWV1waq7GDXPVIqcc=;
  b=m+6/cN4JZGl3T5idmrmIxVq/wy4wdhYjhQNT+Lv4Tvzgja7sKOXM4NzY
   azfFR5PeGYYfeiE1MjGTx7rorDBUPiNsaFj0YLHRwgxWbbxdu71eMMySF
   2ExssG6MntGXVX2elBwLkBrU7oJVNE/TMhbWcaCgBkqf+Z4XBnHh2IHlq
   wrZHuU4rCExvH1kYP4nt/MkZnS9ZtotRJVjfSVvjCxGtM/P8PAcP1kiq+
   FTiVtrgf/Jf9ejgSYqV6fv5wHfak+IdOHoc3nDkRorPrTe3CESxDjLYrp
   TenlIRCzZHEY3VMhiL9BzZpHVSxfv3BtqjiMuJIqV5bMtPm7oP7Ylt2Hw
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10337"; a="248354759"
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="248354759"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2022 09:24:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,198,1647327600"; 
   d="scan'208";a="599597736"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by orsmga001.jf.intel.com with ESMTP; 04 May 2022 09:24:51 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 4 May 2022 09:24:51 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 4 May 2022 09:24:50 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Wed, 4 May 2022 09:24:50 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "hdegoede@redhat.com"
	<hdegoede@redhat.com>, "markgross@kernel.org" <markgross@kernel.org>
CC: "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
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
Subject: RE: [PATCH v5 03/10] platform/x86/intel/ifs: Add stub driver for
 In-Field Scan
Thread-Topic: [PATCH v5 03/10] platform/x86/intel/ifs: Add stub driver for
 In-Field Scan
Thread-Index: AQHYWxYWmJjf7gsCY0aglBAPDxFRY60PBIYA///pJDA=
Date: Wed, 4 May 2022 16:24:50 +0000
Message-ID: <eedc3fa9ec47494590be66ad66f90bb7@intel.com>
References: <20220422200219.2843823-1-tony.luck@intel.com>
 <20220428153849.295779-1-tony.luck@intel.com>
 <20220428153849.295779-4-tony.luck@intel.com> <87zgjxk2kt.ffs@tglx>
In-Reply-To: <87zgjxk2kt.ffs@tglx>
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

>> +static const struct x86_cpu_id ifs_cpu_ids[] __initconst =3D {
>> +	X86_MATCH(SAPPHIRERAPIDS_X),
>
> Why do we need a model match here? The core capabilities MSR is only
> available when X86_FEATURE_CORE_CAPABILITIES is set:
>
>    "If CPUID.(EAX=3D07H, ECX=3D0):EDX[30] =3D 1.
>     This MSR provides an architectural enumeration
>     function for model-specific behavior."
>
> So checking for Intel Fam6 ANYMODEL and X86_FEATURE_CORE_CAPABILITIES is
> sufficient, no?

IA32_CORE_CAPABILITES is a nightmare. Although it is an architectural
register, the bits inside it are model specific.

In particular bit 2 (which we check here for the existence of the INTEGRITY
MSR) has been assigned for other use on other models. See SDM volume 4
table 2-45 where bit 2 means FUSA supported on 06_8C and 06_8D (Tigerlake
mobile and desktop). Ditto in table 2-46 (Alderlake and Raptorlake).

> We really don't need more match id tables with gazillions of CPU models.

Sadly we do :-(

-Tony
