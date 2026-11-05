Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.38
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793837036;
	b=U8BYzTNFc0P3k8r+z+a6kaKVlLZvAhIq0cULOg9cdep7pzKM1S2pmTVRFAg2Y02eqUk2
	 9VFw5xwS4CDL766xBR2yiP6kx1Hd7pQXE2Hjjsm/GgiHwOBiuaCfJER7nTpz5cgKiXufk
	 3OI3JIit+Ka3W3Rc79EDy+K+NLFAaVdMCAu9umaXMSWTUDKt0jWPZWhIrSu8CmWRdWrHe
	 5hiJXQ6bOcWi+ZjXXyArvq9UHw8kBguy4fXnceYwzOl5jRodfpNkjO9C+NNqRvH9LUNV9
	 hSxH7ZQLEjP3OjTkTkOAfsuy2rmHzE/0mEX+eFukxwUOjeIcj16xsU3yO73eEGIUKNw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793837036;
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
	bh=8/AzQ7jLvCG0TtYl3YDqzcWQaO8w7BzjtKTotUtwsR4=;
	b=eMBPP7d0Th5Uy7qQyia9FhPG+jLbg9+0YRw1wxvZFTjry5VO3BX3izkx0iIgYIwMLLhj
	 i5IwTl/q5ubMhEN0i1msy2pWbTZkjyuKCyGfnSYYuIhCOb1ZeIX3yhzuliY+DFPamgw6u
	 IsKDc64uoAsgoo6l9CBH6sjd5Awx6xUQvNW2m1yiV7HrVYXSM7FTq9SIag855oliJYlDo
	 6l0UN91dzL1201ejNCFN1iySmG9gLjQntMCasyoLlP/DGL6GZttLqoXCesm10ANAEqhXd
	 mS7CNjR1/RK/CgK+SWuYRRzxnEm2K7IwF8p/xXyuoL4NNI4mCUd11MCWDVSJQUSEnMw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=q1xUVWqz;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.85.38
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010038.outbound.protection.outlook.com [52.101.85.38])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FF6606A326;
	Thu,  5 Nov 2026 00:03:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32FF6606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=q1xUVWqz
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iv+ZgVLG0Zaaq86NimJWAYfy+KsDmO+5WZMSKVY+EqCYo3I9rDvENIsWpS/HmngvmQdvKjIUvyD8OPCjWWDNwxCGmAp5jCiReGFmu1XG5iQR+CmNDQnbEbD0AZNFqTUuCbRdhEiuoypUxCxcqXUncogPWSItwLssf5e1KJwWmgS4z8020sVIDFUmY3x54Q+3I/LeZ8gLYUV6s99Q+SKWsSuLQ7ln4BoBpqGcBixE5dwHsvQIfrUjw2wlsjTU/ETCYVK1Akr9LBZnFUr8wLPdXPvTxixVDXhUBB3eypXw9/Nr/gEXasQeWmAssOZ6QnnUoZM49jAXnUJec+cfT9uIaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8/AzQ7jLvCG0TtYl3YDqzcWQaO8w7BzjtKTotUtwsR4=;
 b=Md60K8kneXlG3v6HS11VslDC4RHXmJiRut9IPd0GvMDPoSC3ua8GYjVxS5SLkQp2mJZ6xPmdufaf38caIUGHvhAY79HZC69Tzky4X3tD7/3i+qTWd7uT0h4DwkdW6+Q1RaeV6CJGpOApJ/0A50RemA4NHss+bvt1ocIyykOeArOVwiitY6CW8pQKBpkMGVFumQoiZI+ysXp5tL8eKIViH8M7O2aV7c7ju2JgoCPVNVRNUrVQGHdMo1oSYclfxfbuCpgZy3FmlmMjovGW2fmGfqznqoiDKj2KGpS02a2qi4YbkGxqpTDZL67DLvUwYpPRY2pyuhgg3A+u6AuE9njDcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/AzQ7jLvCG0TtYl3YDqzcWQaO8w7BzjtKTotUtwsR4=;
 b=q1xUVWqz8XzOcUsoDRGtlyXcDixF0xwbCeiCjOpIAqUoGxfE25mIhTijX9x5u162w0EE1pZAMVcvcqYPbpYBJZ6qwLURQnsiGLIzoLswLS3Nm/VTtw+8R75ABXkGW64s/clI5hSroZznlZOzh99WiP5PuSJvVbQPiE1aq/o4UZzP6DL+EsKpTiGyxTh0z6KisvybA6TaR4XachrnqCg43LUcrXF9WWnvixMCIS+haU/cis4asS3LByjdtXJ/tKi2PxlFvFMmuNbMG6Io/JwS8oTzZkU2/AxOJcvFOChRsAvNQd/T/Xi+/PMuVAsDcDZGuqv53L4h0pE76amkh9XDaA==
Received: from BN9P220CA0010.NAMP220.PROD.OUTLOOK.COM (2603:10b6:408:13e::15)
 by PH7PR12MB6564.namprd12.prod.outlook.com (2603:10b6:510:210::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Thu, 5 Nov 2026
 00:03:51 +0000
Received: from MN7PEPF0000014B.namprd04.prod.outlook.com
 (2603:10b6:408:13e:cafe::41) by BN9P220CA0010.outlook.office365.com
 (2603:10b6:408:13e::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.592.10 via Frontend Transport; Thu, 5
 Nov 2026 00:03:51 +0000
X-MS-Exchange-Authentication-Results: mx.microsoft.com 1; spf=pass (sender IP
 is 216.228.118.232) smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 MN7PEPF0000014B.mail.protection.outlook.com (10.167.254.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.592.5 via Frontend Transport; Thu, 5 Nov 2026 00:03:51 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Wed, 4 Nov
 2026 16:03:29 -0800
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 4 Nov 2026 16:03:28 -0800
Received: from nvidia.com (10.127.8.9) by mail.nvidia.com (10.126.190.182)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Wed, 4 Nov 2026 16:03:25 -0800
Date: Wed, 4 Nov 2026 16:03:22 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Bjorn Helgaas <helgaas@kernel.org>
CC: <joro@8bytes.org>, <will@kernel.org>, <robin.murphy@arm.com>, "Rafael J.
 Wysocki" <rafael@kernel.org>, <lenb@kernel.org>, <bhelgaas@google.com>,
	<alex@shazbot.org>, <jgg@nvidia.com>, <kevin.tian@intel.com>,
	<baolu.lu@linux.intel.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-pci@vger.kernel.org>,
	<kvm@vger.kernel.org>, <patches@lists.linux.dev>, <pjaroszynski@nvidia.com>,
	<vsethi@nvidia.com>, <etzhao1900@gmail.com>, Danny Gonzalez
	<digonzal@google.com>
Subject: Re: [PATCH v8 5/5] PCI: Suspend iommu function prior to resetting a
 device
Message-ID: <auvHyrZmMXLTFyz9@nvidia.com>
References: <348c50ab6e95b5ec6d48ee3fa05d529a784a34c3.1765834788.git.nicolinc@nvidia.com>
 <20261104235238.GA1469671@bhelgaas>
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
In-Reply-To: <20261104235238.GA1469671@bhelgaas>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN7PEPF0000014B:EE_|PH7PR12MB6564:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ce00e31-9d67-4c2f-b498-08df3ad04603
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|36860700016|82310400026|261009223027099003|261102123227099003|261021121427099003|260925021311599003|260925022911599003|260925021911599003|11063799006|4143699003|56012099006|261022075727099003|261022105027099003|261021135927099003|261028144727099003|261026121527099003|261026140227099003|10067099003|22082099003|18002099003|6133799003|13003099007;
X-Microsoft-Antispam-Message-Info:
	9BSttmEu0XCyNYiNg69zNKf5977Uuz0j7xw9uIoJtszIl91jcZ6FsskxBND7mVldJEd61OUGnXZuTImT0jDbUT6nJ+yt4Vlcm6Cq7GE5jPtv3TDw0kK9JzJGHGu2xe363zhJDDH9Dw+IjIfxE4vA1aB73UmvZQTuDlnhDKcS6t2+CYz6qJe/QU4hWKY6FjkSx+jkMmCwyHlIgdlexk+KFEBnSY9whRvvDrWKzG5MfzEWlTppW8p+NhkHls++9lAt4J0bigFndM0igkwBDIWDKS7SZqXmQMfX0Ql4KDMvyAP9ctMElpjdl9cxDjG8g3mIqHlNICu++1UV/sWMsddDvFrAAHaNxGTfyeYhxPcI5MYovhoxZvXSx6PRkBv69KOWkJJJeDhOAZXF0qMofhqCCo/B1j+A2GvBJB16Ua5G1imdYEQMfb3O8726JIteUnymH9PHnLWj9/q9nwnQ4t+EeXisWOc9NxAPAT9pqnSWJLaZkMQRhGPkuAa5+E+1nWQhjT2cPXDe4Fm7UwgY5Zouy6Z8fTGB/1uc7Qjt4v0upaEQixv3KBwprtxZyV4RuPMvS0fFIojq1m9pP/lOVtxo2OzVOn46pt6pydSRKzJ0LRDAccZMHOmsafJbNzDyKVtwStFpRq20HSNJx7xPr62R1iAQO8OsiqoVzCEsT07L5bPaw7P83I5quAPuLIPlVaFX75pLuuVKUL97zdwEZWL/iQ==
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(36860700016)(82310400026)(261009223027099003)(261102123227099003)(261021121427099003)(260925021311599003)(260925022911599003)(260925021911599003)(11063799006)(4143699003)(56012099006)(261022075727099003)(261022105027099003)(261021135927099003)(261028144727099003)(261026121527099003)(261026140227099003)(10067099003)(22082099003)(18002099003)(6133799003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	onOSDIoz9ot3L8ycWqNl8QETnGGhhdQlUBpEMJGvv2/3OaE3dUxZewawv3+T79EtpFHs/qJg2WnNRIyUowPE7qu7AJyai0M/QDdc7alF+qQM2Qq6dhSpTyBJ94y2p8AOChET9E85qiUSwmd8Er2JPGhguLYhBAylqW2v6z4Yxt84pkBYxEKEx30GZliX3xIMIyIaK/d4HOagH3cNNzeE5/083hq8MPc/XBy9goJFD6JFWYL3PCtpYUYLD/ncN57sMvMvajBSh49k0nY0uMkZtxJDr5cWEiuluSSY6ZWrOOAVpYsWdjKrHpLhmymmPLAOrhZSey9vJXda+FFEOd6iaTRXKjLNG+YaiXHqQfTQmn1nHG5c+Jxiq+GHOvav1uI4FRRF1yNNPGh/kSSPum1lDPL2/hywldY8apFE9OdIfSO0WdO1gD4O24t5jch0wvw4
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2026 00:03:51.0294
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ce00e31-9d67-4c2f-b498-08df3ad04603
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN7PEPF0000014B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6564

On Wed, Nov 04, 2026 at 05:55:00PM -0600, Bjorn Helgaas wrote:
> On Mon, Dec 15, 2025 at 01:42:20PM -0800, Nicolin Chen wrote:
> > @@ -4885,10 +4919,20 @@ static int pci_reset_bus_function(struct pci_dev *dev, bool probe)
> >  		return -ENOTTY;
> >  	}
> >  
> > +	rc = pci_dev_reset_iommu_prepare(dev);
> > +	if (rc) {
> > +		pci_err(dev, "failed to stop IOMMU for a PCI reset: %d\n", rc);
> > +		return rc;
> > +	}
> 
> Unlike the other reset functions, this one calls
> pci_dev_reset_iommu_prepare() even when probe==true, i.e., we don't
> want to actually perform the reset, we just want to know whether the
> reset method might work.
> 
> It's at least unnecessary to call pci_dev_reset_iommu_prepare() and
> pci_dev_reset_iommu_done() in that case, and maybe even problematic
> because the pci_init_reset_methods() probe happens from
> pci_init_capabilities(), which is pretty early during PCI enumeration
> of the device.
> 
> I know this has already been merged as f5b16b802174 ("PCI: Suspend
> iommu function prior to resetting a device"), and I'm not sure whether
> we should do anything about it.  I wonder if we should just skip the
> prepare/done when probe==true?

I've posted a fix for a few times actually. The latest one was
posted yesterday after a split:
https://lore.kernel.org/linux-iommu/c66d5221a8e4356316d4f614c8584a80dc9d71b6.1793729707.git.nicolinc@nvidia.com/

Please help review it (and the other PCI patch) as well.

Thanks
Nicolin
