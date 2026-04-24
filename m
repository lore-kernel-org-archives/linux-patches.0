Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641133FA5CA
	for <patches@lists.linux.dev>; Fri, 24 Apr 2026 19:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777057784; cv=fail; b=rEMdulrEkE/FEnyjO8psxyMTDRRMhU58MEJgn/4AkPmzZ00YECxqEmqmk2skLgCRtEWwrzqSBCHnFqqqlxnd/3+gxUdNZBCvUXmIMN+7cYome9OmGVT028Nl6NcvKo67SCO//dku4hcut21+x4AmysYTcFS8mfOgddoo1z0E2og=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777057784; c=relaxed/simple;
	bh=HPE+6LHpea8uHqFvbhQ7zQfqjFFVLnaWdFy1CYrsLTY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=A43EJ6VCo4y7Sl+EoHYueeYEcaZATRbAdEOqrGatGJFbxDmNYGqGj0Rl/CfdHMUnumRP4/fVO4xr49/xePZtEC2rb4r7+mk+pp07JlroHIteUve7GxX/BBMwrg7kxork3XtNGCUPfK+yRmOqjDyi2JKAt28m8eeniBVC3XNHmn0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GuPP4L5g; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GuPP4L5g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777057782; x=1808593782;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HPE+6LHpea8uHqFvbhQ7zQfqjFFVLnaWdFy1CYrsLTY=;
  b=GuPP4L5gmY0bolsOFufpBKI24uo6carBWBBs5sihcMhv9cslDUpZ2sGP
   +Phl8484VGG/e0fimHeWbi4NjOPvLBU5ZaET1GBbub6H9HNkkL0P3EwSu
   j/G4C75irejBphdHK+bMeqwY5q1iSvckzfPVMtNkMhxi7SIWDrvN4gX6B
   Am6lM6JegsIO3rtwYZZrwXgyN5tEJGmokgikNlM1CmTel7Z0Oz4OlLpH3
   md3XinhjTuycKnwsMtTtfhf3/76AbxGRav9+0FeHr2r6EvawJFWPcNB6U
   Bo6u8T3qX4UjnDAA527zhWtubpOBVNPsmYDwBd1R6opstuABIfIFT5N60
   A==;
X-CSE-ConnectionGUID: BjxRvYosTb68TFyokzTtUg==
X-CSE-MsgGUID: 4c9hwdooQciGr8s6Wef4Gw==
X-IronPort-AV: E=McAfee;i="6800,10657,11766"; a="88352673"
X-IronPort-AV: E=Sophos;i="6.23,197,1770624000"; 
   d="scan'208";a="88352673"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 12:09:41 -0700
X-CSE-ConnectionGUID: R0xQR0ekTIChSwRDKKKnVQ==
X-CSE-MsgGUID: 6OSX1iKsTSqFS680q0xOTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,197,1770624000"; 
   d="scan'208";a="233321174"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 12:09:42 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 24 Apr 2026 12:09:41 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 24 Apr 2026 12:09:41 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.71) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 24 Apr 2026 12:09:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZbXKIESRR5uGeAjY+LEUmjC78v8qpK3f1asDW0LwI1WCUzqsSuir8ZhK95abpi29dwiiRpVZHPDUUEgyNVZiYip+Z+N04DfU+oafmARkSTvifTOHqnjWzgBlpvItQUzc2IG1LFwXEfXs+SjzaWYllNAXZS4752TuKngkw1lGg3fslYCHumgr0EXBeIzotoOgOcgx/8s58pH9/m5yh1v7qcIPW3AcMANRf+wl81lRV3ZuHilUm2A9yNDcCwBV5nhjLbelmTkVoWRVZ+N3NPTbfY5CEqNfHyu7z5BuHSq0aNhfqPgKW7wUFuGE22H9zjYgahBHLiV1eTmeQ5hFg0JGPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2rUIzlzAco0MGP1P3inJfZluZPCcZ4XWUm7svsIVEk4=;
 b=AxZtGKR2t8w+KkBmVC53ghK+VTHDti4cvBE3JyNRPy7roJnnn+VgQIeyASLF76pri/EHOGpxkRF/I8XGq35/nIV6AWCWiwRB0L1OGR3R7sYIwvqx++fWKXzKV6zQQ0XbuJpywSrQRE0d/BQVnpw5AVOhDdrfNWPNyMCPIASC4JvvbO1bmh0SIYSr316Bcuim4Yrlc5NBvhclfCxHMtRWTp14AvLkimGb+PCYcG/0jMECRTUE/vSxG86/h0BghdUBeAHZng/xsZpW1i3CiMBHRc5ZYQZ7QVX0fq328NMp819kgcZEXcb/ZXOZ5Oe122zsSzpqYGJQ53eE/67NqFNcaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS0PR11MB6326.namprd11.prod.outlook.com (2603:10b6:8:ce::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.21; Fri, 24 Apr
 2026 19:09:32 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9846.016; Fri, 24 Apr 2026
 19:09:32 +0000
Date: Fri, 24 Apr 2026 12:09:30 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "Box, David E" <david.e.box@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: Re: [PATCH v4 4/7] fs,x86/resctrl: Add architecture hooks for every
 mount/unmount
Message-ID: <aeu_6i6AGUOe6OvJ@agluck-desk3>
References: <adgNfJSeHVyBXumt@agluck-desk3>
 <c948c358-1dcb-4896-9c0d-239e99d89e72@intel.com>
 <adlIdusn61pKB3oq@agluck-desk3>
 <5a62a2b8-fef8-4808-bbcc-c268f9013651@intel.com>
 <aefdJG4y8JS_aTse@agluck-desk3>
 <1633a669-ac1f-4ef4-b733-e12bb1c6a5eb@intel.com>
 <SJ1PR11MB60831D6EBFDB4E1968B69E1FFC2D2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <b92879d7-b7a9-4698-bc66-3216e483479f@intel.com>
 <aeqdOlO3BkKQqSQ9@agluck-desk3>
 <f0015e2f-3468-4a31-8eed-c46bc6804ae3@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f0015e2f-3468-4a31-8eed-c46bc6804ae3@intel.com>
X-ClientProxiedBy: SJ0PR13CA0178.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::33) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|DS0PR11MB6326:EE_
X-MS-Office365-Filtering-Correlation-Id: ebc4d7a5-9eb5-47bb-b596-08dea235040f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info: FtKKrQqcQDHt2O7b5ihbBqTsOcNA3yU3qd91fiU6CvWxa+uESQeZAaj9RPQVKYg682kWVYMF9L9ihnrBxRviKne6OslWSwafosFB1mgBUX+7UdVgGu6VxvZjihXpWAvp+MjMe10pjjM4z7iKzVcYznsixh36hbzStNftzdt5s/YaHj/OsbHeksKv67g1wagA/Wl1xN1GtMtf1h8hMDl1x8E7Ui9IzpN9we2WLPhn9YDwOS8waNSAYMT4PTIWip7UExJS/02GcjovHxkfw5rjqbVQkItrKdmwoDTquGtshsaCaRKaA6KOjRMdbpCJ0l1IvVB9nWefiEgsZZ1rznwFJNG2Wa+yvQW2SmGBg9k6lCVD8gnC1YqzlfpGopZN8NegbIWOidtdIaMfpZ0hW3hgUSeotk0QjK1nCkNPCYMlKH0ij6gRyUTAkWMGVYmyOAiLV0fM/uXSlsG+aBZ+3lg/rPXNToEZTpHnf2PJBT5VZlQU33K7xyM6TqhEhu9XlU14U0YhR5oxF/JVC0E5Ed4eDOrZwIbw4cMLPmDXTXFL+C4Zfa7AP9301lWyYlyPw70e52DcA9w31JU5vVHtMWW12JmCg51Eqk3mSgfMAGAoD+I0PtgP/TSAXAdkIPvMMw13HRaBw8AK0nhXMOSlt4WHXyDRQLZ8B8nDLHFf1o/jmRCgbFXVP5AYekXHwjDLoQd81jfjeCaEKfjyRBT+C8fCQQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qYfVlf0EKyVRTA0ocI8nyueLbrAffQs4NCdN9BHP1YGdvanGHkeC6GoADD1F?=
 =?us-ascii?Q?EjZgwpcVHH2pxDjcsw00kgxrR7Zdng+xtfrmuKollbAIz0DI2f3yr0w6Erco?=
 =?us-ascii?Q?cCCMjoUh/3QY5OEbMf1KhdM7JrCRg7Ss/LYFs9ptClty+MUMLsw6F2mJJ6YW?=
 =?us-ascii?Q?3qjgvcvf2Qc6nWJxU8Jo/jox8l2JVhsY00R3Skqvm8TkrlNS8O9aHwph8kYW?=
 =?us-ascii?Q?j2Jli9V89Z8fPwxVCeWTCCg6YrIhTJTbFITvvoAeQFzNsNOJwEsjbi4YbCua?=
 =?us-ascii?Q?WQs+xDgBfry/GWWx7RN6hzP0vjLwTkbmh+yLfAPcGguhkBZ3Af63Ix+Lt4qw?=
 =?us-ascii?Q?AZsTBno//77IJ+g4Ti+pj7LCyRywY7nfysUZA7Ty1gKKJHjuAGkA2sMVUHk8?=
 =?us-ascii?Q?piuBujO8t1AjwgFp/kfxVviOvP8JcbkKmMIcbV3+a338+A15Xr4alLAfXyEt?=
 =?us-ascii?Q?pjdKGIfnyvGBviPfEN3LAunG+3ANEdCcVaxvSLzc4ZuPx5d54LAOZr/zmt0z?=
 =?us-ascii?Q?BMNa+Oc7LEHx8Cnbn6uWN31uCvDCCNUSFNEV1UcFWOuKk4erzsLoluXE2uls?=
 =?us-ascii?Q?lkvSSdWdtuw7wYwKuvOZ8PSmfiD3M/j1lj1n1B3GVQeJxAzcm+q/LavzOiHQ?=
 =?us-ascii?Q?DhpxwbzWPFh7KhaHWURzlENNn/dmseXlrWkmIlIDaUWatN+QleMH0aGrn7Kg?=
 =?us-ascii?Q?znPQQE7frEIaqM5nXzRQFQdqd6xKIinvLd8aHT0Doir0QWSeIp6e6Quzzi3C?=
 =?us-ascii?Q?NtUgH1LZmBSBbsylDtfTfujWbp6V8bu2pRgwbqJ80tjl8v7AVzvGjRxFNsd7?=
 =?us-ascii?Q?fpZSoaAtCrovJss6oqylYv5DyJ+fZ0om93bgrkrEBwppT6vrA4VcOez3+9sS?=
 =?us-ascii?Q?0PDdsuwch7V9p8X20E6WdpB7mQp2WpMEWQcS2nu7n+iE19a+3LjD7Hu9SWEy?=
 =?us-ascii?Q?zgBI39J5jVYAXX4gvCxoMWpgv8OfbzhWii69rDLjrKya+5OYBGzCokMmI+Xp?=
 =?us-ascii?Q?LnazZSLDB5wYt7rfVK9TiTFJlbr8bHlvsQIzChd7LkQns24oeFjU2Li3NV/V?=
 =?us-ascii?Q?Ij2Q/DBcO3+I1FWhg5Amso24oJsbZY6xKcD7UVF+yHXSSfCwh8B001ebIVGq?=
 =?us-ascii?Q?WjuwbPp0krdOx/YeR/ZhM0qWt2ETYHIku4N0tFij9Qq5bIMcf97KAKU28dNs?=
 =?us-ascii?Q?dDJhjZhsOejkrW9FLMQIXA2KdgHzGhBMFuOuzN6P6MKRv5EfeLfPk/XMmcwi?=
 =?us-ascii?Q?K7UFIcI0habiP5c0pBhbqvrgTGEYmsiG6yjcZ35z+bbCFH512bfMJ1k1Zvv5?=
 =?us-ascii?Q?Tm8c0nIzMPvQn3g+zML8TxSwboTIKjxbbjrPBQYExgpRiRuXYDIEDFMHd0ry?=
 =?us-ascii?Q?hsfqLKErbW/BLpJspwbTJu+Hw0vkjy0ExD9GFei7pAtYW667eG7mXDXelP0Z?=
 =?us-ascii?Q?f1bobEg6sfDMbJs37R3YJGmmEoRL0Wyg/xTNG6+Cc782GJrZoJ/0Rz8t+r5w?=
 =?us-ascii?Q?dModnMHQrhIza4VPD87ZjzEv7NPtu/thBdjadyM2qOMlvTviDGzDn/2yBgYL?=
 =?us-ascii?Q?6NG/NUPBajASnq11Sz6z0u8DEjuOx6l01R8Q2oa4k32iTvwu7PqmBY6m+D9k?=
 =?us-ascii?Q?LuTcqvsai+8o4576j1EcRn7yvGQk/JM25mskQPCGORpgzq3jc6PN30DQGQRQ?=
 =?us-ascii?Q?WvW9Z6Yi8uukBJzaZOjAPNLDyASlOHTMFlZpoTZfSCj0s24xxBDxPh8ZVA1W?=
 =?us-ascii?Q?1RDJ07gOPQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: YAnBl1T8dkrfj5zirYe2OKtaT0Y+EKpv/oJD8DqzNEVp+CRYuaCZTJysvsb/iBdh0E7bveY5ZUPQ8lIqsTkxz3IcNE8VChWnDJLbg+8MZZ0Wr0DDB+69RZxjyMsst9OjODruiziFPXfkvi7Aa0AkQ4INlZ4lETTLaBHIYvwdXafBwoiLpcy2xGE4FnNHlof4HeeAR103/SDBwGj/TnhOQOx2FrQHcGfDLw0SorDJ4O4f7AcE0vsUOTNzi2Ts380LXZQcKmOKXsHjWDT14/dHu1YxhXdfBRd5ho/4KWzTA1pDhIlVs0OUXVWz+Eja7PVXfcy4hhoU8R1TARf2u8fzhQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: ebc4d7a5-9eb5-47bb-b596-08dea235040f
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 19:09:32.0610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LCbW+xmoQrFGnJ14IqQp+XTRmnVSMiw8usi9YNA9lb/wpP9RHl6ZnBMPyuWg3QnQ9uPtlnx3pvVzjSDzw3BNgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6326
X-OriginatorOrg: intel.com

On Thu, Apr 23, 2026 at 04:54:07PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 4/23/26 3:29 PM, Luck, Tony wrote:
> > On Wed, Apr 22, 2026 at 03:10:59PM -0700, Reinette Chatre wrote:
> >> Hi Tony,
> >>
> >> On 4/22/26 2:59 PM, Luck, Tony wrote:
> >>>>> Seems OK. But to make sure that events are accessible, architecture will
> >>>>> now have to "hold" the pmt_telemetry module regardless of whether
> >>>>> resctrl file system is mounted.
> >>>>
> >>>> Could you please elaborate why this is required? if I understand correctly the
> >>>> "hold" on the pmt_telemetry module will be done by itself between the
> >>>> intel_pmt_get_regions_by_feature() and intel_pmt_put_feature_group() calls.
> >>>
> >>> If architecture code runs completely asynchronously to resctrl mount/unmount
> >>
> >> Since there is shared state that is managed via existing locks I do not see
> >> architecture running completely asynchronously to resctrl mount/unmount.
> > 
> > I think I now have a solution without any new locks in the file system
> > layer (just a call to resctrl_arch_pre_mount() on every mount and a
> > call to resctrl_arch_unmount() if the mount fails, and on unmount).
> > 
> > Testing in progress. Cleanup to follow before posting.
> 
> Thank you.
> 
> >>
> >>> when would it be safe to call intel_pmt_put_feature_group()?
> >>
> >> I think I am missing something here since I have been assuming all along
> >> that intel_pmt_put_feature_group() is and will continue to be called from the
> >> new unmount handler.
> > 
> > Correct.
> >>
> >> Reinette
> > 
> > I'm looking at a more aggressive change to the Kconfig options.
> > 
> > Linus complained[1] that the biggest pain point for new people is getting
> > the kernel configured. Extra CONFIG options was his prime focus.
> 
> Thank you for pointing this out.
> 
> > 
> > So I'm looking at removing CONFIG_X86_CPU_RESCTRL_INTEL_AET completely and
> > just making intel_aet.c included with CONFIG_X86_CPU_RESCTRL.
> 
> Sounds reasonable but how the final dependencies would look like is not obvious to me.
> Consider for example this removal happening with today's Kconfig that may force
> a kernel that will run on AMD/Hygon to be built with INTEL_PMT_TELEMETRY/INTEL_TPMI.
> Something like this does not look right.
> 
> > It does mean the resctrl will depend on X86_64, killing 32-bit support.
> > That was discussed before and decision deferred. But there's other 64-bit MMIO
> > stuff in the pipeline that means we have to make this change sooner or later.
> > 
> > Thoughts on unconditional inclusion and on removing 32-bit support?
> 
> I believe we already have a clear answer on 32-bit support for resctrl on *x86*
> from Thomas https://lore.kernel.org/lkml/87jzm3jckw.ffs@tglx/ and
> Babu https://lore.kernel.org/lkml/162f5113-4eb6-dcea-f034-c81b9dc021b6@amd.com/

Good.

> Whether this can be extended to resctrl fs is not obvious to me but I think this
> 64-bit requirement is indeed limited to x86 here? 

Just x86. The specific need is for readq() to do a 64-bit read of an
event counter from MMIO space.

> About the unconditional inclusion I would just like to ensure that the
> resulting dependencies are reasonable for all x86.

Only Intel needs INTEL_PMT_TELEMETRY. I tested out this Kconfig dependency:

	depends on (INTEL_PMT_TELEMETRY != n) || !CPU_SUP_INTEL

and managed to configure X86_CPU_RESCTRL without INTEL_PMT_TELEMETRY for
a configuration that set CPU_SUP_AMD but not CPU_SUP_INTEL in the
"Processor type and features" -> "Supported processor vendors" menu.

Note that your need CONFIG_EXPERT=y to see this option.

> Reinette
> 
> > 
> > -Tony
> > 
> > [1] https://lore.kernel.org/all/CAHk-=whigg3hvOy7c1j1MXFy6o6CHp0g4Tc3Y-MAk+XDssHU0A@mail.gmail.com
> 
-Tony
