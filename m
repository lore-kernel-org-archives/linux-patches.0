Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2055.outbound.protection.outlook.com [40.107.96.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07D91A5BBC;
	Tue,  9 Sep 2025 05:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757396580; cv=fail; b=c0EsI6DreOWOsC+PYJwPaCwHVH3PtdoPf3M7BztBUVCKFyU2PlzJSK6iJCnOUlEGS5Exont6wZv/yKtey/MXUyI4YOf8EzErIQrFmrz6dloCZ8VA/mcd9fsH9QdfwOXDUDtOKfkGeM83ndQyQu3WSt5mdisK784vhIvJe7DaR7w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757396580; c=relaxed/simple;
	bh=yQSsynTREe/5V5s/2a2aop73snOGUePBjSTW4nH04rE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DkH1TTfrLqbvBdRX5JfQox0ZFTjgNToCPKPcrGdd5kM+YN7zFfDL5UPXdnuaLYSX4suOE1/A+IWRYGX+XDpfB4l9Ztb3C2WY0TG6Ep+xkhh3xbupMEAiyCMv80tveHMhC1mHw3m/wPVrA6XK8dKERezImmPq6aktxDs4q+SsAGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fyBx7XfH; arc=fail smtp.client-ip=40.107.96.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fyBx7XfH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vX7EwFDwoZORePnzEK00okPr2eGuPyLsw7OvsaVr3v6ZrfFTDwlH6WIoZaDYizxPJ70fmUK2p26cEHR6Gb0ZHK92Y6SUkXC7nRMwhv6+R3dee4okMF9aMc61C2oOJJaUxyvdxRcLiE9vZIWbDAiofc3n6uKtgiRKIn7xyxv4WegyH0zRIb91UetSwAhXV2FJ4kjRk2UZTHkzKPcBMwVIOx3OMVeAdNGilPRZHHuFYYxrERRqOHdCp3/v9Oe3zZI4afmIZONEOB7PvUEUzgr4J6vQ30zIYc6/fNF1XDXEg7NliScUUIQV0ofIk3zOBrST7uecGOOov/Lyjx8gXBdPlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FWzcGJAvXwjcaTGtehRSKuCXFF9JoTj7AqZUgT/LODI=;
 b=rw+AYFW5Pf9P3wd73lCAgv7MHcLs9Zz5ac/38m85w6QmDN/W27gQc9IENlP+ZGz1xB4mBwkcTCvtpUu3vdIBRaZFUWNe7JtGh0b73w8SWSnc1PFLl4qFrdvGfr3kExuurXKfTXAUemRB3z8BXTI3E7U06TWSj8Hv+D22Cg6uC/YGdssz/FOym3kwGugRz3KMo/j6gcZYhyax4HL5PrZOxj6NQiENaymAKmh2oj/gsYE5ONtAYP6xWYa9pMXv8FpS/OJBxyQvyPQXFlv8zZ6Hdv97gUp2A0yMf4F3lj8j8L7J911iMjLvuj230vt0tGdXUkT1oIT7vVhsny43Mb4YBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FWzcGJAvXwjcaTGtehRSKuCXFF9JoTj7AqZUgT/LODI=;
 b=fyBx7XfH/iaVtx2ksOGveJAMc3aFTE3tuXnzx/GJ/wTC3XaxJ5nRVu+APuRpQQdnZo3SJnbjYfIZQ0uceAbmYrYMoxLp4U9NQ2TumWehvYMqQhHakMrcjy7VjouUZ2TtwtAIisGvMF0dMyhaxOS/bx55WUTwmK8kVv1SO1LdjKzHB1oRx79C8oXXN/TQCHf4D2k/rki+pns9aBd9EHwketUI1MTucqG+tZPgXk3+qxw9C2cisY09dReMdizPpCOzsn767M5Yx2oGUyAFONFaGRYynBiaT8xxTwXDscGdGwkF6Z23qL8vI3Tv4WQOULzNVyhMcckV/CplHL59TeLTaw==
Received: from MN2PR13CA0032.namprd13.prod.outlook.com (2603:10b6:208:160::45)
 by MN2PR12MB4062.namprd12.prod.outlook.com (2603:10b6:208:1d0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 05:42:55 +0000
Received: from BL02EPF0001A0FF.namprd03.prod.outlook.com
 (2603:10b6:208:160:cafe::df) by MN2PR13CA0032.outlook.office365.com
 (2603:10b6:208:160::45) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.11 via Frontend Transport; Tue,
 9 Sep 2025 05:42:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF0001A0FF.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Tue, 9 Sep 2025 05:42:54 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 22:42:33 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 8 Sep
 2025 22:42:32 -0700
Received: from nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Mon, 8 Sep 2025 22:42:29 -0700
Date: Mon, 8 Sep 2025 22:42:26 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Balbir Singh <balbirs@nvidia.com>
CC: <jgg@nvidia.com>, <will@kernel.org>, <robin.murphy@arm.com>,
	<joro@8bytes.org>, <jean-philippe@linaro.org>, <miko.lenczewski@arm.com>,
	<peterz@infradead.org>, <smostafa@google.com>, <kevin.tian@intel.com>,
	<praan@google.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH rfcv2 1/8] iommu/arm-smmu-v3: Clear cmds->num after
 arm_smmu_cmdq_batch_submit
Message-ID: <aL++Qv8bNvL5qjL8@nvidia.com>
References: <cover.1757373449.git.nicolinc@nvidia.com>
 <2f7f5fff38d43221fd60139323d23b258e34cf8d.1757373449.git.nicolinc@nvidia.com>
 <d2852d21-60bf-4ca4-a0d2-e70c0c6dc010@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d2852d21-60bf-4ca4-a0d2-e70c0c6dc010@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FF:EE_|MN2PR12MB4062:EE_
X-MS-Office365-Filtering-Correlation-Id: 0583b9b1-38a7-4ead-769b-08ddef63b98f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hkuJq6jstXy1OrXMV9sFnHBXa8kB+xRQViey7L2D/B3wNSIjMbDy90w3ED8f?=
 =?us-ascii?Q?2twC49TpJi9vsU5Fmb2olX5DHkVQRub/Cb2rfFWrq92IgEtX+avI0WyJM0Or?=
 =?us-ascii?Q?i5MggKH6wE5SFIe2ORLPIZY1M6A4YgFlReabIU2GX6R3Jnnkbf+EY7vW/OSp?=
 =?us-ascii?Q?kgh8wgu+VQaIf5epFat5gU9zWz1n9ZW7pP7aq30bHWz4CqlgwVnsTKQn0hWe?=
 =?us-ascii?Q?N5bT6CL6fOZVwll5Nkij6QsqpJRIHykntABpDlxRxyA47JPa2K/K/T51lEho?=
 =?us-ascii?Q?UzAOvDXQncy/6zGZxz6Q0RHlhukKcCdIppjb8ANbKvCtJ5NabDjQMgqLiNcn?=
 =?us-ascii?Q?gbj4radCRtnQSRDUy9KQa5PV8mRZ1TLmk21Iy6KKFtyBUa8mqQewCEHENtkC?=
 =?us-ascii?Q?URxZzV3I5jwzK1hLyfL20wAhXt0xH7Oc5+z36yfu6GKTlToP/Bo0dGx2Tvgs?=
 =?us-ascii?Q?VC+GknuPGc870Tbjrokf2xfWkpFH0Fmx0AH9ZghGq27Kuu1GbhzvSwwHuEEX?=
 =?us-ascii?Q?Il+Djt/HP0f4OoWpYuR4IszIG6bJLR+1KgaLlcHoK6Vjjeg1bS9gsTVDkX/n?=
 =?us-ascii?Q?BR/ZE8Oa5B7qgusDq102H5LT/7W6mdZzOkAZH6DSn8a1u4h1CgOx+MgeaNI4?=
 =?us-ascii?Q?atvrP1Bor8fmCSE4x07W58vy0uwfq8GwQ8iMAkmmeiNnD1L4oG07kLj70C3l?=
 =?us-ascii?Q?dk2QhrJdDlgTQm7VxOJS/U94bg/PFgvqyN0qpnecnzM7otvfkWdGiZnqz0aI?=
 =?us-ascii?Q?EXMnHgkaKMp+jS6B46ClE8bNFtDtIWDMDWQIH3HrGmK4JlWQopMjOQE1PQnY?=
 =?us-ascii?Q?o9aviXLL88y+4UJkcuITsHDptRzSWQTUH5phpHh4Y/N70ir2HDo6jDNyghJh?=
 =?us-ascii?Q?Rj8u87x1T+JYCDfAIe4jiCZX55Eg3QfpTVe91ak3nYvz1uUKSUGyEvzfRrRE?=
 =?us-ascii?Q?0hosasfXT5Y32taI+1bCtB654CKmoFDVjRCdaNyZ5YJkI3MABTTl0lEGIjG4?=
 =?us-ascii?Q?qEAPGE92WUt8TKqsa5jrj7JQLK6vI6IN6Z6U77qLSsUJzYMAtFSzKHVdIyjt?=
 =?us-ascii?Q?a+TJE++zup6JpDRFN0cCqR6quO2sVJjcYRAD9cexptZGbqx9y2pajtnp4JUf?=
 =?us-ascii?Q?NB/njSOHajWR5pe0TMHtjBYreY/a1Gl4Z/i6HJ4ByGHglPcBX36PUQEL8eiP?=
 =?us-ascii?Q?zof3sb+K4jKca/PGx8Tj6x85DQpzkGTAJzamB+udNslT4HnVSprbZ1OePtnP?=
 =?us-ascii?Q?21elw+DivIYi5lBAzqvQcBErayp4ulaZ92nTkyON4l69fchXHoNJc1F7klSm?=
 =?us-ascii?Q?b6CqXtMwaH2HKBGdTviiLkzJbYxKq6fz1XtJNYlpPjPQhvjr9vM1/MBvsLXZ?=
 =?us-ascii?Q?+3RRsYPLDR6xeqa1gd4vCMQMi51NEBe/0o/S2GCsO1VC7PJkfm7r5eh54Sjm?=
 =?us-ascii?Q?xLL6qTkje7/80B1lgONZpldorVbh6QOCNZxP6kEqIIAjIKqL8d/dU0pkJ6y1?=
 =?us-ascii?Q?sRha84fNBfl575v6ngb6CK4Yl7sbsQYSNU1c?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 05:42:54.9100
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0583b9b1-38a7-4ead-769b-08ddef63b98f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4062

On Tue, Sep 09, 2025 at 01:16:11PM +1000, Balbir Singh wrote:
> On 9/9/25 09:26, Nicolin Chen wrote:
> > None of the callers of arm_smmu_cmdq_batch_submit() cares about the batch
> > after a submission. So, it'll be certainly safe to nuke the cmds->num, at
> > least upon a successful one. This will ease a bit a wrapper function, for
> > the new arm_smmu_invs structure.
> > 
> > Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index 2a8b46b948f05..cccf8f52ee0d5 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -974,11 +974,17 @@ static void arm_smmu_cmdq_batch_add(struct arm_smmu_device *smmu,
> >  	cmds->num++;
> >  }
> >  
> > +/* Clears cmds->num after a successful submission */
> >  static int arm_smmu_cmdq_batch_submit(struct arm_smmu_device *smmu,
> >  				      struct arm_smmu_cmdq_batch *cmds)
> >  {
> 
> Nit: arm_smmu_cmdq_batch_submit_clear()?

Probably not. There is no particular point in highlighting it in
the function name, as there is no use case wanting an uncleared
version.

Thanks
Nicolin
