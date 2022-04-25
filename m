Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3620333DE
	for <patches@lists.linux.dev>; Mon, 25 Apr 2022 22:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650927400; x=1682463400;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ED/M6gunqGqtqPcX2JL1MS5E+6aZpSysFeyzL8nmuak=;
  b=PvdRdccY7IPxitaLZ+MuaYmROhLmZvSLbgikhQ+slWeMb/hdIH10kPHC
   /t6ytJFGRZQlj99T3nyVXxfzABHK99gdVxmKmz4WuK7x6aacy8JJL6Yg8
   DKnvw+K/dCEC3C4ynF7Hk4PnZlqoO/+sgGoROpyMq3oHd3PMkczaHsaOQ
   KV2Y4F2KqeShFD7BSLgD/RXTD87+9IWFyeT1Bg24EohvlITKLSm91x/R5
   bCEdxK7JVaLYjj7kVk38g1DJ3/IiYzwAra0wvGwRqcKHMqfqEDGwEXEVZ
   4IG2ohMzDv2a4mdwT33QRz2dDVCVjJXbigamfg7BDnwGF/Ho42NsaYLJh
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="247314429"
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="247314429"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 15:56:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="677530009"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga004.jf.intel.com with ESMTP; 25 Apr 2022 15:56:39 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 25 Apr 2022 15:56:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 25 Apr 2022 15:56:38 -0700
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.027;
 Mon, 25 Apr 2022 15:56:38 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Borislav Petkov <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>, Smita Koralahalli Channabasappa
	<smita.koralahallichannabasappa@amd.com>, Wei Huang <wei.huang2@amd.com>, Tom
 Lendacky <thomas.lendacky@amd.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH] topology/sysfs: Hide PPIN on systems that do not support
 it.
Thread-Topic: [PATCH] topology/sysfs: Hide PPIN on systems that do not support
 it.
Thread-Index: AQHYSgHuySQXf0KA6k2XiES1Q5bhWK0BzeAA//+NOpA=
Date: Mon, 25 Apr 2022 22:56:38 +0000
Message-ID: <f7cb74f128e34b67999ba87a21897f70@intel.com>
References: <Yfhbj7Q99dqRIYaL@zn.tnic>
	<20220406220150.63855-1-tony.luck@intel.com>
 <20220425154616.a0e38aea35649d13d5afb5d4@linux-foundation.org>
In-Reply-To: <20220425154616.a0e38aea35649d13d5afb5d4@linux-foundation.org>
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

> I suggest this be fixed in the topology_ppin() stub implementation.  Do
> it as a nice inlined C function which avoids such problems.  Rather
> than as a crappy macro which causes them...

Greg already fixed this in his tree by dropping the local variable.

Fix should propagate to linux-next today.

-Tony

