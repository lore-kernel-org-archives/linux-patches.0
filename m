Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795009122;
	b=SNzfMsxBMGtjoG0Cr5alPeZjqQf+XgzsVNzrvDQ32Oe4vMqFGa29AWt2yQGK6K2glVKl
	 5wsd7ARcNORGjNRR1mdH1TPzsYQcsPITb7xWYrm9hBB70DcabdzhR28yNrm/uZM0K3yzf
	 vlRKChU0eD3HWCedkB2McpaJwr8F7+nRRfeFDJLepw0VGrOcyrA22ZvtnHJpibfV+wQMZ
	 TfVjhDmgjSZDfi67iUczZc+GEWDiylnTe4sgi8RwVvE9XoKeiMf09CpPpz3oMnskfMRlR
	 MFX0MOOah+YrsZp4DhFKLIIH04YY2G1soD7Mz6s3Aa2ae9/2wc0GiSEfqTrPX9ZXwiQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795009122;
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
	bh=j0R0xI9mO9IEKjsS+Y3rmlO9noNlGg/vGnLygUHKKgM=;
	b=J4TEjxEuE1qrdnXNpifz9TZ1hfXAkaPTx3srPIF3Z7cEKGWSvKgHlCm+qYWalUwwibYU
	 HlymUlTPCyY5HzdoxGJN50gL64D1/kiytOTwd0XCdZguxHI/cGJL7wkYicUScg2AcaiEu
	 /ENiDnX+sKo/qyVsZW50M+TPh78j3+Z9LWhXS67rHGWJZTfec7fwJIb7aN+ACrFWjEZzy
	 XgN0LR7hSRd3DXq+3bv8f8Kgu4OulXlnhKCZU/v7H7C0SVO9OZZgVS7ES3Y/k8EAyM36P
	 +cxQpK/S11E94b3e0fj9dOtUt9u3+slq7mrh6eKGWOy/2O9uGggR5m/FsWx2HlJKv6g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=llr9yyKY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.11
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010011.outbound.protection.outlook.com [52.101.46.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5171C606A331;
	Wed, 18 Nov 2026 13:38:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5171C606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=llr9yyKY
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aV7ezjVa7AXSisgRG7K9ZEjBx/kG3xtfX5Xugz2XMbYE13Vhbg59g5aysb4lScuwSfOF7Clv0ulyQ/Io2sfPZJXxuOscFvQpgbU4fLyZUOKhN+w059/GgI+67+IgdWZwrz/DKn1fL8KgplizpajgUEB64hVqkQUYM7VKPxpqnHdpLk+w6uFWl4ye7W8GG9qoluz3FVSXV44fdekwCnGM724lByUT62tpfvrV2rWSEriU3ejVhmee0UaZYnuQAvuF3N6VWusCWhLKHo+vZvi52JIz+t3DrhM5deXHD78MzitiGIpU1ezYdJ/LR9nF++/hiZ97O2AUfzD8w+98/GvyvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j0R0xI9mO9IEKjsS+Y3rmlO9noNlGg/vGnLygUHKKgM=;
 b=tjuoRHjtoaJv2Jclb544kTykS0mPm1yt+8uOcAhH65bMsC8T2NN/0Ja9eid+WB7FlysMnLFZwmil+ku4Q3V9A8i4xfiMuW7vH5HvbbCCP+1AWUyS0I/E/Hq2BB8OVhm9VBG1+S8HajwzkWQ2iLy3MIJBEkUPDjgyGHVxhaMlb+DYEb/q9XoOnKaPqixgMWg8HCbo5Z0aMl1a/QolL3JWA2ehckyQG8CWsEECG056XuO59wUS4c7mNAbIbkQ9CQScWSATcNERVrUbA2xGZSd9yeRfRXdbiQpLoi9KL4N2qgFdpadBPmMCSJznu2opbKYzKG57T62Ze2AB0W6sj2h4Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j0R0xI9mO9IEKjsS+Y3rmlO9noNlGg/vGnLygUHKKgM=;
 b=llr9yyKYLh1RRF5IhZl9svlM0wG8Td+lYTVjG8//Aw9UktreL/tYOijObvGh41ZfWIS8h6VzLEhdpkWdWolffRtb3YCwoqcnUne8FVr6pxSJjQ0/nIssEH67Cz4zIfAekx7kwFlZb8DnEB7cM1BHFpns/5fXP8tq8LgT0Fau/eLjj6ks6x0mLt+/MGHtlcU1dMnTndxLRod2zCshpSMDT1+FigJLyrDK+xz9hhULDaOiMXqeN9C6gKWUPQnTUnZ7k7PHAR2iz0TEQ99islSDKZZ/U7yoZFKH+4It3cBd5hdNq4yJkReMt8msEPoglKZWO9PkhLbRI+JRwpdQFffLRw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB8468.namprd12.prod.outlook.com
 (2603:10b6:208:445::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 13:38:36 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 13:38:36 +0000
Date: Wed, 18 Nov 2026 09:38:34 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
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
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Alistair <alistair23@gmail.com>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Message-ID: <20261118133834.GO2245175@nvidia.com>
References: <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <yq5a5wy2qtjs.fsf@kernel.org>
 <20261112145254.GL738765@nvidia.com>
 <DS4PPFA84FA90FC465DE2D4A57521CEB991E77C2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261116143319.GA2245175@nvidia.com>
 <DS4PPFA84FA90FC9031C253514720694AFBE77B2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261117142027.GI2245175@nvidia.com>
 <DS4PPFA84FA90FCA6CFA44F36D6B9DE24F9E77A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS4PPFA84FA90FCA6CFA44F36D6B9DE24F9E77A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR20CA0051.namprd20.prod.outlook.com
 (2603:10b6:208:235::20) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA1PR12MB8468:EE_
X-MS-Office365-Filtering-Correlation-Id: 2df227de-6500-4285-2f0d-08df45793ee8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|261022113327099003|10067099003|261022075727099003|11063799006|56012099006|4143699003|261026140227099003|261028144727099003|261021121427099003|261022105027099003|261026121527099003|261102123227099003|261009223027099003|22082099003|18002099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	u/8y5gH+7sogfiV4XFXzF48c8p2z73gvHrt+/HzzwL2MzUM/0lRz6nYlIIKxky/FZfMxWBK/u3XArpf7lpCS99NYgshX6utK6JNdwlazPFiFRvZsHtDpzhLETCxLvHx+eZuo/J8EPkBAToM0yvRYu8dT7oCaRabnDVRDebBqXYKSu5gljot0agOWZVJ8z35QTzN9QTA+vDYJ3AQxptZjJk0NotOOrvaVMAy1ZoEhd0U+NUOdc4a3nEX8hOs8Xu01cvnZV+zQrGmDx/QgcyIOOdOOgCrq4jwCMQOLszRYVqDFP9HRjIzN6AcuGvDEm21r8InHSrg393nHb+vMDRLTwRrmB5g9IEpKVW0QqllItSHp0xXdIGykDObmLCQnmyn2lrfSY1Un3qifk62NE1gSTP0iq0FSfZedeVVDlg0ihRfKBuE7sI5FA9GbrqGM/vxfYQzqp6YXmvHBisZuF5534WADco2W1HrpMJtP+QMQg77p5pTNCMvRnrP5lLk89XlLFTx9eIYO521nZi/imzIBvZE8BZWs2tQE+rM816IMbcT6/gmmcSYS60R4AcIiREe/zWD34YKSfr7Y3U40R0h0PXkjIYV3BQhMfrxsEtGVfziQCSi0b6VA3ksooxS6JtqgPXUaPWx1AmlLBTMDOkBw4m3WtACoHQ8n1TlLjMHTF30=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(261022113327099003)(10067099003)(261022075727099003)(11063799006)(56012099006)(4143699003)(261026140227099003)(261028144727099003)(261021121427099003)(261022105027099003)(261026121527099003)(261102123227099003)(261009223027099003)(22082099003)(18002099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?rqWWaEppmGKuSqAUysTeeQNpBZjeCAz82+1fDPJ8UHgIKdstVDN4mfhCjlZC?=
 =?us-ascii?Q?YicOjJy0PAWd9jejBDkvSFLQTVvwglyxn4uThom4Ix0Nt+vbXss5jm+WaiBf?=
 =?us-ascii?Q?NA7MJB+OAnQLor8dFMg6AUesimegYwwWaW1kW74eUq6QTC2Fmp9YA58dsWuU?=
 =?us-ascii?Q?KAYCe14QCE2LhcliSFeaQi8UrxE9vQS6U2Ot4YuTTiMtjB3QGyzPCr9na5wz?=
 =?us-ascii?Q?s9RrsrI8Vp/vjmq8UUSzvYH52hiF9/zufrsG24wBG1affGQCjvSt+frga7Ay?=
 =?us-ascii?Q?1P4F47CCnHDcAL6dZQ3i6YcnNrF8GFiPn98pyHysdHrcPyR6V0ds0Upv9ICT?=
 =?us-ascii?Q?ivYSCY8PqazzUePKrQ98/zuvsva/4Mtyv5obwIJdW7nXNTn33HhVQcP4JfYQ?=
 =?us-ascii?Q?jQGCzjcUZNtva3ACvihHx2jZJtCu6YbtAfaDyIw0Eib9nBp9ax2c4kUzu/QF?=
 =?us-ascii?Q?0dU4LWcg8EKqwi+2ZUYzZ2+pHJZDo8PFyTqimn9F4B9W35dopA/lSSPwxW1A?=
 =?us-ascii?Q?Xx0cWswPGSvU9NT3YPKtKDg6n/djohMNzQ2OeeCTDRXM960dgZNZbfYQKu+w?=
 =?us-ascii?Q?f8z1FQXR5bhj5NW4gIn9ORzAGfiGQKglmvhP8WNkqC/fPsM79ex+1Qo0nBEf?=
 =?us-ascii?Q?J2Yrh/clAiz6QS5PwDN51dKpY1Ad6R2aiAt3SMcLnfjPWQ9tCpMVOt7th8Gr?=
 =?us-ascii?Q?LIUw5IJur8k5YzEXrLC7FkqeL/59JCTQAIht6CQB7Y5UqENlBwDgwjm7db9k?=
 =?us-ascii?Q?Oa8baQRWNfo+t16mEc7ehE+LiamJEG0Al1/1NeQ90HoOIxAr9n1eCvqiKgua?=
 =?us-ascii?Q?CGrXCD41nuaRhMCW11VxK44UpHqYR3JkWln+p0mQgA9YgzcbyAI6/+bugy5R?=
 =?us-ascii?Q?XQd88LHtLAU2R+KhTxqqsk1r5oyz11TBXJetWqfX5MtfI6yo2wlYKGtaP9e8?=
 =?us-ascii?Q?TEO/gR/CWl8cs8C2VlS8SOypHa8yWucabcsSTxeSj08OrVKANNOsWoKf/s7w?=
 =?us-ascii?Q?Ib/80IoVBU9hY7iXSct1vlHUvAR+ZT/J+Qx90JkLQyVvRNTgME8cm5wgm73C?=
 =?us-ascii?Q?lDr40/GRu2Gm8Maa1ZI3szBzmNhJGZxEp8BfYkGZO65xSBaNjb4EsT7cY7wE?=
 =?us-ascii?Q?rD6FW7lyeIlcMQ+/M04LNO8uBTPupt1ipI5vhvJxCpd+IQyDy5HQDeVltFaB?=
 =?us-ascii?Q?mjco+CqRymyASi43QxgrkddqBTbZOHN7JWVn3rU6ikwd8C+Xpz1NYm1srOVx?=
 =?us-ascii?Q?rzigxpehjwyNqtx2hS6Aef5Oj2oZsY38nZy2gUnFw1otoHXQRXH9nDRmypA6?=
 =?us-ascii?Q?65ELdUCDrTgs13Z4QsHTyuQuLQ1BEJtNStNW/KRX4hyCR6HvkNexE/1DYEo/?=
 =?us-ascii?Q?V7BSX1bId5GbPiPRoeBe5EawPPTJTMfOoUUXABhcvstQDeKTsKL4FvPOQbwO?=
 =?us-ascii?Q?6XrAWHEGW3mVrmmoK9GRin6wB7khc2LtmO59m/Ktxu/CHltaE8VumFY2nywU?=
 =?us-ascii?Q?VIcMwXMVC6FOl/c/zo04R7dkEbhvxbhsUQQkdPkjVFI3XjNZCNXd5oSVPZg/?=
 =?us-ascii?Q?S755Fb5YJO1rJ6Xyf3EePEl5WkIzhGeXF6QTLRquS3jO+Kaz3/dz9AUVwZMl?=
 =?us-ascii?Q?Q5WQCh0BTpcmoW7Dctzve3BXSA6LNRWDwa3lXXrHgYgORaT+eul3R3243AGA?=
 =?us-ascii?Q?miLfhWcpSxDD3ToyEKolUkE/U49W3gJrUP7CkXt8meclbAD1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2df227de-6500-4285-2f0d-08df45793ee8
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 13:38:36.0793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mk9THWOyEf12MYAoX+IlFYvS0fibSuogzRrLTldDkyQ5x8/9oRmzPgfqn0H4q60N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8468

On Wed, Nov 18, 2026 at 12:26:25PM +0000, Reshetova, Elena wrote:
> > > So, yes, if we dissect this structure, then the unique fields that Intel has
> > > are:
> > > HEARTBEAT_PERIOD, TDISP_CAPABILITIES, TDISP_VERSION
> > > (I am not listing SPDM_CAPABILITIES, this must be part of VCA)
> > 
> > HEARTBEAT_PERIOD will come out of the transcript as a field in
> > KEY_EXCHANGE_RSP
> 
> Yes, if host parses the whole transcript or TSM exposes it. 
> Did we conclude that it is a must or do we trust TSM to verify it? 

We trust TSM to verify it.

If a full transcript is available the only thing that might re-check
the siganture is an external verifier. I don't have a good use case
for that in mind today.

> > TDISP_VERSION is in the data from GET_INTERFACE_REPORT which needs to
> > be a common API. Though this is probably the selected version not the
> > offered version.
> 
> It is in the header of that message, but it is not in report itself in my
> understanding, and since guest only sees report (and its trusted digest)
> it wont see version. 

So, there is an annoying spec unclarity on all three vendors exactly
what they include in these blobs. Is this header included or not? I
cannot tell you the answer, we will have to find out as we go along :|

> Again, in my understanding it is not in the report so guest has no
> trusted way to know the TDISP version. 
> But yes, we can make a decision that we trust TSM to always negotiate
> latest version and we can attest TSM. We just need to be explicit in
> this.

This is what everyone else has done

> > I don't see that we need to double check its work. None of this is
> > even signed so a malfunctioning TSM or OS can simply lie in the
> > report.
> 
> OS cannot lie, because information is protected by TSM provided
> digest, but yes, we can decide we trust TSM with it. 

Once we accept devices OS can become compromised by device DMA and
start being hostile. Once we pass that threshold none of this unsigned
information has any value in establishing integrity.

> > This is the hash of the message bodies, which don't include VCA.
> > 
> > You need VCA to compute the signature hash which is why everyone ships
> > it around.
> 
> What I meant is L1/L2 transcript that is signed in last MEASUREMENET response,
> it has VCA:
> 
> L1/L2 = Concatenate(`VCA`, GET_MEASUREMENTS_REQUEST1, MEASUREMENTS_RESPONSE1, ...,
> GET_MEASUREMENTS_REQUESTn-1, MEASUREMENTS_RESPONSEn-1,
> GET_MEASUREMENTS_REQUESTn, MEASUREMENTS_RESPONSEn)

Right, it is a transcript, you are expected to already have VCA from
the initial transcript when you compute this. It doesn't re-transfer
VCA.

> > > And this is where in our original SPDM_DEVICE_ATTESTATION_INFO_T
> > > struct VCA should have lived instead of being a separate structure with digest.
> > > Would that be acceptable?
> > 
> > I'm not sure what you are proposing?
> > 
> > My concern is you have this digest over a struct that isn't a protocol
> > struct, so we have to make a special API to pass your special struct.
> > 
> > Unless we can get rid of that I don't know if I care what you put in
> > the struct, but the kernel will have to break it up and your driver
> > will be more complicated than it needed to be.
> 
> I am trying to see how break this struct the best. And the only open
> question I have so far is where to plug VCA (rest is clear).

ARM has it nearly right, VCA is captured in plain text as the session
transcript. This TSM directed capture primitive is what you need for
1.3 because we want to capture GET_DIGESTS and then pause.

Building some other way to get VCA out after the fact might be easier
from what you have now but it is only useful for a 1.2 implementation.

Plus it means you have to store VCA, certificates, etc in TDX module
memory, instead of just fixed size small digests, which seems pretty
undesirable to me.

It is up to Intel how you want to sequence spec changes, but I'd take
a serious look at doing the transcript capture right now and use that
to capture VCA, then you are well set to expand easier in to 1.3
topics. Especially since you brough up multi-slot as a key requirement
:) :)

Of course you can add a new command to get the VCA and do transcript
capture later and have a more complex driver and module.

> > VCA is immutable. It should be made available once and not repeated in
> > every single measurement fetch.
> 
> Yes, this can be an argument against providing it as part of measurement
> fetch. Then the only other clean option is a standalone VCA with it
> own digest. 

Still not sure we need to digest it. I know ARM did, but I don't know
why.

There is a merkle tree from the digest of the measurement to the hash
in the signature to the L1/L2 above which hashes the VCA.

It doesn't hurt anything, but again to be forward looking you'd want
to hash the entire captured transcript, including any future 1.3/5/6/7
things like GET_DIGESTS. Not just VCA.

> > Collection 2 and 3 are the same action. Anyone who can make
> > measurements can provide the nonce and generate a replayed nonce. The
> > only difference is if the vdevice digests are changed.
> 
> Yes, but this difference makes me want to separate these two cases, but
> I cannot provide you a concrete attack right now. 

The only purpose of the digests is to authenticate the guest/host/TDX
channel.

It doesn't do anything else, and even with the design you have today
the host can issue measurements independently and then hide that
behind a legitimate guest measurement request which refreshes the
digest.

> I need to think more about it. But it does feel scary that we have
> the same interface for a trusted and untrusted entities, which has
> different security properties, but non- distinguishable otherwise
> (when you look just at a signed transcript).

You can never look at a naked signed measurement and make a security
decision. It always has to be bound to the VM's quote/signature by
trusted software.

Since only a legitimate VM can establish this binding it is how we
prove the signed measurement is made by trusted software inside a VM
and not in the host. We trust that software to have checked the digest
to make sure the guest/host/TDX channel wasn't tampered with before it
binds it.

> > 4. TSM controlled nonce
> > 
> > A way to put the vdevice into "tsm controlled nonce" where the vdevice
> > evidence collection no longer accepts a guest nonce and the TSM
> > provides its own random one. This would be a permanent choice when the
> > vdevice is created.
> 
> What is the usecase for this given we have above 3 items? 

The one you mentioned, single evidence collection. If the device is in
"TSM Controlled nonce" mode then the host can make a single
collection and present it to the guest over and over again.

Guest can see it was an authentic measurement with an authentic random
nonce because TDX module tells it this is happening and gives it the
digest.

Jason
