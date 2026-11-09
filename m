Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794267639;
	b=njr/zfTunEZd544RrkpfOt6WJGwbAGc7StWqtsG+5bwhZ1MkQIdeplWbIfoisrqCbkYw
	 bTaEcoL6E/DnuqL65HFZ+Vfq6Z/gaMGNkBukMYHdjg8gBOsRKwErioM7uJEb1RyTJZm7K
	 paI8Yq1+MGTN0TaB1WK4g47ozNEDtKOpdZlot08Qnlf2GSWKsY+AyRssZPFs/GxWWEckr
	 GJ12njdikiP987r9OU3QDRNPezEcoez1x3FKnYLJSNqqSy6SjE4gc/hLyc6NwC3ygZnjm
	 VTaphECNWSoiX3hpsV8Ykckn2ifcMTgql0fe70CSMZAPdhWLftJmKXjUBisah0OZJuA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794267639;
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
	bh=x0BfSH6a5nE141EhV909Oy4Wpk4Lb51SbpONz+4zwKc=;
	b=MeC++XjYITVzttPHCyKWzeLJRqReq7td8vpK2MyllfpGYkqRwV/iaGR6qTZ+46JEPXBP
	 Lt1ocIZWJi+9zCYg08+AcpBQPGf+2VSBNVh91Y/5eSPqFDNbF/YvIhXde2goUC+plwFJh
	 5lnBsAWJNvCLcVw+ScFUq0ZDiHylD39fwaeT91yap+W+7iN7oY/Y7bw+y378DJcH3+Ftf
	 jcCLJISnOABCucIdqp19fXiWslFoEuMWPzfueBJ+26YBSycVpOUP8BjrT0rtL97kXi6dN
	 hNITGIVLdsdpKlcKzELJnD7fl5/neTmCTUHHXHMxNWNrH0ya6D2vvo5o1TO8czRHtjg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b="Q/+cVCB+";
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.46.54
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010054.outbound.protection.outlook.com [52.101.46.54])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B2D606A321;
	Mon,  9 Nov 2026 23:40:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50B2D606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=Q/+cVCB+
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=epKm2/ggylLpm+L1iQDOdIkNZkhPWGoERrzFRn+XNFEvJzCSszWNpQJhtWOTOPumAJPpJmZm+iIT/pd0AwEaLyacAViJZO5oiGBtzv0nSnwg65xIrZAW4tdEuQnmP9HcFHu65vlQLBqcUroNjHQQFJ4N94TAUmL2hNgWEXgLgIzBrTCwfuY1sZflsOWrtwIIsCSg7iNXiDSVo+kDZ30Gp4kq12Ny/D7yn6MWBs78kwSlvgeM8tG05Ho47uC//GPCb15iHna/3HHUSytxiO9vS/fSLXQ//pJpiIpnyLUTRG1jHdNGhW8y6FZmu7ZpsmMUVVGWgLw/nV/j5c/2qmMOTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x0BfSH6a5nE141EhV909Oy4Wpk4Lb51SbpONz+4zwKc=;
 b=gHkuLUFvNEFFOoLxvLE1EKdI5p6gsu8ygEzCbJdCVsHm340kKmMBmQkaHsv78AR8YtOhTZfRYsrPUGV1QEb9J14anKF4rJfvApT47jrCfWyrF5qc70MUfO+NlvWOBzD9V/i/HV4qC+kiR9m2zGhlpmTFwYXAUINW08T3Z/gbNwSayPh97h0neiNajNU8VeoaGcuI7Usy3lrtu8aQrwC6qU6F8uWBkZ6vQ3abjo93X5OE4bnaIKx80k/vIZ38x/I+cm33L59RFqT1lRg1kJlgNmsqWQy7gOPOvqWxym0aAAvZtQXjT3R8wty7DLR0aGgLZBN3Vmj6YEfiK24ktQaHXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x0BfSH6a5nE141EhV909Oy4Wpk4Lb51SbpONz+4zwKc=;
 b=Q/+cVCB+vldTXrzzt/2L1pUGg0kYEcNao7q48a86e5MT3hkE2vsfhZ+HFB9X7vbB5k3Mk8y2gAccUrHeFe/24hya8RlN3VquWOw0VeI32MOIBa3FOEq9aga+qKEac/FRgNttFFMgmplmPIQ2aSOod2mYlHODfPlOTbOeKe8qkIyHUKq+VSBB30J12Hh4IjjQ1KQOSsC5KCQjEANcOQseJxLmaTi2bZWcpOAXc9Fd48++5JJ+ZEuKaLG6lprwQhTK5ZZInnS78BMyougtrD/kTj3SFw/Njw826jCc8BmSJfJMWdoEfh9M1aNPIIBNAuyxDXkBYQnYQRNrURzOJ8Awdw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by MW4PR12MB6899.namprd12.prod.outlook.com
 (2603:10b6:303:208::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.13; Mon, 9 Nov
 2026 23:40:33 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0592.012; Mon, 9 Nov 2026
 23:40:33 +0000
Date: Mon, 9 Nov 2026 19:40:32 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
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
Message-ID: <20261109234032.GT770409@nvidia.com>
References: <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <53bc57bf-1ee1-407a-b48b-bc6b2deee12a@intel.com>
 <20261108183337.GL770409@nvidia.com>
 <2b89b830-f1e4-4304-93ee-40287a4b5b2d@intel.com>
 <20261109185315.GS770409@nvidia.com>
 <e1fe8fa5-7bcd-46e3-bfe8-368582304222@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1fe8fa5-7bcd-46e3-bfe8-368582304222@intel.com>
X-ClientProxiedBy: YT3PR01CA0037.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::14) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|MW4PR12MB6899:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f924d56-802b-41f7-b7ff-08df3ebad922
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|7416014|18002099003|22082099003|10067099003|4143699003|11063799006|261102123227099003|261026121527099003|261021121427099003|56012099006|261022075727099003;
X-Microsoft-Antispam-Message-Info:
	ksViPiZ5/nUbyfzKJT0ui14gk1aez7/Glqzetyuh9LvLZU0mPy4EezjaN8BDpw7rfXm1HAmP1cvaXg7KnXbPTbX5Li/7jNd4F9qG9WzoluNR10TX8eeUga5JMhaNG8rDobec8f8nxppsgxANSgsWpIGJS866nDk3oCjb8DCZD7U0iE9VnxWFCq1n7rHoDecNKkU1M35R4sOfz0uxMAltGv+3rWrl0NezrfAqzd6OHOyNeJrjF7PL+dYbdyWR0I5jpZIgo9RT9ggYLZOrLc+VVuDhIBFY9ecrt/Y5aQn8+oISt1dJyQN6PQELbNSmK9gcWnwIll6MvP9DehYvbeVrvxiW9zPaw8syOb4YzvVCyj5tRaDa8MqxCTwXPFMa2BPduvK/3e7S8eey4LwDmK/xEgpiHAyuz8fVNt1v7psz5Zj1OcenbfzOt986wYQp42ZfMpEwzNPkkthjjBRXQk81Ruo7+gNFG1gLM5FQnkl78nKz6a51h0n1alS7cEDFbH/ByHrnySIb1RC7gyqFZGtITqsqvWZRMO5MT8bconyRKxlouNYZoKRye4qlvKboOHB96gmf1oC/IHaD8DiFVONVZmrdue8V5qe1liDv7nW02L6yL7FLkWYMscK9Xu8MowL1u+s45WsUyAwctPKL/ScBlnxfUlJTnT0gEjrj6VzcxHE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(7416014)(18002099003)(22082099003)(10067099003)(4143699003)(11063799006)(261102123227099003)(261026121527099003)(261021121427099003)(56012099006)(261022075727099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JXaR2HxpUGcl62omKmbeD2O6bXAfNle+HC6Gds0PZjpWtY44oHFrqxeP0lbG?=
 =?us-ascii?Q?daoHHb/AdiKLbuUlm+j5w97mRCPVJmqr2OC/kMDQ5RKPelLS0sn7kHcnmiV7?=
 =?us-ascii?Q?2EKzoil876vgfjSvP4Y8i1+EgKodgNioAmfaJEy7Mm2Lb6dcSqAtRYDagHnl?=
 =?us-ascii?Q?Ulyws/3sOrVWhFsvDpi2daQOtusvfsMw093SEwvJUkt/8XLfrVORipcDu1nW?=
 =?us-ascii?Q?IHkT/bbz/4NiJAY71moo3RRv4S7s9tro0Uf/HH/d+SgIZ0TcN0CpbZ5DBYE6?=
 =?us-ascii?Q?lYzIXOnBPCtGi62Oq6tf0VBUWq6cwLRYQX6WTFMEpuejVURJmnInkGuWsDI3?=
 =?us-ascii?Q?78+3eqqBi+qnDOTdP9YUCJpCr/hscj8hBd18gwvSZHhpmSu5MpJdS76QqqKi?=
 =?us-ascii?Q?y7OE+o0nsWDLl5e6BWJ+objvf45Atwmfv/WthJyKrZnbluAEBbv28P4p0oFA?=
 =?us-ascii?Q?SufOJTK1YZHoJJ0EETb5ShoGz6WQTeAk/j2s5hHX/uqaQhd+i19FpTZc/k7Z?=
 =?us-ascii?Q?PVWh2uuIsIDFe3DJojBDf63hT4O3z37EYe/xCNfqFW/JFvJGRV+sM6090Wqi?=
 =?us-ascii?Q?GI/h9eCBG8s3rA/cvOBdvmZIe00au6zQuROyZavKoqa6QSvtMuKpLSlIdhuw?=
 =?us-ascii?Q?zZ5R8iw1n5MlO/KqXnwAr75m2x1VGKU+FQF28rTR1zfpBWZ+I2MdYQATcSne?=
 =?us-ascii?Q?1FMQ/MHiaRdEYa88NQSxlYoWFbceMVNlbR/FS2/ZqOT3/yXO13gjiVM+heR6?=
 =?us-ascii?Q?mP20es7T6Byz+ItmAW8VVRKfWETNUlbED7/QhhGEjqdMDQJK3wfttzzRliTK?=
 =?us-ascii?Q?Z4SviAhsvm99fa9uCtSHuVW4NftcA1P/duoKmEimrbhzvq2bQtjoDLOElp/o?=
 =?us-ascii?Q?KdaFCO1+OQYqyJAd2E72vIT7NVpMbdUSCf/ZonhMZ/lmV/KKv2Quf+R4h4VD?=
 =?us-ascii?Q?XcR73bBw5g+0bFwFEQfiuOmmMixpaNs/8KIsMdkrymro9XLaYaGd+jVRNEiN?=
 =?us-ascii?Q?SvLu5wFa20rj5XE9JlkxQYmC1XVeC6pif6ewjM9tVD8RHbZ7DHV2fS9vwBO3?=
 =?us-ascii?Q?+GxpvlNN0k/hGr3NWIXnGXoNJZEFgoYqi8BWg//ohNSABdSQZ9vn/kfpKAVS?=
 =?us-ascii?Q?Qzo84u4IxbdB/o9E5rRJFNEaat0Je+v5IPY2hdRishGcuU1HK3O48b6YenLD?=
 =?us-ascii?Q?lwQWa37ufcEGPG7swNlAY09e4MtH5U6ImcY0ckXH1XCIuU3/cftho4x2bONg?=
 =?us-ascii?Q?8PNrhKtMF5sbwlKmIemz4bpc9nmJ1dqpvYk/UwsV5z/DFJKsLI/9m2WDeaYY?=
 =?us-ascii?Q?Nj4q7X9sM10aBU8q1ZBboHV5hAq6KbYZJZ0cwv3B0XopNDtUDab+nVSA4i+v?=
 =?us-ascii?Q?IOFm2zM8RTiv5q5r4GypZsSQTIDtJJ/KAfhgTHLuqwlOvQuGrcu5BaEd2nBM?=
 =?us-ascii?Q?08Dik7uGrU/iZeL6o3dLnW6KQXYH+rhQUvTvVlBjY/pvHOgokbr2BOZ9JFfn?=
 =?us-ascii?Q?Me2pccEqc3Q9T94zvvmex5pKbWEL8Jf0FXSdrtlLJJ/9kS69ZnZBCmmhoGOD?=
 =?us-ascii?Q?FdeINQTmTvnN+W6NGDmRCXnxwALtYNkBh0FOndf26ZjpOdnebhKzjA031fYn?=
 =?us-ascii?Q?0f7uueDEAw4SmrQyZbNbXr4/jCn6lzR2c/5lKUGvJ0k11Upu2TTUbDUT839x?=
 =?us-ascii?Q?q82Z6F4TZ254DNp26RUVXFLjHINkNe+9kTdQyytk9ooqI3Mh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f924d56-802b-41f7-b7ff-08df3ebad922
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2026 23:40:33.8710
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K0B59VkNU+SAfqaOmUY6QvOn5Ua0SlPL9CmKpAGTP/O1EoxNCIzNzrmewKeRQdKz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6899

On Mon, Nov 09, 2026 at 01:54:57PM -0700, Dave Jiang wrote:
> > Why? Seems like another wasted operation..
> 
> The TDX module runs it as part of the connect and with the current
> module the host can't skip it. I'll discuss with Elena and see if
> this can be different.

Does it come out anywhere and become visible to the host or guest?

> > In practice this means all the TSMs will need the kernel to tell it
> > what SPDM versions it can go up to.
> 
> TDX has no input for that today. Will discuss with Elena.

Nobody does, but I'm interpreting that as meaning 1.2 doesn't require
a flag and if anyone does 1.3 they will then need to add a 'enable
1.3' flag from the kernel, for example.

Jason
