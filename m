Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E36B12E1CC;
	Wed, 27 Mar 2024 13:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711546906; cv=fail; b=sL1wYV1zCtmf3HkSDKDJEo4a2Y1L73i8EI9H3jaaf4Ev9DD326gWx36PllclV5kFf4BQxBjvPGrniI3Krpl0Nwsw2iipcl80zHp79ExGwMhdEw6zUgM5XEWa4Di9eCgE8nUBQBdX7oz+nTVUXxX8tkWyiOMaseJvh1q0JjJwvGA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711546906; c=relaxed/simple;
	bh=OFAUgp6jkgTEluEi/N4n/mE+3ES/nPqSNiCKt7HYHRY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Dm7hz65qHMsjzcbZM4zrOhVFIqzGshwy1Fvupimvh6Jp2esiUYkPC4Ox/fBwHsV3feMeQ876kjyT1JQTQLd/PWW3KhdNYXSBphP1d+a/m1g+d8SEpuhWitYLOyLMqKsxW2dB0+SfUIoX2srdA4ZnyWXXteidBcQg5AafG2jj0V0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KWUvcu2W; arc=fail smtp.client-ip=40.107.244.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KWUvcu2W"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EFi5ozbPLEazWBo4/ZZdAgKIfBPoO+W3GBazfP58O3l3zlO20QOAsCl2gzGiQTmg5ilSk1y3kEgJUPyG7kyahMh9MPPwMhVF9yzJzhhMvAqV7qBkhqGhCGZ3FIgunXXtaqDjFeGKZRhWem6x+gELiuVmbAPq7mIPUhN63MjMFRDQaLTD12e1pV97yJFflImNJFSe/F1pjVCPINgryYs9Or+ZluE0VbrDpmXEJTkIp9VUcOhkTBIbOuc/iS+gfZVLSkpSDa//17aYQafS6YiVyA9JHx3N4/0KlIIK3KuRF+J3Mq/Lr/VpEtY6BX/FtEl1XZsQ9H/Rhk+0LFsP2xNUJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ipp+KOlI924KanOp3zW6UO+uY4bKPScC17T6D31cMcM=;
 b=l+1SGUMhhIdUXnBV9Jn4b/8x3QtVyXAXBp6AACOjgbx48EWzboE35tTIOw4z7luLe2PgsXUD/cTDll0J2NHiZ55ukMdrPL+Qysx4VCpy3n8OfnHTvq+5wREqfMTJ8U36gFIxB36iLC+U4QYfpP3YUivVI0zdRSBLMdVw75S9XpbdOR7D2CKdBe5DAesK+ISbLoB5mn/9Ei+aGem2N41ddOW2qHs6z5V+25hdYzGwcLMp3626+F/S/QT5c7yDfX6TcnHinzkzue8b+bbyr0ZeSiRDZygdsrMXvHfAOtXMYvW726CN9URsNu7Cu0h/rM6FZMW7+DvtmoZFeOLrvHsGRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ipp+KOlI924KanOp3zW6UO+uY4bKPScC17T6D31cMcM=;
 b=KWUvcu2W9YJSc9c4aCB7bGKFbNR/LXxK4zAaMntPFMEl6AY1uLbhPUcHEifv7oM348RK7rgbcykAyTYACfM3xGlxhHkf58vheDRK4ZNFISnbTHi5TFjkXQI82MolU56uarPiLSpEWHC0xifN7p2JxRKi1Mv8PcWuzHW+JkTw2e7vTJvdofDYl6AvwUrsXcwDU/DwbbOadHndTt8Ng2UdlWdH/9kGogvEzBLmnisyjJB4DL7VjMk41L+nYE92Cnecij54Kr2Q1fObLg8qLja6r3gbDSsM8stlvO1R84YVr1vD4tRnKqn7xZyvGfcnVZ7Lx7HblQRoSpHUlViauofKbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM4PR12MB9071.namprd12.prod.outlook.com (2603:10b6:8:bd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 13:41:41 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 13:41:41 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tony Zhu <tony.zhu@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH rc] iommu: Validate the PASID in iommu_attach_device_pasid()
Date: Wed, 27 Mar 2024 10:41:39 -0300
Message-ID: <0-v1-460705442b30+659-iommu_check_pasid_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR18CA0029.namprd18.prod.outlook.com
 (2603:10b6:208:23c::34) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM4PR12MB9071:EE_
X-MS-Office365-Filtering-Correlation-Id: b11a1eb7-c62e-4e8a-5515-08dc4e63a22b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fdGyx+XAs3f8UgcvWxCJJom4kySiENtRLU07VyaWr+OuI5N/hj58XffkLhbTfVS3aJunYfXiV3P48xFvCQOHuv9lINeviWd3qbCmaOQhVEYGUhQsKEhte9NA9diWSgXh8VQZRmwGbGCL7+5jrLdiliqBrmwQLL/Z6MpkMymjufriG3khArsQIB1pdPClv2LAZrtSZRAMgJ/Xz23ebgu7YUe5CpPPcWfSeLA+Xpf8tC3KqqzCjhyo8fYIxmAu0WkNHu/h8WAFoubVRm2hPLAr2jyyyNm98qKvmz8eV9zguxHdH8B09te+qfi4ERLr+g68ft3FAjz3LmWv0USDm2XXrZuceM+ZJ1R425COLhnz82HpEClNtyjSxW/vo0SfRfy+9t5gdq/QALhAT2G4ndod9T5j6ltfHpBNpVblaWgbLzc5QdlTLYRWyB36j0d6nZvG4gSovCZa9ivWbTsNt8DT2L1UTLYvqdrQeOWOq/wWZyHksqZA7y6wc/Uf6M3GQnvMJCcFg8BoeOXXEfgw7zd3jTno2LqMUNpw11y9MHmfFhuFtuJVV/VGU55UvZeuIOws/d4IKunUKCVojgkHfvAXF/08Sp0FdTYeV3olNQVCJF1ISHS2FpH+vdOZ/E9zDTKbE0OfRGmuQqhyU/Tqq/sj1bQLGqE5qhIwNA4+7NC6CLQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/9DuKijro1rUNMLN0SMNj9UO3/zFYz0bQd8eSMtZj1NCo/d4pvyIIasKqNE9?=
 =?us-ascii?Q?j3s5oZelX9pkQOBWjE14nnOc0iNiy8LGQkH6p7c328+ofkJDYoVjOIScOKmA?=
 =?us-ascii?Q?5hDEKrlior+4stmhEctxcsNg3/+rsGCcY8ylNLD/xw6gyl3SyHRLJgOPEBtr?=
 =?us-ascii?Q?p6ELnbSOd7F3iZSnJN5f4SY4XUYr1dyqJss1K1PRpFqoaNKDSzgsxQIgJYKQ?=
 =?us-ascii?Q?ZFfR+HGwXgqd21ULRntX4oIrs85k9ufc/Jl+pANOYgGcxPRnt/PSi8/8E+oT?=
 =?us-ascii?Q?MRSMWOXkeg9pg+eaRv+ailD7GlEA+7xhB9zsuzkyhUDoiTOsyQCHGjam+olo?=
 =?us-ascii?Q?Fiu4UnWCPNviIKceARElZnqCVQ9503Agk4sNSiycHppHf1rU9JhhCm1ahSi8?=
 =?us-ascii?Q?9klUVmroluLkK9AU2REly5yfroIpqaZkNFP1XzqEL0jFdmi6sH5mrIw0ygxa?=
 =?us-ascii?Q?a5v1q4PSX1dRuPOv1bkxy7W8NtOWtl5Sfcfz5YksSiMvBTXyuTH8cEoE2wEt?=
 =?us-ascii?Q?n1X9IPtJshzk6PxwjboMcIRve9Fwhc32zmOcn7N69tZWMhlznmNNOocQ5VVB?=
 =?us-ascii?Q?z92zD4DQZEhd0GSSgVx4uGN/6n+o86HYzWS8L0CpMpmzER7GC5AS4HsEBi4j?=
 =?us-ascii?Q?GkvUZl5jYnPTu4L1qJrwNyYi+G44sX3GpYcb3w/qONe56fulkfYrW8vIKahZ?=
 =?us-ascii?Q?1y2kPTXIPQM3BWcjD3dRyR9bIk0NCnr76lStiKM+4sfrDO3FBfEAEzK6jIjn?=
 =?us-ascii?Q?tnVMDnTGz3xtG6qm0nQcnpHgDKHXOhhUTWHZmYJBXiWI3qlRnT40j2hFERar?=
 =?us-ascii?Q?x1EgApAMCkWmYowQFxV7zsbcjMaIV8U20YK5UDCdm1vVAYTmJogxMMywYxiu?=
 =?us-ascii?Q?rV8FjRdsz7CKC/5mHeXT1REhp1FKgFF1C46yX3qtHdpBLDKIokHp/27+DwDl?=
 =?us-ascii?Q?OaILuaIZiRE39e0+cbU9t4H1ROvPXKYtJzbR2YbaqcHUXn3xI1XRRqeMQcDk?=
 =?us-ascii?Q?Mvu5j9Urv03+FtCqQcYjPBQnwKgYyamQfVEAWU30iZAXn/GGuHySyQLWQ9oX?=
 =?us-ascii?Q?fXI3LlQdT/lEvw2p7g+uhm82O7X6ja5OM6AnS8s+hTELmK0s49UbKVLZ8lI8?=
 =?us-ascii?Q?F234HudzMkIS+5c9P1W23R7HNgus+OcOkzF/UOAmfqsPI5SG24cnfv6cYQVY?=
 =?us-ascii?Q?S6mE53B8vihOAUl4byP8ww6B+VoKIgdf/Xk+35XbxuJObFxYgUhTcQyXvIoG?=
 =?us-ascii?Q?DJPCM7ZN1+eDU9GIM4cvH70xQBhVeqhhoWJVxf0tqn4HIg+TUlVLhT/U5Uj+?=
 =?us-ascii?Q?YSCzHecUx9JAFWS0qzcghDxRCU3z8l+Yb3UhjgwdI2V6we2U5wQ7hV74npvY?=
 =?us-ascii?Q?2BdkDxk9QCMGvOzFF7p26/OiNFUi9WGOhLcKZY5WdA/14wDExhMgzwT56e1+?=
 =?us-ascii?Q?hPZPfjg94DWLsNSKp3ify3Y5WWoABct6Ie63ErJ2Mq1r1gKEBpIannRRIcjo?=
 =?us-ascii?Q?MPaf5qMlFHzrqUeNm+fUTvbflmL+29GGPQNL+kUHXtqCD5SnwJ8fpqV2kVYc?=
 =?us-ascii?Q?GM3cxRUdezaCzsadbQMlult/lDdfgl1+rHYcareH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b11a1eb7-c62e-4e8a-5515-08dc4e63a22b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 13:41:41.0212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +4InqUhNncWCV8DbJnMQXJctBLpnhHOeO6FPJFlLQjvmoyKPSOVB7+ZoTECj7hwV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB9071

The SVA code checks that the PASID is valid for the device when assigning
the PASID to the MM, but the normal PAGING related path does not check it.

Devices that don't support PASID or PASID values too large for the device
should not invoke the driver callback. The drivers should rely on the
core code for this enforcement.

Fixes: 16603704559c7a68 ("iommu: Add attach/detach_dev_pasid iommu interfaces")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 098869007c69e5..a95a483def2d2a 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3354,6 +3354,7 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 {
 	/* Caller must be a probed driver on dev */
 	struct iommu_group *group = dev->iommu_group;
+	struct group_device *device;
 	void *curr;
 	int ret;
 
@@ -3363,10 +3364,18 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
 	if (!group)
 		return -ENODEV;
 
-	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner)
+	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner ||
+	    pasid == IOMMU_NO_PASID)
 		return -EINVAL;
 
 	mutex_lock(&group->mutex);
+	for_each_group_device(group, device) {
+		if (pasid >= device->dev->iommu->max_pasids) {
+			ret = -EINVAL;
+			goto out_unlock;
+		}
+	}
+
 	curr = xa_cmpxchg(&group->pasid_array, pasid, NULL, domain, GFP_KERNEL);
 	if (curr) {
 		ret = xa_err(curr) ? : -EBUSY;

base-commit: 4cece764965020c22cff7665b18a012006359095
-- 
2.43.2

