Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.12
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795669268;
	b=3EDyFeSdqiuPPb/QR6sMf7zk6u4YFNL9GJvQqZkaHq8bYH9zyr7fx8NkqhEiYEKhdA/A
	 YnqU1PUG+JG+2uPD/JUjmymOnmXhFkPxMOfmMMJrZBX/Ez/ZzN7ocf4hXUvZLDar2KDAi
	 EIfWEPvL8MYVZzq1boiYheY2mn2O8Af5DMXxUCsQjmt5h+6oyFQB4Rl9YjVwhMm1rxbBf
	 SZl09IwQVD5aL0GcHv7ozfPJTqXBcSB8QO6FB4h7KL5+Nwqbui3+tyTSOD/IFyXYrYoo2
	 bLkvbp8++m/oEfxoqXKLjnf8T4gLg+W4QcIoNTS3x/Ea5NDWozbppAvftknknc1XqPA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795669268;
	h=DMARC-Filter:DKIM-Signature:Received:Received:
	 X-MS-Exchange-Authentication-Results:Received-SPF:Received:Received:
	 Received:Received:Date:From:To:CC:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-NV-OnPremToCloud:X-EOPAttributedMessage:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-Id:
	 X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=GjHytJMXDzoCx6ad0K73SL0T69tcdzeEOAFHdrTOgtY=;
	b=LCie0BFi4RlVrmw1zhZ5Gs8Hmz9oP0NwzY53eZN4Bw6PqNA3w2IVBLWZv1m7v4f3lA99
	 2XJ1i0Qzb2EmswZ+UUAHWGcyik+m1T/SrRnjf10ghTFI4UT0I39Mv0ouTZQ/Xu6bnuw2W
	 Tsd6Is6OPAyVDj03hscFGdg9eRrObSV995KbmkTHtlz8KAbOUvEPh5zt/JNWC11F+B1WH
	 GWy3JuJ4LbIRwCFc3d047zsWLQ7jmtjDxAYyRl2VYMtE0H2hr5ZkTDqC7vugCyW7llI0a
	 tRvuFIs0FHuli9FVN6DCQsnflF8omPUmvc3ZFwUuRI09vifFU7p7FemoI3+DZkDOk2A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=OfYtZGKD;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.201.12
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013012.outbound.protection.outlook.com [40.93.201.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02B3606A31C;
	Thu, 26 Nov 2026 05:01:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B02B3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=OfYtZGKD
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V/eC3bgmYZ6f3FFPOczen59v/oRCSBDOZmFDzsQiT6AB8nmkBWZ8zW9/bJW5s8u2uOFzuIsbR5bsRQu1zYSusB7dedlTC4fajG2x0pWpvUkygCQW4CYPajxK511ao7jPwNM7BcLLBdTxn71XIzQ0Ct40qg1vOVhq5x8wmIPeaxr7WYtSGsOuWNzctZHTlxFgYq/CjqjuKQ1jxMmwzmCqyqdjfHIYKkR5s3Ml+7/roOj1Kn7yl8zdD9Kw5M0CpvVQup3LY6I37+Zwr4LGRUkZ3LYj+OdefVz+Ro/f86o7WUPACKS3BIl3DGK9g2se/QnXAeqD2sQ037LVNqXBtZySXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GjHytJMXDzoCx6ad0K73SL0T69tcdzeEOAFHdrTOgtY=;
 b=iVLwYRvZ7U7aH3k3anZjTwtEpngYM/KgFGZNzPUOMX7tzvOmjLlr67hqGLprwCvGqU9E3heKYEA9bX6/zs1B5OXOtzd8GO1JOFsv7/sgJhHfl4AaUU2u8TWp9aZFkJAY4T2bkQ+jtDq5/0OUZl/IUdkaRPXlNrQuA0SatMIM4huvfMEUSMPSzZQlJaD+qzh2s6t0/c7ZHoFYnxZLtpCh1QU+fCtFshnJ5Zp7fxDZPipBKcYGMEcx0InciuAaK6TXF/pimtky7frboRrV9dIE+1X7KOKup90SgoHDo0fNJqSPDMYnGkWCXX4P4jUgo5dTzPawrf/eMRaKUpM9L08mZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GjHytJMXDzoCx6ad0K73SL0T69tcdzeEOAFHdrTOgtY=;
 b=OfYtZGKD4KOjFlV8RkgyK9AeVYeVCrJiOAW01+WTqyOhHzJVymzGHX+8ktfNkJ2/i41nShm0OQj6pvdMU/6J45j8Rj/ut6gtQKgBae86sECUEJluEcJPdnkZubjlHgjpdq28CxvfuJIuAxuBug+1l/VsXT92WD1iGnSzKaw6YZXX9t4agU8NqDHzcq95wp13DPxiB/TIZkhhnatw9zir5GVnHu4Ld0HIkbFejcC0tS90VYsfqqqEYlOmldNTvnUazgugHQAoIRTq0zJ38zBJu9h/NiNvMLLMh5kIDWjVoko05hHk9EhA1GMHieIRG5tbRf9Ow80Jq2M7n6Vul2Ql6Q==
Received: from CH3P220CA0002.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:1e8::13)
 by IA0PR12MB7697.namprd12.prod.outlook.com (2603:10b6:208:433::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.662.6; Thu, 26 Nov
 2026 05:01:01 +0000
Received: from CH2PEPF000166C8.namprd04.prod.outlook.com
 (2603:10b6:610:1e8:cafe::36) by CH3P220CA0002.outlook.office365.com
 (2603:10b6:610:1e8::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.662.7 via Frontend Transport; Thu, 26
 Nov 2026 05:01:00 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.117.160) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CH2PEPF000166C8.mail.protection.outlook.com (10.167.244.230) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.662.3 via Frontend Transport; Thu, 26 Nov 2026 05:00:59 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 21:00:30 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57; Wed, 25 Nov
 2026 21:00:29 -0800
Received: from nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.57 via Frontend
 Transport; Wed, 25 Nov 2026 21:00:28 -0800
Date: Wed, 25 Nov 2026 21:00:26 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>, "John
 Garry" <john.garry@arm.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
	<patches@lists.linux.dev>, Pranjal Shrivastava <praan@google.com>, "Samiullah
 Khawaja" <skhawaja@google.com>, Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 05/13] iommupt/kunit: Skip test configs without
 supported features
Message-ID: <awe86jdX2ayKruCf@nvidia.com>
References: <0-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
 <5-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
 <awUg0O0WQUBcuUvC@nvidia.com>
 <20261124150843.GC8680@nvidia.com>
 <awXgxBCNDzh/32cm@nvidia.com>
 <20261124200749.GB114472@nvidia.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261124200749.GB114472@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF000166C8:EE_|IA0PR12MB7697:EE_
X-MS-Office365-Filtering-Correlation-Id: eabd1f20-3fda-49bf-4ef4-08df4b7a437e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|7416014|82310400026|1800799024|5023799004|10067099003|11063799006|260925021311599003|260925021911599003|260925022911599003|261028144727099003|261022105027099003|261026121527099003|261021123027099003|261021121427099003|261026140227099003|261021135927099003|56012099006|261102123227099003|261009223027099003|4143699003|18002099003|22082099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	Hw55+AOZDQ/LoHGK/CHoUW5J2gF/DunGPFHJS4OpTLojgxQdknp/MuTbmznZ2Vn19A2zjpK8E6Ia2WOVloQgQdiBNfhsq8PbmiQbkUIj4ElYtayXyyUbUZUn2GYO4w73FUjD89mLne/wJ1M2SEE8padJyGF708Ja6vdpc0+m649Vu4EkHFPZvZpZ/Cih1A81z2H/uguWnJnmg4hnXcoK0EWRmKDkAhgROSBVWIBkuc2Kt9DsXDqflWKzAn5SU1zW6ABgFYvMa9iaxWxiXkpQDmSKSg6YTCz3zI9ss3cVf71juzy/vj32NLwK04KJMESTyoqBpD0Wx/YENdJGH0abMBMQY4Jffu1BT+LyRSAIXFlwjE2I5EYS/UREa9Pbceuk6GC0KtzTeVbr5EM+Iyb8+fUC8gpBobazdLfSYB/wDY4JBXEWmGI7xd2QdjKowyLd3X9NGnm82RrLe4rM7n5MP9wPK8D1ZSNND0i5xywXZ4jGvdkn0cKowi0QFfPhh7zEvLU/8N1jKNCURL/lh/e3Ig8NCF4d2+1O0LnMZjW69FJA5MWW3WNarARO4yXJPQY69adLR5yEo4VomUyem5lQN0c03IvARaLgnEIeoYJnXPbveRXTyrBtqm11ZDtEJwE1K2qFAonID7RRrYy+kzIWvyWVcvXYFbhl6w56a7TjNpi8nWe9OPHn7sS50lVStTGVlSdL8mQC6FOvQA1IxQ2+Fg==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(7416014)(82310400026)(1800799024)(5023799004)(10067099003)(11063799006)(260925021311599003)(260925021911599003)(260925022911599003)(261028144727099003)(261022105027099003)(261026121527099003)(261021123027099003)(261021121427099003)(261026140227099003)(261021135927099003)(56012099006)(261102123227099003)(261009223027099003)(4143699003)(18002099003)(22082099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dsg96sK0E/HCBWbvMcu1F3hhhus57tK5gsEf41Groq9qZMiRKu/2VOnFd521ZEwbAwH+91Ksslt7utUZLvxveclWcL7PFHUtbWYqdlxCrwkPAf++ppa9YtfA/A5IpKU7Gm+0OnnvO8ia+PTEJsT5eb/DCRHP5f+8NseOTOZx5vyLMHvAgzOSxhswMPYuSUJt5JdIb9zr5wRLYl3QopIv083Wt6l8pv2KSJyg5nHtXojLFtyKRIshBpSFrojOxTcoY5gs62TyedOlkrOlWb0JeqNP6FwOWhLp+t/Bd6BH5YOzBl/XI+9FQXdFoywftpLOWJfeY3b0Ary8Mka47cDR6sZeXvPrVaTyq69t5haQF/DS7Ue/YO0kFbQ31DeDiuAXZai8m5vuI4rRQ5eLXXdhyeXQUB0HMjbv12AZt4SToVz6E5t5CEndJJ9v6OSF/gyB
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2026 05:00:59.8834
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eabd1f20-3fda-49bf-4ef4-08df4b7a437e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000166C8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7697

On Tue, Nov 24, 2026 at 04:07:49PM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 24, 2026 at 11:08:52AM -0800, Nicolin Chen wrote:
> > On Tue, Nov 24, 2026 at 11:08:43AM -0400, Jason Gunthorpe wrote:
> > > On Mon, Nov 23, 2026 at 09:29:52PM -0800, Nicolin Chen wrote:
> > > 
> > > > The leak check reads NR_SECONDARY_PAGETABLE with global_node_page_state().
> > > > That only returns the global counter. Each CPU also keeps a small delta of
> > > > page updates that is folded into the global counter only after it exceeds
> > > > a threshold. So the value can be off by a few pages without any leak.
> > > 
> > > There is a patch already in my tree to deal with this, this test only
> > > works when you use the kunit runner
> > 
> > 6e8127719449e kunit: tool: catch warnings generated by the kernel
> > 
> > You mean this one? It doesn't fix the leak-check failure though.
> 
> Sorry, not my tree, Joerg picked it up:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/iommu/linux.git/commit/?id=d2eba9f4fa6319eac08608958d4f3a11d5240002

That one works. Kunit runs fine with it.

Thanks
Nicolin
