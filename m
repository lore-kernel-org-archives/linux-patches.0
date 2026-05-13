Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FA638B12E
	for <patches@lists.linux.dev>; Wed, 13 May 2026 22:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778710788; cv=fail; b=CiEwt+UkUCOMEIdpfwD0vNetNNHmzNe2CvY/K10022N8TVG6oIfmCfae4sdfRAC2WMGxOkCXWBtl4aJ9dZDyjGLAGDXGdzcuhXNdoPPqFQX6K1HkfVfL7TkaJJz6X4ZosJ1J+5LFEV0P+n5Tf9LWgyCfhQdaXVm6hw4e/LJGeg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778710788; c=relaxed/simple;
	bh=rOljSWivR8T8ktviF3nxqq2pHv76/7ev8gsr0YdbGnI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lRj2O6fvtrxa6MQJoxBlgoFNHTpIZsLH4PQOAoV1wv25gbku9U+5Js2vEhgW36/6+r3jX9F7VQMqzQkAxDEKzxjSP4iE+A+09e/f01WDGurAW7hBewXp4Bh22AaUKdtCwVRx6BKY7/bXgpeqQMFu6OV1cy0lSpDG5IYbwHYTxaE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nJKcQlSG; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nJKcQlSG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778710786; x=1810246786;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rOljSWivR8T8ktviF3nxqq2pHv76/7ev8gsr0YdbGnI=;
  b=nJKcQlSGyzYYav2IRAn8aXUeeJNgL//2Ky7EfhiQYnmPDdzGDf4XBah/
   iN+UA+Spbb3YHAPvdRGy16GLn3RF5iHewVKnICRXstVa0icbwNjQz8AC2
   PLv8iKKBy8pCii0mD0BsYNrcr7J2276OhZ3zDKvE+DZ9nYTHa+TxzHNdw
   2TEPNhfmGV/g6M6TecfbPnnYhMdRSaswXJs27+9GyygQHFDFulbA+asiI
   BDgL0DmM+vFC5qNZ9Qry6vw9UJLht+yW0DJePAP+2Ohk0nBP/IxUOnfAb
   09hwPKaGCAYuwaiSfoCAM969/GenqUReDxs6J7Je1ddFlF1i7vpLT1q0W
   w==;
X-CSE-ConnectionGUID: iWYAcSZATZWIwhaRjcdAHw==
X-CSE-MsgGUID: 2uDki/QXTtW0uRC3LVKiDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="97075837"
X-IronPort-AV: E=Sophos;i="6.23,233,1770624000"; 
   d="scan'208";a="97075837"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 15:19:45 -0700
X-CSE-ConnectionGUID: unqh33g9RreKw95w9mHhdw==
X-CSE-MsgGUID: Nd8TulPeTc2v8fickwB/Dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,233,1770624000"; 
   d="scan'208";a="242206003"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2026 15:19:45 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 13 May 2026 15:19:44 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 13 May 2026 15:19:44 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.27)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 13 May 2026 15:19:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kBv7Yphpz8215NvnW9Q/NT8u2Jdgx0H4SdfJXzG6ewsCWEAZY7cfOVH7xMX5DQf3NHLTogAvM2eFS3YovuYCS/ncJn+r3Ojvw/1a6CWHlkXpRmj86oq0TjiyvKc5lrwVHVI6D2GSXCazxm1CuReVuTbDzOhsNcuVflGP0IprRLmLJse81J//RJVVUSmAF2g+YLPvhpVep4yHfOriHPPHKq4yykqxH2pGqsge+eGnxc1Hqm79Ce7q8JjhM8DxtCmFlboGOjZhADoIhDr5inE24rj+U0BRTNkbldcGsdZg0U7bzA+tW+QOtLWgpeF47yW9+bStkKDLUtmdOLa7tcpCAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2D0b2UhSB/ZFyaNDoJ5c3a39tQALguTKNfJa3YwDlqo=;
 b=ZmDsFB1HXLiO2GKNRJSXnVzcRqPmNP4GcKWPIo86bX7UFD2z4gjq6ETyAd8XHjbvzPOpTKYiu6Hg71Ity50yPiWBTNoQPdnxP7t3vj//Eg+345tTTDaAXzDv2kEwLn2tRlkpoYEa/VyI9g4ZhpKPFUydYT2BlXt6oMNZAt5nDtG8wEqNSd1+rmoHi1OMUm+mgQaqMkFOQtQ/2X89rGS/J71vHFeJ/4KzMe9uPVX+RwYPojU7GvudUbo8jpWsVrDEHxZDpVKu2IOBK9eb8pTEC7YgcUXnhgck3cQ3NOD/cmq/9Kl3HIgfNogy9XNyPTLo32YwlF7YJyQ08cJU8DOb7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SABPR11MB9963.namprd11.prod.outlook.com (2603:10b6:806:509::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Wed, 13 May
 2026 22:19:42 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9913.009; Wed, 13 May 2026
 22:19:42 +0000
Message-ID: <6ef756c6-7c21-47a4-8173-88e1989b7d1f@intel.com>
Date: Wed, 13 May 2026 15:19:40 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] fs/resctrl: Fix deadlock for errors during mount
To: "Luck, Tony" <tony.luck@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Fenghua Yu
	<fenghuay@nvidia.com>, James Morse <james.morse@arm.com>, Drew Fustini
	<dfustini@baylibre.com>, Babu Moger <babu.moger@amd.com>, Peter Newman
	<peternewman@google.com>, Dave Martin <Dave.Martin@arm.com>
References: <20260508182143.14592-1-tony.luck@intel.com>
 <20260508182143.14592-4-tony.luck@intel.com>
 <e0f70732-3ceb-4d4d-8ffd-4f2761922e3d@intel.com>
 <69874f4d-e64c-4d74-8ba9-eec30760751f@intel.com>
 <547e32fd-1d60-4c12-8ba5-5f8cebe5ab87@intel.com>
 <8ee967df-329d-441d-9635-47f48b5e7b8f@intel.com>
 <agTWVa1NYNhA5wUp@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <agTWVa1NYNhA5wUp@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0041.namprd03.prod.outlook.com
 (2603:10b6:303:8e::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SABPR11MB9963:EE_
X-MS-Office365-Filtering-Correlation-Id: 95cec48f-1b6b-427c-1260-08deb13dbaeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|18002099003|22082099003|4143699003|56012099003|11063799003;
X-Microsoft-Antispam-Message-Info: lQtQPip1Nnoz1hFsGSQp5kJ/ERtynQXdwx2NXP4D3yMfXPU+BKQo4uw3uDz1whAhpTLZOdwAprxMII07McDsAgAmdYS5+Fy3zlT+Lq2uTGUoHF1YIhXglnvq8joG+OkWa8yJEapi0dt9Fdak9vSeYzTFZ+r40KvU8/I/Va72HaeXekmzvYr/OecnQbc5brDjAAa00a7ytBza+NsoZc9q7mJMjnTvBfiOGYehQIGqmOKHbml6skUNvcrvqr9MEm8q68a9UbbHAy1Ri6jSt0Yq5SRE7jooKCmTPGtUijV7Fv+K/umnPaksmrmAE6dupzPTtvAW/iCYOuTki1V9ZxVE2BxKwA0yPZiC7OWAmZnI7qNiJsimlO7rx2Xmxtgj8pVH3DgzCBCq2H5b+2327cHBeYDPPTl3pkJqb86IG6piLV13qSEiBk/80O3xKcEGpgHuasSKt4tI13s3/JalGbDj895B7o6dm1bkyDzDtEhl+nIiia9b1HgO8W/DFyVdLPeBbAXTiQAr8kPrILS8MsoJPIk2Mr2i9oOFi3+v65PihZegxBsRjprmci4HDYdLhdSV+y9Oe65F/qOONu+zG5ky76hTxrCGzZRl3pKLokbaxnKNT6Wts0KdXXWMkAk2LhhjeH128yd3QA7zj0USscqfiUrm0PWZ0bgXCMy9JosPa/9Fb0WotbX/QsK2tnUSW9/9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(18002099003)(22082099003)(4143699003)(56012099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dks1bkFhRittL3hiRm00TktWbkdacm8rMGdHRUlwNHZnVEJnRTg0SXBQVjNi?=
 =?utf-8?B?QTFLWW0vcVRwc3R2dkJmZXNlSENPU25XajlXdXU2bmZ4bEEzdDR1Sm9RV3dV?=
 =?utf-8?B?ZGkvYllpcVdrK2EwSWdwZ3IybHA4YTdoVVNQblJ2elhaNjF0eVRrdGZxR0RD?=
 =?utf-8?B?YnFtNU1tSm82cXRBNWF2S0V3clUvMmVOb2NLVEpkVFlySklnbXlkMEZ2dE9V?=
 =?utf-8?B?UzlOVXZXVlhsSlBYVGJKR0NwNnNEREY5OC9SUzh6UkYxSWlOM3ZVR2IxOXdj?=
 =?utf-8?B?MkFkUGFIQzJ0ajRHc3Zna2h4akpoOFVTZDRQeWJoOXlzU3kzVXRxOVc5emdy?=
 =?utf-8?B?eFp4eUdsamtJV3dIQUdhNHQwMlZKRkl2RzVFTjRUY0pMMmZ3QVdlTzRHMnVa?=
 =?utf-8?B?Y0diUXo0SFlhaUV1bUJkMndONzRNRzdIQnlRWWlGWDFKaE9mWWwvZGg1eUZh?=
 =?utf-8?B?cnZBYmUrUDE2bkk1UmlUVzVoNTRVc1pPVnZoQVNqSW5WdC96MzNJNWVOVlR1?=
 =?utf-8?B?MGFNRmprbW5YYUxhdzRsalFSNzdkdnlseDczZEt3WTIvazljd05VVllWMUtq?=
 =?utf-8?B?MFpvVzdGMFh0aFZkRDUyUTVrbjlNWlZaTHIvZHFEZEFnTU1aUWVYNks4T3Yz?=
 =?utf-8?B?dUh0dXFRVlEvUUo1Sk5KbmlBSVZ5U2xVSUYxejkrRllHdEFzeHliUGpRY3lR?=
 =?utf-8?B?SmpzSGlZbXVzNlpoM0pnQVI5L2JtTndJZzMyeWg4UEMvWENMcTFVMitxMDky?=
 =?utf-8?B?SXF5K25tek51a25YSWlnT0pSMXdaL25lN2hhTzF5blhKcmdLWVd2M1lyU0dB?=
 =?utf-8?B?cU5aL2wybHAvUEt5R2dyTXpoZ1JPM0lCVkQ0cUJPWFlKQTdaQjlUZVh1UUdv?=
 =?utf-8?B?VVMzR2J0aVlubkN2YVc1V201d0UyYnRUR1FCWWpRaHZ6YjlnZ1dJYUlJMWZI?=
 =?utf-8?B?Mi9XN1pZRlVGRGQ5YmVuOFlweEUzMmJhOFdPMkg4ZW81YlBLU09ObXE1dHJw?=
 =?utf-8?B?NTVHNmdwRk83RVd3VTJNeHhuak5qUkF0bU01NllWMmJJQ3dOYjNHM0RGYjVZ?=
 =?utf-8?B?NWI0RkJzZ3FhaTJQc2l5YUFsSWwyODVmMHBKUHdBbktSSFRJQk0rYUdQVHhv?=
 =?utf-8?B?S2Q2Q2h2RFFybnFLaXhxQ1RsSlgzL3VzRzJqQkVlekx4MlBPSEFKM2xQOHcw?=
 =?utf-8?B?MG1xcXRlUkc0cjIzbU5ZbVpnVU5WalZXdkIvR0FXTi8xVWVlWHYrbTdSRlBh?=
 =?utf-8?B?bitxT1VNRnArZDhhTjZZMklFazdxY25tR3JoYUliZ3pzQjc5OTRJMjgvUCtp?=
 =?utf-8?B?RTlkenhVZTFES0pkZnlHb24xSzl1dmlmM3Vtak9EMFA0cVZCRTF3OXRLOCs4?=
 =?utf-8?B?WTNGRlcrSy9ibE5vdmRqVVJwNEpNdWQwdGhCTzJxeG95TEg0ZEEvK3ZKTDUy?=
 =?utf-8?B?K1FOdktJVndldmJuMkpUMDRzYlluQlU3VUh0TkZMN2FoMXM0UFo3UHJaelIv?=
 =?utf-8?B?RkhUaGQwRnkzMGw0MkR4bkVsZFY5Zk8yNnY5Z1RzWnF2YkllM0RJdWhtSUNw?=
 =?utf-8?B?WW5rT05NcHloMXROQWc3ckRpSVBscGoxTXVKOC9SQjNYdEFsUzE3Mzk3cnBP?=
 =?utf-8?B?UnZONHRzcC9BWmVKTWlIL1RtMEVoNnhvYlEzSWUwTE56TG55YlE5dlJMdElz?=
 =?utf-8?B?dDJrNzZpVklMa3E5c21wS0kwcGNCV3U0Tkt4UHE1MldteHdvQU9nU290RmtY?=
 =?utf-8?B?V1drcGs4L0pNa3NqZEFtQ1pmeDhzVGNOakllSUJDV3U5eVdvZ1RoK1FNUWZZ?=
 =?utf-8?B?TDZLWWxzRlFTRDdpbkFLbEp4UndIL2lZRytzK3BWMGgyQkUvSHRTMXo5TWhu?=
 =?utf-8?B?RzV3NjJ4Y1J0amZ1dDNUd1B4VFRsZXpMdUNpanBuQng4cVZxZ0ZmZ1ZVczRz?=
 =?utf-8?B?VXluU1h3R2d0VHY4RW1uMFpkR1ZVN1d4WDEzcjBwT3lwTmlpNFpmZ1FDbWU1?=
 =?utf-8?B?Q1dNNHozQlptamdkcis4bEc3Y0NRRitEeE1hcCtkeW8wREJlOUNqVzgzWk5U?=
 =?utf-8?B?NmQ5cFBoMG4xbjZLUERaYnRtdGRWcjBNaGZGZHdGY0pxRnIxODdOSzltaDdV?=
 =?utf-8?B?YWdsWjhRMnV5YnhrMW9LRHlVWVo0OHU2ZnBNOGZLNjBBME1CbUVROWpkbStN?=
 =?utf-8?B?SFgxeE1IZ0ovendvZGIvUEhxcmNydURWSGNaNDZ3ZFBhd2pGd0FnTEVLOGJt?=
 =?utf-8?B?azh1YTZFbm81czFYYkltdW1ZT25iMU9HcXhiQUdiY3VGSVcwSno2cnl0MThx?=
 =?utf-8?B?YW5VNlI0ZThjbEM0U3E4SmhzdjRiSUlycFVOV2dlOC9DMjRKemF5TVpMK3Y2?=
 =?utf-8?Q?DbeZXTN4kCmyvmkg=3D?=
X-Exchange-RoutingPolicyChecked: jpLUE0QABmtqj/dNn1syS60tOl5n665LgIyhe2KkYCXJwL1eDZ8c4RGWxanoqP14B2WLWu8ypa8wiB26CCyFQjmMTTnXkB9383MPEadadg8irOk+C/ODUw27I7DuV0pzSCQZYDVgqOEC7/Y9bGGvxJYvIMJcAbiA36aQZyzrRGNc2YeakMcDYAxe1CWmWH+XP8+m/WbVpyk/Je8seVgXQLHItVZ6DIn9hI7GOr02Zyo+j1UNkTD7QhYxrzl9+5YHhk6GSlqVR3E4v7PW3bAfBGL4FQmaeWeu/PENyntFJdf+NBRp+0OsxBqDXSviwvH5rZWV9eYRH3ZBEFiudsi8WA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 95cec48f-1b6b-427c-1260-08deb13dbaeb
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2026 22:19:42.3058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2h38OZzudK+b33deHs7j4UxlgnRLMUMljTwoLYX5tQ6KkDqBvqUjIzhI+4Ohw1OU3c2VPKXSGHHMVrUvB7fFKMyOPrkKP/VJekxlUS2KCt0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SABPR11MB9963
X-OriginatorOrg: intel.com

Hi Tony,

On 5/13/26 12:51 PM, Luck, Tony wrote:
...
> Are we out of the woods yet? Applying these suggestions I now have:
> 
> 	/* Ensure root kn remains accessible after mutex is unlocked */
> 	kernfs_get(rdtgroup_default.kn);
> 
> 	/*
> 	 * Make backup of rdtgroup_default.kn just in case one of the
> 	 * following flows (that sets rdtgroup_default.kn to NULL) run after
> 	 * the mutex is unlocked:
> 	 * resctrl_exit()->resctrl_fs_teardown()->rdtgroup_destroy_root()
> 	 * kernfs_get_tree()->deactivate_locked_super()->rdt_kill_sb()->
> 	 *	resctrl_unmount()->resctrl_fs_teardown()->rdtgroup_destroy_root()
> 	 * These flows would not actually result in rdtgroup_default.kn
> 	 * being removed thanks to the additional reference.
> 	 */
> 	rdt_root_kn = rdtgroup_default.kn;
> 
> 	rdt_last_cmd_clear();
> 	mutex_unlock(&rdtgroup_mutex);
> 	cpus_read_unlock();
> 
> 	ret = kernfs_get_tree(fc);
> 	/*
> 	 * resctrl can only be mounted once, new superblock only expected
> 	 * to be created once.
> 	 */
> 	if (!ctx->kfc.new_sb_created)
> 		resctrl_unmount();
> 
> resctrl_unmount() clears resctrl_mounted, so as soon locks are released
> a new mount attempt (maybe started a while ago, but blocked waiting for
> the mutex) can begin. I just want to confirm that won't stomp on
> anything left over from this failed mount that was waiting for this
> kernfs_put() to happen.  I think it is OK, because the new mount is
> going to allocate all new structures. But there's been enough layers
> to this onion that I'd like to confirm.
> 
> 	kernfs_put(rdt_root_kn);
> 	return ret;

I agree with your analysis. I also think it highlights a sharp corner
that may benefit from a comment. The rdt_root_kn is intentionally a local
variable and the comments above explain that it is needed because of some
flows that may set rdtgroup_default.kn to NULL. Based on the existing comments
a reader may wonder why this cannot be optimized by using kernfs_root_to_node(rdt_root)
instead of a local variable and that would be a problem in the scenario you
describe.

Could comment changes below help to clarify the motivation for the reference
and provide enough information to support future changes?

	/*
	 * Ensure root kn remains accessible after mutex is unlocked so that
	 * kernfs_kill_sb() can run safely if called by kernfs_get_tree()'s
	 * failure path after creating a superblock but before taking reference
	 * on root kn.
	 */
	kernfs_get(rdtgroup_default.kn);

 	/*
 	 * Make backup of the current root kn being created to be used in kernfs_put().
	 * The additional reference taken above will prevent the kn from being freed
	 * before kernfs_kill_sb() can run but rdtgroup_default.kn may be set to NULL
	 * via rdtgroup_destroy_root() and its backing root (rdt_root) could be overwritten
	 * before kernfs_put() can run.
 	 */
 	rdt_root_kn = rdtgroup_default.kn;
	...

Reinette

