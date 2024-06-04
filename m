Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2042.outbound.protection.outlook.com [40.107.101.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63010136E2B;
	Tue,  4 Jun 2024 06:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717482068; cv=fail; b=iqa2Hzf4o/5zzg/4x5YLi2E9QNC0S8IF2kWlCfRjDeo0VzznpB0ooG0+fK7CqqiXGKXS9p+8vXsNFiuScL+tigybUhS+DBNqBoGq2kqnpMrv+Xw/KxjQkI8yH+EEaL7GhtcOABBYIDiYwQHKCNNSMC9yA23eRniyNAEg+4CHuGQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717482068; c=relaxed/simple;
	bh=A9NheWFefkP0Ut2Gt9KZk7TEh1cwJUsB8XazKgC/P0I=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nivjZIKtQAGestW7u4jlS6n5gUAN+1D0QPT5wBawGF3JO9eZ3jA3uYJvUdtwVfBTC4aGRBcKUN3ZIpyc2yxioebvvyFtjmwps1ScJGEaKbii8Wzfam4dd3VZz5f31VVqgn1kNcS+5Z8VBof1dKwvQvpmQejb8VUSy10kM5J1MzU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Bh3QoHe6; arc=fail smtp.client-ip=40.107.101.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Bh3QoHe6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UBuX8QUJvpAp7w2q0FyECdNQX/rWFr7JC3VI1q7LeUSyd8DqZlY5himZs2ILbIPQB/KUzPSyBeK1C/53pd6z4LKoJ0vmowyQyyUXNhwDfVWTrHjW5At3dfLcuqPENqQwjNH5eu/TRySf4lqQ6WRGdyKT+Qpvx75TzYs2kGXm+Og+KX5rXA849gixZ6c6c1xt31HrjcriwFhRnyJFyiw2Bsqai+XNLozla52fP3tKstnmJzWHXPPfB9ykcukFe4JLIh3DqnVppaHDiUHe+Xfo/jnlXDKvXRDfv4GPVlPFQ3ElGa9K6ExA3H9RGdgDdTCJex3Uzi53XFiCSblejgAJCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f0P9BPsbIiV8Q8xxFUU28BZ51N5F1Dq6g0/AfxRlpAM=;
 b=hVDj4VEPmvwHzKv6+8yDLA/1iuDAE75yNAq6WCuiUF84ACqTcrNGnd31uMuEDdbllUTJ4Banu2+QT5MNkUTRjafCt6Lo97N3K88mKZRw2knHJmll00vd+Zh5mJp5hW30F8xaCrnZt/P3GD0NLu9hnyP/EJ2kp0xTXA3w6Rn2A5PM+OznY//kSOQGfPdovtk1ZEBbU7TVuovC/RlNz1APvs+pPsoBdBec1lBfzh16jpyCb0H57czS82Cgtf+BpEtxO0Gz4pims5Wgp5osT/m6Kg3vvivBghkfUbLBsLNd+xLWDnsi2F/l3fJ7MysmBC5LO6kbfLsvu/s+aeJe9te1Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0P9BPsbIiV8Q8xxFUU28BZ51N5F1Dq6g0/AfxRlpAM=;
 b=Bh3QoHe6dkL4CU9zs2RInJXxkBOCJO8k/MQv7RRa5IpIXTQXdw7HPadRmEaRVGv1VkFM8fjRsItmeNs/JRwH6l+ZuftVHRfI8QAWQXMbby4LfsKrDudVTSTJ3tCI3JTiOG7ofHVLRKk33lCzxRstQ26VaFF6FqlhjqsQULL41qtHvxmbKB5srPCuze/xMKpw/l0lBYYVtysjO3qJGCYJtYYNgMs0aCMFfAItKwL0YzaOPDorf2MbGrwFoWtAT9jKkeKU8u9UNR6XwTome6WS+6/SjUabdK1LFXcxYFeL1NXeLK9eWvRvwEXU+Se/F2o+uEROMT8XYjJW1vy51qyP0g==
Received: from DS7PR03CA0037.namprd03.prod.outlook.com (2603:10b6:5:3b5::12)
 by CH3PR12MB9252.namprd12.prod.outlook.com (2603:10b6:610:1ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Tue, 4 Jun
 2024 06:21:04 +0000
Received: from DS3PEPF0000C37E.namprd04.prod.outlook.com
 (2603:10b6:5:3b5:cafe::3d) by DS7PR03CA0037.outlook.office365.com
 (2603:10b6:5:3b5::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.30 via Frontend
 Transport; Tue, 4 Jun 2024 06:21:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS3PEPF0000C37E.mail.protection.outlook.com (10.167.23.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.15 via Frontend Transport; Tue, 4 Jun 2024 06:21:04 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 3 Jun 2024
 23:20:52 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 3 Jun 2024
 23:20:51 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 3 Jun 2024 23:20:51 -0700
Date: Mon, 3 Jun 2024 23:20:49 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v8 13/14] iommu/arm-smmu-v3: Allow a PASID to be set when
 RID is IDENTITY/BLOCKED
Message-ID: <Zl6yQYZe2ifxUY4a@Asurada-Nvidia>
References: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
 <13-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <13-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37E:EE_|CH3PR12MB9252:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dbe21e9-4429-4fb1-713a-08dc845e835b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|7416005|376005|36860700004|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?d6shlFwYOaEDsIFlurkXArSsWEh5N7aLxTJusz3cJAj8kYbDT1dbDiSoi8dC?=
 =?us-ascii?Q?NkMBsLR7yep+jLswo7fssemtWPAyaG5aNwu7KWhPOKZcoIww5yXRTbKI808G?=
 =?us-ascii?Q?4IFQPY9unnBEfhZg6AJrIUnCgKu/L8nMb1g2hQAO3v9kDAMvY/KFUshDbMf6?=
 =?us-ascii?Q?U7Gnn489sAuntYym1i5d4nWJoTCxXLryCMk9ePJCYYyDeiGLqncPLpZQP8lq?=
 =?us-ascii?Q?B6IJke6Fg8h6t1zJfDjtB400mgEwKAlh5mhGv6lJ1QviorYqSpzknKULnWwC?=
 =?us-ascii?Q?D80XF93yz7lJZHTuBvUfG/baKeb9ClQfWpo/PGTNlKAY75WjjXmS52dV2nRp?=
 =?us-ascii?Q?D4eRXXaj4r35+H4lqQMTtakdmgRZMemTicYmXaX0YQXchaNOBbvApvap+L1E?=
 =?us-ascii?Q?soFMw3tNslCKvjrwuIaaBB40ab65vIfc35G5UKAiEEtqN8dclYKZLEtEMl8C?=
 =?us-ascii?Q?2z45sYWKEyWZlNlJhK0IXZhz6n29OOW48+SFwhKKtje9Ic+66FJLK2C7T/B6?=
 =?us-ascii?Q?sfYh1AcOBGLtm+5L/tcMC5OeAcNGFOkme4AldPjVhq6GTVAm4vY9HwLm1rjg?=
 =?us-ascii?Q?v3qIAuHVQbwrd2L3yNlSw92IaUPWGMJO5CQYpz+jCoUc1h620unOkRj2H35A?=
 =?us-ascii?Q?zWh4FqW5y5iChjF8ldItu2tXU4jevxROhIizjv3sRomNLxEgYX7yDJKceDMs?=
 =?us-ascii?Q?zSWMc1ce+vqbBOXtgATSchkhRuk+TJL0eXpSR90sONk/QoFgET7wr+/OaePl?=
 =?us-ascii?Q?SGm0M5NYvQguoFfbacmLesCSJqti/IT7rAHSyHv8F659KfEf8rAc3K9VQjGs?=
 =?us-ascii?Q?KUhDvQRrpoSHAF1IhJROlRdtDHmyJI07hs6RrwcN1rlGuAD+S9TnB/8cQNnT?=
 =?us-ascii?Q?SNSNdanVnrXP5GOo6S2qTbcGMzthwjgGT3QdRSdvo3Fxs5OxxWMUXVQL31A0?=
 =?us-ascii?Q?PqYKh0FvCG1QesaIgeOvZlAehhQX5nvlF3YfEzO44oJHCRzpY6irE+B/+UCr?=
 =?us-ascii?Q?2cahMka829CFk6+3WC+uHrKJ7+CWY8JHAjQPM4czI21ent9+Wi6JxtuTRiQ0?=
 =?us-ascii?Q?Xvzk5ckVgliggPoyIuWBYsjXy+nzmtsxZBDBZAduS55EM/jIXxzx4FpSqM2L?=
 =?us-ascii?Q?qKUebJBBC5+O1VynsrU5ojPs+rNlG3Ok7ZZID6n8UcnNizLwJwBIlynF2pXe?=
 =?us-ascii?Q?0e0LJHcihNECanEN1UhyVREIE9AbzArLN7b7DtmN9S7s000a7Z6IL4BL/+ba?=
 =?us-ascii?Q?DIvEdsfh0TWCir2epm/WlA5hBo9XF+9dfhrHx02/3l+681RkoBc6Cu504i7H?=
 =?us-ascii?Q?zgogh5OIEip/o3CI9Mhm7RszilWTSZfoX26JIVeP22dWLbn0YoWJJSndzRDU?=
 =?us-ascii?Q?NwS83mEpQh3GrpeC297I2f7CEEdo?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(376005)(36860700004)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 06:21:04.3336
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dbe21e9-4429-4fb1-713a-08dc845e835b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9252

On Mon, Jun 03, 2024 at 09:15:58PM -0300, Jason Gunthorpe wrote:
> If the STE doesn't point to the CD table we can upgrade it by
> reprogramming the STE with the appropriate S1DSS. We may also need to turn
> on ATS at the same time.
> 
> Keep track if the installed STE is pointing at the cd_table and the ATS
> state to trigger this path.
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
 
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
