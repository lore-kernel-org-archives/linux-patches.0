Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFCE25742F
	for <patches@lists.linux.dev>; Fri, 19 Sep 2025 18:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758305400; cv=fail; b=CjIkuPS8OsDtLXcBhXRmoANZLmQUB+HaKBElaHpQ1oYQb7ofFfbqyzE/Ns9dsLdUBeGcF8rYdTdOJ6hsTmmOFDW3VrCwxiDqz6eGWf8LebKZ8fnu2zxOjhm3iY1eEI5HegW0ZTqiQvp1pZo4b9Wcl9eflFqezxvEnCPTv5P6gHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758305400; c=relaxed/simple;
	bh=Ej0Kc3buKhr2Wz4bmXQWbcY/fU1eHv7aj/YsV4ZqQwI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=WnBQLGSDY9WezE4+f1I/6hpIjuRv4mMYP4cS7UUAiYxTmVHWtFNEZnGEIuCo5sjIM/ys8LoGvyHNEYawHjYRiskgfF2qFhK3ZoUjYyaz7ehvBWYmQehbZ9xlQL9DOYOsSCrG54qJ6RQ2jcm808IrAYjbl9fZTwRGzuw4eCIbOlQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kBpLek0n; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kBpLek0n"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758305399; x=1789841399;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Ej0Kc3buKhr2Wz4bmXQWbcY/fU1eHv7aj/YsV4ZqQwI=;
  b=kBpLek0nRWQAiyz+Z2atRimYVAV5PuSQ/PNDzksZrVJc8I6msCuqb7Fc
   rVVppReELpvHFKtqaH9ah1Lt0k8XdVoWO+DKu30duuhwnx9seuRCD6znp
   7d5cG0vP2HZSPy16AARtMR1J/Bvm+c1AEk68rGdbADNVVdDdGwT8vB9rg
   cIoKQBNFgtPceduGbAncKNU6uuvPZi8b7ZlxUZ6gkXBIFcep9rzrzmMsj
   D3duNuAluIs45FxoW9ogONTkCfta7ERJQTQo+SCA0dwE/FYctzc6XWxmn
   uLZ1ePQogIXUzyHbhBeqAfuDiyJNVYvM1LDqt32+xsDVAMEL7vuXa2sF/
   A==;
X-CSE-ConnectionGUID: S94UvmOwTEmJPtcDTHUP+w==
X-CSE-MsgGUID: qOVPGPznS/y9TAF7Y5PDHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11558"; a="78098725"
X-IronPort-AV: E=Sophos;i="6.18,278,1751266800"; 
   d="scan'208";a="78098725"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 11:09:58 -0700
X-CSE-ConnectionGUID: KuIhnhtESxiVU0tDXuzS9w==
X-CSE-MsgGUID: uqH2IrwIRrGm8BR71bp5XQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,278,1751266800"; 
   d="scan'208";a="175520869"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 11:09:58 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 11:09:58 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 19 Sep 2025 11:09:58 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.51)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 19 Sep 2025 11:09:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KVmm4E11Q2cc+lQgZJmiMfRMojm0VwiOxbP+JvM6mTRhaoHRyQKZLjjbYd2UBcfsDLUWAaZqPZt90zirEUIpavr4zJnC/93tqbm2xzG3de5Ct88FxGPV3soK0Gik8qI3LqXCqSPvVRcayl/lenoEfBSGoiF6/oWFlf1eBmhfMA8aaJoOLS2XJXpDBU11osJDgsSmTMpH0oONMbDTh6Zt62MUiy13IapTdGh65yM/YO0QZ4iMb4ufJUIQ/cHVIV4AFerBgJjpufdSt9v2qI9Dt7HNXg48DvMmWNmZ5jQuW9fIo+XVMVL2dgumDZr1SqDO6E3gHP9b0V+ZC2aCEDj/mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1OO/4GnxkPiHjqwCPF54WbNiAKbdm7TWUAgIOjYcFs=;
 b=BqsL76uX6u8RdhNtKjkdGVaJcWV9Tl3GdmW/2TqKVbWxXifCHbKVNMP9Pj3d8JQsW5MyQtbWs9k7R2Kp4AcCqlTmOC7AO/9YX7NWvtAFXkqfgw2LBcMj4/uOulMn1EzM3gM+fQZaVf8v6nn8oNwD6PFQqLS/BAPNqoDZLI7Nacb0clOwsJckq9cXqctVwH4ugPwLFh5ae+C6Udsf0Z5KGCOcZte4BClefYKdDZnQsHUnqr/uyA+VEngZEpChbLZoS0r3pnKg9BLh7sKLXFYvp/qK/LMuPhFoMIwiZNXbNtqTS2ixH0x19aonP+KPM9pPdj3zAtknNiJ8dwfBzj+Qmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH8PR11MB6706.namprd11.prod.outlook.com (2603:10b6:510:1c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Fri, 19 Sep
 2025 18:09:56 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9137.012; Fri, 19 Sep 2025
 18:09:55 +0000
Date: Fri, 19 Sep 2025 11:09:54 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v10 02/28] x86/resctrl: Move L3 initialization into new
 helper function
Message-ID: <aM2cctuXS8NBLeJ5@agluck-desk3>
References: <20250912221053.11349-1-tony.luck@intel.com>
 <20250912221053.11349-3-tony.luck@intel.com>
 <67f34897-d5b2-4ea4-9e4b-edea86b7636c@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <67f34897-d5b2-4ea4-9e4b-edea86b7636c@intel.com>
X-ClientProxiedBy: BY3PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:a03:254::6) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|PH8PR11MB6706:EE_
X-MS-Office365-Filtering-Correlation-Id: e0a2d139-3f6e-4ec6-6ed7-08ddf7a7bce5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?eRhNYPaq+eurRPLjhgP/twaww01/z/Qqe/IbR97IQjJq3HSuAggaRDNOGg95?=
 =?us-ascii?Q?MOAejx2/RYFcQ6h8FUzkOWHe1KRgwGAoX/lzrZBCSg1CSHV92hJB7J3/eoMp?=
 =?us-ascii?Q?afKGkHGNOqqvzQJLmOGyI0q5bC9CFC05+8GCgzI+yBlzDR7eRrg49JAKROss?=
 =?us-ascii?Q?C7MteJj1XBPviz9iswJjhXu/ESIZxpFAzkI+S6zPMx9/FslcARyyzbUPyPoD?=
 =?us-ascii?Q?fRSG8UQ3SMKefsOFrbHz34MpGJnp+NCZAVPy0TspZJ8VM9lKGGMAXGEnawqW?=
 =?us-ascii?Q?yS7L5cUpz3VrqSq7KHkPVUqHi2RYl+hv65PdNxB2xqhY/zVAHj15cbKbhtS1?=
 =?us-ascii?Q?twacf5jCRX/kpTgA/YgS+AZxwmocUBR5DkM3ZW4rw9FO8S9pDCM3c2M6Cgqr?=
 =?us-ascii?Q?LwCV/P40+ihI6KShTbka6/AC1xuy7LCXSP3g5jqU22BgJiXhn5bFNo8x0/z2?=
 =?us-ascii?Q?F4nuAGKkeK0R5RkdcRGp+kL3E0OiY2pduFudw6JiyB6hCF3nVtWtn7wbaWD7?=
 =?us-ascii?Q?++0pntcPxYrfYNowKTZFQp0DNhQt8St+1i4JFWvnWEb8SaZPBSWWNkfjm3th?=
 =?us-ascii?Q?mcz+HIbDnv0WzQ7bN3oTS4u2oVMJroLxiWyXIuq+LivZMzgPYP1nz6Uw/Zf3?=
 =?us-ascii?Q?BnjI9tA7Y8EVt0ptTFWIeV7U0V2ziqxzU+ooyQnu4gqUsPztvgr4Exz/5Ilf?=
 =?us-ascii?Q?0XhjxH3WzriYJlJ9FEwgbi522m6V939fSMMVaSsREyXI+cBU8//nJXIbgxBZ?=
 =?us-ascii?Q?/YCEG/sBc2cPSp9dIGPRDChxjtOxGjx37vvgar39O9lgIjFpnQoqobtxgFe/?=
 =?us-ascii?Q?J2q7IAftoE9eOfLul1zpdH27JfKz4R5r8m05mL0HUJzZqBPcq4FkryK/7/h0?=
 =?us-ascii?Q?wsHHCuOfC0RswJaPY2EeMvmO0EknUX+ChdTTb2Zr9ITE+fhOg8leT6000TJV?=
 =?us-ascii?Q?4xA5Pr4fwT5m63iO61zT1G2LrdYuuyWlXaolbRT+I6hepuENxBGRO7LwA2mJ?=
 =?us-ascii?Q?6Cl34sXIEk3ylvCSV0ZqJ0D1Ca8s4Q9DUyEHp6pIF8mxCS8NXzbekrEEmzSl?=
 =?us-ascii?Q?wwvFROzdM2kjZw1e9yXA3FfV08pOUR7a/a6xJKyUDmjL6XJbC7XsvvZ7uUqW?=
 =?us-ascii?Q?QeF7Zhrqwlt8HmmxnFaeJ7PJoF467AHWsAxzclPJU0NSaPNXXI83s1dvwd8H?=
 =?us-ascii?Q?G1HiYhnV/LuiWSQsFgphs4HiIjiPI3auobcv2ruNHR1F8HgzCuQKm51FVZas?=
 =?us-ascii?Q?GCt1InFXBdXg95hg+iZv8Mx4T9oeZDBEfquHiSGYAY2IvDM8RXXZX1y3stwP?=
 =?us-ascii?Q?PG5uDsMj+O7nStiqgO0ZN6tmPfV+Zgj7YFoJcNbaCpBB+qCRHtSruQ2VWzFD?=
 =?us-ascii?Q?QDkqqPd/iy4cEsNSKlzmUDbbb967DaH5PASAfGUrBU1OxCAaMBPa4NkkTCTC?=
 =?us-ascii?Q?EcVdeC5cBX4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XXk3TGAUunr5JdcD0GgcagHLcJ7698MuE5qc4hknhIhoprslfJWj7GM5wYRT?=
 =?us-ascii?Q?wEd1gkFi8SdWnF1HAaEyo6SfNzgP0lOGbdjelXuNDzpwYqKt9NxQQz14Cyk2?=
 =?us-ascii?Q?9xZXB4gzOn4x/jZ3+zK1e1wVjU1G7Xe43os32j24eqrDEhM3JSR7UHDgbycW?=
 =?us-ascii?Q?21hogsberlMzsVyymrdNb5DcXxepHUXSe3dFy3TXBgWrbh00lTE6LgwNOm9O?=
 =?us-ascii?Q?oUit1ZPIqo5QrioI4BnfnfY3DS11LNrmuyOeox7OBsk8NCw0REGlGfSe6vxv?=
 =?us-ascii?Q?B7/lREjPFy5UCT1swNVi9uknob/A4T69A+I8NTqFdIvfvgy9IkrjN/5FzmuJ?=
 =?us-ascii?Q?rkcoGATJfkaILl1lEhl49W8NiDSidh4wWcOJInrS9QRqs+QyPsVCC21Qu2Vo?=
 =?us-ascii?Q?IW5AmGhjC4Drd8HDplJ9meV+ArfFuAAZE0NY+kTf3uBuLmp/Ps+g0fEyMSaE?=
 =?us-ascii?Q?i1+2zLsTUSvlepYXnJj9JB+n/Vngkun/Cda2l3n3W7u0Nxudk80j/2umntck?=
 =?us-ascii?Q?JtFX1v3ZyJn49R0k+7a9PAK0FvcYXZiim9LKV3h7qnKSdYVar+JBt00MmqvE?=
 =?us-ascii?Q?u1KlCYk8odMMYVteFAqtVaX0otdSaFCnElc7xASxsPBIrbuNnfr7Wk4qCIDI?=
 =?us-ascii?Q?QCtMZJSndst77OLtoy6WfUCGoESqCRK70+uitVqoZzaty4Czv/1LtPFi290a?=
 =?us-ascii?Q?Yyk0T+ti5Q/ZoKBT0uRPURf1V9V8spTAeajYIFp3lGMIbXIopnJJaFyGpCPj?=
 =?us-ascii?Q?nsU4mpqfme8A0UfK9iFwqpV51eOKeYGGGkpm2U1smKWnJRYbhERM7gdCiLwU?=
 =?us-ascii?Q?Me+nz9emamL4XrXPTJUKQPMp5gCEWoO1yHDXlno+BpYF8AGB7L6HFpIWlhM9?=
 =?us-ascii?Q?7/ohpegTOB7JyJOhi+ncplyhGKOFQB4fVEaSg/Y+4O/Y2Sr/MkUZx7dCfIV7?=
 =?us-ascii?Q?zJPB7AmgW5cE5jTBG+l1IEDacArUyMEudRc+V22FGUKpzgRjM7PgDfN/STAS?=
 =?us-ascii?Q?foXH6Y+dN5NBvsUc3oiEFYhtqHpQTSoacpitkcLwuhXxI/uoN+/UDetwfX6N?=
 =?us-ascii?Q?2g9RYUY0XHB6Iu0xPgsaPSlQflk+Gn9EizdzzxbCBpW5EoD4CG0TNFiYIbGB?=
 =?us-ascii?Q?45fkKCnva2FoGz9MJl2tJFJpY04ytmQOhisOH1lGhygR3XYNo8cC6cYhFm3s?=
 =?us-ascii?Q?YMlWzwkkP4962giPUMeHlxq57ZZco6gs6xyvzv2WUR1jFUkuCG9o8EHPFMUf?=
 =?us-ascii?Q?/MpHhj+TiUwpJ2B6u+XwuNOxA91cS0Cq/IisPInEHBMQ1KYoRdnz9ic6ZR8B?=
 =?us-ascii?Q?ZvhKkcU5SAFd4U7Ybm9F2mw2YYcJoXuCdGr+C1zYXfcy5fhCTpLTtfF/rXiv?=
 =?us-ascii?Q?PJ7hsEd1ve+qqxhL6yNxfjI6g386ZDt7cKzLB1Baiwx/6Op2UFvDtnfuq6of?=
 =?us-ascii?Q?CMZ25aIn8DMdPlhfiq1CGLlKYYljDGOa1dWeb0FYn2t1lNIiBh7s/Lq+sufu?=
 =?us-ascii?Q?bHzox1RrRD79ZywaBw3etO/MmhXXGOarkuJmZnx0Tl73xuRl4gbKiXcfkkUH?=
 =?us-ascii?Q?gR2Q6xG5N1FbwWEvnVhs04n6BEwM93qu5qPD/L1j?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e0a2d139-3f6e-4ec6-6ed7-08ddf7a7bce5
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 18:09:55.8648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0pwElYjRVlZgiuecAkBcThotd42p4ykAldW83MinsQYNwCEw3c8TQWhGS4KqkUenBNqGz1wSz38vEDDAzS3WIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6706
X-OriginatorOrg: intel.com

On Thu, Sep 18, 2025 at 02:49:05PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 9/12/25 3:10 PM, Tony Luck wrote:
> > All resctrl monitor events are associated with the L3 resource, but
> > this is about to change.
> 
> Please see Boris's feedback about changelogs in [1]. To address that,
> please rework the changelogs to not have so much copy&pasted context 
> in patches. 

I understand that Boris doesn't want to see large amounts of text copied
from the cover letter into each patch. But there is still a need to meet the
"Describe your problem" requirement for a good commit message.

Several of the prepatory patches in this series make changes to expand the
capabilities of fs/resctrl to handle monitor events from resources other
than RDT_RESOURCE_L3.

Is a single short sentence repeated in several patches "too much"?

> 
> > 
> > To prepare for additional types of monitoring domains, move open coded L3
> > resource monitoring domain initialization from domain_add_cpu_mon() into
> > a new helper l3_mon_domain_setup() called by domain_add_cpu_mon().
> > 
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >  arch/x86/kernel/cpu/resctrl/core.c | 57 +++++++++++++++++-------------
> >  1 file changed, 32 insertions(+), 25 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> > index 8be2619db2e7..055df4d406d0 100644
> > --- a/arch/x86/kernel/cpu/resctrl/core.c
> > +++ b/arch/x86/kernel/cpu/resctrl/core.c
> > @@ -496,37 +496,13 @@ static void domain_add_cpu_ctrl(int cpu, struct rdt_resource *r)
> >  	}
> >  }
> >  
> > -static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
> > +static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos)
> >  {
> > -	int id = get_domain_id_from_scope(cpu, r->mon_scope);
> > -	struct list_head *add_pos = NULL;
> >  	struct rdt_hw_mon_domain *hw_dom;
> > -	struct rdt_domain_hdr *hdr;
> >  	struct rdt_mon_domain *d;
> >  	struct cacheinfo *ci;
> >  	int err;
> >  
> > -	lockdep_assert_held(&domain_list_lock);
> > -
> > -	if (id < 0) {
> > -		pr_warn_once("Can't find monitor domain id for CPU:%d scope:%d for resource %s\n",
> > -			     cpu, r->mon_scope, r->name);
> > -		return;
> > -	}
> > -
> > -	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
> > -	if (hdr) {
> > -		if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, r->rid))
> > -			return;
> > -		d = container_of(hdr, struct rdt_mon_domain, hdr);
> > -
> > -		cpumask_set_cpu(cpu, &d->hdr.cpu_mask);
> > -		/* Update the mbm_assign_mode state for the CPU if supported */
> > -		if (r->mon.mbm_cntr_assignable)
> > -			resctrl_arch_mbm_cntr_assign_set_one(r);
> 
> Rebase error? Note the assignable counter initialization done on CPU online ...

Right. This code was lost in the rebase.
> 
> > -		return;
> > -	}
> > -
> >  	hw_dom = kzalloc_node(sizeof(*hw_dom), GFP_KERNEL, cpu_to_node(cpu));
> >  	if (!hw_dom)
> >  		return;
> > @@ -565,6 +541,37 @@ static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
> >  	}
> >  }
> >  
> > +static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
> > +{
> > +	int id = get_domain_id_from_scope(cpu, r->mon_scope);
> > +	struct list_head *add_pos = NULL;
> > +	struct rdt_domain_hdr *hdr;
> > +
> > +	lockdep_assert_held(&domain_list_lock);
> > +
> > +	if (id < 0) {
> > +		pr_warn_once("Can't find monitor domain id for CPU:%d scope:%d for resource %s\n",
> > +			     cpu, r->mon_scope, r->name);
> > +		return;
> > +	}
> > +
> > +	hdr = resctrl_find_domain(&r->mon_domains, id, &add_pos);
> > +	if (hdr) {
> > +		cpumask_set_cpu(cpu, &hdr->cpu_mask);
> > +
> 
> ... assignable counter initialization no longer done on CPU online.
> 
> Looking closer the l3_mon_domain_setup() also now contains assignable counter
> initialization that is gated by a RDT_RESOURCE_L3 check. Considering the flow
> I think it may thus be simpler and consistent to not return here
> but instead have the additional initialization done in resource specific
> areas below. 

Yes.
> 
> > +		return;
> > +	}
> > +
> > +	switch (r->rid) {
> > +	case RDT_RESOURCE_L3:
> 
> Something like:
> 		if (hdr) {
> 			/* do resource specific CPU initialization here */
> 			return;
> 		}

In this specific case the resource specific operation needs to happen
on every CPU (it updates the per-CPU MSR_IA32_L3_QOS_EXT_CFG). So I
think the code fragment needs to be:

	switch (r->rid) {
	case RDT_RESOURCE_L3:
		/* Update the mbm_assign_mode state for the CPU if supported */
		if (r->mon.mbm_cntr_assignable)
			resctrl_arch_mbm_cntr_assign_set_one(r);
		if (!hdr)
			l3_mon_domain_setup(cpu, id, r, add_pos);
		break;

> 
> > +		l3_mon_domain_setup(cpu, id, r, add_pos);
> > +		break;
> > +	default:
> > +		pr_warn_once("Unknown resource rid=%d\n", r->rid);
> > +		break;
> > +	}
> > +}
> > +
> >  static void domain_add_cpu(int cpu, struct rdt_resource *r)
> >  {
> >  	if (r->alloc_capable)
> 
> Reinette

-Tony
