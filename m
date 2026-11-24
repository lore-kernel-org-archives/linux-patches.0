Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.32
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795532934;
	b=0+hOpaU/O1x4+pxvDlfJHkJ8lWU8KEjK6prGIszZGby4lDsnWYYCzLLHU51CutUlppLA
	 26AXvtxD4W6OFixdA0jhRBBqAnHrCVto63NCH6Rx/tANTvCEMqwguk4C0bxLLmAfz0fYX
	 qdRBH7YrwqgkM/7/JB5v0ayAenWTSSc81/2UyqPepVmlhwywZmVGcukjIn9fn7DxLcNSu
	 tjd/eyf9+pcVoYokb5mxFJzDbnhOzp92012AWwSlGmF4l2+ky8iJoyA3mIBgCeXuHdcS0
	 r8fLJM77mEOR4vJWPDuDmzNv00lZfXRbQhscVmeTarjUsdzHkidmdXXR6xRiZof0C7g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795532934;
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
	bh=//Ui4esF1Voj9IyBK6IL/pQOihG6TXNtfV1kLTKEK3I=;
	b=pSheYyL+FEks85E37BM/mf2Tdr34BKnSjpfU3zx7e9vc+GzF5avTkSEjyZLWofB6NngO
	 IcHoTJl0vfbUBCO3ZGm7m3tLxtzSlLrJ17YIXJEcu5Tz85hzzR3CWidkW36sUg23Wp2my
	 bAogMzihsxWXW1gEQzf7pMs0uFPUdbcKTTDFETSIVF8aLDx34zocz47Awb2/gzUVtx8e7
	 5lNBEHrr6M3SR/aDUMJkah4SEQQBJOOsKTbtq91mCXpNpcj9e1c/RgsRXE5sWoY6h2ndF
	 yTPv0hdX+wzngQtGunI02BgjsFsm8LaWporiLAzwJ10+HHUgzi7FwJS0eNTYUPYGX/A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YvymbGkZ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.195.32
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012032.outbound.protection.outlook.com [40.93.195.32])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD8E606A31E;
	Tue, 24 Nov 2026 15:08:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0FD8E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YvymbGkZ
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZXtNq+Bhimer0mfkysmjs5Bsz2bLAc1EP+28773a7o5jucEyoEvPGsoEm8JHB2N3ZNgq05i7SGAYKxsWPV/K3mRifDqjR/v8c/x17+UTr4DiQ+kC4HK7QhIkrKHHbD/iFB0q0juSrEaxYFOkBLVzuzA7OOHidtzVDgEp6OXltfMgk6mdT8mAGHnHkPsx07XjodEBV36id2blkvvp91ZNeRjVvxYdoQ2mTm5EWFV07J3EJ3wALFi0FWq+v8Wh7uGFizJ1B63v17qaheCy2EVKfdIesliSuEXbRjlp5xjMVdVboseY5n/AWwcwMP8Mo4yRvLhJGm2AbbxFrhpY2iSSSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=//Ui4esF1Voj9IyBK6IL/pQOihG6TXNtfV1kLTKEK3I=;
 b=gsQXeynOZTsu3NWAm0+lunTxgdmNeqCseSAFgUxmZeafufwfeaaDdShaqzu0X2Hk8/9wVPcIgZdLk6JiLPRdyKdnl3NqyBK1JO/kXwvN7/3D1GSbChUzS5f8PbocHeGWhNlJu6xMcRmYDPIBSBDIQ4v8iSBeRO1tpjMnUaZV2IyeQsTZC9C/qWI5nv2gLQdfoPmOGNJlVeNkreKLjsVcdRIl+k+H5KuNlOrIRb9X5cnv8oiiiMKdua+C4ovnzDKs63UpGBcu/y3elclrdLWTNq/r+YnIK/cvtMWO5KRYcAknvixBtH50QzPJfIROr/STSfjtqzeKt68TC3AsRkUEXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=//Ui4esF1Voj9IyBK6IL/pQOihG6TXNtfV1kLTKEK3I=;
 b=YvymbGkZ2Mh/WvZ27BZNPLjE9DfCi+D4UHa+FG6godD+zvkHIO0+hUgKGRDtkakXOQpWOE360JvXOPwTIsRuc8jhtCRyBtVlyGalqmHuWoBcyogAdTyVxy6hDI/EggwOlK2oCm73MJ7SyKrBL1cds3+PEVZvrkYc7bP2YVuqtWgy2GdNjfCys6XEwFqA7oVlxHnFQ55eCD24zdZAf+M1/DcjGo24tUH/FRbQniHfbGQskqEleKW++MFqG1y4kBUASDd+2xS+Gf7uxfqkHJHMSHO7uf3nAZM3eH6oIhjAltXUIPdo83dqdu9tJ8trC9ohGeZBtxrD04dvnMAJ30p9OA==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by PH7PR12MB5711.namprd12.prod.outlook.com
 (2603:10b6:510:1e2::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Tue, 24 Nov
 2026 15:08:45 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 15:08:44 +0000
Date: Tue, 24 Nov 2026 11:08:43 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	John Garry <john.garry@arm.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 05/13] iommupt/kunit: Skip test configs without
 supported features
Message-ID: <20261124150843.GC8680@nvidia.com>
References: <0-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
 <5-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
 <awUg0O0WQUBcuUvC@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awUg0O0WQUBcuUvC@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0195.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::17) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|PH7PR12MB5711:EE_
X-MS-Office365-Filtering-Correlation-Id: c3d23114-96c9-4089-6269-08df4a3cd4e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|261021135927099003|10067099003|5023799004|4143699003|11063799006|56012099006|261021123027099003|261102123227099003|261021121427099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	imE1cL6nhehvZoDE9WHLuNzt4eXbCO5cU3GlVzB+xmcfGrv/AQaxgZHFkGNZk3hjvgBC5LYhefe2/IXNzpBQ2j3gu9snI40H4gs+4ZmApxnzy2s/0OoqiLPUYbnc4hab9Mtqu/UV87IQg3b+5unWXhniArpkZZr15vFxuoCHlwxHZGzpZMBSoX9W7gnPJTknhKcBlO0ULcrhD2vw3Hei77pHrMzHHgo5SM/VC9EECjWTvIHiaevwz6l4IEaBLsUwGcbt3PW0Ok+bbJApnCRdX0hKNLFzmq3d95hKkhkOxFRSZEmdbx/Eh97pjwfsIRqULG+QnxMOCESKiK7IuVxUTFI8WnJhaLu8MrU0gvfSUlg41ADoZDdDMx+6Lr8zmanghK62rJ5E00+Fsv+mOAQLyzraF1GvSjU9p1dXdeu7LLwf0dRV4fJowSLtqaK0ZUBwBpzB78xW5T2WF4D7pEo8vtqTgUBJ08Azvzb7RLNfWuTvmI0VF2YApcMTzma8wQXoBw/Fx5rKSAQPmVFYFSNKgPzY7B5IgCpJiPG5VmvYQrzak/K2CvE3HubkYDJMW940QIsVdgizO9uldgNKx8HWIfLwNrsybEWIRBG6ipIkoptbDGxX6zMRsb88QDY0gatun4ZSq57pqeLfeQWwTHTF9Cv1MRT3KskpDc2V2t4avpc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(261021135927099003)(10067099003)(5023799004)(4143699003)(11063799006)(56012099006)(261021123027099003)(261102123227099003)(261021121427099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PpvzhZ1tPrab6AqCVc9D+WH66EmGbh50wGaZs8JhCU8lYSWX9wamwjZlPjnt?=
 =?us-ascii?Q?uIe1piJW+VPjZdcIXNbqAXNWFvsucx4XxZWZpTKpYadTY1/gB+qoX9p7yeKP?=
 =?us-ascii?Q?Y9ihhUg1kjvp8Tqawbo0JJnvIFAgJdJ7AxFLuq8xgNRTvhc9IanYyIrme+P+?=
 =?us-ascii?Q?idMM/p50MqIibdMtqDCvssA3zR870xCIiqk5/nV0ocP6DUd522+BJR9hNNb7?=
 =?us-ascii?Q?dMESos4Flzy8/P8JSGExpr7u++ftpdAKwv0H1rSG3mMyqXVVoKwmK1zbjGdm?=
 =?us-ascii?Q?M5vE8n8jt1gVK8mbmKAmuTMJsP0AR56iouxnMkRyhy3f73o21vQbR7FjB2hI?=
 =?us-ascii?Q?CcZPUA1kHSR/gYr5PdEi5bbARtHDgZ9mNCgsRmrXx9zRNU04/xtOIlensTJd?=
 =?us-ascii?Q?VExWkrt/FdHAPNAMiXcXPY4GPPsKsliPNp3ZzSkBnnD320K/w6bsCG8KJXbv?=
 =?us-ascii?Q?RdBzcnoanRxvcen4ZD7nWaiu4n1t+eRDF3qa0aJtl3Y41i5GMhtHoZKf4F26?=
 =?us-ascii?Q?vqRRk33T0ArBA+pgwSiE0ZRMMZoFNqbUqaSyvrVq1Oydvw4+7iGBW33ATIny?=
 =?us-ascii?Q?FoTTcf/TnbVJlqRn9iRx2du5HLFYGnr4SMVTSRAjAeavwSOh19f00bcIs59K?=
 =?us-ascii?Q?vuGz+fcSy6v8Cq3ggtYMKIhgln3ZYgTu6QDmYbBA1EpnPzaZ0TLBMuuFSOKy?=
 =?us-ascii?Q?7k8aIyS2N+5Cku8PMQIwImckP+iThCDnDpz2879onkT4ZFa+4DWgJaLU6f1/?=
 =?us-ascii?Q?O8mcJ5SYjvpQ4TheILgRC/sMnni8s9asG3+HWRW8nCmadhuw7zrk/+fJr1R7?=
 =?us-ascii?Q?bkVIga4idKUi+Ez5hgZOUlz6G2HBjSQFmdTug1Z7WCbbFsSLHhln6b+5zfrD?=
 =?us-ascii?Q?IkEuyOL+fpBBZQ+v9sEX0+ZgzKiAg8HSIj4J6BHBQahPAPgRVvGcWamNYpjF?=
 =?us-ascii?Q?zXija+kNmf6JlkrsVDaUJKvjuCEE4cNd0OmnUlPXPRrWEdRTH21QlZR0ONr/?=
 =?us-ascii?Q?H4bWg2URNzMFFGb4zCp6wbVaINCLQC0bDMKtWhyCWy1CBljYkT+0AtkGptZb?=
 =?us-ascii?Q?yKbzpFewKJlTau+SJ49w4LWVDZm8d7S/0341Pm92sCOHqmuISFQ7iFHXN01x?=
 =?us-ascii?Q?IZY1ZNT9rI6yKsDysxw4UF7l/fnYIz6aOxkXe03c1UQmnFRiysl/lZx9dV+f?=
 =?us-ascii?Q?f9xY8J+1850d9Fcie3cJ/zDIRIK6qY7wH05iCOzvvMM2HzIQ14pmcy6kioAG?=
 =?us-ascii?Q?ZPYBAO/mYlqPEkVWfK+Z1x7+rMmK1AjU3oCuOLAXVW6f+yHsuOS/4egT7OXw?=
 =?us-ascii?Q?Gxqugb8VvHIgFtrLXNVeL/jV+2Y8agULu+/MpWclsC28Ac02y8dAPJWHtOp9?=
 =?us-ascii?Q?B2cONLJAmz175DGAU8RnSA2TimZb/KRAQPeFO3RDnVjt38gHFuucIhXQ/iro?=
 =?us-ascii?Q?JCL87N4y6jV+tvCoItK5kzVNbmVqgxuaUlN0QAH6ffb6iHtfgUAqo6tmqMrN?=
 =?us-ascii?Q?W74FB6JWBeoRdSCRfKrGD3p2kM/kyVDNWosEyU68OO2y/xsSBs2xw7eZNER7?=
 =?us-ascii?Q?FvpqGkJn9x0nSuPuR9RFWD4cGU3AE+6IcgmcyfVXmteR5qC7d//4yFm6Ig3X?=
 =?us-ascii?Q?neCmL3+luQaaUEOL/gtwzZhhnIo8/7ArPKEC5eRXkW3l3vubazG5LcW0xRzg?=
 =?us-ascii?Q?Vfs9Hof8KYL0kNuL1ZEBiEat7bu/gBcvTuvKaSDrvZ0ezCIk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3d23114-96c9-4089-6269-08df4a3cd4e3
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 15:08:44.1101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8OHujypUyTuiEd7SFgzpX3k7T6nZ2Cs41iV4onAJmrgnMcpduk4qfQZJyzkgXuTf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5711

On Mon, Nov 23, 2026 at 09:29:52PM -0800, Nicolin Chen wrote:

> The leak check reads NR_SECONDARY_PAGETABLE with global_node_page_state().
> That only returns the global counter. Each CPU also keeps a small delta of
> page updates that is folded into the global counter only after it exceeds
> a threshold. So the value can be off by a few pages without any leak.

There is a patch already in my tree to deal with this, this test only
works when you use the kunit runner

Thanks,
Jason
