Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B3D6136
	for <patches@lists.linux.dev>; Wed,  2 Mar 2022 21:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646257317; x=1677793317;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tICJn7O0frWHzJ+wfRZLQugK3cqy6m5DqqQk0iFZOIE=;
  b=fLXHlNzIcG1wfnYsGuUmghj/0F+DLkXGmWUax2zUzLW5VeIzKLHUvYsN
   LrSi3pNrKq5BY/gXuw+NQqneM8cSdgOVlLw7mHmboQQeJsaQeEWes6tK9
   GiYXE/Lz32Pfu4Hv5130GNE7aUlJlMoK6tZ2QMLAOPa1UUIWcuCDtJYGB
   GIvo64yfWPoPioqy9RnuhsmhNwTCydToNyL+Y2hzBBJRTqzoFVJl7HM/1
   yTGaJjz/iDV0zc8YAkNE6kCll1DIL9rvZ4CT+rhwfX0bt2ElWuSdKyImO
   Pp76dmwF4CiA/vWnUQOzu1iqlgZVRw9GO93EAVieWs0byvBsN3LuwUVFk
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10274"; a="314230117"
X-IronPort-AV: E=Sophos;i="5.90,150,1643702400"; 
   d="scan'208";a="314230117"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2022 13:41:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,150,1643702400"; 
   d="scan'208";a="576255809"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 02 Mar 2022 13:41:56 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 13:41:55 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Wed, 2 Mar 2022 13:41:55 -0800
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.021;
 Wed, 2 Mar 2022 13:41:55 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Andy Lutomirski <luto@kernel.org>
CC: "Joseph, Jithu" <jithu.joseph@intel.com>, "hdegoede@redhat.com"
	<hdegoede@redhat.com>, "markgross@kernel.org" <markgross@kernel.org>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "the
 arch/x86 maintainers" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, "Raj, Ashok" <ashok.raj@intel.com>,
	Steven Rostedt <rostedt@goodmis.org>, Linux Kernel Mailing List
	<linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [RFC 00/10] Introduce In Field Scan driver
Thread-Topic: [RFC 00/10] Introduce In Field Scan driver
Thread-Index: AQHYLaZcmKq0UuRYGU6xp1k7P7vRw6yspmuA///mywCAAJPCgP//faKA
Date: Wed, 2 Mar 2022 21:41:55 +0000
Message-ID: <f927a309de734c50a5ea8e62077e9e30@intel.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <1b793ead-a47c-4719-b7b5-cba7d49633f2@www.fastmail.com>
 <Yh/Tt50Y8ubGNwS6@agluck-desk3.sc.intel.com>
 <bdc14f77-98e0-4af8-9bef-5dd3d41f22c2@www.fastmail.com>
In-Reply-To: <bdc14f77-98e0-4af8-9bef-5dd3d41f22c2@www.fastmail.com>
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

> How does this work?  Is there an Intel IFS blob v1.17 that is expected
> to be *the* blob for a given CPU until an update happens?

This is the model. Although internally the blob is divided into chunks
that can be run separately, folks outside Intel have no visibility into
which chunk tests which circuits (even *inside* ... I don't know what
each chunk does :-) )

How often will updates occur? No idea. Since this is new, I'd expect
that there might be some improvements when there is feedback from
large CSPs running on many more systems than we have.

>  Or is the
> expectation that several different blobs might all useful on the same
> system and operators might want to run different blobs under different
> circumstances?

One of our early implementations included extra sysfs hooks to only
test specific chunks ... but we dropped that complexity as there's no
way for end users to decide which chunks to run.

So the posted series just iterates all chunks for a core.

-Tony

