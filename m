Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E2A1DE3B7
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 23:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772494673; cv=fail; b=uju8sI25Gf2aIWLBiWBaDyXWWpJe2J2U1ytjHGEV9VM2b/PDZymAEr2EN9zKH52em3dRGYcaKOwol3VkwSiQe4OFGK0M6b845ag8g9a8jWJ70C8JyDfvuG18vc+SQKOIiMNyFzn+3AdHmDwSBgEHczBi1GAClYEnFVZdvmiqrgI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772494673; c=relaxed/simple;
	bh=8t3VrlBEJ5TD1wmTmqaLxXd+S11A0VDkImjXY2q8vb4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NgVUssnRTDSPXjpjSX+MAkqsV9kXHYVGETCiKhmxfUnGCRyJlsqYoBMHkmy94cMHSunNJMVde/IVFHt+kdkcwVyFQPsllfC10B7xnLwYiTgIrMBBcKNIskRRi69XwOAcgFduL08UV4VLO5tzbBod7Z0tSywu3Lnn5QXi/BTGr80=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PbxLujkQ; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PbxLujkQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772494672; x=1804030672;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=8t3VrlBEJ5TD1wmTmqaLxXd+S11A0VDkImjXY2q8vb4=;
  b=PbxLujkQhS7wPZkCS0yoWMTTxsu9PJpFFXebrUC1VLS/ecX/hMXJjrVr
   QEsltoMz+M05cpbMj3lfZrVh3BcaODkuNet/4b57LgKFBEoqU/CYFm+2M
   TltYrSp9PLmMrufvr6Z4S2U8cy0fhPPI/qQuDUkc97PU2SKHaO7CYyhOJ
   D99WC9wYjoqcH7NcObJ9gNLjmjlCfNcuT/6tkZ0qTNg7qA4aUBaLDp23c
   42IVyOxCzGwrffUcEa6MbMgYFBFcUA+Bp/bH0GE2UATQ5CzjAdQ5WfqQV
   ySc5kpS31wuPkL2VbNF9XjPq295UJkp+UufwBiF0WXY6QWp06oyxutl3l
   A==;
X-CSE-ConnectionGUID: pqQhxuomTPe8rtnCIA8sTg==
X-CSE-MsgGUID: AjrVlYEzRJKnHoPmoEaecg==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="73385892"
X-IronPort-AV: E=Sophos;i="6.21,321,1763452800"; 
   d="scan'208";a="73385892"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 15:37:51 -0800
X-CSE-ConnectionGUID: Qci7IkFiTYCGBdEQf37nKg==
X-CSE-MsgGUID: tlLlhdxRQMG68BnOdCcCEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,321,1763452800"; 
   d="scan'208";a="217043388"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 15:37:51 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 2 Mar 2026 15:37:50 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 2 Mar 2026 15:37:50 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.32) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 2 Mar 2026 15:37:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xoDH3BvnH8U1tXvyY4QH2f1NAUxidQpDLY3rUjWSumhMswuJbAEI2rRkbGl1bIBXVdfH5tOI/m48fTUurJ8Jf90yT/TILrKOSwFtjSfF4eix9ECn0o4dkoPKTtF46H4+uo2evmD15U/6bDpb4ymQldxNsNOs5eEa6oSat0ILzsIS5lbCTSkPMlrY5XFBgRUkpKyZiGM/tWGezKkdud9EIweY/Y9GMYLRppiEKuu1PTmWgxp1l7lB9JEbx1RL3P/kUxIeIz3ce88TSo3xElHwpHO5CJO+2yE0D1zKDmehaC/cs9c5i4ZajhTvZCXw4n6Nh2iJYupXOAy4I9sLxCWAWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+jsgo+79uJ4NayR57BijCfNCUSkP8Ig1X4YLgRNYmYY=;
 b=i7AZVTm4OpeI0JK1Tk57kVIFmAnscl9k6qRiZiXfjcifu2if7ct4bJb+ZpKm1/dp1N5HEUPeD71a1yOVdUp3Lxdl0OhNxcpbYKEpbug3yOr5XY3T9bnfIrQOiogTlfR+XgXqhKsGgwaSgGadUrCOn1X9DX6WRyte+LUvQdhI94XPfSmRhFAdi/KJBNme0Ft7mNMyNb65NFAV3vJaybLVx4uwGYEA0jIZB2es0Cem2Z+5EzfBjb/N/3AJoctMimewkTEhErGc8et/B6OvgN/bPdh0zq6UADtW9T4UGlcoFuwW4v+J++nM8zNh/O4QIPhPWvP6TbAE4ZPZHTn8nx7mSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA3PR11MB9061.namprd11.prod.outlook.com (2603:10b6:208:57c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 2 Mar
 2026 23:37:47 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9654.020; Mon, 2 Mar 2026
 23:37:46 +0000
Date: Mon, 2 Mar 2026 15:37:45 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 00/11] x86,fs/resctrl: Improve resctrl quality and
 consistency
Message-ID: <aaYfSTppsqwgMz1d@agluck-desk3>
References: <cover.1772476561.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1772476561.git.reinette.chatre@intel.com>
X-ClientProxiedBy: SJ0PR13CA0102.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::17) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA3PR11MB9061:EE_
X-MS-Office365-Filtering-Correlation-Id: 68a6f946-8ea4-46bd-1df0-08de78b4b56a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: 7ObgiFcfieHJhuPzSwWCscHjR5h+GoS8udrZ5XYQC8hyr2ncfFZyM8kXPcJP/DL9rgn8/yo0BwgRi2XOnAnGqlCrUGruhiBMXnG7sk6knUAxCogzYF4gNrPOlCigsi+YBdUpUkJ/GN1JVau2IAn0VQknb+fpfr9JD8C6/K/wt8653K4b4ffNkA0tmphAlrIPZTSnxIYHwtRZWOMr+NNJ+KGvdEdqcn7JTU7KLtSWl+piLXdJZulkkIiak/K/FB/F1AQyjSMUKj9r340D7OFlT9Yu46l/aeQZ7iq2QbJCObm4c6EnK9jrE34PMiuV0N8ouursxcE2fnqouLXuG/kvEjb3Vh5aEo/Xosthyel9Ppdt5ZhAJO4mkb36BYSyGoTjnt31vZxWRN/mxFzAxuJescgBpic1x5Y2rJsYu7hetoqaJ59OJB8ZAJ+BNAgMlcC5h80lDjrbmuFwwNXKpZlxjc1tYGVi+UmtKY7E1xrzwkaHcevvpi3vAqh+RomTvn4061/ss1mHse4sP1S5AP0LQoR/GFII1X0z6fYCTrLkx5O+EfZU7voYkTV7Omzs7dCoa2+5fE8An6EEgdeJcKuntbS5NTbZXpSNMgxuJOpCra+pzK8/QtO4k9qKMz9VRmbGFYJ0btBfczCkUYLtq9VrIYKmuJ/2lgkHRy1H+4a/DoDBPDjDqYOHisM80GnEth9ByOmQ9CSygGfrR9J7M3QfGzzyjJjS/ELCd1OeqtzPLyU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/nWn5ZUc+WtjUYa2lfdat2nH/PtLnd0zhqZvbL4cV/zM5Wxh+Csvl82BVTnE?=
 =?us-ascii?Q?zoBcqoD4ThONrD49roMexV5d5Y66pn71akfv/xklMF68r6lWBPTpo65XyNPc?=
 =?us-ascii?Q?xwikVLyNPsEScGdZJYMLByHURXJsbZ59Qkt/guk+DB6Cc9cD/7q4veej6hLs?=
 =?us-ascii?Q?pswOYU7ba5Os2zCRUrRbSucp/b8Y6GKsNl5LAMlhpbn9AR01YxUiH1+3FrSC?=
 =?us-ascii?Q?SdWYuSJh8rdDqpb1ivNAj0ixh4No99o/h1T4anUUmzKwwJNtndtlAUFCk5Mq?=
 =?us-ascii?Q?C7J5l3MFuV/VtxPg+3VpcyhMyXNzksk2Y6E2fMBMJVKcqc28ipbSuvq7T49Z?=
 =?us-ascii?Q?wjXzWbNyGqt1BB5hznaG6cPVRxyyN/3RaIruima5vtP9P24Aehw/Y8SmjMvh?=
 =?us-ascii?Q?KMqYrnUCLm0vgfiGSdlmvScjJC+oLbOGb9LIkC8itplIMV6nczEhwCjDUhmc?=
 =?us-ascii?Q?OZ82dCSpgtVR2IFE+ghIqC+9MbKC5O93QfKn+3oqitHEcBP0HpgA7NICjyez?=
 =?us-ascii?Q?2nwp8lK6i4zpDh85R+lV8BsuMwtvbq4aiK/85ZpvrEzkGyNe6qIPkKyq7Ob1?=
 =?us-ascii?Q?9R113Ui/JLwOuN60bKzumCC53PLOZaDAVRcZ1F+FF4pf60emADo26U5rOtI/?=
 =?us-ascii?Q?pMEBMA9WmF7bVeHsQ7kcfdgVRAxy6eFXoMi2amUWukFzQhtYTeXrsHTyfhOe?=
 =?us-ascii?Q?kpTKM/9v/6/0LDvzKoKjXmv2YSYs4WxHR4Jkcq1VJ13X4BccGlby7CkEgoZG?=
 =?us-ascii?Q?c0NHLzA7ZxKtXDn/u9hNB9+xgRoBpGIUSfIMOWN9YwCga3LcflgzjIQoF615?=
 =?us-ascii?Q?NLrKyNafJD/A3VbDxpGzkSJFbEvTTFRIg5bWB3d9NgyiNOsleUTrqurXQQ3o?=
 =?us-ascii?Q?NglKfj5EcKmMXGa0n8Z/HcccRgvqeojjO5sCqrjrjCaAXDwImfvsQF6CcgwC?=
 =?us-ascii?Q?VJBMuVVUdwei+f0i1JfFFP7V7G1cPdhYUy16E4R0NTi+gcnD0QgRtatRyzf2?=
 =?us-ascii?Q?aftIjfL+n5SWfBhSuK63/uOdI5gPco2aObsmkQA0P24pjDGYfcjEVVxeguz1?=
 =?us-ascii?Q?Az9gK/RwhJJqd86k3VDr1nvH0IZJ5hjRyJtWYucnpZ9oULndoQ0tBySk248D?=
 =?us-ascii?Q?YTpg7BgBt4bPpybg16vgEfStmvpfor4Fvpn2Cr2tJNqTQ7o1g3JryT2YHiFM?=
 =?us-ascii?Q?UOy+1gmwDaS/4FeSiX+kICQ9oA19VgGbBmxsly6iU9nbsQKlTEFO0/vqsIbA?=
 =?us-ascii?Q?sF5JUQYln8QI1pt8LtOo8JFZ102cp4QS+Q18QoJvX6rqNsRtoaKj8fDhWHD5?=
 =?us-ascii?Q?RsiJKvuZcfI5RgpdKH3BdhJk54CqF9YR5LRuBxtDGuImA2hf42iar+qiVqS5?=
 =?us-ascii?Q?a6wNnC11UgQ02XL7jCfjHWZolnAEm81z4AS8ih3h9zIATFvsRsDM0aWljgre?=
 =?us-ascii?Q?HA43H8Zt1STLTj0eNMkGEOHixyh/YzE6P9uP4BCFmAYByDX9kzqpIJLhOmcC?=
 =?us-ascii?Q?Cb7/hWtuCpKz6RauTQwfCh7OwKW2Zz5O84LlsvwBWbBJ1GexLNc3iZQIr0Mk?=
 =?us-ascii?Q?mawRwj71aNdNbQl2CdoaiboNR6GVCotoDW2/qjfHQCPpmXlmMTK0UVbqIhYY?=
 =?us-ascii?Q?QRHoVzGRF4RUtHCxsoCFPUGyU/SN4qEvZ19rvGg+7rmuMS1//x52c6HdOZqX?=
 =?us-ascii?Q?0pd8UwVbpHgnYfaNZldlXfgv+QFhNIXTDk530xe6X74T61NgbLtrQ1Mulnu4?=
 =?us-ascii?Q?sy9SotvM4w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 68a6f946-8ea4-46bd-1df0-08de78b4b56a
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 23:37:46.8277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: luS1kPrV/TLJmpMN2xLnef/WLoBvAvVTLSrodxfTV/P0xCIrCznMjuf3w7bUwRKty0NU6+QgriRwh8xpqAHu7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9061
X-OriginatorOrg: intel.com

On Mon, Mar 02, 2026 at 10:46:06AM -0800, Reinette Chatre wrote:
> Hi Everybody,
> 
> This is a collection of resctrl cleanups assembled together for convenience
> and simpler tracking. I'd be happy to split them up if it makes review and/or
> handling easier.

If it is time for spring cleaning in the rescctrl code, maybe fix some
bad fir tree declarations too?

Note resctrl_arch_pseudo_lock_fn() needs help too, but complicated by
having #ifdef CONFIG_KASAN mixed in with declarations. It might need
to remain an exception.

-Tony


From dd9c2ad1a1361b34e25fc10d18d3ceb3ba57fb92 Mon Sep 17 00:00:00 2001
From: Tony Luck <tony.luck@intel.com>
Date: Mon, 2 Mar 2026 15:28:36 -0800
Subject: [PATCH] fs/resctrl: Clean up some bad "fir tree" declarations

Sort local variables by length (longest first) per TIP tree.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 fs/resctrl/pseudo_lock.c | 2 +-
 fs/resctrl/rdtgroup.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/resctrl/pseudo_lock.c b/fs/resctrl/pseudo_lock.c
index e1e9134474f4..cd57d862e0cf 100644
--- a/fs/resctrl/pseudo_lock.c
+++ b/fs/resctrl/pseudo_lock.c
@@ -797,10 +797,10 @@ static const struct file_operations pseudo_measure_fops = {
 int rdtgroup_pseudo_lock_create(struct rdtgroup *rdtgrp)
 {
 	struct pseudo_lock_region *plr = rdtgrp->plr;
+	char *kn_name __free(kfree) = NULL;
 	struct task_struct *thread;
 	unsigned int new_minor;
 	struct device *dev;
-	char *kn_name __free(kfree) = NULL;
 	int ret;
 
 	ret = pseudo_lock_region_alloc(plr);
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 0e93cecf6f30..b2ca6394714a 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -3423,8 +3423,8 @@ static int mkdir_mondata_subdir(struct kernfs_node *parent_kn,
 static void mkdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
 					   struct rdt_domain_hdr *hdr)
 {
-	struct kernfs_node *parent_kn;
 	struct rdtgroup *prgrp, *crgrp;
+	struct kernfs_node *parent_kn;
 	struct list_head *head;
 
 	list_for_each_entry(prgrp, &rdt_all_groups, rdtgroup_list) {
@@ -3559,9 +3559,9 @@ static int __init_one_rdt_domain(struct rdt_ctrl_domain *d, struct resctrl_schem
 	struct resctrl_staged_config *cfg;
 	struct rdt_resource *r = s->res;
 	u32 used_b = 0, unused_b = 0;
+	u32 peer_ctl, ctrl_val;
 	unsigned long tmp_cbm;
 	enum rdtgrp_mode mode;
-	u32 peer_ctl, ctrl_val;
 	int i;
 
 	cfg = &d->staged_config[t];
-- 
2.53.0

