Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195593C5546
	for <patches@lists.linux.dev>; Thu,  7 May 2026 15:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778168926; cv=fail; b=Ak8AIAeVMZA+LB+5J7hbt9AhJ9ZwPCq99/jj2+YWYxyABERKWgFK5wABVQHopEqc4MjXSbpgdj+/T3cGLW7coi1ZhaJpoZctiGsoS2LMGCQKqvuFTH5FHe/xQeFPs3iAkxw6hH1LNbvtkqlPS/EWO7C4j/cMOVvdrkgjaIK6FyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778168926; c=relaxed/simple;
	bh=/ijgvxJk1MMiaETryBgv5vA2QJpgD53MsBdPKtuBOY4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jhes2Uw6x3WvXE4GbPCV7z6o4njVP5v0UEKtfyoyrRVd3uPReQApSOGFFkoeFI4LSNMjEiTZFhcoKbPRXibkbvH8qQwbOXar9jVw+xzPn381kEsTqkQyIwWIjRzILa4XHMdPAdd/rXq1m1b6UzvNAToS1h76R+RZ1RzOLu7aLpg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EiSFfDEt; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EiSFfDEt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778168923; x=1809704923;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/ijgvxJk1MMiaETryBgv5vA2QJpgD53MsBdPKtuBOY4=;
  b=EiSFfDEta5eQ3mJhW39sV8ycM7cVMBEMNtXScXYyX5fgHDf6mupxaZLS
   M/R7x6aHW7ALUHRB9RThkzRk8Tq3hjKRXQgRJp4znTC5GbEOQodyVzB2e
   trKiO37i6L03D3WXEtS/ijqVaCec5+06Y+I2YHI258hWTfFjUcoD7gEsO
   HF2Wp67MKO22DV8eKqhziEyQISNHldVoi0AZwkMPQEF3a7fTNXspkTjx1
   f1miQAeUolwoY4T2/Hc2Cfejg7Rnu8Lq6GqUhWCgwF4K8saJ2nHwq4hxN
   ZZey+WNR3OaqcQ8d8GIUZBDhpmaGJcBbo7qMUhlseOUxflz5jO4TYjosq
   A==;
X-CSE-ConnectionGUID: XZRvr+JRSxGwlpg/hsMhdg==
X-CSE-MsgGUID: CJj40EswT5+laMAXRBsOEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11779"; a="90581772"
X-IronPort-AV: E=Sophos;i="6.23,221,1770624000"; 
   d="scan'208";a="90581772"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 08:48:43 -0700
X-CSE-ConnectionGUID: yKzXvGMkTm6tNLKOeiX9TQ==
X-CSE-MsgGUID: 0KUbh2PbRuKZHFO88vLU+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,221,1770624000"; 
   d="scan'208";a="241497572"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2026 08:48:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 7 May 2026 08:48:42 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 7 May 2026 08:48:42 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.71) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 7 May 2026 08:48:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bG9Iv6PNiZFkl0zhufrwDjO8neVgvv+AQEhmqtwrOIELz5zfVxTqmzhyIhs6lNny6Edh9dFLzcybliP5LasLnrwnoWqiJdcVC3zYsGEUhi1gGYuLFH0K90SOKCLE/VeG9+2lVYqVY4gr8ptbKFZCc9Z12Q8ulGcJJuzFH3ZMLNyZ5XT9G0eSihsBREpJCSoxlk+Ql8XxePzgbWbLq9VF5AN4FkpLhOBzhfVIpVDodRnum/+Dh2fDRb2MC+DNeHa+ITZbPAG/rMLU6AOt/ggkFwED2Xf97T8NPZdJMIADMbTOSeqXJ+WUnIUPxnAQGEz5L52lg/qEuqnRWNSx6nLUfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yYv0+vUaUCxNQvVw71UAqA+TO9ltOXr1QsL+YwlxHcY=;
 b=mApDFtNydH5svB6m2lZwi3LRevOzqj31c4PvXOWFVb+KJ6fM/HGLsqrvBPehSK91tGME6TUHQRLtugJ8j+hi/hlyD1aexfuSwAxjaBN738hn8qf2raTw6qdNSl42x8xraqla1D3ef03zLm4eiqMm/Amm75dk3h3hGcdb3oeeTJCsyVNXo2Y6lIXPKeulYK7rCAePJ04NAJ1L1Rtl6mBvgBaVQ4fN4TqKG2q/GQS+OpFXKKSCodu5EKVCYQ/0TfCQKaIaKKMrTDaWkZFe06Gc7WdBQ59JoL2sXwpvuUZSUgDhr8+D5iNMfOuXCJjUPDg+hG8smFUZU3OiEtahiClIVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA4PR11MB9299.namprd11.prod.outlook.com (2603:10b6:208:565::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.17; Thu, 7 May
 2026 15:48:38 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 15:48:37 +0000
Date: Thu, 7 May 2026 08:48:36 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Fenghua Yu
	<fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH] fs/resctrl: Fix use-after-free in
 resctrl_offline_mon_domain()
Message-ID: <afy0VG8ctiJBPyf7@agluck-desk3>
References: <20260501213611.25600-1-tony.luck@intel.com>
 <2236fae5-7e66-43fb-ba05-76fd4434e2c9@intel.com>
 <afkizhrSwJkiLD3j@agluck-desk3>
 <3f13c7e4-3812-447d-8c42-b28fd6b9d0fa@intel.com>
 <afoesuWB8RezVLrN@agluck-desk3>
 <7fad1d7d-c892-416e-b97a-a230fd43f2a4@intel.com>
 <afp4OkwtPpyIwAC1@agluck-desk3>
 <d065f7b7-daac-4e45-b7c9-69175dfb43a7@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d065f7b7-daac-4e45-b7c9-69175dfb43a7@intel.com>
X-ClientProxiedBy: SJ0PR03CA0115.namprd03.prod.outlook.com
 (2603:10b6:a03:333::30) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA4PR11MB9299:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d8b2a9b-e506-4c88-8a9e-08deac501a76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: bkoDyKmcKNdKE2itgODJiHudet5BxylMafH8t/tqEWNP4t7D7XpbdcJ7zBYo6EWqHS0hLxgL9qQTqUoxtmEZbYDyULIHbILg64Y1WK0xFxjpJCbJI+ghWifHhAzdDMMiIWPUO2U6xGqDtt7Px8oi7XHaCgkk3Pu0NVuq4Gt269YDnzESc/czgDuRI4QrKSR/7DRhibdPf4PzRtesfkFwVgjE8v+JkqbwCz0CPCiYKcZ22l4x9aYFKhUMl/Kcn+eFQEhyU0Z3Ed9xPuzc+9jZEJ3SxH7aO5sDERvyU1aV0ewPFbOEl5b7YVEpAK5RGte2r919HabystCsSPV1XXxNxXK5R5D3zyKEOlJLMFXEEyW9p3yey2Xkoq7Gpy156/pyyNCc6Y9q63l9ZLDYkrrq0a3VGky9xNjWOf30cBv31uMnL4OMEcund55wsulXVq5MMevGsYm5Ck9rnUYTEIVQeXZex45Xq2RPaNJgvhuVhckXCXr/yoNjj7bRUSy0GOzkQYPYlQxg9uSwscr3i0r6k7t22dIhgLGPUnCmjoHo6vZwFjhw598NFD35N1Aqhs+pHT8Szt90sLgF72mhdShszEJvLQLejOWcQmGNFftsjFCV78gRSLRyf4Ynram38Mpwk4UwATrkV5QYecnMKHh25O73Q/D9HYZFO7ING7jD1xB7+goFTKO1z4T8oI3gDB/W
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Pk3US+0/s6u+gSNqJRrhqCtweP13NH1VLilQiIMNdFuWy1yyq4XsrLxKdV2k?=
 =?us-ascii?Q?y5yYAIQiyteJov1BjQFfHh0C/Jg1PAV+7GwYJLW+xvhy9NYVy18vX6Hh827r?=
 =?us-ascii?Q?XDENjenIg+AD0B9XwQhc176xv2nl9pxYXBsaIbSY/UiP6wnQ1IcEMr7gtLuk?=
 =?us-ascii?Q?BwUj58JqUVXF45ifXGbP7APrgmlY+maoM0P6NiWRzI3nVoTIjkxvWIPd3EXR?=
 =?us-ascii?Q?lobw8y/nmASism7dZpO0dFxU4ECwScJuBWFhP+GOgc3Ma4BcJiZalTQXUcEw?=
 =?us-ascii?Q?AqSQZ6cWBBTwLoRw4msQDrT/N/x2cQNOTYV6xnFzjeCFZXNuz+jG1mhZ9Gc/?=
 =?us-ascii?Q?qAz3H2muBay07a+WCq6tCpmrjS/ZccQ8XRs0ccrhkHGOyS6MshdfJxw+cvlI?=
 =?us-ascii?Q?Un77XhCllJq5tzPR99tBqR5yz50UnY8NgZrN6FatbHPeS+7dS/HQsXFp192D?=
 =?us-ascii?Q?leObwTAo6TVV+9nj92jSd2iVUaOmWaL/5f8RoCr9cQVruHDa6l2cMwYunu5J?=
 =?us-ascii?Q?iJi9kHZ6UMwsjRtwA9A+NT+6nVQ+mOKRUTnc4xRWAY5HE0eAUdlhgfeq4Knt?=
 =?us-ascii?Q?JxH5kaEz/jKXEZWuw8CWgXYN61OiwKWuH59Tav721o4HNlyteRcBtuO1KFw2?=
 =?us-ascii?Q?8PMZ7oD7D/xnbtfJ2GYAQxXTmeWkZ+1FHSkIz10raPqwbZ6lM6tIMSTqy8T8?=
 =?us-ascii?Q?Yp5nsZLXJphjwEpOkRAwXCV2fz4s1K/o4ViWMkvkXe8f3IRP/8mZFEDD3mCL?=
 =?us-ascii?Q?KoxE5qDQIZzMhJr9nNVEfUg9MAbxZ7cLRJ/R8YZnBsI5nZFIXz7l1Ez0rJZ+?=
 =?us-ascii?Q?n8+e9cgkuY6Dtfj9Fb9IaptlKQNW+albo92vTuYwTFPzzV/F1C/HvyK/j4YV?=
 =?us-ascii?Q?TYiD2xyLWLcoFl0Pi6MdGTAt2e5sI9YOzlv6/uiYh9uJBN9OAiE9ZjEvTcJw?=
 =?us-ascii?Q?2q2MD8yhCuvHhB3S5r3p+M1HM0UNkw8TgXu6Kc+mm4F+AoX7YZjv75vaeKli?=
 =?us-ascii?Q?RQKKFn1axbQrvBnRP4skm+4bXIW8DTb3jmztcqVWBSDf/BKynUXwoKKoQpkd?=
 =?us-ascii?Q?BfTb7VuPrR2gI+CNGGwFNG17SOVVSFVqhKu5Tge8bvwX/LBWj9sCJoiw6onP?=
 =?us-ascii?Q?YlUIJr1NVRbXKPuWzvyvyLH7EJPB7yo4PzAzLCcnXNGTN0B4drE7IJTNYgje?=
 =?us-ascii?Q?1XETq/xebmACPrUKKxX8e7b5E0pfqZLwpkevrgrj4ffY4bKq1k8D+vcxaeZC?=
 =?us-ascii?Q?3YddSGUYVWVe/pelQIYHvTNOqbrlCAkYit29TrwcYHva2RUSpL11BwybHfBK?=
 =?us-ascii?Q?9qPRUK7DKNhUesSlSWEECAE29cA8nyxjwcb/VsVqVIzSI8DHtJik5auqNjMD?=
 =?us-ascii?Q?pyhtcsTcD4WBBewNLjCDQNf1LGICNcaVdr947nrtavWl+ljDw1z4h2fz/rOA?=
 =?us-ascii?Q?TUcdmMFcBJ+1eK3xE7yPrN0aZTPa6n95a5kqSFNsdAxZQ1H2/R1fsK33pfj0?=
 =?us-ascii?Q?/pbxcUb742H0k4dwVQZWTt9LegSUiEsnFfdGm6O9WX4BtWbl3X7buqE7bqpe?=
 =?us-ascii?Q?+70BAhPP9VqJRZZrO46NY3w7JfiouXuRxNxlraKoPvgl3DN97PgxX1SH5liJ?=
 =?us-ascii?Q?ViFhGYhzE0qi9TparQPwIf9nkEEVk0kmePc1irtWxHA4VKaWPYWDYuYzPaVQ?=
 =?us-ascii?Q?9djJ9qDDQjC+ukDEFspa+LyUe6bjD4K6HHpzKvOFxaBP7Jv2SqXOWrzVSapa?=
 =?us-ascii?Q?W5HK7rg9yg=3D=3D?=
X-Exchange-RoutingPolicyChecked: CYKHpiT80l2uyzi2NMBpScf0HcI6GQQBtBtz7VeeVUmjeMBizRijmcaNHY8YfAkUOp25/4VQgjYFcL116zofAf7k5eMDRhWnMPzy3AHgX2tC4e+QZOZ9IrN01vk85Y8Xk+1iPObFnzazDbR4NI+KF9VNfCiyYYTrId/+k50OGHQ7bD9lH5FujnJtrvExknLx+g7ju69nAPljnb1Wz8bBxdVJqqCyEQDhj0KIp60oplyBKoso2qbCx9eX4qwfiRdw11NQvizzgwhgvsLD6fFGFJtm6GO/xBC5FRLvNvCfDjU9L/r2BisEVELi15UJM0Y//dEEeBeexSOMGikw2c1LVA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d8b2a9b-e506-4c88-8a9e-08deac501a76
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 15:48:37.7564
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bwNa0gqEgJVItw1eDoill0N9blBQ2rr/+KZ1W5T6QtvlcqltC+qvZI9rbYrd48IvMGwQMd40iE9dzsAQalQ7sQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9299
X-OriginatorOrg: intel.com

On Wed, May 06, 2026 at 11:24:30AM -0700, Reinette Chatre wrote:
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 02f87c4bc03c..cc8620ace7ed 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -4539,8 +4539,19 @@ void resctrl_offline_cpu(unsigned int cpu)
>  	d = get_mon_domain_from_cpu(cpu, l3);
>  	if (d) {
>  		if (resctrl_is_mbm_enabled() && cpu == d->mbm_work_cpu) {
> -			cancel_delayed_work(&d->mbm_over);
> -			mbm_setup_overflow_handler(d, 0, cpu);
> +			if (cancel_delayed_work(&d->mbm_over)) {
> +				mbm_setup_overflow_handler(d, 0, cpu);

Per your comment[1] should this "0" also be MBM_OVERFLOW_INTERVAL?

Does the same "delay 0 is magic, ignore the cpu argument and run right away" apply?

> +			} else {
> +				/*
> +				 * Unable to schedule work on new CPU if it
> +				 * is currently running since the re-schedule
> +				 * will just force new work to run on
> +				 * current CPU. Mark domain's worker as
> +				 * needing to be rescheduled to be handled
> +				 * by worker itself.
> +				 */
> +				d->mbm_work_cpu = nr_cpu_ids;
> +			}
>  		}
>  		if (resctrl_is_mon_event_enabled(QOS_L3_OCCUP_EVENT_ID) &&
>  		    cpu == d->cqm_work_cpu && has_busy_rmid(d)) {

-Tony

Link: https://lore.kernel.org/all/389bd92c-47ba-46af-81cb-9b669533b1fe@intel.com/ [1]
