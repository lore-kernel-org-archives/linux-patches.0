Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0B72E5B02
	for <patches@lists.linux.dev>; Thu,  7 May 2026 03:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778125336; cv=fail; b=TcyzaEr5XgSJUTCbn8HgXjhh3PkL7j+AwFwOrP5vphEgf2OYcqoYys1dvwr86hdnNLfZZFWERamd+WxKYuYTc8+SIjcRUYe+cxPXx6wGUZXLYtqmOJfd1av2PU1wM38aSrOXkDz7NBeICuJ3+jsHCYC9wd2Camm8ULpIqKFhW7I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778125336; c=relaxed/simple;
	bh=DDyxsvhLbJj96u7i/fNWfHybXU7SK7ImNJTi5cDu9dc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YgxmZuUHY9/po8mNYa8/znNGrqMgWaPpyIjNrNocChB/Vu2gYhFKTPfSxQxhmNIQbu8vZO5veXEx7FsnxKKi3htTJUvBVzeOKKpysU6brA9x/fbkZYbm/3mbmxMx+gqKLaleHtNnlP8FGfgEs7+m8uUty0u4FHqTvfT+wC/Rl3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CTb6b0/+; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CTb6b0/+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778125335; x=1809661335;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DDyxsvhLbJj96u7i/fNWfHybXU7SK7ImNJTi5cDu9dc=;
  b=CTb6b0/+Zug7ZPJYFopz8mIHTYLAaLODjoCp2dmpafQ3PZN71dM+MCV6
   5bIh+mvQSCWW21mr8G8Cz5bAUczsSEHOTM+BMJINwT0e4tFdApWF4qXIc
   WMBsIbPh7sAt24Sxs1grzV9l54Abmsadnyfy94MAjrurw5ZymiiHFerYM
   PXxvufNFdERT6ttq7t5D/nx60FVR3SXsqlu8rqOIUDs3nQODSe+r8arzT
   Wj9IK4NCJWpcqyaK7I7MjUU4Z2eK/sE7IpSMZ9YF5d4ZgPea3ig42JCFy
   thxm/KSGBjS1zgeYZZt7ZuRwOAlECWhLbPZU6wXcPVpNpLi5zfXVV+XxW
   A==;
X-CSE-ConnectionGUID: vrL2wZRETwanmglaOBuaxw==
X-CSE-MsgGUID: KfMUmki5R5OuioJOm1O63w==
X-IronPort-AV: E=McAfee;i="6800,10657,11778"; a="79248170"
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="79248170"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 20:42:14 -0700
X-CSE-ConnectionGUID: F8mn9rAuS5a/bBSAjLR87A==
X-CSE-MsgGUID: i8lFrSdsQNu1S8jUiNPFZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="266718198"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 20:42:13 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 20:42:13 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 6 May 2026 20:42:13 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.16) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 20:42:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Cu1DBfGUbE5AgZQ2kI7qzPqYPe78DKXQDuovrq8a8AYRw3WsE+tKTHDzhVLm8tHEkeLQgprJetoJZv9fv+9/TUheuTJ5r/Nl63zZSd4LVy3z8jN7m9ZY7rfkinQLLGSgEWPhnJhL3P471MK9QcuhKZeTEwcbQLdFORthSqIonaivTlSZrEPA0STdtDJntuenvPYGyw5XX5XIaqbb+OB5VUOHOUFkcGAMWqUjc2VVbD974Tcn4Cq2rcPU+39+rHMUI/l5QEbSF5OdgsbxCossWhLwuV/vjrcgWdft3v0kzmo8sdPsYDkr9haoNw9zCjsd4xJiWccLQHBwQnFNYBfQYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BqnwMGbDCLNiAP7TJoH4PL+mtJYjVuQuAUav2tk6f7Y=;
 b=bZjptKUuE0n2iWuxl4EgpPqxySNsSFOQ5VC47Oj7v5nCgCKOv6OQmKc76ZEtXNVTSLNr0XmyrUugg+Ube2T18wAddZj2VXBRSfikUBN6n3Ssuefm3TaUGtKPYbdVibgcmKnYaxU8NQWiEvPKMtF+RvKQHhzO3gBu+hsNFj48P/XwgWNAmHSZuNpnAWoXdTyUn/TAho3UdiaHr0irklRjSrA50iQUd3bJjdXgrJarJkXXjZAleHmP7yN9Rp+YOUdZdSniyMFJn5Lqoh49VMwKPTP4wf/ggzVTy+VT2RKVb689aR+sKmFFNFY72PF/R54uViTJZpojslqKByxRmB1kpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH8PR11MB9976.namprd11.prod.outlook.com (2603:10b6:510:3d5::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.17; Thu, 7 May
 2026 03:42:11 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9891.015; Thu, 7 May 2026
 03:42:11 +0000
Message-ID: <528caf7e-b548-4e80-9ec2-70697073a14d@intel.com>
Date: Wed, 6 May 2026 20:42:09 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Fix use-after-free in
 resctrl_offline_mon_domain()
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
	"Fenghua Yu" <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <20260501213611.25600-1-tony.luck@intel.com>
 <2236fae5-7e66-43fb-ba05-76fd4434e2c9@intel.com>
 <afkizhrSwJkiLD3j@agluck-desk3>
 <3f13c7e4-3812-447d-8c42-b28fd6b9d0fa@intel.com>
 <afoesuWB8RezVLrN@agluck-desk3>
 <7fad1d7d-c892-416e-b97a-a230fd43f2a4@intel.com>
 <afp4OkwtPpyIwAC1@agluck-desk3>
 <d065f7b7-daac-4e45-b7c9-69175dfb43a7@intel.com>
 <afubI4kYrdWUXGUR@agluck-desk3>
 <217d306e-78dd-4762-8c82-88d6bab9de44@intel.com>
 <SJ1PR11MB608334A68F7E79E6AF3C324FFC3F2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <198e6dc2-b57e-4117-a71f-5c3983da3ed8@intel.com>
 <SJ1PR11MB608396D4D57AD6C1E079A4B7FC3F2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <SJ1PR11MB608396D4D57AD6C1E079A4B7FC3F2@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0107.namprd03.prod.outlook.com
 (2603:10b6:303:b7::22) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH8PR11MB9976:EE_
X-MS-Office365-Filtering-Correlation-Id: afa79207-665d-4177-7f53-08deabea9f3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: MbZ4oDhropOWSUzb8ePfBvurjvN6RIF4y3nuU0nYMtrIMu7irTaIftvS307w3cQCAoGNoSeQPLRsE8+IHM2675XYIA+yp8Ewk8vnSBjo3/vbT5PxvQyVntsBCre2qLp9PpRoVP93YFvMA5nScYKP/P+wRHytrFx0WeaMd3pBttsMftmJqadEFcoL3PmiMwO/0n3RyVrprsgfrEMoDaoTWoFaLpqLsCiE1esfJAoMUbE/S9ZElw7C8HYIaeEGmOVYIgl/ZrYiHTUfqXy5ZCLVAaJictph81dqwXA8L3w8p2VPLXjO1k+M8IEzKElwx6uZptUYMkwn9VlMZm6IcyZQ/WKjqQcIMFSNebInxMY06tF2HK9Rm8hH+SSWIIALFmCWxKhOzIkJprErXFRhXLltlWTn9jDfVSEj4ppsk9QNl2xucufUIuRh/rQNB31cgXWgqZ4hANEd6iCNOp4E4FvConP515IJnZBOdRgu5ErWC88p6MH/KKUmDkbVHyNX99cXCdwNjjfRiTMG24YTdgTaPslFNk69i5/HL1hG1fsf00d7vm//dfg+txVhiNpv1rO3AC4ZOMKqo1asOU/FXRWu3lYIdma9w4ScABk8MnohgVfFR1kU9I0mVUuT+qitkUeCqnvJH+Zs/nMrV2j2oMR+gLgKIBVCjtgNJwlPzvhwCqgFFOL3Q4yU2X/JLg1uLh3W2lSPWBbFJFCdKxYYdoAqUA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTU2eTl4UVNtV2NKZEZYcndheDQ4b0k3anJILzJBUzN0bUx2UFMwd1BnL1U1?=
 =?utf-8?B?REJlc0dWNVBLeGNSSy8yWVFORTlqbWRaanE5STBmdWJlYldsYjlXU0FscDQx?=
 =?utf-8?B?NVBKUVp1Z3hlckk3SmNMQ0owejV2WmpPUmFsSkFpOXUveFViTFgrTzFlTlg2?=
 =?utf-8?B?ZmN0MThsbENtelRMZlNOdzdNS2lWakRlWW04aGVpN1IrTUlvVUYySE0wb3Yv?=
 =?utf-8?B?QTNsWDZNS1NOOG9OcEhBTmY3b1RIaUNLZGcrWXNpWWtBeE9pQjdTQ3lhU2Ry?=
 =?utf-8?B?Z3hGYWdzc3lVdEdCLzZmc1B5TU16Tk5NMW5DazdZN3B4Y29wYklGY3pYYnRX?=
 =?utf-8?B?b1R5Vm84aERwT1hibmVCM2phWktoUkZ6UlRPS3pCOTRHK2Y4eENIb1E1ZTB6?=
 =?utf-8?B?aVdOQis0bmRHcXV2K1BENWVGbHNFZnFXMkEvWDhXSHVGYmpYeElKZGI2Um5E?=
 =?utf-8?B?eTlhbVNjYmRGbTN0cnJYaE92N1l3bzFyemFITHpudU1JbkhlRks3RGhHVHpM?=
 =?utf-8?B?bXJjWU9zM3hyTERRMGc0RExBYTZONWdVWXNFUDYxRDA0eERwYmtSOUxEZkN1?=
 =?utf-8?B?REVHQ1dLTTNQaUZzaDZqQmhyblJROTJpQWc3T1FZbG5LT1V0N3Axcm4vV3dW?=
 =?utf-8?B?cjBYVHdiNXlzRXVpT2t0czI3eDkwM2wvTCtQbkozN0lLejJDdmZ1dVc5U2VW?=
 =?utf-8?B?UGk1WE5TbHhpYjFldzF3bkF3NmJDOXh1TDBZY0RhdnllNG9rWi9xMG1nK1k5?=
 =?utf-8?B?cmJLTEtJVVg5WTZoam9TNmQ5OUtnZ2Z6VU95VHYvakJRYklLUkFYSWZMMjFB?=
 =?utf-8?B?czg0UlJJOWtiY0I3MVd5MUZjSTBseTl0UkxCTGFEQU1UOFo2K0l0RHRkZmp0?=
 =?utf-8?B?WGZWcHVpRlVSTUhKZWxBejNuTXNHQ1Bhd2FKVGdnY2JZLy96MWE0MWZxMjVD?=
 =?utf-8?B?U3JQK3Y0V1c5UVM1RGNxbDVNWEpHdWxVazQwdHVzM1hGbFVBMzdxaXV2V0Zw?=
 =?utf-8?B?Q0k4akZvU094S2pieXlTL21rN0FQUXZvemVvK3NudDlsT2tTbHhpZEg5OUFR?=
 =?utf-8?B?Vk81Q0NpT25VUnJSWW5abVZ2eEM1RVFRS3BsaTRtNWZ0cXJtODgwVFpHTjJU?=
 =?utf-8?B?aUlaUkZUY0VPOHB1Yk9rdjJnOU1ZN21uakg2ZU1mTGxTL0tzdnNaN0N2WTlC?=
 =?utf-8?B?aEk1dHRGVCtQZ3ZkN0lhaHZXTXZ3a1orTlB1M0dydEVnN05aQXpQejdrSVJ6?=
 =?utf-8?B?bmNxVU5Remc3N0NGSlZmbVdYNDZQdkUxejVFTnhPMDNBS29GVEMwOUoxMGl6?=
 =?utf-8?B?T0gvYS93bnlBNkhEVTRnb29jMERLbWJxLzVOY2k3Z2NCaDVQMFRuRG5iVG4x?=
 =?utf-8?B?bjFFUVVhR3QzQTJ0bGVBREdlOHdWMlUyZW1iWWhBMVJ6QVEydFk1Y0p2YkU4?=
 =?utf-8?B?S1ExMFp3Wkk1RnJFeUNPNFdIUTFVUWJzNmNvYzVGSFZQWDhaMWd4Wm40MC93?=
 =?utf-8?B?L0hzRVcwZEVVcWVqcjdxYWFzMllKazdGK2JJK0lER1pJZmtwSGNqMFM5TCsr?=
 =?utf-8?B?V2RBSU5rY1EyNjVremRNRzdpMk1vK0d2akFKRmc3MXJYSWZiR040bEt2cER6?=
 =?utf-8?B?SkU2Q0NxajYySWZKRmhIOHloUFVsbXZQQWdpcjYrbm51dVZldGk5ZkltUHd6?=
 =?utf-8?B?N1hzM3JobEYxWG5yTXB1SUxLYVBTUlMzTG9wNXhueDl4cWFGZThtWithZG9o?=
 =?utf-8?B?cWFRVzkyTWdLL3A3Qkt3OFU1Tmk0NitDUmFaTzBQcjNHVmpVTUx1ZjRTUEVV?=
 =?utf-8?B?YUNTOW1qTDB6cXhCVDlaT1Q5Nzh6T056bWlpeU1QRE5Vdzl3YzVwdHNqSUhB?=
 =?utf-8?B?cklCMWo5VXBzendvaXlSRXRGMW1DbWlXZ1FJRU5GYTBxVmlpN0thbWRkK0pR?=
 =?utf-8?B?am5obHNMK3hHdWNFSFlsN2NRYUNLQWhTbitlL2NtN1BvR2JFamdSZURpdUJ6?=
 =?utf-8?B?UkYyVUNoR1ZZWGRkSXZEbEZzdXZvbG9FV0N4c3JuSFZoWXBaQXdRWmg2NXI1?=
 =?utf-8?B?YndvenYvbldHekt0bkdYUjBJNDMvYld0VnRkTXZOQy9vS2V0Yk96YlgzNVdl?=
 =?utf-8?B?WXVMbURYTEVZTVFsOE95MmJKaExJbGNNdURvODQ5V3IzZ24rZEdvYzcyMGhj?=
 =?utf-8?B?SVpKQkJIaE9wZHF3SUxiSG5TL2Rwcm1ja3A3RVNkWHJxMHV5V3ZBY2x6dWZS?=
 =?utf-8?B?MjdINGFXUENCOTV3K2JKTklzRjBnOFk0NTVPbWpiYjNMNzBiRk12QWNpa09y?=
 =?utf-8?B?K3QyZ0ZhRk04SEsyUEJQd21RamtnZmQ5dzNnaEk3WUF0UVRhZU9kU05vZnIw?=
 =?utf-8?Q?HrG4hqhbrtorQCJ4=3D?=
X-Exchange-RoutingPolicyChecked: ZzgYQ2Mq6hIY29J8h9w5MfLnPlkvZa2nDxBR+TvGl0mdnwqmc18op7t3fFjlIarzE6QUamM1syDwp57RW8mLqnT6swTmFoXwOVi8HRizVVHiwd1rC73qQIkzxq82cYy2ckGjaDu8R6q1ygqf31oO3411qsTgPm+7gqXwL89htJOwSScdiReZc+ozVQZsE/aMPdObrTKigTzoNxQ7j9W7yCE5FLnI9EGpAPWaZeZttvRr4hbiN2IS+0IgvywFc0u2uc/AKyI4Ei4NbazBX44AFENoCw/ur/CsXBydc5yWNy0FsxRtWLpfCHIntRyEGtsNv7XD/wme1ND6gJHPxhLb7Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: afa79207-665d-4177-7f53-08deabea9f3b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 03:42:11.6723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YGngLRiJR/eq15IOouiPfs73kbwPpbe/9cEHg6NvqAS7Egv+lPEnMvmicsTalQAba49R7EeXdOJr0kKdPNOAsgnB9hu9WkRxlXn6Q7eRH2o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB9976
X-OriginatorOrg: intel.com

Hi Tony,

On 5/6/26 4:14 PM, Luck, Tony wrote:
>>>> Unrelated to this question but may be worth a mention in the fix is that this work focuses
>>>> and fixes resctrl to not access freed memory from the worker self. To complement this it may
>>>> be worthwhile to highlight that it is safe for the work_struct self to be deleted while the
>>>> work is running (but blocked on cpus_read_lock()) based on the following comment from
>>>> kernel/workqueue.c:process_one_work():
>>>> "It is permissible to free the struct work_struct from inside the function that is called
>>>> from it ..."
>>>
>>> Scope increased from just the use-after-free when the domain was deleted. The case
>>> for taking the current worker CPU offline doesn't involve a use-after-free. It just results
>>> in running the workier on the wrong CPU for one iteration.
>>>
>>> Deleting the work_struct inside the called function is different from some agent deleting
>>> the work_struct while the worker is running.
>>
>> Right. I interpret this to mean that judging the safety of work_struct removal should consider not
>> only the workqueue API itself but also external agents that may access the work_struct after its
>> removal. The current fix addresses access to removed work_struct from within worker itself while I
>> interpret the workqueue API to guarantee that there will be no access to work_struct during or
>> after worker execution. The fix under development thus makes it possible to safely remove the
>> domain even if a worker belonging to it is executing and blocked on cpus_read_lock(). Do you
>> see any remaining issues here?
> 
> OK. I'll add something to the commit message.
> 
> I asked my original AI about this fix. It claimed to find problems relating to kernel using the work_struct
> after return from the function. Pasting in that comment you gave me from process_one_work() about
> it being OK to free the work_struct made it reconsider and retract.
> 
> Another AI (using a copy of the sashiko rules) has found an issue with our reliance on is_percpu_thread()
> 
> The problem is the ordering of hotplug callbacks.
> 
> resctrl_arch_offline_cpu() runs early because it is in the CPUHP_AP_ONLINE_DYN class. AI claims
> that cpus_write_lock() is released after running this, but before running workqueue_offline_cpu() in the
> CPUHP_AP_WORKQUEUE_ONLINE class.
> 
> So our worker may obtain cpus_read_lock() and not yet lost its_percpu_thread() status.

Your message is not clear to me. Do you agree with AI here and thus claim that there remains an issue? 

Are you suggesting that the original race explained in
https://lore.kernel.org/lkml/afoesuWB8RezVLrN@agluck-desk3/ is not accurate? 

I am not able to see how CPU hotplug write lock is released in the middle of all the AP cleanup
handlers. When looking at _cpu_down() I see:

	_cpu_down()
	{
		...
		cpus_write_lock();

		/*
		 * Run all the AP handlers on CPU going down - this includes
		 * everything > CPUHP_TEARDOWN_CPU that includes CPUHP_AP_WORKQUEUE_ONLINE
		 * and CPUHP_AP_ONLINE_DYN.
		 */

		/* 
		 * Run rest of cleanups on other CPU
		 */

		cpus_write_unlock();
	}

You claim that cpus_write_lock() is dropped in this flow.

To test this I enabled tracing and see the following when offlining CPU #38 running the
overflow handler:

offline triggered on CPU#1 and it takes CPU hotplug write lock
  1)               |  _cpu_down() {
  1)               |    percpu_down_write() {  <<<<<<<<<<======== CPU hotplug write lock acquired here
  1) # 9155.999 us |    }
  1)               |  /* cpuhp_enter: cpu: 0038 target: 144 step: 236 (cpuhp_kick_ap_work) */

...
executing moves to CPU being offlined (#38) from where the different AP offline callbacks are called:
 38)               |  cpuhp_thread_fun() {
 38)               |  /* cpuhp_enter: cpu: 0038 target: 144 step: 235 (sched_cpu_deactivate) */
 38)               |  /* cpuhp_exit:  cpu: 0038  state: 234 step: 235 ret: 0 */
 38) * 20632.54 us |  }
 38)               |  cpuhp_thread_fun() {
 38)               |  /* cpuhp_enter: cpu: 0038 target: 144 step: 214 (rapl_cpu_down_prep [intel_rapl_msr]) */
 38)               |  /* cpuhp_exit:  cpu: 0038  state: 213 step: 214 ret: 0 */
 38)   3.171 us    |  }
 38)               |  cpuhp_thread_fun() {
 38)               |  /* cpuhp_enter: cpu: 0038 target: 144 step: 213 (pkg_thermal_cpu_offline [x86_pkg_temp_thermal]) */
 38)               |  /* cpuhp_exit:  cpu: 0038  state: 212 step: 213 ret: 0 */
 38)   2.378 us    |  }

... this includes resctrl ...
 38)               |  cpuhp_thread_fun() {
 38)               |  /* cpuhp_enter: cpu: 0038 target: 144 step: 209 (resctrl_arch_offline_cpu) */
 38)               |    resctrl_arch_offline_cpu() {
 38)               |      resctrl_offline_cpu() {
 38)               |        /* workqueue_queue_work: work struct=00000000ed014eff function=mbm_handle_overflow workqueue=events req_cpu=39 cpu=39 */
 38) # 5920.866 us |      }
 38) # 5927.396 us |    }
 38)               |  /* cpuhp_exit:  cpu: 0038  state: 208 step: 209 ret: 0 */
 38) # 5929.182 us |  }

... and the workqueues ...
 38)               |  cpuhp_thread_fun() {
 38)               |  /* cpuhp_enter: cpu: 0038 target: 144 step: 187 (workqueue_offline_cpu) */
 38)               |    workqueue_offline_cpu() {
 38)   3.724 us    |      unbind_worker();
 38)   2.312 us    |      unbind_worker();
 38)   1.701 us    |      unbind_worker();
 38)   1.681 us    |      unbind_worker();
 38) ! 226.852 us  |    }
 38)               |  /* cpuhp_exit:  cpu: 0038  state: 186 step: 187 ret: 0 */
 38) ! 229.393 us  |  }

....
eventually this all finishes and _cpu_down() completes, releasing the CPU hotplug write lock:

 73)               |  /* cpuhp_exit:  cpu: 0038  state:   6 step:   7 ret: 0 */
 73)               |  /* cpuhp_enter: cpu: 0038 target:   0 step:   2 (x86_pmu_dead_cpu) */
 73)               |  /* cpuhp_exit:  cpu: 0038  state:   1 step:   2 ret: 0 */
 73)   5.038 us    |    percpu_up_write(); <<<<<<<<<<======== CPU hotplug write lock released here
 73)               |    cpus_read_lock() {
 73)   0.474 us    |      __percpu_down_read();
 73)   1.420 us    |    }
 73) * 62023.47 us |  } /* _cpu_down */

In the trace that included all CPUs I only see one instance of percpu_down_write() called when
_cpu_down() starts and one instance of percpu_up_write() when _cpu_down() exits.

You claim that CPU hotplug write lock is released before workqueue_offline_cpu() is called.
I am not able to verify this by looking at the code nor the traces generated when offlining a CPU.
Could you please help me understand your claim?

Reinette





