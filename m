Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1792477107;
	b=gfoadmQ7k8mGen1ywvqcLYU53rfirVS0paoF5wD2kU1OC/zDVnONXUjmMRDnkZanXf0M
	 ZDlWJiWgFaK97XmIkRsXyvLahcKng/xnsuK8Q6FG0ebAuxNE9BJC2bu2JrrGV85A/wenP
	 f5txZKuUVX3ftTYUkrigE9ohC8Tuzx6dhXYWgQmCxiqytqzRpb+puEQY/2R3h5pwnO9R1
	 tzuUvQ1mx/jcMXa3b0NHWUdNNgLwUenUgAoLJZehLP/1B9CM2TD5CADIVRS2pAwf4nyY+
	 +ZvGTienS46u7sVWBFIyYIIdpgDdMTKfGog9f8O7+g5H6HdI/nwPJwUmWl0dD5j+yNA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792477107;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:In-Reply-To:
	 X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=drs9uKubSJAn27bAsTSgwk+91qFF57tXQvus/vioa8I=;
	b=z22chs5NjVErDbiZ8xCvOCzHyr8Nrf7rBSvFNUPEz2i4s/wLef3hfDpOaTWrGLKm7NQv
	 WnL3tZQ46DsaAeNJsaFZss0TxeEoDeviCNeQycBr20z3E9CyNn4Gxr6pyzA7QVGgKXJCN
	 nXBGlk1sGT7xpUYtY4ttYpeztiUhnVTv5ui3b0TNcG8xD+j7FjunPcMezdhZ/cOXu7Z1J
	 M06TiNhP+vnIg/XOCwt5gkq4a+4/CAY5uI0tnHfij7t+i0bOUHWkqO6ORiczfqFUWhoJ8
	 caVTSOZDu4j2dZgBY1O1LX9zUC4F8jZCaRqUkeQTGQTUdjmG9h39LkXPF85bf7nzm/A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=HA1MyxSO;
	arc=fail smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCF7606A33E
	for <patches@lists.linux.dev>; Tue, 20 Oct 2026 06:18:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0DCF7606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=HA1MyxSO
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792477105; x=1824013105;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=AzYjmxc8FUCuNm1jUQvk8YgQ3bJdLodSs0qs0H9Xaqw=;
  b=HA1MyxSOcG0FdtSJCFIC7d63PP11TZTuL6CA+m+r3HVZ2ouyWEMJyCUl
   je8L0+TRSpad+dPhUB2FX8R6SnYxaCAsBfW74CaEtOVIvPwJRtIaI4WWu
   FS1ALR3pqSRxPsz+ijt6jNZTHYE1iFtKxsbozRe5jAmjh/CwXmRoacjjU
   0GGyhkVomv0n6ptuPs6Ps4dz1PuVaOQ19aYqA3D4YjsybsOxi2IsvHmMP
   AW+9mFjDUSeMAAk4dPklxZT3RS0Wot+DCxUwJYhXIExJkhyZygwhQ8gba
   BxChww7FStFBu3g58Imh//sxCD1cG/FroJ/WCu3NCeMyMye9g5A8VfXUr
   Q==;
X-CSE-ConnectionGUID: grSLeDSvSySpqGKEO2gaXg==
X-CSE-MsgGUID: vSMJClBaRr+NuV17GqAhng==
X-IronPort-AV: E=McAfee;i="6800,10657,11940"; a="1188644"
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="1188644"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 23:18:25 -0700
X-CSE-ConnectionGUID: ZJQL7lBjScKw/xAX3GcnTA==
X-CSE-MsgGUID: NIPsUbXXT++17wfq4u4snA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,168,1787036400"; 
   d="scan'208";a="3144733"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Oct 2026 23:18:24 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 23:18:23 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Mon, 19 Oct 2026 23:18:23 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.38) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 23:18:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Uc8HpNqGHF+u1KbwN/crdjBWI2uHT4hG1FBho11GrOn2XqqJ0w2uRh5tS0+mtHzRbsHJVfEUxzlm/+xdGOS5Lcl0vWWr1066D0DvjLzHJaGUlxsLG3RV2edpSsr8aexduPzZqJE1b8OR4RxHXqxoytMcBkFMmd/oxEwrpXFv+RMNmXnHrMEjUjql6LenYIKGUH7dn+3ruRmVbJbU3OjPWfe9/dfOrqtSSYkIoMlB6SUY6VSBR4v9v5xglluq9urRgfsoDJQq5gOhg0HFF46jw4KsI7DXWBfuuR4sSyPNYARDnIDhE6fINc5teBG8f8IfsD6K72EklFao4WH9iaktqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=drs9uKubSJAn27bAsTSgwk+91qFF57tXQvus/vioa8I=;
 b=v3RbUirxC/+SuQynq2uda/sxgZwzX4tjbwf9u7zbEqNhv8Hk6ZagQNovWWWrCPoJTg+EqPZvTbI3OO9LuW5cE3jGU5v4/Pit4i0lEro76PoK3YKZuenY7h2OrPGRR+O8/7SBamg4zfXr60K+RD9vqEfU/MYV/OGvDDVmGUKILJX3fxh3Y3Zqx6KL5gWZXtZjeyjD1jmVSM11JnXieTFavETy9QUN0UGvXeZRex9XMe9eNnbWwMcwlhu9COJwdA8+qmiEM9p2P1Pou5AuQOEKSBGTiQ5mVc8aG+Rp+mwS/3J7N6bpHOZ/XKPx/S1vcQnIodpLt6N5SLWnIatx1bA+gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 LV8PR11MB8722.namprd11.prod.outlook.com (2603:10b6:408:207::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.17; Tue, 20 Oct
 2026 06:18:19 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%3]) with mapi id 15.21.0496.021; Tue, 20 Oct 2026
 06:18:19 +0000
Date: Tue, 20 Oct 2026 14:05:20 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Chen Yu <chen.yu@linux.dev>, <tony.luck@intel.com>, <ben.horgan@arm.com>,
	<james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <fustini@kernel.org>,
	<fenghuay@nvidia.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v2 3/5] x86,fs/resctrl: Move MSR_IA32_L{2,3}_QOS_CFG
 scope property to x86 resource
Message-ID: <atcEoIz4kkQFyEgx@chenyu-dev>
References: <cover.1791406459.git.reinette.chatre@intel.com>
 <c873c62e78f335df6f7b99cb0cf0ccbcdd62b09e.1791406459.git.reinette.chatre@intel.com>
 <atUEpF4pd4YBncbL@three-body>
 <f054255d-f34a-4f8d-87e1-e7d296bef93f@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f054255d-f34a-4f8d-87e1-e7d296bef93f@intel.com>
X-ClientProxiedBy: SI3PR02CA0006.apcprd02.prod.outlook.com
 (2603:1096:4:295::13) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|LV8PR11MB8722:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cc7a4a3-eb5b-4e11-b5cd-08df2e71ef82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|23010399003|56012099006|4143699003|11063799006|261009223027099003|18002099003|10067099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info: BqQ5v3Id/0XMlV0S9Wct1hxr1H5ZOKhG9tFnJ2eu6eMY2n0wA0kbKQejRQK9c8w+67fioufJStqHJ5yYghUF4/PYofc5Vz+0YO44oBFGE0ZmkpbkmxX0ytSFkPxH2jA5A8raGjzUqW7kdwADW5svNzxWWP32Nb/z9ib9NZnPeX8HqP88c0Uo/XA+cLJcr2Br21cb/jZnfVxx2jOFuej+zp9nz6Jp1dXwsnU15RBOjM+Nc2N+qwGSqYn4zIOrHTMmtCwBFHzzxrkE1c86wEQNVMnTE8cgnvIWlgzL1+M0CY1Kn0unrG99CQyCYVfvrF3P1YIBkWVR7pwykjHIL1SVWN/YfGpm8934fmOpMdeySfNgiheRlAw/PZWbGGGlf2tO9wM0SDnf+6trE+6yj5ewolgIODdvOboOYIIbQgnqWgPBLpLkI75qiBcG/+lmFuQRv2f0tgUW0YFnlvNtIn2fjGLrbjfHlL7kNV9YbnbXQPr4SeoM3MNFtcKseI7KqGYOt1XLmMGPEZvfv2MLFNWSW24bHlSx3zT+Ar2zd9EZ7GuWafNcM6FyB6PuIeD+oClemcNmCOMVi3yZpU2GXG0k4FsHArsyRZf4y4SAPBjAYYPAgpd6w3bsGVBxPU6hRoEj171bcvnYmBBepmOm8dk2Ycu+r/vLYFoI8TzYxPry5fU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(23010399003)(56012099006)(4143699003)(11063799006)(261009223027099003)(18002099003)(10067099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jOjJfmCKhlzijnO6yXKxfME+X/eOEVCYoZmT/pef9KVYQY1wHdBdCw/bPIaZ?=
 =?us-ascii?Q?NAWDOfjoXuvowRwBsu3TSvPccUGwdtNCH8CJf+Ga81LA7i3N36OKWfYrH/fe?=
 =?us-ascii?Q?VOiSFIQkPobGA0y23PMxp7YdOLQkyWIl/4ICKbMLlyynFxOI6+2YzynlQIj6?=
 =?us-ascii?Q?zc/K5HS9cGWiHrFPYTMTzJQxbr4px4d4zpThyhaRJf6pInXh23CoVffLXFXG?=
 =?us-ascii?Q?90T6VJrh7le0M0Lpiwu4Y2alnQ2jMI5jvNXM1BfQPbN698/pY3u4NyeX3DkK?=
 =?us-ascii?Q?aZifjXtThnJnr3T0+99KI4gDJJ7Ww80EicDs3mDPVUedYq9oIlKGSYsHJSKk?=
 =?us-ascii?Q?d4Xj22LXfvSpBGTcwg4kWXelDfixlof86f394fG70eqP51oRW96T5kDGM089?=
 =?us-ascii?Q?1RgjVLQTVYP0+ROyfCpiJSNPPR5DeV2RbSwv4Zq1mpnILKD8NniqYbAbLd4V?=
 =?us-ascii?Q?XlVHTwW4YeAGgqWHt0t0NsJUZ5wF//yI5RFlYAlq4KTH1PiH5NYcEx8AhoRs?=
 =?us-ascii?Q?3whrzv7QZEbqeh4BxYFl8NKBDJ/oq5V1Ku+iQF1XphFXzeJkq2yEcav8lFEI?=
 =?us-ascii?Q?M5QsNVCiPdKdlxMqNNUskViS04ezZ97sFyls8WpZJOX5sBhGg0tvIpOdWHub?=
 =?us-ascii?Q?P9r2lyGnGyr60RhVbM4neUkRNCktfUSt3byr7OOdcbDNvGe4v0/KdNng7422?=
 =?us-ascii?Q?EwdAZpRcvlHDyv915pAQvuH4zgwdTGhsHHv2j9K1plxy1BAXBbnuIiIC4kBM?=
 =?us-ascii?Q?dINLlCShU4smmjSAdJvuHlqYbZuadDGEcxPI84N3jy/HNMoN0qJYEs9/pLfF?=
 =?us-ascii?Q?XjDY6RNxnPePTBpUUhvtn2RwHpKsAvju2BewLgOFHEpKUlVucAC2hoYjiulT?=
 =?us-ascii?Q?g10lugHE7zkNYkP/Cy2IslHafbT0BpmmTbI0CiLn63CtHM36EuraIWeq/8n6?=
 =?us-ascii?Q?Rd9e287WsBqzBIl8Kfm5+1E/UUNs26SIHp6OuvbZLllmfkwExkz3QcSzCd2l?=
 =?us-ascii?Q?n6OGnToFHIbfR1PGVNNlaMgiWJEKT94+QCyxKLveVEAMMDg1Ll92KYL/i1Ej?=
 =?us-ascii?Q?9c1WA8F9/uXmp2XrbcOQ1MUkyHpA9jPh50z0aHFK7rFBDud9kL7ZJMbphRV2?=
 =?us-ascii?Q?ZK3q2pP0L1eXFPbmqrk9H3ReWjQ72MgSaIr+HQeiVi+Uwy9hy/9Lkyyr4A0k?=
 =?us-ascii?Q?uP/Ed1n39Dk6Sz+GdAe4eM3RjOnX0wiA3sH49NK8OHXoVwg25Y/6cB/LTY0b?=
 =?us-ascii?Q?tFtWSmHdhvWT8TgoavdnHTPiUaSXYlcLzL3BQqEeo4HZBBOHsbiF6eOQpqdc?=
 =?us-ascii?Q?gMjBL+DKmeh3RaxHnEqjtozV+RjI774s/QDuyS3h1oMHCUQLC3upjFPN7k/n?=
 =?us-ascii?Q?XZfjq+Ed+CJKasgOL8Cqcm/6PfA1nDAolhbii+YErAO7KOwpMeDGRPcV7qPv?=
 =?us-ascii?Q?BZ+dKaLnixywRII99I/WiAR+mGSLWO8L2LXm3a7mRZPC+D5xRso5nSelMqL3?=
 =?us-ascii?Q?vVNUbEH9kEKen/KIqv+rb0z8GPYYAEbVkaKQlBQAfLyp6QC5WD5GX57tdEBR?=
 =?us-ascii?Q?SXGCGl8p6a11PVUCEqqn8OvGMFU+2pNsKxqdbn9m3aDk7OIJzQrX+vEnRBh6?=
 =?us-ascii?Q?p7qP4GOMScLsJRGANYeIYA7Hso7DB88XwgIMKeZu7LfOEQ1Wbb7f6cUQCA++?=
 =?us-ascii?Q?TgscGr3Wq6lR9hnK4uspJK5KTUB+sK25HqCA6ktYaBxRnYwuv0K2veXm/4Y1?=
 =?us-ascii?Q?TQNK3xluMQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: 37/R/yma56oJsa5YNtADgKWvxIauHr+0Mae4erVYTWvMjihpPCzRxyZdCiWIRO7T9CuO/uaEmC66gnXx7dxCorTqMmmJBbR+JgtxBX28V4P5P+oVa44SWmPyBb9oHCjbsonJuWSk/93TyXAe2yzV4L5uGKDeTCiF2PyhsSpRgse9iQAfZUJIF+90fkeTizQ/Fst3aE+TI57+HXe2BBc3Z/yWcQvPysebbV83rUy9TCXCukQkcZgSPy/L+Ir2J9izoW/yWi/v8w+gDRrnIpFcI+XTogiu5z9We9Z15Ruc9q/d4l3UAmJ8tmR3OkVa0cPzqrayYxEDuG5WwMxqgu7s2A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cc7a4a3-eb5b-4e11-b5cd-08df2e71ef82
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2026 06:18:19.5645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iaPuWyycIPZgK7xGgISFhNPB2FXsqzdaD1hz9MD+HtjpM9B0rVgzTL9pJXGnVjtcTSTND0HA996Ty216uLTZ4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8722
X-OriginatorOrg: intel.com

Hi Reinette,

On Mon, Oct 19, 2026 at 04:06:35PM -0700, Reinette Chatre wrote:
> Hi Chenyu,
> 
> On 10/18/26 10:40 AM, Chen Yu wrote:
> > On Wed, Oct 07, 2026 at 02:06:45PM -0700, Reinette Chatre wrote:
> >>
> >> MSR_IA32_L{2,3}_QOS_CFG enable code and data prioritization on x86. On
> >> Intel the registers have the scope of the associated cache while on AMD
> >> they have CPU scope. The scope is recorded as a property of the cache
> >> resource's control, of which each cache resource currently supports only
> >> one.
> >>
> >> The scope of MSR_IA32_L{2,3}_QOS_CFG is only relevant to x86. Even so, the
> >> property is found among the resctrl filesystem's cache properties while only
> >> x86 code sets and reads it. Keeping the property with the cache control
> >> properties would also duplicate it across all controls of a resource when
> >> resources support multiple controls.
> >>
> >> Make the scope of MSR_IA32_L{2,3}_QOS_CFG a property of the x86 hardware
> >> resource and name it for the registers it describes now that it no longer
> >> needs to be generic.
> >>
> >> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> > 
> > [ ... ]
> > 
> >> @@ -140,6 +143,7 @@ struct rdt_hw_resource {
> >>  	unsigned int		mon_scale;
> >>  	unsigned int		mbm_width;
> >>  	bool			cdp_enabled;
> >> +	bool			qos_cfg_has_cpu_scope;
> >>  	bool			mbm_cntr_assign_enabled;
> >>  	bool			sdciae_enabled;
> >>  };
> > 
> > It seems that some flags are in resource scope, while others are in the controller's scope,
> > cache's flags are in the resource scope, MB's flags are in controller's scope, for example "linear".
> 
> The goal of this change is to move this information into the only (x86) architectural driver where it
> is relevant.
> 
> These "flags" are different in a couple of ways:
> a) qos_cfg_has_cpu_scope is specific to x86 architecture (thus located in struct rdt_hw_resource of
>    x86 driver, not struct rdt_resource belonging to resctrl fs) - this information is not exposed
>    to user space nor is it of use to resctrl filesystem. This is just information internal to
>    architecture whether the x86 MSR has CPU or domain scope to accommodate this difference between
>    AMD and Intel.
> b) the MB controller flags like scalar and linear are associated with the controller,
>    exposed to user space, and managed by resctrl filesystem.
>

I see, the hardware-specific attributes/indicators could be in the hardware resource
scope(and usually they are global settings), while the MB controller's flag is not hardware
specific, and they are not global settings.

> To me this qos_cfg_has_cpu_scope flag is closer to the architectural support you are working on
> that contains within x86 architecture driver the decision whether it should use ACPI or MSR than
> it is to control flags.
>

It seems to be a little different in the control_mode case, currently control_mode is in the
struct rdt_resource, but its callback resctrl_arch_control_mode_set() is x86 architecture driver
specific.

> > For now, there is only one controller under the L2/L3 cache resource, so it might
> > not be duplicated if we keep qos_cfg_has_cpu_scope in the controller scope to keep consistence? Or do
> 
> I do not see how qos_cfg_has_cpu_scope is related to properties of controls exposed via resctrl fs.
> resctrl filesystem may request CDP to be enabled/disabled on a control but how that enabling is done, whether
> the architecture uses MMIO, CPU scope MSR, or domain scope MSR, that knowledge is private to the
> architecture.
>

I agree.

> > you mean if in the future there are multiple controllers under this cache resource, all controllers'
> > flags (e.g., qos_cfg_has_cpu_scope) would still share the same value, so it is OK to put the flag in
> > the cache resource? If yes, the code looks good to me,
> 
> This patch is not about moving a cache control flag into the resource but instead about making
> an architecture specific flag (unrelated to a control) invisible to resctrl filesystem. 
>  
> > Review-by: Chen Yu <yu.c.chen@intel.com>
> Thanks, but I do not think we have the same view of this change. Please let me know if you
> still feel this patch is ok after this discussion.
>

Yes, thanks for the detailed explanation. This patch is OK with me.

thanks,
Chenyu

> Reinette
> 
