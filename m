Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012053.outbound.protection.outlook.com [52.101.53.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E953D45E5;
	Tue, 12 May 2026 16:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778604395; cv=fail; b=pJ6ysmSNa/zxpddct4m5GsmuTtk7966e7hTkMMwc6iAQQQX5HbKYNeUppPAkbX+ffGGHVQcDsb4XQ3T/yAqfZwjPdEe0KC8DjXYSU5piAe10nvdJs7S5CmP0lksh7E8ejL3tPmnNJFtSeDtLgDT5Eg9ukHOBybezk6s1IFrV3rs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778604395; c=relaxed/simple;
	bh=afuippdsrW0WEFt8J1P4gfVMU5f1uS/IsjzFGmPpYVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fnsHXYyn0RkMYUhIPyWyTi6NhMiP753zJBOwTAIHxmMpqjP48vm3gNNk2rOaly6Ta0UKIy/NPa/ZVgPBZ1W3hXSEil7r4enME+iHyHgMveRgE/Qrso3MmETeuWPQvXSaw1kx5AS5FFeAe/C0ifz76LzlUudziMy9MWHMbE0A5/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=o/yGH5bd; arc=fail smtp.client-ip=52.101.53.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="o/yGH5bd"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vQHBKGnfnF5v5PcLelH3+rwVhM6DLidazDvATaFrECEl4hBy5VFZqSJM0+7FrXREjqtGMGUAjRgxSVgTr4buSFjt71LPbcLG+JBS6v817uUgJPJw6CdLQlbZOUQ+R7g9oIlHhIvGmKH8mjvjp1iVMtAPBFNYMnWUDWULXgJrkpp4+jMKyAHVIjQASvGKD4MmwyjVbPUmMn6+FYd7hKXfKx/ddIgCMdbDj3R9O6CRsylgDiNq6gzs0fSd4kwJB9GpJT07qS1SnM/3sg3ngBQ4RoBy4Z7Ra7q3UzpmfU83SpD5dL33VYQEbU71l6xmTtBhgxGEaZ3OH3I7v1TYskcnRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LBaAijGQOb0cLQkwyKjWq5v9otnEif0yXoNbJK8vSqA=;
 b=ozhvuTbpXNNyIGfMrASsgOtbGVNEQo3IYU77R9UH1zGr06cAvVjYGrxoHLMZBvKpubjTbA5RQvE9o44Ijf+4wL+JfYCYIwOMu/P/e2e6GzhlBy73WuUkfmW8RM3w+94eyMXhicaEnS56BGDcz3/mECGq9sCXQxSn4kPw7ldkDKhHfQH5CWiUH6IeGmq8xhZWI1cr6F/0qO3ccBTITZavbwadfHLMp3m2i4WoC6Rc3WpdvVAA4YfBDHdtS2OYb/rohKKVeNWPzWFyKrZoBkDDSw5o4+RO/Jb6QrMRNmJkG1OnNfsdwEl9JntVb+PiZXEgdXUBFfINJRf49kpJhFE/PQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LBaAijGQOb0cLQkwyKjWq5v9otnEif0yXoNbJK8vSqA=;
 b=o/yGH5bdSH0UnZ6kv9BR40nFdqdpaeKBUFaii4C3Yy67yz54gygy7RuctCWxp2C1uBoBg9piXyoAfpp2t3AtgqtvwsUHSULdmMnsnzS/RfBVta2KchIX1u6o91XQB+GdNA6ldftzRsiyXPzyGw86hfWcbGd6ShXYIshCIJqoiIiQbOxUByfuwHk/J9Z8gQ77+yqMGGw/iOs/r7VyQYXfQEzxsg+mdmHJJ0DfZ+PXs6v5vGyfZ8oGBfwBxOj52vharV+SeScxK0VpqCD8Fn7WEFSxsthv4oJDiJ+z4y3Nu191mbobNSxLvaCzfExsH7UKPOyHhO8lOmYKEbkokSJJWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by PH7PR12MB9173.namprd12.prod.outlook.com (2603:10b6:510:2ee::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Tue, 12 May
 2026 16:46:23 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%5]) with mapi id 15.20.9913.009; Tue, 12 May 2026
 16:46:23 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Josua Mayer <josua@solid-run.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	stable@vger.kernel.org
Subject: [PATCH rc 1/5] iommu: Fix loss of errno on map failure for classic ops
Date: Tue, 12 May 2026 13:46:13 -0300
Message-ID: <1-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
In-Reply-To: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR22CA0028.namprd22.prod.outlook.com
 (2603:10b6:208:238::33) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|PH7PR12MB9173:EE_
X-MS-Office365-Filtering-Correlation-Id: 16a7db8f-a068-4d3a-1785-08deb045fec9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099003|22082099003|18002099003|11063799003;
X-Microsoft-Antispam-Message-Info:
	WOWPMX1GwweRc6rPcUfXSiCEMDlT8f7TRYNJXQh6RovW7NktkcZdZ/Ml2O8zteMEuO6eZU0Fh0osTqKCRZZc2RXzHvTDtt9rYBfmJRN5lwdu6Q8I9VoLuiBkRObkOaRcl1zj5swe7r26BmVuHmFETghf+4amzNhDcygJUNb13pZnEuYdurM73LMKVv2wDCCOyN7v91bOJNLraZ18zYspXKxcUVHf/VNIWgCIzDOZrvTzgoQGS7ZrWEg1ORuCzqqcm7RY10o/A59tY4oqUrBUoRsFvDaA/g1Hz8F6orzyRKwqAUj6hq9i5L8OqpoP494yS0oqUFft7oyOxAo9Vp+muFFIO0pHe0ZhESfY8rX+AXKW2u76f5c+qJNYDask+m0t4wxPFlVM8/XI5U4RO8EuS528uo+AtgUZtmjbnOmuPi3JMedmRw70BEQoclyuKqHQQqNlmD2YCd4LFfTMx+kQ8yZstTYQtfyEv1WusfOSRIov9Rg3bHF71DeTbbLB9YgeijH/CxcmB3I1U+JDVzYJJR56ZDzbvk1FF8gpHKDqdMOmHcQokZT7u4ykE1cAAdYCdi27kgDTpCgU8PlwH9WVPoFRo81eRJLCaAhYnS5hnVTBvwxJo4SfkLqlpw4qo+8m+4cOdwlAJYXcRAnf3rTU8/y+5oYqZZUWRKOVHaXeMjlxwrpDEykQdZEjXr+ZwoBNT3qP313hPHOeCowbZ8vVIg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099003)(22082099003)(18002099003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nicAy+yQB1h71+IM36/RQtdlHPDdFEQHXCe4XhTUU0Xhk+2vesOhHd1hFX9W?=
 =?us-ascii?Q?JDaaOGfIhGHE4I9Iz6+BkEd+7InSbLwgamgZuYDqiRWJZ2AUV4DdppokukWT?=
 =?us-ascii?Q?RtB+0Glo9XNKVjU7SI7/1SyvXF1yDeYD7NYb39RRpkTaLcaKFOnliauLoE8t?=
 =?us-ascii?Q?yMyhsiR/YwC/qicpyRODghSHNW3yRsU+2W021QED5D+/hJuvxAj8dJBQc/3A?=
 =?us-ascii?Q?QWyU8eUfiKJHCP6XayDrchyg7J7I+/LmTOTGnJExJ4TjEPfOJdiy2cr9tbnw?=
 =?us-ascii?Q?2nQPEoQoYwVsUdTo2v12CpOFLbK8tX8hZxP+puvBGG/ajtDAsC0OdmaHjvZc?=
 =?us-ascii?Q?+xL/f8QP9JL0wN85PlW5eE/3BkVMRYmrqYkZcmDEKgnEK8sKgDF9fqAif4zy?=
 =?us-ascii?Q?zaowIdskOTQmCpExPoMas3PdS+8oPgS1j810j/6QjQWto8LBqsylmxkkvLid?=
 =?us-ascii?Q?9Y/VX5nUqi7r1Vm+NXy/bntHucaXAatnN2Zsae80+Kgb1NoBTnwX8w2XpeU3?=
 =?us-ascii?Q?2a4yt86Oht2sXx4ysmJfiQ7UOMP4a9H3iLU0cV547TqU/bU2z5fyTeZ7pZML?=
 =?us-ascii?Q?m/PRas8uCck49aWI3G7v/yYpMBHwWCqOJq5mIjsBCnMQs3OWqDgWna6WeiUZ?=
 =?us-ascii?Q?IbghoUbx5glhfhgD5eNHyPYNc1v7Z//l/f6pKhXynFOMliL6AIj0ZvLV4VpQ?=
 =?us-ascii?Q?WaSEig6oSM3tIc7wBUIzgCpe4A4YnACEBAk6l69Eei4dSe/3+x19hG9nce2s?=
 =?us-ascii?Q?T+oaEZ9kNJc5HdTY6QF9Fwzhkm0EOvRPC8hEZ+P0mIAY400bfzE/nmZ8X57Z?=
 =?us-ascii?Q?Z0bEsqNzJ5g09586oH3PCXizLMMgzLhMLwheZpwfvYA5SZZWJb7gQFC9cPZw?=
 =?us-ascii?Q?LQr/nl7Jx0R/5qeYg9tv0Bm5kAqWHgQZoEztUfaFKa0bB4e00pUxWvrztWc3?=
 =?us-ascii?Q?xDV6KtPoL12gi72Pqus2r11N0lhFQugdUcu/ptjQo1xPeirO3Qe/yUQfLFYX?=
 =?us-ascii?Q?eVWCmU+PPqHjNqOA6oZz68snewjOA4jFHPAo2U45ttv8wAdhKem+eEjhImgc?=
 =?us-ascii?Q?NiJP5uQClIyUKRVNGDyBKfkXVV00z7/v7SuKry2/giWsEdJ67bJq7tm417oX?=
 =?us-ascii?Q?bjfb1KnGk7etIBEgVjNiYUQCGCP2mH85MjP7sUwiT8RczUGMH2AYsoVhWt7y?=
 =?us-ascii?Q?ENwrOkEQdQ5p36i2ZLvQkboHXu0MxKYH4Ntq0pLqnZHCBI7zyLH0cFynII5n?=
 =?us-ascii?Q?3x/Vlxqx+tLh0YtJ5jiyTYHsGbbJOoHUhnu5Z7rqrfkdWOpijYfITDbcQBqw?=
 =?us-ascii?Q?F2AEyZZjFhVD18zbIfM25LXLA0mMTEq4QISc4zOcpereUNdLDR40s2E6KnA8?=
 =?us-ascii?Q?OER2BpX0rVbGkfYm+m3SDdLr63HZVXPDSjtCONejy5KVAm/HGjXAW5XmEngr?=
 =?us-ascii?Q?kW7XBd3quyBoSxUKtIGP/lo5MMiVO2Amnobc1+YtGfCSZ5gmGiB0/SLKOa7J?=
 =?us-ascii?Q?AeTmFoCj2C8+LMzlF1WbnLo/Rt+3KGrBWnIDo24ieX/nAM2GL/f51RuTZsKw?=
 =?us-ascii?Q?jlMJWtuuA1s4/cU5yQALYa6FdgOkuDUdUnZdhmwTBr8t7nvL5QN396wQE44v?=
 =?us-ascii?Q?8lHFfLyGEeVrsN9gnFZkljos+T4Rrjk1kuaZXwnUaaTCx41QyeJZT430M8fy?=
 =?us-ascii?Q?kMdWWrvDBFI4qVXPy5RdqrarJmvOi5+TSte/5YhXbFwtgO6X?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16a7db8f-a068-4d3a-1785-08deb045fec9
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2026 16:46:20.8754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gMkccZ2Im24FWVmRrV2E0LHvznhJ/AMmShaDN0CE4HFc3HyYYcB2kZ+LntO3BwC4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9173

A typo, likely from a rebase, inverted the condition and caused
errors to be lost. Fix it to be "if (ret)".

This was breaking iommu_create_device_direct_mappings() on drivers
that don't use iommupt and don't fully set up their domain in
alloc_pages() (i.e., SMMUv2). In this case the first call of
iommu_create_device_direct_mappings() should fail due to the
incompletely initialized domain. Since it wrongly returns success,
the second call to iommu_create_device_direct_mappings() doesn't
happen and IOMMU_RESV_DIRECT is never set up.

Cc: stable@vger.kernel.org
Fixes: d6c65b0fd621 ("iommupt: Avoid rewalking during map")
Reported-by: Josua Mayer <josua@solid-run.com>
Closes: https://lore.kernel.org/all/321c2e57-6a17-4aef-ba42-d2ebd577e472@solid-run.com/
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 61c12ba782066a..6e53cfad5dc001 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2669,7 +2669,7 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
 		return 0;
 	}
 	ret = __iommu_map_domain_pgtbl(domain, iova, paddr, size, prot, gfp);
-	if (!ret)
+	if (ret)
 		return ret;
 
 	trace_map(iova, paddr, size);
-- 
2.43.0

