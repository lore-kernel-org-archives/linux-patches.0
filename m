Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.4
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794406402;
	b=SPWN90brHj5sBKFuMBNsxznSgfMadOM/ZKu3UMYS0YbvT0YJe8t8k6oZnxxvRvfzH0gp
	 D0AFpTDf50QEa4E+Qhgcv3zwGhv4HTo8PqQunXMzZtKydHWp6CyKQrxb0yiH3f5sStr6K
	 Ucp5I0mdV2xjaF4l884Y5ClGV8NoPOQd/VdC6J2wRYI76iTV9GKSLHSasfTyQpYGeot/w
	 0AoHI0MNnUuFFXrHtdxB5bF+aCgxjbHsLGOHyUQBKDD7GCFqBTgbOpxvjpjgEZV1dSclp
	 qgkhshqEJXGe6xA9xUesy9iyNH8K+NCFRhnLLI4AfstSQ4EvLTbcZEfSnspJ8e7SQpQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794406402;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=mnDxtZ9EdqjwOw4kFiLxZKjx8DbuLfTDd9am1Neinpo=;
	b=oynM34FiFT+nevlVM2oxeV2pHJaPdJFeCf9kpY/DiVZZ+r+fDbV9nh1i882134OnSrSm
	 kqZVUkCtzdbbxswH19d4iu9TkLiEH4XgEVrklWinI4kQxfetf/nuPcihPdncelROTRxNZ
	 ZhSIq8CxvInqvu3SYf/fB4L4Y6rGsrE2qqrwhiW+Fghb12qeEIfEzU1j7didYgongpz2z
	 DluWoguqwbTjfB3elwfMy1EkgFBCKFG34IbHAZhehwnlDvavAGLf16JowuAaOjREMVN2/
	 gZxceQLV/GCKLnm9YOTts9J6VYQxXLC74Qm2YA0DFhDW8RM6x6Mgrcx7qFEdvi1c63w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="jB/XPOTK";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.52.4
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011004.outbound.protection.outlook.com [52.101.52.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E486606A32D;
	Wed, 11 Nov 2026 14:13:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E486606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=jB/XPOTK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HRO/JSESOVE9WMeJlIkdGydii1n2KtNV7X4Vxt8TiU1t5v5ICPIdV6t+uHePGlO9g7lzgWX3E5ErFU82/e+3gJkalxwOHkIG+p2KjFTSAe73e+Gco67vPzgrKAsIiMcCA0Wip58LziLmF4O8prL0a+zN1VPcMDeKbItN09uLcKYuwOLSQv13frE4c3ZB4BwZgmHaZYlyKSyC3FNjvhpL7Zin02I5zO8Bmqkxf1qIZGEZhbqJ05KQkZYiTp4eAMXOfynEo1GyeNv/bXqb+Mz1Jh065XF2TUjYAON/PhnyHp9M8VogsCyppekyuddB3Nb/LQQrcfsioiEpZ47tSt6CwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mnDxtZ9EdqjwOw4kFiLxZKjx8DbuLfTDd9am1Neinpo=;
 b=LwA2a5OZ6ZBCSn0P1bo2poVH7ndesF36Wz/nglH42cfRLXea8ngyMUr61YuUEVqVtEzzuiLNe0GzKhEcPopNS/DPJFWMriCrCNCzB4XHBo895CDCUWL+q51vs2Baj6bIlJmNGXRBER5cb+OTZ96Smc+2BPJ7c0AqsA7qnLXRQDfvVYTTfxaWvzIqHFtB5ls36vm61octoC20U7+5Xi6DGD0SF+ULd372KyrRMg44sMm9FT+HdqVjGk8bx5njYAmsd0NoW9PpxPVCDo+bU9j5NvRyooJ4awvePXDrYKNMwnK8W6hHHIEZOL+aFRY+etNRTkimOiTwyKTZguTct0Q0EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mnDxtZ9EdqjwOw4kFiLxZKjx8DbuLfTDd9am1Neinpo=;
 b=jB/XPOTKtt4uTq950MecKkyogJbkKleA5Ym2M+BF321q7sfJ2ifcaFsQ89/9dB85X9zJu4ZGbC1+QMqrdx9DDiGg37cd3L7+M9bybLcOLLB6wv1qr0rf+LhLNr4Vw06c1tNMxkqD4z7j6ZGeknOb/5wDwNjdW2wnD8CXZ3r+UlRLDygVtgodqBMWeakmNtEIeoZTX96l+mjbZ7rug14mbu2RpwtGw4Ly5SjuMNfyT47PUHsB4F6NEV3GRqynOGkWtU16Hc9Cccb/j4cBggykahsRpSJtu1Tc3WPcIYn0ofv7uvPtKOOBkP97NnY2BtQldow6NLZ7/PGi6cVHrHhjxg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS4PR12MB9564.namprd12.prod.outlook.com
 (2603:10b6:8:27e::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Wed, 11 Nov
 2026 14:13:16 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.008; Wed, 11 Nov 2026
 14:13:16 +0000
Date: Wed, 11 Nov 2026 10:13:15 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Jiang, Dave" <dave.jiang@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Message-ID: <20261111141315.GI738765@nvidia.com>
References: <20261106193018.GK770409@nvidia.com>
 <53bc57bf-1ee1-407a-b48b-bc6b2deee12a@intel.com>
 <20261108183337.GL770409@nvidia.com>
 <2b89b830-f1e4-4304-93ee-40287a4b5b2d@intel.com>
 <20261109185315.GS770409@nvidia.com>
 <e1fe8fa5-7bcd-46e3-bfe8-368582304222@intel.com>
 <20261109234032.GT770409@nvidia.com>
 <IA3PR11MB91609724D29DA39CB0AAE25AE7722@IA3PR11MB9160.namprd11.prod.outlook.com>
 <20261110142038.GE738765@nvidia.com>
 <DS4PPFA84FA90FC31803C37BDCA2C11FCFCE7712@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS4PPFA84FA90FC31803C37BDCA2C11FCFCE7712@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT1PR01CA0055.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2e::24) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS4PR12MB9564:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c9a07e1-2b93-4bd0-d28f-08df3ffdedf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|11063799006|5023799004|4143699003|261021121427099003|261022075727099003|261021135927099003|261022105027099003|261021123027099003|261026121527099003|10067099003|261026140227099003|56012099006|261028144727099003|261102123227099003|261009223027099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	sEFYR/+0E1qBSr+9y3sSZG/WrzU0eW2AK5rkjRC603N9Je+7cSIh8wpzEkEik5vrYckoT0h/z1Nh5YTfjId9xcBGGaj3uGkSPHAdmfh4AfVPUrThWc8SrCO7x91aDwIsDHEIBeA0BNlqYhD/SL8rQ50SyPw9YNe5G5n4T1eNHWuXeNslvWiS66keIoxfOS+MpXb6lNDdE8zV/UWEZMpA3yzx5kR2bLcWWLM/0GNSqHS1sUpxUItVw0pHFlzkBKwHwBxM1WoL4hpQyZcal9P82fU0BTepHubUpy1COvhFVUhudjr8UEkP2NDw6YEVF1HHhYcFdauCI7BSX/iPo9HH/AG5bMaWobnZAGCsOL18IPMmd950M7nKKIODCUvpdJa8SmT2fVBAn8TV59/NeNMsqKXLxzCha4gcxroWpIbBZ+xDC3qb2yYVbQD0bjzfNrC3shY4mRmSX0vBc5zIarw5U+86O+PuXWPMOGlbKxHyg82U0m/CLIWrQcIrHN3Tpt/m6PkQ9tDnKXpbCgQM+UUEE+U4/O1LDwF5O9bZJX31FGgzSh8fzBgSFYxGN/yAPxuEKRkekrLbKZgWz24Stu6Abd+AlQQuoKPcst5OmS0xeSxRkI1/eR5WLHtCoBkrcLY5dzIWfHbTklPwi8GN1h86NenFMTQyTYJwGEhdTOUXV3Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(11063799006)(5023799004)(4143699003)(261021121427099003)(261022075727099003)(261021135927099003)(261022105027099003)(261021123027099003)(261026121527099003)(10067099003)(261026140227099003)(56012099006)(261028144727099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k/SiSuDCDdLkS8/0N1pEbfq/gFA5Gkk8tYOTBv/4yyM0MyjUI4zU2Pvykgvh?=
 =?us-ascii?Q?Gn23ddROAtTjXPZB1al8YWeMiN1O1AqDEW1UgGvBb6DYFpQXTkdRPSPahfP1?=
 =?us-ascii?Q?g+5vUze+576t84exp6nPnjGyOsLZUYFxgzrqTx5Rayw8TojvhEr63hdt6nWa?=
 =?us-ascii?Q?z7PZ3vLtlLde5NJEd0egQoiktdYX7kcLfv7alb7xC/HTYJLezOSi8y2wqHTc?=
 =?us-ascii?Q?LI9QHW+LXJbHqpGtMFxCeyLfL9Vp00aztOFnySqS94n/otNHulWEkK/guyc6?=
 =?us-ascii?Q?cWwoc/AWr1LGu+0CFnPWq4kYB88O22RCWxMh2ayEAclh4Csx6UPuJRsaWEcA?=
 =?us-ascii?Q?O0aF4Q90GJGySbiUvoRzzjzq2fXQVv253p4TgbrZnXPT7ERXsBhhAvbpO7BO?=
 =?us-ascii?Q?7Gk5sr9wN36I6z4VOuC/n9Ej62oSZbtp1hzfYnHTeocR/I7hwL/dNR4rHFbP?=
 =?us-ascii?Q?cYdGcot4kJCkynHLrCwdtlijHLOHxu6e7vPHdPTEfYlBBXq3AXHPjlZDqAwj?=
 =?us-ascii?Q?c0MtVUnwZTlEf9wqYe/tO7d9/p/di34X0ZSVGeo+X4OJ3ZpCpARDt3bZLp5a?=
 =?us-ascii?Q?G/inFbx0aFwUtwvo+sxtxBW8SexgX/NWb7dF3Xca/4+lntrRcfyY00cb6vwz?=
 =?us-ascii?Q?FCUe9H82yP6v91sGymy3raUMDqsiquzY0EeDjKGQ1EFwxYnQXE49mdwnSsJv?=
 =?us-ascii?Q?BLeH/T3+VB5jM6K+FsSQCylHt8m7+Ts+r+L/nNNXfyVLXKgpBgXG+UhlmBRd?=
 =?us-ascii?Q?9PWNgDUh3hBP1DoW5z7W3mYx74+WgTgjTpykmF6dng37ohTtsDn/sQqLIoVt?=
 =?us-ascii?Q?ASCj1GDnzpQ7g8r0Z56/uLe0BLrVg0TrvJzvrRfOjSnG9coePDIZTtFk10rQ?=
 =?us-ascii?Q?Erm+4NA3iRmyTNSnfvtyHVTPTyzNxCFpP9ow5FO2FrAWdLbqqXSd/eKcEyJ+?=
 =?us-ascii?Q?dBmXizbpPHJXM96zgLk/kh1VUmm3ST8tvHZVWwKJX6Bw+hYtjSHLYDsYfdxY?=
 =?us-ascii?Q?HJ7mcCu280nXz2LFnL53W+dMNAEIwSNAdYXqTKRp2/DhoRo+QfYmAEpjsiz1?=
 =?us-ascii?Q?VggCUSfL1KkG91SsPU/xqIkRKdX/rCdTyiTaMGr5+ZbqZvSf2jT/yRjAIKaW?=
 =?us-ascii?Q?Gd/NtgN0dWi+LxVOCbUfjJaiUnNWJJD2KzDqJxXDBhbRlLG18e1g+uROg6cM?=
 =?us-ascii?Q?Hzq2HzBsE4FHb93T944JCIsSG2KDZJdT2AZlefma0voJB8iPQ9TQQ71BqJjM?=
 =?us-ascii?Q?pobg265OFG+gqQch7mXKSTZHLK5zFfVTtRmkHKNsdUmSRXq4N3NlxMgOochH?=
 =?us-ascii?Q?HyzXBi8Qao/0wuvpkLtJxi6px9Ye5rdvWNEISSJIM73aSEhV8d/t4gW2OAij?=
 =?us-ascii?Q?VX7C8iYqmYjEKIhPVIGqVKZgvqxq6aIm5pP071Fk1cTM0Jn1HfF67xujcovw?=
 =?us-ascii?Q?6duxOSyq9kMYfQ8Co8ArdBdJSnfKHQyovUlqY5e57bS6P93pxXjA9/RXaiYu?=
 =?us-ascii?Q?u5G2QP6A8ScbWt/k3+Lp2Chgl03pYLPEUQd3maUr3SBNPaN6afpZ5NtsGkb4?=
 =?us-ascii?Q?sPSgrdFCzAvGWKumy6Hl7M3u4g2UC/kfydJOrIdqNfdJcSljzfRCRELjFlSC?=
 =?us-ascii?Q?B8iSaxoB/TS5eZ8aeDOh9JzK0oGPHTN7Ajt2FpGOLthMgJR9to0cdjmwNCYP?=
 =?us-ascii?Q?4uXkjkq/NFBuPcdh95bIecYSuDMCg22rh9DtumXtHgbi6Cwk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c9a07e1-2b93-4bd0-d28f-08df3ffdedf6
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 14:13:16.3282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9RCSnY1bgndLG8u0Gkrb4ZnWUQ4S65yon2P+cPt6x8/4uT2RnxA2ggnWt2N4tzdw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9564

On Wed, Nov 11, 2026 at 01:09:43PM +0000, Reshetova, Elena wrote:
> > 
> > On Tue, Nov 10, 2026 at 01:15:06PM +0000, Reshetova, Elena wrote:
> > >
> > > > On Mon, Nov 09, 2026 at 01:54:57PM -0700, Dave Jiang wrote:
> > > > > > Why? Seems like another wasted operation..
> > > > >
> > > > > The TDX module runs it as part of the connect and with the current
> > > > > module the host can't skip it. I'll discuss with Elena and see if
> > > > > this can be different.
> > > >
> > > > Does it come out anywhere and become visible to the host or guest?
> > >
> > > Yes, it is visible to the host kernel as part of the initially returned
> > > SPDM_DEVICE_ATTESTATION_INFO_T structure. The guest can get the
> > > reference hash of this structure from the TDX Module/TSM.
> > 
> > That's security broken.
> > 
> > The guest must never see a measurement from *before* the guest did
> > LOCKED.
> 
> While I also personally prefer to do measurement checks after LOCK
> (being a security person, you tend to be pessimistic and require strictest), 
> I dont think anything in TDSIP standard says that LOCK formally affects
> measurements. The measurements tell what device/firmware is.
> It is the TDI report that tells it how this particular TDI has
> been configured and locked for assignment.

No, LOCK says the hypervisor can no longer tamper with the device. It
revokes hypervisor access to MMIO registers. Taking a measurement and
then allowing the hypervisor change measured state via MMIO is
entirely security unacceptable.

Exactly how LOCKED works is device specific, but from a security POV
the device must implement LOCKED in a way that excludes a malicious
hypervisor from undetectably tampering with the device.

This is not statement about device firmware integrity, but about the
device *runtime* state.

For example, if the hypervisor tells the device to do a DMA write
after 1 second and then the guest attests and accepts this device
while that command is active, all guest security is lost.

The device's security design is responsible to prevent these kinds of
attacks one way or another. LOCKED is a key part of how the device can
do that.

Broadly there are three device implementation options:
1) A TDISP device MMIO is simply entirely inoperable by hypervisor and
   only works under locked. Trivial
2) Entry to LOCKED cleans the device so it is quieted down enough to
   be safe
3) Measurements record if the hypervisor did anything with the device
   before it was LOCKED.

We cannot know what kind of device we have so the OS must always
collect fresh evidence to support option #3. Or at the very least the
verifier must be aware the evidence is pre-locked and stale.

> Again, you establish a trust in a device at the time of SPDM
> connect.

This only establishes a tunnel to device firmware. It says nothing
about what the device is doing.

The CC locked/measure dance is establishing what the device is doing
at the moment it is allowed to be dma enabled'd.

> Guest can inspect VCA and the cert chain for selected SPDM authentication
> slot that was fixed during SPDM connect and decide whenever it trusts
> this device or not. This decision *might* require to know what are device
> measurements at the time of connect also. This can be needed if guest's
> trust in this device depends on its current measurements, i.e. I trust
> device A with a key B certified by a trusted intermediate C but only if
> its firmware measurement SVN is higher than 12 (because I am aware
> that device manufacturer reported a critical security bug in SVN 11). 
> If all these connect time checks are satisfied, guest can trust the device
> *given that manufacturer specified that runtime downgrades of SVN are
> not allowed* not to downgrade its measurements between SPDM connect
> and LOCK, moreover it can trust the device not to downgrade measurements
> while it stays alive (and while corresponding SPDM session stays alive). 
> So, the fact that SPDM session stays alive in this case would also guarantee
> security.

> Do you see the logic in this reasoning? 

IMHO you have focused too much on the device firmware state and not
enough on the runtime state and the impacts the host can have over the
device while its MMIO is under the control of the hypervisor.
 
> > The entire security argument of the guest is that it locks the device
> > so the host cannot tamper with it. Collects a post-lock measurement to
> > show what state it is in after locking, then makes a policy decision.
> 
> Formally measurements of the device can change even after LOCK if you
> dont explicitly forbid this via LOCK_REQUEST flags.

Yes, but this is something else entirely. We told the device it is
LOCKED so it activates all its defenses against hypervisor
tampering. We take a clean measurement to prove the hypervisor hasn't
left anything behind in the run time state. Now we trust the device
itself to only alow measurment changes that meet its own security
model and the hypervisor cannot interfere. (bugs excluded)

> > Capturing a measurement at SPDM session startup, while in unlocked, and
> > then using TDX module to trick the guest into accepting it as a
> > post-locked measurement is *entirely* unacceptable and I will oppose
> > anything like that in Linux.
> 
> There is no tricking, it is specified in TDX that these measurements are for 
> SPDM.Connect time and not after LOCK. And if you want to have later
> measurements, then you must use recollection functionality. 

I'm am feeling against even exposing early unlocked measurements to
userspace, given how dangerous it could be to ever rely on them.

> > The guest must be able to affimitively say that a fresh measurement
> > was collected after locked and when it gets the reference hash it
> > needs to know it is fresh after locking.
> 
> If it wants this, then it must do recollection and we provide this
> functionality. What is missing from this currently is TDX module does
> not refresh the reference hash because the assumption currently
> is that the same key must be used to sign recollection measurements
> that was seen during SPDM connect (and protected by a reference
> hash).

I pointed this out already, this is obviously very bad. Loosing the
direct binding to the SPDM session is a significant security
degradation compared to every other architecture for no purpose.

Updating the digest means that the guest nonce ends up being captured
by the hypervisor and presented to the next VM as the 'initial'
connection measurement. This does not seem like a good choice to me.

ARM's VM boot time mode selection of 'TSM controls nonce' or 'guest
controls nonce' works better, IMHO.

But two digests 'initial' and 'latest this guest collected' might be
the better option.

Jason
