Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.66
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794162825;
	b=eex0zOeKsGkXRGGQ5nKcT8E/SALIVHJ8h2wTIZ21upMUwGkTTS0DUuwyK96+vo5q8f7o
	 Qs3tFr8bT/Tj1xJJfqJ+8c5UrtGLByKFEjCRFttvurZnjy8iK4dQAPe4keuIDnb010UpS
	 0WD3wmVywgJR57sC6dHzPyT/fu8/BTKA+EiBrde3akuBIB6uPStUH/n3W+zXroo+rjFAy
	 X3WpI+TBoApPWmKGUumexXiCDklXIrrb0Z9LUIkWcSBu3PA1JgA6zTqvQK785kqIO4Yxj
	 lpK1QNHy6oGstBPPYYat6hDh7mHc+dj0CcoTKcEjm26lLqSJSEzxntsXOIykeGEFOeA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794162825;
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
	bh=ldrs/wTHNNll0ymoCibfE3VgNDIrrEF3kCHDwivznuA=;
	b=C16Gvt+/qFcnPn3eQL9SF6Uc3vMbv2TaGYY/xM2qALNhEm+mWk0rpP7XyN3ZRYMBQar0
	 +Kg1TNJ1U6E3HflxXeORTJR3tRcXPZC423hyluPMOi+tihV1kHfRrcdmeYJc2WxAdLSI4
	 uEbS/u9AS0vndf1ELaoCRSx1rN6eZXTe32AZuN/M3GxoUFEUsKW0XkO6Uj82zqeCpqM4W
	 CEDe/g5d0oSuM28VuehtAzCq+gOkSjeZ32CUqk86iLsgSAB/l7DovhaTWWNekdlEk4gdQ
	 OuavIxv2NycsrYkoQueC1wUCKmi9EEGnp3I7sGHhhbh+zDsAmlvROxRYLw4B960TFyA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dutX4LVF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.43.66
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012066.outbound.protection.outlook.com [52.101.43.66])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD5F606A31C;
	Sun,  8 Nov 2026 18:33:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3DD5F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=dutX4LVF
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TlL9CVCLrbK8t/FEXeD4eXNOyEbbL4VYss+8KtWjSRsNYghUiKZQwzO43cVp52EEwa9wEw58ClzMfUTEXD8uvyxVo2DauSs1ETT70sJyH+QnKAteJXCH1jd+6YDtiC4bPfv3dtdIHA6m7xBd2B9J2HGahEwh10lE1Hhg62s/Uzc2p/4LztFIjK04YfeFtH06LGxDvJf22wu8su3d/ZWNBW+bfUIxytX5TVq4mhue7N0C5pHvoXftEEA7dQsfP8dpTn4m2eLefh71VsfHgfvfCDXW69XvHuh2h+4Z5pCDzprPwMZ2OXUoS3nIyJi7CPfCvzQ9XpZSJJ1q4VA18p6ckg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ldrs/wTHNNll0ymoCibfE3VgNDIrrEF3kCHDwivznuA=;
 b=aUeprLvPykHGNpGCUZpvYY8DUeTlXVlfrCN0nQ4TTyjG4ugg3o2n9JSQoawn82+c5FfBwot3x4V0yHvS0dFYrsSQBMs70Ri4rBt4iIm33zYQy7l3g47V62AzDfsCBMrlKd7m2DAyE3TkuDMgvwH5EcGFkvQNJqgGSpK3F2dMazCx0FU9Tk6NCeACbObvDlWaTJl3rb5hhhnMvcn/uolePkrFxZPdJCScu2S4gSvlgx9M4C+vy49vg3+E9qQNWpPIbFzcqRKDs6WigF55pEtSSFRFWqDrscIquuNqodVBBede72eFUl77h+DI6/Fo1zU6yLE0rPULzoklRBC4mFjJLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ldrs/wTHNNll0ymoCibfE3VgNDIrrEF3kCHDwivznuA=;
 b=dutX4LVFtkjBoJiqwCzKxwC+ZKcH9aKlM44xPoBhYwh5MldjxNwoAb/Hfn3CoqYis7UO5yJvCCdKjyzgk/fIbvA+A70+1ouuTqR7LuwQauq4AxxKmodmSO3I6HHP5FCXuH8jGOB8JPO04aVbjzVBfB+x7z0bcFZKHE/6NLL1bQdVrTQTJ+0q/5qIVZhKiw63yNR28igS9+sfBLXqWyjGPQ43/5pOIvhTf4VVBPV0YCB2W5M6ZUnIY9bjmIJvL+J1Ocl4ApSOoR9fLOXGF2oUFoP9OFuAqNqOz3IgjAQM00sjfmKXN+LVLVrf6buOQttRGEBctJpps5j3cdJAfKcT5Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM6PR12MB4108.namprd12.prod.outlook.com
 (2603:10b6:5:220::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Sun, 8 Nov
 2026 18:33:38 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0592.010; Sun, 8 Nov 2026
 18:33:38 +0000
Date: Sun, 8 Nov 2026 14:33:37 -0400
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
Message-ID: <20261108183337.GL770409@nvidia.com>
References: <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com>
 <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <53bc57bf-1ee1-407a-b48b-bc6b2deee12a@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53bc57bf-1ee1-407a-b48b-bc6b2deee12a@intel.com>
X-ClientProxiedBy: BN9PR03CA0491.namprd03.prod.outlook.com
 (2603:10b6:408:130::16) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DM6PR12MB4108:EE_
X-MS-Office365-Filtering-Correlation-Id: 665b22ea-21a7-44b7-fb75-08df3dc6ce66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|11063799006|5023799004|4143699003|56012099006|261021123027099003|261021121427099003|261021135927099003|261022115727099003|261022075727099003|261022105027099003|261009223027099003|261026140227099003|261028144727099003|261026121527099003|261102123227099003|10067099003|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	ZLdUwjYhC4Tnz8r8FSqAqAmRQP2bWhHdUfqohu3UffcKiC4G3YQpvmpG1Oe3MfchDElCFNa8hAjGiqVi/8beVgYGJi1Og/bPMyGHelz8GHr+ieRDchOD0tbE3/j7fl5+3Or4xpWOaCfpsc+pUn0CwwoDELdmCwFkH9JUqk2oxNZOqVy2UzZEcr7BctAzcrVbowC+ONuA/bT8ymp9H3nd4KfAc2ZHi5ZzIMzupjdYvEpVxH1Fs1wmPRafb64RSixPZkpSHX5G3osRhLSZytiHXkrEreClv3cj2A2s52utNCA+6LtrfOjauKJjqDLJNrViAQ648aUDT+kIwJ4j8sUuK98IKVdFUD+Fr3c/6PFqVSkrt85iyFgqUJCpLWRMaANmitWGrQgGJQ2QSoPF1p0y8WPJVTJc9JSvZOinkG/ItxGUlPiNAHAg8WdBcribjiQmJ4LnKTlNu9P9Qev2aiXlinpp/fve+370lJOmooMeeL5ic8S2dY7fO0o0CnXp5QMCNoRJknMHFvZdeOQVinJGvq/7Lve7shGDxzIKJiyFvme74nNqWnxhxWHrhJG4Q/eQWJYoBI3cQx85wyOCozPPSXZSm8BitZ3gr+YqnZyw8ZslE3S6amgbes07I28Axfx9cvVB+0TgWTNP2EOMwjRqrFyuPp0CFAXp7M3eMRjEJTs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(11063799006)(5023799004)(4143699003)(56012099006)(261021123027099003)(261021121427099003)(261021135927099003)(261022115727099003)(261022075727099003)(261022105027099003)(261009223027099003)(261026140227099003)(261028144727099003)(261026121527099003)(261102123227099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kDZuD77fpZIReU2ykut/7jUZoF1Y9DfGF1Jb9ofgdw3SvyOi8zRDHipuq43t?=
 =?us-ascii?Q?KyEt3gI1T+rEUcr8PcOpJRQ2VkFeGODSwiM81+y95Mt4+BY80DKXY97U4uBe?=
 =?us-ascii?Q?Y4uPiCFBEIxLVh7MV8idpMkGZ/LBLV/iiiYSoW4AsMEwci4WXlNGgPHrPT97?=
 =?us-ascii?Q?bHuPLdg8MH+dm+bfRoPocI1GCKodLqesHUG/13cJRdpcT74l8Cqdh/4OPTuG?=
 =?us-ascii?Q?28L+LWdgsxcQF8B9Vi4MuV4aVp76ANCqBivuuRPuAUQzy6CiZMFXbO1urAe6?=
 =?us-ascii?Q?inGygTpRzciCwSUWZtB8EP9MppCAsKA3CK7J+x7iazGmXD5kI7flGDqKsmvb?=
 =?us-ascii?Q?uOpnkEBUzqeKjgIPKOqsjwR6RyXswf27ppkTkV9ACVlLbx3YPvwQzf8IDTi7?=
 =?us-ascii?Q?TX8GZ9tVxeshiOKTJchp4Msqx9hvzcLY8IVTvCxYkbhLS50h4FdTsJQlETrd?=
 =?us-ascii?Q?UAEO6CiVL6QbDP17hL6J4JZslC6rBGQNDfORq4xEilA3aQwinSz7N5UgJkPN?=
 =?us-ascii?Q?vO0cR3CbRfQsGoXQpcA1SoA3DUfMwYLr0oOu52VrQj5+9GjNgvOcqIV7UnvI?=
 =?us-ascii?Q?Kdu2BHkC3/+oIohoHjr8iTYCyKylXwfh7dFqaQ5NUh417mQa/nlvCxYd/2Ab?=
 =?us-ascii?Q?lHwx9odCnoNDI9w8OEWPT9uL5eqEh6eNt4E9tc8bkxvYnl7m5+AHnQ9RQIAo?=
 =?us-ascii?Q?TDeRJQJqHIRe9eRxGqlF/Foi2tiUpMs3pkJE98dhBU78/Lzh9PN+4riZed75?=
 =?us-ascii?Q?FxikBjhrLvjJuCpQEnDEHuK7kbDvzmRtxSVK/56TqjsG/ijsWUQPTKUbx9hp?=
 =?us-ascii?Q?H8+ynx2OiBT9TRPwzulwNaoH1NSKb3lIofO9IsOya9raEDJl1q4cTr7Yhvnt?=
 =?us-ascii?Q?xDSYPT6iD5ocx7YLltqiR3kfCqVKnYK/2GVIV7zMFZEvdtJjhEhk5KhXJZFU?=
 =?us-ascii?Q?W7RkivZjQoEcRpERV8Aih4sGOSrnXxH86kWE9UlAF5WmLJgQCL0SZ1r4Bwl7?=
 =?us-ascii?Q?QrB3IhMCEhcNLS6uYR/ofTM2iqUJS+CZ/nxBcJvWxywqrKL1p79EUkiU+PN3?=
 =?us-ascii?Q?F0LN/vB5wRItS4MhlG5j9RPfdUsGpWaFJqJdwgC8gWJ7NbTpp72Ar17HSl6d?=
 =?us-ascii?Q?erw/w/qiAdJaSVmDg2U476hem2h8PG0ZcNl2ObPRMjiHe8UyQf26Vg5bZPtb?=
 =?us-ascii?Q?rG4c9NCPGdJFJn7lU4tGIuthdwAARye1Fwr8JpexlqHdk6BUHDklImw9DTLt?=
 =?us-ascii?Q?qQwFdeVcxFQ7HY5ZOqaLhowGgelPZxQqEuKZEBkV9lfLl3+UAkubOLCPkcG5?=
 =?us-ascii?Q?EWbFcf2gqvmjuKXkIn+UGNqobi5KlQyVnrcpiKzloHGc5jkNa6eD4tQVCO6C?=
 =?us-ascii?Q?BZwpOCGIhAgeF6NvVJoQxJYWAgjF0cW2vvTMWYEvwKTcwD98RwO0SZsFltVE?=
 =?us-ascii?Q?j8PmkS0EWhccObBXjbyNhuJLUGWZlNH56kgZP1SllrDkGDBAq/fK4EgnawQ4?=
 =?us-ascii?Q?vPYt6kFOwTXF8dKXfLT31a9nvbqmlKeFai3I2fgxPIWgIIMhztuJzUuzhg40?=
 =?us-ascii?Q?qBGS9aYAw/VuAm12k3AAEjUw7iE9gXksEzG7+rkQ2XZCXJszYb2luBYXopmH?=
 =?us-ascii?Q?Rc6Mfazr3K+BBteivviyM34LR1TLpmjhQVnRC6Hk4Q6KwBPTv+sgqqFz9Oij?=
 =?us-ascii?Q?/GIYpskhK8Okl7VXPMJuUjumMuRcHApyGYObL7WdFAQrJVrb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 665b22ea-21a7-44b7-fb75-08df3dc6ce66
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2026 18:33:38.7366
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yUJG3ZzvBA0ijxna9F1vxP/IaS7hCZObGZrwz4Gr5XCmhWrrqdwLVTlbUX1Pqeib
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4108

On Fri, Nov 06, 2026 at 03:39:56PM -0700, Dave Jiang wrote:

> I think that works for TDX. tdx-host already relays every DOE
> message for the TDX Module, so it can hand them to core SPDM
> code. 

Everyone does this right? TDX does, I know ARM does, and AI tells me
AMD does too. So this is universal.

> Only part of the flow is clear text though. With the current
> module I see the VCA, GET_CERTIFICATE for slot 0, and
> KEY_EXCHANGE/KEY_EXCHANGE_RSP in the clear. There's no
> GET_DIGESTS. FINISH, GET_MEASUREMENTS, the reads of slots 1-7 and
> the TDISP messages are all inside the session, so the kernel can't
> decode them.

Yes, but in 1.3 there would be a get digests too.

> So the kernel would get the VCA, slot 0's chain and the KEY_EXCHANGE
> transcript from snooping, and still take MEASUREMENTS from the TDX
> Module's device info. Would that be ok with you?

Yeah, this is what I was thinking about. I think this should be
completly universal and uniform across every implementation.
 
> I tried disturbing the session from the host with a test hack in
> tdx-host, right before KEY_EXCHANGE. A bare GET_VERSION makes the
> device reject KEY_EXCHANGE. Replaying the VCA with one field changed
> gets a KEY_EXCHANGE_RSP back, but the TDX module rejects it. So
> KEY_EXCHANGE does blow up when the host interferes, as you said in
> the other reply.

Yes, this is a critical security feature.

The host could inject GET_CERTIFICATES on its own right before
KEY_EXCHANGE, and I'm wondering if we end up with this scheme if the
1.3 mode should simply have the host issue GET_CERTIFICATES and the
TSM side just does GET_DIGESTS.
 
> Seems reasonable. Every TSM gets the same uAPI, and on TDX the host
> already has every message in hand so the driver side should be
> small. It also lets the kernel check the KEY_EXCHANGE_RSP signature
> itself instead of taking TSM's word for it.

Yeah, not sure that has security value, but it is a nice debugging
aide for sure.

> > If you *really* want to do certificate refresh it has to be a
> > dedicated operation, it has to be supported by the TSM, and it has to
> > get back another SIGNED GET_DIGESTS. All that would ideally have to be
> > dumped into the transcript again.
> > 
> > I feel it is alot of work and not valuable.
> 
> On TDX the re-read of the chains comes with the measurement
> refresh. The kernel doesn't ask for it separately. For option (A) I
> think the kernel can drop the re-read chains and pass up only the
> new MEASUREMENTS. It already has the copy KEY_EXCHANGE signed.

I don't know why you guys do this, I would take it out, IMHO. Just
wastes time. Yes, kernel should forward the chain it collected with
KEY_EXCHANGE, it isn't allowed to change and there is no need to
recollect it.

> > I think any device that can loose its private key while an SPDM
> > session is open (ie with live update or something) is fundamentally
> > broken. If it wants to do this it has to break the SPDM.
> 
> On the host side, should we drop the fresh-nonce collection before
> ACCEPT then, or keep it as audit only? I'd rather not carry a uAPI
> for it if nobody needs it. The guest's lock keeps its own
> fresh-nonce recollection, as you asked for earlier.

What does this mean?

Every single call to GET_MEASUREMENTS should come with a user provide
nonce.

You need to provide two flows
1) /dev/attestation/xx on the host does a GET_MEASUREMENTS for the
   host's use, with out *any* disruption to *any* guest
2) iommufd command 'get attestation fd for vdev' ends up implementing
   the hypevisor side of guest/host channel and does GET_MEASUREMENTS
   with whatever anti-tamerping scheme TDX has.

Both of these need to accept a nonce.

No GET_MEASUREMENTS should be issued, and certainly not from accept,
until userspace specifically asks for it with a user provided nonce.

> >> (3) TDH.SPDM.CREATE runs first. The kernel sets CERTIFICATE_SLOT_MASK to
> >>     0x01, so the TSM reads only slot 0's chain. It could also read slots
> >>     1-7 inside the session [GUIDE B.1.1, Table B-1], but no signature
> >>     would cover them: KEY_EXCHANGE hashes only the chain of the slot it
> >>     names [SPDM 10.18.1]. So (a) doesn't report them.
> > 
> > ? this is confusing. KEY_EXCHANGE slot=0 includes the hash of the
> > certificate chain in slot 0. If the TSM doesn't even read that slot
> > during the premable it is impossible to validate the KEY_EXCHANGE.
> > 
> > What prupose is there for this configurable "the kernel sets
> > CERTIFICATE_SLOT_MASK to 0x01" ? If the kernel sets for slot 1 then
> > KEY_EXCHANGE must fail?
> 
> No, it doesn't fail, and the note was confusing. The mask doesn't
> control slot selection. It only picks which of slots 1-7 the module
> also returns. Slot 0's chain is always read and returned. The module
> reads it in the clear before KEY_EXCHANGE, even with bit 0 clear.
> Slots 1-7 are read inside the session after KEY_EXCHANGE. Setting
> 0x01 just skips reading chains nothing signs.

OK.. Weird, not sure I see that as useful?

> > Yes, but if we do #1 above I would keep it anyhow and optionally give
> > it to the verifier. I agree it is fairly pointless, but it is really
> > cheap to do if you have #1 and simply capturing the *entire* signed
> > transcript is forward looking from an ABI design perspective.
> 
> Agreed. With snooping the kernel has them anyway. I'll change (5) to
> keep them and hand them to the verifier.

So what I'm thinking is some kind of little library with a driver
interface like the blow. It would be used instead of the driver just
calling pci_doe() directly and does all the capturing magically and
transparently.

Basically the only thing in the driver will be the communicate loop,
and the little bit ARM needs to get the PUBKEY out.

I've got some AI running through to make a sketch of this to see if it
is a terrible idea.

struct att_spdm_connection;	/* opaque */

/*
 * Called by the driver (not the TSM core) before the first GET_VERSION is
 * issued. @doe_mb is used, not owned; it must outlive the connection.
 * Returns ERR_PTR() on failure.
 */
struct att_spdm_connection *
att_spdm_connection_create(struct pci_doe_mb *doe_mb);

/*
 * Release all capture storage. Must not race with att_spdm_doe_exchange().
 * Sends nothing to the device. Evidence references already taken stay valid.
 */
void att_spdm_connection_destroy(struct att_spdm_connection *conn);

/*
 * Forward one firmware-generated request over DOE and capture it.
 *
 * @doe_type: PCI_DOE_FEATURE_CMA or PCI_DOE_FEATURE_SSESSION, as chosen by
 *            firmware. Any other value is -EINVAL.
 * @req:      may point into shared or firmware-owned memory. It is read
 *            exactly once, into private storage; nothing re-reads it.
 *
 * Returns 0 when a response is available through att_spdm_response_len() and
 * att_spdm_copy_response(). An SPDM ERROR reply (Busy, ResponseNotReady,
 * LargeResponse, InvalidRequest, ...) still returns 0: it is a response for
 * firmware to handle.
 *
 * Returns a negative errno when the exchange failed or was refused before
 * reaching DOE. The error is latched: every later call returns the same
 * value, and the caller must destroy the connection.
 *   -ECONNRESET  GET_VERSION restart, or RequestResynch
 *   -EPROTO      malformed or illegal message for the current state,
 *                including any plaintext request after KEY_EXCHANGE_RSP
 *   -EOPNOTSUPP  PSK or mutual-authentication flow
 *   -E2BIG       collection budget exhausted
 *   -ENOMEM      allocation failure
 *   other        DOE transport failure
 *
 * Sleeps. Takes no lock: the TSM core issues SPDM operations to the driver
 * one at a time, so calls on a connection are never concurrent.
 */
int att_spdm_doe_exchange(struct att_spdm_connection *conn, u8 doe_type,
			  const void *req, size_t req_len);

/*
 * Size in bytes of the latest raw DOE response, including DOE dword padding
 * and any ERROR or chunk envelope. Valid until the next exchange or until
 * the connection is destroyed. Returns 0 if no response is available.
 */
size_t att_spdm_response_len(struct att_spdm_connection *conn);

/*
 * Copy the latest raw response into @dst. Writes @dst only; never reads it.
 * Returns the number of bytes copied, -ENOSPC without copying anything if
 * @dst_len is too small, or -ENODATA if no response is available. Never
 * truncates. Can be called repeatedly; it does not consume the response.
 * An undersized buffer is not latched: how to react is the driver's
 * decision.
 */
ssize_t att_spdm_copy_response(struct att_spdm_connection *conn,
			       void *dst, size_t dst_len);

/*
 * The driver calls this once firmware has reported that the SPDM session is
 * established and valid, for example when the firmware connect command
 * completes successfully. It is the only point where any future kernel-side
 * validation of the captured evidence may run, and the only point where such
 * validation may fail.
 *
 * Requires ATT_SPDM_CAPTURED. Calling it in any other state returns -EINVAL
 * and latches the error. On success the status moves to
 * ATT_SPDM_ESTABLISHED; on failure the error is latched.
 *
 * Evidence is only made available to attestation consumers after this
 * call succeeds.
 */
int att_spdm_session_established(struct att_spdm_connection *conn);

Jason
