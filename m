Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794962159;
	b=v2Q+mSd7yFdVWzaLpp8OWYs3JKcOqEfX8bVjLOHjisYs5KjGEzDTOw/0X8ogId4sKQkc
	 I03bBjl+kDmPaO7qvISkj70YGBtAEGkSzz6HwYnEcM+4FQ5eRZC6wgrzHu7qEWIBiQUIx
	 B8JXOUnIRqpb7QfJBP3bh0UaNV10SRjm0e7poW6p56lfN5MRe5ClPnjNQrC2wAjoaMgCP
	 +XxRD9c2LdXHCYAfqO8PMWFxrpmnxzbNMIva/bbbspyQIm9ZY/vI74oTnGv2fE/3iuszF
	 O5yodLP1XxNX/zS8c7Z2QKmJPTgi7M8cOEw9oJ5kuk3cbDsMdM2DvLEsWZEV6uyolNQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794962159;
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
	bh=/6dWA1SUH/JSjr/x9MIHpThHrky++ks1K37V7Ab/Dag=;
	b=qzBz8UA5kuzjuYHOw+ynuSQhBdjzHZ5jT9/pOMNoun41idRQs8eYmvFlL0jMCq/umoLV
	 V4vY6bxgVNRHXnjM8/JlE2L1V2hvmDB4duYtq5kIP8UYWCowGGFfkTkYTKl7NmKkxSMrL
	 LRk/n8fY7AN89zxSFIcLLwpk3wFbIYM4QmIASEjwUQqGdpNZyL5Yy0JIqnfpu8gEelt2/
	 bsQgyP+SSpA3QDSC0hJ5DhUwTHHNhbL9VDqoD7NFCMAAvRPC2Ud31vCwsephtXtd+gERv
	 UD88B8HqOCcUsLKjpyVohp8oRMFwytuLIN4CiHk62VR/FHxEBCt2GdVV4Cq3bcZhY7w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=M4iDa2oO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.62.17
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011017.outbound.protection.outlook.com [52.101.62.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DD9606A31C;
	Wed, 18 Nov 2026 00:35:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45DD9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=M4iDa2oO
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IFDJqwysAx97ZW21M0Vbj8+lkq4efEdV0Q4Z3hkBJ0mYOlgIuF/qyZ546R+NMNIyw/vS4Ch+nI3sZnUovAcHi68wFX0AWsxSGsgHzpXdwVihiU/gfYY63AutJjVRD4T5+cirYnp/Yqca6TWx5JgOJe8tGmvNi1S9CQIYX8BuJdR2A1qx0V7OFcpk8TztRQ0hwM2pZYPLg/AX8REed8jYkWlFKCMMD7tpAzexxpLobCkEoEoblTYqLEpRiovk4cbqb5qL7UK308IgsULCGr648oxEUtiF1KaPFq1TGnHhsoxWNdBm6zFR3bAD2lRJBzwRAXsKT6Lvhyc2ft1TO0jEdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/6dWA1SUH/JSjr/x9MIHpThHrky++ks1K37V7Ab/Dag=;
 b=X0MRFYcYhvtr9Lt6rjhrjn00zgkvARc8nQgdDxRldVpCUY0PtSnSZGS0bC1BhLmnSCCiTE6tElQrrtJjUR/WQByiZWw+RFMwxcNd3R38lDW32Up7O015svw1kq21R4Jz5HophXSvfaUTQncNTIlvGJJT53gLRKulh5t84CMuJETrLvboX2KTwW/0Fz+36bDc9KW0qgZg78Wt6lY/GbbEkD9LKiKE6vdPNQtk9CnpCCd8NefZINTZnCOE3l7bh2y9a/0IwzDHGH+IrqUZgAXOrToUVfLO2LODjjE46Et5Pg4YQT8YwlAFu9kH7u2H7e/vYl7GPyin5YdFFw/w/1ot3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6dWA1SUH/JSjr/x9MIHpThHrky++ks1K37V7Ab/Dag=;
 b=M4iDa2oOOiXv1uWGoqJiil5KXYMmn+p5TrXOC7NKi6cCIsU/BB987rXeI26C4iZ6s1zrHiXdjraQgHwzmt2PrOYWHxZnwPqF7f8bB81p5BW4ZyIoJs4ubjhuimr1A4+Drt/QD/jtZZ6yAAtBd7YNLGtqA7dLLNGR3d0ST6Ypin/+i6cHsQ+ZokoLCaxDxJp7fLZ2iXUbJJ5zURuuKKG4aSAwaZ3FBLuy405N1STDMSpO9pNJpKu6GltZ5o3ofJJ6eXlAFsKo0uU+4ZBBNUQSrDq0dVvK37mDkvxVcE4qyvC6XYs6Wbe70KkcKduJe2agFI7KKX9ZzbWIjo4wDbCXdg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by IA1PR12MB6066.namprd12.prod.outlook.com
 (2603:10b6:208:3ee::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 00:33:47 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Wed, 18 Nov 2026
 00:33:47 +0000
Date: Tue, 17 Nov 2026 20:33:46 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alistair Francis <alistair23@gmail.com>
Cc: Dave Jiang <dave.jiang@intel.com>,
	"Reshetova, Elena" <elena.reshetova@intel.com>,
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
Message-ID: <20261118003346.GK2245175@nvidia.com>
References: <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <53bc57bf-1ee1-407a-b48b-bc6b2deee12a@intel.com>
 <20261108183337.GL770409@nvidia.com>
 <2b89b830-f1e4-4304-93ee-40287a4b5b2d@intel.com>
 <20261109185315.GS770409@nvidia.com>
 <4765e562-8c58-4e0f-89f4-eec23b5ef102@gmail.com>
 <20261110150747.GF738765@nvidia.com>
 <CAKmqyKPQXnMiiD9z3Ww-YoOTOdByeCeNBLMXVYENDJ3+Qfab-g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKmqyKPQXnMiiD9z3Ww-YoOTOdByeCeNBLMXVYENDJ3+Qfab-g@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0194.namprd13.prod.outlook.com
 (2603:10b6:208:2be::19) To CHBPR12MB731189.namprd12.prod.outlook.com
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
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|IA1PR12MB6066:EE_
X-MS-Office365-Filtering-Correlation-Id: b9cce2bf-a0f0-4d70-f69b-08df450b9c1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|22082099003|18002099003|6133799003|11063799006|56012099006|4143699003|261026121527099003|10067099003|261028144727099003|261026140227099003|261022075727099003|261021121427099003|261022105027099003|261102123227099003;
X-Microsoft-Antispam-Message-Info:
	HGdEQE2gBRbHvvPtkG2grMpCv2olOUufiS+Wt62WWBzOqW6rX8UaTFKzefw2394v247HK/435t5EMEs7OZLY8sUvFW2qnDBTFODfGquRirOg8OGEvYOCz4AbrQOkQgHJrJFSe6Z2Of7H0BAX6eASZH5W9y33hSNgYYB7bmfnHCkm1AjMx8XrzJxGOgiQPemrNyDWbarekdDVlFKhWCUYeBk0AjIlbV7nyu5cRdz8jNCla24wLTEJ1rZr1tPg44akJhgxO0++f72dz/qtRjwHUAIwEA3PPg+zuzlJJWJiV9TeuC9QQhUfcsw5C1ff5r/PdgDTmVWwlBrUSmsPA72L5NjVIm/BqIWQui5whWoPbOJtHc3wKdjVKvyfYj1V6DQVVAwg5gkVGL5tXU2Oj5TROnK2/iIIFFDkUZxFLSfkKIE7oPxDMEnCET07DCZljNao5Cn53wMFvhoa5ud+e2MoIDZKMdqx5qB04i6WphSRwrHeTEtHCXAW2FuWe7XgCP9Yf5xNTZ4G+SgiC4O+hcU5E4cvDtydL40dRAGt0ACuCKc8NCefzrDd8FtS1GlQe2k5j7WfWdM3a10vzORe2VEEGxOUCH/lcZME2qbxrQBvtydJZrxjuXb91TMhEjyOImPIaymHsGRYb5yrtalqiR0ABWIcWSXiTl4sNGgFPvvUxqE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(22082099003)(18002099003)(6133799003)(11063799006)(56012099006)(4143699003)(261026121527099003)(10067099003)(261028144727099003)(261026140227099003)(261022075727099003)(261021121427099003)(261022105027099003)(261102123227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tZkVe4+eXZ8OaOVRX1xPjJhs8oCLxbWOzsPUTow/B1YWASal1NWbdx7TxE5O?=
 =?us-ascii?Q?SlFXAXH76i3hTLHhC9bN95X6r9Bktsdze1JhKjCR3AIOr/4kvOQSDCURrXsd?=
 =?us-ascii?Q?PNAMmesnYwyQaRJF1VWa2lvMNQnGXZKhugSdGvQc6GtRIM5OgFXbS66HnLPh?=
 =?us-ascii?Q?3yofDip6uOHaTcLc6L0hXBTYIVIK4lvLhMIC46K4g6IFLudxz1FEMbdvraSh?=
 =?us-ascii?Q?ilukQBKPDT+S1SqdrSVnWs6YtX5Qa95MhiYgBAMAWPHpNNw9Etk7mj8I7l+L?=
 =?us-ascii?Q?uuA3bHSUIX1BJDrwORpGri5oDLrhLXQLSpwe9c53vB2+YEYH73IoX1WyMkDt?=
 =?us-ascii?Q?Saz6GgfTqSCKl8AXY2Jd8x/aO/wsugs/m7rseBTzuP+ZKKuQ31tnrthrC3NN?=
 =?us-ascii?Q?kRfOzB7RAv3Ht0kIvEJBue5Kwz5Y5sNPrjTXv8W4w2SpZIW9BXTyHHwt6su9?=
 =?us-ascii?Q?6jB8OO/hggas5rm2UvEdX1hVuTckoZTLKYnFKum7IwBOBXjC3bJ2/Se3Pclt?=
 =?us-ascii?Q?n6Od0tOzsfBOteK/bGgGiEzM+YrD2X3u9sPmNNUUranon4QJEE4e4ljEdY6W?=
 =?us-ascii?Q?XUkJtALNxwDTdNXni+tDkcENfJTfJmIWMj6LiN2GNxpIsua3KY69zz9hEIGy?=
 =?us-ascii?Q?GyhDprqRRrkEWOVJ0Iq7ZHzc3ZbCZYt6SlsYSDKbIr7T3er9+HPoj81tqaVe?=
 =?us-ascii?Q?gtvwQ4awvCQdjVh7+vEbzAmqiD84giHoVKvUpkq7yZlhySB+ajPGHBu2XTG6?=
 =?us-ascii?Q?ltqFlj23rdKsYgZWoyWHcvG49J3t4Q5u0XN76ec4dHT+aNoTfzPnkLjfD1+Q?=
 =?us-ascii?Q?2v34iALfjqxJnUApk4Ex98GgJiMp/bopgAuScHII5EmGXumcWxParaJrQnXl?=
 =?us-ascii?Q?3/PUtF3BiyiM3ZV0IAZXf0zHxyTkdt0bY9V9drPnfIjrYs0wyifQG/zrZLek?=
 =?us-ascii?Q?ucD00qzMXGJB2Jp3H1qXwpK58E4Qke1oFDTe+gfflU/brulNT0fVYGIzgfMS?=
 =?us-ascii?Q?elZGDiQvWtAUItQVBtTRlXJ5onDCUf+ce1VDUZ83uZL+J4Xfgninxq3KQ8dV?=
 =?us-ascii?Q?PAe8CW0QuEH5KEIjEclXqLOesT4jbDAG4UwqoRXNimVZlC/7byM05jisPDke?=
 =?us-ascii?Q?5Ie6TLZhg3N1otzJgdhTEvVFyDOEArd4fP8SEVywiLJCEPrv8wEJDOHI/VLi?=
 =?us-ascii?Q?pNOgmFOxGdR6+Uftj1U3+RjtgG01Po9+fJ8aLfTRpV2HjXBqki4uWpgqg1yG?=
 =?us-ascii?Q?ZGokoc8+4JuQApmfU6cULwY6hMo5TnimRqsoaLQRcvn4PwOoffj5cAh5ppnG?=
 =?us-ascii?Q?0PVQDucopHZflMLUKxkDDxDGfbraub8e7Bb6lBSf/CwWpYSAN/wpjwoTeUuu?=
 =?us-ascii?Q?eq2aLdme/vZo5Wd2DN43ZEnSSBmf7adUlA7u3b1rzq7sB6IY/a4nbv5pwdvR?=
 =?us-ascii?Q?flmtA/pmx5YAo9qjFWXzhpCvQA3Hn1Vphv1nsOdMstP6ACpsTVviVTqSKS/4?=
 =?us-ascii?Q?cwScnthGCTqM6Yv3L+aYb0ZzB+NPGNU+L9JkFNX1eq0adYtbN1wm5+YfeKvG?=
 =?us-ascii?Q?xOjJcZ/jsmpRfF+h7POnBisS2d2rhDxu2gL4rN3rjx8Mjlvl8v+6TDezvT4k?=
 =?us-ascii?Q?z554L/oNuo+RakCnsEskz00ZWncNHMiGZbtzPAgsuKe8r6WjmzT3+kfr9YLi?=
 =?us-ascii?Q?YVYq2qbtFTO9+mICyean6DqsmLoC10OEfj/Z7TKDDwAjjt4v?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9cce2bf-a0f0-4d70-f69b-08df450b9c1d
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 00:33:47.7712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G2V7TzW1eAY4LJfWgRcR+HAyw8lpQotuko3iRY9NqodmJ7ihOAyBnJdrQLqKrHEg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6066

On Wed, Nov 18, 2026 at 09:12:59AM +1000, Alistair Francis wrote:

> > Heh, well I don't know Rust so I'm useless. I also have no Rust
> > knowers to recruit to such a project right now.
> >
> > The best I can do is make a draft with AI reusing parts of your series
> > that shows exactly what I'm thinking and we can talk about how to go
> > from there.
> 
> I think I understand the big picture. The hard part is splitting it
> all out of the current approach, in a way that doesn't just make
> everything complex and messy or reduce the security of the CMA
> approach.

A lot depends on what the architectures decide to do when they
implement 1.3. If they do TSM directed capture like ARM then none of
this is needed.

Otherwise we probably need something..

Unfortunately I don't think we will know for a while.

Minimally we need to be able to split a concatenated VCA back to 6
messages to create a transcript style uAPI. That at least eliminates
all the chunking, framing, and error handling.

I've been mulling that might be the best place to start, maybe we can
replace that module with a rust version as part of your rust effort.

Jason
