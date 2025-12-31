Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011031.outbound.protection.outlook.com [40.107.208.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F6C2FFDCA;
	Wed, 31 Dec 2025 19:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.31
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767210561; cv=fail; b=gpcjHF0IEL969djwjOrA+gkcX4hs39QjT3FEwggx4HzR37I130rqgh7+opwG4RO1jzJz09HHpKKJw7mHu/CjZqY1omQASS8nBSkNQOXXfFi8yO1UmYcB5ZDZS2jHH4qeVAILvSQg7N3uDfQ0aecHzTq7+vc/BZuOwsQj2sR3+xk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767210561; c=relaxed/simple;
	bh=maDrgXLqe5VmJhifOtRzynCrt0AGl9GYX+n18UC22S4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RtRCVjxSDrDmwZyyuaZchjUXhx0CJ7xYBgDAoy9PQgUckXbnFnCqimCtw5gKzC3o+a9juWUu/z0Nj73n1h2xPDVe2NYW6A48sI6RAwWo6dUCdJHmQvQnT6KAOfmYr7gVXQskeSwOb6bHI9zFPtZFJJz+5wYFK4w8P9uh3m/Z2mc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qEgqR/gb; arc=fail smtp.client-ip=40.107.208.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qEgqR/gb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vU5eghumTzu69FN6AmqfXkWprAczeRLU17UdJpRgI3mwkrfaj0ctgl4tqo6V35r1mdWgT1yZuZ3InAcU2/4rRNMyyrfSSbX8kfp08TYjLSDdB+owcTakBbsiCTvjfEPkhhV0+bvVFK+2RWJuoW6fUSW9WFRoDC9sD2Z2vj7t7Fry2hkjyRCVvSPvN91fRpiv4uCBYwzdPpoC9+5YG2opf3H322c5qqguUq8uymuoxjsANnx7yPw/FTEiGOJBhw/vq2XHnuY1LdM57WIu2eS8hHnP23McirtzcfqVhB1nm69nCJYz/His5jsNMeCKank98m+pn/p6EOa/E304GObomw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z+xpTGCc2+wtCHsHGpLPyY+dLbrZGBUUuBYP+PIY8MY=;
 b=klvhcyDaguDwjBkPNVCHLBZzPcTvNvC502mkMjdE4Nl1KmrZnJK+Jp/0bSHrkBS5r0E2ayFdpXI0Tc6pHjoY+suTn1A6bZDeKDMS+lteEusdEDH/2xTlWWOO2rdbYYEkXYwNORAN2sxb4x0RUhgRnmZcuEzTB/8V7d8fwmihxs5xhneYXfHJ7pBCSqTDYWGksw9JywzvNoO/18jgFXBsRXlNx4mNTMvf1dpKDkf2FtiayHKoQ8KJ8pmV8Nr+qDYhqn50ix5rNOl5KCQfiYkA4VuQrl5urXRFBkRqHtpzycKOKnAHicS2D24GB7ryu35uCZa6K5sq65RLrqyqnHR8nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z+xpTGCc2+wtCHsHGpLPyY+dLbrZGBUUuBYP+PIY8MY=;
 b=qEgqR/gbVicz3HWhwds1O0Wn3+5DVqomydYD104oGcCp47GflbGGIDJHtDnIAxvM7FWNtqXUOtPuGjdrDgvCztDG5b/7uVS1vgjTqC8VQg6FbONQRmmdGD6RXqLXaqFcNyEsITHofI1y9WnUBiFTbA5JfPRDQTGVQuWtUu9jWZDp1sIB+NlY7izm58Cptpk35EsNFfhJEWNOr6omLCeoVlvJUhbaoc49USpLWXPzZ8UVt3GLEz//3HFexVh1IfyRNTL4n7uKqt7NBPFKsBibvDkVaUtbIvoMh0xG33WBxwHG1bGEIbT4tWDWyr26YuaqN1Ot8ynudG4h12Tw6TUuNw==
Received: from BYAPR07CA0049.namprd07.prod.outlook.com (2603:10b6:a03:60::26)
 by SJ0PR12MB8139.namprd12.prod.outlook.com (2603:10b6:a03:4e8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Wed, 31 Dec
 2025 19:49:15 +0000
Received: from SJ1PEPF0000231C.namprd03.prod.outlook.com
 (2603:10b6:a03:60:cafe::84) by BYAPR07CA0049.outlook.office365.com
 (2603:10b6:a03:60::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9478.4 via Frontend Transport; Wed,
 31 Dec 2025 19:49:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF0000231C.mail.protection.outlook.com (10.167.242.233) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9478.4 via Frontend Transport; Wed, 31 Dec 2025 19:49:15 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 31 Dec
 2025 11:49:00 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 31 Dec
 2025 11:48:59 -0800
Received: from Asurada-Nvidia (10.127.8.9) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 31 Dec 2025 11:48:58 -0800
Date: Wed, 31 Dec 2025 11:48:57 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jpb@kernel.org>, <praan@google.com>, <miko.lenczewski@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v1 2/9] iommu/arm-smmu-v3: Add alloc_id/free_id functions
 to arm_smmu_invs
Message-ID: <aVV+KWzpxPPfaNw4@Asurada-Nvidia>
References: <cover.1766088962.git.nicolinc@nvidia.com>
 <1541ea4a9e9c935c2f907c0c5f13a4af2bdc2114.1766088962.git.nicolinc@nvidia.com>
 <20251219170551.GF254720@nvidia.com>
 <aVQfhaqfvfLFNZqe@Asurada-Nvidia>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aVQfhaqfvfLFNZqe@Asurada-Nvidia>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF0000231C:EE_|SJ0PR12MB8139:EE_
X-MS-Office365-Filtering-Correlation-Id: 46d12573-053b-4436-c6ff-08de48a5ad9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tOAhkeX3IgMOEaLeSyhAxb+Ypv4wfe1M1R5tqflvIRMN1rNlaaast5QQ53fh?=
 =?us-ascii?Q?YJEq7u83uhtXcgAnlKWrJQI8edJJZLWudYnfTmrK+GKinHXqKRtEusmq6Ark?=
 =?us-ascii?Q?bricUjh0QcwDvjMpzgww75qV+hgYmnvSqiz9kRZnHW7iE0zBvy8wRXZ143TA?=
 =?us-ascii?Q?34hyK+iryRyHxQIMIX5bqW+9qNVtm81BJw2V7iMMBB/n77HVEfEkNsCzliT9?=
 =?us-ascii?Q?qQMR0JmQV7ejFCsq5jJ35JS3M8ta+ci2DdHgY2F3WdHQn52/GS0pt50Jdpps?=
 =?us-ascii?Q?FvR6azrrg4vrNS9Bty5vvYWkp56H6KN6w+LZEKQPFEZclIcfi4+HWFfnTyjJ?=
 =?us-ascii?Q?ZisRHJ7ggLJN0WGw2r1hltrGafSqm7eVJ9vfgYFbr0abWrJk1hCZbdhhDaov?=
 =?us-ascii?Q?f4qvmx/b10CRFjGgmX5thstdle7sy/WqZVvtgqvcukhOgrQ/t10uBVSS6K5b?=
 =?us-ascii?Q?KUUTQf1YHl4Pzx9EgCiL+tSP+dfjHLsJGOoDH4Hy6TrMMPSMSf+zWCWyCYck?=
 =?us-ascii?Q?O3Egl+ykdMxzpq9+dG+D/U4pGRa8O01w8DgT06ziLv0c/92F7RLW+vtwEVF4?=
 =?us-ascii?Q?CZpzXSrmziPqdYpxOChvx4p4GZNsRQZRovFAElqn34otsI9FNYAvARMBDWTN?=
 =?us-ascii?Q?tE4Yo3FXC3dLQCV/qwQhp+35mhMAlSiRjzRciHcLAibzjHAaWzoZtEvRsuhd?=
 =?us-ascii?Q?Uj8K7Q4qE+IxB+XyB5Hxb41lnnLXfeZHJ0DPGsIF5uBcrzQqR+VAVh7PVWXf?=
 =?us-ascii?Q?OA2Y1tW24v67J4QDhhnfsB4RKTB32genDhfNiNib4zWWblchGDn5VPR4x3h6?=
 =?us-ascii?Q?ustvIu7kQeNbPurXhaXT55chiVbAU47rfJRztBTl8bEDVwsCm1+hxIOXeWg9?=
 =?us-ascii?Q?bkEfBXdj/Y+GSYHhAX+a8N+B0kY/6SZkojldShP8JaP3b5iFHMp7AI2Uu+c0?=
 =?us-ascii?Q?Ovnuf0eNG5miZacu/y5u2Ag4yJ3HOfmJ61wJHA5JN5dBvjw5H7r8jjPeKcc+?=
 =?us-ascii?Q?C0jjqviBdPcsb87+FCuXyoDzstA0cZGM+Dfi0maPNLv60W5612P2ThL6sCOq?=
 =?us-ascii?Q?yDpu6yGOTsusuI4wIOdChwL1c0Txo8c6iZXML7W1RtTW1OkPC2hjtSCiS3b6?=
 =?us-ascii?Q?Dyq5NOGFD1swoQz0BZr+bjzo88lzGg2WKufh542IFNY3swMEnLsW33BGgfDq?=
 =?us-ascii?Q?VppX1N0xFYkZfYA5J2ecgbBTC8xUse/xF9Ebpf/vgeXwn6Fo395FGj/kI4+i?=
 =?us-ascii?Q?8G/5HRXH1ewPaO99LPyF5yz8gYypLot8SVsJdmQ4TxaYd9Yklg7dBuZh7afs?=
 =?us-ascii?Q?9kCP2CAKFsUEHMHl+qfRsZpDVz1MydsbwXcJlEc1Qgw2Sm/wh6jRbze25XJP?=
 =?us-ascii?Q?jLQXuoPr3MF8AvMD17I1/IYq8QyXpXDoWGxKO6Sega3eWBLfpXmtfNzKURB7?=
 =?us-ascii?Q?PzrfyoE1mYQggLyPfk28u7ckzPJrjekAMqKnfj41trNikIQ+mw0OyShjWozv?=
 =?us-ascii?Q?ZZ6E1/PzSmb1g+Rk/4SeBjS7ctZcjjdj2WdVrVuM841LDCOkEWxXlmxwYqJO?=
 =?us-ascii?Q?Kj6LIuMFgZB0gCmyFp0=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2025 19:49:15.1677
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46d12573-053b-4436-c6ff-08de48a5ad9f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF0000231C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8139

On Tue, Dec 30, 2025 at 10:52:55AM -0800, Nicolin Chen wrote:
> Hi Jason,
> 
> On Fri, Dec 19, 2025 at 01:05:51PM -0400, Jason Gunthorpe wrote:
> > +static int arm_smmu_get_tag(struct arm_smmu_domain *smmu_domain,
> > +			    struct arm_smmu_master *master,
> > +			    struct arm_vsmmu *vsmmu,
> > +			    struct arm_smmu_iotlb_tag *tag, bool no_alloc)
> [...]
> > +	case ARM_SMMU_DOMAIN_S2:
> > +		if (smmu_domain->nest_parent) {
> > +			/* FIXME we can support attaching a nest_parent without
> > +			 * a vsmmu, but to do that we need to fix
> > +			 * arm_smmu_get_id_from_invs() to never return the vmid
> > +			 * of a vsmmu. Probably by making a
> > +			 * INV_TYPE_S2_VMID_VSMMU */
> > +			id = vsmmu->vmid;
> > +			return 0;
> > +		}
> 
> Would you mind elaborating why arm_smmu_get_id_from_invs() can't
> return vsmmu->vmid to share with a naked S2 STE?
> 
> I'm having a bit trouble justifying this INV_TYPE_S2_VMID_VSMMU.
> 
> Since it's the same S2 domain/iopt, if anything that is attached
> (whether nested or naked) changes the S2 iopt, we should always
> flush the nested S1 domain too, right?
> 
> If so, a naked S2 STE should refer to the same VMID in order to
> allow its following INV_TYPE_S2_VMID_S1_CLEAR to work properly?

I figured that having separate VMIDs on a nest_parent S2 isn't
a problem since invalidation will go through all the VMIDs. And
having an INV_TYPE_S2_VMID_VSMMU is for its unique lifecycle.

Nicolin
