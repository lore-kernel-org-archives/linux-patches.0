Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568F32701C4
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 22:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759532387; cv=fail; b=fd/al1zBQu9CiV/QLHFN5TbuEitpV39qzwfB/EyukR95eQAKqg38eYsYo90K08PAY/BAhjVppg3lMx3J+rKAgEPdsvl8C/dyFQIPwbUM3OcDuvIpywh+1toSbdEexTxRoLTlJ0nhQ9LxIbLM3tFTBGs5j+1+L9sHh3cADZP024U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759532387; c=relaxed/simple;
	bh=9Mb6O1OELeSwk1YY7kOXbSc8UF9grNLdxhZyBsqF00A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=hjj+1WYcIGdF3ZgCLTrV8Y3hxdswEj8Cx8BMAUUZiteCVDGJi3VcxLn8+ZR3WTkRW3uzuzui8u12/mLeSaN4ljAHOqTdlPtcUtbGmfI4qckDvRCUT8gXzhWg8RqWRY1WqT5prUKWD44FKPMA/+H3RTLa5HDKdzB+02GQomyQbi4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZAhS5kmX; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZAhS5kmX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759532385; x=1791068385;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9Mb6O1OELeSwk1YY7kOXbSc8UF9grNLdxhZyBsqF00A=;
  b=ZAhS5kmXeckJUNevYFsY5fFLIw17Minfdgo5aRwDQk7XLG3PPMrECUSl
   3WrR4TE0u3hdKaYn7LB58V3ijTzJyfbaPmtx/7ToJDeAf8iBx6NA8ftfZ
   3x1HldQoue3tmET9Tg83SuDYpnSqpPAoSWkqHMqYgPOojyp9DBFEHSbHY
   FtZDl7K+w8AdoG+TvVqpNA70T4u6kd2DjLrT9qFtvBNvJVN+BUGYv6smo
   Higka8vdqgnZMBDLOUduL0KfpqHWc/4zx3IwnSCuLhzr4tDB2EssO2KZt
   fP8uwMf76Uf0Pg5Rr2v9El4eIZ3xz/KaVOBQ5cLBsiVFF7TL8rd4fg4eN
   A==;
X-CSE-ConnectionGUID: jCHwfmXiTgmXtFU73UPq9A==
X-CSE-MsgGUID: vKBk0qXbQxua5/Cld+Zv4Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="61920288"
X-IronPort-AV: E=Sophos;i="6.18,313,1751266800"; 
   d="scan'208";a="61920288"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 15:59:44 -0700
X-CSE-ConnectionGUID: iwpTTWd3QMC/hPwNrajdoA==
X-CSE-MsgGUID: ngOQCEY6T+yXBv6jrvl84A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,313,1751266800"; 
   d="scan'208";a="216499041"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 15:59:44 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 15:59:43 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 15:59:43 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.22) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 15:59:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZQfnPucog+QXyS9fZOvJEEb2PwdBkLkSoO28lepUTte33gz6xkx7RESXLPV7QMeRyr9cxu2APBo+i6Ype13zl0fK17Sf/3iSpVx8MEw/IAOjLXul6PAWARaUK1U7oj6NgOKp0w5/d+IDTegpC3W2X/yyjlMP3d4o5yM54CzeoH46JRb/Fh3TLGWYmnLvY+I9ypOdLzkEfH64YhXnOBjOm5fRWTeEtQuzfMN3AWCYkFpjq9cd8gU81z/NlPnw2CRggab1AUAizKqnuVL45lZsYf3Kfgk9tYm7CrdQr4iRW2LQk5JFcag5L3cj3cPXSE0u+wQCGueXTyMUmoph/7tYaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AerpN9HSzyKvt/0IVP60+3JqBNdeLGEX/Dpf9hwt+D4=;
 b=dHc3K5Lbyg7yi/gUSa5SqS5GAG1PYw7sKApEW2mL6tqY9Pto8tlpePV4RpjtwssdP0v8qauwb6e+4HL/e91+xf3BoxaTKC1V7DvlSeRA24QebBmQbMZhWixYsZ5dWiDwrZiiWW8xQrSHokrHKZLykQQCW5D81nXYpqg2ARqED+Dt2COK3co7wmiy/FZiaXk76MPx9p+tF7vyQsI2yi5zYyI+4Wva3UxMK/Y1UvnpUk41jenny+nJ58P2pXlIBX/YyF88EG+B6Ek0h/YFAkfTAs/YaQSJnWTvtjbrYzlsFqIMSl+p0+WcBxCQs1+Q0+w9Tl+jCzIttu/Nq/BT69hR5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA1PR11MB7821.namprd11.prod.outlook.com (2603:10b6:208:3f0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.17; Fri, 3 Oct
 2025 22:59:32 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9160.017; Fri, 3 Oct 2025
 22:59:31 +0000
Date: Fri, 3 Oct 2025 15:59:30 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v11 06/31] x86,fs/resctrl: Use struct rdt_domain_hdr when
 reading counters
Message-ID: <aOBVUvy5p3915dKA@agluck-desk3>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-7-tony.luck@intel.com>
 <f5a80f3a-1aaa-4831-a9f1-7f3eca748dfe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f5a80f3a-1aaa-4831-a9f1-7f3eca748dfe@intel.com>
X-ClientProxiedBy: SJ0PR03CA0121.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::6) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA1PR11MB7821:EE_
X-MS-Office365-Filtering-Correlation-Id: 5bc36922-6fe8-48ff-7c65-08de02d08368
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?mKtlrcTjJPnt4hX6N+Sgh6k8d5b6QycczP/AO8hPVfRd57mS7tGD4j5d0kRb?=
 =?us-ascii?Q?G275XYfAcnUwmsu8reTk5IOXjhRTvxwFR1x7f/hgraCONxaFowyv+1CtDjGl?=
 =?us-ascii?Q?4mlBFoKdYedwlVvm3Rst+mwIJF+NapcI7QVmq96/IpcWsVMuFf198eFuyk8B?=
 =?us-ascii?Q?BGY48RIw6AYpEws+MJ4cB2fD1jb3pWhCwvKlQNVBT8CkT+KlZa78ptOseTR8?=
 =?us-ascii?Q?IinG2GCAf+Lz2OBgrgl2xGHnhfqftypsv/Ycm3q75XaOirT32HYUT7oAQS+E?=
 =?us-ascii?Q?mGWilxO0rOHK3nhgS1VlKpKbCtGRICuKXrWTZqGw3wPEaruYNmgbAvVoSaKs?=
 =?us-ascii?Q?K4Tj0M7ocA0Gk7q7/S312VdjeniUEsoYMOWV+YnttGDDc9uVJPJU9t2DMuSa?=
 =?us-ascii?Q?fdjHukcgnyDYKk4GefHIZCImriqSLm8NhBUWps6bMEwnoeeB2K1FbLuzQm8a?=
 =?us-ascii?Q?wPL3OpFY70Vs8J5xMWzHKjE7U9eD1GKXr+EVjG5W8r+0DibA7Egry6SuNa49?=
 =?us-ascii?Q?e8Z96aZBLfGpHKny2vfKaarPnpNgyl9Jbhjb+OqlRFqB7UEJ8D7gk5bSgH3O?=
 =?us-ascii?Q?f2iCU+8s1Qykq9qigi82usa3HsL4dBUf0CXziyraEajI2aueU00XE/CwNHa3?=
 =?us-ascii?Q?dLt/ZBsWx0FsYIm9xzsxySMHujrQT6hL7Ae8DDZSvcxY1u44fdVxAecv937G?=
 =?us-ascii?Q?uHzg/y90L2aZ+oRU9M1QEWxBpjgrhNc9Hgc9g+FQ23UOcjFolL7hvu/sIgif?=
 =?us-ascii?Q?q/YGnUBxd5k8MiY7MyGnF4prX9zOEZViokh867AHL2QjvUSAry/BznNULmaD?=
 =?us-ascii?Q?a2sUyg5+/vPw7EodhFYDl8cVsNmtajI+egdFhgoyPnk6PAd2EAxEmxc/VjLv?=
 =?us-ascii?Q?0VdQ3khakoGrlu/PX0+A5Bl0MuX082mO7Nmfyf0ShoVEZXbmNgW64Ng+jNfk?=
 =?us-ascii?Q?J0EpbQ6QHzShT6spI/wyZhdMHjDnZLOM88jnRVGxMuq6VRi9dXaWTVUn73Nc?=
 =?us-ascii?Q?B4H2bQ5WX5fywaLIyZANasLXI8Q+mU8UqInhmUqWpnq/ek08oCmALglo8ndZ?=
 =?us-ascii?Q?vDLwWxRzywfdclwR+mtpFHF1FZp9KVa2kcXt2otStNScI3EW5Z5TFsuoB6Gz?=
 =?us-ascii?Q?xpFU1WL7/2+lAt8/gTesYp5KNbQgUYlawkgC4YnDIIeKarPwvZ14M5cTjFhc?=
 =?us-ascii?Q?5uFD0ftARxcbUahPJ/wKq39DKAX7scK9ACrLHhLEaxjBTu67Lb8B5JwvUCvl?=
 =?us-ascii?Q?9Oyx42u6SqVDHRJ62rjkdwSpEM79GJBd/jpNOULQJ1LtcnV1AXpR/MisioGT?=
 =?us-ascii?Q?Ggkut75tsoOeK6aeryqt8O1nqblH2RZkyHWh+2W/fhSu7JGJpRIKzVDPtRFk?=
 =?us-ascii?Q?v9sFCYJruk9Ckn05R8fsyBfvaKHxSZTDXvJE0sKZR5XjVz2zSvdWLZYQCzKF?=
 =?us-ascii?Q?87wTed2ILti9Dyo2inRFZ9zwvFWndll2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1sJOBZjRIqkYehC/3r2hHS8j/y4eX9h+W4H5rRFp2ruQZLUMi3C0BxZ6hOlD?=
 =?us-ascii?Q?5f0XGRPZbIiLflE2eOutlSoZ+lyBl+maifbuO1HS7IB+ADHh70TMqeZn8eYT?=
 =?us-ascii?Q?DHz1FsDZLbkZsDi6eTrCSxAezdlXMwNnteKPpwu4HQXGroYEFseGclx5z/id?=
 =?us-ascii?Q?Rew5MGZn9CuoofdS7wBc9pjHgfXiwuQQMZysLzGQll/h1vIcwclYmdJOBtMa?=
 =?us-ascii?Q?PuQOQKGQptBqCyoYLfzDVNqlzYCMePCk3x6wSnhDCyMUYc6w1n8v093dbzhC?=
 =?us-ascii?Q?xbq6hY7B7RCq772BbbKJ/WXhc7UT/akiFuyGW5MEO2VA7oAn+fo00unKoWop?=
 =?us-ascii?Q?VxGeZX/GkHB9s2ggBuqAwzKkMNrIzuMbS70wcV/2Gif1k8tb5BLyK7npWrS2?=
 =?us-ascii?Q?vDtUOeaOLQrGQuEIOe7tCOoXrAwyNfHqL7tOOu/JaBlGA7PKdGMvQDMWkZF2?=
 =?us-ascii?Q?Ym1IdBOYyOpKxogrSE++a/FHn+rKwOfo1rQE9+L9xUSBAma4Ce0u4ohk8n7e?=
 =?us-ascii?Q?YYoXnZuJu0X9cy+y+3IDGgVn97Vacz6xV5Ug+NEij/m+PYujIQDEVKIA7l4l?=
 =?us-ascii?Q?XBOaXzMYgT87lHR4htRYuUY64dtDuhMaZtrDY/MnrVs+kFczmw5vK0bLjjUh?=
 =?us-ascii?Q?PXNsDq0hot21qXdzMXZPfAQhROudt/vYKEj5V2TtbMSG/VRhRcn6b70bIJmj?=
 =?us-ascii?Q?BEfYgjEgueD64jRaDl5WxFtHoVArscs/sSMvz+r7nfHTjx72EBXrnhkC8pdy?=
 =?us-ascii?Q?wcSUKtPVpPXSeq5lVUPBO0tehP89AsUiy141BTDBj/Gb8bU849B4aLTBcXcD?=
 =?us-ascii?Q?BgMr1L2xHDHFabf6VTpYwS8cld7jlYGXWUv+avHm+4yuGG+3x/1KUBgQLVY4?=
 =?us-ascii?Q?Q7IMg14AgFr7Z/nFOEpvZLneR7DzYnze0rQfzJY6eCshPIfYm1QqLU4NmnpL?=
 =?us-ascii?Q?7EIjEr3prp2hqfr6NrfnQMD9jeVWKsh/yoQrO/DfhVzgjnMUc0YYGOSPju8X?=
 =?us-ascii?Q?/9gF3J6Uisn1/3rxzgi9jaad790KGfNxidmC4tTWgkOUYAqvUxAwD3EoxEfr?=
 =?us-ascii?Q?UYMMlXWXsBJwt781Y3QSnPFXkzOpA8Wgl02zI9OVC16xB5cOUNqwGag/oLfw?=
 =?us-ascii?Q?byfjMFfTNpXjc6aCCuR8jrX9yqbnk+Ms4COkOlnBRKPBJZ0XmuaV92G9I39u?=
 =?us-ascii?Q?4iLBP4pGQvZdTY21shanNaAyi57T9LHrVByObImYhbwJG4vZ1dKiWxZDMMV9?=
 =?us-ascii?Q?V/jijJMUI/Jb5VSFef5khxF53PWS41pnOsBFKc4yNBhepVsCtyseKt/z+6c8?=
 =?us-ascii?Q?XgZO6bdMGCjwUVo0cxv8vpfXwf+RQs6SNv0ACN/FvqzsZ7w+uFm86tc1hkW1?=
 =?us-ascii?Q?BE402AOTu6fMUsRUPR98rZbLW9Y5kQYw6ANB6DNGcBobwLqjtk9KOtjO90ib?=
 =?us-ascii?Q?Swbw7mOkhKrM5S1cWGg+mkkuX6vNfp7xChsafQGeRVgoC6eRtZpL5lUu+57L?=
 =?us-ascii?Q?0GvSfjEdyppE+RjDUlJ6p3iEKK2GbAYYCgSHUDlwRXTwtP5EEoGLoDfZG7gt?=
 =?us-ascii?Q?kk3+k2foVz73aqN08kbJI8ZSnIjXJnBhkqVx8mZt?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bc36922-6fe8-48ff-7c65-08de02d08368
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 22:59:31.7697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rja3tVrICZfbJrZ4/4rP9/3P1ZeunC74DZCGvermRG6BOxMdsuqvgtHpcLW15OcEzyfpGhpCx+yjEHNfuHn3xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7821
X-OriginatorOrg: intel.com

On Fri, Oct 03, 2025 at 08:34:01AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 9/25/25 1:03 PM, Tony Luck wrote:
> > Use a generic struct rdt_domain_hdr representing a generic domain
> > header in struct rmid_read in order to support other telemetry events'
> > domains besides an L3 one. Adjust the code interacting with it to the
> > new struct layout.
> 
> I'd propose a small amend to be more specific and not assume reader knows
> what rmid_read is used for:
> 
> 	struct rmid_read contains data passed around to read event counts. Use the
> 	generic domain header struct rdt_domain_hdr in struct rmid_read in order to
> 	support other telemetry events' domains besides an L3 one. Adjust the code
> 	interacting with it to the new struct layout.

Looks good. Thanks.

> 
> 
> > diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> > index 3ceef35208be..7b9fc5d3bdc8 100644
> > --- a/fs/resctrl/ctrlmondata.c
> > +++ b/fs/resctrl/ctrlmondata.c
> > @@ -550,13 +550,8 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
> >  		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
> >  		    cpumask_t *cpumask, int evtid, int first)
> >  {
> > -	struct rdt_mon_domain *d;
> >  	int cpu;
> >  
> > -	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> > -		return;
> > -	d = container_of(hdr, struct rdt_mon_domain, hdr);
> > -
> 
> Problematic snippet removed here ...
> 
Yup.

> >  	/* When picking a CPU from cpu_mask, ensure it can't race with cpuhp */
> >  	lockdep_assert_cpus_held();
> >  
> > @@ -566,7 +561,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
> >  	rr->rgrp = rdtgrp;
> >  	rr->evtid = evtid;
> >  	rr->r = r;
> > -	rr->d = d;
> > +	rr->hdr = hdr;
> >  	rr->first = first;
> >  	if (resctrl_arch_mbm_cntr_assign_enabled(r) &&
> >  	    resctrl_is_mbm_event(evtid)) {
> > diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> > index 4076336fbba6..32116361a5f6 100644
> > --- a/fs/resctrl/monitor.c
> > +++ b/fs/resctrl/monitor.c
> > @@ -159,7 +159,7 @@ void __check_limbo(struct rdt_mon_domain *d, bool force_free)
> >  			break;
> >  
> >  		entry = __rmid_entry(idx);
> > -		if (resctrl_arch_rmid_read(r, d, entry->closid, entry->rmid,
> > +		if (resctrl_arch_rmid_read(r, &d->hdr, entry->closid, entry->rmid,
> >  					   QOS_L3_OCCUP_EVENT_ID, &val,
> >  					   arch_mon_ctx)) {
> >  			rmid_dirty = true;
> > @@ -424,8 +424,12 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
> >  	int err, ret;
> >  	u64 tval = 0;
> >  
> > +	if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> > +		return -EINVAL;
> > +	d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
> > +
> 
> ... but now the problem is moved to __mon_event_count() where rr->hdr can be NULL and the
> domain_header_is_valid() check is referencing NULL pointer when SNC is enabled?
> Am I missing something here? Does this work on SNC?

You are right. This likely breaks SNC.  I'll add a check for "!hdr" and
move this inside the "if (rr->is_mbm_cntr)" with a duplicate inside the
"if (rr->first)".  This duplication will be cleaned up with a later
patch to refactor __mon_event_count().
> 
> Reinette
> 

-Tony
> 
