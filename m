Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010026.outbound.protection.outlook.com [40.93.198.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E08395D8A;
	Thu, 26 Feb 2026 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.26
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772118290; cv=fail; b=jhvEFHrR/GrdhsepeP5RhlEfPo8nMTQqWyevb8cUBW51gkng1wVnwjEvbhSb6Phz/9gNzFFdIAhTrG9yfi1DrwfVwFrZuBjbbtzUiVdafTlvusSdOvi90abl90aJlpoGXd8ny5yqAS+cydnYBrtrteUtV99bPaeLhUQzVHU2Bik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772118290; c=relaxed/simple;
	bh=Hgj0y5PWH8k3mhrDBPKa0Nh8tKe+YXKEdu8nALpK3Nc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Gi7ErwDJanxVxkfxtge3G2hX9HlR5bAnddAz5TO23+CGrSS5Qx6n+MnQHbr6IlzL9sbgrQEliOyshZlaVGuOfdKNJ3O13jZ+BFzTr0bsk3WlEy3u08vAQyuYuohv8idhAXCgnWXDsdV0gtYNujJYbjTw2WSIr4q4PCczoGYBWMc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=B7aL2gkO; arc=fail smtp.client-ip=40.93.198.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="B7aL2gkO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ccG1ShkPxP8+iaNCPAco/UVvQ7B9jMSYAMpSXN/azRSviLbyTckn66iZrbJIYeWATJh2YZJHkNz7Kl0QAU7BbiyETWl5w3Vgk9rreqAZll0fydNfPJXlPNhi3pK9uhrEKEIfFXdbgLx1uglsONTstaFYjUfpSz00gXjLF5AJ6GZzJ5CoL/h7R3nDNGDIW1YAW1Ek6ym4bDDQFfJUIUEzAJvhL3V4Q5O86nl28QXZMPw9q3oPJtqkJoynIyodi8t3Q46q8h+WnfoKszx0aLOyDmofaFtfbAIuDOB81BAThFL91Op6S6idrbIlJvDHVShxnXLavSS/Lokdi8enWFijRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eguFhSG5ISZuZuY6zY8OpcZ3pTsMOJK5D6eaiFJ5gYQ=;
 b=y0iKieeuYnRRyqrI3PsxDFyGZJOdDIlRKl3fjOIUm8+JKOswWqZPXSS6cOTthusRjinLy5BTDJ8CW9xt4uLLq+Uz8R2k5o/ctj8YAnLMqyxCxft/jmdNzc+BZLoodqkddnO366lNrxw4JyJJzdcC5qeRxk214kp7xWJSCtmrO7pFRBP7F4/eZKcDB5PJRazsJOylnxhc9FzN2+92rSMhIgqRkZCqd+Tv1/CjxalMGPChdM3Wxh1xsra3ETX9Mwh7gSG7Zp78xG4ahR1FtNRz1MhYMDBhPGRZyxT+CXpSP11PbXy0sSaMyMHSF8PgSJ0YD7ZDTcio7QweMigjz9/i+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eguFhSG5ISZuZuY6zY8OpcZ3pTsMOJK5D6eaiFJ5gYQ=;
 b=B7aL2gkOIVDWpGbiJe4uW+2Ecoy/8vHPQ8Rt32u4Ud8k+5zZN3Ooe0512+wD4S7aKfvXD6I1vAOSrO++bIbIDyqR8QJJ7jhZxyRD+TokiklAcN0ibGDGoGLFho1b+uiL10B2RH7zaKwWu+nqSt+wFZa0Gia+TAKuCluSoE/HKDUMhHdAmk7V7t42m0+xVRZG4EvUCfcjtLbwPgLIgxWBf4Minrc2OM5HRY16AdqTAeKFkEdZD/mUbGr1/cK4sFxK4/EqnG/Wh1rxaXIYq43THB7ibtOuYLPTp8jgfnbmr6dRmqnT9OhQRz8Uf6OpdsH+3kuCnqffwX6Dmfc14ECBmw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MN0PR12MB6126.namprd12.prod.outlook.com (2603:10b6:208:3c6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 15:04:42 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Thu, 26 Feb 2026
 15:04:42 +0000
Date: Thu, 26 Feb 2026 11:04:40 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>,
	Albert Ou <aou@eecs.berkeley.edu>, Jonathan Corbet <corbet@lwn.net>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Justin Stitt <justinstitt@google.com>, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
	llvm@lists.linux.dev, Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	James Gowans <jgowans@amazon.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Michael Roth <michael.roth@amd.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH v8 07/15] iommupt: Add map_pages op
Message-ID: <20260226150440.GB5933@nvidia.com>
References: <7-v8-d50aeee4481d+55efb-iommu_pt_jgg@nvidia.com>
 <fc4f0354-4e6d-452d-abfb-fe24e53253a2@amd.com>
 <20260117154347.GF1134360@nvidia.com>
 <bc6817bd-4aa5-4033-b89d-88fef637de65@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc6817bd-4aa5-4033-b89d-88fef637de65@amd.com>
X-ClientProxiedBy: BLAPR03CA0097.namprd03.prod.outlook.com
 (2603:10b6:208:32a::12) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MN0PR12MB6126:EE_
X-MS-Office365-Filtering-Correlation-Id: aad7e03d-359d-4e8e-9ecd-08de75485ea0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	cXD5a7tWFYjmfB7Anr20ib1e4twdLxL+5eFQNtOV5JpIdlSzIepMc2bpHto142gPpesYWaYw+zNGl4z6BChkNk6PKWVFpyb+ng1X1QU08B0W3MGiIpREhtS98TWw6VqI2aXhja6bgPan13Ah5jfCl0aqCo6BGtMFDdr3T9L4862pYpmw+Bc/c95hwLrfivLc8MDt+9HwoveCKBgpF5OFKzngU3EYIvc8UpKIJTKiyxWCBAdqw9+TxFuStu94byDNCEuYr7EUkWRvF3uTw28RQABscElP4DHVhD8xCX88NGy9IZp73Q97aohMnwwmU29HxMCaX+r7Psqbn4y8W5j4nMp96v/2DCvg8sVaF7Kxbw1sc3TQlxX0/tZtOIAYiFvrfIMCx59OPnSwZ4+w1j+gwFqHaoVwDCRH/pEm4rSuruFxbhUeRtfpITo4/1L50wjUPNBlcoSXs9c/EX4t/1E6b0HqGQI3JiWTkKh+YYhyf7w4kjMz1EgpDJLOFTwjj/E1CrLXfzi6MKl12VI3i4gQe9ECye80ZXuncR7EVB/yqgdkE1yvPs1Cj+bH3u0jCnCWI5grac9O6UI7GUZKNVYh9WLMsYa6VobmDr2N9W4MA7Oc/Q8OfD5SHWtIlFA5E8nX8xZIyrlKDG2GyHoQitxWefshamLoO0ruhEs3IA+EPbem5ZqehSjE6NibEWrMUrqFvmay12Me+y2yd6U2FuBWzWl4OWcef7arjIOd0DV67cs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+/3of0oRL5EEcvWNIhqaRD6mIveHlwbZwqSsjAbiA+oBxzvId8QZkRakrqp4?=
 =?us-ascii?Q?Yi7xxvY5ligL/dDPrBqgM5emlNU5RkjWZcvh7xmCjclBfOEm1oumdJW0+Cp8?=
 =?us-ascii?Q?F8ijKRHkNvaktOI1cJ5El/E3PgaT93rbw08a0ue2YETKGpUXCDshdV2VyxDU?=
 =?us-ascii?Q?Yuu3ag8wG/+iIpugMNv0jEJJvOgPb+b/zihfp5xykkPe5reIMkYzmLPvyvLu?=
 =?us-ascii?Q?1Dcl9PNh5jPcX/HhrWQmYHY5XhLcVT3FqNb2fauZ7sCO9PZJKmak0uHRqJIK?=
 =?us-ascii?Q?m4Hz1Jg+QdLc59V/xG1sZ8z81zz5/Se/pNWnFm82i9P8sRjEhYIcFPM6YXt/?=
 =?us-ascii?Q?PZMh7xdbAssP3Uu2NQshjdHVY84ohZL0bxv0j9MVLDDQqJx8nFGh6FzWl+o0?=
 =?us-ascii?Q?Mdj8BtsyrKep6ejXBR0V9bzNDCNkfJZYmLAVuRZNGjr8ZU9OXurv7hDiYcwW?=
 =?us-ascii?Q?qz+SJB9xfLiab/SjNd5ac+nlYIpXKSlO9YHcZ8ERQt9//FRh6rOsN0JW56Kv?=
 =?us-ascii?Q?5UJlM2adMgnuWKuyyTWw2cwoxHjHkFunJUoatw6vMsaJYJra1fP5atmXexZ+?=
 =?us-ascii?Q?dKjxdM8h0HXqoKz50hlYDl4IuhZVdtwAKJM/bhZfAHEB9xkI10j0MZj69AQ5?=
 =?us-ascii?Q?2WZDxtnIbu5uq80+gEwUEpcgxxYlxKrqDsN7wj1DjXMVrBWPpl8a0O7G/BR0?=
 =?us-ascii?Q?dMuxAp0TvzG5z3Kl6MGTP4w4q82t0TizWCRv7vIb6wl156mqByt6d6fJZ6++?=
 =?us-ascii?Q?WTJR6EZEOfBXPgH/dIx6EPA0RMDvBJcc4n0lHtnqXlj+wY4F42HxulofcTkH?=
 =?us-ascii?Q?HDbTuX7gLnnz6U/IAy831d1mazADeeIG8qmeLxPbVd13jB8xllk+NQ4wbZJh?=
 =?us-ascii?Q?gvNyUHmo3IpW+pp64YTey5H15cNJ+ywn9VynaPC6lAiTxmS/XuhxUqspUDHt?=
 =?us-ascii?Q?n4eya2yNOSkY8I5PuzfA9QXtKL3OH8+BIWjTsNDeJWOikz3T0t4hImKOn90C?=
 =?us-ascii?Q?Wxyq4oi8jBfa4pNbaJ7cA+sZgFqn4Z3ERAzfYS5O3uTwP5L5zhVX8JRuvl5C?=
 =?us-ascii?Q?ZY/HlZjX7Cgdgja2jZs2+OWTq0ZAljw1Wi+V3TFIMMiwjrnOPNBw8b11raU8?=
 =?us-ascii?Q?KjJZLJW8BB4GlWxhFqGEgIyic0CE7SOL9g0zmV0wr3zRzASEbnea3OqQW4VP?=
 =?us-ascii?Q?cj8SKYcTD7fAlT/u2tHsIpLVkINCQxF5HMGQwAE+jYouRzDAwei0AkxEQexe?=
 =?us-ascii?Q?WgLyT73HffgXpEA7UwLTwfvuNjkhSKDukRqdkz4vh8mBpQs8D/umGw5umqv1?=
 =?us-ascii?Q?BuYMVFcT0IauaJPX1Nh037bxtSn9S9Sl/BdXCIiJZs2ev1RJRDfrb3pjjLla?=
 =?us-ascii?Q?wLxGHG7ni6OFG3Gpfkf1vSt5SHbTr3QiGyFAcQpE0GKTnqIeI8ZneE05i7H5?=
 =?us-ascii?Q?6KtzbXqW65MkBsfxpbeMaMJ+KMlYFxThqYPhgvrbJ4/ifZWAs62eAASqntAx?=
 =?us-ascii?Q?4QKq/7IknCsdkUjnhs32I730ddcxwxk6c1baE90gOvzA00wcoE3xCarS1yOj?=
 =?us-ascii?Q?TkKNkTIWpPdrtIcL9VewGQSrSvG6pRm1bxp+MygoE07fjPsRHy0IzMNYl8I5?=
 =?us-ascii?Q?6tGzYMlj0zssi/L/ZzaWdBPoa0CHDOevPmQiwB3kzLuAphg6qmw6UpGqpKRj?=
 =?us-ascii?Q?O05Ou0MyuwKTE0LTirtAgQeluzahYkpQBqmM+tzBa+SeHIJQ0Cm5N1jj3Sh+?=
 =?us-ascii?Q?SBSSTyKGNg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aad7e03d-359d-4e8e-9ecd-08de75485ea0
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2026 15:04:42.1493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fWJo2Om+imwJ6avrIwUp87/XOwEwsWbcrz/GUNoPlz5Sx+J3ZTYVvUxGz7cQ5Wk7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6126

On Thu, Feb 26, 2026 at 10:11:56AM +1100, Alexey Kardashevskiy wrote:
> > The flow would be some thing like..
> >   1) Create an IOAS
> >   2) Create a HWPT. If there is some known upper bound on RMP/etc page
> >      size then limit the HWPT page size to the upper bound
> >   3) Map stuff into the ioas
> >   4) Build the RMP/etc and map ranges of page granularity
> >   5) Call iommufd to adjust the page size within ranges
>
> I am about to try this approach now. 5) means splitting bigger pages
> to smaller and I remember you working on that hitless IO PDEs
> smashing, do you have something to play with? I could not spot
> anything on github but do not want to reinvent. Thanks,

I thought this thread had concluded you needed to use the HW engines
for this and if so then KVM should maintain the IOMMU S2 where it can
synchronize things and access the HW engines?

My draft for cut is here:

https://github.com/jgunthorpe/linux/commits/iommu_pt_all/
iommupt: Add cut_mapping op

Jason
