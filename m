Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.31
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793800807;
	b=RY+YcxMNA3mVsvEBkZbfiS/Cxj1McsGhEhlKqKh55djucBPMRdoOAd9TEBQMImcgfJpa
	 see4gv7uYDoYzKau3DABMfN4IWeU9KNQxb5Src2ksBmsqL5kG82u0VU9o1cFbS6XzyWhk
	 cP+vu2vS5KtZvHf9zo1tjo1c3iqxEMHnCSRQk/tuAvCdQog28aRr8SxmzTx7lbTEryvrg
	 TgOQyXjbKxr/T9WlYyXI7lyZxQxB/lB8l1pcqZGT9WwuQas2jzGnklccun4rGJ5vG7LW2
	 yOc9Dv2D3K60ABXsgp9mK9m0nZxZlwrjZBqzHm3xketXPsj90hlPH1UtomAJUxA4icw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793800807;
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
	bh=Kp/dwD0UO8+OZBtdC6d0zC+SZhYs5xBHLxmsX23N1MI=;
	b=vMC3L7bD+2z1nK5dCryrprdPUT7TdUCL7Vu/Ijdf2BuOt5KGc9PcAeSzRq72tROOoJAg
	 MqKnOGGCzgT45hAL1BdeKctzWbYbo9eaByBM+hNBp2F3YVZCHBizGCzAjX5HrOOaBbTBd
	 iLC2KW1gBU8Nfy7OEQP9HaTSTXBzgWGHBEzfiyR33+TGaic63Ib5zVbbxbfNPvue+fPMj
	 gWnzuAzFtN0pQFWbFj8xBcLg2VtBWvtUJtw/SwG9ORjRvCu4F28MnjyIO0HeCvCxZUz0h
	 By1L1ZxiBwfG3FtDf409nEZY/Rz3kvJujYiR5tJIDNgxYCnOVsuVMBzHcvFUQiy783A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=sinmXoQG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.107.208.31
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011031.outbound.protection.outlook.com [40.107.208.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC0A606A31B;
	Wed,  4 Nov 2026 14:00:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DC0A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=sinmXoQG
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O6EW6yRrEbfY1n4Fer4yJOOgJxEhnQN+KxAc7ten5D5VPQnkhKuCkQrTPciTezD4sAV+VBBiGM3uH1i2aB6oywTEi0pfxjieZ2Rdxp0EnqrLgrNdriBTwS2zmr1FhxAqvYW+2kXTqkXiqk+IsUrMde9pJ97Af/wR+OfbOIugOaO2azaWMyX8raeGUZZnnRD4Qu1S3HSQ20j5NO7acY+1wZM4fQpx+KmrbisgNUsoDB1VGW4Z+iX3ZfT98P/y2HaZ2D2nJ7jczrrIm4nD+JvJVD6lcNaVGjNOtpUIv5kyq1TgZTtNoVfJiJ1117VLd9/KrAeeNuWPm/8IwSp3ojHi2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kp/dwD0UO8+OZBtdC6d0zC+SZhYs5xBHLxmsX23N1MI=;
 b=NNKmARSiYhWJj3M+rb0/veVMrqHMHsGIiEPIRdCbk69wi3a846bloQ1Vumypzc5g4MlZEF5IGl2NQ/GICXZ0yeW3TASx1UJKfq0TabUfKWT+xNMVyIutt6D6wmPMg9hEgruXfECKHc7S8C2yULzz082n3uZirAHfU7IWL80wCUyjrJ4lAvHrqz1ZzntdTVs6HVAIaBIJaakOVcz8D1vdkI0d6FYoqVAL7h2ayDCtaDhtGXfN1NSyrqdn7LkTR49bU+9oYOdvtsCc7IfdLecA2QoQM/7ASWEtrrVBmGzlHBUdNc2cFof3wmRXF3nGBxVRlk+KKKhH3Bw6zTGsbKfqAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kp/dwD0UO8+OZBtdC6d0zC+SZhYs5xBHLxmsX23N1MI=;
 b=sinmXoQGZJs14MndR5mq321oCyNzlDHK37Ph5lzrxVZwfq9i2qum+YogJia+pgVgcS0xuOl5g+hKOYcjjAPVGMh+5cvWr5PC7rSotwcOLKRSBt7z9o1tyr+IonIsbIVB31rI11dVOqaiVYwXwXlX3Wu/yFoqcbFQirIWVrGzh3WGghwOfti4vuuPP4Ii5qFI+e9Mn6XyYIluqGUtfHvLVksAEm5YJ+3v7yNMhg++uuNyihYb8oG64RptMtKFKZeWd0wtwRCM33VcuprYT/cj94JZIJRqlc9CjKCU08gAuB1AYavwJsBXkczXytzVatFxscdZCaHVxRuT8B/En9U4LQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CY8PR12MB7217.namprd12.prod.outlook.com
 (2603:10b6:930:5b::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Wed, 4 Nov 2026
 14:00:02 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0592.009; Wed, 4 Nov 2026
 14:00:01 +0000
Date: Wed, 4 Nov 2026 10:00:00 -0400
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
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev,
	Dan Williams <djbw@kernel.org>
Subject: Re: [RFC PATCH v1 06/11] PCI/TSM: Describe the PCI attestation
 control family
Message-ID: <20261104140000.GT274202@nvidia.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-7-aneesh.kumar@kernel.org>
 <auShvL2m00S70H3d@FV6GYCPJ69>
 <20261030154353.GN3734323@nvidia.com>
 <auh_GGpJ0ngQTETS@FV6GYCPJ69>
 <20261103154539.GM274202@nvidia.com>
 <aur3SrC49Z7FW6c7@FV6GYCPJ69>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aur3SrC49Z7FW6c7@FV6GYCPJ69>
X-ClientProxiedBy: BN9PR03CA0842.namprd03.prod.outlook.com
 (2603:10b6:408:13d::7) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CY8PR12MB7217:EE_
X-MS-Office365-Filtering-Correlation-Id: 75dca738-8830-403c-7a49-08df3a7beb83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|7416014|376014|366016|10067099003|22082099003|18002099003|3023799007|56012099006|4143699003|11063799006|261028144727099003|261026140227099003|261026121527099003|261022105027099003|261021135927099003|261009223027099003;
X-Microsoft-Antispam-Message-Info:
	FKTOjZfnH9shZz+FqBVKT3rGHtNWgsrabkEgwxm0kt3MVF7IUZFzt/gEUEQpv+NYRW5DWv5Ww3piGsuIsoDmWbfZY0oMrGCCE5297didspoM65dvGeH92TD1ThFS2+2RHlFFTFIDk1br7UlXL/gUqUADJ1Pq9Tu8JT2Fb5kNUVUo/lCqM0Oj6LNNL0XX5lvFt39sJHk/3ti38E20ze8dMqdeNmfIBLDvgkYM47iHTHg40v0MHTo2r0pSagi/AJtbSys+QeC/AlHHua8w2UNoz2hNsSFJhWtXrCHGD9W6aHL2IGd2dbjUepO/ABl2KkeWY4lF5+6jEhZQ8y7t2enavLnjNRFk2/7y2hqJIsgtrY5cMC0uFHkx7te42WRGfurBQy10Cp6ZA7Cun8afcEdKCIjNwX0Qo9ajoUiMobUpbOp/O3VBT5Yb9DnBWo8oEW+0emcuDzjnhbNk2m+d457o1sKq+ShzuOaV2b7PcBnZy97NinmMCfLoPKnSVUM4aoOFM5zz1OwSYhXbjpWnrxFjzhcASwnr3+VfffwSnC0NMKCTYlwxDi5qziWc++vQbVCkvelOyywqwtGZqeBQfO/Q8Z2u4jBYg1eCsAwh0sTIxaHummAlL7mim+lLgQbUw3+RLqplpRVeUHPXx8hE7MIl6FZvC0lZTrsRQxJk9dlKIqc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(376014)(366016)(10067099003)(22082099003)(18002099003)(3023799007)(56012099006)(4143699003)(11063799006)(261028144727099003)(261026140227099003)(261026121527099003)(261022105027099003)(261021135927099003)(261009223027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7jsCrKalPRnzkEZ3ZJwnz0lVIaSsdKfRe/09mrXYzka6gM5nl9CSQ1x6soy1?=
 =?us-ascii?Q?SGfpZwkVRTfg7B+lakWuhVFwnbWqpEigy0iNYkQvgol6Va3SqSjhXTuu9FRw?=
 =?us-ascii?Q?yFb+VO1veUkLx3gfB8bTdHortKoVqMCbBckwM6T2YOq5c6COAwe/Ssdco1S2?=
 =?us-ascii?Q?7zCdDiyHp2f/gBrp9TpcbnVaiu7d9l4iMNwiwC3Inxoj8XMPTc4WG3YeJqRN?=
 =?us-ascii?Q?ga70OTmVgnarZ+HSY17dnSEhIeNNbGi/p/wihFA/rNI1GfeO0tpastUjgy1D?=
 =?us-ascii?Q?CFEgYclNs8BxXyK+Lwqj/FBE9Dy1abPJeNAAmNI7Pba4DDfYjRdmcuG4BkQ+?=
 =?us-ascii?Q?Pg3f7z9Sxgtx3/eWo+R01qZJjwIRF2zUIyANkD23ZwRZ3LUFpS7OU5r1vSJt?=
 =?us-ascii?Q?5MNi3qtPwHblGfa4ZMlP7ZSOaQH9fCj6SSfemtfjOfBQwvqcub6CchEHnC6t?=
 =?us-ascii?Q?s2vHcMrZ37iXemr/5G+ytlR8r6P/TpdzjWIyU/Fc5q/di0LcfdD7/JzjPVe3?=
 =?us-ascii?Q?7tEgMKRfB8NnjeRqSa/cBETKKBpXvZwc0CBGmz71kjC2Rez+v4Lr00zNAxAZ?=
 =?us-ascii?Q?7U6+QEHRAKIYI9DmB33m5J9+9SHE5IT3+gNvPhGW82wStUUTzyB3PI6DzPAo?=
 =?us-ascii?Q?rJeYjHYPu9WHNqetlJEGAlmGfIzDN6QT2Os/NLS/5otGEl2G0he0zKUEsoul?=
 =?us-ascii?Q?g+aA8gVnmCQSAvw43c2SfI8S3tN/06c/6vSNN3lLjs5DZylzmbwLIjgGkZYG?=
 =?us-ascii?Q?+Sy4CLsktgtXLSvNhSZlUn9F3G+dEJRW59IBpgD5fNBaFyIjambQhMXXHZ5c?=
 =?us-ascii?Q?0mHkaL9mCiHQ/AfxtMd+G8UfDy+icBfjoJ6M20adUeEZgagP1Zmf5Kd+xqy6?=
 =?us-ascii?Q?Zy2j0kRDOnqszUZpgzGcn3ymDkGxcW4WFrGXOMAHpAsBpovKtHaEBgSQOJXy?=
 =?us-ascii?Q?XkHIeGFToJd+xBmBV5d75CzYolkA86r1c4PP654oCDD0MkHXTzVersmayTyK?=
 =?us-ascii?Q?/LMzncuQSfyrgI9bPxRzlIoHrovcQ0cG4LsaZOMjhTadRa9Rw08fMIut6yuE?=
 =?us-ascii?Q?gACDe175pwZeN9F9rIZKQIWr/Mj7b6NQAzyv1KQZVw49zCsKJ2zFUVs28l6j?=
 =?us-ascii?Q?mDbv5LDPr4OhpUBh41xfgHNzVjl0BRgVJBeOiA3FidMVdXkGcHn+pp1Soj0d?=
 =?us-ascii?Q?umTb/UNMaRPTCnqQANUu8hJ2cW3/kC0810zxv2p6OGKc5CEaf8nAonia22xa?=
 =?us-ascii?Q?RIZCpGLuGoFjQ5s5wkKpjseKtyYynC6qZM1aIsGhZ4M2d4m9ECLPsNSEUXZ2?=
 =?us-ascii?Q?LYTs2t4iQsG+ETawl/8EGhqfX8tlc+SzNlOls8PSkuGOIMmCO1Se8ZAcpRLf?=
 =?us-ascii?Q?L9dK2XPB/njSWAFYyKcVz695/92rJ5ZPK5ZqkUSokLsWswvYumGDOF09dD7Y?=
 =?us-ascii?Q?aweYxk8IK0kXg3uFp7pgOR9iadHojAKh+EO+3i/7H5vJl2pF8Ny0W+sbt1RH?=
 =?us-ascii?Q?iFwkBJyypLfaN7TsLaV9QGVSXp9GEgeQ2Sk4bVDPPBh2uxjSTeBeC9tAYb8v?=
 =?us-ascii?Q?0EwF/nqRIpzp9F44UQ31yV2En+2NAANystyowCJiBu+Ao79ILom6etDvusGN?=
 =?us-ascii?Q?IB9T5Ei/x58AWSXnajGrrqkxlAFUyhMPKsgNGfip4hywOW/BXNdooy2GFTXO?=
 =?us-ascii?Q?8Z+7wfLFO2U78BcGskI5TKkU7QAwLezV0horl4+HE8lbJy0m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75dca738-8830-403c-7a49-08df3a7beb83
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2026 14:00:01.7404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rJtQ+pnsp8C1X61uZ4lqttqly2hfrvCMQWjyWYvQG7S5ttYeI+468Nuf5FFWG+CB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7217

On Wed, Nov 04, 2026 at 10:21:02AM +0100, Jiri Pirko wrote:
> >If we want to do what I called option a, with user space repeat, then
> >we need a CTLV command to start the flow, not sysfs.
> >
> >I have been thinking sysfs should only create the attestation end
> >point and not do any RMM operations
> 
> Okay, sysfs connect can just associate the TSM and create the
> attestation instance. Starting/restarting the protocol would be driven
> through CTLV, Is SPDM_GET op the one you have in mind, or something
> additional done before it?

I haven't got so far as to think about good names. Will work on it

> >> SPDM_GET (attestation provider):
> >>   Return the retained discovery information and connection state.
> >>   There is no corresponding RMI discovery command.
> >
> >> EVIDENCE_GET(CERT_CHAIN, blob-instance=N):
> >>   Return the retained DER certificate chain for slot N.
> >
> >I think these two are my #2
> > 
> >> SPDM_AUTHENTICATE(device-generation, slot):
> >>   Validate the generation and selected slot.
> >>   RMI_PDEV_CREATE(id_index=slot)
> >
> >Maybe PDEV_CREATE is in my #1?
> 
> For current RMM, PDEV_CREATE fixes the certificate slot through
> id_index. For option (a), I would therefore leave it in #3:
> START is a no-op; FINISH(slot) creates the PDEV and runs to
> PDEV_READY.

Really? Yuk, I think that is a mistake, the slot should have been
on RMI_PDEV_SET_PUBKEY.

But OK, yeah I think it works OK at step #3. I was thinking that the
PDEV_CREATE should happen at sysfs time as part of creating the
attestation device. Maybe in future.

There is also a complication that we cannot destroy the PDEV while a
VDEV/VIOMMU exists so the RMM driver will have to handle this
with some refcounting. EBUSY on #3 I guess.

> >>   Prepare the root-port PDEV to READY and configure PCI IDE resources.
> >>   RMI_PDEV_STREAM_CONNECT
> >>   RMI_PDEV_COMMUNICATE on both PDEVs, honoring STREAM_WAIT
> >>   RMI_PDEV_STREAM_COMPLETE
> >>   Enable the endpoint IDE stream.
> >>   Only then publish authenticated state and the new device-generation.
> >
> >Oh is IDE under the control of the OS for RMM? I hadn't read that far
> >ahead. Then it should be done as part of the "ACCEPT" step #5
> 
> Yes, the host drives IDE setup through the RMI stream operations;
> RMM handles key management. We can move that setup to host
> EVIDENCE_ACCEPT, after appraising the session identity.

Perfect

Jason
