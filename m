Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012052.outbound.protection.outlook.com [40.107.200.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB5127732;
	Tue,  7 Jul 2026 17:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783444942; cv=fail; b=PccexGbkdLubHdTaVZOKaJj+7EMTH86JqHMS69xfQTUsYDTcFxOcACK90HMy3GYrgJFXxqJoWkltsRJe3TDKG8pifV/c+jVrXJKOU1KHiSe0IHCOlarweCQfFSp/8/PnMB9df9OjWs0n+vHtnBWlNs6OrVED8ojZsrxdFVwy/hc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783444942; c=relaxed/simple;
	bh=Wh1AYrBE6QfAmIc+qTnrEwqkfDK6VSDW7MEPE6nOy6w=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=opV12RG6pivmLhCpTy/1wsroQelgIXyJftmngkfMQhxMkFECV+WKhQJDXTI16gBowmtrclQhEDiArxtfL73JburQguonDMi6ljpbpeu7Q/Oi9r8Oi4GOzoZV0WwY/dYg/upR13Yg7j0+nEHeBM6ibEA/xNx8J1u587Jqk8bnk5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lb+Z81XZ; arc=fail smtp.client-ip=40.107.200.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lb+Z81XZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aJH+NE9KrneanJc3vsK5Rir0mAZLt2mG661q1Vqzk+e1hQ/h7H1oYh8IqIfPYJK/sQG5qZ9gwrIBirIc7UCAqbGpsUaF/yaoN2da9u9SIO4ZZP+i5YuISK9a7aYQdDMjt+b5DeqgFdSOdpLtd/l3r8sVLynwffXK08v978KVyZ+tGIaZ5cxtcCNMOONKwYv7gT0HOWEK5CcD5wAzu8K3Uz//GZn5edNt91EPv6hpxFOAnXCbTSIt6g/9ajOkO94rCNRU0b4rYNDYlMYshl0nXr7R161D/0gFLVnf4bkgUCBU5lv2T1+Aiwb8YOXXjQYz3VFNTxfFYOSrp0yDZJTz1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zaBOiybOd7/mfx0hVWEzmqw9A+nKrTg0fdvXWqkeSGw=;
 b=mvfV6CviUGKym6djQO8DSiTjLYTjsYdvYj08oehYLyYHVCOV1Vx5JU2lbPJQZJlhewt5LI2uIO4lcC0XNxxb2BV70Sft2XZRtIZhPGhdLqLqGW/43/HJHMZ8Sx2TYcfnu+CA2y5TT8IX0niIGCm+oHj67HOjn+2RJYkmChorTiKFX375ZOK4DCTgA8C8tFmFZC8ddWHT2UNvS6IirY9zH0gtRxOxhnB2gRJ/OOzi/77ABO/Kau1T6SgkO1s7JyUh0YOauixJk2zX4mVdG3E3hiWiw+Kb4kXEwP8NR13LEs+KdeZsnVmRUQmtYEJFPLv027Kz2Xh28/xm3lhL5VSxfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zaBOiybOd7/mfx0hVWEzmqw9A+nKrTg0fdvXWqkeSGw=;
 b=lb+Z81XZ8St+KsIgSr9ahclUbSMWmejqurqnBuxh8wHpDRK1vUMf0/t3DwtcDcQMrEqOZC4ynA2NNfbwbKxZzv2OQKQsU0YIKKq8oOn9fmrD9ufegkcXy59Z+oKnZkALycJfTdNy2VqbjXHt4zJtxsjURMLR6ys7mxJKtf4VP63eiA+PPjjS79WvLt6V8MTFAAR9JDxON5DHKhorElY6uvjjc8eLHWSRtEGvSJM9w8YOiNRkwoY3yMbB67iqst79ck6Uq3cTqw/X/2tHi0zHnH/lTW33S65LGHlDSvJqrBAByenMw+YvKqVj/bQLEm+tnMgLQJ4tcycrTcSj44/7xQ==
Received: from SJ0PR03CA0065.namprd03.prod.outlook.com (2603:10b6:a03:331::10)
 by SA5PPF590085732.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8ca) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.13; Tue, 7 Jul
 2026 17:22:11 +0000
Received: from MWH0EPF000C618F.namprd02.prod.outlook.com
 (2603:10b6:a03:331:cafe::3c) by SJ0PR03CA0065.outlook.office365.com
 (2603:10b6:a03:331::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.202.9 via Frontend Transport; Tue, 7
 Jul 2026 17:22:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MWH0EPF000C618F.mail.protection.outlook.com (10.167.249.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.181.6 via Frontend Transport; Tue, 7 Jul 2026 17:22:10 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 7 Jul
 2026 10:21:43 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Tue, 7 Jul
 2026 10:21:43 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Tue, 7 Jul 2026 10:21:42 -0700
Date: Tue, 7 Jul 2026 10:21:40 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, <patches@lists.linux.dev>, "Pranjal
 Shrivastava" <praan@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
Message-ID: <ak01pH1Dkq7nzlIN@Asurada-Nvidia>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <2-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akx5IvI6bi/OPuPe@nvidia.com>
 <20260707161506.GA226829@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260707161506.GA226829@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C618F:EE_|SA5PPF590085732:EE_
X-MS-Office365-Filtering-Correlation-Id: 4246ef4e-91b4-4d77-214a-08dedc4c4751
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700016|23010399003|82310400026|11063799006|4143699003|22082099003|18002099003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	8aaoJFLRZZ7zdyzejg3LcnMd28DcIJQ4rpH6TKg4loiRnZ7MPU7OAwhDiNL8jANB1B8mDEnkFwdySTUWjQuTENyEDlfvRNi/JDszOIEVJ9ZP/QLcxnwFfUAI227WjkfiWy5sX/SVsMKFS0OHKOi9QT1edfW/BGjtDm6FB/e8Y64xncNnfQ1WZaAzl5CFPgjVE9SuOkXTYcSEMQwoDUtFNl7yiFV4eangrqLopGRsN359ZqJNQ1Roayqs/aKWkes9ikiqUrILRS+Tt1QwOxu+jHXc1DZYO/UOInUw8fI5hE7UwM/42lz19YOUQkvUz2cVpzIRD4F6wF6q92Wp/AbWAxZOXbD95zVSySyAGDyDTj76nHmPsyf8yd6An+J19wPJaNQpZbSo8DmzDEV0omnFEk62KD95eOmjVkfL2mnplJkafgK/ECm0mKCixZye+hM6E09hM5B1Z0lUjyNzjbzikCRN/mREdQFCxx0TcKQRet5mm7A0HjYV7GDNWuo59i29L9FWG/nKRh5eE0S0V2VcYgti51To5XSucammGpnOBFXOURAwJmsxrRRRCtII27tsurBN5o7peA73Yy2ZGKZ+ZEj4bLPapsIDn0mMUh4Hx0xkhl9FMpPdH0HNGN/5TmhOhOoVLfaf3AK4k7zpE2lm/L07bwsYMBE1urjZHQQ1/csOQHtgTH2Oc/C6qedRlAMmLjh33aAuMwdf0sV/5S37BA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700016)(23010399003)(82310400026)(11063799006)(4143699003)(22082099003)(18002099003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	cfORRe3SnuZUGGJZ2G/JesyzO5H34seO0M99aUwblu/ugTU8hjBpCSaCyu/u8IdP/Hb5edwIhTZp9LliUaYwdA2JeEfmgRO0rcLQkRRoqoExovseobFYGZkrEQaJpGZfn92PBzkgmjYfNhEGRONZcNoLwb0FQS5u2sZvlbOWx8ISkgAhE0Up/xKKn3lGX+28ELLy6uYKbzW0hJGRNWWZaznxCUsTyGjVnxBh/gqWSxNUiJBaeG/bVYxLi7MM3APyudkODvQ92QSwPvAaDdpi+ZiHTP79y9zej8JJFMFsHgUnqSXKtGvDDIqE6whCh8xyoLdrPmomWZzyzKcpblziYRqLggEZj2qVVsXCS4bWMCk5Vidwb0IyZKQ4bzrW0azTYpeCx9/Bq6r82rIrzbJ3+deYvoqlZaivbHTaT3ykqdhhE3M1xPUJvDi0rk9QJzh/
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 17:22:10.3819
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4246ef4e-91b4-4d77-214a-08dedc4c4751
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C618F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPF590085732

On Tue, Jul 07, 2026 at 01:15:06PM -0300, Jason Gunthorpe wrote:
> On Mon, Jul 06, 2026 at 08:57:22PM -0700, Nicolin Chen wrote:
> > > @@ -734,7 +734,6 @@ struct arm_smmu_inv {
> > >  	u8 nsize_opcode;
> > >  	u32 id; /* ASID or VMID or SID */
> > >  	union {
> > > -		size_t pgsize; /* ARM_SMMU_FEAT_RANGE_INV */
> > >  		u32 ssid; /* INV_TYPE_ATS */
> > >  	};
> > 
> > So, union has only "ssid" now. Should we unwrap it?
> 
> I thought we might need it with some of the other series?

I was wondering about that too, but couldn't find in those series
of mine (smmuv3_kdump, smmuv3_atc_timeout, smmuv3_share_domain).

Nicolin
