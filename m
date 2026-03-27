Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F1030215A
	for <patches@lists.linux.dev>; Fri, 27 Mar 2026 23:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774655207; cv=fail; b=AnOpJ2JojVOS9K2gC8bqwMpVigQmbGZ6EB57Auizf3LO8RXuFvBQZNFMaQTRKP8jpLxg7hLeQn/YbH5g49Dz7jRZgz2zIGUII9mB3GCNMvG91m+Sc0IUoDyxnffKpRl6lD2kAz2UexvAxFkTkzbvL2ia+cWhxx97o1IT2/1EWME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774655207; c=relaxed/simple;
	bh=kvCgJ28+6ufCLy+YcTNbftPUI3x7Xu0Sp4O5GV6IiGE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dy6GjNnbQN1Z6CvQ8bI47yzIJbpQtjK4LRo03k7Kw0QAMkorPbHmNFtKkqbufNoL+tuBe6otFXu9oqdgng01BLcA5rgFFsGCUEpMPeUlbEzQnCa3YBrpTG1IVo0duT4F28fyzboax7ITx13tbFahGwWhdgmO/iw3QaIFpFaRD0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LLed8iDy; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LLed8iDy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774655206; x=1806191206;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kvCgJ28+6ufCLy+YcTNbftPUI3x7Xu0Sp4O5GV6IiGE=;
  b=LLed8iDyuO06Bv1Gls6AqFlS+12D35IWHSTuaEJQSxAGVnbEgM1CE53y
   QV5bjhFdjExjhc1NQPDh3+5h+mxS7w9b4wMlZ5ki7a46tQx/GbiOiSePk
   qNc3MpDw8oembuK+3vov+j7SThu9Fpm5NDL2wjKoFoQHpguSNbYz6sGr7
   kD7bPRARy2Z4O5UwwcQqoSb0H9h1FDcYNmhW2OabPY/K0sMHRt0HPr1i5
   gkjy/MKx3iqmRceamNL0W4u7MppACBWQSGNHCFjuH2ymnXZAFm1jnhLrW
   x+ZLmwoV1PKw8m//BqqB6yp9M2Fmg33SSyGWH3eDvc+s2lpaOOEToYZwo
   g==;
X-CSE-ConnectionGUID: lGwJM43jRYyIu0ZWhZLW5g==
X-CSE-MsgGUID: m3+My9N9TUutySTCywL3kQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11742"; a="86353599"
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="86353599"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:46:46 -0700
X-CSE-ConnectionGUID: XlonQE6tTe+u9DXUQTShVA==
X-CSE-MsgGUID: KfPAXZVhT1OxLVnUYRt3hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,145,1770624000"; 
   d="scan'208";a="227058784"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2026 16:46:46 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:46:45 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 27 Mar 2026 16:46:45 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.9) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 27 Mar 2026 16:46:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gSAfPTiTDgNUjgXI//dNrTUSzCVSbpXnGY0HqAFkt9673FKYxjnHpErppY93wWo915Eif4onwNEDXXdWvLVuYgt3vvIXHKECG91CrIa5v034Gngi3H7NjjfpzDrN1Ug/Rtg6L0CW43/nbruMPaz5P8uUYmffEX1PxWw/Lqz/BF1cmf6bU4nb4mXTpgZVygAi3nYymJ1vXluGkIZanzrbK5251gP+TbUz/h9K1f3uMC74bK8ILvFaWguxuQp/RC1ySWBqF42US8+JF7ez9VKWNw9ymTQA8PptBSDlt9jiRpgdh9J0AxZe+F1L2LrCl1hfB9f9zM3BFU1ZrGx52kqfNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UyfYahoDM0iaWLhG8E0xnZfnLUSoVEo/XVc8MMR8NHU=;
 b=UO4oG5FcPmd41uKxfVt8Ki85H6NQ5KfQlM97BEJeRTp80zmjToo211jRfuBnx87syLnJkgwc/mrq9nnAI4MWvs4w6DIMcXrZxwYLGGYQZoNWAVJHBS7u7vWuCQLeLKoRh18svLYW9DfNYvuj2xMQae01qtftODi4RhHPW24ZE5jwks7gMa0ShQY/nN0c8JWDjTAGkVwlLCSxOmJ1Ci6S813HX2+0Sg/7CO78oba9p1Ypz+4EbXoeKkQv5JcKj0XXx21x2kWJNRjJMYWMKVcsx3HU0wDOuTnU7UVZ2LyEoxnOiUswBjj8B/WIRkWvOfK87RQRAjg3LD9q7CJ/5dDmIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com (2603:10b6:f:fc02::9)
 by SA1PR11MB8254.namprd11.prod.outlook.com (2603:10b6:806:251::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 23:46:43 +0000
Received: from DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026]) by DS4PPF0BAC23327.namprd11.prod.outlook.com
 ([fe80::fa8a:90e4:57d4:8026%7]) with mapi id 15.20.9745.019; Fri, 27 Mar 2026
 23:46:42 +0000
Date: Fri, 27 Mar 2026 16:46:39 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <dave.jiang@intel.com>, <patches@lists.linux.dev>,
	<linux-cxl@vger.kernel.org>, <Smita.KoralahalliChannabasappa@amd.com>
Subject: Re: [PATCH 6/9] dax/hmem: Fix singleton confusion between
 dax_hmem_work and hmem devices
Message-ID: <accW30ObpBvBq2Rk@aschofie-mobl2.lan>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-7-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327052821.440749-7-dan.j.williams@intel.com>
X-ClientProxiedBy: SJ0PR05CA0205.namprd05.prod.outlook.com
 (2603:10b6:a03:330::30) To DS4PPF0BAC23327.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS4PPF0BAC23327:EE_|SA1PR11MB8254:EE_
X-MS-Office365-Filtering-Correlation-Id: ea72929b-b975-4c7b-a73b-08de8c5b1941
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: 3tt4crdi+7ED/MfQo7s5Nk6rE+3Kg4+g4O+ncDY/Qxzeli4H3V+ij2LNHYVKJj1EqE8qOeUkgFcHM39dW/OadfYzNX0rmk1uP7nyAFiOk6AISGY1Gb2XBaiBVoy4eIKgNcN0/VxVWFwtFvzWgZHIipZCIBQsCukCPsFWGOS+oRT+GF/LUkEaLi6lqJAzKxl0Uv9KVPOAJOK5D4XT+tiSQOvD9sm4Ey46Mb6eVvbLWK2teafqVQ87BnUhyK+WnqyfwTJJHWL/XTvrvp+FYfT51TVl2QhBsgpXS8UzQSqgDe7GOu6kb3ADdMiOqIRSCasel1de/b9qbEA9crGZZrxyYXC2d7oE0a4b0LVplTbrYQROSYzUUUOrGQ18MF3XTM+Rb2vNYsqfFpTkJwbbdYDYh/iA+rF1J11ItVJzduG1Y+0kB9j4GAXpm3pxUBoBxc1GK/g/QJfvQd2VKl+d5oraTjtop5v92ZNDW6YVpCdoWB7rhkap/KThJzQjcVJE1/UKiH8DHyMD1i6lC9noGk4ReBm44BeI1LMYEkqAgkODd0N45mCXPoUlJmGaXhAZIu/I/OzMpE1r0hTb+jcGwEdXUbA44pnqtwKqcnm9PbSuUOKL4wsNxZDyfGCSt8Ab1AZB4MmBi6ePKa5sFLi/ZHcLrwFacSz+3y9hg0IqqnFQE7Lo+J94EDKgchiw1xXfPcUpTaEE8sspn/RB2MDSOT/eFVbbm/30S3iV28Lz2w8zfbM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPF0BAC23327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wH/A/F+X6yOS4zzGi3vUEedW47XOvODbF00acK5Y3Gc2suagTNcV5pa5gWD+?=
 =?us-ascii?Q?RUzCD8N3qOAIcgP6bO4VKLe0Rjdnk3pTAqxiz3fjr4bHsh2J5P0OuFPRrBv/?=
 =?us-ascii?Q?VnB3e8sA72FkCvQaLD1mUm442G21gukIuPaEn9frps8vWJUKjjVATOvVVAjz?=
 =?us-ascii?Q?vPtVtcVirFh81HOJF41oELcGdaslJvaKFB8vrMn/FV8JIn2pL/OufBB9PUmQ?=
 =?us-ascii?Q?yzLn5QGn6xrQqwkqQMSAjFrPoBH+DQaLWz88LRkl7J57gByaDlUpriWa5cH/?=
 =?us-ascii?Q?jFXRe9Lwz11NvALq8OG0DkPMJwTOj6X036V2H7OJ7MrfkH36JzQT7WHpjohq?=
 =?us-ascii?Q?OY8PkH9iS3hzzcPgTkcO1P7Xr3oadW/UaL9ZKy8ZK8/+19B63fZ3vlWg3u4a?=
 =?us-ascii?Q?Q4v1Wvp78z96uiM9D74wTX3F/uVV+XgnyZcSmBoV3buqFU1QOuV+M1MHvoIV?=
 =?us-ascii?Q?j4q3QF2j2dXcNKKqE41KPzwPUPk2gIP685/Dklhi/ZXCyFhBSgDaotSwgBRJ?=
 =?us-ascii?Q?GLCuxVrcI2RnJVpfril8ctx/KZNi9MluL2jd+2ErpxsEwt1UtF1/mvDc1Hc+?=
 =?us-ascii?Q?idggpLR/MvMSEjyfTB2ckYFr2QRpdz700ajNcLk1FB2xAC7B4fl99HCXhiFu?=
 =?us-ascii?Q?AGu6NVH3x6y8fv0bAZ4RqSj2LVmG3QC19W40IU7PaVRHfTwfvW8VhIc0q18B?=
 =?us-ascii?Q?Mvt2OXIVBwldcpEOWESJT24ynNynIbmbZGYF8mS5A7cboEYLMHZFKOI2wNAD?=
 =?us-ascii?Q?3bXv8DacIiw27X9U1CU8CiIeg4rJ6ZSxgZbyS50VNBZF2WETsqq0yL+rHb+L?=
 =?us-ascii?Q?nf2LfXY7DUE7zGf8ZZCnMWUFiPSozFjB8YTgOcws3GW8qppox4HBmh5mFChY?=
 =?us-ascii?Q?9HoHl4bKt6JN0L5Nip8RjItkcYOMpZzFGhoEr6hH0bsL3HY+JcwY5Mc8QwFG?=
 =?us-ascii?Q?F9DPRdlC0Q9pJo6CAUnKAbxvEG4e3gr6mL6TDPseSCXrqjHm4VS9UdTt3fci?=
 =?us-ascii?Q?o9P5FgADwOG+fn6y4i73/zgFarPawdHfMdQMQGZlQSEEJ7Xa+EADghKc4n3u?=
 =?us-ascii?Q?S2vs+yZbkeUpc9pgBmuTXrhTP9t9fEOwmhzZKZS7LiX52cjNjuknkZ26Dj4r?=
 =?us-ascii?Q?ACSq26ZewEs2NnYsaOU7gd7i39JJE0ZbRGeiTXw931YLpRF2l4UmcnGTtj1/?=
 =?us-ascii?Q?3pFPXeS0qCjivO4pXP+T3nB35p+PFduNkp5aaBVjipFdWoF91Qf4UJUWSDSh?=
 =?us-ascii?Q?nv+7/Lwh5Nleh9dhwUwNVoWbiRTEC/qRNWYztYZ31joEKLBsQjdwI2ojQcct?=
 =?us-ascii?Q?hjnM+ELbFIfACJ4/dzDjMYyLbDiSEguSnaUFTkq1tSK4dYwxv4O/LuYN1UYB?=
 =?us-ascii?Q?qVgz33Pi1qAQoEnvcX8fS61vIOnv7s1UWXO9DFsaTaMCbXgdekcOYJIJA9to?=
 =?us-ascii?Q?CoGDkqb0eGaODozBUBbPGoE1tJYsAPkK8EIED+ZCyBv+U2WkvpiLJer6GYhs?=
 =?us-ascii?Q?yGfoMpXUQGdEjSzJ3NrASi7L8GckbYG1Qsj7QLd1Rowvf6KJVItWiQZ2LVKo?=
 =?us-ascii?Q?LWkHtUDmzkijwWWnix3Ou4Hfm87bon2UinoLTTnrPE0RUh1H7akFBTXbSsNn?=
 =?us-ascii?Q?Kg1Of7zpAOFAEBbz2Ymm+6STC9FmzmWW63KjaZSJraoysT09PhSALK9cUgr+?=
 =?us-ascii?Q?EK8joUv8V1zXuy27X3nKsHRcZkyDQ1WsKK9nZoYo3ydTIrrTSuYfubJJzX8Y?=
 =?us-ascii?Q?AoiQ/usHV69KemaBXjLR8g9CaqhulGs=3D?=
X-Exchange-RoutingPolicyChecked: i8ug0f/RAzVX1sgBBQl6CSmsEk19bUcwXfNJd+LQK3v4g+GJY5B3LzjEYUe/fRYvUzE27fK9zcdABjn8pcAS3DbXSbn3sGLZ02aLZEF/6t93fk38WfNg6EvgOi14Bfed27iTUSnEvjgUi6EvPym32oP/R7RJrYRe1pj0XQjsZ8ia0UDRQn4Vr/+Cce6h7Q5ICxRaSJdZF8/icwv8a0bFI7bPSIOTt0t76TNIChKlhsf7jJXDNEAAt/x0DBjd8oUnb5tAc27RkpqhYzxu9WUCxY3RqVn6KMOToxhxMSlh5EfcOypUf0YIUuTYFUsyZMoueBEP4WqCDFWDBd6KNoz2Ag==
X-MS-Exchange-CrossTenant-Network-Message-Id: ea72929b-b975-4c7b-a73b-08de8c5b1941
X-MS-Exchange-CrossTenant-AuthSource: DS4PPF0BAC23327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 23:46:42.7892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m8R6xwq6GfhFnPXeDRWV4v7pPbBHqRqO/UZXfce3XNSbxX3uXq9brMp/ijvAXxe6jX+yCEUssTPKQ4Y+KNiO7PfuKCy9tOKkhgqw8urlr8U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8254
X-OriginatorOrg: intel.com

On Thu, Mar 26, 2026 at 10:28:18PM -0700, Dan Williams wrote:
> dax_hmem (ab)uses a platform device to allow for a module to autoload in
> the presence of "Soft Reserved" resources. The dax_hmem driver had no
> dependencies on the "hmem_platform" device being a singleton until the
> recent "dax_hmem vs dax_cxl" takeover solution.
> 
> Replace the layering violation of dax_hmem_work assuming that there will
> never be more than one "hmem_platform" device associated with a global work
> item with a dax_hmem local workqueue that can theoretically support any
> number of hmem_platform devices.
> 
> Fixup the reference counting to only pin the device while it is live in the
> queue.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

