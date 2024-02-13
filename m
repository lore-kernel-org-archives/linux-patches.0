Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2057.outbound.protection.outlook.com [40.107.220.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C003D249F3;
	Tue, 13 Feb 2024 12:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707826742; cv=fail; b=nJIIeKbjRESj3u1eTQKm+fseDW2q6VO2HtEafhymRAsa8HcUlMmdlEFuBunvUs9AUIW15z7EzP3rdYzLC7IHqa8RcbbPn8A5zMizx/L/wOy3BGWj3b3LFuKrwHzAY5L9jLfzJFA/GRWXaTHjnP43Nl5gO62xpInrQUqSVYuzkKE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707826742; c=relaxed/simple;
	bh=+dKgE7WrvmYDdk4tnSxqcsvDm2Tb1bnBg6WKHDMdcOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cmSPOYmnZWeb4M9Un63iYxWAZdbO19SErD/q6YNmVkUZIEQblAax5rtaPKJDJDsCluWxcSpkgnI7QS7PbN8aAJzjjtzITyrrmFbMeLeNRVrJo8sKSmo/JcnJ54cDAhK65rO38T5ZltRz9JS5n/ihLc9mFvykZFM2udlLvJ/giFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Z7M1u1pt; arc=fail smtp.client-ip=40.107.220.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Z7M1u1pt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YqOF78zYtePSJ948S88xpiH4Ptl8001xYKbf/1Qk+zDmFc2yPW8zig6qiA+7eo13+3UfNVMJnFKQwF7BNjR+4BDsKBupvjdgb3SLp0VS9f7f+0La6O1ShyehBTFUs7Mc8idTifTfYAlgI/ECpf2rqT3umRX/n7U1xJUiVGLxDaAsnFH0HVOVwr07hyde2IlLNQUxZaIetn5kA+YG/2chM8Tm+xm/a0qv2j7+2Jy9zwgR1LrBf7lcpKkvbEaC+Yb/9qmAnTJK+0kBYy5j6S01pkbQX1p7+90nyIcs1OU6EVkYEFBI20wfCrWFHMksjDZ8wWO+4PZJ1q/n8e8nWl0rxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sW1BKrDONm7FXM3bODUZ8Sv881dHfTafwqDpm37hq64=;
 b=O/YQe9rF3ced9Ua12UR4m1hzQOH2zuCe5ico9Pk9dPG3UOEaLDxJtVyNEZXS5jJg7LP3eCONSE+Iw4sUNdxd1kod3M4dfJg089I+jAAnVXH+5PSqXJmSwVrNffM9MC/vddtCNIL/OJ/fv7o48Ny4y4dwkLHOWOeg9nUchHn5B/RM3KSMSvPQbI5IeYomUBoaBsLc14KkxqHdCnf12vc00GsXBWSodduE9Qw7F7ZtpJQ99Bz4Ycq2yKPviUfZM13nL5m2P3RDzZowZzU66ga8Pl8ptAdfskS/JaoBEenOO8p46nzju93wnZY/Dn+GZ4Nq4Q+q8Z0mgBO9Uljg2pfYJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sW1BKrDONm7FXM3bODUZ8Sv881dHfTafwqDpm37hq64=;
 b=Z7M1u1ptlpR5AbOITf40TQJ8R5uZtiF3A5an4/EbsQiN/wccR4yfCMNLs0Rq2/qODRINO5x7hRCgb+vWTExsKSMnHEWE1SpAOjoZ2jc48nDmHlO4IffZ2ptKKqXM3zAbs3iBXKNfYbuZRkO0GCk53z1XZ9Vtafx1xJy1r+d6PDz9uNypEiU+jLxm2WO/rb/X0ZW8emZy8uU5xgYXjW5unrmzlL1mFNk1N1vWdRlmG51VZRisrgImtmlOKHR13izT810ai3w49ZchoY42uyFg7xUCsgmK1JKFkAZUv2g6qLHBL485z+2gEPuQCYVR1W2zSJ4qAzx2b2p2rGvkvAJ1xQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB8887.namprd12.prod.outlook.com (2603:10b6:806:386::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.25; Tue, 13 Feb
 2024 12:18:57 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7292.022; Tue, 13 Feb 2024
 12:18:51 +0000
Date: Tue, 13 Feb 2024 08:18:50 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH rc] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as
 spinlock
Message-ID: <20240213121850.GH4048826@nvidia.com>
References: <0-v1-210234560de7+69a-smmu_cd_atomic_jgg@nvidia.com>
 <20240208125846.GA23290@willie-the-truck>
 <20240208142729.GH10476@nvidia.com>
 <20240213112015.GB28517@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240213112015.GB28517@willie-the-truck>
X-ClientProxiedBy: SN1PR12CA0059.namprd12.prod.outlook.com
 (2603:10b6:802:20::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB8887:EE_
X-MS-Office365-Filtering-Correlation-Id: f45ccf9c-0664-4f5d-ab0d-08dc2c8df089
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	m67ZoZB3YOqm/E8haF0IUeKWP+gLBclexdjg5tL0/bBXmWDUfpe1kLZ3UykYi7m1Advj1ZXM7CAWhisXX86BNV4UhmS6/6vzUhIOfQ0a9Dqw8jMpiF3TMA9pss7IWNXQ0ItXDnTwYJo+yN7tUNxElhDXmsa/m+974JMNtOJtqTQlSgWEy54aALAz1K+P/qvfpMI6bhoD0E2IwBJPED+f6bo59hN4s1yfGCFt3txNq3Bqs9bnAjSyXCg4Je7p2f2OFZUwoOo8twi9lGdPZhtFc8nMuzNUiKsgz9i/MSRYqnSHXpYZGu6WDRLxInfar7PAs1yX/nnwOYonyKAaPqPn7/4C3tiqB9J3biC99Bct8dUHhdSZsZJKqaCV4FeAIpnW8rvh88wk58MRZ5BDIHJ/Qiw+E/g207idEcYCZzwjDOtFkKCJjLIQEkleqBCCSWucRCl9b5md5Fz+sd5d5eYcXxhN99dCH0ku529sayOgIZurnzcpcNS91xTyDzDTdgnz0eymogAhu0y7/Y4WD166J9lECt2CHRVThC4CyZr/gSuIWISdPK1wuqSW0Ajx8Ap4
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(136003)(39860400002)(396003)(376002)(230922051799003)(64100799003)(451199024)(1800799012)(186009)(8936002)(4326008)(36756003)(5660300002)(316002)(54906003)(6916009)(66556008)(66946007)(66476007)(4744005)(2906002)(38100700002)(2616005)(6512007)(6506007)(33656002)(86362001)(26005)(1076003)(6486002)(478600001)(8676002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xADV4zi+1zuHaRFcI36XVimV6sK0CfYvOckmP5JKuZ8kRxP2IBulrtYeQCQG?=
 =?us-ascii?Q?AEiGO22i6Z+o2lHcA+QT+qWClpC8HhzNx6zUCKi214aTSzQZ/EHWQidHpw9X?=
 =?us-ascii?Q?rT2uz9JhOSsJnPMcyj3liYXYj1jjySziQapWGAvEARFjK8Ol7N2U0h2y/kBg?=
 =?us-ascii?Q?5Q2G2+lDni6AK6tAP3f0DP+JsuBnnD2dh/6AlD+CcWdhofZgOso9UOkb+Jb3?=
 =?us-ascii?Q?/7LNLJDaCIiQc3790QIWa8Jzp2c5/ZvC/euJJvGD4TyVhIHQzlpuPwNDsJIs?=
 =?us-ascii?Q?dhXk/7oOLJkA0qb3GouFc2uQLzjPLiCZ+y/jfCRhmc1zQ+ob/hNb9W6AwHZ7?=
 =?us-ascii?Q?HiOQGMc1TGRS13Rh+Io3l6CH7KcgET0OEsjFgIo87GaSvgnv4OzZb8pnYDRH?=
 =?us-ascii?Q?A/I2g6Q7akxHQkZhSAQZW0EGwKngsSV4sh4PLPFvm7eiRx3Qf/0dDYdq9Sps?=
 =?us-ascii?Q?VtZVBSQv5lk16ocZHeV6TPShJJQytCMsLx9sJnMeUGTLfDJu3xoXuaINg4WE?=
 =?us-ascii?Q?fZdzsRox7UdZfGMINf0e9tt2kqpIH+KgNiVZbNWbHbw2qrsXWKUfVnwoubjy?=
 =?us-ascii?Q?LWt28+D/HhN6EFQytPUaR/C9JNz1r+60HNsuVkP56Z6Hz/v78Cz1k1nyDnri?=
 =?us-ascii?Q?3AWWlAnNAj3CpTsAY0wgxlGWRdEtRCyHvjrIeN0XnXekzpI+CfCen5FpybV1?=
 =?us-ascii?Q?cYzsXv/8e+igyVPAdz1su9dnoQWYxfbaxfCxInpu4vAupVTpND95cryGJef6?=
 =?us-ascii?Q?8xpCkz6YR1gbUMSYYzFRJgyfDRIaA/avW0x0c0l29EwaGHrV2L4JqaA59l7b?=
 =?us-ascii?Q?O/0UGaZtxslT53l4x2kXCqJ122K2VfhlaivMeY7Nf1X7uyB+aU40k5S8V5y7?=
 =?us-ascii?Q?BtMCBVISGi2ZjPUBSAfCFn/5NMAuqDSYEcQjFDEY184U21Ud2mNP1BLUHrQ/?=
 =?us-ascii?Q?efKblti7zS571e539IIcW4pSm9DSybojHCANmxTSdRPOdEps/i7raxIxlt2W?=
 =?us-ascii?Q?pJsR2G3ptBUoNGmnN98OWIlgkDKZRXWc4g31NAKFMIGikkRZVH1ffk2EVAJi?=
 =?us-ascii?Q?Ouofsg3BlSpnfEtke0TCZAf+CaNuug13oCT93cq6p3BkPXzjHLLRwgAjjnMN?=
 =?us-ascii?Q?BABo4ZOgLAFphNAlsi2AJlA5FnlgtCDlV9idRrmVFrij6aQ/1WUnp9a/Obbh?=
 =?us-ascii?Q?EbpHq5DSYHYR7Hvx50Cmc/uinM6vc/NPMxG8+PfL9B0Uw/athsevU9JCVImu?=
 =?us-ascii?Q?PRrvvZ118EnhNzDtXfGgjd/5GJKlZV/lulPtniB3FqNLCNjyEkXxomXzI6BK?=
 =?us-ascii?Q?+8oPi5NPwLn1rhy69eGeSsAD0sYkJlbpRjnNSFa+u0nZC9IbR6m/ICO4IxDY?=
 =?us-ascii?Q?iAal/WbWlSuPXo7zI0/A33JaKsCRaroQxLn5+X6U2Kt3BHh5950hBT4p/Rwp?=
 =?us-ascii?Q?cePS2DkYh+PrVptHTqcbsFt3zFF+md00RQKlxQB5QMv6b3HiST7VqRyBSXP9?=
 =?us-ascii?Q?sH21wg9XukqOWq2PYzoDGhPFzrSCTR1moCLNAd+k70OchrVH9CZ5ezTWHQdD?=
 =?us-ascii?Q?mw/JAiGbNbuiYYRmbBDnMUFo5HBT2aTbQro3Mhlu?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f45ccf9c-0664-4f5d-ab0d-08dc2c8df089
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2024 12:18:51.8106
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FsdCh690T3NlITwa95nsnWg1ktmhLZ5+y39rPjzeaVib+O2p2/Bi+B8igT5EYK3I
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8887

On Tue, Feb 13, 2024 at 11:20:15AM +0000, Will Deacon wrote:

> Damn, all the surrounding rework has really left this poor code in a bit
> of a state. 

That's one way to describe it. There is a reason it took me so many
patches to align this to the new core APIs :(

> Could you please respin your fix, but with an additional change
> to arm_smmu_mmu_notifier_get() so that it returns an error if there is
> more than one device in the domain, with some of the above in a comment?

Adding a check is not a comprehensive solution, there are still ways
userspace can attack this code with iommufd's coming PASID support. It
certainly doesn't belong in this patch which should be backported.

I can summarize some of these details in a comment for this patch.

Jason
