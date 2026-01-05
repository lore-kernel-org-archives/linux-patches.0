Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7BD30F951
	for <patches@lists.linux.dev>; Mon,  5 Jan 2026 19:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767641977; cv=fail; b=seCta9CmfxoxKKl7vWFDVJVjaRgZmI20P4eFioHzA3kDhv/1Tl5UlSslDzWw+0JW3E2UwMi47lUTIfxNH4phnxFUdgWM8ABfG68XViwhFPG1KPzX4q3YReJRXp3MiNyc0E3cCf7M1PRhxOjlUYHZbrfDl+P5DBPd4jonmZmo59k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767641977; c=relaxed/simple;
	bh=ghk9lz+N+L9Adm6tjvr7kCkFUfi1RBbrvL/b3IrAD28=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Bog89smlrmKj0T+BdbnevT9lscFjAHGvbDPvonE7akwSGisaeDhkd9JbXdQcrXIy2M2w5vO4xyztJjAW0VHJSSThvGBg2O4V4/674A6PLEJtBtcpusWGpR0fJdv2jLhMArEAbSHSYy4tnWqQHW/nId+ZGU6LikZ2073ws3XM+2Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UnYoenvM; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UnYoenvM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767641977; x=1799177977;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ghk9lz+N+L9Adm6tjvr7kCkFUfi1RBbrvL/b3IrAD28=;
  b=UnYoenvMwo4aBRsIn7yYgp+XO7850yqVd93do7Es1ltditG5gg23SEg2
   ARBcJbCSvgJCR4LMAvtTMaOx9LuCjIafUtPw/XdzhOhOVje5mRctGM+pG
   5jhHpFYMQA8mjsOuuXsUsuI8iBOIjR4olC95eXrxa6320SOjHpW7N6mSe
   FVTWKhHOVRgeLCvUrBvZs0yR0tH1NTBVkdqmJvNFFIPF74Nq7sVbnJPco
   cnbwEoUkgiTV/OndisA4LAuxMiXzH3udy8RfrVXLQi/BQKk6zE5CtO1XW
   mbdqmheW1OTIW/2DKc8ig+CMxGl1XfOMzATXq55ya2z5Csnv3FgKwnSN/
   w==;
X-CSE-ConnectionGUID: e//4rvT6QcGbPrka+OQEwg==
X-CSE-MsgGUID: 8YZ+J4HOQs+wBQaK0fUWnQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="80129575"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="80129575"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 11:39:36 -0800
X-CSE-ConnectionGUID: oZp0eyiYR3ihQt1imhG+vQ==
X-CSE-MsgGUID: BqecfuXpRv6M+xFYbpup/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="233601840"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 11:39:36 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Jan 2026 11:39:35 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 5 Jan 2026 11:39:35 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.20) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Jan 2026 11:39:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yz8ijP/JuDxfEHQC/D9/1z9KPWOppRVRdenNt/1p0ZQbqj65qGIxOD8Z653HOoMXjw7f4Takx2wb4soJ4wPZ/agPPvEvVKazB+ADQEw+Tn4Fqcv6zZkYX9JQNaWRovyBj2oJQI2YvFk1BTX52rehrmNQ0/SwJ2AcJ0bfd//1YZdkPmhTMkel79DSHBh43H6M3jBA7/6qoJDc8ncqMoRvgmf/5+zTIQ5JbHltyFQzRmyCc2yk3vQbGer8zNA7qpJxSi9JbygL4wFRKgK0B6O9wZJgjySw+En6rO/n4OMxpqterItDw/G9/5V4cvRnX7EoQtJzqXYsqEHnzS3Qob8/dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XppqTbd7WmO27L6q/zdpK/36CAWhrcz6UGplj/nXdrE=;
 b=M0gOkTPvpJZXZ/eBv6sS2mb5Q3U99f1A5beZ7Pm+XmF7UYjFioL8yAoyvJQ674AjcWWuMkIBFCXwi/nmwEJHAZb98+/7DiZ6baEtjk8JCWI2PZq9/ppTEbTldqCsbR33P70aaSyKyQguLHxwmyT6lFuqMVsUmOA4wRnjRcwiYsxY8qgZtOwGaoJiuw98x/3mmPvsUgRPx0Enjt/KMP0Rl7nTpqh+UX5kdLGjGxaP+TANCzGqVyE9SUngWL/xj4cGrk0UmwRZe9hOeUlKiLQjV2t51khwphsXOfW+0FlTXi4W8I2jjy6nPpN9WSDXuhyuhBGotvrYYtO4Ov81DgrvGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA1PR11MB7919.namprd11.prod.outlook.com (2603:10b6:208:3fa::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 19:39:30 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 19:39:30 +0000
Date: Mon, 5 Jan 2026 11:39:29 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Fenghua Yu <fenghuay@nvidia.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v17 13/32] x86,fs/resctrl: Add an architectural hook
 called for each mount
Message-ID: <aVwTcX7V_HN2j6SW@agluck-desk3>
References: <20251217172121.12030-1-tony.luck@intel.com>
 <20251217172121.12030-14-tony.luck@intel.com>
 <20260105191711.GBaVwON5nZn-uO6Sqg@fat_crate.local>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260105191711.GBaVwON5nZn-uO6Sqg@fat_crate.local>
X-ClientProxiedBy: SJ0PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::13) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA1PR11MB7919:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a06229e-f546-4c36-7a5e-08de4c9224e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2BGoCBhbcMv8YKtqyfvhmBxpytr7HVVxNI5ooBCdwuk0CqG5nvpW0tf/GE9+?=
 =?us-ascii?Q?neNz2itmig1Pfw7hVHOT/W/AMOKKeFOFiJswW62bwAuDGFfBPwMA2JODACYR?=
 =?us-ascii?Q?AIdd9iNv5o2x6NLxWl4WzwLtRGzeCzkpwNVFDFwsO71/iR2meQPS6cGKDyKs?=
 =?us-ascii?Q?MpRj9+L9my5VtNeOVgvf36VyZebeqwAC6LVaDR0I+Wz5YjIwYm8ASe6EZk2A?=
 =?us-ascii?Q?6Ep7+/8h1UolObiuqw6pOX5AmfAuDDn5er1nq51tHPtIPb/t3v/e//RKvs/E?=
 =?us-ascii?Q?B0M8G5cduG2H10rZPoavS2E0A1igaTD1eGsjC9aoCfxKLLQVp44ZD/tqRwKG?=
 =?us-ascii?Q?ykBCcJCp8V/kMAuIHKhhNZ9DYwuT2sKFyqR7ngzF0nkRVnUaJpb46Cj3YuQs?=
 =?us-ascii?Q?C1Hx4tLhVvC2SEvCOwdfHoNZX0ZMYXxJE2myi3eEraipdZ4YAhsn9CNKthAp?=
 =?us-ascii?Q?7NaHhP3JzbD7YeLrdP6amQysCqdLFKgfeUa8lkPKNs4CWz0YrESys4NKsQQf?=
 =?us-ascii?Q?UZbbP775qQvsGug+wbGXaPpd3S5NqpDE0fICq8o6OVGsqG3NbEdfXUfUSzqw?=
 =?us-ascii?Q?DlcrIhrP1SaMO31ija3+KpMOUDmSOPT0cMjzktU9935h2L4TbLAzuYJsVu0x?=
 =?us-ascii?Q?GXC4cEGVfWo3wT2y76hUNbgO0GiMXPLbvXfdIDs+GoOaZGW+cer0ZNBaWPmd?=
 =?us-ascii?Q?jqJmKcg94SnRFt57gh9E8M4bSfZdj6Y+v0XaBsNsLyDooRKQaTv60qu/iUIO?=
 =?us-ascii?Q?87lfGli0CJ7bZFZbFE/eodA6IUxxAQtLaFTt4TPwCtTuBNSrJog35COH7FJB?=
 =?us-ascii?Q?1/KX4BQ70GgZRJivWhXx7OYwtOTfvgPtfgbfKK0P/sft5oVYuv+LooNpLISF?=
 =?us-ascii?Q?JD5aSIrTnwABrUZqfo7wZCDNUOEmSLobnjl8wwGZPbm+chkJ6NpBp6SPYaZD?=
 =?us-ascii?Q?89iWrWwbt51/sBCfSE+uEs7T8aN+LIieHyORJjRUxrMBlsFDIliQp50duFPE?=
 =?us-ascii?Q?+hy0V211gwS7SO13xc5qaCZCXhHXVBhJcJIPfsDuDO1y/aqm81gI4uVKG+TY?=
 =?us-ascii?Q?5fQa3VlylVuyTQA1OeXMsm+5c13IFBwOY3xpvDMd5lqvfldbcdGyLUp++JAh?=
 =?us-ascii?Q?5gJwQaPXxw94ExpOcz0Wjml8LudAitnc7U8wttr7hVsg1jNgw2uoxSHAkTvF?=
 =?us-ascii?Q?IxAHQADn/lF7RQOAfjg8nzrNERiQ+Byz6m5fpKDJlYZq64IMZst6j8tfXhZV?=
 =?us-ascii?Q?D59KdWi+4ghFGMCksgxifZ0JD+hmVLKXxn1jonX+hdFPmArBH/0puQGyaHIJ?=
 =?us-ascii?Q?R0IaM6chQ8893O58vm6VsCTGPAmON3CJWsWUnE498kl0ze7z5kCiHfcZtz6K?=
 =?us-ascii?Q?R2TFna+22SJw9auEvCpYZ94b0itrscCBr8TRlK8kK7jIoDvIYqO+hOj5vDsg?=
 =?us-ascii?Q?KMwyYv+fgQqsm1ltiOb0vo8cWr8eBSOy?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MXjHYjO8mY1SCqlQ6sCYud47lLZwUjF4YsY12e+w5zcdAvzYGS5ZJtslZOxx?=
 =?us-ascii?Q?9ZGVpnJnyvG2r+OzL1m9IcFlr/cAH72JITp5Tj27N7N4XLgWlCnZNh5inewz?=
 =?us-ascii?Q?jqEFTBoddl8sBOP/AMNFN2AatLmOZeNMLAQzE2rHpCIg5R2yFTq2ko5ZZW9S?=
 =?us-ascii?Q?IRG73TI5aeiJYHPWK3ZpZXj9ien3+EGrjBAcOtuwqhuj5pPOkcaudPDfO4Op?=
 =?us-ascii?Q?uigBaxD8zDWVOcrDL0AXADCmy1/f7fyzykpBWQjfhVL85Sm7n2JFcSEzJA6+?=
 =?us-ascii?Q?ty4GghdN17o0YXxSYiBbPBFP0ZAWH3AR45SGgtMdX7iqU45jWWBscJxPxO5Y?=
 =?us-ascii?Q?OYUW5QrpUxIUW9scXVKdbuBJcVXyd3oUvCrFweal1Wmo4vvpn4d4D/fXTvUl?=
 =?us-ascii?Q?HZNhRuJ9ub7vs2cUPYZEsvLOpU+GHQC0WzL3WefbOsZQLtMOS6OXVZk3F8sX?=
 =?us-ascii?Q?kaHa/fLDlYAA944PF6cNqdQNYx152Kz6/J11xWt66D7+bJsSjS+lw7PqFezL?=
 =?us-ascii?Q?IX8sOCa2juKvq0AciRqfczej0wCOP+w/XW4WEn5+HcTc8Lbi3zk2ZXxd2bpK?=
 =?us-ascii?Q?KB6sUlQPDeojjzQI7UV/OUer3B4BH2TurGUNE6Y/ZenFhiFCalixsCB6tVpL?=
 =?us-ascii?Q?1OgAHLUQ/WwX7lZxZGcslNoU6plafRKEY1O/TyiDEUfGywqgLvCqePihzbHD?=
 =?us-ascii?Q?LxCuyM4lKdA9VUJrMX9JwcOrHr+REzsskRAqRGWVt6QG97aaThOqgFF71K8W?=
 =?us-ascii?Q?m2/uDxl3DMPeWZhE7334b+k/qTkK5TAmQmH29svyfm0iWxRBgv6sfe2PtCIw?=
 =?us-ascii?Q?HvVKu49+2Sv6TtWpZ+1ocoFoALbJugltisvWIGdwl6kmKwnXXC+MnrxcTYZ1?=
 =?us-ascii?Q?qJNdkZMg7hgDo0wnbuXUFVp3iKH38Fw+NxnogEDAafhiPxt0+r4ga+pYa1E2?=
 =?us-ascii?Q?EHkaAV6M02br1FJdK15sh7xLYFs7lWpuJtrnGbcuJeZvYRIBpcqll/tqnIfR?=
 =?us-ascii?Q?rhoMHn+1zhf3QP07J5rN3eqTZyHc1J16rvq1u0yNZE1uj49OWZ874t1CFgPA?=
 =?us-ascii?Q?QTxuropHExNb5ZAbVuVdvyeCwQS8R48zt511jqHaM4Zdb1kSfUKbTtDmgP6G?=
 =?us-ascii?Q?lbzsddzkW6eeTtu5VNicJNkKE/nAax/+7NqrdR6SOl1t8vCO7tg0+uvSVmyx?=
 =?us-ascii?Q?HhA2Puhg2mvwSJmPRcrre/tdp73loIJ+bxChpsFrp4Ol+2XDnToOTKgArcUO?=
 =?us-ascii?Q?gP2QSBqUyOLqMRpYXdbqSdf2Y/ZLdxSvlLlijSHQwtOyqor6hhvI2cM8grd0?=
 =?us-ascii?Q?fREpePs+fypIDI39IXl1yE0IYYRAt15cSx2mEg2jt3cCZ5GUd7bZ/O03W93k?=
 =?us-ascii?Q?y8IzoQgfu0jMDzvtbDZrpygC75zUIQsFeT9cVnzVfISBi1zyLAkTz+725LqA?=
 =?us-ascii?Q?v8fNpyOdXOvh3wsk6ET2eUiFsvM3qX0Go/vM1dWfV8nWclSvkqpZCxcxID0j?=
 =?us-ascii?Q?0U80dgppxOQtF/pQMn7spJvyKnGlp+2SWZyEGyLJSpRYxpg3XDNgmf1ecgdu?=
 =?us-ascii?Q?xryYlJdWQqKxVp5O+4mTIR4zBFP5EpMlmz6Qf76xsAnGplrFHairWJKDZJ1J?=
 =?us-ascii?Q?mciO5ZHF+HbYpjHtP9oRRPazAqSjR9/D5szh/9WlR01gU8XTTuMyFFOuNdfp?=
 =?us-ascii?Q?T+BMqCS/8LgH/D2qbrUuzTvr/VhXyKFAzHZCeyqnxMpSEd27rSgW+hUFgUg4?=
 =?us-ascii?Q?5mxL2c87mA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a06229e-f546-4c36-7a5e-08de4c9224e8
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 19:39:30.2365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PEZzHVnW9lK7mv4+zPsqqCJRyWjmKVCM6wnzwFMUGHlztPdbrnLsTcQZhuJbwOPhU5qAs24C1vG5ZbiIP1WXTw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7919
X-OriginatorOrg: intel.com

On Mon, Jan 05, 2026 at 08:17:11PM +0100, Borislav Petkov wrote:
> On Wed, Dec 17, 2025 at 09:21:00AM -0800, Tony Luck wrote:
> > +void resctrl_arch_pre_mount(void)
> > +{
> > +	static atomic_t only_once = ATOMIC_INIT(0);
> > +	int old = 0;
> > +
> > +	if (!atomic_try_cmpxchg(&only_once, &old, 1))
> > +		return;
> > +}
> 
> There's
> 
> #define DO_ONCE(func, ...)
> 
> Can't use that?

Learn something new every day. Yes, <linux/once.h> looks possible here.

Though I believe I'll need the DO_ONCE_SLEEPABLE() version since 
resctrl_arch_pre_mount() grabs a mutex and various called functions
allocate memory using kmalloc().

-Tony
