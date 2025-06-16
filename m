Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2049.outbound.protection.outlook.com [40.107.243.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B222D292B4D;
	Mon, 16 Jun 2025 12:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750078195; cv=fail; b=rTZZuvoqh40ikL6WNLjUlCR6kc+qk0SgpOVoNmJnHFP806YA+j8w2rW7txrALM4e2zxYskGDY5HVpyqptEbvJP46OHG/NOiy7fGgh2wwCB1lrB47VRU816XnU7hTao938DNMtteMhQvgI0P2dw/1HCUP1wbfa6ph+nTcuaFRmis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750078195; c=relaxed/simple;
	bh=KzHiSLW8+7RWGGw2CtSIhmO1mkKYrEwLQstzLk1CGV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jmvjqvgTU5HWsH1JV6lOIpZMnvjpKe5VzR7XLiLmmGbnIe3hOdglz/DXKtlWBqgwzUzVuVQ7AqYLtr7XEIJrFqSMvMOFacqlpbAs33JeBDFVgksMnlhqQfn7479YBETJJv8sYVPt5grAxtNLupsh/+7XakTCB6rO3y7aGlFOI0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JGVHJc8R; arc=fail smtp.client-ip=40.107.243.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JGVHJc8R"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z5IRp9HSk04To9iDPpBWzPn8fNl/+xAdSS5J2qXJKV9QRJ3wmcNgiVEhOhOfvRobe0e0jcmIeOZPyKaA12AzN1XMcwMB5VFtlwXhCBIC5qmwqgJG1ItSY+NQUmPN21m26xSoty8dmcc0DA6r4WOHst6/61w2Ogo3jutzzUyLwr7Rapws36Wao26UHUkSCPBxShkYrNurfTJHY/WGZFPl1cgA6UL/Uod+utIA2cxsXipXEcjvha3KRyGRadJtEGw72eeSGQNAabMTXtlZsvoQozOP7whmAM6y4USOKVEW/xg/sgMzBzoxsoR5/MUweDUyo+rNsyD317cwpD6wFUPoHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+bBsPf46nEX05Uqb0GW8aVVLHRkYK+jBcbzGVBU/M9A=;
 b=T5keuX0U/sYSMsVkpv6UDmkP4Vuq4RNStubD7d/WVR3WMDXORJvI+zTQV8WjMlUlV+dbLnfutCo/2il+fOijyP2TmJKOTaSr6fOXxDlqs4dN4ujT+rj0bOuH56BkGUOzOepV0Afvn5A+rDv7mz/1jO+N19Bh+uVAZuXXby0aWNiMgc6537CiDn+LBqbWWmO6XMkROgqTIxQg0hVTdzEGHEExbAwu0sILQenkJLzXXepcKmI5DhxjyYbqix4yJLmhRCOwSFLKHlniSkQWlpsx0oJRBlgO1XeRzMvWzZ68BNYSQ6l8V/0ZZFGl1Wa900haukwXW2RSrOvo4pnAGukR8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+bBsPf46nEX05Uqb0GW8aVVLHRkYK+jBcbzGVBU/M9A=;
 b=JGVHJc8Rmun69xWnBabuC8dP25z3lN4GSTg6yCAA+AS7YOCNv1ROZSkdP1TvnyGFoKUctftgrJVo8LvrDp8W+71z9O8LlhE9HjZLIiUbhzMXDY2q5hO43mtB2BYm6J0GJHHd7Fm363Dokv6TLuJfrOHkOx9D67Gh4dMQL1GaxmduEU+Pe/KsR4jXAjN+i8IeGLilYHyACWeeNMmL5TRxieh5Ud+NDnUmgEdeYVO2otA9FEGn4ZBZYGpvSqpzlYdannTIs75lKJmDXFIZ+JihDrcMqY0J8RKCp9gkgtZPAOIvSBTd5DcymqFpXIOq0e9ghmF3VjyMYHFpYYv4M3PS5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN0PR12MB6295.namprd12.prod.outlook.com (2603:10b6:208:3c0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Mon, 16 Jun
 2025 12:49:50 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Mon, 16 Jun 2025
 12:49:50 +0000
Date: Mon, 16 Jun 2025 09:49:48 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: kevin.tian@intel.com, will@kernel.org, robin.murphy@arm.com,
	joro@8bytes.org, praan@google.com, yi.l.liu@intel.com,
	peterz@infradead.org, jsnitsel@redhat.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v2 11/14] iommu: Deprecate viommu_alloc op
Message-ID: <20250616124948.GA1174925@nvidia.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <5b32d4499d7ed02a63e57a293c11b642d226ef8d.1749882255.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b32d4499d7ed02a63e57a293c11b642d226ef8d.1749882255.git.nicolinc@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0288.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN0PR12MB6295:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d866390-4ba8-4461-452f-08ddacd44803
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/bU6oHI39LDxvsnw0itYmaqIbPrcn+1OtQAtuTOsIsIrXVEJuRazFMdmIf3R?=
 =?us-ascii?Q?6HDDJedZaV07FKl9Y9dmY40MfG698i5Pc3W5LYIO3ajYFKmKlCQkDewWAJVx?=
 =?us-ascii?Q?6DLisanZLtEV50MB7SxtRTVEYiU1lQrGe24lQHuem1X9JQRaE8lzh2pFSISG?=
 =?us-ascii?Q?6BQTFevUrxZ/HHta73Vusez5JVOe2lOTQBbtqjdkWb0rNS1nxRrNPduVAPZC?=
 =?us-ascii?Q?FI5ZA+v1Lsnn5cwdZKzXuD0QAviy25VL3GNkHpi0BPRlT6/sQcXUAg7dBOV/?=
 =?us-ascii?Q?DpOF3bBOY1tqo1i6/iYfdd5e5NXLrCu4mHbOCcqEIkit4kDX5RqoFDOPkof7?=
 =?us-ascii?Q?FU2KOZ3x+ZF4gaL/fSncHe1aPAkoQ2pl0UFGOshjKoWADFinHQ/OvAPvlBwn?=
 =?us-ascii?Q?V5I1hTxKDhzaRbK2o4DjOleN46SL3lnnyOKkPUxhea2pNCyKdadOSCgRYUf4?=
 =?us-ascii?Q?x06YbpQT5wDWPOMHhvCXRHGF2RADl581DZIdcVGgK1h5ZHLZrk8dG/8GT9hv?=
 =?us-ascii?Q?x/TFJSSJhrqoF0prVRiXxeJUFQfOmiIF7mSUKk9YlI3V61Jkm+9hEKXsiZ2O?=
 =?us-ascii?Q?KdHKx3lDfrl9rTQcunou7ibYLl3R+uI/IxBWfwiFEFSN0Wbpj6pFguuA4zwp?=
 =?us-ascii?Q?IIuowAA9VfDSUbmDwXEgmUADXgt6uogDyG/OAYz8ttGZG65EFzP5s3Bdb9I1?=
 =?us-ascii?Q?jED05uG1+25S7WQDiHKu2i/1zAqlVGhUpIZSZR7LE/0GV1LKd+Zs/D6Gfr7S?=
 =?us-ascii?Q?LTp6wx0VqkykO21+TzvnI4ZWE0wiBOV5MgsrtyzO4+Ahwhn5D9rnHd/gt/7L?=
 =?us-ascii?Q?BCjTLbzFeQvNiMiD6wdc4oLDdtBjzPVA0XzoCmcB3wUl2r+a3qldcRMyBALj?=
 =?us-ascii?Q?9ubiRCbhNWnoIBq9M1zZ9ezWdMsLdu8/JD3V/c/jHr0HcCjyJfkuZ2J2ANa+?=
 =?us-ascii?Q?kMxfmZo38EPnTNphTmNjNFXZMoAcSoNRN9xbb0QkJbcnT0MhHhtUa6MfDfZp?=
 =?us-ascii?Q?KC2ECCCSJN7obkXvQ0V9cLVysvJulEFzkhGaUpZcAah/SiTKbxRKxsvZOTkM?=
 =?us-ascii?Q?ayJqmGtkgxkKkn/2JqzJtb0tn6jg+HlBFQNts0Bx75hOip7DkT/f7xvErZoN?=
 =?us-ascii?Q?2nvZMJgh15vflKHCXdy5OcDaYrCQMgziVIQ2YzMWaQ02h7jmULVbQbTGxiAU?=
 =?us-ascii?Q?8dTx3MpdPTsHQZF1Y1JpM0DeLricXPKKBtsb9tQkQ9J97QA5MEtU6xH+u0EK?=
 =?us-ascii?Q?QDgIALZWcItXMUZ3WUeKN8zeL7J8TdsY3qI7JcdV4ivBT7J7ANtphIo8mMIq?=
 =?us-ascii?Q?SYHv9x4awjvlbxnfPNECWX3DOkxmM7o068eXk/SdCi7O0hZKrCE+YbBjZKwa?=
 =?us-ascii?Q?fonFDpLIhQ2bUVurLiaaLzb0d4d0bTgmTt7/8fIRFj8GIYh6Fz277c+Ofqxm?=
 =?us-ascii?Q?5eVdUkPUPDk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g1VqdsKMX7AZHedWTc2GbHseS7xx5GGkJZY9/3jKzaQlT7e9QergAskhkm8F?=
 =?us-ascii?Q?m0kUFKXxMKv+sycMNrc16mcN1UdRkOlafNw/UGjbqlnloaCVWbDoSyPJTqrs?=
 =?us-ascii?Q?n58JPp9/lTiZa/IaMOarpLfULgSzk/iWNybjv/dMAIdaMK1vfSvILrVSBBVQ?=
 =?us-ascii?Q?z+elMN/X2Dip3H7bAViw5cc+D6wBgasNrZTzEHKx3Kq6zsapsCeb06KY7ON0?=
 =?us-ascii?Q?YURxwpfd7K6VmKQp/dKISsBoeShi+O/Mc0tb5p2PPqAjBdAhsUeM30qbnIc6?=
 =?us-ascii?Q?EkEMYLUY6Uu5tK2ft5J31xLxByL83YPA2gKAtgmk2u2WJq3J59cqTAucXxa5?=
 =?us-ascii?Q?ns3Bg6KCkyrAZBLL4X9FuhFXC2HvW2ErUICEjkcnPz6CZPplQd7CLpKp8LF3?=
 =?us-ascii?Q?COEjWwnbpx9KWBrwWcoRYoSuwBeI7JMzPPTJm4IKBGBk07owz38lEXMItF4c?=
 =?us-ascii?Q?CrUvb6l4fADJgZkPkGT2NFSH70rvq7XqEzsfVQVp4laCzyCsrtWSKONsGzws?=
 =?us-ascii?Q?h61MhgJyKD7H0XqSoGGSe9Gf4s5VPoaCTBI9Flct4csUB2IAvlzxW+H9paGA?=
 =?us-ascii?Q?Pju+xhAQ9j0Ky8FGE/okGZIji8paDLMSYcTWPyhSFu8D2S2zLzj+8zDOKIEa?=
 =?us-ascii?Q?UIIeZefv663TzmqZdPbFYYIOvfUzgP56e1zwEd+el53pqkW6BfJlrLlqnRKo?=
 =?us-ascii?Q?tKKT7hwD2iY590rXVT5fjETBHxBI323k7Wd4cZtZdyGkCEmG/xsXoJmoWTQi?=
 =?us-ascii?Q?YNfEZzQVIuJd+Xk5EWYm5LXh8STEtlH2mvcfpDEeU9BCrJVJzDz+g6pC1Fc2?=
 =?us-ascii?Q?fL+nTUgkdpmYiOMW+rwKnHDUYjzotoF54Mp3C8U13HW/r45RnLjqvTVcsZBN?=
 =?us-ascii?Q?GRFjIHj18wO0P0mR+KhHsOLUko5eji/i9umTHFiSLFY0Pz/y4DcE2t4e2qA9?=
 =?us-ascii?Q?TfAEPPAOCfCKfltAXIIKgdc2440RaTqxwMKWn+Lz6p0Ku55I13Qg/7+jTEV2?=
 =?us-ascii?Q?cTrrFRj21beQmey2KmKp5u/lLYBYt+p6OPX8SttQ6e5k4L+iy+ZJvz4Mmj+c?=
 =?us-ascii?Q?C6pw/sdksoGzagvC6CXi1v6UwfhowL0b13DaYydC6ODI+fUkCTEWJ4gQjpBO?=
 =?us-ascii?Q?cny5DxmKXamv6SNmvx3atTfotg7+oV72rhV4u6Pe/B62IN+/MTX25IPRXT8U?=
 =?us-ascii?Q?iaAKoKcGGdDt+08/CTh+5q9D6lof9V+Bh6XZFOjtsVTZgv46lwoLoUgzs7B2?=
 =?us-ascii?Q?VSdCRpAsKYhTb1lUwPJC3lyq0aWUL8roIySTXy+COhFVCamoaLhE3Oj0ct1c?=
 =?us-ascii?Q?Ykh/HVvdOY4RSCwLksbV/vdGro26CCHqOly2+S0IS5EGLUukcOZW51sT5Kyd?=
 =?us-ascii?Q?7O9DMXX+CkG7BrP26msZjvylpxIPPg0irC2xXUvcAtoz9q/FZE5K9aYts8h8?=
 =?us-ascii?Q?LhnggJjRDL1SrpYYb5koe0DOdemsbR/RQmF7SkflD7tioxscVhoaBZufl8Ng?=
 =?us-ascii?Q?K88VLzM51YYALm1KCHtK252EzYCptOdWJ834VbO20f2OGqB8PX0HADexUL3m?=
 =?us-ascii?Q?vRkHGkkHHSVMOU3HL9fVhdj4zwFh96BXar7lsCQY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d866390-4ba8-4461-452f-08ddacd44803
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 12:49:50.1211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YA3C8qWRCNsxXuPsrEqAt2GMavEBoZ2X5YAOgMfkkMyhL/NDGf/SolPROSsCKswT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6295

On Fri, Jun 13, 2025 at 11:35:23PM -0700, Nicolin Chen wrote:
> To ease the for-driver iommufd APIs, get_viommu_size and viommu_init ops
> are introduced. Now, those existing vIOMMU supported drivers implemented
> these two ops, replacing the viommu_alloc one. So, there is no use of it.
> 
> Remove it from the headers and the viommu core.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  include/linux/iommu.h          | 11 -----------
>  include/linux/iommufd.h        | 18 ------------------
>  drivers/iommu/iommufd/viommu.c | 20 +++++---------------
>  3 files changed, 5 insertions(+), 44 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
