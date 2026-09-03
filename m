Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A42D4DA559
	for <patches@lists.linux.dev>; Thu,  3 Sep 2026 15:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788449373; cv=fail; b=qtJkjXu55dsqxMA8qQfRTZBD1Q4gEz/G6Lm/q0YommiULdufYyfjTTJfYyDCv24Xd20cxc77NIhojAsIv4iMFaDmUfinnWSecj+xD3rqH937mHc0FrqpGiQjsUkXpWxRgURI0t3jge9tDZlJxyQ+tBuARgw4iwg6DLYX/MqJVvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788449373; c=relaxed/simple;
	bh=3uZYI04BWpNgT6aywKileGINYcAKaxXYp/QWkXDx3Uo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M72vLZcO+RNUrfy5E6ZyXqwMNI3dFvE36noi/TuijPi0Uu+z+15wf4VOK/02Lt2Wog8mO0TgBJ7s4uV74Ay4Lm5rnUAzyFRvjl9HuBPZJ5Iqnb2fhOCL7OsfAeZtK7IdhVi792MVmBowZA89dwIZMaTVwhdZcEC+/Inv6JuBuN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jzpB09O0; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jzpB09O0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788449371; x=1819985371;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3uZYI04BWpNgT6aywKileGINYcAKaxXYp/QWkXDx3Uo=;
  b=jzpB09O0enJqD50gLz94qQ69JXzxRiW/rfymgPKIORb2EegxGSLjNw+A
   3bHJWM43KlDjZkOfk2VoKxkcKjNC38VUsL4ees0MZ8+Ky+FC5Bf4GH7N+
   zzSSkiEkvZdnka8TuoHlJLU0ScO8efSZd8dF3A9Pna9YMZGKEzElZwsnC
   zXaaIVhPHdSnksA5TrMl4oR5Xtbq/kxbEGjIbuR45mSSbwA1rUyOnBU/n
   phq7T1EJqolHGjeLTOMw/Gd2eGbw3WPLQuPByIWWLSHzAVlGvrLv/Rmjc
   Qrb3427UAwBaCOXOqC1LNtGq0pLKHEJdlyulDShz8RUYTSb3pLdXQaN6E
   Q==;
X-CSE-ConnectionGUID: MMdQ6OwfSBCwEXWofEJGzA==
X-CSE-MsgGUID: PqsSIHUhQ+2NLwJ9ST1IaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="100450959"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="100450959"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 08:29:30 -0700
X-CSE-ConnectionGUID: znig0aIWRGCuoZOOpLPcmw==
X-CSE-MsgGUID: nHm9tBOaSs+CXr3LbUBEIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="270296016"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 08:29:30 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 3 Sep 2026 08:29:29 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 3 Sep 2026 08:29:29 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.0) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 3 Sep 2026 08:29:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xbX9BeqAu7q0e226qDJ5PUeHvGFqZHr/76o6pehHfasKCnCB7OJt52EkQJpRa1IMsJmHccdNLTTN7KixtyKN17fNUt8tyrbmPpv7MZ46OrYYFSGA4QD/lv12kikXsMcCINymEeC7Q2iGqz1f5ePhh6mab6yy7suqi1rEK06RJL6Inhtx1oc6PPoabv+p+DY/U6rJTuqrEKXJr5OFTY/tXo1ELA/gfp5o5wfPmv8NrRTJScMJXpYorcJi8ZOh5wg+H7TdZyrKFswtLEA4t3t53rMDuqjeL78dWZOvNC4CBqnReRU2NfCSAYGbc1+UNZISTzbPBSZCbNamKCTQSi6CHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rSKS2Xj9bEjBc5cAAMBUMSaWK9qsok6hf9c3xY4y5uI=;
 b=ksINWlC1bRDFk8eCeqYhhaTG7kaJmTBxZfFPityCT5C/FBglLkw8yiySJ2tv5uQvjJYmG+yZzX6hij/rdPh4ADjLAHzuwxZCX2QHmeWr4X6SZOuygGe8/g2CtDgTS/o4ICss2wbwGINyC4gK5dzJg91mMELmKW3Pzw6K1W8PfECh3UfQaVtgne1zW3ld9P1pjfkUJgKsAKjmdNJOemVDVAlsXGGtIiE/0d2aHWmE1u8HgJ1aHJois/mRQkhKXZ2K7fPJLaw6180htIRTJqY/th00qg7HXvEhz9dcUCrwC3Vp/gV4PcO8DUh9vbsZGZaopc51fI6sTnr8VQ4dW5WPGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SN7PR11MB6948.namprd11.prod.outlook.com (2603:10b6:806:2ab::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 15:29:25 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0360.008; Thu, 3 Sep 2026
 15:29:25 +0000
Message-ID: <a492ffb3-c12e-4986-8f36-c907382c67e5@intel.com>
Date: Thu, 3 Sep 2026 08:29:22 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] arm_mpam: resctrl: Separate MPAM domains
To: Ben Horgan <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <fenghuay@nvidia.com>
CC: <tony.luck@intel.com>, <babu.moger@amd.com>, <yu.c.chen@intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <85ca29e89eacf12cfa7071249419e7cadb8f0691.1788220029.git.reinette.chatre@intel.com>
 <0b0eef2d-ce3b-48c8-af08-5889e7396e4f@arm.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <0b0eef2d-ce3b-48c8-af08-5889e7396e4f@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0073.namprd03.prod.outlook.com
 (2603:10b6:303:b6::18) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SN7PR11MB6948:EE_
X-MS-Office365-Filtering-Correlation-Id: 25542118-5b08-486c-f639-08df09d02281
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|6133799003|3023799007|10067099003|5023799004|56012099006|11063799006|18002099003|22082099003|4143699003;
X-Microsoft-Antispam-Message-Info: DqqdqNR5u4aVKzj8w+uZ5C/w+LXvDlFQ9s7179iIgRgPBG6nxmGcguk7niqoJJZ2E8hxwQGzTMcdu/JDavPhGeK5Tls59RnmSzUykaj5/LSOpmHWSyjI2TQX3inlW9+FTESYtBpaSbYrULqBMck+wOM2EVDue0YxSclcpUMukNKSTfQhIX6RwMShChznMxR5O7RHbzAvxqMHxNV30DElfzMDzPAbbmS1IxcMYuj+lr2DDV0PV3sTJAFKvUCHc8YuaYx45bO0muqvlUEIm6OwG+CYEOWxS2gZD4EXTPioLNk/Xx9wSWtwyT5fxPCtucqFyBg+ZxfT6wo4/mFn4k6Mj02AVgkwPvnoxvDJdyVMcbg54nl60IPxuy6euGRZYsMM+yhREYNwuIV9gG0okVffyEzl3b1h2WyYKodNe+x/09b5j8EhLQaFTgyQEj+n6HBR9SzIYkHQ5VvWb4+d+ivsI2zva/FYF81zGfd2uQTVZyvJoPedsA7vNYn64GE+kD9hRP+vQdpqyGSujmPs91kEukBlz+QZ0wkYPFtw+fgjIsiO9wpYwwOt7aQCpNag6xwBfY9lVWuNjvOjsS3oJEB37NbDtA7rV1CoTaNBJMpCCwrwMA0flA+CXAzIK/YErsEIZOWTDmO4L4JM+bHqtiopTrBeX1I2oJ77dA0VPaDOakQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(6133799003)(3023799007)(10067099003)(5023799004)(56012099006)(11063799006)(18002099003)(22082099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RjRmeEFNMG42bXNHK0JXUCtzckdlQTM2cTcwYnVnKzR3K0J1emlmRnVNR0Uy?=
 =?utf-8?B?WGkwOVEyU1VoU1lPeWMzMmszSlhJNFBqb2psSWY1dEZGbE1EQnhqa1lNUm8v?=
 =?utf-8?B?OFNzY2pnVFhhM2xZMmJWSTFqcmUxMDdOMG9wOWJKb3h0VTErTnJnTHZLSisx?=
 =?utf-8?B?TVdBbWVhNmRBR2FuYUJXWk94S1Q2VmtKemlIa3AvMFBFdGtFK041QStkQ296?=
 =?utf-8?B?b1EwVGI4N0dURWVIMnhBOVpMT2tPY1BMb3VSclY5NWZuS1lUc1FqZWZOakZp?=
 =?utf-8?B?a0c1Nlg4RElFeDQ1Nng4ai9Hd3EwYU9rdUE3a0VQOTc3dW1LcEpGMVY4azdJ?=
 =?utf-8?B?TnpCK3VrMDNWUDVZbU5ZTld6Q1FFZ0FUMC9iNWJqS2ZnbHdiMGhoU01MQmhv?=
 =?utf-8?B?MVlEL3Z2d3JNVE54MjJaVlAzbTZ1aTcwdmxOcmh4aXpXTGc3MjdQTnhJbmxI?=
 =?utf-8?B?V0JvUXlFZGFjd2NId0FnOGNWdUZPdjBYWFphYUFySkZON1lpN3JZMTQ0K3pw?=
 =?utf-8?B?WXlxZ1ZON0gwdUtkdmNIWDRCLytNZ1dRdXd5SWhEaVNOY1N2UWxDZGwrQm0y?=
 =?utf-8?B?YWQ3cXJHQ01oWk1Mb3RIOGFkNm9NTy82R09xZEdJV2JqT3RDY1ZGdm9BT2tI?=
 =?utf-8?B?dWo1ZUl5RWtqNzVDZVVVYVNwZW42WjROMHhpVWV4UnAvVVduWFE2SHRrTE1o?=
 =?utf-8?B?c2xUbWo0TTNyM3BtU3B3RnllMlZmZjVqNlo5QkdzczNiQ3E0dHcvMjhtWTJT?=
 =?utf-8?B?dWtyanZBRFJCUWoweTFBZTcvN3lwVHlJUVduSXhXMkVob01TM2dnU1JNWHNH?=
 =?utf-8?B?M1BlNnEyOEZhVTBueDdHVnd1TXgvVWlQV3hlTWVOdEZNdmVhSXBHNHpDN1Jp?=
 =?utf-8?B?UHhSQktsZ1JwOTZkN3FnZnNrS0RBTm9EQUxTNEt0RnBPaHZTRUdoYkN3U01r?=
 =?utf-8?B?QnUvZ3VCSzFpRU1WZGlBdHk1UkZBeVl1aDBLZXlpSFFpZGUyUENCY1BxcVZF?=
 =?utf-8?B?d2dsMjZFOGpqS0hBRVE0V0h6RDJMRkNhYWdtTDJBQWprQU5LMTc5T21NeGF0?=
 =?utf-8?B?L1JzSExpWEJ3WU02QVhoWVVSb3oyanBRVW1EYytkbEIzaVlDRjFxOUlkdUcy?=
 =?utf-8?B?VlRWSkpjajRSNW9PVE9rVjltdDVkNEFEZ2JNd1B5NXZiZjhuRDY3RFdtazVI?=
 =?utf-8?B?TGNBUVdXaC8ybldEM05wZHE2K2NPOXdUTXF0Rm1ranpnN1VmTUpSN0U0bzBi?=
 =?utf-8?B?R09EcWJiRlJLNUdJQXNFWnpMME42dW9nTG5yQ3hueFdWakVXTGJtU2FGMzNx?=
 =?utf-8?B?ekU0RHZBYzVKZXh2ZkhLV1ljT0ZFbnpSbjMxY3pPSjVIZ1JXY2FWclNMdWx6?=
 =?utf-8?B?OFJrL2srYVBLWXVINUhzdlRSLzdRNWRJZit5d29vbEdDT3grblJORHJXc3Iv?=
 =?utf-8?B?aWNFUkU3WUpGWmtsTnk1aE56TU1tV2JJWDFnVE9IbkRubDI0SVpMTENjUFoy?=
 =?utf-8?B?SEhERmRQOGRNeVVOVWhHSmNheGV2R0tockw3Wm9wdVpCa1VrelRLYlNzYXJh?=
 =?utf-8?B?dWRzZVgrbldTMkxUYjBvUm92WFh3UmxaRzFKM05KRXFSVHdQZk9PQ3pKc2Q2?=
 =?utf-8?B?VnZDMU9ZeHppMVNna2JUV2lJVytrNHcxUlk1K2lzZ3NmdWxNbm1vQjRHWnA5?=
 =?utf-8?B?RXJKMENOVkRoTW5iRWVRNUp5eVV1ck9XcTBmK3I4MkF3R1RKVmZlMkhDWSt4?=
 =?utf-8?B?ZGJDSjloaDV4WFJiMFk1U1haZTdNWW55dUVqSWJxKzlHb2NWRFVzWFBPWG9s?=
 =?utf-8?B?WlVYdFVFb0twTk91WTh5b1laNGtvckNoeUxQMlpsbUVheDNBUnFYblJtZzZQ?=
 =?utf-8?B?MXIxT1laL1dUbWRMb1ltNzRjenNubnVZRjRnZEtrK2RjYkkvQ2UvZFJ4Z1pK?=
 =?utf-8?B?Q3pYUlo3N2ZIM0JVRkNCdVBkZXBGeGppTVJzMUp0ZWFlZkNTcU1KOTVHcGNN?=
 =?utf-8?B?VW4xKzMzOTZ6UVBpTG1RTU9IR1JaV1BvV05kN0g5Vm5wcDZjOGVzS2ZBY2Rk?=
 =?utf-8?B?YXlQdFZLTWQ1Mi9lRmw1dG50eG1MOEU2QmViMFJSNTlucmNkQkh3ODhUdFNv?=
 =?utf-8?B?M0tHZ3h3eE9HSlJWYVFteW1HWUxGenJTdFhSc055OEJrcEMyTE9iU01yMXFr?=
 =?utf-8?B?Z0l4QTBxL0Y2WXMzRnRTeURSVTlQcHdTcWJKT3BIVUVGNXo0ODV4WlFnamhJ?=
 =?utf-8?B?K05hNlphL05DWGYwQkd0Qm1qRS9iRWhwUEtLeXlEVFNpcVdSUWZzQkMrN0tK?=
 =?utf-8?B?citYd01FWS9LMktzdTJvenk5MTYraW5BcVdnTWhLSXFsSGszTWFId3JFZVFp?=
 =?utf-8?Q?n2ldXqHWMka0YLCE=3D?=
X-Exchange-RoutingPolicyChecked: H6pcbXHgk8Z8KDSRjNqRIL52oiZIHPkW/H6S5AAj0q7Zt+U8HiHtSbfsRa4pG7BGRBR1X72Ut3Zql89sApbYuT7xVbfUi73kv/EWzla7UXdMxnf99gKYaebRQHuMePK4r9v0C95UBVRAOihvgtGGILW5WM9MmeIKuiBe8TKo5knRevhKVC3EwHoAUuCqG9ikTZJ0M1tvchnZrx8BP/2p1PqxlZfwFntb84uS7HgDQINYiscJ9J3Mf27QkMFLKa0vRcNRor6oG32q54JV/emDqamKgIJgopMS7nACMkH3RitSZDIm4djek680t0LMvxftxCMuqZiOjLDbS+YRkjEBww==
X-MS-Exchange-CrossTenant-Network-Message-Id: 25542118-5b08-486c-f639-08df09d02281
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 15:29:25.0330
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LGK7PCZKQeWtJzaSM4G81MjARZ/23idXybgWo2qWoz+TL2OK75rys/Wut8b+73klMEUQhPvcs3FsqoluznZstrgwQyzfk4fPYBcPeuIrVdo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6948
X-OriginatorOrg: intel.com

Hi Ben,

On 9/2/26 9:10 AM, Ben Horgan wrote:
> Hi Reinette,
> 
> On 01/09/2026 00:54, Reinette Chatre wrote:
>> A single struct mpam_resctrl_dom instance represents both an allocation and
>> monitor domain. When a system supports allocation and monitoring a single
>> struct mpam_resctrl_dom instance is created and then added to both the
>> monitor and control domain lists via
>> mpam_resctrl_dom::rdt_ctrl_domain::rdt_domain_hdr::list_head
>> and mpam_resctrl_dom::rdt_l3_mon_domain::rdt_domain_hdr::list_head
>> respectively.
>>
>> Representing both allocation and monitoring domains with a single
>> architecture domain requires that allocation and monitoring be done at the
>> same scope and also requires a resource to have 1:1 support for an allocation
>> control and monitoring. The latter means that when a resource supports
>> multiple controls for allocation of a resource, for example a "min" bandwidth
>> control as well as a "max" bandwidth control for memory bandwidth allocation,
>> then each domain supporting each allocation control needs a matching
>> monitoring domain. This does not accurately represent the resource
>> capabilities.
> 
> For MPAM, the scope of a control is determined by where the MSC are in a system. For the MSC in the
> L3 we collect the MSC in a cache instance and call that a component and collect those components and
> call them a class. Similarly for other caches. The scope of a control is based on the component it
> is in. Hence, we are unable to use all the flexibility that resctrl will offer.

Thank you very much for this insight. Although, to me the final sentence is an
unexpected jump from the description since in my view resctrl is catching up to
what MPAM is capable of :)

> 
> For MSC at the memory we currently only consider them for resctrl if there is only one memory
> instance (a single NUMA node) and that this corresponds to the topology of the L3 in the system (i.e
> only one L3 instance). This will change when NUMA scope is introduced to resctrl but for now the
> domain associated with the MPAM component for MSC at the memory covers all the cpus and in such a
> system there is only one L3 domain. The idea being that memory bandwidth controls at the memory are
> effectively the same as those at L3 if only if there is only one of each and no other caches in
> between. The initial MPAM driver put up for upstream review was more lenient than this and so the
> tigtening up ended up leaving some complexity around that is no longer needed. I hope to simplify
> this in the future and hopefully allow MPAM component to be used more directly to resctrl domain.

For this I think this change is helpful since it makes it clear that a resctrl
domain is associated with an MPAM component.

> 
>>
>> Split MPAM allocation and monitoring domain management to enable a resource
>> to support multiple allocation controls. As an initial and knowingly
>> inefficient approach, duplicate struct mpam_resctrl_dom between the
>> monitoring and control lists while only initializing the relevant member
>> structs.
>>
>> The goal of this conservative approach is to use something that can only
>> be compile tested by me to learn from MPAM folks on what the best approach
>> should be for MPAM to support multiple allocation controls.
>>
>> This patch is extracted from the "Generic schema description" PoC [1] that,
>> among its various goals, aim to add support for MPAM's multiple controls
>> to resctrl.
>>
>> This has only been compile tested by me but Fenghua's work to enable
>> MPAM's CPU-less NUMA nodes [2] is using it as a baseline.
>>
>> I did consider a new layout as below but there seems to be a contradiction
>> in mpam_resctrl_alloc_domain() where domain addition for allocation as well
>> as monitoring domains unconditionally fails if there is no "ctrl_comp" while
>> a comment when adding a monitoring domain states "there may be no ctrl_comp
>> for the L3".
> 
> Hmmm, confusing, but there is no real contradiction. Just some bad naming.
> 
> Quoting the problem area:
> 
> 	ctrl_comp = NULL;
> 	guard(srcu)(&mpam_srcu);
> 	list_for_each_entry_srcu(comp_iter, &class->components, class_list,
> 				 srcu_read_lock_held(&mpam_srcu)) {
> 		if (cpumask_test_cpu(cpu, &comp_iter->affinity)) {
> 			ctrl_comp = comp_iter;
> 			break;
> 		}
> 	}

Staring at this more above looks like an open-code of mpam_resctrl.c:find_component()?

> 
> 	/* class has no component for this CPU */
> 	if (WARN_ON_ONCE(!ctrl_comp))
> 		return ERR_PTR(-EINVAL);
> 
> 
> In mpam_resctrl_alloc_domain() this initial 'ctrl_comp' check ensures that there is for the class
> associated with the given resource, res, a component which includes the given cpu in its affinity

Why does the monitoring require that there is a component associated with the resource as
opposed to only relying on the component associated with the the monitoring class, specifically
the mpam_resctrl_mon::class? (more below)


> mask. The class is all the L3 MSC or an equivalent of the same scope, see mpam_resctrl_monitor_init().
> 
> 	dom = kzalloc_node(sizeof(*dom), GFP_KERNEL, cpu_to_node(cpu));
> 	if (!dom)
> 		return ERR_PTR(-ENOMEM);
> 
> 	if (r->alloc_capable) {
> 		dom->ctrl_comp = ctrl_comp;
> 
> If the resource is alloc capable this component is used as the domain ctrl_comp.
> 
> 		ctrl_d = &dom->resctrl_ctrl_dom;
> 		mpam_resctrl_domain_hdr_init(cpu, ctrl_comp, r->rid, &ctrl_d->hdr);
> 		ctrl_d->hdr.type = RESCTRL_CTRL_DOMAIN;
> 		err = resctrl_online_ctrl_domain(r, ctrl_d);
> 		if (err)
> 			goto free_domain;
> 
> 		mpam_resctrl_domain_insert(&r->ctrl_domains, &ctrl_d->hdr);
> 	} else {
> 		pr_debug("Skipped control domain online - no controls\n");
> 	}
> 
> 	if (r->mon_capable) {
> 		struct mpam_component *any_mon_comp = NULL;
> 		struct mpam_resctrl_mon *mon;
> 		enum resctrl_event_id eventid;
> 
> 		/*
> 		 * Even if the monitor domain is backed by a different
> 		 * component, the L3 component IDs need to be used... only
> 		 * there may be no ctrl_comp for the L3.
> 		 * Search each event's class list for a component with
> 		 * overlapping CPUs and set up the dom->mon_comp array.
> 		 */
> The MSC at the L3 may only have monitors and so no control component.

The code that follows is:

        for_each_mpam_resctrl_mon(mon, eventid) {
                struct mpam_component *mon_comp;

                if (!mon->class)
                        continue;       // dummy resource

                mon_comp = find_component(mon->class, cpu);

Is this find_component() perhaps sufficient by itself (without the earlier "ctrl_comp" check)
to determine if there is a valid component associated with this CPU to support this
monitoring feature? Although, as written it seems that it is ok for mon_comp to be NULL?

It is not clear to me if a mon_comp of NULL is able to handle all scenarios since it looks
like mpam_resctrl_get_mon_domain_from_cpu() and mpam_resctrl_online_domain_hdr() does not
consider the component at all. Would that not cause monitoring features to depend on which
CPU of a domain comes online first?

Could mon_comp perhaps be required to be !NULL here as a replacement for the earlier
"ctrl_comp" check to ensure there is a component with the CPU in its affinity mask?

                dom->mon_comp[eventid] = mon_comp;
                if (mon_comp)
                        any_mon_comp = mon_comp;
        }


> 
> 
> 
> 
> 
>> 	struct mpam_resctrl_mon_dom {
>> 		struct mpam_component		*mon_comp[QOS_NUM_EVENTS];
>> 		struct rdt_l3_mon_domain	resctrl_mon_dom;
>> 	}
>>
>> 	struct mpam_resctrl_ctrl_dom {
>> 		struct mpam_component		*ctrl_comp;
>> 		struct rdt_ctrl_domain		resctrl_ctrl_dom;
>> 	};
> 
> What you have looks to work for me, with some local cmax, mbw_min, mbw_max additions but with the
> new layout also works. I gave it a go with this mechanical patch which uses the new layout.
> 
> Thanks,
> 
> Ben
> 
> commit c67c624149474b96e07ccedda11a11ce968e5599
> Author: Ben Horgan <ben.horgan@arm.com>
> Date:   Tue Sep 1 17:36:29 2026 +0100
> 
>     arm_mpam: resctrl: Separate monitor and control domain structure
> 
> diff --git a/drivers/resctrl/mpam_internal.h b/drivers/resctrl/mpam_internal.h
> index 3304ef64fcae..855f06657554 100644
> --- a/drivers/resctrl/mpam_internal.h
> +++ b/drivers/resctrl/mpam_internal.h
> @@ -393,18 +393,14 @@ struct mpam_resctrl_ctrl {
>  	struct resctrl_ctrl	r_ctrl;
>  };
> 
> -struct mpam_resctrl_dom {
> -	struct mpam_component		*ctrl_comp;
> -
> -	/*
> -	 * There is no single mon_comp because different events may be backed
> -	 * by different class/components. mon_comp is indexed by the event
> -	 * number.
> -	 */
> +struct mpam_resctrl_mon_dom {
>  	struct mpam_component		*mon_comp[QOS_NUM_EVENTS];
> +	struct rdt_l3_mon_domain	resctrl_mon_dom;
> +};
> 
> +struct mpam_resctrl_ctrl_dom {
> +	struct mpam_component		*ctrl_comp;
>  	struct rdt_ctrl_domain		resctrl_ctrl_dom;
> -	struct rdt_l3_mon_domain	resctrl_mon_dom;
>  };
> 

Thank you very much for trying this out. I find this layout better since the
architecture domain structure only contains those members related to the domain. 
I see your snippet is based on the PoC, would you prefer I incorporate it into a new
version of the PoC to get some more testing or to create a new version based on
current upstream so that we can work on its upstream inclusion for the multiple
controller support to build on?

Thank you

Reinette
