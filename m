Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A22429D281
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 20:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774902055; cv=fail; b=V48l9HNDNcPQeUXLeg+2Sz1bstUQcUFdcoJxIom1DfUgKvpPgEPRipQlpxm2/OIg1EOpTdSI4qYx3b47GRfjM8GKXG8rWSGPH1nJDWVRJG24JDUdMxzjhoLaHZyISCmw0UMTuETjKobH/kERXRJ8CB6gFIXPbb5AhPH8pPvClbg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774902055; c=relaxed/simple;
	bh=sI7/vNPOxa9fNTN34+cpHAXDZoVvP7Nd157G63xKgyg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jLPMHLuFEKnO8LMHe4rc/5JBMldeMI76Zm8MVZSfoHbntYhrLbMak3fUJsZQhhwYOsTG/2/IIAPE7PJpK+ujPAsLH0UysUsc3tD9Jxa+Fzr2gyeWA3Y4sP+JBjKUJDj2ZHpeMPU16ktVcOaKR+DMvnIgRfJgWACOCPl5YW9i0eI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LYeKIsvN; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LYeKIsvN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774902055; x=1806438055;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=sI7/vNPOxa9fNTN34+cpHAXDZoVvP7Nd157G63xKgyg=;
  b=LYeKIsvNiplYNRh7zZpCBmVwYUjiq5u2Z3A7bdgl28n7IF3g6kJBBzyB
   ikVQdx246ebcqqNj7aO4n1Ruoe6QtxaLRji980XIqU+VX50td71oUHumM
   Hi63gsev5jSnpnOPR8393t+3p/otpNzOltt/ABMPFqwUgILagKkDIRRHY
   G8oEjzDXDO6wTyPoRv36rJwgnbFLXd72AORFLyUfuemKBGFdAHrHzbN5F
   2DvRF6NOFsRAeRQPyyWwRIMf1W2lsHjIDQaJtGv87vdZ+HeE113PSLfKE
   4el0314KiPoUqY1nzJOUVx3REifdrRQxuTS5nFeISlfY5iDFiyHXQ7jaW
   g==;
X-CSE-ConnectionGUID: 7uJQ+z22T4ity9vaTr8Y3g==
X-CSE-MsgGUID: iU6OmOdPSWSgJjSowTVIVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11744"; a="75872746"
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="75872746"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 13:20:47 -0700
X-CSE-ConnectionGUID: 5oAwcBaFRtmSlF7cDrC77Q==
X-CSE-MsgGUID: TFo09/hHTg+2g9QjrGSH7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="249202161"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 13:20:45 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 30 Mar 2026 13:20:44 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 30 Mar 2026 13:20:44 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.21) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 30 Mar 2026 13:20:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MmkIA1nOwe5ZPLNQYoCmduQ4nSMkEYGDEIJz3GlWQ4r2e2Vw8d2/1FkY1Gv03qBH0M5k2qveaMRToxjVN2u8a67B7wgJ2g37NOEYcVaNKsoR55/sbwFn6IP4zjW7Ku+WMeGvxmJx/ZkF/aWQ9Hb+S1aN0JWcrGpu3bBP4/U6vI7co9h11jo1DQka+qqp0aThl3O0YnG821Tlc3ZmNOnHFVxCv/Pi9RfHyBG5wSX4HO95fgbwnbgYcJtF83EnkxvLs2LSMv26EFW5P6ljlkSWpd7EE5ACghVoVfCHjN07fgKb3pdtJnQqkdjNf1mQmY3Jy+SXcq6738tSQvq2aRnSNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pnqeS5b8KtZ5DGFbqFTPN7c1NQ1EsP1CpEU3yk2UYpk=;
 b=jn3I0PXGMJsNzskbId7zj+5tA+ROwFo2BLkxQ0FJSmJzkgT69w7QBIxpyXL1Q7XvANztaPkZD79RciklEDWuwQImpcvG71ldR40DVGDLmzrSf7xAzCLzDoJ2YStKuzxoHwzCJDnuj1ltbYTftAB9iTIFjpXacWHg6ZGStOhMjv0SJwPULwdVnvkCtmR9krEeV8YQ2/rAE5t5vI2Ff7z/yOTtZw9dO1hSo+CjMOGRyFOy7isvd2Jb9zyDwWUd7sE45pIOWdDA3d1g2ix7xZeuJJMce3K3TSNCYFkFgxAOoRejlpAVy292UypZziLN0O7aMKUS3amhAEc+Wd50aAI0Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by LV3PR11MB8458.namprd11.prod.outlook.com
 (2603:10b6:408:1bb::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Mon, 30 Mar
 2026 20:20:35 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::7d4b:a049:aed5:d2b0%8]) with mapi id 15.20.9723.018; Mon, 30 Mar 2026
 20:20:35 +0000
Date: Mon, 30 Mar 2026 15:24:26 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Dan Williams <dan.j.williams@intel.com>, <dave.jiang@intel.com>
CC: <patches@lists.linux.dev>, <linux-cxl@vger.kernel.org>,
	<alison.schofield@intel.com>, <Smita.KoralahalliChannabasappa@amd.com>,
	<stable@vger.kernel.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: [PATCH 1/9] cxl/region: Fix use-after-free from auto assembly
 failure
Message-ID: <69cadbfacef53_17924f1006b@iweiny-mobl.notmuch>
References: <20260327052821.440749-1-dan.j.williams@intel.com>
 <20260327052821.440749-2-dan.j.williams@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260327052821.440749-2-dan.j.williams@intel.com>
X-ClientProxiedBy: MW4PR03CA0091.namprd03.prod.outlook.com
 (2603:10b6:303:b7::6) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|LV3PR11MB8458:EE_
X-MS-Office365-Filtering-Correlation-Id: c8f29197-997e-4702-15ba-08de8e99cc9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: v8EfU+XTRizJr63hFy8vyHjMcCYanwVn3PgB6ZkRwY+heT0KKHy3rIevTBnWlPibZT9OcU5B/v1C8su68b3SPcgokHO43yRYb+Ozhj5KyopC9ypNSAzf70l5gE6Hz10145fGmhWix9NtUhkaYtIRipzakdhOEGd9W1fgs4nzngxDUkTP42UADAQJc80DpXhUSg73rdbHAgC/rgOgPRhG9QJ8zlOAD7WBGdMwOI7Bs68xsxRMi766P8Q9LAmt7/M+FjOvX6pGxdy3ZN5J2ZEiG2u0zqE5R10Wc9fyuQLMGhocKzSLTjKDoquQfPRKHL+ZTEjT7/dPNNMq3RHdhHGV/tjARACxw9cSp6irt1vrPsIMoclQrk9A9eKg/HNgXkLynCaFEBwnKx5etIH2v5GWBX5ux74JPn2mhXwTjTHcGrwl4U3Nv7bFN1B3XQozm0MmCHxJzrZnHOriWevzwtFepkOTVYDnfXSyjIex9UCOcJfaR6a4i+s5+suBQAYxaUU7WsG/aWPaV86uCXiHkeJVvKlcfQLe9l8XyFgm6RFwcHM8avi+cMPNMy7IFAtOVfj0uver3Zk5FHuC2+5Z3brZg8B1pKUpojMDEkXZ+lnb+u1nuoJEFD0Lww2HlHcp1HmV0nrAsMQfgyYKBA3tAHo7rTwt5xQWp+OfhZumAWOvuDNrf8TTA1FQ1KuTp6vFWqPyMpfecRESBB+96ek5g/71bKZD66bS78VXrpkK5gIC6ug=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T9sKmgzBcVXUnKzPtuY7PHrTuUE0sOenr7GZjCMzrtiUBhHIFSrcFLZphCfX?=
 =?us-ascii?Q?JuVFBYehnSILqu1d5lioSwCM9tsyu6F68Z4PjS0ih8/TT7r3R3XJ8v69wK37?=
 =?us-ascii?Q?gwOc5tqrxyTD8bpl6xSrAgq62NRpVEEYryLsv9EX9CeaF0PMId7sraFrymPy?=
 =?us-ascii?Q?ldkQQ7QmqBzhhFWIKakqv617dp5DHKp6V1ZBRQsk3WpXHZO5iufXgCaGT1Rc?=
 =?us-ascii?Q?yE7qvyIjdEtoyyBn+fxn1KwFVVk0vWQeaIUtMKMopUPXxbioJQwEy/QMeuba?=
 =?us-ascii?Q?kUEAcn+F8ZlAgQIN1TCDxF1a27MhRUMDEVr1FoaeJYGl2l7hzJMmXrmtBzEt?=
 =?us-ascii?Q?Fp7gw2Mz8vg78DkPMLF+0KCwdqTVTrkHWC2hlB2+WltbUwZcf0x+sErOakoR?=
 =?us-ascii?Q?/6pzYHY6td/g4yBQaPsbJUkQy4OvB5M4WA7OoD2KuC/ZCXx48sSlipSBuLtm?=
 =?us-ascii?Q?5/BkbE9lVSwzW4/nNfex2FptKgJSuzzhhdCaS9A0NN+xG0vSefUoWcROu2Bb?=
 =?us-ascii?Q?jtKaJDK8e03FIlJtKp4SXjCxjQE3DTnSOl/vTBUw3NtSI3bWddMS8FAfQKMN?=
 =?us-ascii?Q?vb8gCqk9V/i8cQRzEs9cwpZJHH8/86M2wFenxkZIpRcso+G/EZXp7dMu/xVu?=
 =?us-ascii?Q?PsWyyUFNHfz2Y28aePdffPw8v4OISlNTC+h9aTZ0rvDF9rgeh/Zcjby2F4lx?=
 =?us-ascii?Q?JfnLQC5js/0l0wLsmQhBFSrOlJNrJbpjmKFXMy5crUPFhg68n3G+N82V/S+v?=
 =?us-ascii?Q?RFAlEusI4sKtLFMBXINJt3tC93SHkq7SA9/MW5VBL1DEzMs286H8W7AgC3M+?=
 =?us-ascii?Q?PlF0wgkq5mJzXqAMhW80Zf7W0AZSXQTXNNdIXX+KzYGxO0vIbW2nN5c71jNB?=
 =?us-ascii?Q?wS97At6a6YTtHhJIp422imA616CazV8BYCoELhgVPRc0TD2br5In2Jy9/Ff9?=
 =?us-ascii?Q?M0FHUdD+c6kQbAJznwWtRuaG03k0KF3K+KIAC/cRqY6BJdqxSz1Zwn2GR/TH?=
 =?us-ascii?Q?VP54N0mXjwgg9Q8j/EDe+v0kh+ar3Is6kNdOm3UMOO4axo24KG0ib4wu6U9E?=
 =?us-ascii?Q?LUPobZ/7v4njPTO0JL3rjcqAMSY8RB9hm41Qr9+Su6SxtuSfO3oiDof5AQWH?=
 =?us-ascii?Q?7KKDHBh8bXzkxA23yhA6ljrEAbWqbjUp+UO9sFL1VhI/uOs2jbYccLW0Nusk?=
 =?us-ascii?Q?N4C4fH9wpJ2Y+O5+0bYDtknT1ZAmO55yIEXE5IhgBBJ52K78fU4ViGIRPHwK?=
 =?us-ascii?Q?DvASoF859scEFgSbrTa4948LmKDvDMrQEAea/vpEu17qCTSCNEF+tqwxOjoh?=
 =?us-ascii?Q?dyC3OeKjajqjfJp37LGuBzwYCkszk0NsERG/Kna685NSuBWGb9Jmo6LFFH2C?=
 =?us-ascii?Q?hvLrOPh/rSu8jbzLEqDxViKXSdV6S3sGwK4o2TS8fviBRvtB6ewNta6bfqf3?=
 =?us-ascii?Q?/eDb++eB2ED9EtM04eI/qc9vqGMUSqaEWU4qWtfhDBoj2pZ6BIbJK2BjWACw?=
 =?us-ascii?Q?F07ticeF4cXzt054tJn5WibgxLBk3/XetpqCZl+FCUyWd/85GCfWOnwC+bE9?=
 =?us-ascii?Q?cxVQVpkl4oEt9YcXV9rWqpPWZCwdnQ8/cwuuVUcNpFTEd6kDjXEmAsUPKbzJ?=
 =?us-ascii?Q?CpKhqghgCpUmbJmMkmXyHPiO0YaXOQES5+SwQhQsXW2fdhiG8SMrPupunuVT?=
 =?us-ascii?Q?9rIHMngiJHVxhns3uow4JGqnbIkPCM24h2pORjI+7P9Iy6SDXLO0YT5hI1HP?=
 =?us-ascii?Q?V2asPD5beg=3D=3D?=
X-Exchange-RoutingPolicyChecked: dM0L4a4qjTXaeCYd4jDSWtgTrtf08PHePpnCOwjYNMiO9lXtcO9YxZFLomYA/4tz3LHN98xQfPPvJ5iebNQG3nbmJ/pLCc5qkxTgXZMIYsFnfBY1SEX545cSEdrKCutV4C8BszSIEdKV/qmeVKPXZAhScMNm/knImu461DwRW/ls5vf94aWKFdwVvIZLKaoQywZ5yOJ/Eg8bBRE8xAdHWZsvAkDVh1HJZqmjwZTOXdituhapwPI2N0N+7bNMK3I6foguyIhGoeW8sBj1MiohM6BRjSzFYpRcvrv02l8/9CbXLDpU1IFgNq+PseznTABoZ2Army3LCEGzfcqK2gRyYg==
X-MS-Exchange-CrossTenant-Network-Message-Id: c8f29197-997e-4702-15ba-08de8e99cc9b
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2026 20:20:34.9994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +xWDCVLOO+3XxapUPaYAzoYhpv/CYBUD2iKpMesE/nT2v053Rc1WolZjNxd2aZFzytA6tdbtddMlbzGQCQ9GXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8458
X-OriginatorOrg: intel.com

Dan Williams wrote:
> The following crash signature results from region destruction while an
> endpoint decoder is staged, but not fully attached.
> 
> ---

NIT: When I applied this series to check it out this '---' incorrectly
trimmed the commit message.  Dave should be able to fix that.

So with that fixed:

Reviewed-by: Ira Weiny <ira.weiny@intel.com>


>  BUG: KASAN: slab-use-after-free in __cxl_decoder_detach+0x724/0x830 [cxl_core]
>  Read of size 8 at addr ffff888265638840 by task modprobe/1287
> 
>  Call Trace:
>   <TASK>
>   dump_stack_lvl+0x68/0x90
>   print_report+0x170/0x4e2
>   kasan_report+0xc2/0x1a0
>   __cxl_decoder_detach+0x724/0x830 [cxl_core]
>   cxl_decoder_detach+0x6c/0x100 [cxl_core]
>   unregister_region+0x88/0x140 [cxl_core]
>   devres_release_all+0x172/0x230
> ---
> 
> The "staged" state is established by cxl_region_attach_auto() and finalized
> by cxl_region_attach_position(). When that is finalized a memdev removal
> event will destroy regions before endpoint decoders. However, in the
> interim the memdev removal will falsely assume that the endpoint decoder is
> unattached. Later, the eventual region removal finds the stale pointer to
> the now freed endpoint decoder.
> 
> Introduce CXL_DECODER_STATE_AUTO_STAGED and cxl_cancel_auto_attach() to
> cleanup this interim state.
> 
> Fixes: a32320b71f08 ("cxl/region: Add region autodiscovery")
> Cc: <stable@vger.kernel.org>
> Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---

[snip]
