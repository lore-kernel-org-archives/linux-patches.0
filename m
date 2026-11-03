Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.57
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793720481;
	b=gC4FGD86w20EuNKzkca8UviKm5r3l8NfZug5HtDxDHNMdp7pSEYVhgby5tq/jN+C3nFJ
	 HLKn1mC1wT0rqBU4YC82UIhazPk81BoB0WcNFK7dzBSUpXiWjFS4SfRT7UPYOG07DILcA
	 EwYv1g0y4t/dMwGHxJzfjmNeKZfDzgfT/E/HxeRyz36xKgI9ugI2BBd02cYn6j9AU3Fqr
	 G/rNSERCXAUeEIIv1hlWBxsH9eeyJW+kTaI+WBmlj03LIYYgySWWDOEg9/2bGoafM7+hh
	 pX2An7ehnyklgTZw+G+phzRDZXt6Q2ewSCrq/nhob10g+sTTuE/4XnFX+le4uJ/kdrQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793720481;
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
	bh=Wlj62KRLtS2ogMTcoFuk83ipnHn7xg4HOYRaihchYmg=;
	b=MVVqhwMx0d1RDFGYlBmjhMSMHz+nSL16D1J3J0rrL016J02uaKngWtL0JtqC0QKoOOo0
	 gjkqpEotvGjL8g45mrlvP1SyeF/o6pZPkfLNxmoN04ILOnZUQpd6uiUEVrSp2usB/yqGU
	 NFleW1OgSiw3njjPHxGRaRlOGwqowl2QMBJi0AnnlL4satpEFXzLn3YIN2bsMcFdb9j5Y
	 Dy57TPagZEP/6RUQqKEHhgH6H+F0CIt4qgAgBT08DdzZc3NcRx/9YPH7/wQd+ocVXIB4/
	 bSZL9bFRcA0jU2f1h+hMyMVxCKChozPwQZiLyCvewDf8NDt5IIksBcSL28K5ouQiPyQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BJlIum9D;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.57
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011057.outbound.protection.outlook.com [52.101.57.57])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F81606D821;
	Tue,  3 Nov 2026 15:41:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14F81606D821
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=BJlIum9D
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RehJdCQxAEX+E2BToo9Wo6GipmNRI9v9LRIOVRDvSy5spUsdc+9HCNyXGKhmXuU4ncoBGZzv8TeenonmPgiTjRBPAmPoMEfhdC6C1P0HAmJlVdqB7J9X9e11xHfn9Fvm5LrOVxOBtkhY4QvE+dW6j1g5Vfk6z7fVbe1bGEfpt539ZQSC7Cv9LXxENKnS2GedOlgcGkpoKV4qXwcyxIqd7hQrNc2Kw9wFhZTZsuTuhP9PSKaVcF5ThJRNvjntb33cRSXSJxZBWroBVL52l03Nz3169hkoWWLq2ISwgX+qnDMTw+nyeticEzIXL2phdO5suhUe47QDjhlDfjvi76rJtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wlj62KRLtS2ogMTcoFuk83ipnHn7xg4HOYRaihchYmg=;
 b=AOEFcOJWHhLxOdy5yo0pinfZyiO8Zeh2leeCe/9Rt4dG2BOpMgBsJGU6kuBAjOeuW1qOblvPh48HQKN2WZ51mbZUEL0ZEqz5PMvpzZjAjP6ev8IMWywDTpAykfSRMGYpA72uZFOEDHxWAiWe/GWtFwZat73lx9k5kvy7+9miLUFZFLaCZX+dgS5yJF1CrVUSZEOKFrf+4XRycuRXZjofnJi4MCi70IsqkfWgys3EX0+LMqaODzjAPYaW/1KnZA0As2k0SDUXs3heA9n21p+XsHEOUEoq+8Rl6joOwn/i+uccZp420Ui9Jx9LuG/36eWdLK1PZeEzwZ9UHlxxsHQs1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wlj62KRLtS2ogMTcoFuk83ipnHn7xg4HOYRaihchYmg=;
 b=BJlIum9D1+1MZ9TAQcuEI3eZKpHkR5ZEiFdD/+Uck6R8BuxIBT4HTviIJrFFc4qwMlWFP5i/FJ/uPwNGgPs4P0VOSDHzIsdXAPCDpjmpUk0dRs6PuXidmulGFmlGRyfWVftcTbUraLVrLigYD2I0K/viuUW69Zy9ulAt/WmRrGc03EwfcVdi3tyjvxkOKtWSi1d1/5fWdY13ngZTLkz6D4B9FibMvESo3nG/m9IBnV/2CqiQ7Nl/m04pVGYmFYg/IXXsXVDcYnnl+g2Dmi0+E9KhQfnzsELC2UiVT/TWAr7b3IFMsimNECNSHVe1e9Gz4dLvOhW4Ii3Vjc97MT5bDg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by MN2PR12MB4205.namprd12.prod.outlook.com
 (2603:10b6:208:198::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 15:41:17 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 15:41:17 +0000
Date: Tue, 3 Nov 2026 11:41:15 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev
Subject: Re: [RFC PATCH v1 08/11] PCI/TSM: Bind CTLV attestation to connected
 and locked contexts
Message-ID: <20261103154115.GL274202@nvidia.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-9-aneesh.kumar@kernel.org>
 <auSkHORl2mg_FiOf@FV6GYCPJ69>
 <20261030153900.GM3734323@nvidia.com>
 <auh9uIC0TrR9pAZR@FV6GYCPJ69>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auh9uIC0TrR9pAZR@FV6GYCPJ69>
X-ClientProxiedBy: YT4P288CA0036.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::13) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|MN2PR12MB4205:EE_
X-MS-Office365-Filtering-Correlation-Id: 3eb0d02f-a2cf-4a66-c8f2-08df39c0e62f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|23010399003|18002099003|22082099003|56012099006|10067099003|4143699003|11063799006;
X-Microsoft-Antispam-Message-Info:
	MT832mwVNOUPe14AliLwJ3uinh8wOzO5ne1YTnvyEEodXMgRffxZ1/EWs/q4MGOSuA3JLQ6i+L4lj2QqjXITCFMOO91LZm51PWTm7j4girQ/Vmaxc/MO3ev4XJU28Ls6QX3Xr1dIqVqK8B6UH1EPPBKfJa+H6AVlZu6sQeT4wQU969VH/GSx+98XJEQC6542Nrq9RItGUhu3Clx6y4k0YzbvUNozmGH8qo47gbl33cIGURR3u+hWf4xoxooLXP3zPehPee1g5wTIFFCX6x9+XsdsbGzK4IhnU2ok5F5j8ZRRScFfLNnar5vk8c+/rU3hFqtkcTKx++Tawfna3ZHbGAQrSPPF3lTzvnLqZKhSEdegC9JE4JIZmnhBNvBAxJUNw/Kp5pmPAq1si5g6P0pQS65rlqOOQBidXPF6OzK9h7JgEbioZgkDNvCf3kXnL+t8grC5WJ0vWvVzKLuhYAMYNJpf1bKySbFkLwkrdKR50XZ/M/7uDdZ2fOAQ3kwM1DzGqaSwK/lsM0yV3EmH3anc1p8GNW/pG/SojHHFm3rp09A/UC4tGYKMTXOWa1m9+q3Yf6sBQilBtGfWz3t6Cl0c+OCRK4Ii51/fDcUDyHZRg+/+OduBhOb9GZwtrmsA3xMLuSGe9y5TihVAgEL21AhI++gDp1nqcBX3vtK3esdcjP4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(23010399003)(18002099003)(22082099003)(56012099006)(10067099003)(4143699003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w+HR51cHCYnxfU7aKYdVSOvG4yWzv4pXlB0N5t13k2QOjTByU+K2uLchve+A?=
 =?us-ascii?Q?qTCvOwBgIEMZN7BRmZqMc4QppDjJSp6PwacNvI2TVvmLASt2RxlJPvje+MQl?=
 =?us-ascii?Q?SSJFUIXvxM29jj4AJQLzt+WpfbCtf6kxUMyHnRzxl/+2ir7u78sdiV1ZblO3?=
 =?us-ascii?Q?QmRsN2E9S0a9QqKwplhd3Quu13hm9Pz3Yq0GbANNw2hXVxB2Vt5tCYfoD9HU?=
 =?us-ascii?Q?MkOPNXwdKMOE3vXht/EGWlV1+/xeqGC0WJy/a4zNjEHsv8Dw9D603plDEX7X?=
 =?us-ascii?Q?+fZE5KJCtyqqc4tFXoHGUs26AfEPoI/FMME2vy27lbO1MPvChyp5Qye8APeI?=
 =?us-ascii?Q?siONXn4uLKtSaNZVTUuZCcx8IrTQr+ihfZsOXCe3AJjHvOlJmH7kFt55Ihs6?=
 =?us-ascii?Q?hSTvmdnIEnW0rvUkGITACShRchWYys+h+mNOcAoKsMtGORijhUpzbZAytPD7?=
 =?us-ascii?Q?lfKWXx2NtAYnj7HsZ26L/uey+LKu6YBs5VhhP5l2pNFQUQErf6J24dCfqPg0?=
 =?us-ascii?Q?g9B7otpTpdJ5gTswhb7zgSyCprx3E07K2VuA5RchdDYNXsxsMQpty+1F95ib?=
 =?us-ascii?Q?h9oXHV3LBkRLSVQI78eLFYx2LXiixgwlGfH5Aaq9p+SimVEuSi76xdgURymG?=
 =?us-ascii?Q?0PrbvhvT4ivnYIFEOsU8E2QThmD2uHFQyf3+BHhajmS/RpyENvbXqWuoUdgL?=
 =?us-ascii?Q?g3WoYe5aozyebZIIxo1Jk9+WXXGhj6NIlx9/0nQ3847KXVhOWkMc80u4M9ld?=
 =?us-ascii?Q?TutssOgZl3H9vfzoUDzP5a3sDYPl0gsBT5mqKMsZU8T/WEcsJsaYmjtu01Bv?=
 =?us-ascii?Q?WK6A/nsoOtZuqZoTO5JeVX8Xo/mU9aYAgAy5ZGTQBgi3UyMolMgybqaR1KKt?=
 =?us-ascii?Q?RUEi0Vv8OK8/A1JpVrAO6F8H8iWXWv7nFu97Hk2G/T8nVAQOwLuGish/jCF/?=
 =?us-ascii?Q?RXnMeSDGJxxFyjPnbAyVHWy/WuV6O2JWvgiwfiIWqoRCjHB/TEmqfu9GmPtO?=
 =?us-ascii?Q?KFR79u2lcv1egbuxGdbC32TTwOiknSnA1sFK5YvYCD3/zcZZB8NyqlTkr+1K?=
 =?us-ascii?Q?6jX0KZ+B0EwmlTyTZ8MKVP8BhSVSOGEsGVOe4QiSkLZ4WP+Z57LU4QpMmv//?=
 =?us-ascii?Q?MEGY4X8Dmc1Podq+PoI9otNq1OEpeARz+Q+yEDcgtlXXXYr9GXsr6qS2wfMm?=
 =?us-ascii?Q?W1dsTsLYaCaa57tJ2OGuJrwKxu1MwQOiY8Kl2meMp/iw4h0yGPm0v1egv4jr?=
 =?us-ascii?Q?zOlAxPFVYYlfxiKFlxBqeK0uaGjs5t8180NcunaCn25aQKkvNeSBNhkNM4++?=
 =?us-ascii?Q?RxeXIafqlEH/34Ev0EduptoZnuNShgeULP5V/DFWBdiY3CITLuJF/qNtcDJ2?=
 =?us-ascii?Q?I952pyQA33DQhw+/g+ElxRRcOI5FXfdPu3Aswi99DWSbHXHc9PwIoFL5sMSp?=
 =?us-ascii?Q?15QBomwB81rLNvS+o8tfyWYIAP2HtJKCfJImZLTPWHQRXS3bvTBbhuRilLBG?=
 =?us-ascii?Q?HIuDw3OHsWKkauDHOvSlOUur6LqvgGWmNUWNvi3z5V45HAsK0CclQx6DPgUD?=
 =?us-ascii?Q?O/Beh6PBK8ZdtRKZHbJsX0fm+MNyDk1Ox7eMCk27aU7CFvVurAN/pWI0lRYN?=
 =?us-ascii?Q?6GqMFAt8x39AmlckoBBd+MaY+SJH6WzralYmyhP605LAb3VS20qM45W5b7Jb?=
 =?us-ascii?Q?bAYziiFRzaIbaIDVzQdVz9ZcjQ2d8KubUhjS0BKQy/fJdTtX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eb0d02f-a2cf-4a66-c8f2-08df39c0e62f
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 15:41:16.9204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TxRMMv96pRL7z7MquFSRSxaZWhqLBgBFjw9rJes9VKfEueSWRItKTtdSLqCKLvSQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4205

On Mon, Nov 02, 2026 at 01:11:14PM +0100, Jiri Pirko wrote:
> >I'm not sure 'stream connected' is even right, as in my last note we
> >should not consider the thing authenticated until we actually pass
> >userspace EVIDENCE_ACCEPT, even if the TSM has established a SPDM
> >session.
> 
> Agreed. The question if we can legally get rid of it at this point...

There is no functioning upstream implementation behind this I think we
can purge it freely.

Jason
