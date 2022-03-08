Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A3F4AA8
	for <patches@lists.linux.dev>; Tue,  8 Mar 2022 17:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646759555; x=1678295555;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=05og3bG3fwVmDMyEU+pQHSfX1B6HIrys12euCU98SW0=;
  b=nxhGMoaX9KwhZIpphpHKoktRMduS0lSZAenrRSQW6mePwsy2IGmAqt2t
   c6bSptvznHxVgR6GJPiklKouQwqEVanoJoWpFeJeK3NdLQzNx0SWIFKPs
   pSK2CMCKe0cW9znCBWoam0X8msJ2hpdcBN/A58BMGGMnBN3OTdz0E3b8K
   xc4m+JFC6z93uGMRZjeKZ0RJAQMHNWT4LBquLqIR50Z8f8FXTHDuhB8pu
   YG+K0AStLM1vHXJw8KiGD6a/yzqwsoEyOOIap41/Zsp0Jc2nXWpQvULMj
   c1VwSgbVA1k3xplQNuibcXaMoowR7+roxN82CCz8A/iCZo/Bh78TIYEfP
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="234698388"
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="234698388"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2022 09:12:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,165,1643702400"; 
   d="scan'208";a="578060557"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 08 Mar 2022 09:12:34 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 09:12:33 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 8 Mar 2022 09:12:33 -0800
Received: from fmsmsx610.amr.corp.intel.com ([10.18.126.90]) by
 fmsmsx610.amr.corp.intel.com ([10.18.126.90]) with mapi id 15.01.2308.021;
 Tue, 8 Mar 2022 09:12:33 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH] x86/split_lock: Make life miserable for split lockers
Thread-Topic: [PATCH] x86/split_lock: Make life miserable for split lockers
Thread-Index: AQHYI52JusZbuGFIckyHL7QBBN4/aay1JM6A//+ddgCAAXbhgP//nlcg
Date: Tue, 8 Mar 2022 17:12:33 +0000
Message-ID: <fce8ed8b5ea94cdfa265e5dca01e0c11@intel.com>
References: <20220217012721.9694-1-tony.luck@intel.com> <877d95l7jo.ffs@tglx>
 <YialXwpbED5kAUaZ@agluck-desk3.sc.intel.com> <87mti0jxr8.ffs@tglx>
In-Reply-To: <87mti0jxr8.ffs@tglx>
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

> I still do not like the inconsistent state between the TIF flag and the
> SLD MSR.

If I'm updating the "warn" option to work this way, I think I can make the =
TIF flag
and the code that updates the MSR in context switch go away. But need to wo=
rk
though the patch to make sure I'm not missing something.

-Tony

