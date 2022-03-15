Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109591B6F
	for <patches@lists.linux.dev>; Tue, 15 Mar 2022 14:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647356347; x=1678892347;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GyNyfKahJzTHsEIBBRJIhFWT/tnEv+2kPDiw/r6E+k4=;
  b=fDCuhfOe8RBBicbiGJ3IJtwK4jzAiv4IylJzUhrKEZn1ke/IGOXAiuzM
   pbYlJVAgQPdWKKmfcpW7Ue4FI0SOU2VrKI/3EISFhKn8JxURaZ5h+Ab3W
   Gl1a1x6JnUJilCHZrsk/NqUb8+nUB8WOztZhHdGe4Jxx72e1TfPfrE0U9
   xlAsO//rRSLTau2dIernYRQ6OTLWICKyEa9jFV+5uf4gwGMqV7eabh21V
   hLPNCT4oN6ITstqtfD/CvrENAeWUvDOie86WoRWLmcbs/BFfYTpB92MRm
   7vYIlIym2Vslp2RExTrHsv4gkynTXm4UAfbgkLkgpnyiDiKHY5EWAtw4t
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="236270165"
X-IronPort-AV: E=Sophos;i="5.90,183,1643702400"; 
   d="scan'208";a="236270165"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2022 07:59:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,183,1643702400"; 
   d="scan'208";a="644286209"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 15 Mar 2022 07:59:06 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 07:59:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Mar 2022 07:59:04 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.021;
 Tue, 15 Mar 2022 07:59:04 -0700
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
Thread-Index: AQHYLaZcmKq0UuRYGU6xp1k7P7vRw6yre5AAgAABJQCAFBlxgIABAjIAgAAEKTA=
Date: Tue, 15 Mar 2022 14:59:03 +0000
Message-ID: <c4af81bd788e43dda915a1052af0be55@intel.com>
References: <20220301195457.21152-1-jithu.joseph@intel.com>
 <Yh59rOIH24X+6GyI@kroah.com> <Yh5+om/Nr06V0+Qj@kroah.com>
 <Yi/Lb5laEki0JHft@agluck-desk3.sc.intel.com> <YjBBmEjbIaqTbVt+@kroah.com>
In-Reply-To: <YjBBmEjbIaqTbVt+@kroah.com>
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

>> This seems a novel use of uevent ... is it OK, or is is abuse?
>
> Don't create "novel" uses of uevents.  They are there to express a
> change in state of a device so that userspace can then go and do
> something with that information.  If that pattern fits here, wonderful.

Maybe Dan will chime in here to better explain his idea. I think for
the case where the core test fails, there is a good match with uevent.
The device (one CPU core) has changed state from "working" to
"untrustworthy". Userspace can do things like: take the logical CPUs
on that core offline, initiate a service call, or in a VMM cluster environm=
ent
migrate work to a different node.

> I doubt you can report "test results" via a uevent in a way that the
> current uevent states and messages would properly convey, but hey, maybe
> I'm wrong.

But here things get a bit sketchy. Reporting "pass", or "didn't complete th=
e test"
isn't a state change.  But it seems like a poor interface if there is no fe=
edback
that the test was run. Using different methods to report pass/fail/incomple=
te
also seems user hostile.

> good luck!
Thanks ... we may need it :-)

-Tony

