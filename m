Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.31
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795007802;
	b=Uf3V9cebsFI0nXQ3roJ8KPCZx+SuZgMLZnKbU/J+KDYrUeWX7WR8P5aOMKyCpKGdRV4B
	 pz+gORdXbMrJvw7736tv6UMEpbqeJ43Gu5CoGSSITi8ixnEXtIXI/fQdIp/hdI/kho4LE
	 pSG9UYX2bP5SvYK3wsU4H8uQCDDBytvrDTeY9lCxnArsZxZBrlJYWsHSChacn67e3gZaj
	 K4qy3gD5sHdkS8T4b5xDjzqQcNpu+1AnbPSlkO49dXSJlmI1fietfXLbS2imRyeWONcVV
	 Nz4wqwH/6S1JISSwJSWJHeAumbxRf+uQGNBQfyq/tqsa4M4lFohSO3MdFfzCB6uOftg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795007802;
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
	bh=QlnU4bFVwEZV0RwwFTyZbV4JlOEBJpwxR1JwaM3Or9w=;
	b=QL4D56qvksZj7XMFFQoc/jnu/5F2zOIZIiKlhm7HsqcrDvaQIuzRwX7YvrjSTDeQC9AQ
	 Bn4GqB7eL+KFow2wg8lFLFrfISIfKxugDQfZ3FvXwvkWiS36h62QarBW8YNqgPzpCd3s/
	 R4m3MfyshlJK6s9qBS/5sDIaGsZdQGxBuAMfOrT1qJzRH5tBSdepKtPvWfNbXgyzFTAlh
	 xdIo1esYrBIk7V+o0jAkMa0ZqiihaYjApytuBBomNZ0RPdAQtOHX1NGg7rPr32PA6WA5c
	 zGXah9KVBBhcFA9T3mSTjykkcUDoJ9GUqb+Z18GReeoPhwBvEiVlOhFASYgPVnT+wWw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YykeULKO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.57.31
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011031.outbound.protection.outlook.com [52.101.57.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31B3606A31C;
	Wed, 18 Nov 2026 13:16:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B31B3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=YykeULKO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i8JPKswSS9xjWreUO2D0JjeVDUo5t9T1Nqpr+OBdPT5HeX1F4YLIE/LBfnzWVI5CYIfCfqv6ZFKyMZsi4Vex6SAkDN1muon0Y7RFgT1Ndu9zbHi2hEABkXn519rq1TAMyb002zidAFX0akMzSexJ+6jVMZbnTH3jrX+QwlE+bCttb2gmfW0cvKFoXEef8MCYMfxn79prOEzD1fna6EGn8v5mJywU0sPZ2xKXd5t3fTqTQg1mkakF7SmF+eIjIK/7/2ysXVE/DaT/kFNAuT2MrpxwLlEKD8MDPj1/+iZgovM9QJPy+2S1REW33SfAutOrChycqj1i00lfQdDzK0Rvmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QlnU4bFVwEZV0RwwFTyZbV4JlOEBJpwxR1JwaM3Or9w=;
 b=jeZVO38c4nl/YZxs/PeJVILepNJ0xcIEbPzW+HY9UG8CrHU3DUKw+SHMCkMBbeQ/EE/x1D6XGemXa8QKeatih/GZJFECm+3Eo87GSJhX9njszhtybYJqIZHTKCEFYo8lTG/WqMNVs+vgVmqjwJZ87OjqbYfrayBOwxNAtWONncG/K99X/KXBEvsd27ufJEMX4trMHgXctzXYV6iQpRwrtspYL5oqB2t86zgFijA9W2VfuTFPuwETvFLHmlvdG/y0T71U34BiO0WhVlQ3xPO7DEJsEqKWav9aAA4LcD9yPVjdWNh6eS9sE3xPz1a0dZQAP9riDldaGQMUvacZk9wBeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlnU4bFVwEZV0RwwFTyZbV4JlOEBJpwxR1JwaM3Or9w=;
 b=YykeULKOMf/bTgs2TsTG4LosSu1+48hM1yHyOgLudaCDeh//Bm09owoUQWv75llnHFecHWWgzN9+00cmlcALiirzrPDEQHFMwqi0+SX6ZYm+zQOCYgYybCKDCRQnAKCQMcpCdHQEwEss2vDeAsa1UL3VsTFQFzlc8sESP/QomB84OWPED0Hg93qrjv3dFOOh8JpVdJRB97v0FFpeR94M5XdsdTaLZN2vuV5Pw+T1mB5W5SrjrnY4TZgy1xUbni9LdHHcznn6Qv9bfxbHSc1EAUnTBkyMrrfGZQ8643NHE+UQLMoMWHhtrtxnJ5m+cyrTxyoSWYp5m7p+HoXh9T3YEg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB9500.namprd12.prod.outlook.com
 (2603:10b6:208:596::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Wed, 18 Nov
 2026 13:16:37 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 13:16:37 +0000
Date: Wed, 18 Nov 2026 09:16:36 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexey Kardashevskiy <aik@amd.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
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
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Alistair <alistair23@gmail.com>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Message-ID: <20261118131636.GN2245175@nvidia.com>
References: <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <yq5a5wy2qtjs.fsf@kernel.org>
 <20261112145254.GL738765@nvidia.com>
 <DS4PPFA84FA90FC465DE2D4A57521CEB991E77C2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261116143319.GA2245175@nvidia.com>
 <DS4PPFA84FA90FC9031C253514720694AFBE77B2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261117142027.GI2245175@nvidia.com>
 <06d99ff3-3fae-47df-a27e-f2b45d8d3852@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06d99ff3-3fae-47df-a27e-f2b45d8d3852@amd.com>
X-ClientProxiedBy: BL1PR13CA0014.namprd13.prod.outlook.com
 (2603:10b6:208:256::19) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA1PR12MB9500:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b2b38c5-27d3-468f-73d6-08df45762d09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|18002099003|22082099003|10067099003|4143699003|11063799006|261026140227099003|56012099006|261102123227099003|261021121427099003|261026121527099003|261028144727099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	nVV5Alez7dfKVtGbwUIgn6Y3IYWJUW8xeZneQ+gKtHO+DvDmdx6/lRDJuGsJsDSrQjph2Fh5nn+cQGuCd7lFQCc0BjpJ0gAIm2Enrxk8Jm91sZXUSI7HlLu7R/LYxwusQ5G8ogr458JGHnVrz93BgGRl6TZnWzj5kxybm7jDiDrhqWM2/EgdGURGIb2sTVihAMIrg2UlcW0Dkwk4UGUK6bMaxKJGff4rDCt5nclKXgOmsHVJo6svw5dDpIX2OGNJrYY9cDDFPbAobEftHFDBD3PGhq/87kWHWgl+ztLxAWjoQ45qNvFwsibCRa72oWFl59XdfLQ/VeQpXjhXjKoj3Xy7c2u1YpsutRPdl498ViH5LXzvsX5chMidbCnaD6sRd/fyjWx+bPvtApnsvDxQyS0EAV2QT+zYYWWDaBumSV+VbkMqqB/EHNdMIXJ12qmouVSUzHScMWCHWwQyQVoZR27kAvrB1SVExWPhDnxE1bj0n6NpuacyfhapOBB1wms+vY9t7iJDsztdhUKuPckTFQgVNb/cYi/nQwu2Wd4Gl/iBEbCH1gO2HZuO8ylZ/S8IzzwOXdtFZKVyjlBtMrllGJ8cvDR5pZwzg5bYp2gM14u90yG9JPYQiYTzXWBo3Ybh3kzbBiGsirrI/FcPbtWFMw17g8D2SYfeFePb5a+yp18=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(18002099003)(22082099003)(10067099003)(4143699003)(11063799006)(261026140227099003)(56012099006)(261102123227099003)(261021121427099003)(261026121527099003)(261028144727099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lcdyxGjMTOtqOq3+D5AjYd4+hpV59cq7yw8XjmLJ53t7GwAzrmZxm+2nUq08?=
 =?us-ascii?Q?eKyoqEKPF5SPbAiXxdEeHtVARJuJjFg4KQ6Nce249YYDtOFT4NnIZoWZveHa?=
 =?us-ascii?Q?bsYtdNF+pLHqC4QYC/R9I8ySGjSUO6pP4McPDFwjf8615J/GBI2AI28HYHl3?=
 =?us-ascii?Q?HVSqkakYFSaYwZCgTTe3NJ6XAo6JJ8uMN8K9onrAOfLXBw6VpmdZ6go42a32?=
 =?us-ascii?Q?WL1dmS9YQ1HeOW1yHp9H4M5ZVmT+ziJgPYKBBWNOSoREs5FnDfQ0iT/jTj+B?=
 =?us-ascii?Q?kV3pHWqeW+J3nqPgRIBDiZAXB83SIDfjVM9TYg9JTYbojhcPDvbGsSXDbaD+?=
 =?us-ascii?Q?N5T3W9AVTRs4XiFG+wu153pgxwAN05tqMmX1XQ2u/p0BmYB3GWsjE1pkSIWi?=
 =?us-ascii?Q?TycS9Y7sQ6YKq/rfzB/vMFiHBorRg9lpXeqHwiq2Yw/BmIAFFBHxocgW+0mo?=
 =?us-ascii?Q?57FwDLGk6Tw3p4/U7sZmz2I+whk+uhI/4tOjLhnaNV7oJPNKZEzkCs+vtmrb?=
 =?us-ascii?Q?eZKWG14vluwMpGtih3wILQCpLn+J5ogo7RIP2xEvvCu8oOW0wY16vblXy1u7?=
 =?us-ascii?Q?XlRomaaeUapvJnkJh5Vu4urkHJdW48bzKcWVXB92suIgxss5mtEdA2TuhKng?=
 =?us-ascii?Q?Ff7yXOWOgjcjEISFaQsZbXarCYfrW1zcPxBbrSrzg45OpcLfjI1WR5LQ1V+A?=
 =?us-ascii?Q?AZM/SYf46hGuVi2fErkqXFd2iyWeRcpcDjBPxHuygxHIj51I0AF8ukA4hdbO?=
 =?us-ascii?Q?seag/qzWJ3yzKUmXHlqSz2+QiPKYMpT1Syb1H+NwBfVa5gPIXLz4Ov6Lpmis?=
 =?us-ascii?Q?Ht8/e08H+SPmdKVY/vNE2J5wKog3TIQezSK7voj22kAvPRsJn9B/EqUjgk8E?=
 =?us-ascii?Q?63iBcNPkWVEzEFhnijsR6zmU45RU9Flxm5Of2l8Jr5FtF0mU6hJHc+az1lUH?=
 =?us-ascii?Q?c8J2PpTUBjFYJ8obNex+vNjHEuYJxjMP2vySIHfYyPiA9FH97qS2KlASg+Rf?=
 =?us-ascii?Q?7U2PCw3gSjKH9F1ShA7e/RGjEdniqwRKRgr93tZXHzAsAg5VmpEzey8KI8lT?=
 =?us-ascii?Q?bCLDG3i8Wwj7wRktiuAqYKxWUjQcjkrSfFCtAzj3ezNS4wwFzjIx6PvGwdVZ?=
 =?us-ascii?Q?68UKkheXTJ6mLvldoeRN3GenXOLAMRgYfZtdlsja+oDXXfoCwAsqywSUeGc8?=
 =?us-ascii?Q?bAxts472MFbFNzV1AJYq8xMfQjM3YJf38QZJOnooLa9zIGFQu/sciRPXU97q?=
 =?us-ascii?Q?I342s9x3se3iuQKslbs2ek0bL9Ub06HvLH2nB0JFUUcQlXrH5P3v6Da1Qvcd?=
 =?us-ascii?Q?d6JHBZbfATOvIEda+2dUpqpeL75uNNR6Vzka7Td414CKpPhx5vL4R/JORRVZ?=
 =?us-ascii?Q?Ehf9+aEHkTTtlzDUtff0TjdrXjQrOFZ+DlbtXTRPMfkjdWUgplTlam4YIPo9?=
 =?us-ascii?Q?UUMoqW+kxSRXOpPmh67ZfrSFStEU41Yg6hEaw0YX3fCYbCsV9npfsWUTcpBz?=
 =?us-ascii?Q?9Z/FDoOTIGb0lUB2nPinijhIBYjieA6w2HZ2+N8KSnxR9K4gjlFu6ZEzB+ab?=
 =?us-ascii?Q?zuQWu7Kxjb9jmY77cYHgBf5PjlFW3QhDbzxEGreWAIBaeYJ88W7XcQXfAdvx?=
 =?us-ascii?Q?FosgYvNK92GOUXcHKAx59R4+uj/NMBDhbGQIFdKKdEo6LIO7xulbvsiVibeZ?=
 =?us-ascii?Q?xesjBMZYUzgLIHLe0rV+2xV/MEnZAlwlOwyG4YTj7Dk3A/bT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b2b38c5-27d3-468f-73d6-08df45762d09
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 13:16:37.5259
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GRXOUeUYwQCRhP6pyFSjhtetv9WMOC6oS8bxVn8B/E9LBRXn9fl/vYJsxfCQTMu8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9500

On Wed, Nov 18, 2026 at 10:12:17PM +1100, Alexey Kardashevskiy wrote:
> > > Btw, does any other arch provide #3 today? I am not able to see this in ARM
> > > spec at least.
> > 
> > It is coming, currently ARM doesn't even allow the host to see the
> > measurements *at all* which is a really big miss on their part.
> > 
> > AMD is probably broken the same way as TDX is right now from what I
> > can tell.
> 
> The PSP always takes nonce in DEV_MEASUREMENTS and updates the
> digest. Nonce comes from the initiator, the updated digest is
> reported back to the guest via encrypted VM<->PSP GuestRequest
> mechanism.

Okay, so that means it is broken too. You will have to disable host
evidence collection once a VM starts using the device.

> > You probably also want
> > 
> > 4. TSM controlled nonce
> > 
> > A way to put the vdevice into "tsm controlled nonce" where the vdevice
> > evidence collection no longer accepts a guest nonce and the TSM
> > provides its own random one. This would be a permanent choice when the
> > vdevice is created.
> 
> Is this any better that the initiator's nonce? Thanks,

There is a certain customer that wants this weird flow. Ask your
architects they probably know.

Jason
