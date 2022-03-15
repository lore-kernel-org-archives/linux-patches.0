Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D0E23B5
	for <patches@lists.linux.dev>; Tue, 15 Mar 2022 16:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647360709; x=1678896709;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=glOFaMsZQ3qIAkOB+ER/W8hoSjZuYOqUjaQuQNhbfuY=;
  b=SL/gmsvC3XQN7alhw5/PiMVwwcTsXAkBWIvaXtN15gn0BznCOPsaRZVc
   WNgbcIp2XN/jbp8++VGEL9Z5R6l9SXNCbYwrMWfdpVSDCpED5nf/juyhO
   /aKYHDEaE1pdnNU0g6I5T1J2HH21Pu/EX0vADj+YkvUSy1v0C2PofgUiN
   zxA9YxhlrQGRrJ8KPNnf6GWyKuQGl64ENWztPqhaycgxJ7RmPC9r57OQ9
   rGJFnyh7oAo0ySTwLqxnPVd5LLurw7FHtZyztYFYlYhWitX4sn271zWkK
   ygPxi241bG6gVrermsoVpV4usjPmrg42gTDu0pVDa5KffTisFqEhuLRl+
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="256537781"
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="256537781"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 09:11:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,184,1643702400"; 
   d="scan'208";a="540498624"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 15 Mar 2022 09:11:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 09:11:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 09:10:59 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.021;
 Tue, 15 Mar 2022 09:10:59 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "Joseph, Jithu" <jithu.joseph@intel.com>, "hdegoede@redhat.com"
	<hdegoede@redhat.com>, "markgross@kernel.org" <markgross@kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "andriy.shevchenko@linux.intel.com"
	<andriy.shevchenko@linux.intel.com>, "Raj, Ashok" <ashok.raj@intel.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>
Subject: RE: [RFC 00/10] Introduce In Field Scan driver
Thread-Topic: [RFC 00/10] Introduce In Field Scan driver
Thread-Index: AQHYLaZcmKq0UuRYGU6xp1k7P7vRw6yre5AAgAABJQCAFBlxgIABAjIAgAAEKTCAAH+egP//kvKw
Date: Tue, 15 Mar 2022 16:10:59 +0000
Message-ID: <de895b9617aa412e95fdd14fcad285fa@intel.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <Yh59rOIH24X+6GyI@kroah.com> <Yh5+om/Nr06V0+Qj@kroah.com>
 <Yi/Lb5laEki0JHft@agluck-desk3.sc.intel.com> <YjBBmEjbIaqTbVt+@kroah.com>
 <c4af81bd788e43dda915a1052af0be55@intel.com> <YjCwI4N00reBuIqA@kroah.com>
In-Reply-To: <YjCwI4N00reBuIqA@kroah.com>
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

> Again, I have no idea what you are doing at all with this driver, nor
> what you want to do with it.
>
> Start over please.

TL;DR is that silicon ages and some things break that don't have parity/ECC=
 checks.
So systems start behaving erratically. If you are lucky they crash. If you =
are less lucky
they give incorrect results.

There's a paper (and even a movie 11 minutes) that describe the research by
Google on this.
https://sigops.org/s/conferences/hotos/2021/papers/hotos21-s01-hochschild.p=
df =20
(https://www.youtube.com/watch?v=3DQMF3rqhjYuM)   =20

> What is the hardware you have to support?

Feature first available in Sapphire Rapids (Xeon: coming later this year)

> What is the expectation from userspace with regards to using the
> hardware?

Expectation from users is that they can run these tests frequently (many ti=
mes
per day) to catch silicon that has developed faults quickly and take action=
 to
isolate the cores that have issues.

On HT enabled systems both threads that share a core need to be put into
test mode together. The current version of tests takes around 50 milli-seco=
nds
(so for many workloads doesn't need much prep ... those with high sensitivi=
ty
to latency would need to do some additional userspace task binding to make
sure those workloads were moved to another core while the h/w test runs).

There are three outcomes from running a test:

1) The test passes all stages.
2) The test did not complete (for a variety of reasons, e.g. power states)
3) The test indicates failure. Recommendation is to run one more time in ca=
se
    the failure was transient .. e.g. cause by a neutron/alpha strike.

-Tony
