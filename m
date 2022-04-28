Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197661361
	for <patches@lists.linux.dev>; Thu, 28 Apr 2022 16:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651162083; x=1682698083;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ir4T5uqY+GX2tlG/wVzI1xs8T7NLnwE/od0GN7231xQ=;
  b=MpnrB+7g541cU/6FAzre6o1WEcwUIZTMAn6NWO6D+VyktqPUBVDbCeqJ
   yDcm3Xc7rEjgdAKmf0B18AimQRPIq345pagrMaZ3vXosMGQHTf4XhU9+A
   RbhdlVe2pSN6cfs2l1wv8BCE4Izr6SU/7uoSwwP/s1A14D1ECW+Sp9HOX
   D4DIPUyHf6O+5nDy6+jNJU7fjlpVcCG7vlVAAtiFGKj8MvlkWV4bzjA8X
   jCC6NTWWVmv+7Z8jEIkQHOlDYZWIAmjgwTBdDzQu1SQvuhEb8NJKmjTuW
   dg660UICDdt3VxS2ArUOgHXnHSuqBIKAqw+GqvQsKD2dVn0VQ18FqPY8L
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="263924541"
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="263924541"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 09:07:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="651280527"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by FMSMGA003.fm.intel.com with ESMTP; 28 Apr 2022 09:07:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 28 Apr 2022 09:07:46 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 28 Apr 2022 09:07:45 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Thu, 28 Apr 2022 09:07:45 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "hdegoede@redhat.com" <hdegoede@redhat.com>, "markgross@kernel.org"
	<markgross@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "andriy.shevchenko@linux.intel.com"
	<andriy.shevchenko@linux.intel.com>, "Joseph, Jithu"
	<jithu.joseph@intel.com>, "Raj, Ashok" <ashok.raj@intel.com>,
	"rostedt@goodmis.org" <rostedt@goodmis.org>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "platform-driver-x86@vger.kernel.org"
	<platform-driver-x86@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "Shankar, Ravi V" <ravi.v.shankar@intel.com>
Subject: RE: [PATCH v5 00/10] Introduce In Field Scan driver
Thread-Topic: [PATCH v5 00/10] Introduce In Field Scan driver
Thread-Index: AQHYWxYVdsKdZt61BUSHj1qB1cqAT60F8LwA//+M88A=
Date: Thu, 28 Apr 2022 16:07:45 +0000
Message-ID: <08c593c1aecd4131bf9c2558198a2dc1@intel.com>
References: <20220422200219.2843823-1-tony.luck@intel.com>
 <20220428153849.295779-1-tony.luck@intel.com> <Ymq5nH/A9c88wIM/@kroah.com>
In-Reply-To: <Ymq5nH/A9c88wIM/@kroah.com>
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

> Much nicer and simpler as compared to the first version submitted,
> thanks for sticking with it.  The diff seems about 1/3 smaller from the
> first version sent out, peer-review works :)
>=20
> Reviewed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks for your patience leading me to a much better driver.

-Tony

