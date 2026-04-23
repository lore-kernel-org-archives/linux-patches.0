Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83E936165E
	for <patches@lists.linux.dev>; Thu, 23 Apr 2026 22:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776983365; cv=fail; b=BZ0FgAmgmYA7BHCeA/L9aROCSnV5Y0iYButoU6q4L4KaO7DpTCrbW3UMtaiER2uptTclYY86JhyozvLEE8+B8V/2BuFvb+dMb4x1mbqs2B0zcQAXgkRlFKzF/QPNYTC0nIjFSfkwOQwy6VwYY1+mBGevunC/AeOw+xLB1RdJrbI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776983365; c=relaxed/simple;
	bh=O/SVOPtrYi7R2lOd16RJixOwZGl14oVbsu0L2cO43Xk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Mhb2Y44bEvLY+NvZcpGaI9fqmZ2kR/JTz0/Mm5tp3nbmoHstXVL6jITv06NrzG8XO2IkeSyYXL1jFiEu3F7xjwtqqglEh9GKmKmcA1aTHqGpYp72zUGhbr9gaOuWWN/c+U6rwYHbwMXeAACWDoworixs38mDJJ3UVUVyLyijHiM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q50wufi3; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q50wufi3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776983364; x=1808519364;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=O/SVOPtrYi7R2lOd16RJixOwZGl14oVbsu0L2cO43Xk=;
  b=Q50wufi3w02CK8rWzukL1SNjxC8uv+DRvMHIXWdGYkX9NsTKUQNlB4sv
   IGjMs7bxy1kSMSj2bCvFyxjhu+vtPewaFBrxP4NV2RyX0Jshtxi/o8r/Q
   +nVec7hSphpTYAir8FzvfNMFzquGbIEOfk+qMMr7qlFnKNJJy5IwZ9c+h
   f6pAKLm6zTKtPYBtTMsibSSBOnpyB87DNqGpoNJUmQgKOTfM0l/5QJ8Em
   t0IvB8OWjhqRcmzzgVF4UQn9eVUK764ImPK65ghbg0J+uxV/YMf/aOTFu
   ZVXtn1E+OxNVmShgvqj8HahAC74MU7lTFJbGcLWkA7u1uua0wEiMW2Ibd
   A==;
X-CSE-ConnectionGUID: qx1jaQO+T+KSWMc2nU05yw==
X-CSE-MsgGUID: H/nn935qTYKgBfYyZ8C0Jg==
X-IronPort-AV: E=McAfee;i="6800,10657,11765"; a="88659210"
X-IronPort-AV: E=Sophos;i="6.23,195,1770624000"; 
   d="scan'208";a="88659210"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 15:29:23 -0700
X-CSE-ConnectionGUID: ktp02KB3RHCy7lH3sbxYKQ==
X-CSE-MsgGUID: Gq0yWK5qQC+ha3ow5oersg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,195,1770624000"; 
   d="scan'208";a="229595611"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 15:29:21 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 23 Apr 2026 15:29:21 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 23 Apr 2026 15:29:21 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.49) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 23 Apr 2026 15:29:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MywwWHzAtsgnVcrPaRWZeLFJMlHz9SOXSDShrlwhmIPI8cpaN9L666D0CODhiruZn6E0nMd1eXRZLEWt+BnEsCawEkSQrmv0ec02HKtPGGUVrqgDOgBFAgV/aPj9xExIPUZkdv9zhJyAMzMtJWRpNlXkTcFPYMnaYupkB4hZHIE1dBoTp/EZsoCub5RCqYtmYuXNPF3cNlIF3KzyH2I+Zc0OzKSlq3V9l5SSRYUgXchnB9p5FFNyb98FAMme4zb9Rba35t3BNrNlRc1DqAOr9NklRVEP+PMYa2TVZmbZAUl3TXSTWwhZOOIjGjOdLcOtHX4bQdjL7Woho4XodKMxrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HG5COW3jQGH0jFBzVGSmnEq+aNQA+Exkv9sglqlMffc=;
 b=PxvO93Kdt3qhileV68L93YwJE6o77Ef/czROG62tapYny9Y4rJAZC5yNzdrj2+1mBaaELb0N9fk13uk3hBsaUgIwY+IaLkMKsWzKPOIaiYRONiP5186TZwUBytqEC4FCbcPzM6rU5Grunrggm4ai2hxfeWgbGw1jK4CK1ql5/4Uo5YTTtBIvL2eDRryaPv4rSbL1L79nAI+pk1SQxFntBylswp4Aq1zc33LsZrW/hymDp+l+e2jo9Ul8/hiBpwQF4ezYOfKnVWAfu2pD9B4gdXuUpsobgshEUiYQRFzDvtVAhwOlyPbPYcEY/zO7lgOVIwdZpdeDfh5D/hhRLrqYaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by MW3PR11MB4746.namprd11.prod.outlook.com (2603:10b6:303:5f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.21; Thu, 23 Apr
 2026 22:29:17 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9846.016; Thu, 23 Apr 2026
 22:29:16 +0000
Date: Thu, 23 Apr 2026 15:29:14 -0700
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
Message-ID: <aeqdOlO3BkKQqSQ9@agluck-desk3>
References: <adQY_m8I2jUiR88k@agluck-desk3>
 <e85cd466-2202-4b40-82ed-91e421d8e073@intel.com>
 <adgNfJSeHVyBXumt@agluck-desk3>
 <c948c358-1dcb-4896-9c0d-239e99d89e72@intel.com>
 <adlIdusn61pKB3oq@agluck-desk3>
 <5a62a2b8-fef8-4808-bbcc-c268f9013651@intel.com>
 <aefdJG4y8JS_aTse@agluck-desk3>
 <1633a669-ac1f-4ef4-b733-e12bb1c6a5eb@intel.com>
 <SJ1PR11MB60831D6EBFDB4E1968B69E1FFC2D2@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <b92879d7-b7a9-4698-bc66-3216e483479f@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b92879d7-b7a9-4698-bc66-3216e483479f@intel.com>
X-ClientProxiedBy: SJ0PR05CA0131.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::16) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|MW3PR11MB4746:EE_
X-MS-Office365-Filtering-Correlation-Id: 25639857-d038-40c7-e1a9-08dea187c11d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: NiAJB+xARBwVWfh0wRZrQyn9lU5Skn0xEQAti9H49XWZQgImsMzpK1vCAKeoF6CEaiN3NPTfoFcqbdOP3Y7E504laKjeSfp5hfaq714IR0NBbbdeXDyW+Gev6tS65vJbWStS2jEsDrHKfELOQv49c9krJ35+6j2rnb1vvRIkjLAvy5iCXq4vFBkNUSW4ldAkcYUwGSLxfW3X/fPWdSMGUG7uWBJs0n5/msFh50qJYhfeQhSRKMJ+AEnjql+LBkK+WTcnCN8DwaSAeeVx5+1opaA2ctnAnmjF/z7OXns8qqWNYGymQXSZorl201Yz6IyIo7RzKA3Iv4pNtTo0V3usJgykfWqjj3GVXjFob90cZTdwDVEknrbDEN8IPlPySvCEifoQIlU37SdRcV7/JJiOU2V0Fw+5lrx91v0CkiibBl/Q42DRvLKEUw/YOnl8CLC38SPu+3UIs39/mTX+b8wkQcARVowkmuWp5mzU7tZ2HGtSR5D/wfCs52Zv0Ml649zXHzjlcQ3Uz5Th85xv24y6A9uzl6jZnwGVokocXkb2FCEbqmDwuP/zn0CKHR7c/wnvMlbVco1JcQkQKC5/UOj1tbIjnVh+9aZV8bbbgJcfMCr51Rdii7b4IIcX2aoIQDsP+9U0PBcjnKKSUn3B57Qx2QipRGo60WNEBQYEQRMY28QVFFAMN2X9DtToa/Q1eHVQLSGLxvEgijLBpHpkN08qt2nw4GvhPcw9lWL1ny7axlFdspjxt3HX1F1BYxqI46a0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lKwb3HcE/h/Zc9iJ+H9kF54n9w/f4qVxHcusGfwtaPZrjULCifnkJIUihC2w?=
 =?us-ascii?Q?UBWqqg2O0rnqnCAvaA9GzJ7ta9xTutW16nD6Is+bLQMR2HvHTkETMhkc0cXD?=
 =?us-ascii?Q?JN8eLS8LUzvOF2qIYjL55shA8aFrNiL4jskxcgWbRV6OqxZWD/HejzAsUhJ0?=
 =?us-ascii?Q?+s1RZNsRSzV0x08iegoRtCTPH1l+llT8B3CjxhEPHSqPKHnOnNhGRtzJLrze?=
 =?us-ascii?Q?Wpb9PEwMLPBOAxoZAcddCff2jWCZ8ZUDmD9FXAVSmhXLuWNM+XmUKn/q0iXg?=
 =?us-ascii?Q?HdWl4WIFZj64X6pO1lnXif5AgQbbADT9B6YF6YPY/Uftv1zMcG41VmwLjQ5j?=
 =?us-ascii?Q?rWtf9Ua3MEM2LkW4/aHVHDTT91h/JPQ7kPt/JibTIydaS712o93E3cuh/5uK?=
 =?us-ascii?Q?QGwhLXFMgNFXyZ/Hj8HDLvOFUqVQwmgqYN7Vk+ZBVI1bDMe/L5Cx2CJyLB+s?=
 =?us-ascii?Q?sW50f36XR/i1iuINFGhqvlWlosy3sQwQnqc40BYhxp/coR5Avc77s1JXnnIH?=
 =?us-ascii?Q?bNppwN9R3wMhFtBch2KiYIcGFZjfQY63E+Vu+kcoUe8YBzIs6DeCdyJBzE1E?=
 =?us-ascii?Q?IGZgz2KnIADzrzYweE+WWldGTodWlFMjbicYc1QL5WlCu8h+kPLnWMA3eyzl?=
 =?us-ascii?Q?sP/hl5tkt9Jt/4/87UHQeXVeYkwHlC08njwLYvQnFhvpxZVBNcnkKlwnXY+J?=
 =?us-ascii?Q?ySly+MBHloStspZVPbJ6fZOXaWeDtecJ/Vi1I1zJnCP0MA+RpXZ5yMXrFrJV?=
 =?us-ascii?Q?WKAHCOQj0T8EhrLR1nNoRTQV20rvai3NihUic8iHH0I9kCc/T9w8cWZKuusz?=
 =?us-ascii?Q?iKUiRHF09Epb11NyO04b3kdgETRtUN7v+iDSsu5OrZ0wTtmVyYvZ/B3h0uhQ?=
 =?us-ascii?Q?l5o4Z6zcOgK8Y1J23/3Ikb4Hz81HR97fxKRYm+0atb4cqml9VvtzHysyiNTW?=
 =?us-ascii?Q?8EcaYUvkZQf963byd1nJyXVG25h0MsW+WJrt7mmAglFeXvDQBZknm4agdA17?=
 =?us-ascii?Q?iKhh3fJfWHuoG3iWSqnzwmnrR4SCRMO+F+5wCPmxJfbKXsiUWCa5l6IfVUJi?=
 =?us-ascii?Q?92cAGdtgMCm7DUNGd4LHSAER93+G/OggjRx0gX/Eo4kXUofVx+pCY9XEOsdn?=
 =?us-ascii?Q?N4nB7+LkpAOt4hGIalwYEobIrd2l1sHUWpaJY5SJc81HHQJJMNl0R2eye6Qu?=
 =?us-ascii?Q?3eY27Q0MnV65C5eKi63HXURZptFY4tg0dpezQ+/HuHz1RvUceGKSCcwSNzUo?=
 =?us-ascii?Q?vyCFQxfmT4qcWb2oaDrxBmrc1jwdW1Ly1vLw5WgUIQarub2KK/LjXv6w1vBR?=
 =?us-ascii?Q?BfeaFcIV75kwrqIApoOcFKTjtM3J0J2qb1Os8n42NOykesMv8GjQ/ztCTnAw?=
 =?us-ascii?Q?YncZ0LIABNlLBawBlQ2V5YN8eekonJrT0+/yHbjKMdzg0COphBeEvx9BiwLE?=
 =?us-ascii?Q?z8QeyLcUhlVzqSWMsp7m31wjHWYGHXc57Y/2tmJjjzBEhmqog5l4k0zyE1Mf?=
 =?us-ascii?Q?tKTx/6EB4iuHWr2ku3E4Z1bMJ87+Lfymv3W/BRadiWzW7NKAaxjmVkNO7UPB?=
 =?us-ascii?Q?bscvGC7R8txmmYNzF9YtWaHoJEnYpbCLhS6muWZr3hiZoekXNOLjUFyPapUC?=
 =?us-ascii?Q?G9zTJJ06JfGC6aiFl1AM2GitcosMbbHWUm+twG/7IYeY/gsjpS4d4i3J6Gv+?=
 =?us-ascii?Q?H76mgFV4exPHY6Cj9QUmdOUZq163T9CHHSh/RNxJTT70o7G8qpIrNhWwxhbv?=
 =?us-ascii?Q?Mihgtp9B6A=3D=3D?=
X-Exchange-RoutingPolicyChecked: uUD4Gzxcz0lCMCRoikY5qE7J412LbH4tHKjrG4uNu87MU1oqBJgkeWVdGA5hp6TeGBLObzs9exWMYJQQe9j1w9oe2BVdHx3QBqGu8z1ztUsZqtOEI3Cyl2UgZGqDebZT0JlZgVrUEhKNhurV30oilPUEzpSvvu/vvb+dgxq0qOUgD5AdYZmKFBABMIQZtNeKCywSoj2q6WVB1Su9uvE00eUPhaldrRF4EgAUrWH64Ey0Ha1ymsYwfD0nxd8lI29LfOGNe5+WYrjN1dXnkcHF97yo19cIjj714YntPTaqmdeAfk05FJFh92qjoP5SBoLZB+J5tzIMQphJk8hpgkSWWg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 25639857-d038-40c7-e1a9-08dea187c11d
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2026 22:29:16.8448
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wZbB0diqMmPm8METje62kLUJTD8Tf3By8Y+ukHkT09EOXlgO6v1FfUOPUyL0ACYbXbqpftr/hcNdmW6a5PwTuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4746
X-OriginatorOrg: intel.com

On Wed, Apr 22, 2026 at 03:10:59PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 4/22/26 2:59 PM, Luck, Tony wrote:
> >>> Seems OK. But to make sure that events are accessible, architecture will
> >>> now have to "hold" the pmt_telemetry module regardless of whether
> >>> resctrl file system is mounted.
> >>
> >> Could you please elaborate why this is required? if I understand correctly the
> >> "hold" on the pmt_telemetry module will be done by itself between the
> >> intel_pmt_get_regions_by_feature() and intel_pmt_put_feature_group() calls.
> > 
> > If architecture code runs completely asynchronously to resctrl mount/unmount
> 
> Since there is shared state that is managed via existing locks I do not see
> architecture running completely asynchronously to resctrl mount/unmount.

I think I now have a solution without any new locks in the file system
layer (just a call to resctrl_arch_pre_mount() on every mount and a
call to resctrl_arch_unmount() if the mount fails, and on unmount).

Testing in progress. Cleanup to follow before posting.
> 
> > when would it be safe to call intel_pmt_put_feature_group()?
> 
> I think I am missing something here since I have been assuming all along
> that intel_pmt_put_feature_group() is and will continue to be called from the
> new unmount handler.

Correct.
> 
> Reinette

I'm looking at a more aggressive change to the Kconfig options.

Linus complained[1] that the biggest pain point for new people is getting
the kernel configured. Extra CONFIG options was his prime focus.

So I'm looking at removing CONFIG_X86_CPU_RESCTRL_INTEL_AET completely and
just making intel_aet.c included with CONFIG_X86_CPU_RESCTRL.

It does mean the resctrl will depend on X86_64, killing 32-bit support.
That was discussed before and decision deferred. But there's other 64-bit MMIO
stuff in the pipeline that means we have to make this change sooner or later.

Thoughts on unconditional inclusion and on removing 32-bit support?

-Tony

[1] https://lore.kernel.org/all/CAHk-=whigg3hvOy7c1j1MXFy6o6CHp0g4Tc3Y-MAk+XDssHU0A@mail.gmail.com
