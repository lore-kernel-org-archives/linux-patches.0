Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2059.outbound.protection.outlook.com [40.107.92.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14DC13595A;
	Fri, 13 Jun 2025 13:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749820381; cv=fail; b=iuV6nZs0CoydmsLM9cc2GahgP8BKl6bqL1XkuenIp2Qvfq0ivzIZGFTpXHrOmi9DLAI4R4WJjLcmmjWNeuqkUqpV7Ly9KmB8gNijruB2bMfyRsqU3/K5vHqs9AX3srNE4mcdie8gcxQa7b1kvReW8JY9BWDEBt6Wb+08KuaLgDg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749820381; c=relaxed/simple;
	bh=9Mjbl9gSZYXKJWb86HwHBIAMgk/X2e4MWQletk7fZh8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gr51FTrnq9YJig7q3/7cPO0sO+UIO7Hmc3fwlScysFER3JpCwvY3gY+K8idCPjbhejn7xgA2Bfy17oHEtVu5TT6Vt1Xd04HkyIJzVPzafKCSZtc3W6wS8kQy4yD2YuTH6Sjjd5qxZ+oPe15YDtc++xLwW7zFIgAofgGSBlIdf7A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SnpT0KLM; arc=fail smtp.client-ip=40.107.92.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SnpT0KLM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U0hkf2WYYArL1CJ/bWdpE6oOSeT16z36BmVI9nYwSZZztH1VwR/qF0rPDAAyNgF1izLnqJArqHS8ofkGjv134AzVmZgqHugRg6HstlMn9wtm2qepE/iMeACmTvmNORgsS8ygajwjOmDor0talO0wAkgSwUR2pj9L6ZPrEGoVm25QWXzXqZRZkJKgsOkbqZxL+UNB3607ya859d0/im+flPqYFzHyiTqruSjSxyzdE4ILef8ZngzCHL+eTByDfApkF/zZ985W7hsBB2J4Vt4jPs71G6RtT/mHii/l4l9POU1a0RF0jKvxXDYyZHNwENSSdonUK10h9lQqFAu88fUhVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A2xiuf7yERa5yvlcd9khgxQwit5euvyLLImftYYBFC8=;
 b=kOi7HEIq+cjxst/JUpVEkkGRjJoX7X2KtwjykE9ojE43nS2HEe4e2zzNBC6Et50SU1l9pZRW60wP+YfjOI0YQr76HhV/3VbtC+xd5AW6ClWgr72MmrdQk9DXK5VJ1dcMUnWryKrsTGWlIQTZAo8caNizHFHj5zhrGUbAZ/xro0RIxjNcxrh42PoafEgYc5u7wJDzEBg1YFI7Te+D43C7NEmuZRT1XT7iBGFWcPBQkm6UrTPFMTiZjm91u7kNQkShdJdJBkx8SDYv71Jd67dm2ZhEF9lp7SRLqO/K/hbwFqb76E9ap8b6Bu4vwo6e3Wxmh2RzR5LsxjAUgTFTyDZnug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A2xiuf7yERa5yvlcd9khgxQwit5euvyLLImftYYBFC8=;
 b=SnpT0KLM/+lEMyHononJifHOFEZ006sD/iNFjENjYVW3000qf7SpZGNQ6fxnhD9GwIFUNmOU5yonQFsDVRM8g2eKlIdGIGHS6X3czCt2zhsLeR35Eq+BHtRvqgS7jRNNT0AOOsLqt7nYvHCWuBj02oga5WkoDnaegKSF7rKHCWKoGv8Q5UW0fYCrQFR+fS66cMRw4jEU3Wbc8ZPaqNkDdkVuazNAjHSZ7O8lqrp/mVwf0aoOIbi1y81EoE7IMDI4YNo+ViKQxMGluhEVrX9tMgx0reWhsMWlcGo/q61czDDx4jW04sZzOQTeIio59xr6VmPhdS4JgBgvxmfSSQoALA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ0PR12MB6965.namprd12.prod.outlook.com (2603:10b6:a03:448::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.41; Fri, 13 Jun
 2025 13:12:55 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Fri, 13 Jun 2025
 13:12:55 +0000
Date: Fri, 13 Jun 2025 10:12:53 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Wang, Wei W" <wei.w.wang@intel.com>
Subject: Re: [PATCH v2 6/7] iommu/vt-d: Split
 intel_iommu_enforce_cache_coherency()
Message-ID: <20250613131253.GA1163305@nvidia.com>
References: <0-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
 <6-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
 <BN9PR11MB52763C1B4AED06073FAF79EE8C77A@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52763C1B4AED06073FAF79EE8C77A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR15CA0035.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::48) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ0PR12MB6965:EE_
X-MS-Office365-Filtering-Correlation-Id: 73509047-0ddf-4d83-eeec-08ddaa7c026f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TyE3sDYwiiFaIet9e0iPMtjogPH/dEILU6UDAsJ7wRlIofU7z4slZNSIX9L7?=
 =?us-ascii?Q?EchKEElA4pfAK6gJvp5n/ynuM87IqTwFFj9NzK+FXOQlzPYI1NYELkH+EmPd?=
 =?us-ascii?Q?ZJgVU7Xd/VftS2MuSQp2nI/6QtIUu0V+PWb2oyAftMZGOU+zQx+cebyvE/ic?=
 =?us-ascii?Q?HDmQjLjaKwRJi3Z85FKRjMEdyChFyS2ryLRpzXit8EEc4UEC0o/uIO3pvlIw?=
 =?us-ascii?Q?Yeuod4BxVxJZWxuZqcWGJg1nj/dFtSVGce/9KJtbLs/hoIzZMk924vOFOcRf?=
 =?us-ascii?Q?uSVj1Z8F8Me5Dk9mcOss5UwTWP4faUGetFaCsHiyMniWLN3WHNPDGVVllDUw?=
 =?us-ascii?Q?pIDp1H0iNNVZNlyloNgBA8VksdxGUgEgF2HbYBFwClLYdKmu0nnFRb4rr55q?=
 =?us-ascii?Q?ex23A+BQxXkfncqOCzlm2pqPxiU1dgKADMj2KJYsgSoPSputfdoLTpi/v66X?=
 =?us-ascii?Q?bbQpaQNtx5TorPjX4XIWzwjXD8xgZf3juq1vuoV0XtgLI4SowvVMIFKZHp6C?=
 =?us-ascii?Q?ZEVLTqmajQHRksWBcCoD1Eoafh2g+4nw8F0g1MFpM8UaobGvnMe9bWioP0qi?=
 =?us-ascii?Q?0ibQ2tHXOqQMgRlms+uwSjm/L39XMl28YfAlpTw3IHOIOBPmG1di9X1hPQHL?=
 =?us-ascii?Q?gx9FR+AZ/3E9FRcIhvLJl92SpwuwGMUZ0fsb2Ragi/oE082X3+SQg2AZoncI?=
 =?us-ascii?Q?HoD/VJLzAxLGVvo6cfIOfjcyocd50A68L14laXjjOkhMSc22P3tqhHBbuhF7?=
 =?us-ascii?Q?Zr3+KL/wb6dLMeUaN8YmgF0J2Tay+OIII0JIOGNswYt4408jqCleoT6DhiSM?=
 =?us-ascii?Q?U4Iqz7rpoUdB2VjhgTwgnkezwSmD9FcVAhmljuYcoQMc22qH6rJtFmgo/Llu?=
 =?us-ascii?Q?I5SyUKZWFVenfP1VzzLusL8airF36ZhOznPgCs5g/bwbryzG42sdpX7ar1g7?=
 =?us-ascii?Q?XXHfLx8VrHWkhXYhfACo5AI+TufgtyBFs66G3Wvqy/efalhzZobK5SD1kHjO?=
 =?us-ascii?Q?LiM9U91NZGRBPgdr/TL+rFdSiFg32bStmg+hT79jNIAqgJ4faZeTImJQHGdC?=
 =?us-ascii?Q?2z9mYLsqoVdpu180TXsDlkbRm3+onnQdDGgVVfx9BRI9r7KcE8Vg7fSeuJxV?=
 =?us-ascii?Q?rQUCVBmOqkTvqtSNGz04ZuRGylJWlCazDNHEF725m35aWAmxrfm8Wt/HgaO7?=
 =?us-ascii?Q?GGu9Pf6VuoXUlD1nF3eWc1EkeH7ruPlDaZ4WDOnDHRz2puW/S1iAcftVlGO5?=
 =?us-ascii?Q?T9dnoW0ddyu881mGbiKdU0TcLhQzudW+lKAIGyupyEnNlFVVFXaFcJLVAd5u?=
 =?us-ascii?Q?cRSSCGuPaIC2CHGN0RMca6u24NsVwN76dxKpZXsnumyBhbt3TWVDBKJSTtrZ?=
 =?us-ascii?Q?jEmhkUEErW/wa20oJtCcpYd7brTNUU5JbeHHZTbCl12c58ez+XN/smnolMKQ?=
 =?us-ascii?Q?R9ErkzF++FU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PItNXMX3NYqW8VZfofxAn/Yeaxfl8uTjU2+6tBe1tp8GuUMgdKi7ugY3sKW3?=
 =?us-ascii?Q?0SipDec6B74MayS3mu0hptVskzyPrH/G9On0vF84K3EjIk+vZtYn3gKL31TV?=
 =?us-ascii?Q?ap1OgXwFuhnQz8y8aCHiTEQndeuaw3Z6hPHc4h26kZg8Nd2D/I/CusqHi/k2?=
 =?us-ascii?Q?1YibDkfSYETkX+nWPKqJCyoDUsnQI/yqaUH9YI4+b/9/lUZE/mc0qanjiUCD?=
 =?us-ascii?Q?roHEzLXFyzK2/0uCUvAhN9Zk0e3GrujEEn7suhjRLgminNyDEXdSOftrOwRi?=
 =?us-ascii?Q?Ue/9cG0k7DEBDBujp9RVnCgKml3YjNeUf3VRU2SJz4i2O0nl1p2sIRPx8qlB?=
 =?us-ascii?Q?OcwBNuwosMC/edPbk+947iiNnhHHh6em8npXf4IhdrF5bHLulEQ8A06VjzQq?=
 =?us-ascii?Q?B/yckg1cuTRFHmhFc3FYgOkalFM15S5sGlFn2eC7M3wmKcLlDWTa8EHmj32y?=
 =?us-ascii?Q?SaXak3UBFWUEhJjHXN7S031sPmzKvvSs+fI17uZPaTw2JwJmf7FFyDbUIJ8u?=
 =?us-ascii?Q?3q8H2m6hZ4JLno6gIw5Ra/Os058tCOSeUjTFukCdUV8z2Bpv0Nu0SDHlJpCn?=
 =?us-ascii?Q?nhwQnz9dih216M2tj/DQAslxf/njrY1bfhH2LSvi+nvVAk9dW3DgBtdm13Od?=
 =?us-ascii?Q?+irNOT/I+dBKRuQeecxAgJjxsKHJ8oG2gs8nbvA2KnxpbICDUQ+urWIeUX/G?=
 =?us-ascii?Q?9PdEmskHgvZ1h3reg+nmI1Rb1sKG0Hi+YfS5Cv0puTgs90rU6gODHjM9HDSC?=
 =?us-ascii?Q?2KDEq/HKpOJhpPjx4xvDFdaIEaS7z1s5VUZLaQJzkDzrvYZECLL52MuDLHIb?=
 =?us-ascii?Q?G4m6/VaT5+/3udEK8r15r33yijjNN0VAwn2xsVq6qRUtmsypknmvCb2SlJ+8?=
 =?us-ascii?Q?0J47iE2YsRDWbEwoO+ed9X+1xUawyNs+RMfA20PnoGRPRfdA7dsJfc/xwKAw?=
 =?us-ascii?Q?RvWVHnVgh7eOLHzDm2VAjEtrP2taQRe8SGfUqXZvx0PsV8TAMeeohh14r6q6?=
 =?us-ascii?Q?MYf2HWt/ZunIjjnCbtyDDDLccBwUCK/lUMxIcRhiWBKduCgeFx4GrNgPZPY9?=
 =?us-ascii?Q?ZDS92XEJ+e0pXQa8AewHQOxU6tK3ywjwAph9Oqp23EztDKc3dmnPXpWL4UoC?=
 =?us-ascii?Q?JyssGqoVhSH8lGLKR33PcEpl5pQuPO+udmiIJJgzF/nap67kEHvpVjTL5uQ+?=
 =?us-ascii?Q?jMj7sc+TSOtHDDcnI++GPdjmxzPVok7GUSmO7F5L6GwYWSAqwk/aGb72XuDP?=
 =?us-ascii?Q?qkv3IPPXDp4dQ1cCRhTDbqGqUYB/3sHcRRV/J2mup8aSPSeVdXUyvpiS0/cJ?=
 =?us-ascii?Q?8JO5PKoGxtpbBIcQF6Sze8TAuLv08gVlJrwZBzo/K08aSy1YUfxLIYFlNg2G?=
 =?us-ascii?Q?pP1r+os51rkZVOv1UtIcVgi+cHRgI/MBKAaT4qcCLHsS6/I6+3LNf68AAfSE?=
 =?us-ascii?Q?/xA0qbAANiqDeHcAYjrH2NHd+Bw0kd2fACyCSZh4+NW70AXV8VjFz0cju3NQ?=
 =?us-ascii?Q?nm/lVRY0aF4sD/Q8qX9rpHwW+0sBLVLTAlDYGT8vsXEmnvTcUu9fGns52ZUS?=
 =?us-ascii?Q?JuFXc+bufrbSeuL/qhA+8PakX1uXVnRlofawUG/j?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73509047-0ddf-4d83-eeec-08ddaa7c026f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 13:12:55.4627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K0LJRlMuwFqqemUQ7EUQjdGfcsD03D3X7qHx2Ffw/VnTO42NL7+VTFGfVoGpND7S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6965

On Fri, Jun 13, 2025 at 09:56:44AM +0000, Tian, Kevin wrote:
> pasid_pte_config_nestd():
> 	if (s2_domain->force_snooping)
> 		pasid_set_pgsnp(pte);	
> 
> we either need set it for second level or also check set_pte_snp
> here.

Okay, I'm deleting set_pte_snp, so lets set force_snooping

Thanks,
Jason
