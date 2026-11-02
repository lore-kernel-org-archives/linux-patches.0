Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793640407;
	b=HooIwLPw3qU8d2ked5hZfy1CPZDyG+fJ+blZFc0K9XjCyDSYOplwQNyYf86rlPoJyZtC
	 yHICQXGb9UNjOZbAZ72XnCuBSniGNwL5eEqnRCgnxYOOp3dQNhyHv+wiKZDSeB27b8+bL
	 8FxW+N6Vw93TyKSBFwzktD2scFpVkLpZY/eZs9YcvubQRoUOcT9brTE7o3np6C9mKF0Sz
	 lusNMBBJ4tUCWAZ/gk1i1b15GGgZSSjIE3osB2NnJnb9zLjBaVhq5DINNCnS7bTU8eM5R
	 mAq/8lYw9Jp53UwzI6a88au2gW8ujDfdZYDdeITyoIix4yDNodxwEOvfsVgrki6P3iA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793640407;
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
	bh=GNgYisBMxaiOII22aYsrZYaBrpunAGhWTw5T83M78js=;
	b=ketBHQ6HrqatIkxUQB9o6ZRLzRz+EEuv4fBOyzTNj+FV4v8cH/IcSFPyEP12j/g/tfip
	 3vHoJK2pnzG3ySudOva2Poz3l0XizVe0IKG54nvnmP01MCM3qk+hF3trZXqOMmq/YAta6
	 B192UCnJdOaCU1AJZvNJrxoz3fzpmoH55wj9hcJAtwGG2Y1HNR3U59Gi8p9ptogoXxSO+
	 kvSq2ySHKVOSrqTDUH6e2jMxPbn9ojXnX6TmRMKVmSIgvkJ/FFdG1p9Dn0QlmOlv4hH8o
	 g63A9WQwnx3qvSNZE3fsxT+g2PJ3TnQLb4kTUVbMjFYR7fQzez91ySdPgBFwJujE5bQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="UbMw/O9Y";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.53.48
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012048.outbound.protection.outlook.com [52.101.53.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36756606A329;
	Mon,  2 Nov 2026 17:26:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36756606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=UbMw/O9Y
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VFxz9fFvqysLjXYSTJWA0VfNhhwh/yOcY8mng2WQBfVtoHiAUUIDyKHnNFrgjxhrrIYuu80L9X/Hg2yfQ8r5T0t636JirWECvG/0TKt46AvIxk/TCVNw9R+C29fXqbFATsypBaneQyvtBFOcQQNbzPIHsn29vi1W+b9zn7gHDUH0sWR+YuK56b6VsdIohl5g1ppMbEs/TytV8Gdi8nduuKCbVq4I65UvdSCMAIhVS4FmwBfwknrrGXJ+VYmHWsYCvOsmJ8KqcCr42k0LQJdfKGFcSHKrp91Er9EbT+pSzmkxem8QDrT1AgMx3Eh23b8JMs9O6GjyQsPKQQTIpQhrJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GNgYisBMxaiOII22aYsrZYaBrpunAGhWTw5T83M78js=;
 b=UdD9jwWwqV0EvOixLXeGBTyVg5EKWu50luRUvXVL2BezLizU/xHqBDLlmeYjxQgayRsvGvYH0Eq/ClQPXfiNFIDBiPlxGGLHHPd30AnqbVICJ/wTXpCuyfblm0F9wEuLkH3DypaR5T35pi/RTN+3zqDkwgWhdMpzlUF6PzKwyqnUGT2Q2dzksZp6qCel65T32LUIHmdovIF9/8/ahdA/iakVtLEpmWVb859tIU5B93/vD6gqRyQ0+S5ce0uu81X7oblDY3LG4yPmsRz9a5h+qndZSjp0Y15lAqs/EOn7hsBzPSaeBV8Qlywmx2nEdlyEDNXhfcB184JCDHN9mLG0eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GNgYisBMxaiOII22aYsrZYaBrpunAGhWTw5T83M78js=;
 b=UbMw/O9YMv7LAmJjlI2hwzrt3UsWUNBD3MKlIUlngKUrRk6gKoxNra7mAm/l/+vhMnsIw1DfmMcX7zAX6K61nLU4v6J5SRYn5o9gGQ0XTzu5z0mBe9MNjHkfBU8GgnQNI9/LtUOuBMtgh7OVHHhT+H4HW9E0q6utKl70iXWXO1gXkwB+8Bbyb41fPpkNaeiB//NiNJQFjz6FQOWCLHEUsukyVISAByL3oJDTRxRPbi7PjvFxrNtIOYFNdAMihXWOVWv3wmvwvdK3ivpoH8TsZr6YcXzkywL1/jyT6Pc1JSOmLZNJosSsPJuzHJZVNOeA5fsS5slci8Jj3IrtooNT0g==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB8239.namprd12.prod.outlook.com
 (2603:10b6:208:3f7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 17:26:41 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 17:26:41 +0000
Date: Mon, 2 Nov 2026 13:26:40 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
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
Message-ID: <20261102172640.GB274202@nvidia.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-11-aneesh.kumar@kernel.org>
 <26c24a66-be3d-40ac-8cb4-294deb0108db@intel.com>
 <20261029171053.GD3734323@nvidia.com>
 <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261030131543.GH3734323@nvidia.com>
 <yq5apkwqa5ve.fsf@kernel.org>
 <DS4PPFA84FA90FCEFB18E5620217FDCA728E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS4PPFA84FA90FCEFB18E5620217FDCA728E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
X-ClientProxiedBy: YT4PR01CA0383.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fd::29) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA1PR12MB8239:EE_
X-MS-Office365-Filtering-Correlation-Id: c0e9556f-480b-49b1-deac-08df39067567
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|23010399003|6133799003|18002099003|22082099003|56012099006|261102123227099003|3023799007|10067099003|261009223027099003|261009221227099003|261022105027099003|261022113327099003|261021123027099003|261021121427099003|261021135927099003|261022075727099003|4143699003|11063799006|5023799004|261028144727099003|261026140227099003|261026121527099003;
X-Microsoft-Antispam-Message-Info:
	C8vbDxAwun8Eo18tPTNpOaQmoxxj/gIHvai00JczL9dx2cGIpUbBNnqJMeGmsaoTDonb73FRt/SFPsCIrSIj2FkB5FdhouKRx8LFHXTPex+V2IK/61t6CMoy75bEB5p9lTQlfN+el33YFXGJtZz3oJvW7yqVI6NJNPmf6yD9VQwKxcYGvQwmXv6RVMt2R9EfrgaV1tSOCUK+Op6yQIMSisOGvYX9Ffm8lVxdNdTnCnMx5a4hjJUlFTKdIJSwCup8m/dYCcLw0oUN71YjiKEsChi9jqHnQPYy1RpK1dEorIjOhxbXHQskNl0x+c0LEsH1FElOFDv+5L2QaQh1785hXRy3FjtqEzNFL15skVYRl9wsbYSemy17U8fimfCh/dFSZncY+uDc2cO0NcSwwjchsZDkvC7nDmix2qqNvRiGs0UtgeGDM/S61dp2b730giru4HOdJ4HQknqauU1LntRh3qtphqgPVMwMUnU1s7q3f0XOG3gbrN7Bd25kHUJURbF2KSw56xL3LdV2ky048fZLtZ7ktn/DDYFqqZIvTe1CxFLHSN2pn1K1ZfvWV8GfT95OL8I8DEmlK2sRitZCPTCgR7Ko9igVCoSrZG0sBONOtugs0oZVzOvkYXE5+P1lzws3ye47ciNI8w5prenRg+cGH3js/M2aSevwGsq24vI783Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(23010399003)(6133799003)(18002099003)(22082099003)(56012099006)(261102123227099003)(3023799007)(10067099003)(261009223027099003)(261009221227099003)(261022105027099003)(261022113327099003)(261021123027099003)(261021121427099003)(261021135927099003)(261022075727099003)(4143699003)(11063799006)(5023799004)(261028144727099003)(261026140227099003)(261026121527099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yQP512tZAsa8oMiUIfv5MrBFNxppa8o/gQoMinc7i/aTY1xuqws/Mlm/5zuA?=
 =?us-ascii?Q?RebkZn3ZkheY+whvpPiI+RkPd0inedd3Q5Dg1apEVEk3EA0mgucYy5lPK1wU?=
 =?us-ascii?Q?mrIVqFDUIUzVKwoTDWMoWLvywI2myvgcE+pkqTNmM0GSfxiRdsLEVAS7R/OC?=
 =?us-ascii?Q?JDMmBg0dgpxVy4ZXZvviiJRmZUOAvhWnyC5m60dk/HteDS/jZmSwLpsmsUe9?=
 =?us-ascii?Q?qvZBHQ5nztjnWvuRnvp/jDsted716ncWEp6vhwNp77eSm4/qrKTZBk4BoXoH?=
 =?us-ascii?Q?xn7Yhu0c59e1i8adWN2RS3/uNV235C58rWHu0ijtLrAVKVS4E3RDbWMwmdpt?=
 =?us-ascii?Q?RdJEdjF2z90JwnI//BSi+Mit8rBPJFIaS0q1rrB3XUpK2FQCmKMfya71Zo6x?=
 =?us-ascii?Q?aN8/ih+tsgb5hHlUwPekR8pLZ3gvnRgc8xNMEZAtvItWeTezVGR56cH++DV5?=
 =?us-ascii?Q?StntIYAvRmQccSa8Uz0pPJFBt7iD9ZrT0AKOJH0yWCUJk1cylWALuMbAE+qA?=
 =?us-ascii?Q?5FLyH3db050MKt5WFvDref7GPs8LShMtEC6BuhSyyjXC5hPXXPjFLrKPiRu1?=
 =?us-ascii?Q?NRx6/RgaB+1ofq9BqlylFtqcEWWrLVI0k9cOPQZTpdEnfqfsSYTx3AiRB1XA?=
 =?us-ascii?Q?PI2Y8xmFVKMy5G44AoHI31bo0IIb3GuOcwqHJFqWpb/l3yvZXqZ+dW2bDBfM?=
 =?us-ascii?Q?GtER1K0MgV4ge2vjC4yp3EluM2Gz34FkGAQZtXUafK81Z/mMe0SVqtw7KJNS?=
 =?us-ascii?Q?qWayP+RKgBsJCpEny+C1a0ZSzriEVjIPhIDI7TLF2YN/QGDDonMmzXk8qPDs?=
 =?us-ascii?Q?Jg6DCxeK6I/Zm6Q83ML/0xZAZ3kQlnE6trUtRtHpwt8V0hmVhwepcoh77xnE?=
 =?us-ascii?Q?LvcsCX6E/AAHkSYc6swuj8ft7PxwawrWTFtWHx2phspv/T3UMmIf0G7vzI3K?=
 =?us-ascii?Q?1tG8zUsEL76R+84WVAhWbg5itN+wQSxurmmplA3ODl+9I7MFW3EaMIeEtti5?=
 =?us-ascii?Q?aLh1UTq1BYb+YXRLgdI+oSOZJ1dDPxGlhq1XftPY5TbhQLU0bKh/101FNSaC?=
 =?us-ascii?Q?OlSvKyrKy4OfGNo4KSTrRGkyMDdjLozpQ/SSRXadkU5vUjwyXidRouIEJMjN?=
 =?us-ascii?Q?VSdGyPjJIZMa0v7XATrJlQXLIaezXtNXp2Tw47Gw7hPAcs8EjG7FgMyb56yw?=
 =?us-ascii?Q?7OzyWjIWPmxGBNgPjDTO1ximdMe8Rav2FY1d2r+5USg9Vfkw0kzTjekGtsJe?=
 =?us-ascii?Q?iDlMOIkFOGZ1rMBKEIB5PpZljelGLZ7Xv0eAmdHx8d01dBQlkdlxBCHJ/1VL?=
 =?us-ascii?Q?UVJKrRjB4fxa2SwZQ6k1ahvorwUz/nAFJuSd5m++6Jrl+I2L9/cN3RG8NDf/?=
 =?us-ascii?Q?YJw66nr4I7MfBKh08vSISUXEH0CJV296cLBYvtxHtFY1tm3xljlT1dBXUHM7?=
 =?us-ascii?Q?7zsN6zPQQOHfTP7ZHFr4mUDFt6uQyD/VWf1Sfhku3kM+LHqo84FwPkOfBcqa?=
 =?us-ascii?Q?+P+O+ayzIy6IrD/3Aod+oXufWZCuS1QsUdbUbchWHsc/PHOaT9gydG6nog6k?=
 =?us-ascii?Q?Kt79/ZcYee+rMIm1F93pnJXdFIzQ4um6S6pouLwsbX4ww5SNHSLlLexLYLGa?=
 =?us-ascii?Q?+rYFzRt4SGYdauxgQpG8g1xlrwLLk4Otw/fPbYZ1T9h0EnBxT/76Mly8tHor?=
 =?us-ascii?Q?YxstjCaHRtcujIQ26Obh31aARx2KfZYZfa6hybPX8i7vnVmj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0e9556f-480b-49b1-deac-08df39067567
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2026 17:26:41.3930
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4PoSprJfcqr10u/gZZRhDFSJVsq+p/XsR9v0I4TkIK27p7KmYYB440/fHowOYrTk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8239

On Mon, Nov 02, 2026 at 10:11:44AM +0000, Reshetova, Elena wrote:
> > > AI tells me there are a couple of reasonable ways to implement slot
> > > selection and avoid downgrade attacks:
> > >
> > > 1) With 1.4 match GET_DIGESTS and MULTI_KEY_CONN_RSP=true
> > >    1) Do via RustSPDM:
> > >         GET_DIGESTS / DIGESTS
> > >         GET_CERTIFICATE / CERTIFICATE
> > >    2) Userspace selects slots
> > >    3) TSM module does startup and also issues 'GET_DIGESTS' as part of
> > >       the signed transcript
> > >    4) Confirm that the digests from #1 match the digests from #2 in
> > >       the TSM transcript.
> > >
> > 
> > I am currently doing something similar to the above.
> > 
> > https://git.gitlab.arm.com/linux-arm/linux-cca/-
> > /commit/0657d167aee1ba43dd2765d99b5e3244b83c6ea6
> 
> If I understand this correctly, this is not quite the option 1 that
> Jason proposed above. You dont use GET_DIGESTS and I dont see
> a binding between cert chain discovered prior to TSM SPDM
> session and the one during the TSM SPDM session. 
> Or am I misunderstanding it? 

Right..

I have poked at this alot more and it seems a bit different than I
originally was told, especially if we narrow it to RMM only.

For SPDM 1.2 AI found me this statement:

 SPDM 1.2 para 304 (and 1.4 para 369 when multi-key is off) says the
 device "shall contain a single public-private key pair per supported
 algorithm for its leaf certificate, regardless of how many certificate
 chains are stored".

Since there is only ever one private key active, the only thing we are
trying to do here is to prevent a "fake" certificate chain
that isn't actually installed in the device. The 1.2 spec provides
CHALLENGE which solves this issue, it signs all the certificates with
the single device key.

So "all" we need to do is get the certificates with RustSPDM and then
use CHALLENGE to get it signed by the single key in the device.

This is the best RMM supporting SPDM 1.2 can do.

This is almost simple, except that RMM and Rust SPDM may negotiate
different algorithms and may see different certificates and private
keys because of this. The main challenge will be synchronizing so that
RustSPDM uses the same algorithms as RMM. The spec didn't really
expect this split, it was supposed to be one session as far as I can
tell. So it's hard.

RMM will need an ECN to have an optional negotiable feature to support
1.3 multikey/multislot. In this flow RMM must do the
GET_DIGESTS/CERTIFICATES as part of its signed transcript when
supporting multi-key.

So the logical design is to have RMM run its FSM past CERTIFICATES and
then stop. Userspace gets to see all the stuff it collected and select
the slot. Probably via RMI_PDEV_SET_PUBKEY we tell RMM the correct
slot and mulit-key to use with KEY_EXCHANGE, instead of telling it
during PDEV_CREATE.

From there it is a small step for RMM to support 1.2 devices by also
having it issue the GET_DIGESTS/CERTIFICATES/CHALLENGE flow in the
same way.

Further, if you have a transcript that includes GET_DIGESTS then you
don't *have* to select the slot early. The early slot selection mixes
the certificate hash into the KEY_EXCHANGE, but if we did GET_DIGESTS
then we already have that mixed in. Once you have a signed GET_DIGESTS
then you can just request measurements on whatever slot you like
without any relay attack.

Unfortunately RMM doesn't provide an API for the guest to select the
slot during GET_MEASUREMENTs and we don't have any way to pass the
certificates from other slots to the guest. So from a guest RMM
perspective the slot is fixed, attestation subsystem should report the
single fixed slot (maybe not zero) and the other slots are blocked.

Anyhow, below is some AI assisted flow how you can incorporate rust
spdm and properly bind the CHALLENGE. I'm not really sure this is
worth implementing, I'd like to hear from ARM spec folks what the plan
is for multi-slot and multi-key. Proper spec support, including guest
discovery is far better.

So.. I think we should start with slot undiscoverable and effectively
wired to zero. TSMs that want to support discoverable slot really
should to incorporate the above into their spec'd SPDM flow and it
will work without requiring RustSPDM.

RustSPDM Should be used to demonstrate the flow where we start a
session, get to CERTIFICATES, stop, then let userspace select the
slot, then continue to KEY_EXCHANGE. This guarentees that the
certificates are hashed into the KEY_EXCHANGE for multi-key, so the
uAPI must support this kind of flow.

Elena is it OK?

Jason

Host-side slot selection. The host is always responsible to choose the slot.
RustSPDM controls slot selection, but the RMM establishes the operational SPDM
session.

With a single device key, the slot chooses a certificate chain, not a key.
Slot selection is therefore about getting the right certificate chain hashed
into the RMM's transcript (H(chain[S]) in TH1) and attested as
identity_digest. The goal is to make sure that chain is the one userspace
selected, from a complete and untampered list of the device's chains. No
attacker on the path can steer the selection by hiding slots, or substitute a
different chain into the RMM's transcript.

The selected slot S defines the RMM's transcript: KEY_EXCHANGE(S) puts
H(chain[S]) into TH1, and the RMM records chain[S] as identity_digest. With a
single key, though, S does not decide which key the guest trusts. Every slot
certifies the same K, and K is what the RMM attests (pubkey_digest) and what
signs the session and measurements. The guest is not limited to chain[S]: any
other slot's chain whose leaf is K is equally usable by the guest to establish
trust in K, if the guest can learn those certificates. Those chains need no
RMM attestation, because they authenticate themselves against K. The guest
only has to check that the leaf is K and that the chain passes its policy.
The host decides which chain the RMM attests, not which identities the guest
may accept. Today RHI only delivers chain[S] (RHI_DA_DEV_CERTIFICATE), so
other chains need a new RHI object or an out-of-band path. Since they do not
need attestation, an unauthenticated delivery is fine.

The attacker is anything on the host<->device path (DOE mailbox, switches,
interposers) that cannot sign with the device's leaf key. The host itself is
not defended against, that is the guest's problem.

Approach: require a single leaf key. Without MULTI_KEY, SPDM mandates one
public-private key pair per supported algorithm for all slots (SPDM 1.2 para
304, SPDM 1.4 para 369). Slots only differ in which CA chain vouches for that
key. The binding rule is then:

  The key the RMM verifies at KEY_EXCHANGE must be the same key K that signed
  RustSPDM's CHALLENGE_AUTH.

RustSPDM and the RMM run separate SPDM connections, sequentially.

Scope: this design is only for connections where MULTI_KEY_CONN_RSP is false:
 - SPDM 1.2 and older devices, which have no multi-key support.
 - SPDM 1.3+ devices with MULTI_KEY_CAP=00b.
 - SPDM 1.3+ devices with MULTI_KEY_CAP=10b when the RMM leaves
   ResponderMultiKeyConn clear.

We expect an RMM ABI change before the RMM supports multi-key. The kernel
must explicitly opt in to it, for example via a PDEV creation flag, and the
default must remain ResponderMultiKeyConn clear. A kernel that does not opt in
then always gets a single-key connection, and this design stays valid. A
kernel that opts in takes on the DIGESTS-in-TH1 flow below and does not use
this design. Until that ABI exists, check that ResponderMultiKeyConn is clear
in the RMM's ALGORITHMS anyway (#3), and fail if it is not.

SPDM 1.3 added multi-key, and with it the right way to do this. When
MULTI_KEY_CONN_RSP is true and the requester issues GET_DIGESTS immediately
after VCA, that DIGESTS is included in TH1 (SPDM 1.4 section 12.4, para 1239):
  TH1 = VCA || DIGESTS || H(chain[S]) || KEY_EXCHANGE || KEY_EXCHANGE_RSP
The KEY_EXCHANGE_RSP signature by slot S's key then covers the whole slot
inventory, with freshness from the RMM's KEY_EXCHANGE random. No RustSPDM
CHALLENGE is needed, and if the RMM cached and attested DIGESTS, the guest
could verify the inventory too, without the replay problem in Limitation 4.
However RMM 2.1-alp2 does not issue GET_DIGESTS (it was removed by
FENIMORE-868). Using this needs an RMM spec change: issue GET_DIGESTS
immediately after VCA when MultiKeyConn is negotiated, and cache and attest
DIGESTS alongside the VCA.

Part of the multi-key enhancement for RMM must include moving the slot selectg
from PDEV_CRETATE to later, after the RMM has issued
GET_DIGESTS/GET_CERTIFICATES. Possibly to RMI_PDEV_SET_PUBKEY. This will avoid
any need for RustSPDM on multi-key devices.

1. Run this sequence through RustSPDM:

    GET_VERSION / VERSION                          (VCA: Version)
    GET_CAPABILITIES / CAPABILITIES                (VCA: Capabilities)
    NEGOTIATE_ALGORITHMS / ALGORITHMS              (VCA: Algorithms)
    GET_DIGESTS / DIGESTS
    GET_CERTIFICATE / CERTIFICATE                  (every slot in the slot mask, all chunks)
    CHALLENGE(slot 0, fresh nonce) / CHALLENGE_AUTH

   M2 = VCA || DIGESTS || all CERTIFICATE || CHALLENGE/CHALLENGE_AUTH, the
   (A1, B1, C1) ordering in SPDM 1.2 Table 38.

   NEGOTIATE_ALGORITHMS should offer the same BaseAsymAlgo/BaseHashAlgo set
   and version ceiling as the RMM's request, so both connections converge on
   the same algorithm and therefore the same key. A mismatch is not a security
   problem, it just makes #4 fail. Only offer algorithms that are acceptable,
   because each one is a separate key that an attacker could steer towards.

   For 1.3+ responders:
    - MULTI_KEY_CAP=01b (always multikey): Cannot be supported without RMM
      support, fail.
    - MULTI_KEY_CAP=10b (requester chooses multikey): leave
      ResponderMultiKeyConn clear.

   Verify:
    - The CHALLENGE_AUTH signature verifies with slot 0's leaf key. Call this
      key K.
    - CHALLENGE_AUTH Param2 slot mask matches DIGESTS, and CertChainHash ==
      H(chain[0]).
    - H(chain[n]) == DIGESTS[n] for every slot in the slot mask.
    - Every chain[n] validates, and its leaf public key == K. This is the
      single key check that the whole design rests on. If it fails, the device
      is either multi-key or violating para 304, so reject it.

   Retain the VCA, DIGESTS, all certificates, K and the CHALLENGE transcript
   immutably as part of the SPDM connection.

2. Provide the slot certificate information to userspace so it can select a
   slot S.

3. Initialize the RMM with the selected slot. From here on RustSPDM must not
   send anything to the device. The RMM's GET_VERSION ends RustSPDM's
   connection.

    RMI_PDEV_CREATE(id_index = S)
    RMM  GET_VERSION / VERSION                     (RMM VCA)
    RMM  GET_CAPABILITIES / CAPABILITIES           (RMM VCA)
    RMM  NEGOTIATE_ALGORITHMS / ALGORITHMS         (RMM VCA)
    RMM  GET_CERTIFICATE / CERTIFICATE             (slot S, all chunks)

   The RMM asks the host to cache RMI_DEV_PROTOCOL_DATA (the VCA) and
   RMI_DEV_IDENTITY (chain[S]). Check:
    - For 1.3+ responders, ResponderMultiKeyConn is clear in the RMM's
      ALGORITHMS.
    - The DER certificates in the RMM's chain are byte-identical to chain[S]
      from #1. RootHash may differ if the RMM negotiated a different
      BaseHashAlgo, so compare the certificates portion. This check only
      confirms that userspace's view matches. It is not the security check,
      TH1 in #4 is.

   Retain the RMM's VCA immutably on the SPDM connection.

4. When the RMM reaches PDEV_NEEDS_KEY, call RMI_PDEV_SET_PUBKEY with K from
   #1. Do not extract the key from the RMM's cached RMI_DEV_IDENTITY. The RMM
   does not parse X.509, it only checks that the key encoding fits the
   negotiated algorithm (RmiPublicKeyParamsIsValid).

    RMM  KEY_EXCHANGE(slot S) / KEY_EXCHANGE_RSP   (clear text)
    RMM  FINISH / FINISH_RSP                       (in session, opaque to host)

   The RMM verifies the KEY_EXCHANGE_RSP signature with K over:
     TH1 = RMM VCA || H(RMM's chain[S]) || KEY_EXCHANGE || KEY_EXCHANGE_RSP
           (excluding Signature and ResponderVerifyData)
   The device computes TH1 with H(its own chain[S]), so a substituted chain,
   a modified VCA or a device without K all fail here.

   If RustSPDM and the RMM negotiated different algorithms, or the RMM
   negotiated MultiKeyConn and slot S uses a different key, SET_PUBKEY or
   KEY_EXCHANGE fails.

   KEY_EXCHANGE and KEY_EXCHANGE_RSP are clear text, so the host can also
   verify this signature with K. This is defence in depth against RMM bugs
   and makes the retained transcript self-verifying. It is not required by
   the security argument, which relies on the RMM's verification (DEN0137
   IZJNMR).

5. Report to userspace that the connection is open with slot S, and allow it
   to view the immutable data from the connection: all #1 certificates, the
   slot layout and the RMM's negotiated version and algorithms.

   The kernel retains the #1 CHALLENGE transcript and the RMM's
   KEY_EXCHANGE/KEY_EXCHANGE_RSP transcript. They are not needed by userspace,
   which trusts the kernel's verification. They exist for debugging and for
   a possible future RHI object that lets the guest verify the inventory
   itself (Limitation 4).

Security argument: K signs RustSPDM's slot discovery (VCA, DIGESTS, every
certificate) and, through TH1, the RMM's VCA and selected chain. An attacker
without K cannot:
 - hide or alter a slot in #1, because DIGESTS and the slot mask are signed by K;
 - substitute the chain the RMM fetches, because Ct in TH1 is signed by K;
 - alter either connection's negotiation, because both VCAs are signed by K;
 - put a different device behind the RMM, because it cannot sign with K.
The single key check in #1 ensures K is the key behind every slot, so the
slot 0 challenge vouches for the whole inventory, including S.

The CHALLENGE is mandatory because it is the only thing that proves the
certificate list is untampered. Each chain authenticates itself against K, so
a modified or added chain already fails chain validation or the leaf == K
check. Removal is different: without the signed DIGESTS and slot mask, an
attacker can silently drop slots. The CHALLENGE proves the list userspace sees
is complete and was produced by the device holding K, at the time of #1.
Policies that depend on what is present, for example "the owner slot must be
provisioned" or "reject if the vendor chain carries attribute X", or tooling
that confirms a SET_CERTIFICATE took effect, rely on that completeness.

The host hands
K to the RMM at PDEV_NEEDS_KEY, which binds the RMM's session to the device
and inventory that userspace selected from. Trust in K comes from the selected
chain passing the verifier's trust policy.

Limitations:
1) Connections with MULTI_KEY_CONN_RSP true are not supported. They should use
   DIGESTS in TH1 (see Scope), which needs RMM support.
2) Slots only differ in which CA vouches for K. They protect against a
   compromised CA, not a compromised device key. A leaked K lets an attacker
   impersonate the entire device and SPDM session so everything is broken.
3) Trust in K comes only from the verifier's policy on the chain. An attacker
   holding any CA the verifier accepts can impersonate the whole device, with
   its own key and a self-consistent inventory that hides the other slots.
   Signing the inventory cannot detect this. Only policy (pinning the expected
   root/slot per device) can.
4) The guest only sees id_index, chain[S] (identity_digest), K (pubkey_digest)
   and the RMM's VCA (protocol_data_digest). The RMM never captures DIGESTS,
   so the guest cannot see the inventory directly.
   With a single key this only matters to guest policies that depend on
   completeness (see Security argument). Which key is trusted does not
   depend on it. Every slot certifies the same K, so the host can hand the
   guest any other chain for K unauthenticated, and the guest just checks
   that its leaf is K. The host can still withhold chains, though.
   Partial fix for completeness: give the guest the #1 CHALLENGE transcript over RHI. This
   needs a new RHI object type, because RHI 1.0-bet3 only has VCA,
   CERTIFICATE, MEASUREMENTS and INTERFACE_REPORT. It is signed by K, and K
   is RMM-attested, so the guest can verify the inventory.
   However the host chooses the nonce, so the host could replay an older
   inventory.
5) Requires slot 0 to be provisioned (SPDM says it is by default) and the
   responder to set CHAL_CAP.
