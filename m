Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.62
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793719011;
	b=Uvh7A8GND6QZuTaeX04lVz/Zw/tJ0CVzmmv2bvGWwR4A110H6CGz0x0aKGrkEFqE7tfG
	 xPuBsZz7aIuOW6beNH+uwyk/KlswDXczaHYSMu6s0UqgqaJGsMoPGIaySfbnoqpCsgeh8
	 KzQwXYWVekwQV+eC+AFLSY3syM6VqsSyuX5H68EgIevmTPmIZCB4eYYCjjdJ4D3msenkF
	 YLzNT+ajm6hUmH25NlnF35Na1eh70ryNXrWPSQUzWRzZsDafHOM+p8W+t1aYJhgXu6hJw
	 YynNNMYIjoezUmaXQkSPPf2AEyXzh8Gw/EIYe9gRQx14qMRttq8lwt0Q1HbPtMAmwGQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793719011;
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
	bh=lzLyRU8IQewlckXKvQX7olOHl16yb9QUU1qXnkGg5Yc=;
	b=5jkg+vH5le13kD1TbxX5T0VYhfpkGfS/GbAMvCkR+XAtCdp9AYZoH8QZ2RpHxG3/FwZF
	 1V8zdZDnGeqQkSzDF89QWn4RaFdTwvor7CfDUzW2pu1IvKiTJ3apwO3x+ghhxq55goJf9
	 NS5w8TivQ1iVDdQQiNs4JoTuQyeemchi4FUMXxzTQDJHgpWK+YVmRuHmQITQLILUWGECe
	 smyAQHV0NRXBb4uEPqVd08oHzBomJ5O8iGIFzhCCKmjSQaYSOGTnL24lZ9S4d0PqEq/CN
	 Syu3yZ0/cuEuYUxu1lOR40FO9qBDuWhnSk60ZXAmbO0/uH+/OqsontSOmjBDVRCGsig==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=PBFbjlAO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.62
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010062.outbound.protection.outlook.com [52.101.85.62])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754C6606D819;
	Tue,  3 Nov 2026 15:16:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 754C6606D819
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=PBFbjlAO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cdgscI8WpSQLLdOkMmYfFWZ9evq69+BjVSahU4CrQy6gP6mcfxDeDN1GgdbgdwVTRFRbHFuR5Kzt4/NeGULYNa1hIe7c1uBxXq2ulLspSZDp+mAK5+i3lAS8hkoSyfJ/C1h7f/tPAj2ttBkJzaT1lg6/7EIi6pGRGvAPipSkNFOsoYau6R2zdQG1UFamAx2Yzlna5wFTaBDuWhvuBCWu9pYOmvbfLpF+uoOzc9BJFMZMUF8efyuEmfqhHB7z71XooHbiqxxdk9g6Rga5aZUPiKBH6076Kw+HUEY05d4XQPP2r+va7gAmFivmeVgVDGF+DkXYwmSVe1MJ1t8Mz/0QnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lzLyRU8IQewlckXKvQX7olOHl16yb9QUU1qXnkGg5Yc=;
 b=NosiPGIwDkjAV0yeX87cS0HL8r4cVgPj031j7R8sOfS9QzMnPi6sKE4ZE3lZ6HuZHwGw7t59t98dZcMQH/Kb1Yg0CCgcDskeFaqy2ImRdYImC4ChooPT028w893xnob6xWZAC6XVT/lvSKPdsy5bNrfKavixcJFxCm/31bhg6jgogUdejXVpBkr8dV8GBMscbsgTU06xCnlucLeScPxjHKUblHSHKpTIglPdJbdsAWe6bJdXWpB8AvPIrdbHf+Cuj+RJ7wwfbe0xUugk9DVq+UVW20WJ7xdK2j2eCXR/MRMB5wF90i9mx4CMKw8aXU/QEFrJWnZWmcOahGlYUcFbsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lzLyRU8IQewlckXKvQX7olOHl16yb9QUU1qXnkGg5Yc=;
 b=PBFbjlAOlqtg0TIl6FXNwDbOn1DkUarFYSBp7Nsk2WtaoRTeM0k3fkOxu3ytJt8DZuSoq4FgMntTFTxax9LVmQu/lNp4TJUSRKYyN+TNlzzkEgNkJLH7zEP4zUBSy2ySs99l2Hu5RuJn3xYCrrFKVdNqRtwiGPl3+glhcguvZFokb1gJrQXlpSXMIu0pzB/FoHStd9H/m070QEFqt88a5eBJrHsTnN+ecNSDGI70N/GVuAqYl17SoB8VVo934ZGpmJfwyGip2dcDefMb7+89vDWdiWiSgf4egLgMl6kB0ZiBVFD7k/iu1TwblDTx+oI0DSlg/4+UM623mR/amtPkNg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by SA1PR12MB6996.namprd12.prod.outlook.com
 (2603:10b6:806:24f::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 15:16:45 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 15:16:44 +0000
Date: Tue, 3 Nov 2026 11:16:43 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Jiang, Dave" <dave.jiang@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
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
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Message-ID: <20261103151643.GI274202@nvidia.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-11-aneesh.kumar@kernel.org>
 <26c24a66-be3d-40ac-8cb4-294deb0108db@intel.com>
 <20261029171053.GD3734323@nvidia.com>
 <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261030131543.GH3734323@nvidia.com>
 <yq5apkwqa5ve.fsf@kernel.org>
 <DS4PPFA84FA90FCEFB18E5620217FDCA728E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT4PR01CA0238.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:eb::28) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|SA1PR12MB6996:EE_
X-MS-Office365-Filtering-Correlation-Id: 83f2ba37-c724-4c4c-9a14-08df39bd78c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|23010399003|11063799006|4143699003|5023799004|261026140227099003|261028144727099003|261009223027099003|261022113327099003|56012099006|261026121527099003|261021121427099003|261022105027099003|261022075727099003|10067099003|18002099003|22082099003|261102123227099003|6133799003|3023799007;
X-Microsoft-Antispam-Message-Info:
	bNvjpNArXAIid809f9z1KrG7rKijB4QkwSnC8TvK2buwZva84ohepLRGst4tCzFzrw+y8Zcfhe7nIkfzjBP8s4v6BbdDnukcHXCFbUXBFJkhP5iZMrmm3qEznCrPJaO4SAwVGcw2y8Ncqs8ofRswsU8PK9bwjgqJibcVpx9iLeXdNuiW70e1EJCC2aZq3BfWjm+c12reiGNeBFeMlzVZuQwoSk1O8+w/gEFS4VTftqfWYdB2WcErm77yfKQAn6PYxTwf0ORTk1MsjTvUPTp9dTS0j3I49vfY5b35ppblIoOkojgeQrJq2VL6jUmAgqQM9z0AyNPlgrf+S3kbuMnszwJhIXby+Gma/4F4uE944lkUboCSRvZ2oB+Z+8rgV6csogSt45v5Vq4plXotIa5ZHYAjpbvYDVpS/ikuHHKcYA0p1A824RTB5sClhmw7mSPkloIxxQn0HPWj+Ua8EGCx6GtrP4oAC/UUETAi5xEale50IyC7GfcxoB2ykCRJgkcc8WGwa70EtfSesZ0TuUXnjWrqnKyKVZMrYf1zVktlxrE+fXncNv/gGl3QPKdeQEXKwwxFuk+MoHFhXNYMdqR5aPdVNmNsdZSU5UhXpURa8kvW5JWLGtWsOIRskzV6LkySlaYQIuAM/kkTO2cYcOMUazha6KImRNecz0YYbIZ3m78=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(23010399003)(11063799006)(4143699003)(5023799004)(261026140227099003)(261028144727099003)(261009223027099003)(261022113327099003)(56012099006)(261026121527099003)(261021121427099003)(261022105027099003)(261022075727099003)(10067099003)(18002099003)(22082099003)(261102123227099003)(6133799003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4PpqyqyUTGg0lJK8yLD1Rqwj7XfWlSjXHsWVmv93dd3aSQASe0fBpo6MbKpX?=
 =?us-ascii?Q?jMBrWGPN8LC5p+Qt+HISuRS3QztN7+9rRLHPQ8lelaCtdXu8BbdikBIIE7No?=
 =?us-ascii?Q?KxcQvQ1K8KYzOKj1AXFigNLzLSHZsoqQbnyZhGGyZup3UVCBMyfXkRntHatT?=
 =?us-ascii?Q?avAir/NvTkAdUTbkYdbmsWsNluKs3hugV2fJKGMvJL646oJI2OY1AennUXYa?=
 =?us-ascii?Q?8xcOiqe20kacXNC3SG7kVJonBdqLl2QgtIrh17H1LX5jnKrt7cT1kE7YCKcU?=
 =?us-ascii?Q?akXgB9rvDOgzQfgIzFjbokzOnisjL6OF49OnDY1thbMdojcdxcNyb82WC8Bl?=
 =?us-ascii?Q?6U/kUT5J33yCo2h+k7H3EEGrT5ARgwZxO9Za/Mru9WSZrDNnNEHHIMBHUUTk?=
 =?us-ascii?Q?WNXn5oWSsbC0RYc4WVQAbyMMa8h1bycyuCRdMHwWJsj4K23wU5Izl+RllJhx?=
 =?us-ascii?Q?fX9a1OPO9NBEUAd8t7Y0y8D5tBCk2C8oSl4FylKcdEHZB706GPLy7MZx/uxC?=
 =?us-ascii?Q?jlrKuZHGmHzBh/ZyPoK7LveRl2WtAaV9J9E9kqIOsUNcuN6fgdIneF6Lj+S3?=
 =?us-ascii?Q?7NHaTCEPWvBR8qsCyGJG7dBwUXClZkvBpYAjdr1RDRrPGGblwdR7Ncx/f8b1?=
 =?us-ascii?Q?tC16/MfyXeKqsSsuaALZ22pwoXUGG3Rv4d7oUVp16SXr0um8xjI9CZ/Wse84?=
 =?us-ascii?Q?m3Ys4KhkSDZMRbobnIGBJAhznh8vNtBP0sK7JcQ0bvhF1OBaubSwpwo19a0q?=
 =?us-ascii?Q?HQODiUBZ9d6I441ACnBjwpLxx84SOZ/EkRRm3FwcxtSNuUFERufSBRECQJss?=
 =?us-ascii?Q?U/TzyICo/26ZROJCucqAjEEktpzMKLYvjGaODAtIKzuT8vs8pjuk6a+cff08?=
 =?us-ascii?Q?ByIpR0/w+nCDuTrRd/zJimnOevdLU1V5Ovtvz6aDMOe9McupUHbUcK/Yighz?=
 =?us-ascii?Q?lHjpnwLk0osWoosD26CJ6T1ODoLm4UX8DP2y14XbAcxDW2n13oUahyoUgZFn?=
 =?us-ascii?Q?Glc09lx8HcMIYVB1ggPNCA1IhoNPsuuPihieFZYOgXwtT3wfyp1Kh2+lJpLu?=
 =?us-ascii?Q?+f/nSgrYA1E8zSBiac6JBAnXCkKl2NrXwy9NgbfwhW/IB0YiaJyEwdXdcziX?=
 =?us-ascii?Q?vKLNxQbM5HSKP2Milp0WKGpABdS68Tyl2zti1YmKsNHcqYPsY5dyKrU/OmSd?=
 =?us-ascii?Q?v+4Ym/DcXuso44zC7cSV9GgugK4U5eUg5JowB6qaAP8lv8DkIO1eAFAvbAX1?=
 =?us-ascii?Q?3BULz4TyUii20m55X4gSdKuo2tguHcBWT9tbwjf2yyrpVv5MTlwgqwidPeCL?=
 =?us-ascii?Q?/lczdK2WXKtqFRoN5383MpXftG1Glw2iT235YpeE0lBmpiwdKkROejNqvPxf?=
 =?us-ascii?Q?a+EDAvzLHGzDQ87p6FXWuQ1yxLoP0wi9oaROF6VACP8KeVWVxyOiiqUD8yct?=
 =?us-ascii?Q?2iAdRWLrCmqtYtU895jtCGfHftrgt4JdcFBWza5xYTyvG+Cri+1N8pSufNfD?=
 =?us-ascii?Q?cMY/oiXKcVChBA3VkTXK1kPmX1Mz4BOnOpf9beiXmNkehkGbTG7LdrFXujal?=
 =?us-ascii?Q?mlHfG12E5zGwpoP94qDfmbY02FgjVB2tNmGTZQh6AOITUAO9gf65qoCr+4pj?=
 =?us-ascii?Q?tBUoEDgP+e4WGlN7AoiVIRFbyXQaFEyZg0kn0VZwUXD4MRAuT92ygBJ593Uw?=
 =?us-ascii?Q?zMg4dMD3ZYSnoWSvI8qKeG++6x2/lAlDC1Bws6WWck8jWegk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83f2ba37-c724-4c4c-9a14-08df39bd78c6
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 15:16:44.9175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: enlVl8SOUlTXZdINDNw1Yt3OBhloEKn1BunCySd+frmSnP9y800+fuTc7WvR1mzw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6996

On Tue, Nov 03, 2026 at 12:01:43PM +0000, Reshetova, Elena wrote:
> > Since there is only ever one private key active, the only thing we are
> > trying to do here is to prevent a "fake" certificate chain
> > that isn't actually installed in the device.
> 
> The ultimate goal of your proposed two step approach is to make
> sure that the SPDM session establishment in step 3 of your sequence
> has happened using the key/cert chain userspace selected to trust in
> step 2. 

Sort of, in a 1.2 world you don't get to select the key, and the only
purpose of early slot selection is to get that slot's certificates
mixed into KEY_EXCHANGE so that the verifier has signed proof the
certificates are in the device.

It seems like a theme in SPDM is that certificates are signed so the
verifier can tell if they are authentically installed in the device or
not.

> It does not actually matter much if you allow multi-key or single key, 
> you still need to do the binding between initial discovery, selection of 
> key to trust and the actual SPDM session authentication in step 3. 
> Would you agree? 

Yes, everything needs to be bound together and ideally the verifier
should see signatures that cover all of it in the transcript.

> Thinking more on this, one could argue that the only thing you need
> to do is to in step 3 to make sure SPDM connection established using
> a private key you trust and if you allow userspace at this point to 
> do verification and acknowledgement of the key, then you do not
> need to have any bindings to step 1. Yes, malicious device can in this case
> send you in step 1 bogus keys and slots, but if you ultimately check key/cert
> chain after step 3, you are good, your decision is made at a correct point.

Maybe, but this is not how SPDM seems to have been designed.

There is a very clear theme running through that the certificate
chains are bound up in the transcript and presented to the
verifier. There is little reason to have mixed in the slots
certificate to KEY_EXCHANGE otherwise if authenticating the
certificates was not a design goal.

If you read the slots after doing KEY_EXCHANGE then there is no longer
any verifiable evidence of this binding when the data reaches the
verifier.

I don't know why it is like this, but I'm very reluctant to see Linux
ignore something the spec committee thought was important.

> The flow really becomes as:
> 
> 1) Do via RustSPDM:
> GET_CERTIFICATE / CERTIFICATE
> 2) Userspace selects slots
> 3) TSM module does startup 
> 4) Verify the cert chain of public key used for SPDM session establishment
> to determine if the key is trusted 
> 
> For this TSM must expose in a trusted way the full cert chain and pub key
> used for SPDM session establishment or only a full cert chain and guarantee
> that the pub key on left cert chain was used for session establishment. 
> This is doable for TSM.

There is no signature covering the slots in this case. Userspace
tested them blind without knowing they are actually in the device. It
is not ideal.

> > The 1.2 spec provides CHALLENGE which solves this issue, it signs
> > all the certificates with the single device key.
> > 
> > So "all" we need to do is get the certificates with RustSPDM and then
> > use CHALLENGE to get it signed by the single key in the device.
> 
> Do you mean in step 1 of your above sequence? 

Yes

> two different independent components. So ideally, you would really
> want to do this within a single SPDM session as SPDM is designed to
> do. 

Right, this is my thinking as well

> > RMM will need an ECN to have an optional negotiable feature to support
> > 1.3 multikey/multislot. In this flow RMM must do the
> > GET_DIGESTS/CERTIFICATES as part of its signed transcript when
> > supporting multi-key.
> > 
> > So the logical design is to have RMM run its FSM past CERTIFICATES and
> > then stop. Userspace gets to see all the stuff it collected and select
> > the slot. Probably via RMI_PDEV_SET_PUBKEY we tell RMM the correct
> > slot and mulit-key to use with KEY_EXCHANGE, instead of telling it
> > during PDEV_CREATE.
> > 
> > From there it is a small step for RMM to support 1.2 devices by also
> > having it issue the GET_DIGESTS/CERTIFICATES/CHALLENGE flow in the
> > same way.
> 
> I am not very familiar with RMM, but if you do things within a single
> SPDM session (just stopping after you have fetched the certs from all slots
> and passed it to userspace to select the key/slot), then you dont need to 
> complicate matters by including GET_DIGESTS/CHALLENGE. 

The purpose of CHALLENGE is to authenticate the certificates to
prevent any MIM from tampering them. It is cheap and closes this hole,
I would definately expect it.

> TSM in this case just must ensure that SPDM session establishment
> has happened using the key corresponding to selected slot. TSM can
> do things like this because it has the final SPDM transcript as
> result of session establishment and can verify it by itself.

At least in the RMM flow the OS provides the PUBKEY to the RMM so this
is never in any doubt. I agree that the TSM implementation has to
provide the property that the PUBKEY's signature is checked during
KEY_EXCHANGE and the OS must definitively know what PUBKEY was used.

> > Further, if you have a transcript that includes GET_DIGESTS then you
> > don't *have* to select the slot early. The early slot selection mixes
> > the certificate hash into the KEY_EXCHANGE, but if we did GET_DIGESTS
> > then we already have that mixed in. Once you have a signed GET_DIGESTS
> > then you can just request measurements on whatever slot you like
> > without any relay attack.
> 
> You lost me on this. If you mean final SPDM transcript in step 3, 
> I dont understand how having GET_DIGESTS helps....

One of the issues with 1.2 is you get a signature over only one slot's
certificates during KEY_EXCHANGE. So you can't use the other slots
certificates because you don't have any signed evidence to share with
the verifier.

In 1.3 we can do GET_DIGESTS and include it in the transcript that
KEY_EXCHANGE signs. The clear purpose of this spec change is to sign
all the slots certificates in a way the verifier can see.

The net result is you can now freely use GET_MEASUREMENTS with any
slot without any binding issue. Both the slot's leaf key and the
certificate chain are signed by KEY_EXCHANGE.

> > Unfortunately RMM doesn't provide an API for the guest to select the
> > slot during GET_MEASUREMENTs and we don't have any way to pass the
> > certificates from other slots to the guest. So from a guest RMM
> > perspective the slot is fixed, attestation subsystem should report the
> > single fixed slot (maybe not zero) and the other slots are blocked.
> 
> TDX currently also uses a fixed slot 0 also for step 3, BUT it does return you all
> cert chains from all slots, so you can actually make a full decision after
> step 3 whenever you trust the single key using any available cert chain
> slot.

IMHO this is not useful. Again without signing it is all forgable from
the verifier perspective.

> > Anyhow, below is some AI assisted flow how you can incorporate rust
> > spdm and properly bind the CHALLENGE. I'm not really sure this is
> > worth implementing, I'd like to hear from ARM spec folks what the plan
> > is for multi-slot and multi-key. Proper spec support, including guest
> > discovery is far better.
> 
> Yes, I would like to also hear how others plan to implement this, 
> ARM and AMD included. 
> 
> > 
> > So.. I think we should start with slot undiscoverable and effectively
> > wired to zero. TSMs that want to support discoverable slot really
> > should to incorporate the above into their spec'd SPDM flow and it
> > will work without requiring RustSPDM.
> 
> If we start with a fixed slot 0, how the interface/flow would look like
> for userspace to accommodate future slot discovery?

We will need some multi-step sequence from the uABI perspective:

1) CTLV command START CONNECT:
    TSM does:
     GET_VERSION / VERSION                          (VCA: Version)
     GET_CAPABILITIES / CAPABILITIES                (VCA: Capabilities)
     NEGOTIATE_ALGORITHMS / ALGORITHMS              (VCA: Algorithms)
     GET_DIGESTS / DIGESTS

2) CTLV commands:
    query certificates. TSM will issue on demand:
     GET_CERTIFICATE / CERTIFICATE                  (every slot in the slot mask, all chunks)
    query VCA items

3) CTLV commands:
   FINISH CONNECT with slot:
    TSM for 1.2 does:
     CHALLENGE(slot 0, fresh nonce) / CHALLENGE_AUTH
     KEY_EXCHANGE(slot S) / KEY_EXCHANGE_RSP       (clear text)
     FINISH / FINISH_RSP                           (in session, opaque to host)
    Or for 1.3 multi-key does:
     KEY_EXCHANGE(slot S) / KEY_EXCHANGE_RSP       (now includes DIGESTS and CERTIFICATE)
     FINISH / FINISH_RSP                           (in session, opaque to host)

4) CTLV commands:
     query certificates
       * Only certificates kernel or TSM has been able to validate
         with a signature.
     query final transcript items

Then there are five implementations of this:
 a) Today w/ 1.2 and current TDX/RMM/SEV specs:
      #1 is a NOP
      #2 is EOPNOTSUPP
      #3 does the full flow from GET_VERSION -> FINISH
         no GET_DIGESTS
      #4 returns only the slot S certificate that was signed
         during the transcript

  b) Improved 1.2 TSM:
      #1 TSM can execute GET_DIGESTS and pause after
      #2 Ideal TSM allows the OS to request each GET_CERTIFICATES command.
         Less ideal is TSM pushes all GET_CERTIFICATES then pauses.
      #3 TSM issues CHALLENGE and verifiers the signature.

  c) 1.3 Multi-key flow:
      #1/#2 is the same as b
   
      #3 The function of CHALLENGE is absorbed in the updated
         KEY_EXCHANGE which covers GET_DIGESTS when in multikey mode
	 No CHALLENGE issued

  d) RustSPDM flow:
      #1 becomes a RustSPDM session and includes CHALLENGE
      #3 starts a new session
      We have to solve the issue with ALGORITHMS mismatch somehow.
      There is no verifiable binding of certificates visible to the
      verifier

  e) In the guest:
     #1 is LOCK
     #2 is preloaded with the transcript from the host. Currently
           exactly one slot with the same number the host picked
     #3 is NOP.
     #4 is the same as #2, it doesn't change
     #5 Additional ACCEPT command is TDISP RUN, after we have
        logged the data in #4

CHALLENGE in 1.2 brings it up to the same level as 1.3 where the
GET_DIGESTS is signed. It broadly gives the same security guarentees
for both standards levels. If CHALLENGE and KEY_EXCHANGE have related
nonces then the whole thing is bound together in a way the verifier
can check.

A TSM that implements b or c should present the whole transcript,
including GET_DIGESTS, CHALLENGE and all certificate chains to the
guest. It should let the guest choose the slot when executing
GET_MEASUREMENTS.

Since the transcript now signs the slots the guest can rely on the
transcript to prove the pub key for any slot. For multi-key the
verifier still has to accept the host's slot choice since the
KEY_EXCHANGE signature is root of all the security. It is probably
still a mistake that GET_MEASUREMENTS doesn't bind to the channel
somehow, oh well.

For case A userspace has the option to run the entire SPDM flow
multiple times through to FINISH CONNECT to enumerate all the slots,
with signatures. I don't see a good reason to have the kernel do this,
hopefully nobody ever needs this..

> > RustSPDM Should be used to demonstrate the flow where we start a
> > session, get to CERTIFICATES, stop, then let userspace select the
> > slot, then continue to KEY_EXCHANGE. This guarentees that the
> > certificates are hashed into the KEY_EXCHANGE for multi-key, so the
> > uAPI must support this kind of flow.
> 
> You mean you will just prototype the flow using RustSPDM? 

Yes, if someone has hardware.

I fed all this to AI and asked it about AMD. It looks like AMD is
basically the same as RMM with some minor difference. I expect they
could do option b and c with similar minor spec changes. Hopefully TDX
is in the same boat.

Also I suppose I should mention for completeness.. The systemd side of
the flow would be like:

 CTLV command START CONNECT
 CTLV command FINISH CONNECT with slot 0
 CTLV command query cerificates
 CTLV command query transcript objects
 systemd-pcr-extend <something something> 'device accept: transcript, certificates and so on'
 CTLV command ACCEPT
 device trust = trusted
 driver bind

Where systemd-pcr-extend would extend a measurement register in the
guest's quote. Like a TDX RTMR

Jason
