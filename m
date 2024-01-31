Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2061.outbound.protection.outlook.com [40.107.220.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60AA84A42;
	Wed, 31 Jan 2024 14:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706712025; cv=fail; b=f84BUUloIGx+lVhBRtj2RzeWE1i/OAEJtSpSMBmcot5h4BCFEhhAj6JfonlLLpupqR1g8naqsfWZshSihyBmhIY/svmKrL2VSnmbuU9miB+PcoLVjVQmvCy6aaY33hTFgBb3bi8fm4K9zaMZyuWZBakRQuB7HBe4x8pqyJ6IFt4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706712025; c=relaxed/simple;
	bh=1Fq3VL3YPxMm5zxCMSl+RkGLcVRhIWgP3vg6VYaEGhk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ndxWRrAVSiz9XiQnfWkUgtZEUVh1O81bkc+rFkb16jUGxD6pBN66XSsKTfM7Sif1BYBlaLFFqmFQdGCYra07qkMMk8W+GeL8lFpqxXQIakKnk+ydIVn5zVGTzbHb8gGd2ADJen2PkmoipUXxdRmI6TRLKPTZnHU/a/qWnWvd3j0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=R6wrNx1B; arc=fail smtp.client-ip=40.107.220.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="R6wrNx1B"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bM4HrHrllkYxn+ZqRjm7u+fjSaFVgbZBHEBlx2qkUurLnn869t27uc73M774vYncbq+2QVAklWOy587cR4CVR1insrYl5f6LVwl8TPgCLPxKGUd2WariN/KDoIcYmoqJ3en4v7GS0vM9V743BNEhL5QG+3mYjot0Zcj5y7nnkpeRC1SXYpUjiKnGUOySeIIw0Ioi07JTvfu7krpV3d9jISZnSZdy4JPukQENHmwI3DUzSin3i54rBX1piWKU/7DKRVw4/8HDuZa+JpKsICDmhoaHOmLsfFQQ3e18XiKUR7TE747cX3CcRTPq7RifIhSy42Tkg1sn2r9YtFL0BYam3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Fq3VL3YPxMm5zxCMSl+RkGLcVRhIWgP3vg6VYaEGhk=;
 b=HK9w38036EeHrgCdU4bEm/XOdOs4m2MsYNUBeA9lRvltTvVZXL4Uhl4aTA9ia1pk8epNfxzhizzt/UX2wmYggx0NYHGI7fJqQsjK0QKiZHu4HSXwn2R0nfGY521qYSLr8wlGM+O6sXojmE4ScPJ/kdYNVSINoVpes3J9/za2qNgdwnVqnb42yNRox9sf3Gz2HgTuNX6a2uAgOi39kdBWrmvp2MyF/yOGmJtazbvmzp4nlsnouWeoVf0aILV+MH7o26xy7G1yBtia2377HUC6rucabDsU+dmCqSXBM2ER4s+k/0pFza7Ix7ji9X8To+sYUljEYURdM7alFHz3OAicbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Fq3VL3YPxMm5zxCMSl+RkGLcVRhIWgP3vg6VYaEGhk=;
 b=R6wrNx1Bp9gbgx+9XK1WmmmXcZqh5d/5+Cn1MpgPARsDeXo4qGFcY2Bsx/I4Ei1Eza/Omx3c0QvyLqESzOw1/DV7leAL42QkxCX2OYGtVTOpfwHXQ6SNWxeDIV5N2XlRNyCpeDUHM4uELTKS1PldUiBmY0VsilKiHa7xPd4NRyvWb627z0wa5yIEMd/nJSeynCByrAMhY1GkFq1BRon0j/1aIwPw72V1oonyGVLFDq5k4SoLXEKiwu2w4Igr/+c5jep+FLD4Xzwa4UqdULmex5nRYsAQirJ7IdBfVkQzNckQzWSGwLOc+TrXzzEvEsvlEHMYP7hv/rthe1JFZSSx7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6854.namprd12.prod.outlook.com (2603:10b6:a03:47c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Wed, 31 Jan
 2024 14:40:20 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.029; Wed, 31 Jan 2024
 14:40:20 +0000
Date: Wed, 31 Jan 2024 10:40:19 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v4 01/16] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
Message-ID: <20240131144019.GI1455070@nvidia.com>
References: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <1-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <Zbl7RQwOGPebvv_0@google.com>
 <20240130235611.GF1455070@nvidia.com>
 <Zbpab0NoE2mKBnUc@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zbpab0NoE2mKBnUc@google.com>
X-ClientProxiedBy: BLAPR03CA0116.namprd03.prod.outlook.com
 (2603:10b6:208:32a::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6854:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a631a81-9f43-45a5-96ff-08dc226a8c72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fbAG3IjI1OYkfpsgGBUqVCvcAgPXGJOFXvQml8oZyQF9GOQG83ZhP2oqk5PddVzDLjXhFSAWP9GKWfw1okM7G1UBXk19+5abXZA16qMMhtzvy2nRcJpM10tmMZt7GtVtceUkPmcN/s7N4hSNXE7cSouUnAKtVtaijmIzCqxAcKDp33CDklZpcQL9N9ja3Hnzp9Q+n1/pkdN6lyuWMOzgqvr0+wWTrlrgUtcX11xfQIkTq+5q69UZakhpdag+GzXlx7ko8v0d3bq80+3PrRm5OR3BigJPG2nxsJcDjwteSVQXcdZWMoSFKCq+g1j4+NxqHQzbAY3XtmjckJjdB/GRQr5tdEB2AoyH3Q+atRH5ZnF4yTW9zgkAJHLHBVqjZGCLV3D09jFrXNWEY7vp1gkWoC8vVBE9trwYnH3aG0d1E5ZfEz4tTXIQdHRP3oWA93nxKspDfo/Cw5dfZFh+jb55iEnfVp+xQQ48oceE25xWcClWlBYUeOL226cJHXQTJRmAMlXBt5MC+8WWZ8xQ9IjbMgAkWVQ/7k9LoLg10ncYe63sG5UXs31rPR3hj1ySAfYd
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(346002)(39860400002)(136003)(366004)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(83380400001)(41300700001)(26005)(6512007)(2616005)(38100700002)(1076003)(8936002)(4326008)(5660300002)(8676002)(7416002)(4744005)(2906002)(478600001)(6486002)(6506007)(54906003)(66476007)(66556008)(66946007)(6916009)(316002)(86362001)(33656002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?enZ0Z0lYM2FqLzVFVXBReUJ5ZGdZTUNHcFV4SjNoa0JWQk5Ra09Za3Mwd0lR?=
 =?utf-8?B?UnhuNnBFVlVGdlhYZzdZT096Q2dGc1NMODVsRFI4YTU5cEgwbDlGSllVVEFk?=
 =?utf-8?B?cUNLNklpa3IzSXhlOVJ3MjFxUUpoNmE3TEFKOWdJNFdLYTZ4UFRTWDVhMnpw?=
 =?utf-8?B?NnMyM2tQd1BiL0xwOERMOVQxcHpvVXlXNEtOclVuUWg4QkxYa3lpTHBoVSsv?=
 =?utf-8?B?cmcrbWpVRmtqWkppSzZyRVZrTUdBNSs5WnBWWXFoTXpCOWY4RFdZVzhnSmw5?=
 =?utf-8?B?MVpIcEJWOWhWTTVsMkt3bHN2ZXhDUHJCakhmWU5IbkwvVTk5UksrL1hSU29X?=
 =?utf-8?B?MEx0OERZNjh5OVJrTUdHcGZIbzc4K1NiUGJybmdjMzEvOHNwdnlpVmR0bzFX?=
 =?utf-8?B?TmlXVFlnNW5JazU1bHNpUmZFK1pvbTV1MFZSTlhTUGJJdUVoRHRlQWw0UC9R?=
 =?utf-8?B?UHEzREExekdqZnUrWGNOL2toTmtKS2FkRU4rL2NvMWsrSmZuTE11eEVMczlo?=
 =?utf-8?B?RFYvZnNxZkE1d0tSUVBOaldVRXhJNDM1aUx2Y1N5d2xneXU4bUpnR0tkcHkr?=
 =?utf-8?B?cGJWdFBreGJwK0NkbWw0bUlXdXlaSmpTTmJjdVgxRWlZbTczTmxZeFNaSndx?=
 =?utf-8?B?alpqM0RCVXQ2ZVZPRXlrOFNoRjh4YTcrZkMwWEJkS21iOExGODRXcXlGTkpa?=
 =?utf-8?B?Nndob2E5aXZBQXdETkNIVkNkQnRjbW9GVkFIZDdnSDZBT3NNZ2VudGgwcCtt?=
 =?utf-8?B?b3Q0dXZEK0E4YUZ4MGNrZG9HcWFNTnpqUHpOK2xaNzRwQk4xZzE0OVF4Y0Jm?=
 =?utf-8?B?OEdVQ3VZdkdjVWFVUEd0ZlZybmlwMWNVOUJwMDN4RTNOOGJiRUMyMWhlOUow?=
 =?utf-8?B?Sm1HY0tXVUdEeGZXVGJQUmNPWDJSNmU5TmdYbThPRWE2K1ppN25MMjA1RTdh?=
 =?utf-8?B?OUxnWjZQd3VyNlE0ZTYxNks5dWdlSEFtYldqV2wrYmgxaW9OS1NleW45RERM?=
 =?utf-8?B?TEg1YWovRGs3NDM0THpEZjFPTjVZOXFHdUp2WnJBdjNVUnc4c0NJWElLN1pv?=
 =?utf-8?B?eDhGVDNTOUNTMnd3SmRhMm14dExKSkQ2ZVhvK0JtL1l5c3hFcjA3RWNabzFX?=
 =?utf-8?B?UnZKLzN3amptc3RzVVVObnh1aGcyc1RTdVQxekRQdDc0S2k2YXQzKzlJSEds?=
 =?utf-8?B?cnNzN1ZXcUhMcURKVjYrUnZjQi9BUTgwdXRRMjIxRUJUK1NDUUZ3ZExJaWFl?=
 =?utf-8?B?Y1YycGdPeXdTSW5lQ1BRMnZNODE3dnJCODZ6RlRRUFZ5dVArMXFodzZ3MVVX?=
 =?utf-8?B?U3ByZ3dmTS9kNnhqeGtGa3VHcVJsVGlGWXUvNUN3NXRBdDJQeEN3MXo2Z1V4?=
 =?utf-8?B?dzZtYUdrdnF4eTBwSVFxbmZHZFdJYndMUnFkV0NhalpoWi9ORDg5cVA0YTJ0?=
 =?utf-8?B?QXhhSG5weXhrRHJJVDJTbzd6SzdubC9XWlc3YnpIbGJuQ0NIWUNERm9kUTNj?=
 =?utf-8?B?NmhXMGtiazJjV0JEaGVLUEVxR0VPV0FkajgyV21qZjZDUTFVQTM4MXV6UEhk?=
 =?utf-8?B?WDE4WHM2T3l0M004TFBjcy8xZ2pCN3htcExhNUFpUWJsRUVYTmRnelpkQkY1?=
 =?utf-8?B?ZmRPZklJUU5JOWtmMm1kQnVEMjQ3WjM0cjJXcUZXWTg3UDNDWkx3QWw2enFX?=
 =?utf-8?B?TTU4V3NJSXF6NG1LckxXNmZjQUFNdXdkQWhUTGFMVXo1cm13OXUwSHFkcXND?=
 =?utf-8?B?ZERta0c2akNFdFJFMHBpTC9TNHZSb1AzSWRxSnR2Q3IyTHJ1TllUTGlISDJC?=
 =?utf-8?B?c2RsTDUxNktQZlJBN3RRMUIxMTk0cFlRNFIyWVRMV0h4b1RDRndkakpQaEVa?=
 =?utf-8?B?cHBSVHZrdHV4L1dLdk1tbXRSNDFKMU9KQ0o2MUtkT2ZnSEo2anFFVkFpT3U4?=
 =?utf-8?B?NVZDZlYvZytROGlkQ1M4elpmTytkQ3FySUNpdExjaTdTOG91a0xMeks3eDB2?=
 =?utf-8?B?NDJzazcyS0ZNSzV6WWFqMkdzeTNkZExPeGxPUkdaenNHQUNFY3BPRHFxbUhz?=
 =?utf-8?B?SlZac0NKWFp4NjQxYUpuaUhKWmtyTzgxSEhlbnhpVFVGZ2p5aFQ5ZlpHRDY0?=
 =?utf-8?Q?VvmeXaVX5UlhLUrr+FapEQGJX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a631a81-9f43-45a5-96ff-08dc226a8c72
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2024 14:40:19.9287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rgldkwMJ4ApJcQOM4Hg3bW9Yb35jXrHrSwJ6kY6N3pKbRXUIxK8XCCGBpI/3/qYJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6854

On Wed, Jan 31, 2024 at 02:34:23PM +0000, Mostafa Saleh wrote:

> But arm_smmu_ste is defined based on STRTAB_STE_DWORDS. And this macro would
> never change as it is tied to the HW. However, in the future we can update
> “struct arm_smmu_ste” to hold a refcount for some reason,
> then sizeof(struct arm_smmu_ste) is not the size of the STE in the hardware.
> IMHO, any reference to the HW STE should be done using the macro.

We can't do anything like that. The arm_smmu_ste is a HW structure
that overlays the actual memory that the SMMU is DMA'ing from. It's
size and memory layout cannot be changed.

Jason
