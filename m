Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795710075;
	b=cHZ4zfKwu0qiu+Tk7tthW14f5WyhDv36guhOkhFD58lejKNRDi3A2VZc7lOR/DZS6AWM
	 W5NvWmfZNuVRcuzwmTpU9+XTS/8FSe1tc2D8K5e5NqetbCWEScGemPSqzcbBiUWyKPhMP
	 HAycPSgI51Ba38shNSXu/zoYOZze3kV4Ocr921KF6porvkFD/CZvRhjrE7U9KssHcBEy0
	 1qiI6bxqsGmiEpAb81TROKvNEkj4n9lWyrIeQU6ue+0sNGsMuwYMChzo93mkG1+vFgdK5
	 qG3QV/G9acMh2YFGAIoiMNV1YfG6yanaGsGwSJj7LMshe9TyeDxUn8vMRiDhiJLUYNw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795710075;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:Date:From:To:CC:Subject:
	 Message-ID:References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=Copskdu/HoTGSrs8O7Wvv7M2hmil7wxePLfQvjpJyk4=;
	b=CbLdpWF48BbBwQw2qy/sV6uTXvNz0UK/RashOSCFfGZ2W7g5r/jjx1uenkyGKJ29dC4D
	 QL4yNgqk6Sr67BETOo1psiX3DBhhpOjxqjcyR2LUOFSrOfpR7RQBy5Z6VAazp3/C30ctJ
	 +adCDGEyICw87gx5C4A5C47W14k5RhHMjBEeQqkjuK2CO1t522idnz1WCRsefe7aK+PX9
	 el8DbTS87ajklpfK3dVDxbr0aCOYM60mR3zNFWyrB4H1bDTuBHxXNoXa9c7RVWz85kVLa
	 tmUikp4m2vCdyUtcDn+OBTA7KVVGabtX4SPdGMK+Eb5gdKQv0CzRmKTh4a0wtDnrtjg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=nkZsaxGS;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=FRv1LTPn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.19
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D251F606A323
	for <patches@lists.linux.dev>; Thu, 26 Nov 2026 16:21:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D251F606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=nkZsaxGS;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=FRv1LTPn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795710074; x=1827246074;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=E40qhtyw1vo9r7N0qFS+HBnoB3kgOPE+Evp6wNAScQk=;
  b=nkZsaxGSWApJxmpuIxyYlVuvS+p7unSBAZXBj0pHAFvqbC6UC1AjBR+x
   JbS2sSTeIH4VIA9GoS8XbRUZoldR9UoZFAI4YLuNasiGe+dkjnjrWjQO3
   nPwTzlfLrkMiQcPfS1w5p6HUAKsthJMCQewSeN7isJkiAFJfMIopbQLJ8
   JlpuokX5XlHLich8CFlsWKdJb7qT3TYV3gtq2rBGYdopprRJFRx4Lhs1K
   RPFCSe+ONUhqM4tlpmTPhszTRhWK019OTQ8H31hWEwlsje3+xo6ZDnXqB
   HIGjaMuVbZjxOrurnRsp7GRBgtCgQLWn6sEapOltZTyY+xhfuI8een0wl
   Q==;
X-CSE-ConnectionGUID: AD+A9FfgS6Gs3FZCWFLZPQ==
X-CSE-MsgGUID: 8hJ8zY3lQ5CX0JeXLBNyAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11978"; a="4642103"
X-IronPort-AV: E=Sophos;i="6.27,235,1787036400"; 
   d="scan'208";a="4642103"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2026 08:21:13 -0800
X-CSE-ConnectionGUID: HXoyIyb3Td6G5Ipb1pu2Yw==
X-CSE-MsgGUID: JCf7KrYmSY2a8vhezLD4IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,235,1787036400"; 
   d="scan'208";a="12238468"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2026 08:21:13 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Thu, 26 Nov 2026 08:21:12 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57 via Frontend Transport; Thu, 26 Nov 2026 08:21:12 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.25) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.57; Thu, 26 Nov 2026 08:21:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EeeN4ZG/rlnePlq70/+59rLd3W3w9mkEgEVo9kxnFSUgNQtm+fhH2Ho45tB7Vhac5vJf6goxzev8QGf+f3nzJ5TowQEU+qZnK2yX/6hd/S4P2fblnkroNm82tMud+60N5bAZJizpQ3bw830UP+QfDQkOGoDRF0ukV1p/K8lRKbLQWaIFv+wSIS5YE0UeDe8TmDitPSkXq0+Hiczs90e7eby5VT6mXGtDNjjM8khvJ34JOgB9UNzMsjo/KNPjLzkR5MAg+Cft66YaJlng/ifvhD00b85R4cvHrVYjtrA8NOdPfd0pFojfTHjfSNsGAjUr2WN78F1BuB2KKso3E2ZMeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Copskdu/HoTGSrs8O7Wvv7M2hmil7wxePLfQvjpJyk4=;
 b=V35vdoQHDF6hZYNsMnLa7SosatvnWCQfQSmrRQofC/KHDnONqt1NT8jJp4NRL4dyPfY5PL3231siOoXd72XbJc40AkMru5PwtYzqcvRfqfQHtovxyOAm41a8qhnnXcL1+6/uQVN+y5Rlv4nTw35d8yektl7TXOCC+WpvBrJoDlfy6g29ls9VI8AJ6dFF2UOZWrcgTOWa2R4hw+r4b/blz5O0RC8JwOsqvrLb93iIwgbNz7m+LOgfnPaAB3lBjrg0J4JRpDzvP0H+/1xyt3w+DlOirVE9go8B0+89PdkOEMHn1alK5FqYEfYIbZD1FZXLmN2FLsXFE9DkiBqLaCPA7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Copskdu/HoTGSrs8O7Wvv7M2hmil7wxePLfQvjpJyk4=;
 b=FRv1LTPnAaDPMNDHQrIrY/YzgrjgIJrwHGNC2YUATVDUgH0lO9IyGBuu+Rwgae9+pLaTqwPNAgaKN2RgnfLUyHRBdcc82X+dUU2UH71R+MLXmIQT/fS4qfs+8zl0p1EjWPCVegUqGfsGLIH0/HoF9RvftxjuzlnLunUAJih6Rcw=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 BL1PR11MB5270.namprd11.prod.outlook.com (2603:10b6:208:313::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.6; Thu, 26 Nov 2026 16:21:09 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%3]) with mapi id 15.21.0662.004; Thu, 26 Nov 2026
 16:21:09 +0000
Date: Fri, 27 Nov 2026 00:10:01 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <kees@kernel.org>, <mingo@redhat.com>, <peterz@infradead.org>,
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <kprateek.nayak@amd.com>,
	<david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <tony.luck@intel.com>, <ben.horgan@arm.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <babu.moger@amd.com>,
	<fustini@kernel.org>, <jedrzej.wasiukiewicz@intel.com>,
	<fenghuay@nvidia.com>, <peternewman@google.com>, <x86@kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [RFC PATCH 1/3] fork,arm,x86,fs/resctrl: Fix stale resource
 group assignment vs copy_process()
Message-ID: <awhZ2UGIpFDNgcCs@chenyu-dev>
References: <cover.1795197419.git.reinette.chatre@intel.com>
 <b2e13da64ca3e41207b5d46fb060bccefaf9fecd.1795197419.git.reinette.chatre@intel.com>
 <awO3nYazk97csbpO@chenyu-dev>
 <22918abf-7487-4662-a87b-34c579783e51@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22918abf-7487-4662-a87b-34c579783e51@intel.com>
X-ClientProxiedBy: SG2P153CA0049.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::18)
 To DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|BL1PR11MB5270:EE_
X-MS-Office365-Filtering-Correlation-Id: f19361f3-0a01-4e4b-53d7-08df4bd947ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|18002099003|261009223027099003|22082099003|10063799003|10067099003|11063799006|4143699003|56012099006|261026121527099003|261026140227099003|261022105027099003|261022075727099003|261028144727099003;
X-Microsoft-Antispam-Message-Info: 4bg8DDNjC2YpHcLooPu1pM+b0nwtHDzYjeK6ox4TH1yJpbnBH4OmWys39xO3OLNhuQSg8dyW9DYNLbivPHjq2GCZX+YesQ5/k6MX1FAKZJX1JpuMlAS2UIixYJuDwxc9g2V1QqMk/GK386f2uNyCitMzjp66Rx084KF4OTLxcJqBf+TMIgJ+pCQcdQ2/RgER3x5tGckWp1gFt3sGgysoD0hHghgPuWdfiP6QhRMzhMGju0w1cBF+4raXKpcurPj0k9kVKIFp8ySI/quV8VnN5y7nZlddh9YJa2fn0FUjUL8MLXiR9QkK29ZwDVZjdtK54VbDu06m5se6fP1NuQcUv16O+HwGmXjkx85/prZ10PSZ5cBq0MVTuMoAqVS1DIHMrJ4XY1iEln+nORFv4lbx8rHbTEJFaC9QpblnevOTOUKLrnwJDJpo/w9hzjavBrE5Ua8rZVvnOqdTIPu3t/lUftEigys5d9j0x3NFDT1egGwc9Kkyot6chhF0Rg6jgmA2exJgnvt7Emci0bViZa5BPFMiIG2J5YfFeKaP84MRaBq9c98raIH1lB/3Yu5wrEehhXAdLyl/nXRGlq6u1qKPpFMihKPlbUn0inFHqxvgv+Hk0z4D8fluP//sIqwjI4dybQI5myhkUOddSrsXZ/yZRdlrTbFlGLaLaV2g34DrlkM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(18002099003)(261009223027099003)(22082099003)(10063799003)(10067099003)(11063799006)(4143699003)(56012099006)(261026121527099003)(261026140227099003)(261022105027099003)(261022075727099003)(261028144727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ju2XSDxUjjj4I0nlP13UlyP9mz7r2WiMHnjFiffbdrOkQxWFA8rOynoc855J?=
 =?us-ascii?Q?XQTWypWKhZ7oJERZVYwdUYvySmJXQYDm3EP2eKMxqwnESMLJh8kvczaA43ay?=
 =?us-ascii?Q?CIhxapwoEk8HQdlwjm+koXRJp0QqShzCv0KIEUdUUtWl6fQDtOKw7XeOUGnT?=
 =?us-ascii?Q?eiHdeLUiFgt8TjXxZgRcgClrIc4FLoDO2ksEJlLweZqrXH2Mn4XsmgOZr0Z/?=
 =?us-ascii?Q?5Db+NY/AI8EKIjFz+H2wxbhKOMig++bKpAbR9Ka41oCqSdNZps8CwhTdrHwt?=
 =?us-ascii?Q?+ZqZ87mTkgP4M0Ok+ykQ0T9SoYkYCKc4f1Xwo4X848IF9LmBi8tNN/XGGk1l?=
 =?us-ascii?Q?g90r5MZlJTkATnyUORXXJ+ugjFjZjkhsO3tmP9K28xXIiXOJLleOlYLNDNZK?=
 =?us-ascii?Q?8b74g7tonQL6MfYa5IhZCWOuPKodtWvEzOJbSklOT5qbKDJl8wh0TQjcL3RA?=
 =?us-ascii?Q?yXCfccwa2E8s2vkf0NuBReIUtAD4m9xz7Wj/+HPGWXOPNK74FB6MKTi1FitF?=
 =?us-ascii?Q?+gMBn459rh+LyfG7LTjTsG3IdN0yFcAUTvXoV83BdvA8XuMQNQ9yeXmFWhFk?=
 =?us-ascii?Q?hu3F/CowKCU6BG2WxRuoUZ/SrKh68u4czwAMODyf0yhiT05AHrH8vba6TraS?=
 =?us-ascii?Q?4Fk/CE6Ls6sSLwmzY2vd7GbBjKqNHQTZofp4+hXl4pTPAJgEXoPME+32Vnmm?=
 =?us-ascii?Q?lkorqGdoFLycTpUTXgfFma480NvAqCEpWgXfuJG5nnDg0hMrH3WLPoaa/EOZ?=
 =?us-ascii?Q?/mi64iFw9NCFU/DJ8LphTqQH+xP7TyafAbYshP6sFmiSaP4mDym0opIJVak/?=
 =?us-ascii?Q?cXhNcTqGMmeCK+5Pf8cs0kO4A7E07TE8qsvDEizvnBr776gEt0erXU03pyyT?=
 =?us-ascii?Q?XshP+9qzX0eB2lJzk2n9JxknB2ELfVTGUTnA2alkcAIWu/vQHVcUAH/uZ1Od?=
 =?us-ascii?Q?jw9OxeQmMH+3cjOFTAeHhXTO6K74E+1w+59I3ZWJFCh4S8zKQe2c+Cx/lmtP?=
 =?us-ascii?Q?p3Pp3Ov2HTMQIaiwwnJR7GJZh8drbALmITBkxCo3xk+X3feg9eHKv1Im9PuI?=
 =?us-ascii?Q?s99ohAVRU6iq9sKAraQCnGz4OnNcujlpGEtSvcgTda8K3gL7Gfw1a0uUcpFF?=
 =?us-ascii?Q?wGkgFvoK+xwCQFT190lDCbAhYvAPho5FQQ71kiLkG3RPNLUYSHv+LqhYwg1w?=
 =?us-ascii?Q?Evbu6PcgcHS23CrQw0PvDtvplKWqmVp0oAyYkAU76XPr6vyyd2CWuM1rp48Y?=
 =?us-ascii?Q?yKwbOrxtSp0j9E+zR2Otd6tJb0FSKExrmnczRkTpoTxlWOnV01603L1lNMN9?=
 =?us-ascii?Q?7UMVbM0E4oTd7dkPHVWU3gXosrgxDtDwaL+EIZ5JJdLd71qFpTQMRk4t2ENf?=
 =?us-ascii?Q?3Tjn29kZ6UioKQGdF8lA5jEYV9xm35eFqcJRczvYPaZKI7NxFKYngeDBIZ86?=
 =?us-ascii?Q?E8js9FW4hGihRm2IbqM3pQ19AWXGPj6LikJRTJnZaxZW7QdmoH52IlFf7cWY?=
 =?us-ascii?Q?T8Izw/bzZHcuyLgtXab0YVhWRxPInLgOgSElX6w7CDnecJDaIvGkJmB9Z970?=
 =?us-ascii?Q?UfIV/PIbM0vM85ENDFjDWFgoLx8qE61uygm087xZJvfYrBVHXlXA4x2X+Umn?=
 =?us-ascii?Q?XUuDhcLEincVCq35wDWrFqP67zkc638oTYAhgEN+nIaHQdW71n1/vemfJ9R7?=
 =?us-ascii?Q?IGGF2Kl54MsMrYSQ4mJNL9UHtCWxdfcwjLA8t2eXi2CZ+RQc9OmyxS2MZ9Ex?=
 =?us-ascii?Q?QjM2nny+sQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: H1YzGrW1vbGhg65vkjG3hpkYAhRBiMFHkfe0Cmco8Hh2fsWnS0MQJ4mEJdDjOmXRx+aA+dIBGvdSRdtp6r/1yU5/a4Vq3stf+28YtI/OVTxHmgK/YwDi1wTnIJ35643j5w0KqeOUcVuPj+trPlYpw5msyUCKmpFe4whJ/EyoCyI9p4znXMjnfGLz4hqi89UUuknsW9W+NcLiCCujfJYbbE4MGgFNOvvZltEYkmvPdJh8EJvkRFGwJJzWOVdZ6qDQrULIprMeWR7XQoSjOoL/UfMQQImaxv/shBsJFuFb9aYem8B86BoD3A+nBQRWaEuPIPEKt/QSIwNS9uQMplVdfA==
X-MS-Exchange-CrossTenant-Network-Message-Id: f19361f3-0a01-4e4b-53d7-08df4bd947ac
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 16:21:09.4393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: crMnAAf8EOObmq5G7zfVCQj4kf4naT7cXgM+DsbB1g3ctTxxdrKp8BaCSYvESdZUGlp+14XljqWqKfUiNr7cow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5270
X-OriginatorOrg: intel.com

Hi Reinette,

On Mon, Nov 23, 2026 at 02:50:14PM -0800, Reinette Chatre wrote:
> Hi Chenyu,
> 
> On 11/22/26 7:48 PM, Chen Yu wrote:
> > On Fri, Nov 20, 2026 at 10:39:30AM -0800, Reinette Chatre wrote:
> 
> ...
> 
> >> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> >> index 57ab090072c2..ebf780fc5fe9 100644
> >> --- a/fs/resctrl/rdtgroup.c
> >> +++ b/fs/resctrl/rdtgroup.c
> >> @@ -657,12 +657,28 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
> >>  		return -EINVAL;
> >>  	}
> >>  
> >> +	/*
> >> +	 * Hold tasklist_lock for read so that resctrl_copy_process(), which
> >> +	 * holds it for write, cannot read the CLOSID and the RMID of @tsk
> >> +	 * while only one of the two has been updated.
> >> +	 *
> >> +	 * Hold tasklist_lock just for the @tsk update. A CPU running @tsk
> >> +	 * keeps using the CLOSID and RMID that resctrl_arch_sched_in()
> >> +	 * applied when @tsk was last scheduled in, so
> >> +	 * update_task_closid_rmid() below has to interrupt that CPU for the
> >> +	 * new resource group to take effect. Leave that until after
> >> +	 * tasklist_lock has been dropped: a CPU waiting for tasklist_lock
> >> +	 * for write waits with interrupts disabled, and @tsk's CPU is the
> >> +	 * one that may be waiting, because @tsk may be forking.
> >> +	 */
> >> +	read_lock(&tasklist_lock);
> >>  	if (rdtgrp->type == RDTMON_GROUP)
> >>  		resctrl_arch_set_closid_rmid(tsk, rdtgrp->mon.parent->closid,
> >>  					     rdtgrp->mon.rmid);
> >>  	else
> >>  		resctrl_arch_set_closid_rmid(tsk, rdtgrp->closid,
> >>  					     rdtgrp->mon.rmid);
> >> +	read_unlock(&tasklist_lock);
> >>
> > 
> > Is it possible to combine u32 closid and u32 rmid into u64 closid_rmid?
> 
> This is something we can look into yes. The "What remains?" portion of
> the cover letter highlights this but stops short of proposing the change
> as you do here. Making this change will only eliminate the need for this
> lock at this point though, it will not fix the bug, right?
>

Right, current patch can fix the race between fork() and rmdir/task movement.
 
> > RDT will no longer support 32-bit kernels, so u64 is always atomic. Then
> 
> Planned, but not yet done.
> 
> > we don't need the above tasklist_lock in __rdtgroup_move_task(), and there
> > is no race with resctrl_arch_sched_in() - but we do need it during fork()
> > though.
> 
> Right. The primary goal with this patch is to add a resctrl hook into
> kernel/fork.c:copy_process() to address the bug that results in a task
> _permanently_ assigned with a wrong CLOSID/RMID. This is required whether
> CLOSID/RMID are two separate values or one, as demonstrated by MPAM, which
> stores the two as one value, also needing this.
> 
> In comparison, as described in the cover letter, the potential race with
> x86 __resctrl_sched_in(), is not permanent since it is corrected at next context
> switch. As you indicate with your proposal, addressing it needs a separate
> and more invasive fix. 
>

OK, I think the current version is ok to fix the race, and we can deal with
__resctrl_sched_in() later.

I fed AI with the patch 3/3 to generate a simplified test script, and try
to reproduce:
1. The frequent forked task f joins the task list with group m's RMID, which
is freed by rmdir.
2. A later mkdir N reuses the freed RMID, and task f shows up in the new group N.

Tested on a 160-CPU Intel server with the script, C does not show up in
the new groups. 50 cycles passed.

Tested-by: Chen Yu <yu.c.chen@intel.com>

thanks,
Chenyu
