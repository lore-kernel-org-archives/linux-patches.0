Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BD334A3C5
	for <patches@lists.linux.dev>; Tue,  5 May 2026 16:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777999555; cv=fail; b=Uh/jkh5MqmtETMPz6Xk3an3VmFBf32H8F1SAP+gkido3g89zRQUmnYT2cyzfd0mBxJX2SkXm0Fkn9pPugy50+b8tMtiTN+kF291TDBDGDE12JOfyK1gI1otDSyy/QqB5jcS+7WD3FV8mggrsknCZ1ppqxQEgCU9059hKmGWGunM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777999555; c=relaxed/simple;
	bh=XKz5fzXPwj5BijkOM3TIySsnDBB17NEdAGSQvH3jWCc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=f8TlzK8IaNtlDqxpHrKn2H73zLTRR6cUhKdiHP5lYHORZlkg0rTokhminIzOet/M0MX0BzlrwPtaIRR2Eyhr6h07usrezOHKaTXuuqpybnnhEIEn8AOm0FD1KxiWcoy6DpTy7iBkSnvuSSy9dvwrMH/F8dF0jitfAl2asMLqAaM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MFgmOZir; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MFgmOZir"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777999553; x=1809535553;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=XKz5fzXPwj5BijkOM3TIySsnDBB17NEdAGSQvH3jWCc=;
  b=MFgmOZir0p5PHakxRLUn6dRmjle1VXyxnTv1mwleUDZt97hwlOGtMsEC
   ioRKON/3rNgN7vqCdvsKQq4yIgRAWIE0duFrpw2R7+ANeKEbr4XYorwJ8
   ZIptxpuQVGnHhMPbdh/x54FiK/3od2IAd36hLByU0EwD6xI5WqY4qhLC3
   +7zIE0Z9gqZ7n6dDAF9NJK3tCDDW5gIlWHCn37+HMPcYAmU3egdxYDwrq
   wiKWGSrWJNq/wvvlGZETlqz942UDcfdZR7uAIgezvzMBMv4toXOQ5fCBL
   34N/H/bBwIEQA56fIMmKSKRhe0S2Kyoquv0dz+vNSAGKhpnQ/WZoxGsen
   g==;
X-CSE-ConnectionGUID: CToiaVp3Qs+18zvG04IJ+A==
X-CSE-MsgGUID: nNi0IvUPQleTsNCTJ6zATA==
X-IronPort-AV: E=McAfee;i="6800,10657,11777"; a="104327379"
X-IronPort-AV: E=Sophos;i="6.23,217,1770624000"; 
   d="scan'208";a="104327379"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 09:45:47 -0700
X-CSE-ConnectionGUID: DG3O8gPASbegx2zWcYW7Eg==
X-CSE-MsgGUID: jfDywotXTgKy/801Hbrhrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,217,1770624000"; 
   d="scan'208";a="234857871"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2026 09:45:47 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 5 May 2026 09:45:46 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 5 May 2026 09:45:46 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.20) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 5 May 2026 09:45:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UqczqlC3L568zL5a73AXsGWF7lRK4TLeWBiqRdydmgJoJomGbSTeQPhkob0d9ogAVd1egWDfyBoQETx1Kwt2XqoPBuAuLRzeHNqe+o2kpriMeoK5LsH3s3VUgy2pazW6/4AsNco/3AlYCOTlp0d6ycDnb8ExdmdpMxIRKkssPcbrRJoVwrgura+AqONMii163xWBhpzRtT4dr9VO0QzVdSUtEJEUuCl3FK2nnkpdguaa9buOMy+ZoE8X0UG5ORvTfIFK4vL9PLo6iA++tOLdvRlP83l4uNv4z5Xovdl7P6rfTEFodSAYZDYEY6u1sLAGD6JhfZKejdOAGgT/t3OSzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qoXnYn0xEGG9WdNOyVDe9GtFTFdoGkZQ2GvuMKTe3YQ=;
 b=V9dN3Fvs2RUNHMF+5hG5htFceCWGDtQWrVyWmlsINjIqhkDHyMn6PK8XkNCo4JanRgKkBLfUxF4XDGF9ykirZGn8I39IxqUJgU074J8KY29epA04NqlwNLZVsXpncTbrGXOw5bG0X8JA84hfEbpdG4jZOdx+7MwN/LJznjxZWjXT700rDsE8ugxx3Nr6eutQawz4JS1XjxGJ0qpnSkflfyLGqFkCNuHBmILlAmTu0Q+i37tDgy3x/M+EyK1CnfBcXVLDGNgYz0thXusmK4tpGjLbYPiNSU9u8oWb6Uhhe9CAKLBscVhFia65JC8gRwfQGy4ojEcnRqDL5a2xE9PESA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CY8PR11MB7314.namprd11.prod.outlook.com (2603:10b6:930:9d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Tue, 5 May
 2026 16:45:41 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9870.023; Tue, 5 May 2026
 16:45:41 +0000
Date: Tue, 5 May 2026 09:45:38 -0700
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
Message-ID: <afoesuWB8RezVLrN@agluck-desk3>
References: <20260501213611.25600-1-tony.luck@intel.com>
 <2236fae5-7e66-43fb-ba05-76fd4434e2c9@intel.com>
 <afkizhrSwJkiLD3j@agluck-desk3>
 <3f13c7e4-3812-447d-8c42-b28fd6b9d0fa@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3f13c7e4-3812-447d-8c42-b28fd6b9d0fa@intel.com>
X-ClientProxiedBy: SJ0PR03CA0388.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::33) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|CY8PR11MB7314:EE_
X-MS-Office365-Filtering-Correlation-Id: 90c845ae-32f9-465a-d092-08deaac5be0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info: wsUMa2eZV91kBpRYEG2mXD8w4C4Pn6yBzQ+lxdguKK6pVyzTqDFYo4H1tee4xLQAevHv4JrlScMrnCaVK8Jjc2f0SMrLcCZFJogjxfTBjGatJsHA9ectsKGIC26BZc2X1xt0MLswqA5+V91sLt5VbMOI68XNozOveC9ZxCz808lDiNp5O8jtPoGdfDtzrNo67i1sSwY/S6A8oeMok3T8xz90I9i5A3EkeQmhhZlV2FUAUJOceIHZBtTTL8+KUvLSptZKvBPzl5Cw0cMO0PNw1lDWQi0GY4zaWicZf2TZiogrA4rzO9N5hY44MHuwjEINCrhDl/FKvzXQwiID0CbV9LxjOdjRksKaL4hrHU8cdLCDtCmYA5QclumDei1LMpqEYdOzcenJQuTGQECGeeGEto5SA8DHUKoQImHRdXU+PzH+udW++Pr7R61wNjSF3Onx4E0OeMdIQ3997sWAWC2+oTLkNkSRX2+tWUzoUTvQ+0ptmyxyJklsaOiaEPZafEDsH6oT8qq+1fGbfkn5dB9/dShlh1kq1kAYBHuhBN8LRGcaZBzgTzLNb3uKTPk8JRfq82MIn3gTcYmSwXGIP+/L3mxrurpx+eN7kHxaAkaHBQlK3nMqThAgOEKNuzgk9ZrGiaNlF6aL+98FB/daISTDSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8FXQTAfELAXXwmdQEQyHYYzxoafoMM9NBpuEYXBlo+cTDHacmkW5pKJptgAs?=
 =?us-ascii?Q?YTsLCkMSdqHRHT4rxNTZADRN+CS4fh6pa2SGXAdHgfv46juPUXM64jT4h1Uu?=
 =?us-ascii?Q?WpL7vGWV70wCC9bcpEIb2PyMCgw6KEvZDrhjB1EyAPSaor5GasEEDBQ79o/L?=
 =?us-ascii?Q?MXLz7bsTI0JKlltykNeFR7AGf2TalfrIFww4e375ZO4JnPlFonKDQ4hPLuXY?=
 =?us-ascii?Q?zYuyJ2HnHw4L7hILkgKFoR5+IydbYGp43OL1NRt12c5aK+PVAG7DEJPgM1sl?=
 =?us-ascii?Q?IFJyuT2g4evcvDU0czNJd48a6sajb7PAmCAlZBdSWrIqPd10guJWYhcpxYNl?=
 =?us-ascii?Q?YZmm9oeSbXmBibre53U478ZZ/cwyI7ZwXrqW76KUxpUp61siUuhjd7lhcBlh?=
 =?us-ascii?Q?lwu04l7rJ9iWOMEt1Kmjpo6jx65rEsNcMHD0PgYFDDustH9xiz3lm9nYq7lB?=
 =?us-ascii?Q?5tlFf1d5Iu5EjUtIX+YgiLbrxN4sfobnjJo9QiTiz3wixQ+JKC8cBvurZBYD?=
 =?us-ascii?Q?2M5uwayObGJreiBe2abfmkClmUrlTetgEPxVOr1G4LBjBPzy2wVsRRISi1d/?=
 =?us-ascii?Q?5eJWg8Sfw5RoRmIhK5aYRpBbl8WrXWKpWQgIbNctoOxSmkC9OuU06sTcbXe3?=
 =?us-ascii?Q?ZLY41RFbbDhYK2fQRm1GfyU6UVKVhKFhcLofymsCWPl5jxbtZozRCQPji7DG?=
 =?us-ascii?Q?05d9um0RLNv4gPMD/Hv2EMkFdiE4pIDQgVOAgi55KoRCQIY+Xqbox+fMnv1x?=
 =?us-ascii?Q?byNz4owhzknzXrgVcgJXWHhFo+YHGNvtnwZk43O0BrY8hIRdm8QYIUOOgSEo?=
 =?us-ascii?Q?72r+Qo2krZNy0RovdxpAiQNG5CSIVNfK+DU+BCsghVytiSAtGlGzBImUx2ro?=
 =?us-ascii?Q?KEKkSH68YIJh0dN2tF3tLa3PW0crzp65vMNrSh/RjcnzFpdRfARyJm0W6qGK?=
 =?us-ascii?Q?5rcKPyzrthulNEgVBP+/1Wo/zsXkjaZNTfH6D7CUa/4ZwSfcN0RhwlefO0ii?=
 =?us-ascii?Q?Z1sAdVU2sYp4Aqhc8dpxubhvbH0ebmHQSEViDzvOFrjq/HSzsXPITWaLSN3i?=
 =?us-ascii?Q?KgZtmr60FPr1JfLEmq7bA8HBdl2EX2I5dBwts6R9H0MOj15kftPLy5mqOM+Z?=
 =?us-ascii?Q?3xXLEONoyqE+J60pg/cza7QKKTQf6waVqrRqyUPU0HkquXPA6XLQyB+BBPZR?=
 =?us-ascii?Q?//idLZeDVGm2ZQAj/CCwc7DvIE9scnJKPwUveT+Yh9uR8bJ5E40CMXC1DJ0g?=
 =?us-ascii?Q?EPlzABZ7BT4vnrAyRS7YeW5IwOZwJgAkf9OhFEv/3q9L0UJ1qQhz3OW0tGKe?=
 =?us-ascii?Q?CT3sBoMsXmL5Nd/KyHFacTgx8O19s6sbyn4E8Em3FQu2d135DdsqC6tuXPEB?=
 =?us-ascii?Q?7xa3maopQmngZBf0m7rPBXZ2flltMoOOPnLOVjoEUk256GXY4ygF4rqcJ52D?=
 =?us-ascii?Q?U3oUWa2OSwbg5L1PE9BfYan34dRCEBOqvqR7jY2r9e8UzXJ9de/PrpPsqbS3?=
 =?us-ascii?Q?dTJbK/h30vTP9AEoo0v4bPfTqvT0FOHuRRW8DdWiCexeYM6qPiacGMrSwVDg?=
 =?us-ascii?Q?ov5zEsXqjv49FI4ItnKLYNF4rO02Ot+vDhzi4Ixyj3G8obxfQrDYOe7egWtM?=
 =?us-ascii?Q?7KKEGXTRfIEM0OW6/jlGMMBfDG/XnRIRKvt5MdydMBXI3JFe56d+ktY86T4I?=
 =?us-ascii?Q?Lt+Zt1Ivzfnpn85xt1y+rRnppkVlQDsyW79RmXnDaLQBRph+tn+iQg8MolXj?=
 =?us-ascii?Q?aIzx+qeCww=3D=3D?=
X-Exchange-RoutingPolicyChecked: hqH90tKujEa5l7LoHSAU2qxC6Airr0l2sndSXD25+VENeFaX6E0qOIRYHJFzR5u2e9hjW8MNtMRqn6lDcaa3X1MxD7ZmQOnwOilTpLXopo5QbXBfq6lnkoMZc6TWNvyFfybjHY2vTMjQqYNW00lZj0Z4OhgwiGjEOFVVjtziWprAt1yWXCANcJt+1TuqT50EfewOodF1+arCjP/zekgss4oYSnC9iPQF6FYbRjip5cB2sAdEjG2W78hlJGEq5gN9twv+2IDSGqN+JDBkIHZ1ftZABwvEQthIiXECiDiDIVv7HKlaw0ohyaNYWgYuD//JyC9K/+cqutOLvk5H4jwXjQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 90c845ae-32f9-465a-d092-08deaac5be0b
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2026 16:45:40.9241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WLr7X0npdZ+u/ykZuN/gCTBGl0LLTJhD+SUkTc8tLN61mfVrurKPD14/ZhHGGYXwYyxV9sCcZ4WpH0CvBPNeHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7314
X-OriginatorOrg: intel.com

On Mon, May 04, 2026 at 09:39:40PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 5/4/26 3:50 PM, Luck, Tony wrote:
> > On Mon, May 04, 2026 at 08:11:48AM -0700, Reinette Chatre wrote:
> >> On 5/1/26 2:36 PM, Tony Luck wrote:
> 
> >>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> >>> index 9fd901c78dc6..e68eec83306e 100644
> >>> --- a/fs/resctrl/monitor.c
> >>> +++ b/fs/resctrl/monitor.c
> >>> @@ -794,11 +794,14 @@ void cqm_handle_limbo(struct work_struct *work)
> >>>  	unsigned long delay = msecs_to_jiffies(CQM_LIMBOCHECK_INTERVAL);
> >>>  	struct rdt_l3_mon_domain *d;
> >>>  
> >>> -	cpus_read_lock();
> >>>  	mutex_lock(&rdtgroup_mutex);
> >>>  
> >>>  	d = container_of(work, struct rdt_l3_mon_domain, cqm_limbo.work);
> >>
> >> Since work always runs on a CPU belonging to the domain, could it be simpler to use
> >> get_mon_domain_from_cpu() using the CPU running the work to obtain the domain here
> >> instead of the work contained in the domain struct? 
> > 
> > Is this true? When a CPU is taken offline Linux picks another CPU to run
> 
> These are workers supporting monitoring and they read RMIDs from where they are 
> running. They do not need to IPI a CPU in another domain to read the monitoring data
> of interest. Are you seeing this behave differently?
> 
> Theoretically resctrl could have workers run anywhere if the events being handled
> don't care which CPU the monitoring data is read from, but the current workers
> do not behave this way.
> 
> > any unexpired queued work. No guarantee that new CPU is in the same
> > domain. I think a robust solution is going to need a check that the
> 
> There are a couple of places where the work is scheduled. I understand the
> particular scenario you refer to to be the work done by resctrl_offline_cpu().
> Specifically,
> 
> 	resctrl_offline_cpu(unsigned int cpu /* CPU being offlined */)
> 	{
> 		struct rdt_resource *l3 = resctrl_arch_get_resource(RDT_RESOURCE_L3);
> 		struct rdt_l3_mon_domain *d;
> 		...
> 		
> 		d = get_mon_domain_from_cpu(cpu, l3); /* d is domain to which CPU being offlined belongs */
> 		if (d) {
> 			if (/* overflow handler currently running on CPU being offlined */) {
> 				cancel_delayed_work(&d->mbm_over);
> 				mbm_setup_overflow_handler(d /* domain to pick new CPU from */, 0, cpu /* CPU to exclude */);
> 			}
> 			if (/* limbo handler currently running on CPU being offlined */) {
> 				cancel_delayed_work(&d->cqm_limbo);
> 				cqm_setup_limbo_handler(d /* domain to pick new CPU from */, 0, cpu /* CPU to exclude */);
> 			}
> 		}
> 	}
> 
> >From above I see that the new CPU being picked for the work *is* guaranteed to be in the
> same domain as the CPU being offlined. What am I missing?

Here's the scenario:

There is just one CPU left in a domain. The mbm_over worker is woken on
that CPU just as user requests to take that CPU offline (executing on
another CPU).

There is a race.  mbm_handle_overflow() has begun execution, but the
offline process has taken cpus_write_lock() so it blocks and sleeps
waiting for cpus_read_lock().

The offline process calls:

resctrl_arch_offline_cpu()
-> resctrl_offline_cpu
    -> cancel_delayed_work(&d->mbm_over); /* not the _sync version */
    -> mbm_setup_overflow_handler(d, 0, cpu);
       Finds there are other CPUs in the domain
-> domain_remove_cpu()
   -> domain_remove_cpu_mon()
      clears bit for this CPU from hdr->cpu_mask and finds mask is empty
      -> resctrl_offline_mon_domain()
         -> cancel_delayed_work(&d->mbm_over); /* Again! Still not _sync version */
         -> domain_destroy_l3_mon_state()
            -> kfree(d->mbm_states[idx]); /* file system state */
      -> removes domain from L3 resource domain list
      -> l3_mon_domain_free()
         kfree(hw_dom->arch_mbm_states[idx]) /* architecture state */
         kfree(hw_dom)

Offline process continues. One of the things it does is checks for
orphans on the run queue of the now deceased CPU and adopts them.

Finally the offline process completes and does cpus_write_unlock()

Now mbm_handle_overflow() can continue. But it is on the wrong CPU
and has a pointer to a work_struct that was freed by the offline
process.

> > delayed work handlers are on the right domain. It looks like existing
> > code doesn't handle this well.
> 
> The work is also scheduled from resctrl_online_mon_domain() and then re-scheduled from
> the workers themselves, cqm_handle_limbo() and mbm_handle_overflow(). In all cases the
> workers stay in their respective domains.
> 
> Could you please elaborate how you find that the existing code does not handle this well?
> >> This seems to more closely match the pattern used in rdtgroup_mondata_show() that
> >> stores the domain ID in its state instead of a pointer to the domain and then uses
> >> resctrl_find_domain() to find domain.
> >>
> >>>  
> >>> +	/*  If this domain is being deleted this work no longer needs to run. */
> >>> +	if (d->offlining)
> >>> +		goto out_unlock;
> >>> +
> > 
> > Claude seemed quite confident about removal of cpus_read_lock() in these
> > functions. Sashiko is confident that this has opened up several new race
> > conditions:
> 
> Domains are stored in a RCU list so if cpus_read_lock() is not possible they can also be
> accessed from a RCU read-side critical section for which x86 do not have an example at
> this time. This would look something like:
> 	rcu_read_lock();
> 	list_for_each_entry_rcu() {
> 	}
> 	rcu_read_lock();
> 
> The definition of domain_list_lock within arch/x86/kernel/cpu/resctrl/core.c has a nice
> writeup created by James about the locking requirements.
> 
> I do not think cpus_read_lock() should be removed. Especially not since my suggestion is
> to actually traverse the domain list using get_mon_domain_from_cpu() that will complain
> loudly if the CPU hotplug lock is not held.

Agreed. This was a bad choice by Claude, and I fell for its reasoning.

> > 
> > https://sashiko.dev/#/patchset/20260501213611.25600-1-tony.luck%40intel.com
> > 
> > Maybe we need to add a reference count to the rdt_l3_mon_domain
> > structure and delay freeing it until the last user is gone?
> 
> I still think that using get_mon_domain_from_cpu() in the workers could work here.
> Here is the idea more specifically for the MBM overflow handler:
> 
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 88f1fa0b9d8d..7186d6d02d6e 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -856,7 +856,9 @@ void mbm_handle_overflow(struct work_struct *work)
>  		goto out_unlock;
>  
>  	r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
> -	d = container_of(work, struct rdt_l3_mon_domain, mbm_over.work);
> +	d = get_mon_domain_from_cpu(smp_processor_id(), r);
> +	if (!d)
> +		goto out_unlock;

This will get a domain, but it will be for the wrong CPU.

Maybe it doesn't hurt for it to perform an extra set of mbm_update()
calls on that CPU?

It will then do:

	d->mbm_work_cpu = cpumask_any_housekeeping(&d->hdr.cpu_mask,
						   RESCTRL_PICK_ANY_CPU);
	schedule_delayed_work_on(d->mbm_work_cpu, &d->mbm_over, delay);

This "wrong" domain already has a worker ... Will this just reset the
timeout to the new "delay" value? Possibly also to a different CPU?

>  	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
>  		mbm_update(r, d, prgrp);
> 
> update_mba_bw() is run from mbm_handle_overflow() and uses this same pattern
> to get the MBA control domain which I find to support that the context is safe.
> 
> Reinette

-Tony
