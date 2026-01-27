Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010036.outbound.protection.outlook.com [52.101.56.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2CB1A8F97;
	Tue, 27 Jan 2026 03:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769483203; cv=fail; b=hyU8pDfPuq0PcTxhkUUmUn5BgQJwTnGGMQH0ckyZVHaSMNRt1bgNF/IUhvKoCHnUC414Rk1PPV0iBeMYhwVoQVjD4mGoML7ddl6NtFRFW7DImanOOHNJk72b69TuLy+TQFFX4G4OXABoAkYSg0MxW5x9x35mV0v4JP2zPQSmCvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769483203; c=relaxed/simple;
	bh=O9w3gnWuO4jhfuRC32pt/yEyz8urMcfQHqSty/ov9aY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UX56Dg04q3LAVHjOScMQC+JxsLKYOlxBKTDT7dVT8ZYAR1UDRNValURtro7ghMGywUNGbTKE91PvH4RdB5WWyNFbAIecrl2HpgJDPgk+YRnEOANQkpNOtQ1xxT8BvtaX7KI7okKjRbgct4yxX3/rtrDw25KkZUkNiTyhrT8nEXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=GqvHViTp; arc=fail smtp.client-ip=52.101.56.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GqvHViTp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vDj9QqHFt0LHgFJDh/wh5sIhe4GLYX9Bs5jbxsO1bOwV7TMEGhOy8F10uqopYZUEsRmb0wnlH8ksj3gSkgMD4J3c93u3wGZP4LwNiUqUX9h0IXpH6nfSOYD33XL9COaKLSpvqfrNpZFmOVrUuQPeRJnaCBa5eJ9RuioDKA/5SJti8Xxl9dfcYvQTUwBHUK88cmeS0RbzEFo4HNCXdpCqrZwp8dhw9KmAQ2yvkKHhx0hsurCTO9o3Q8LGMXw0fTM9iXlpf/ftWSdYoi2favSDAJrNKPfZP0cjgy/Y/i+dHJr5MzKGsHkydwCgFxELKfPEOC+7cB4kqMacrgfjhADKkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ItuYqzZWzA/Z3U4wcfz0YROqGSZl50/WH43Vd1lJUW4=;
 b=quBrYbVr8jB6gTvt7gW/74+YIyrawdt9yBv9d+XMU2m5jSBv8T/xM9GC87jwmsVnBmqxlDg0/Xw+Q8QA0ZGhfRvoD9lyTCslkL5aImUwT7ctJ1BJSledcurKEjhfGpZ00zslrtCIsqcLg3NOTDTG3oqCJkMdjI5GP+jNmRTzIdVuZQk9JaUEQWIfW+3wa3gYVvQk9npmxabtPMtDjNh3CwfKb0QpDuZltB5DloPzO9Er+RAaditMw0pyYxccRDRqXXnhb0wXhPno32S5uuQwy7K1/xrj1mOqzQJpHVw/++2SToeOF3KY2mPYUfnbFZ+QJkgfzwh7Bbyfy+KKYQ4jjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ItuYqzZWzA/Z3U4wcfz0YROqGSZl50/WH43Vd1lJUW4=;
 b=GqvHViTpoA3IzY1N9/R7BT46N1NNe4z0y7edntjHUTu0jwPrhhy2+x/fxViOwA2Pz2nAnuvSbiCS8tlvaWCwS5zzWZGX6MsezFa9oRLggqOKaNoNwEgDd4l2a2oKNZl7lg8J+Q09oh2hAQE9/XLjWKR6wePT5LshjfOBiYlgoWMjCJPUkCQwjWzXblFuko1PKkLwXIxl6598PlADmX4AD8etxLmWwe9BQJsYuPPHiZowouoQGxH6Yd1PhvUIQ3EwQxhW2i4++c3rNgf8RTWDOBpVLLlF0ns4EF/9detUc0tgZctpxQStRzBTflwtFbzKc93Mpmy4H7L/XUovzjSq5w==
Received: from SA9PR13CA0042.namprd13.prod.outlook.com (2603:10b6:806:22::17)
 by IA1PR12MB8336.namprd12.prod.outlook.com (2603:10b6:208:3fc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 03:06:38 +0000
Received: from SN1PEPF00036F42.namprd05.prod.outlook.com
 (2603:10b6:806:22:cafe::c6) by SA9PR13CA0042.outlook.office365.com
 (2603:10b6:806:22::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9564.6 via Frontend Transport; Tue,
 27 Jan 2026 03:06:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SN1PEPF00036F42.mail.protection.outlook.com (10.167.248.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.3 via Frontend Transport; Tue, 27 Jan 2026 03:06:37 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 26 Jan
 2026 19:06:26 -0800
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Mon, 26 Jan
 2026 19:06:26 -0800
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Mon, 26 Jan 2026 19:06:25 -0800
Date: Mon, 26 Jan 2026 19:06:24 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jpb@kernel.org>, <praan@google.com>, <miko.lenczewski@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v2 06/10] iommu/arm-smmu-v3: Allocate vmid in
 arm_vsmmu_init
Message-ID: <aXgrsJeXB3bpFQqK@Asurada-Nvidia>
References: <cover.1769044718.git.nicolinc@nvidia.com>
 <3f7c5b84c4f8605688ac08fc2ea2dab08a3c5c0c.1769044718.git.nicolinc@nvidia.com>
 <20260126211636.GB1134360@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260126211636.GB1134360@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F42:EE_|IA1PR12MB8336:EE_
X-MS-Office365-Filtering-Correlation-Id: 892c2b39-0508-45ec-664f-08de5d511631
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?t94IkakZdyxP6vMhwmCao2Ey9L2efmn4J8Qn4HGK3EZDxkE9b2bqDZdM4U9V?=
 =?us-ascii?Q?8ixZL3949An6UYpAesGGkwv6BhMMTa1gJrUpGRuwWoBzw7hpDWU/k7CMyoKV?=
 =?us-ascii?Q?lIR1bAJivsuf0tMaeat9y2pi5l83i26omEls37hwqHdC6iOCKMbeB1WrpTIu?=
 =?us-ascii?Q?up8OQ81KnqvGQ9lHf5RF/MxQxvHLrmUZhon6s8oZmsSbgcZUboyl6/zt1Ksd?=
 =?us-ascii?Q?VeIxi5HgvPM/KE8j2e6A9gCzaHOtzarFwygJC/W677kRFCVptHOjnYwXpRKk?=
 =?us-ascii?Q?qle70z/B/78fhwopQM13WBec6WBIQDAUB/6lpktPSHyj8KXN4UyKa4J0quzT?=
 =?us-ascii?Q?pv71BDyf/wtxgQWBcYH/gY3hh3PpwaDaHVf6OHfHK62M14egD4TOJx0U6ioR?=
 =?us-ascii?Q?kfStKD7LYWq/sdfpHKaM8g4+DWoqcTtEpRF06KZ6HEZXlj9w76hpbSmJCqL5?=
 =?us-ascii?Q?GQHEZ9/YyVcTk9wVF9HV/ifIuWMPdD1Pw4WAmx+dbIOWp/+clzjmJZnbr3KZ?=
 =?us-ascii?Q?zidRSY8Tfguuvpf2XD3vVyicIzu2xZYx/I2GqJ8VsP2UUQ8oGSncFRWRRcVE?=
 =?us-ascii?Q?7W0dCx/KXsIw3qCcgxkFMlnyTeowMRG/Mejw5EVOqY/2XCXDrI0l/7ad7ob8?=
 =?us-ascii?Q?5KlnwCY3y6FSn0TsfqZAm3pnKHKE8MznfkcEYPIUuWxoNkjmKsG3E3ohagMd?=
 =?us-ascii?Q?k3q9B+1oEb2b40948ikobjB40MW7Bhw2AGP8tNbYXw0CCXUfyzSh/j1w+w88?=
 =?us-ascii?Q?WlECjYj27qVTDEW2HT3DR/mPRra8dL3f1iNu+J9cZAcRJloCV1+RMdFcVkLl?=
 =?us-ascii?Q?DOkgZESRHItJrw9Cqe1rEnEdGqobrEbuIUH74EOTcZV7gDGvoijBzh2oD1sr?=
 =?us-ascii?Q?Q3RXonVHGrpSGLP1+MWSnnSsxGvYbeLpGHzDpWlVsDT+eQYPORsIoxZiKAo0?=
 =?us-ascii?Q?511MXI40GvzIYLM+uNHd9MiC9N1PDCwsG6Nl8zj7rEkVvEKi6puoe4k+U++x?=
 =?us-ascii?Q?5CSFK9+MIZ/s/aF6/+rioCoN6NVR5rfTLQ7Wc8kTkPm4gC+sjKRF+WC6XXwb?=
 =?us-ascii?Q?gGvvtCGn7/Y4F3UjXRFiqkIPHQP8JzfrmXPqnjUykaCWLUinOUViHdV/w5FT?=
 =?us-ascii?Q?jlJrdRPU9M5FIYGcZT3UN17icNlpz47reJVW2wJWAfWkjqItZcxs4iWMLTVT?=
 =?us-ascii?Q?jsvHNLaLHWirEiFMM2+54NohGcIDV+Moh7TqdFdEGnRaLmSJ9vn/fF96sW4q?=
 =?us-ascii?Q?gh8X9KDM3ULu4KkavooAAHTO95inJQkm2UKsk8Lw2CMe2VL2HP85pPY/9xVo?=
 =?us-ascii?Q?klZlNCqSz5BWt45Bv4VxA18MK6e0ZeN6JmJExOUWwrdI1CgwhHjArn6jNNfT?=
 =?us-ascii?Q?f6XUVMSxasHK7lk2VdA+MZBvBaz1/M0/iDkRox2Tfgwh5HTGRiT1oPHm2wRd?=
 =?us-ascii?Q?8PJ7tQSgEKuc8wIRqK0JQdwGL82+SuPMphNff2BjlcP+0ykBxS41tXpgwqHX?=
 =?us-ascii?Q?CXw2HoFfWCC5TbQdUArC5juvYtMt4d1lmW0Sar9NbfCdhhKg3/L1VTAcsY/8?=
 =?us-ascii?Q?hZTy5t/PNL4VUmgiq/TNmoUWXF12GV4SLRUuXB5/Waa7MIGhvHBC1JMUk44g?=
 =?us-ascii?Q?YcKX91U82wlvuFiGUehxVOj+dqh7jKJ1JuT8SSspzGh/9FHDZGFvxk2JEK66?=
 =?us-ascii?Q?IXMUIw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 03:06:37.7872
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 892c2b39-0508-45ec-664f-08de5d511631
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F42.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8336

On Mon, Jan 26, 2026 at 05:16:36PM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 21, 2026 at 05:24:24PM -0800, Nicolin Chen wrote:
> > VMID owned by a vSMMU should be allocated in the viommu_init callback, as
> > HW like tegra241-cmdqv needs to setup VINTF with the VMID.
> 
> Even the architected SMMU needs this, the VMS (not implemented in
> Linux) should all share the same VMID for the same VM.

But for standard SMMU, the allocation/sharing could happen at the
device attachment to a nested (maybe bypass proxy) domain, right?

vmid is only needed for STE (attach) and invalidation.

Or do you see some other case where vmid must be allocated during
viommu_init?

> > +void arm_vsmmu_destroy(struct iommufd_viommu *viommu)
> > +{
> > +	struct arm_vsmmu *vsmmu = container_of(viommu, struct arm_vsmmu, core);
> > +
> > +	mutex_lock(&arm_smmu_asid_lock);
> > +	ida_free(&vsmmu->smmu->vmid_map, vsmmu->vmid);
> > +	mutex_unlock(&arm_smmu_asid_lock);
> 
> Need a comment explaining where the flush is.

Ack.

> It looks like arm_smmu_iotlb_tag_free() does the free in the case of
> INV_TYPE_S2_VMID_VSMMU?
> 
> But this patch doesn't have that code yet. So maybe this should be
> merged with the next patch..

Or maybe I should re-order the sequence of the patches. I'll see
what works the best.

Thanks
Nicolin
