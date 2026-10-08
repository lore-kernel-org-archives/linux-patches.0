Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21363E49C0
	for <patches@lists.linux.dev>; Thu,  8 Oct 2026 07:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791444475; cv=fail; b=QGvq0EQOQG0QWRVKakI2ppoHToYf60mZ7Qj2nVcO7ErasiCjTf+ElEeGOrWivJ2OY1jYGxjZIU/reZYXdh5LbycnNtM85PdfkW0bJdR4k+lohLN6w5rbkJ/1SE/wwrIN+Cbd92vpiMY8d5KYrRqxZRljRpqgP03EWp12fOAI4pw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791444475; c=relaxed/simple;
	bh=yhLN5iMoYI3ViMeZLRsHUCzfw3w224T+ZEASF8N7pVw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jyg0gtkM2qHFOUeFvQep9IKchWaDYFQlNtSIoGRHAhIFnSREmuDhAj6BxBFaezBp7j9/KnyISNqGojf8vgnr6zjchE6IVcFw6/vYcyTnxoI0dBaEyjvfUogWDP4N7y90Zl2kUaFoGp6n2OF0DcdZdSOJyFmfbf17DGhG1+iaMOs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RZq8C/Ht; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RZq8C/Ht"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791444474; x=1822980474;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yhLN5iMoYI3ViMeZLRsHUCzfw3w224T+ZEASF8N7pVw=;
  b=RZq8C/HtI5ILITZwl/+FRhDXO5i5tQZEaqx9+LlYfQIkDYPfpX9in9kT
   M14+co7S6NNTMlSZUszuUPbCAaDvDwkO5ZZXaXu9blv00RM/pSlPUMvg7
   ZLSLl1WVRxDF6CXLPEXKk7V8vz/W0CSZA4mYLTHWWSp54o6wPpWp1nY6M
   BoDHnwQ86XdVbAXKmsncQJJ4zcNhMGfYsrSSCH/HLD4vJrE9RSZUemWxm
   pbvR/frygLb75S5YwoD3+6PpkmSSfb3pGQycgXu+Ly1XYDgxvjw8DH5Wp
   AQ4U1lQ/e8imoAVEfX/PN5B3h0Vq0qxQutGBGNvalpodojucKB+l8C+TM
   Q==;
X-CSE-ConnectionGUID: jl20LhoQQgWaFySCqqyUUg==
X-CSE-MsgGUID: cyYx+Y4aT1mca/ScPyzwNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11928"; a="239122"
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="239122"
Received: from fmviesa012.fm.intel.com ([10.60.135.152])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 00:27:54 -0700
X-CSE-ConnectionGUID: eklmfSmvQXSPnzHyf6rtLA==
X-CSE-MsgGUID: tdE2S3TbQSGnQsAUgiJ+iA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,145,1787036400"; 
   d="scan'208";a="1787417"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa012.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 00:27:53 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 00:27:52 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 8 Oct 2026 00:27:52 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.43) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 00:27:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rYgu0jw1LVIOnxwkKKykzi1AW1LKkzQBnPHilKIn8Mpm6EtN/MdRee5RuL0xejkxY3/hZOFoKul7GvI2F74MPObllX58a/QOoX2PUTs9ShVT2qPqNU0TsIMPo/zC7dxmjEMvLLRWQsIn0vdNnMs79U9ZwwitzfCGiz5cxkTjebmJXUxwtaYpqy00NMp/FxGmQA4UcQM6nwE4Jlwmq/Uz7wtBThxo3AxRLxiZ5m+7n9baCJOAerDFRS14V0fyOIC3malEGQXReJCu41Td/JMIRgB5N+F6DgIj6UgA6kxRpRil3+czQfZSW8co9yi5fkgGB/g/XnE/kHEZcYVnWetv5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OpRqPF+/td2M9+FvlWetcqulqbKB6bJqODTUfd8L/eA=;
 b=xnk/6jUjc/FDvDzk/kBxAUbVWbJCIthiUPL38yrmtfCbFlsZqmkS8C5fnx09X4DAUt9+ZWjv3e6jOFpPhjDAyBNcOq+SmWvRMnP6zyt7zuoBqCPNN11/j3dqSHeDpd8Y7er0H9h8u33zG9JM/u3gRvCfqkXZZ+7lGtjPqq52TqMihyo41ekIqPAFc7CjnsFdMhcg8jT5rnk+IN58i3xgCaQIDs3qzCB7yIYENKXPkJwjjAEET66Jtx83mp5l1fUMsHXWUnSOPJS0ih8QC/jzyMdumct+qX6cJsDtfySoCTklrQkh6iGXjeRSnjZuNQ3j26pcxlVXvN6Q/7l80OOyfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 IA4PR11MB9277.namprd11.prod.outlook.com (2603:10b6:208:55d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.16; Thu, 8 Oct
 2026 07:27:45 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%3]) with mapi id 15.21.0496.010; Thu, 8 Oct 2026
 07:27:44 +0000
Date: Thu, 8 Oct 2026 15:14:40 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <tony.luck@intel.com>, <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <babu.moger@amd.com>, <bp@alien8.de>,
	<tglx@linutronix.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <fustini@kernel.org>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH v2 2/5] x86,fs/resctrl: Remove unnecessary non-linear MBA
 configuration check
Message-ID: <asdC4FU8CbrNm_4f@chenyu-dev>
References: <cover.1791406459.git.reinette.chatre@intel.com>
 <54ee80a047388ed372f1e848eccbac930a9745be.1791406459.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <54ee80a047388ed372f1e848eccbac930a9745be.1791406459.git.reinette.chatre@intel.com>
X-ClientProxiedBy: TP0P295CA0028.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:5::8)
 To DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|IA4PR11MB9277:EE_
X-MS-Office365-Filtering-Correlation-Id: f7c7cee3-9eef-4646-0129-08df250da518
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|6133799003|18002099003|22082099003|4143699003|5023799004|10067099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: 6OhAf3tqwQDCYyd3RYkg/S3WDGyQ9oowI8jjScKURVSbeS+1tVsnvD7A0/fWjs5l150UIyi9zFbYinUU/7CvOi1MkeIqX92VGrpBFEmq/FK5u1lp6XKSgTMPqek7/Zx01j2R3rAImeYA7AbQrRDnK5WPvhwMWCQiVWi6CTGbLg1XJesuRPP9GxMcSAgelow+ZWwa4IAH3aMNOLqi5xbKAgCAy7hz36udi/ZunWoM4OgOMmsCFNGgVBb7c3Li3Kb2m7ryvTd5kh+K70pw25KzzikcV0aFR33SvUYSBWcNJQInbZxjk/rXwjnxMDRDTMWVfR6M/dU2YCOLQqjv6yfiaP/ZtNZaQeZ19fdoFdKEYZQvyrWtNLJRG1y9yWGjZ+aR/otq1YDyZswgxV6l0isZwOsFcpyq1nG73Ko6Z/jVVaAW8PeSfBBhQBLQifyOtq+7SGjYXurWSeBri/xMjPWUIVyX/HQAE6a/DD9BgO7DnwA8kgdwJvHy6yy5RsSR+l8j4QoxjoKpoLUMl267ZcggSlz8IXt76jMUJPdSnhsPdA+ejEp6f1xZuvf51Gyg62fNdX2DrHYPuSdzLk0NN0jWdkpe6qV2mb08/XUzdtM7mph71WRlXLvJN9nWOTKp56hkvlfxkwn0fdGRfktp4xSt4uAmPzngts+E9Bamv0TshFU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(6133799003)(18002099003)(22082099003)(4143699003)(5023799004)(10067099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k8YBNR+3pXvbg2YNRoXGYLsZ8ndK27wUKURU2FBrI9bnR8WU9vOE8LJuIGmq?=
 =?us-ascii?Q?07dEW69rTOh4dUXRBfWEuHAdicy28NmXDEFzqz6l0h+XCXFMjNY8wzWW0Jq0?=
 =?us-ascii?Q?K/IKzhWKbmeLlwPJrMelMZJh3KwC9nCmrDZxqMFZFMVdVsAi5P+n9RpHCCYW?=
 =?us-ascii?Q?qIT4W9p8lMD85Z0Eej+4smn9s1hjewb7Ou6hapOpMpY9SyCBgwZME+SRyH1r?=
 =?us-ascii?Q?RPbFOd/YsDxlI92wn0ElSanfM5XTtsf+YLUvhTZDpvi4ATGhc/bShP6NVkL0?=
 =?us-ascii?Q?FvHuh8ViuTAHNfmTUUAJgRAb5ICdvQVxezjYCLEwCGrcSV2TMltoa8FWDA6L?=
 =?us-ascii?Q?O/3z2XMZm15kmDZ2YaW3lACpnRemQuQeQS+oAFEwC7pERF4K8WFtTLjqRDgK?=
 =?us-ascii?Q?PJgrprmz6jZE8QzDQQKMkW+E6+0lRyqGTDUaAvsbvN0jKDa4p3dj4NHK+Rne?=
 =?us-ascii?Q?noxHjPxHBa6ZOyS0C8pdnRjVOHzN2/8e3jjZKRfc8remGwEiKdOBIf75/kYr?=
 =?us-ascii?Q?BKLq8QNKkg52QnqgX2b8Zy2CJkEgvsvqLUtRxODiheCNM91pVStu8Fz8INOo?=
 =?us-ascii?Q?MzT5O5fBAl851svNFT+rvYDRnP606nMtIixJcfqTspAGNyMcmzNlBlKZF+5e?=
 =?us-ascii?Q?57vSaLQLPX7urkeOT/h2amhMwaM6yQ2nHyKpMjhRVUhocPI2MRj0JZ+PO3dC?=
 =?us-ascii?Q?BevbNVFUiCrkBd7MU/nXx4kgt1ZXeudtVYsSDpaaV8aTQoGAUTNE/rxT1Jos?=
 =?us-ascii?Q?j825flak0Jz9kHqsYf9ZiIH3jSk5/74ziohev4MkVOxdaKCFVuk5DFjGTbMO?=
 =?us-ascii?Q?AfR2EZDZXYEqAMhTvUOPV5QH0Id9ITaOjfgQK33U7DBeQniMXjC2uzs5MRtu?=
 =?us-ascii?Q?lp6jNrsOzoefr8DpbJzshlV872L+lQMtuHKpDE5KKx4BgSWaXX4LmEJH4DiM?=
 =?us-ascii?Q?lNo6BF/Sqe1J5SuZJZsMqeT9TjFYf8Xr2ulvYkY9F3t66d7Ebp4QVu+CpyO7?=
 =?us-ascii?Q?BmSQdsV4E16uRkprnLSQkj1Yl/UFcQZZZxkkwyNeyl4kdE05rSYixdL3qxWt?=
 =?us-ascii?Q?rYavirDOJWiDdfDOqyS5PnCXtjlw9E6hRxzsmxwu4IlR8y5SwS4tewFF+t8j?=
 =?us-ascii?Q?aN/RvzbRzRGqA65a4Jk02kgu0ByQIiSQGvqfJMo3Wk2jgCGr8WEVwo7W2OBp?=
 =?us-ascii?Q?fY4wRLtASxVSt9R672a56Lf0wbEVBl4X/vkVjRlXxZiihfmknErZZuQpWd5C?=
 =?us-ascii?Q?Wxuckxs8QhGrhVebvZQBi8tid1fLnpkfr0++rAknnbN0xO1PHna2MVBBT5C4?=
 =?us-ascii?Q?zA2iJHq8Wje1PUaZ+yA+dCN/p5gbnLrUjvjlFbxYxVVe/EZRFjPhs0xiOtwt?=
 =?us-ascii?Q?K9V2vaDggh/XvSUVLsDDkAbZ1JdkpSaigO/DivIEgqbmuTl2t73Ied+jNEba?=
 =?us-ascii?Q?QFErjKfD/E9TcBNoSPiW5moqUVFKyLmgXQQjEQsT3Ka2XER58KwTEtSUmwro?=
 =?us-ascii?Q?Zo1ppHSyQTe+EZml/QCRQ9sd/taIG1JahVJRvRYvlqUlUdPV0crx6dDxxQ8T?=
 =?us-ascii?Q?c41FbHayCgd3bSOl7FnbX8DajBDXp2bJoHqd6oNgtYP2EfajQ7c9fQ0o4fI5?=
 =?us-ascii?Q?JzhXB/ovvcew3Q3v5O/x0RF9IR1zkDohxuceGXgHxc2oipYfUloCZUpo8tdm?=
 =?us-ascii?Q?ahylaCe+DX6xXlWcLuyPMD8MMlMQRfTypzTBd5uJMokohPx+TbXHksoGAP9R?=
 =?us-ascii?Q?a35/1og8IA=3D=3D?=
X-Exchange-RoutingPolicyChecked: TDmxaKJYC3Ltmq2mhvX+qS31DO7577oRYhiqSto0Nnco3cJehlC6/qG7NrWYXtxKNSJOSt0BORAygSk3vMtVUc20L4oO+emnaExmz51I/i6rrS9saDaBTK6avoufIYa2KcbuqbJxgl4DjfVZg5rPnYgyxp+u7PWvg9MylK9hYAOAtXhEsnUymarUzSMSmEAxKnqI4zPVkqvh9zSSJ5E4qeHN8l+rzQrBr/l9gZpJQHKjdAqGSG1BVOFbJDQS9Lt7HKzFfrJ92y9FnQBK+A0RlFkclPGwl9Q2662Dl39pl0WeJRZIbgOO3UaujLG+3wG1V6qO814KYEdegPd4lmMlwA==
X-MS-Exchange-CrossTenant-Network-Message-Id: f7c7cee3-9eef-4646-0129-08df250da518
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 07:27:44.7689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QtBLaFeGAOK0rBYoa82M7mcP4EUyLkej5WQNYcnJdF9SDd6LHkbNa7pC4rXfvyJ+1ZEPOrfPkWJVwxW15n48Lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9277
X-OriginatorOrg: intel.com

On Wed, Oct 07, 2026 at 02:06:44PM -0700, Reinette Chatre wrote:
> Writing a bandwidth value from user space is rejected if the MBA resource
> has non-linear delay values while the architecture indicates (via
> resctrl_membw::arch_needs_linear) it can only configure resources with
> linear delay values. Intel indicates this for MBA while AMD and MPAM do not.
> 
> This check can never fail. No Intel SKU supports non-linear delay values,
> and the placeholder for such support, rdt_get_mb_table(), is only called
> during enumeration and always fails. A non-linear Intel MBA resource is
> thus never marked as capable of allocation, and resctrl never exposes it
> to user space or attempts to configure it. Every Intel MBA resource capable
> of allocation has linear delay values, and AMD and MPAM never indicate a
> need for them.
> 
> Fail enumeration of a non-linear Intel MBA resource directly to make clear
> that it is not supported, and remove the check together with the
> resctrl_membw::arch_needs_linear property it relies on.
> 
> Keep the informational message printed when such a system is encountered.
> While moving it, reword it to no longer refer to the removed mapping table,
> add the missing newline, and label the printed family value "family" instead
> of "cpu".
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>

Reviewed-by: Chen Yu <yu.c.chen@intel.com>

thanks,
Chenyu
