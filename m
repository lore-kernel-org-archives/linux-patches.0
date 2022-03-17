Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC9B4378
	for <patches@lists.linux.dev>; Thu, 17 Mar 2022 16:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647534464; x=1679070464;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jgqA4epx8T6t7aXhyfOU+Wo7m6KRfTHcYD7JaGjzZ14=;
  b=cNKH0yq6XIgNZBY455m98i4ei4aB6H46iBDIZSQxUVEwxolgPWfEnwhO
   UpD+5wTKAsY0kvwt0kCoSy1gYiiGK+4JrprYtnci8VkUf6kn9UQsl5M4J
   88A6Gx+eydjc8fH73ztYITGYEchBg1r0QeEhgtQFaZ2bJeuPCSTiCDgXT
   GGDBVHlGQjAK+Nto9vEeUlFxnHnN4PO+vjUWkNNrMAvQrtnOXdzqJGHKN
   LMSMMt/JayW4gPduAR5jCmFCiZUcZ/7eQrnoLLOF6EisEB8bxLIgkH5wr
   f2vVJ31nVS/Cj2HxNyzzYaMb4PrC5e7UjMcwQZ/9yvVL63pzNKXiA1Gw+
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="343342707"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="343342707"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 09:27:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="498888450"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga003.jf.intel.com with ESMTP; 17 Mar 2022 09:27:42 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Mar 2022 09:27:42 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Mar 2022 09:27:42 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.021;
 Thu, 17 Mar 2022 09:27:42 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Pavel Machek <pavel@denx.de>
CC: Thomas Gleixner <tglx@linutronix.de>, "Yu, Fenghua"
	<fenghua.yu@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v2 1/2] x86/split_lock: Make life miserable for split
 lockers
Thread-Topic: [PATCH v2 1/2] x86/split_lock: Make life miserable for split
 lockers
Thread-Index: AQHYNMBHgmgs1nbay0qYe8hPygXs9azD68qA///go9A=
Date: Thu, 17 Mar 2022 16:27:41 +0000
Message-ID: <532e45aad7c64349b52217bc548edaca@intel.com>
References: <20220217012721.9694-1-tony.luck@intel.com>
 <20220310204854.31752-1-tony.luck@intel.com>
 <20220310204854.31752-2-tony.luck@intel.com> <20220317111305.GB2237@amd>
In-Reply-To: <20220317111305.GB2237@amd>
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

Pavel,

> I'm not sure what split locks are, and if you want applications to
> stop doing that maybe documentation would help.

See existing Documentation/x86/buslock.rst

> Anyway, you can't really introduce regressions to userspace to "get
> stuff fixed" in applications.

Applications can inflict pain on the system with atomic operations
on unaligned operands that cross cache line boundaries. This
is just pushing some pain back to the applications.

An alternate title for this patch series could have been:

	"Split-locks: The OS strikes back"

Note that there are few applications that actually split locks.
Normal compiler alignment rules generally avoid them.
Applications that run on non-x86 architectures have to
avoid them because few others allow atomic operations
on unaligned operands.

-Tony
