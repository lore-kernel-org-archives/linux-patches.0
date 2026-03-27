Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9B22C11D5
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 23:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774655948; cv=fail; b=QGHyo9Vqv59Yf1KFajBrytWZ4pOFn0wqKeXxO0uCIv36Opl24OxQs0gVMHlxgxkHSsFc4c7GouGwfiBR2OWLdnTd746AQDjZiv4VHqZQedwdd1NxASGYquY61ZxKjExsJAuHYEuD+Hv0i5pbjEEEk8BHkoCp/gyiF6JvVUpVSOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774655948; c=relaxed/simple;
	bh=Eb0ZC85F+newG3K3TUr5PrqEhJKZ9B67JKmXqD+0sVY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Qjwy+mYBZze5Z2+yFPT1G94nZfkHQY1IwroBf5xs3LHCYwFB+KEUd0kYJX97gW5uBNKVzWbpLqAWsrYyV2W4GRQ/nD/elH2UpzlOPTkXfEQUgdxT2ewCv2Wmc36JLgtBoT5sDR5kSLyh7ybjWL9QWpeXMovVIRG6ZECPLwhZBes=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WTt+TbLR; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WTt+TbLR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774655947; x=1806191947;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Eb0ZC85F+newG3K3TUr5PrqEhJKZ9B67JKmXqD+0sVY=;
  b=WTt+TbLRyECRaLrncB4EroJVxBSdA7a4ZQe9KManlrizDb+MwIbcPYie
   aK9M89AaVC0XFNZVhrhkRkC7QHD1Yax1f6sJzaC6qvHL90eGJfNL8kKza
   uI/xXTrkNFOyMKTBkgskvtwS/PrF90x0KdfW/exY+7roF4czEkqKJZlWx
   I+xRWDs/3Lpvu5v9xDWCeh8uUNhhT/sOb+Z4JvDXgeEy422ve0Ncd1CKa
   u3aBCEnWNuVpaDF8TqnUV4ckEzX9gDbd2P4CcV8ORXCmUB5/MKo0PhLp3
   pQ3d9rkbKfVlKsONYUAoSwjKKT3xrXSAmnH/hZn+58ALC3yyfIyL3rq9W
   A==;
X-CSE-ConnectionGUID: kE01m1OQQvWxxDb4YPQGqQ==
X-CSE-MsgGUID: Rot92kiYQmq8KoQGhfldtA==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="75800678"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="75800678"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:59:07 -0700
X-CSE-ConnectionGUID: RHEaRBjHT+aRPRe8j3oeVg==
X-CSE-MsgGUID: enCT/rvPRFOS6j5+zaMpCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="225358520"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:59:07 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:59:06 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Mar 2026 16:59:06 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.39) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:59:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cnqjNKU2xGzwjQGPMY1Ktlwq0jXmEJ4/cz7ILlZhEA5YKavQDg2UrAgvJ+g8wqhyVQtdy7nFmh0n4wyYRSMJOPftRyZyaltspRy3VwxFbac/uwQ9NeykQEyoIhBjvF8uT9oVSrapuU58oLqhi4IDavZQ+x3RcV0zvzJCzT5ju3ZWm1qXvMK5/q2mQFvdL5q4ncUdD1+D4vvcf7h1sArI1wDhxkWGbLCQC+y86u5C2pyQbbw20og/LFgsHC1LQR7OJ+d69vH1cM3IxXHs8JG7i38UnL9eMy/WcHY8jyvOMZuvYA9LbuMQ7qcf+JtzkmmMtNfXUqxsL+X8UYBH9QyTww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dVolmXO1hGGabkjYtS4wCcwtEBVjJttwOC6oaxlfHPU=;
 b=jYFUpr+HtPZ/SXzMY7B27qovp7b1dY2Vy9UnXhuS2CoHXHOD0ApCcJyZAE6mxL/S9IOoBjzfyMOyPbBDg7SPpHse6pmqtEo0uNgJSVvHU4COrC5v8ZGWwdAPoA8PDkXSe3mYa5Ic4XXgnKGAB7B2nZAmPsWZv2OIGspW1F38dAAjptIE9dCT8Ue8oj1WThJURwb61THcFhNiv9SKYne/7qmKPKn3b857WtZV0hm1Edov9dhemPVvyZsqbDz2Y0joG5PS3XgXtHlLz2hR5/CRMJ9mxRDY2+E+t1xOVBSv4K2QP2hC0HEQNumqB+luZnlm0t+OEdTgQ76DbJon+ksc8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by PH8PR11MB6950.namprd11.prod.outlook.com (2603:10b6:510:226::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.11; Fri, 27 Mar
 2026 23:58:58 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026%7]) with mapi id 15.20.9745.019; Fri, 27 Mar 2026
 23:58:57 +0000
Date: Fri, 27 Mar 2026 16:58:50 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <dave.jiang@intel.com>, <patches@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH 9/9] tools/testing/cxl: Test dax_hmem takeover of CXL
 regions
Message-ID: <accZuj_b1kB7M4AD@aschofie-mobl2.lan>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-10-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327052821.440749-10-dan.j.williams@intel.com>
X-ClientProxiedBy: SJ0PR13CA0013.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::18) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|PH8PR11MB6950:EE_
X-MS-Office365-Filtering-Correlation-Id: 169e2f73-8ed5-415a-66bd-08de8c5ccef9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: 7FOYLXicIObj1HiRfWh7Nd9GQBskwejzspDd/AyhXChTg8SLCwJ7aXgp8IeuCC0UnVfhYSHZE3kXP8UGT2EBbyKErYGTC+aA7WAU2/Cd2VxmOrfsDL1V7cqtmRtwkP7Eub8XuAUrsm4BngzdeXJi/CZaPOM9U05JP3l+3i4mDpEaRKQmVMHYvLXpQL6te8wTtCwND9IsTksl/QAn+K3nlokNyx1Y8TjHrVycPiGLpBq9vtah8FmnRpnEWOziFaG41h/82fN5g6Wqu0mizgtQMI6qNXgDN70IEYSv9Vr2UuWjQQyiEgdXJyY/S8zu6dCUvVr9vUNkgSwzmbvZYVUFsRWl7cONacFpDhT0IhtkV5cr67RAYzM6RsgoWsn9/0Su1QX+9xn9mWMsS3EyOlYBV7HKKSUlnmUbqrKc9GYIaXJfuTWsXfjtNALvi5CqMckYeFfEDm2SaIpsXb3WoaD4vpqVjjyNGmSw5qMyuFXbHt6HHeNuRwiij3/YfEbHx/NK+gsNwZRq7ZqpfOAkoEv0PR6kYTnyxY0kRDwR7Sk4WovcneMefOrnEahkj15Kun0K7IeApsB3E9RNoy81G/3OLct62qo8BXwFOoy0DTQjEh2Vf9q/QX24BdgKuMQN9+zPSNB5rYqaGpWRXP0sf3kWm4xecIj1K/zQ/vREtp626fAzAN2hoANhXB8+rK0/Y83m0U07OLQ48hAg2hn7S0bLaRkfEvhqagmT3bJfNUxIy+Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?daNF19mAW18zGp8DznlOktQC+06eUTSAB0w1aoItMkpaa7CxF9YxGgdN9cmC?=
 =?us-ascii?Q?+E6N/9C5Ok9LJ7dDJAAO/65IxZriiw4jVpxBPmHoUVSXwiIwT0SQeum4aw1R?=
 =?us-ascii?Q?XIBNTX3cfRoGvHT1vEJMvauL2os4vtSxrexY4SSOwB5KsAXERzxSuqoxokEr?=
 =?us-ascii?Q?owUlm94GFtnlp8y38Msq2aGazMHFcbZXYxMGKh55klvr2Xa60yJ9zrRZrbFm?=
 =?us-ascii?Q?FdiXnDFyEZms3j7P0QlmhIkUSBUyryBNE0fRTNrBjDEWFV7r9jvADVNXooh4?=
 =?us-ascii?Q?AuTICMM3VMmkp00KeHlUpziQlTBO8brIHaCj07xm2jgYm+f1ZXu+LSbXlzBX?=
 =?us-ascii?Q?DQIoc21KtD2FnUP3ZhF7VNPsQZnIffQyldXWc8ANW6rCK3r4ovMyC25nGnp6?=
 =?us-ascii?Q?vvsVUxufZcS42pNe94H10kliOnrxdH31rqYH9RWG+zYXYCQBJI6ehfgpP2dH?=
 =?us-ascii?Q?d3LMTB0yBh5JGL8KwL1XpnCZCbsgLGv+tjGMr0K5BSXo7E6XTEaybC6HIXyd?=
 =?us-ascii?Q?Gp/tKRKw9va4SrLs9MEO3ZEkTvcIVASRI2ss3g9z0rYZahSWwlvYFlsFoBiJ?=
 =?us-ascii?Q?s3G3pBQmrdlbtp7svJyGNh9ARaMaB0SY/EQAxk7wM0W9GZpNC7rO0pi24pNH?=
 =?us-ascii?Q?0LNo0MSR9fIklLjz/hYGRbcA683kWgp5XavYQsgAu5xJ/2FGsx/h+az4qjKM?=
 =?us-ascii?Q?hScPPFVsSgWOKmh/2YrBkvGoQ1vgE6i0sySrGbOVpfxNM6OWQjtHczOnzvYY?=
 =?us-ascii?Q?yEjEJa+F/XeBV3o6fgFR3Ltwh6D6292Rv6+phVHdrIJGc30StfChYhbGveya?=
 =?us-ascii?Q?Ol1fhAuAOgDjQVUKDDRz33R7Rr4UKNJUGiilHQySgRuCybSfvMQ3fanFRcZh?=
 =?us-ascii?Q?hIsW+KrF/c+yEemq8AZ6pp8HYsG8rhZYw7dwjUmhqb/XDsxkckJAiAGCc8an?=
 =?us-ascii?Q?7LunL0/m71/B1gDxBtSS/TgV5cMfic+LtmqZnOZsXaDSlwAbCJ3r5tiP3QNk?=
 =?us-ascii?Q?cZYrN8l1XbfsNuwSiyf4S7uvo4okhFrcVkRAbWDK/+VKKhwE9jnA4J0Y2Iav?=
 =?us-ascii?Q?bJOoW8WZ/4usUuL9MBrCSulqDU3XfMbEL/PmqKNEPZtU6zSolt+FgeNAMLDX?=
 =?us-ascii?Q?P/YHcEjMiogA5Uv5kZiTC27ak13YmZ4ojTygH2nsCBFgFmPcB3ZMQCw/aGRH?=
 =?us-ascii?Q?s+DFNQpT17dQuRVFs4+mcukyBZdkwTYb+YMoPhvIiKGmFx3wuG1tUoaYXpm8?=
 =?us-ascii?Q?bwkSioA9V2wiTmat+mEbokTYdQE7DkoRKyQYchAvS1BpyAhwlPHuap1Zyw0D?=
 =?us-ascii?Q?ROAeu5ZKrbqgq18x2oFnmI3n3JqtWKJmkEBQJWXD2wC2AhaKeMhWEkx+65oc?=
 =?us-ascii?Q?2w83tUpygvVet3MniVkx6eP5kMlQND4RsBwJ/gcw6EJFVxtIh+VsM6eXCeqp?=
 =?us-ascii?Q?ZzFHy4ejj+XcDjL9ZWXQTjR1XP1ann5vcFQU0giFCQ0p6W3yAYoirho++KPj?=
 =?us-ascii?Q?757f95zawAvraWrH4A3uqIhs1hZPQyLkQrpMvnza9UwB3nLJpO5yKVd78Q91?=
 =?us-ascii?Q?nZdZCUMfO/39tW9SNNc4oZZ62sqb0oDeX44h3tneLpZYEI87FsrosG+r6K0O?=
 =?us-ascii?Q?k0rzj/R17fE9GEiHTcvijkgyMriqBryYnxZIZFwl7WBeJ1dHlMBBfFMMH07M?=
 =?us-ascii?Q?yjKXHT2GuA4oMXJqnG7mHxK5HaEJ6D+/eTNSH5of7BKEMvV2drIiQG8sqWPD?=
 =?us-ascii?Q?f9a40cSIjplvRBBWo/y8dxui18mhFMc=3D?=
X-Exchange-RoutingPolicyChecked: vgZpf3R2Mg213DoBdab6iVjFcBvxft8xACW/DAu71HR3pys+PZw8CyrVxp4iPzEoTna27m1RvPjtOUbd2NWarDZbDH0XB4sszYHRSWWit1Ej5wCyAPlb0mPsj/cOOMaUHe6QbuRTlyK2XANB9NYKuNAdwkCSY1lx+X3FLiKz2/l2owlGvAKDO4FYZ6Nh4VWpRraFTe0nmCbOuLzsRPYRltv8iWoEibkZE/jSkGtAE5qLjnu6wfLyYf65i641Oy3Gq+RuEhXGlqMS/W2MEbhM2humMgbs6hGL1vrKnXh/P1omMM/8wokaK1bdTPYQhLuDypFbNSFkVf52KHO2gdhNNA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 169e2f73-8ed5-415a-66bd-08de8c5ccef9
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 23:58:57.2234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dOA4VoqA231OOswGfQ0Qusvr+SGcIS4TWSGO7lYXh0GaItneWqqeSUSIHQpiUYk/Bt4AagJuJkEK7ISFn0GROyC65vcAFpJgCuo4aJEXLAw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6950
X-OriginatorOrg: intel.com

On Thu, Mar 26, 2026 at 10:28:21PM -0700, Dan Williams wrote:
> When platform firmware is committed to publishing EFI_CONVENTIONAL_MEMORY
> in the memory map, but CXL fails to assemble the region, dax_hmem can
> attempt to attach a dax device to the memory range.
> 
> Take advantage of the new ability to support multiple "hmem_platform"
> devices, and to enable regression testing of several scenarios:
> 
> * CXL correctly assembles a region, check dax_hmem fails to attach dax
> * CXL fails to assemble a region, check dax_hmem successfully attaches dax
> * Check that loading the dax_cxl driver loads the dax_hmem driver
> * Attempt to race cxl_mock_mem async probe vs dax_hmem probe flushing.
>   Check that both positive and negative cases.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

snip

> diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
> index cb87e8c0e63c..cc847e9aeceb 100644
> --- a/tools/testing/cxl/test/mem.c
> +++ b/tools/testing/cxl/test/mem.c
> @@ -1695,6 +1695,9 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
>  	struct cxl_dpa_info range_info = { 0 };
>  	int rc;
>  
> +	/* Increase async probe race window */
> +	usleep_range(500*1000, 1000*1000);
> +

I see your words in the commit log "Attempt to race..."
and this sleep looks like it is only widening the timing window,
not making the order deterministic. Given these tests are typically
single-pass tests, what ensure we actually hit the intended ordering?

