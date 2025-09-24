Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011028.outbound.protection.outlook.com [52.101.52.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E468024679A;
	Wed, 24 Sep 2025 21:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.52.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758748102; cv=fail; b=U7Sd21FOXjnsfCpQk3LH1CavrSUzFkndbcRk117iQgSlzFkm1var8nPvo2uB/ekL+uwOjssV2zExQ9znVzM7ec3S5IDH5RYjoU0CEijesZxeg5fP/cVnR0WGEmeEhvdJstalPxzpIZR/Z5iLSoxTutLloWf/RDig9QQ3OPh7i5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758748102; c=relaxed/simple;
	bh=ZXiVX/Ab/XqKYM3uTL9SBOTuLaPt3jljJtO2yDLaJOA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=m4VUfalsWD/wUo+UiWajBvZdWBB6slEp/9aKGx5Y8NkhBFVFntaQ0RVZ9E+TBcqGVL8MHjqWyFaZANlb0UQpLEa4ykUWvrfIP29oBI/sfpyW5XuJ3/9EjfjJ3Pj/l7jEi3iNnBlnaliDPwYmZihOMPIr/MXPBqIeu/elp8s2pto=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QTtTPBRu; arc=fail smtp.client-ip=52.101.52.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QTtTPBRu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YA8QGfk5TUfVDdCkyhofuwfCpXLDrEV643EZGnd25KnKnmiRMC4SSy2zoxEOtLRRdVNNuuOT+E9zYSVB0g3XCnbEzvAmKOqee4nGIHpVVb9oqlFV21M1RrWTH1DimZwnbyxORsufhXqCIhCpmsslT/tGWm0/b3U5/Bm4yZYrDRTNazxshu41+TxBbpH3McDVAnW32S65JxtFUxxkIVvnDPJGgsNnT9RXVkBCcsxGl8NZOlm0SDtLrHob6mjU3T4P+W6YhPktRrLLZY2KUt67YgzQ70jKFhT34RoY1verShiW7a+GqBOaer8PT5Xi0fz7oVivsa/sSwhwduu9KiplIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kzzV33boIzjAEdbeFOgpiDnk7I5xTkxmzQzqUAs3XrY=;
 b=ouWcnWYJ+dl9bTn/Mv/6nsnBAQAP7AtIagW7DGnAin+p9HU1s2+QPeW4Fs6TfExn1qFmNFzJdbmtZr2XNLS/OgrF8rJOx5fiYk0HUdBRTW6veso7Z6RePnPWh4Sq+5mk+1M4YCoJIhnL6I6UKzTBSILiBmVngc4HrXkWIgyGp988uLDcHimCCAMSoGK4qOnD66pOoWJ3TePbH/MCSIvYBv1/wnkvNfyf8gHDzqlj2whkD7/ziMlgzOZgOQtXyIDgbCWgVdgSNNM8utkOJPUU1Wcb2xNp0V9siK0ZOR5hfSOqv9uyuTeWO4OsgHnRFEo4Up4ps3NcnB2DYIs43d2ksA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kzzV33boIzjAEdbeFOgpiDnk7I5xTkxmzQzqUAs3XrY=;
 b=QTtTPBRu4e2zSNikoygJ1yNt2F/83HL+D61ti/DEcZkzWq0AxD7fr9Xnj+3EQCWumwocuVQTbnLYsZru4icdDCG5rZ6zJbCErf5NqYwWb7c2fhoHCj1h0Mz6rmxnTpI+VAV4HrzvUSwUIiNdpuJBY6BQAy9OR4H3h1Yqo2MNwW2Kb8lHXeFRKD+mwvVDoVYcpSa0cAengA1mS2GdWsneIjSH+h+f8K64/rFjmr7skdMUAPp9YTW+VGd3fteFR1MFmJt0u33xXO8EwFABnGxsEW/OgHYwggzhkvwnBV4U0C2WJ461LChN/j7V6cKJzu+/fbOdt2596Zm6lA/5KTR51Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by IA1PR12MB6284.namprd12.prod.outlook.com (2603:10b6:208:3e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Wed, 24 Sep
 2025 21:08:16 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.021; Wed, 24 Sep 2025
 21:08:16 +0000
Date: Wed, 24 Sep 2025 18:08:15 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
	jean-philippe@linaro.org, miko.lenczewski@arm.com,
	balbirs@nvidia.com, peterz@infradead.org, smostafa@google.com,
	kevin.tian@intel.com, praan@google.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH rfcv2 3/8] iommu/arm-smmu-v3: Add an inline
 arm_smmu_domain_free()
Message-ID: <20250924210815.GO2617119@nvidia.com>
References: <cover.1757373449.git.nicolinc@nvidia.com>
 <2066c45c004cde5c5e9f334c40e5683402e6deda.1757373449.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2066c45c004cde5c5e9f334c40e5683402e6deda.1757373449.git.nicolinc@nvidia.com>
X-ClientProxiedBy: SN6PR16CA0056.namprd16.prod.outlook.com
 (2603:10b6:805:ca::33) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|IA1PR12MB6284:EE_
X-MS-Office365-Filtering-Correlation-Id: 50d36ca7-8812-4573-33ce-08ddfbae7b21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JeB4IODwjmJctiuSNYHGBgWF9EB5cKkKvTeXD3irb8UGAOpygb0dx1X7bX5e?=
 =?us-ascii?Q?RMXIjVe/gz0ODPCzfi+8zPKPYkmLipamVrkrzcI0BfgHHypljWMO3kKL7mM+?=
 =?us-ascii?Q?+myLOYYLRcJlxQEddEXC3r+JeTR9M4E/DRV4t4Nxs20x0NxjT6bdn4jXp3Kl?=
 =?us-ascii?Q?feB2cCzF16HtvSgwtlI6cAu232xbgCgVoDLN/HyimX49I5XlO6IUtkQaNvzp?=
 =?us-ascii?Q?qhhEhPLg2EhbnZD8DYH1IIo8SuwYrSMDkqv8nouCwqGJ1DxxewD9uKwrQuYr?=
 =?us-ascii?Q?rQViPW9MV2L2nYo/RM23qsm/0+3cGvvgHczlODLgeQfrIk2h0JgINCgCAC8c?=
 =?us-ascii?Q?rg0yC35llZK6W0wbIzVoYU/Imn5sMWOy9eOhEqvp9TEM2IVInGvKbbKcFyGy?=
 =?us-ascii?Q?hdTQLOBBwGI0rN7MYzQtgRMsfVzJBtXeZEp98W5aNfMgOSosR5jmY9H2vi/O?=
 =?us-ascii?Q?a7LCa04TlrBq6wlXqwVOl3n4GSc10Cuup6F7tm0CgNGfI00sIOaLF3Nbw4Oj?=
 =?us-ascii?Q?NmpdkCpc/1r7rZ0QIRq4SdemdloS3BxcPlVhylobw1zCdeu/8K8UalYTlc0K?=
 =?us-ascii?Q?+avSYBgTzf7MnyVsJKqPlonfQh9EipfJSGWgX2UrqQyM71eJkP36T6/NTlOM?=
 =?us-ascii?Q?IrROZJuAaBueBuTaKiR0/UDF9/0155ynkKAPMtQ1ls0/kyGWTS4dmmKz2NKI?=
 =?us-ascii?Q?yDCUX4eZ7U47A2owhmsug5oBXyEQelhDd2LYI0WcuCsUKkE1L3mvUa73IIpz?=
 =?us-ascii?Q?QMIEaEjTQQoh5iLr4emUX2CSH5/0GF/5C4oV3gG1sUiCOXEhU/caZj8GPJXb?=
 =?us-ascii?Q?vr3kdWs/xXnBZygNTlGG16HkLuXnlg6ruxj+5HvckwCneOjh4mKVLW4mbRC1?=
 =?us-ascii?Q?ay7PWdlFJZWmYW/2S2dE6yJ08Q6wgF7w0JgR7PMCCYNPR/PDybZ/9/YpoPU+?=
 =?us-ascii?Q?ZAGXhpFrIVNa751kDwgKP1Y898CF/Xz/+VX0LlafQU+4DXKGe9ChmLfueSZY?=
 =?us-ascii?Q?5OyoRA1E7fCvQiG2ifuf7tw+WzbyIAIxM0WRiTz42YupHqpE538YLAMFsakg?=
 =?us-ascii?Q?9MN2ejk+h/YLHxOPwzahiP8RszSEzVYYez//zNiITvfVLJsTE7tHykiU3OM/?=
 =?us-ascii?Q?t3Qv8vjlc0hmEvAVZTKZkzbqoaE2ydZFFIfVrRH1ObvT6Oz2Q5/RcvVC0BhC?=
 =?us-ascii?Q?3uQdjJdzMnhNzVQqmhZfcnM8tzuY2xIRPaueyzwx77NcrtILKvPxsZvvmqsA?=
 =?us-ascii?Q?SrHBzdC000w/z7gaKAkFDTJeNX4pMFY8y9xkuXVHMm8XJhQNAhUcr7bSJPRu?=
 =?us-ascii?Q?h4crcoE6OSmnhbyrvPtytSxDFTQ3FAq3NfIjNNHaRyspA3GS+0T7P8BV+b2K?=
 =?us-ascii?Q?pe0/OqniQ6+s3SS953gum5u0DcM3IyPPJFIlDiGoOPMZqBb8PZk11GGSVJaX?=
 =?us-ascii?Q?TpZ0nyZUKSI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?R0ltA0R+DLR9aiSD+qZYrjypUoeCiM4Ri4D5Oy3ShkafTPa8Eu22G9BN0gj7?=
 =?us-ascii?Q?/3WSI9rJeOykpo4z5zihL2VAMYzw++PUL0vpbidgj22seviHE2dC3UfLhx3d?=
 =?us-ascii?Q?M4dcOrKI+1F6HKR3KrBbTqJpq6LUoTdKKOyH/LuPqQDlhcpsIK3+IF8cH6Vn?=
 =?us-ascii?Q?GUh8ZvW/eclgdrgR2wvJ9TR5CA3t/NQCai1SDaE6wzQ4y+iA72RdT2A+1YM4?=
 =?us-ascii?Q?Zx4n0Ufaw6tYHBYw4teDucSthlIdvT8oNy1jDZIzcs0yCKRJhYp+KnWKtmjt?=
 =?us-ascii?Q?98urYlbm2UML6rrLUbeiCOGlNMZUEN7kbTsWEOrW6dde7E28wG5RJ+bGV2Vx?=
 =?us-ascii?Q?MdvcbnLx2rHNyTcE6rd7BYGl7yh7jUFWwAjKxo5mOh0hx2S5jdGbP0Gn9NCX?=
 =?us-ascii?Q?6yJdxWfyjh/aNdVXulrtLbryvKjT4SUtoparU+UAcHbZMPohFnFI17LJDb4L?=
 =?us-ascii?Q?qoRQ01Goj6QLMD5S9LpGMWaOtMuA+gCeuGlPZTSVXDlBJMAlkKIMW9JnrASu?=
 =?us-ascii?Q?rKXtHtQkNYC59nnYbNGFySBEkodTMYxCzaq60GejCmNLeGexE9qUU6RpCK09?=
 =?us-ascii?Q?2W61Yg9l3L+abyT+4sv+WycTwdZhkYD2YBgCTViqER55vf7FcD8kJ70+n5wq?=
 =?us-ascii?Q?iy4Xsw7uk44PzXgWrKHgJr0BxIHvqKXZrIN9qczKoxMWyybzZiLpYqJVgFaX?=
 =?us-ascii?Q?M9Tp241r6tHA4qriL8qMoUy/5Ti65/6+Ildooodyq3SqhWkbrHAR9bkgXHG9?=
 =?us-ascii?Q?S2W9MK9ni/6HJwahSRT1wGptL3p8GF1NTC19pG4FO68eBd1gOr6Z7jAAPZZA?=
 =?us-ascii?Q?EHgRxMN9Va9omtyYscJ7CMPYRlKAHo1BxxnkDf5FN3oYIBkhsUnAPBPKFjL3?=
 =?us-ascii?Q?WX7ofgadmM1HmI+xJl+/RiOR1xB8SmXjXUJmv+1vD1e+KHgptSL5/dTz3zh5?=
 =?us-ascii?Q?F8Xme5IpFVTdwNaSi7Im/aVC/UcTx/7eqt/Tdiskj4JLBIkNtLYELWMACXjS?=
 =?us-ascii?Q?UTQ7uB5QLiEied3weQpa2qea5j1dOIqH67Q0GY139bcoI6YY1FvQEUZJK1su?=
 =?us-ascii?Q?flj3AW1P3KD5RYaMAvKIG+/SiCbyot/DfxHpM9OIlz46DmKd1UascZnkYcuK?=
 =?us-ascii?Q?xu9/xw8SNfEN81CGKZzNUPZAEZDG3xA7/B4+C2bFdc40yeL8V6C1rNx4sf4o?=
 =?us-ascii?Q?byUnL4uFR2qXIG9RZx6rX5abUmQTaVRTKDqfmayag7yCplsxDB5rkULtnIhj?=
 =?us-ascii?Q?DaxiUAQn9RKvTpffyc9R5DPM/6t25mpfcgRq82VhValqq0my9Dup9RYRLhxB?=
 =?us-ascii?Q?wsgZdIE4cqH7i9WdChnIwdtoRpJDrgXX8mtekR1mVSP2plJ3Gxp2KKp0QXV7?=
 =?us-ascii?Q?b6p5vmST0/OjqGqItKexClqpsxajHHaWyJU7mlccwGMDBq3R2aPd6nDi4ekX?=
 =?us-ascii?Q?29NcYJtMeKxrqOZZ0XfenDXOLErKr27OaWcpMqY2X4seXF7NI781INwgkGVg?=
 =?us-ascii?Q?SsmUud7wN53guSOUsmDSdO2+eMXTZjn2gMCFTaPwIduGM4YzUyNbeeE/rBvh?=
 =?us-ascii?Q?3dmlc6XQHwX7JyiIvFR+FmBDnjopiubKVXzzxP5P?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50d36ca7-8812-4573-33ce-08ddfbae7b21
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 21:08:16.6712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1QZXwHCIWVkZ6q5P1CyWmPHS83Ahtknq6CtE3Ifr+nMzyhQ02Jb3l9IY+2huMt1A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6284

On Mon, Sep 08, 2025 at 04:26:57PM -0700, Nicolin Chen wrote:
> There will be a bit more things to free than smmu_domain itself. So keep a
> simple inline function in the header to share aross files.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     | 5 +++++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 2 +-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     | 4 ++--
>  3 files changed, 8 insertions(+), 3 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
