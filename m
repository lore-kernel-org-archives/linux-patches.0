Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0640234575F
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 18:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772562066; cv=fail; b=jOjZSsGKkboFm7BlAQ1Bmc3mTVxPsiT5eGckz1sp+ct0/JNkmhgh+MuKlg/jVVzwjdvK6ZHZS9gAxOuxyMDtFhp4csq9LOwJFetwAvQURNypZO1INqTWq9J1ODBV2ZOjxVJIgONgMJ41ypm3YPXd0BqSrkK7a11fXZgnLthUMjE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772562066; c=relaxed/simple;
	bh=2wymGVdfJ6tlsK4sH4amVYWrbu+0S8oRW0iXNr0Gjj0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BFBGAfmiMBYwV9CvOvWzXLWOOAnD34reU+/S/12PPKGnf7uJEFlJvb/a0uRNXbVWQKpCi5nchNtIEYgtJ2lOFUcm0gE2aTbT39BRH2VUqEA4lqmEJ00yExxod8RJAHI47tfopQUe9Ojf9i+xk6OQ2iUcaXU1pKi96isp1db/fq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MvlcPbJ5; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MvlcPbJ5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772562065; x=1804098065;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=2wymGVdfJ6tlsK4sH4amVYWrbu+0S8oRW0iXNr0Gjj0=;
  b=MvlcPbJ55xpeD3I+dNKeDFVW48Ng7ivaugCds+enkgRZl60O4wJ8oK59
   viV0/r3BjUEqpoCQARpuSL0doHbm3OIa9xZ7cGCvNjuRWqOXHauD0eXwu
   icssoiE47F4hnuGgQBYoR0wD37WrOxKwa5b650DwFPp9PPG4m/LcHsR56
   GLegFq2a+OHqJaW0BvGIcfxS8Iku2zvc6JYlVryAzp+c/JTKy6JPP2Zj9
   +ybtJkPgeLouXZPZ4umWkt2J6ZMW9dRWcBQvWq/zNQ4qdNzmTRf6eAp3b
   gE0YhjcJkp8w424REpdSK1e14gkqOQ7PqfGWOc4NkLOxCkpndAj3unLmW
   A==;
X-CSE-ConnectionGUID: PWA75Wp3Qza0du+nZPDCzQ==
X-CSE-MsgGUID: 8XhsVkLCTpiMe2NS5m9g2A==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="73526162"
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="73526162"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 10:20:53 -0800
X-CSE-ConnectionGUID: JAWVCybPQqiCCsr6KHar6Q==
X-CSE-MsgGUID: RWcnN++BRoCXHppIryArsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="241088570"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 10:20:53 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 3 Mar 2026 10:20:52 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 3 Mar 2026 10:20:52 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.41) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 3 Mar 2026 10:20:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mEj4WkcEXZ+juP504mxlzl7AZoOtNmLDLOPH99OGL6vup7iY7sFuu1Q+CoA1Hd5N2i+rpP3D/vKySNXMt8WK3fVrDmXUyGFDsHwRsq/PMcXk7bR4qfLP1S/eg8YzSQ1k/cluVsxaiMYkWPrgswKLIJCamL1FsM/jMR1mI/NCzlT1cWjJzboOF6Sahuj/A86OwuDo2BEjFd/v3NjGr12tph3QdSNhsmRD0EMwVX1uA42QYVEfpGMbpCNoVidSHDXE3fCgxSyFxt/fiVq/N6r5Bhkx5owbXD02KNg77og7jDTqnPZrFxm4AotABNLEt9dnP+PbMKU8hhrKYBUFdFgbxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MIO/pnUT+39AN/QJraD/wmwQ78VE/SLMYQHPljwccb0=;
 b=HCugYUzLUNdTxjQHFGNIaoZkC3VCTHQOoL4pR+cHKW79nJU9zELuutc5oZcNKvcVPupxgOKChNfGQwXInbN/dS8dHSAdncZGBuN2szBoSyefpwrkNbW9pfw+Tae8JEJhZCHWJwtNpqPV5LwEBIUG0e++2q3TYNn+e+uJQmePe+sNbwYaL6eD9TAKB9WxRgc4zFAx5aXPRvuHm0Sg85T9IWFtGWNWnSTRtuFzywGVc0PClvj7f2EgHgYEo6+kzjsPm+c+h/NSUVr9nGBl5K0JCr0SsUmqsl+c8taLEzDra7ZmX5zPXODUqpbmH9on/Hq/DNClFHRt7eZDmK3j81F+gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA1PR11MB7855.namprd11.prod.outlook.com (2603:10b6:208:3f8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 18:20:50 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 18:20:50 +0000
Date: Tue, 3 Mar 2026 10:20:47 -0800
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 05/11] fs/resctrl: Use accurate type for rdt_resource::rid
Message-ID: <aacmf_CM52gHRMot@agluck-desk3>
References: <cover.1772476561.git.reinette.chatre@intel.com>
 <956a7f8c9ff85b873ec85159a66d5e3c8b468d70.1772476561.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <956a7f8c9ff85b873ec85159a66d5e3c8b468d70.1772476561.git.reinette.chatre@intel.com>
X-ClientProxiedBy: BY1P220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:5c3::8) To SJ1PR11MB6083.namprd11.prod.outlook.com
 (2603:10b6:a03:48a::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6083:EE_|IA1PR11MB7855:EE_
X-MS-Office365-Filtering-Correlation-Id: e552ca64-3f4b-45de-0e61-08de795198e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: 7bmPwvxIdQFUVmGYib8g6imkMWsVa3CJ8Ab5m5hIPwnJRtaX0LpJvNfMmovnmBQD1dJWsp6PqZBowCvrvsVJ8C0BZ05kf3wBohZqbZfSyGQDaYvnix5W1Jhvz14Leok9FESg/JHiNV92LbGvsAlHVBoCwKJ+OQ6ElovqV5ecIcN1FDeYDoC5KCYG+zpKifl1lSzAcU/Z5lGeHmjrL76ZqWI1mDy/t8HbTsApUfIAn/uCozP46EpT9zX3Du5gMkUTqZNneRJ2BQNrYi7GXKKvbVm0ldqXnRj55k5n9jQRYZgRwcEL7r80esYFcerUgJTx8E0vVy/lif84whH9kTmcy8Rz5lgjPRuxdN1B2RmGx23mc7OIzPzoO92Ozut1KZvcMJfl9WZaLUewkAKq+1UH4M9RlJqQXswQGhME9HLxCoURlTmBiSZ5edMrvaNkoBXMtexS9Xc98LOHORwspdTOapCVI4c+6naEaP4s40LwRGn82TqdL6vzyJhT7uIewNMjNpLpCS6rC82IHr64ksv+P1UIdkrxI6iumk+EeTm8gPjysWnbx1gUMuVWVWwzWt2JI5X+v5k/a9SkcYddoLZj/MVfTdrEX51PZvjPw5/6kY34k49hv4VZJdX2SIQMQZU9SFXDR7rJF5RguWo+qHBEyj2MdqcF4hmXzTxwsW0uwBrGBnP4lqO48vjInijJOXOKkO0WVybxGV0/bV/Fdcd00ZKBB6avlBrEn3wcgRZfR48=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fshgoqyR5SHoa4vlYEBF5watMMQ9/7mlfShNy/kyGdUVxTGWhVaMU5awlpkf?=
 =?us-ascii?Q?+pBuNLAj8BNkOq9/cSBoe6Tz2u4g2FB32gmzvn05qfnw32UcrSE8mJCA7JCr?=
 =?us-ascii?Q?08TklvPwXACk5D7Maj6iTFxr5LK6CXb8AgpvNmYjaCCru7WME/pyjPT/ZfBe?=
 =?us-ascii?Q?zlQ7FEW3IC5EH+/+DEGuzW3/GaGgV8Mv+dbS3qxWNxpGXLh/+5S+LMGmnBxh?=
 =?us-ascii?Q?Saw2uZvPTAV2/bg+PGzxdBUyL80vfNerMEIIMTvxDmsQ2zhsChS/3WVycgV1?=
 =?us-ascii?Q?NwnwZI8NVmTALjXm7Q77GnaH8XFvLPeG8aVe717aINOt5FJa+waoljLYrokd?=
 =?us-ascii?Q?uYtgz+5tq+WBnOBgePWWE37jNEFvb/GjzY5e/+tn6dAcgi9/l5dzeFGzV2qn?=
 =?us-ascii?Q?vkxqLV2vgHYq99M2LY1do8jIWPBNL9MwMnkR9OoBghxqieg2FoGGdEKToIbc?=
 =?us-ascii?Q?Rxg0g0QqTyPhgq+9ZjLnihaQCANDhle05s4DO9nfxZta4u6yhlTXx+3WFulc?=
 =?us-ascii?Q?eDL54R0BOpankN14MO6w66CReOOlxDXbEfGzXpuHjciN/hbUSjNegsyQeVRg?=
 =?us-ascii?Q?RJQvJH+RzCWS9+EPvg9tIg84Mj0sAFXSaMbOEf8RkBewrujbDxd/vpp92B/E?=
 =?us-ascii?Q?hcFqkw5GPYWv7phiPXwNxQRasug9Zm8nKpOB4UE0FssbTlUDt+TPHt3FAXJr?=
 =?us-ascii?Q?8EavGEUNTZiegVGoJOQWsNaPzvI+I5ptzKvYgtsZJ0jjWFYMFOsMfsF//tA2?=
 =?us-ascii?Q?eKqyb++SSjbDLf1wfSE4zV58ED442s/wtCHRjSgj30ZxTi8hJ3ZCkz0+H16w?=
 =?us-ascii?Q?TWNZpRBUUKzXWhNBIBaIE1YlYyLYUhoSwF1NIl6tFJgECcIr0wrb+kIhHHwl?=
 =?us-ascii?Q?PWHWNZf5G/ft6m9cspcjdBgkd5A/PIzEKXobVHhq7Y2xWLRiicc9CbtRgVWe?=
 =?us-ascii?Q?Il8kiH6IYqU2UktoS8JoT5XTsdqu8OWeB12cGzd65dDlyt3gYv+kkieU+z+z?=
 =?us-ascii?Q?2ZI0WGaliaU6V0kK66BNJsULFIaYMP+QqADmqI5nfS5Y/yq9fJqfL0B5iKXk?=
 =?us-ascii?Q?6AWU1XzlyjOQoUnpzNm8GxFZJnB7Ho/1wwUHMj1E0S829cfZpnbBNX3yoleb?=
 =?us-ascii?Q?zSkGLYSketvPz3Wld2Y3vtsCdkXzalyRnu3jMKT0zlWZVJBGpAEBb1uLhwpu?=
 =?us-ascii?Q?frNpprGe3lM5VGPwGOtfADRlyOKjaY1uIc1Jc1us+B0Rpwp8EvPK3/Dw0cZo?=
 =?us-ascii?Q?fBLavu+41krEzamV1QQ9lygElwAeedvGTh0qE9ZwIlVA+ff/pIRRlsHvOQV5?=
 =?us-ascii?Q?IQay7KbEHrCtFWj43k/IlsmWRczIvHcAgz84v25nIDyUcvA6V3p0/5yiFy0T?=
 =?us-ascii?Q?NLHU/A0GcpzfUAjTZ2wUoWt8OaCwL3pnZ/uldo9+MxYBgdgqw2D/Ws0M/2Ph?=
 =?us-ascii?Q?KfoVAsj4Lil5p8Gn5f16uBT8Kwd0bE4WQLsBG06bBS3F3XQPTETvomhd3UGS?=
 =?us-ascii?Q?ft4AM4nN7FOU8vcnRWE9/7h049U3ot6vaxgbpTvA8BbgkiMTnqDBv+wmIegQ?=
 =?us-ascii?Q?HavPxXewtk/kBp6raSsarB6BLCZI6yBS15MgITY4wUtb/EwlEjGNDln38swB?=
 =?us-ascii?Q?dbDLz/YECUad6h1YVEXCyMqXoHO20CLP5wUuyaaZYL+yY81T+ROl9ip9b6nw?=
 =?us-ascii?Q?Tnyx0qL4asYS2IsXOVbphZqjVOC/JSxz/QBKBU6iFJRUDs4UcDJmU115R9Mi?=
 =?us-ascii?Q?FZ9BieCDyA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e552ca64-3f4b-45de-0e61-08de795198e2
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2026 18:20:49.9244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8npnqaDyWWVZgRZBYWk/lvoqBnLMfqNo6hyH3+mJTtHPX3w/LzqtmtWfTNhG7ePhbWE43VudyjdPLdsANPD8rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7855
X-OriginatorOrg: intel.com

On Mon, Mar 02, 2026 at 10:46:11AM -0800, Reinette Chatre wrote:

> -	/* Must be the last */
> -	RDT_NUM_RESOURCES,
> +	/* Additions to enum need to update RDT_NUM_RESOURCES. */
>  };
>  
> +#define RDT_NUM_RESOURCES (RDT_RESOURCE_PERF_PKG + 1)

Alternative approach that doesn't rely on developers reading
that comment and updating the define.

Replace the RDT_NUM_RESOURCES #define with a variable initialized
to ARRAY_SIZE(rdt_resources_all).

-Tony

From b31a874c7199347d875fd6e9505d41aa2639eafd Mon Sep 17 00:00:00 2001
From: Reinette Chatre <reinette.chatre@intel.com>
Date: Mon, 2 Mar 2026 10:46:11 -0800
Subject: [PATCH] fs/resctrl: Use accurate type for rdt_resource::rid

Every resctrl resource has a unique ID described by enum resctrl_res_level.
enum resctrl_res_level is used in all resource ID initializations and all
resource ID comparisons. All functions consuming the resource ID expects an
enum resctrl_res_level. Of the four structures that contain a resource ID
(struct mon_data, struct mon_evt, struct rdt_domain_hdr, and struct
 rdt_resource) only struct rdt_resource does not use enum resctrl_res_level.

Switch the type of rdt_resource::rid to be enum resctrl_res_level to make
it obvious what values are valid, match the type everywhere this member is
used, and obtain benefits from tools that can flag any enum misuse.

Use a variable rdt_num_resources to replace the define of RDT_NUM_RESOURCES
in the enum to enable tools to catch when a switch() on the resource ID does
not handle all the resources and thus help flag which switch statements need
an update when a new resource is added.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 include/linux/resctrl.h            | 11 +++++------
 arch/x86/kernel/cpu/resctrl/core.c |  9 ++++++---
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
index 006e57fd7ca5..ef2efa2e4b39 100644
--- a/include/linux/resctrl.h
+++ b/include/linux/resctrl.h
@@ -27,13 +27,15 @@ int proc_resctrl_show(struct seq_file *m,
 
 #endif
 
+extern int rdt_num_resources;
+
 /* max value for struct rdt_domain's mbps_val */
 #define MBA_MAX_MBPS   U32_MAX
 
 /* Walk all possible resources, with variants for only controls or monitors. */
 #define for_each_rdt_resource(_r)						\
 	for ((_r) = resctrl_arch_get_resource(0);				\
-	     (_r) && (_r)->rid < RDT_NUM_RESOURCES;				\
+	     (_r) && (_r)->rid < rdt_num_resources;				\
 	     (_r) = resctrl_arch_get_resource((_r)->rid + 1))
 
 #define for_each_capable_rdt_resource(r)				      \
@@ -54,9 +56,6 @@ enum resctrl_res_level {
 	RDT_RESOURCE_MBA,
 	RDT_RESOURCE_SMBA,
 	RDT_RESOURCE_PERF_PKG,
-
-	/* Must be the last */
-	RDT_NUM_RESOURCES,
 };
 
 /**
@@ -319,7 +318,7 @@ struct resctrl_mon {
  * @cdp_capable:	Is the CDP feature available on this resource
  */
 struct rdt_resource {
-	int			rid;
+	enum resctrl_res_level	rid;
 	bool			alloc_capable;
 	bool			mon_capable;
 	enum resctrl_scope	ctrl_scope;
@@ -336,7 +335,7 @@ struct rdt_resource {
 
 /*
  * Get the resource that exists at this level. If the level is not supported
- * a dummy/not-capable resource can be returned. Levels >= RDT_NUM_RESOURCES
+ * a dummy/not-capable resource can be returned. Levels >= rdt_num_resources
  * will return NULL.
  */
 struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l);
diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index db787c4dee61..2557bb639555 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -16,6 +16,7 @@
 
 #define pr_fmt(fmt)	"resctrl: " fmt
 
+#include <linux/array_size.h>
 #include <linux/cpu.h>
 #include <linux/slab.h>
 #include <linux/err.h>
@@ -57,7 +58,7 @@ static void mba_wrmsr_amd(struct msr_param *m);
 #define ctrl_domain_init(id) LIST_HEAD_INIT(rdt_resources_all[id].r_resctrl.ctrl_domains)
 #define mon_domain_init(id) LIST_HEAD_INIT(rdt_resources_all[id].r_resctrl.mon_domains)
 
-struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
+struct rdt_hw_resource rdt_resources_all[] = {
 	[RDT_RESOURCE_L3] =
 	{
 		.r_resctrl = {
@@ -110,6 +111,8 @@ struct rdt_hw_resource rdt_resources_all[RDT_NUM_RESOURCES] = {
 	},
 };
 
+int rdt_num_resources = ARRAY_SIZE(rdt_resources_all);
+
 /**
  * resctrl_arch_system_num_rmid_idx - Compute number of supported RMIDs
  *				      (minimum across all mon_capable resource)
@@ -131,7 +134,7 @@ u32 resctrl_arch_system_num_rmid_idx(void)
 
 struct rdt_resource *resctrl_arch_get_resource(enum resctrl_res_level l)
 {
-	if (l >= RDT_NUM_RESOURCES)
+	if (l >= rdt_num_resources)
 		return NULL;
 
 	return &rdt_resources_all[l].r_resctrl;
@@ -1121,7 +1124,7 @@ static int __init resctrl_arch_late_init(void)
 	int state, ret, i;
 
 	/* for_each_rdt_resource() requires all rid to be initialised. */
-	for (i = 0; i < RDT_NUM_RESOURCES; i++)
+	for (i = 0; i < rdt_num_resources; i++)
 		rdt_resources_all[i].r_resctrl.rid = i;
 
 	/*
-- 
2.53.0

