Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012033.outbound.protection.outlook.com [40.107.209.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C3E2FB08C;
	Mon, 19 Jan 2026 23:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768866023; cv=fail; b=NTwBFcS3MffNm6NJbPKjevJ7JDH0cFyrh8S4+rWVzjEbF0FAlRj7uXrxHdVNNgO1T6Nl7rB5FkbaeDh4VmCm5sZmrQmJ2uvyI3wh031OtPDTJxkIq+n73W+Tj33c2vbl8nBbWXwa+6z/06Lq+s0qRZ9jaXJP40e8jFI/jWob2Js=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768866023; c=relaxed/simple;
	bh=EOslbJrZdhQ6Nq4u88H7oHnQfF3169BDrereL5ZpYdw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=W8IojdDVjtDpiJ7mfw7DWtS0OmViR6t5evxng4hIqomhZnTFLE9y/pXWwtDGGTcn6Xpgmg+hOflR18FOF19B5ECjmHLvRzs5TxMQJx5PsjZ/SILKj3tEpxv8hu3wNqrkKlQpIHJL/l6LhDVsToez47IDykn4bDex76NE8h94Sgk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EzUifwIm; arc=fail smtp.client-ip=40.107.209.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EzUifwIm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MCtll1oTZQRptsrpQVYbu2ZPfnNAbjVD2OfD4GF7vn0jfeAMN0H4EGHzo56b9ZzwNsBiH1/WzmBLQ5VDiDvl8SdExKcWmDfcDYf4QhBvjJj9rzkfVmM0rLrjKz9mCNL1Qu9f/y0YQ52N3F+jvFWuCihOXr8Q/nBZ+tbcnZmqejnwS7IccbtcAAF3xFMn/nvo1A/I6NfBlYthvK17zFKls6+vjyP0A8OMKHb00/FmkAQX8S08rD1SGiOhDmsbKXkiVNNyk3oXhXIRlQB0q1j+rSomWc4VwkcYIY2vdP+Z9dTkjDjwYipEID9CfOTH0uBLDjp1e+1P6mPjEfxhAplxOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=74iUgpd8dl3A9tM5n/w+uieGZrY20sPePKD7GjpNj+k=;
 b=EdzXz78rNLc/jsu0cekuu0SHUWHB2HcH9vTaF+91a1NKbN0eOOhr0sfgxHoCEKlnaf218ie0Z2EKU2ko77cHuNLF8ptTAiSswsWmZN0ZYF3p8BtuJNbheffAW5u7F9w/n9umC+Y1uz9xzjmYVOLJghIRB3TSmSJRXN3CYsUeeOP23au7j7giVR2IOtQr1axb6dXJV6uIlorFXfWSGSM306/FiEFnCLbP1afxGJ1GNQHaPxHD6NVMbEHxaO5467MDTz1M/Xx5D7yhI3i09fUXsD/dDUYa/tV7fdFBoTzLjpLuofP5VS9zEAh4AE7/0SQRZh9rJNAMO0460pHUQZ5JSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=74iUgpd8dl3A9tM5n/w+uieGZrY20sPePKD7GjpNj+k=;
 b=EzUifwImmmYedrmkZnYfbhh+BinI2gbMU0c32t9HHFXz/jwD56rKHxLUF2rfd6cD5eHO/NXHOMHlGvW9+jUk7zOjLbiUruJ4Tfy2ITNJBPLctH6wjuLsdW9ephiLzbErZmNZLSJ+YbF0qoZPtw7PU9lo74Eob+G2VmsPySbgnO4yHZ39ndgEw/lOPuqgQUKxJ+qs17UYVwGwPvWdBYz9EfBWDZED6Lr4ImgGof4Ilelbb79khFJoXksb2nXQ97CTZ58IAVb3hAF4V7t1gNvO5IjarNqwO3xd7SVq3WhMkFwAzHfAZYwR7HuQd3Wb8vzilIcoude6FnUf00iQS72H0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM4PR12MB5940.namprd12.prod.outlook.com (2603:10b6:8:6b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Mon, 19 Jan
 2026 23:40:16 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9520.011; Mon, 19 Jan 2026
 23:40:16 +0000
Date: Mon, 19 Jan 2026 19:40:15 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev
Subject: Re: [PATCH 3/3] iommupt: Avoid rewalking during map
Message-ID: <20260119234015.GW1134360@nvidia.com>
References: <0-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
 <3-v1-d7be57da596d+3f8c0-iommpt_map_direct_jgg@nvidia.com>
 <CAAywjhR_Jh5K8VgLWFxvXwn66bV3vdmuxGN_OKh18Xoxb_NT6A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAywjhR_Jh5K8VgLWFxvXwn66bV3vdmuxGN_OKh18Xoxb_NT6A@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0255.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::20) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM4PR12MB5940:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f0891ea-6bbc-443a-2479-08de57b41927
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0/QscNFlPyENpXFNt96p9V1PHXSx4UgYvm+zywRhH4e2MCEVChZ0dRBEjLYh?=
 =?us-ascii?Q?JenbAY3ERPOxmglckTu8Hb71Q63VFgn4739BtVdWitMKfex4iHE7lP4sjWyC?=
 =?us-ascii?Q?HdwBdUeXRnB50zbuAWaXd0kbVnNvjQDinRkuB6S0nvgpItFkG+a9fdTxeGs5?=
 =?us-ascii?Q?ndyGqiJSrWIt60zZLHoBW4xlkkAIffMvyypRJXLt0k1j3Xw+z766r9E3+nA6?=
 =?us-ascii?Q?Oa3zqO/mfxhde4XzXeNmCbB4A1MAOQFpfGdPFRzR8WvEcjwfVz1t0+L3dil2?=
 =?us-ascii?Q?1SF+4oDfX4WWyxnIf6ZV3Gssi9u/RNp9uCqgd+j7UjVuf/IwBNZHJWbJfGlf?=
 =?us-ascii?Q?BhmMPs3+xXVRBWyoI/WFZAhjVF3yVN5TzmDhQAeO1gxHmKIL1Xx7364ZRM2V?=
 =?us-ascii?Q?eqeZ6e5t6KTO3aDrqaONgOqKoUulIBYAjsOaS0F3sNHBum8xCLBBDmfMe6RC?=
 =?us-ascii?Q?ILR1A/VcHVSrnQDIdFaSoUcpY+u9/HFeG3tI6kY+vvcGtYJo2wP8tH3EZ3/T?=
 =?us-ascii?Q?UyKCv58PEFzthPH9fIUm8G63vr09hevmWv1LPF0oFaWPQ7nPdSrQmUWCLrCb?=
 =?us-ascii?Q?LYRw6LBf99hVJPcnepSwWpYck65Cxpdlxx17J9Rr74a1TM0cqhlG2qch/k/c?=
 =?us-ascii?Q?Pl1McCuVHGooy7v61nPgLc4NZe4rak4UbgQmnLTGXOzvHHOlw+1X/bpi5EBa?=
 =?us-ascii?Q?A9wwX27yBg5ydoYS9FvZNU3wEi1ElmkhXY4ImEs1UrIFhTosu3nWQLTg6cdb?=
 =?us-ascii?Q?MxyxDIE7OHveS7lwZobetqiZg+O/c/kNwj5Xd2apJ2nHqDtcZ1Pjbz4Rp42G?=
 =?us-ascii?Q?LzYLcvaMKFIJayrIeyXpBax5GyVTtGUp9rBg2F/64wQtSJ8Wp/zTu69OsxCO?=
 =?us-ascii?Q?WjXbBlOEmAcmrs0BqMmmq2E3X5yTRX2i/kU+TbSL0T7o3B/JhQDwJOKPZ7Ay?=
 =?us-ascii?Q?E2WyZldLHYejVU6YSeYXRI+hbZbg2KSUIl6V2kt43B5pJzoUVUETZ2fzyS7w?=
 =?us-ascii?Q?AL358ZoyR5IbWBrNnlj9oNEH7A2YJIBhMcqG/LOpeFPJ+6k8S0d9OVPK34m8?=
 =?us-ascii?Q?JpnXIpIgencazIRtNJo0QYlfEO5LfjgmzfbkDLFBGHaqRJ9E/yEFLmiqk1E5?=
 =?us-ascii?Q?7IGUN6vygE8KuR5F9j4F44cu3evpEbW/jqyUay7XtX9s7+jge8xLuzB9LQq0?=
 =?us-ascii?Q?MH45Z/OfMsc8huFh6ZxO1HCmFmGfoOpEXJjbnWlgfaaPTuOrPkDsdewGUE4h?=
 =?us-ascii?Q?eVuc/slw/ziJOO8CmT0YiMR4WX3zNBQjhaGmP72KRC5X297sm2k8Maw5Qd5Q?=
 =?us-ascii?Q?KAqViKE/m1g5ewsslKhooXMnOaut8KnmmfMzbuJ9sx1nk0YubA5DsDo8Qh8X?=
 =?us-ascii?Q?j+9fi2hYKsLt1Moxw//AoAnzDxF6iJ1Agh0d51A9SZMS6IVG3+1p02+/fXWT?=
 =?us-ascii?Q?PpBAQpeKENRW1ZgWMgfxBO2ItXr8dTqEzoSEQvQBYlN9giWKzgkzEGW75cmZ?=
 =?us-ascii?Q?eS/yDnD/rr41sv8yqij60bxTINhxsX9dKQ7I1F9zaXUSFOVt0IVIRHFTk2lZ?=
 =?us-ascii?Q?rKPHa/a1PbNqo/eWtPM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?28ltjaqf1SXkMMr2+XgvuICq+CFVKKttN8QcXka3SAEJ5DNH2BWxh//jdBv/?=
 =?us-ascii?Q?x8a/gIBFkQV19TsruBgnkWiqlz778WNkHRPJrtydu6bPVXgEs5MfAtl3LE/4?=
 =?us-ascii?Q?NpCb118pvG7WuaGGafRmLlTOfNlTTgk0K3Ef2gaJJREcjtIKkG1qM1tDRfdA?=
 =?us-ascii?Q?CltRVFUM7RDxIe+cP92NZo3mkGKrT5oC3ihCKw1xALoc4CQ/hURFILb7Y8js?=
 =?us-ascii?Q?Vg+F26/AGgYzLMw9V4r4u+//XeQ6fZP2qQULWC8K3QI+DR44BUSxNIMzxZGu?=
 =?us-ascii?Q?G29XIQayUBzeD0FkB+3rSaflxvB9a3Z7QMwm5SOSSaf1WzWzaKRj7vg8HXEh?=
 =?us-ascii?Q?+EbKaCITLy8VabcudoEKpzc+l/RKeFEY0KfNXPjsE5L+kZME3Oj7ZYMVEIhB?=
 =?us-ascii?Q?CF0EqfcNQjO6QAaylu04cbTglC+7vvYr1N8//82/vwskNfQYDinENqz4Xuy9?=
 =?us-ascii?Q?ffymL/eijIDLkAlV/PA16VZ9o/ZZXP193J4Bx0379nlSV5sc40jRrC9oFCvF?=
 =?us-ascii?Q?LvbXz0CAqFc6M0sL/wOVq66JBw+8Cr+Uj9K6QUH0GkLMYUz9E/JoBnWs+boH?=
 =?us-ascii?Q?9ZB0xxii/elh/uh5T8VhZeQHB7JG56f2QiSGU/d/pRpRUnpbrk5ZhgqIdxcN?=
 =?us-ascii?Q?KXS2XBmD9CgoGxQ6XBesiNgi8kT0OCYr5MtjPTksEs3d2OwCcMvH90GqVvYZ?=
 =?us-ascii?Q?hGdrjErNTRh5hgWE4uZq3pf4gEEYSpmEC7rJWybcy19yTM4PP9c8ZIa22CJV?=
 =?us-ascii?Q?2VYf27nQT0phFoHi7ciMvP3bfuDKaq8uEkcKetF0UaETQqE4XrDnCRIAi3Yw?=
 =?us-ascii?Q?KE6qlMHiYB/K4rgKQDwWNZzfTVd9Cw+lgglaAH5821Ik/a8vMReGwpS4dHnB?=
 =?us-ascii?Q?UqKBhbnCnzxGHjoSYtnBxfBa2f5YI7isBgsX1c9VdN26zGPfAukWy2LMhYaW?=
 =?us-ascii?Q?LH8MRCQ7sepbvOm7QkybX168tfKeUqHL5Okfvsx1QersH482Y8VprtPkDXuj?=
 =?us-ascii?Q?CfOYkebIFMvRpDdLkygfjV4FhdMlvef7cW+SlL/LDUdk0RLvFJw1VCXMERW8?=
 =?us-ascii?Q?HlDieRIp2SiDFbDrQwlQlfyMVAdi5MjdmjtG9iRyy8WNtF3VkV3W7HEaApxk?=
 =?us-ascii?Q?sDX+UjGf8Rjp1Qzj978ZXcNnB+P4H13xGBK8APPnkls+YIQAjm3wS+m3Td2S?=
 =?us-ascii?Q?bM3H+N8YAxMpE9TXqAdM4ZrvLqBTXhJb1pl+P4NtlhH35NRPKMsYqVQ8eLKq?=
 =?us-ascii?Q?ZrFibWESKpLEIDGEbkW8/JKOb3OyajzVwxoyZql5Wfsz3kMaT1ZpJ3zepN+T?=
 =?us-ascii?Q?4QDJAg1xt6KEm9Yt4/HuYwKaOHaLlbqd/XCQUgjA28g0kOAUnV9jUoQMa6Qa?=
 =?us-ascii?Q?qBGL/QPl2Pe46DZzzObSZF9OVwTYlPaGyFtSofIG+7T8zbW3WFMbh1lExXNu?=
 =?us-ascii?Q?zJj/mHn6RQK2S+chDkWSvguCnfypNj5j9kRt+5f6BdcNe0qlZlw+pkDlSCsv?=
 =?us-ascii?Q?JAW7uXCaOXGCidw0j6MAfLNE/8rV31voZDykU7tq0hBM+IjWRToByxuN/C71?=
 =?us-ascii?Q?2j5kj5LkTvBeYaO6777XntjggcaJL9kKGkWGspxWuGR0Nnm74S2vJNMfZYph?=
 =?us-ascii?Q?d055t1Sn9QrwUhjkoNBKK4qqLFJCgcBYc0SyXN8BSoa2GRrzGEsDF6sKEqZ6?=
 =?us-ascii?Q?afTfYZ/RGbWQBWnrifXQ8lCW1XPAvClkTy8QXGZ7tyGILIMY5RvOH8Wl+1d/?=
 =?us-ascii?Q?D37FadM1ew=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f0891ea-6bbc-443a-2479-08de57b41927
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 23:40:16.2519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uoblA/OE1KEmk3RiMpUy6uS35uwnJJxZtJoTsD1RAwvD+SIQyKY+HWphd7kBpF13
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5940

On Wed, Jan 14, 2026 at 08:12:50PM -0800, Samiullah Khawaja wrote:

> > @@ -627,6 +671,8 @@ static int __map_range(struct pt_range *range, void *arg, unsigned int level,
> >                 pt_index_to_va(&pts);
> >                 if (pts.index >= pts.end_index)
> >                         break;
> > +               if (map->leaf_level == level)
> > +                       return -EAGAIN;
> 
> Could you please add a comment here. Maybe something that says that a
> level switch happened and the caller needs to retry?

		/*
		 * This level is currently running __map_range_leaf() which is
		 * not correct if the target level has been updated to this
		 * level. Have the caller invoke __map_range_leaf.
		 */
		if (map->leaf_level == level)
			return -EAGAIN;

Thanks,
Jason
