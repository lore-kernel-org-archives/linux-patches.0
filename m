Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2085.outbound.protection.outlook.com [40.107.212.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36D043AD6;
	Tue, 13 Feb 2024 13:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707831052; cv=fail; b=cCST5otl2JG5YLDpzkRT68ZpL4HwwbrOmYWL+Y2uJAGZNZ7ZfA0mlYDCCwrBJ+fFiCKax45neKt8fE5WVrHjDsQM27hRgXwpQg87owjGnlpVSlzYTSL7qpaatQhPtMS146w32wGsoD4As3ikC3StOTVKB8m0dzTsKlwUSiC4Ao4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707831052; c=relaxed/simple;
	bh=Ie5dAn3ZsqwFYsDS34cfqVh9mQxBMybz5eFHE7Sp/co=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NlBcyqQJfEo3+OpFzehzWSrPw8fHFzar2UTGJiEmmRNws94pRw7FtAwWenX62k3Y/qancZpDlGTNeNc6Q0Ums42grhFoNpNCdtlsDY5pfS8Pok97SitV/qxtZ3qB+PPE9aM7zJiMlbhuu/YhwtyeGkJWcFROXhHpY+Kx/qtKXTI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JZw/8Wcy; arc=fail smtp.client-ip=40.107.212.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JZw/8Wcy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QnxAn/Dp+q/BFLdbwF2EIkmQoM8N0itvC9JJbv0+RZBCd6DKo3fxcPj0Kn7gmAOqm3spRlg7yBHUqn0ZJiZTNMbBKyrAXahVxJuwa1Ip5mxw9yOfLmZQgPsiJTaMyMNZIveqTBOgAeffGsHTbresF8QeFyuhmbM58TaD+C5AmHqYqrbEAz0f3A224kRU5nuVNzQH0QSD4DYhT9PLYefgYGykLQOuTCWP9xRn5oCgQN9lFMe3ugdgJcdRDKGJu/Jw80/8geBUaIXikNw7N7+D4stLlJuidc1d6uB+lLzM+cZD9yx6jjnJQrKrKaOKzawUAXB5C7M7902cRTZoBAAh7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zwM/0/WU+SBzlcT+djiDbci+/U8gHIbyeRxGCk6edfM=;
 b=b2PZhzj5eDBb9Fiiq9f1a+oTwqkJ4PNHzcs44hFBT0WsE/WiOPuZQzLbYHVqvao71zh5IBQE5B5qwoxzEn53rMIkHea9COShJydTr5f3qq/gc3G/h8bfKcv6cNgwmOlsMB0YnF25z9rd7K+68Tv58H4hxksfJQZgbS0K+8UBA95v62Kl0d1TIdW2KWCABSJLP+YUX5Vk6iDxPd1hQadcae8YdM4qlxseoBYxlN/0APmR9+61Mefz+MMKVYFzWIqXPFg/Y89pDCwByhpX4wR8LEFBNFn5/bq0VRYspYt8loOopXFGg0k+ntjpfV33KmHyItfIk/rPM3w+B0+oMhSFpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwM/0/WU+SBzlcT+djiDbci+/U8gHIbyeRxGCk6edfM=;
 b=JZw/8WcyJ6A5pAlT7lOdJfBspGYVQFENdkQPiDDrZv0+hAoHoM9FXgMiLrKzGZF2oGvFS5Ztl2BmrrXySPh2RdYz5nUPqR4wjnhe5EOjpLg+QwCKAVG9yue2BIen6SsYwgabx0xbG3fqdK5aQXOOg2iJaXSMK+e71kZiW4Y0pRlcBhlVhpAIreQvTGdj9+snd0pJS4TQgisSFsSpY2zZMb7njW25Brzg847tB0wj0OWgrD5nXYaHbgg7PEalszgyfegW/184H9C6hdSSpszOd7g7udzyL0vQQqeifSQoUROaOFZMl2TYdoaDTLWncqhzdc0fb3g4Jy+yke42bn6B3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7257.namprd12.prod.outlook.com (2603:10b6:510:205::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.14; Tue, 13 Feb
 2024 13:30:47 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7292.022; Tue, 13 Feb 2024
 13:30:47 +0000
Date: Tue, 13 Feb 2024 09:30:45 -0400
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
Message-ID: <20240213133045.GA989297@nvidia.com>
References: <0-v1-210234560de7+69a-smmu_cd_atomic_jgg@nvidia.com>
 <20240208125846.GA23290@willie-the-truck>
 <20240208142729.GH10476@nvidia.com>
 <20240213112015.GB28517@willie-the-truck>
 <20240213121850.GH4048826@nvidia.com>
 <20240213125456.GA28844@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240213125456.GA28844@willie-the-truck>
X-ClientProxiedBy: SN6PR16CA0038.namprd16.prod.outlook.com
 (2603:10b6:805:ca::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7257:EE_
X-MS-Office365-Filtering-Correlation-Id: aedf4c9b-7e62-4f51-9755-08dc2c97fc9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aWAbQBrkirKW74J8t2I29XFN6zcbdkF0S7jLwASCQudGvRRRNevLpNuGgadc+AZq+frasLM5jd4kkTDFK1N3h82SE7T0qllZpyPORvN14DMbVbt248JUt/vzRcC3TOmHcUIriTQ0dy019xNQypgQ5W2nQP7juiNYps3QuVrlqyTsYY94GgV0h0fXTf58UmcMBZSAsRHCodNHuLWLR1lwYCQPgkwnMZ3kLa0dRQnfBMHOFuMmK1qxkVx0J2qQA/BEKMw2tfjiHg4+UB/P/QceCTr7uaKQhV9vYg5GpuV9UPeyuc1QRW3+olU1DQPXwvRZi2LPqY2TESgbvOADkMcCgEnoc7VKaTT92IQ2jUrL5N54ew+zqpAzGsyM6lPbx4WOkfdQXPXgG0SWokckpGD3r/JFDSW6RMNzHRciuVSZpO8tjbfJzh6bj0h51FSGtZedkw5Sj7HirHxUyg+sh2zoa2+ZWLkd5sMH+hsHKgaVne/eY8GdG6YbMGxavkcJrb/+kULJMe3RczpeU1MIc1CX8qrEtontY84XAU7bq1ELpq6ReJvDBwxUqfCKKR9/QRwQ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(376002)(346002)(136003)(39860400002)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(36756003)(33656002)(4326008)(66556008)(2616005)(6506007)(6486002)(2906002)(478600001)(6512007)(26005)(1076003)(5660300002)(66476007)(66946007)(8936002)(316002)(54906003)(38100700002)(6916009)(8676002)(83380400001)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WZ89lUfrZoOWZCDO4hwkRzlj8Wy8AZ35Cw5kSYbANM2cw+VzE2ks/L4wXhQD?=
 =?us-ascii?Q?7bUdFoy086JlwCO2XAtpGjsKM6js5jO8uAha7YzrAPY0dnoE4tRdmwJnJD26?=
 =?us-ascii?Q?70HinyIJg+8xymAA6PoOVWIDP67oIwqvuVAF99Pyno/guGZoEK59y5LY6+sZ?=
 =?us-ascii?Q?BD4YbofbpwE5HGKbRJMkBqvHAGEFgKkXpUuS+pUGabLykkAHJH5OzLdOuku4?=
 =?us-ascii?Q?GuFVIVE0B8W75o+X90qNDCi086uUci+pzvKBm4OEWfucowIyz46XeAPgL6bf?=
 =?us-ascii?Q?ewfNgijWf0H1aYwLXYJ8YGW30kkHtU7o6zHItl98w5MxDgwheLvrBNlZM5+r?=
 =?us-ascii?Q?9Fv0OWMFm8RsFAJPzHUfb7WnSafFsU5RelE9kHl12ZY6sDN4AL2X9U24kaMq?=
 =?us-ascii?Q?gaT5T60zvfeRhA9gsUQJ9FosNPxN20mGXqHgZ1NiBnILeOUdgkgWugCldszR?=
 =?us-ascii?Q?bZL/wjL3zY/zO9Fz+2AEDtMpWtmIG8XKSbrUUzhFthpfJYgj7o3gt06nYcxI?=
 =?us-ascii?Q?ivRNNvvzEo8TV52lYu3Np+xln1A5RUQFQDcQwuUJj4RsvCRBCfRgWTO0BVbs?=
 =?us-ascii?Q?eEbQxrAhimtw7gIbLKojozadSlxYhyfDWrxIXMfi9iFoNBvjolOQnDUU5iS4?=
 =?us-ascii?Q?HB/U6n8L+YhnO9LeqPdbjfbfNf0qYYadu86cK4WWKiTuBRIqYS3D80LuKAE2?=
 =?us-ascii?Q?vIANYTEbkOdlv60LhuFgTsJozgTAVrHfd1EnKLnciuZqD16ONvKjo0Jnoj5Q?=
 =?us-ascii?Q?MQ/bKHycnYQFo4z4LZHaYuLfceu0qcZ5qRqibTMHE8rsyLF6MGjc2/R4iRWv?=
 =?us-ascii?Q?sGN5c7GKVvQUOliBUkJ36mnEZbVe+i1+yqo1+RXV7oy/0yCQgM0Th1L/9hhn?=
 =?us-ascii?Q?9miW25DCLigz28wQxdoPXw725GKmQ06mz9/PDZF+QivnUFOq3L7If0X54yZv?=
 =?us-ascii?Q?CHrMgCq+I3WV/czHcIaSeNJzLyrCTLDdSv2EmV1g4BDFuIO+Z3fHC6Lyhlr+?=
 =?us-ascii?Q?bs3ywh8Cgx6gt+L3RmGhPZNBm6yZuqVf0r5CIdPRQ7x8dFAJZf5BKiIZZkJU?=
 =?us-ascii?Q?NhOxkeF0P7YVKrknN/WcN5UJ6Rjmjibo7cPWZRdUrhqUiuRAzNZB8lFvfPXc?=
 =?us-ascii?Q?2R/ZOX6yveKNXgI/LAaPxWMg/iSu/dnt0anTB9s0VD3UntLkWpPziBDaSHMF?=
 =?us-ascii?Q?BQvh7VpUT2rkNrCu8nJqSIqsOKKp+T4LoiDxWQPQRkkUW3rtOjcWCW/1z417?=
 =?us-ascii?Q?XQz+xDOJ69HXEp6uYJa/hnfhFVM2Zk4Fyc7WoQQoREoWKfbyLqAux8d/sRx9?=
 =?us-ascii?Q?ITr34YXXyQL6jGBkE/4Yv/keMPeW8z2MCX8fq4HGRZ4+b/AUgeCSh4GXFTfH?=
 =?us-ascii?Q?D88e5LqKplrdiBN/Ln2LNCzaoI6YoKMKxCHQ/GA9t9AwZAMboekQAVCQ75tQ?=
 =?us-ascii?Q?TkzWrI/nkzFKwHBofng+z/SkWyLzbh85r3KB8vol0YcL8aw6DS+fZ1W0sV12?=
 =?us-ascii?Q?+N6K/PmvWp1ymb3FI0ku+i646uDi8ecNQlH4IsBk3TUvGWL9ga8NiOC8RvgZ?=
 =?us-ascii?Q?I38R3zC1Nc8mIHqgiINkQMp2HF/7xWS40lr+wkuI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aedf4c9b-7e62-4f51-9755-08dc2c97fc9b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2024 13:30:47.0570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UAtsW1Tpt0ayb9jSAjHLuGm9hdSzX2bKG5KMNO5Wky4ebQo65AGh4l7UB2SqvHNK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7257

On Tue, Feb 13, 2024 at 12:54:56PM +0000, Will Deacon wrote:
> > Adding a check is not a comprehensive solution, there are still ways
> > userspace can attack this code with iommufd's coming PASID support. It
> > certainly doesn't belong in this patch which should be backported.
> 
> Ok, then how about avoiding the allocation entirely once the lock is
> held?

We need to allocate because we can't assume anything already made the
CD leaf present. Do you mean to do this additionally to this patch?

There are several places where a noalloc CD behavior would be useful,
I'd be fine to add that as part of this patch to protect the loop.

> > I can summarize some of these details in a comment for this patch.
>
> Alternatively, we can just revert the offending commits if we're not able
> to agree on a simple fix for now. I'd prefer to avoid that though.

I feel we are not aligned here. We are trying to get the driver to
work properly with iommufd and expose all the HW features. This has
been fixed comprehensively and well-reviewed patches have been on the
list for 7 months now. We want to move forward, not revert things.

Jason
