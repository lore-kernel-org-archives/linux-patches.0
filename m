Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012025.outbound.protection.outlook.com [52.101.53.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95DEE1A680A;
	Mon,  2 Mar 2026 22:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772490184; cv=fail; b=pMfp+0xprz6a49614bNF4wOd434lVSEDulw1ynuCN+B8+Yo3RtXPlu7SEyqewKlHsUOzYcjZdPJDLXz8QzE+GZNevUdm3yr58CEnYf3zY6EgslX6lJzJqDxzEcRb6PDjZWqm9UYNSrt28f/UESXnE1x54xAItI+IOsLUl19oP/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772490184; c=relaxed/simple;
	bh=P5zi4r3RlBngz3v8Y8ERTevT9kIE4PH1plWXBUCRBLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kabOHcIJ1DBKHJHdVR8B5q90w/W/PHTE58+OHn61xPuiByYW+Qqd0vqisJkoMmHyYrUJdLWV772un0C0LLo9yhk0qL5GWqeTaHNRA7HqGNjRkIo9cdMdp2/1z5VORfEWpXTXA/jhVJ90eyw1aieCmDRzD9qB1xBxhXkUp78ELjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cWfQn2xt; arc=fail smtp.client-ip=52.101.53.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cWfQn2xt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W/N0oqOgBY+9YFBTpkM/BhnkUwzkaTt3juvNQbAzcLC2yHabqLxeCUFb2iPpjes5N9UEMPrTchl1x5RnACJTkdfTCeeUXuhKgON3WadWxIPZ3DXzW1ZzTx0MFdhavOSV8ItCx+BpSynUH7GYTocfH9biVayD7RUX4hl21TIpmYjJKRF0KkRS5j8npXE8HNvnDzwE1h7hWMUKzdFyxOPHyCigrWyOZ2U8qCjAnZxJBBOZgZacegIl5MhIwSWZC8659McwdE/HqzyiYN6mJ1IMIy9abGbRTzn6eYQdHpsMrr9QVdg/BkQY6ypOKtnhytIa/gnzJ1yaclK+lyOmiTgGHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XJkM0jhFO/R5tdrTkCNBYcXhSOhPb9kuwnN3udADqPk=;
 b=h2blaNUdzXmdt2ddIwwa8j3LBy15bxrHTluEurkxYouStW0gXqnlYi7TUdz78LxcuWAvVAArP/Htzd9934iaGV/cI56L4XdMM4ZfCH1J0Gd25/rl8n69gYkv7GkhJq4ypI76h+3a9LL/VTJ5dWWMAfCU5WiyjSlxcxtEbP8YGaVo2GbwiDkSe0aUQim2V5pYZbPI1gaIaGH0PaDI0F3y/koFDLzX4tfit6midFheTgN+GnxXe3+E9xGAsBQkX/Kc9so2YGHY7WOV/kUkaiK591mGUV7BIR4ySg6x6cI2bnJTNMBx5MtWzVKV5GeB/LkPqq8GP1NjQYUy2biW3/CGHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJkM0jhFO/R5tdrTkCNBYcXhSOhPb9kuwnN3udADqPk=;
 b=cWfQn2xtGWtp17WN5+pnoB9SawFYRG0XeApZ3CV+E8erlxWh4YLibeK+9C30eBVaRec+PSSB/ooluwwvzcWnQvaQbb+TWQzjw+uimhC6+FN2p0t+UJbrCQKILAfInQeBqEgu2vfQmDRcGihDTe0auxNsphUko8mfSANmox7zdWlD2L+5VMZOHk6hj/tSRfg2Q5ENAfWpwyiT6n/i0SSVw6YZbEUpyksR2vUZAzJe2iFc2xLhkCueJ4bV7/p5fKxTp4SEiEQ/0kY9rX35+Z70uWsSCKvdMBfi55h6O9SztnrIoFK0tcEKSXB7l/5JIZtL2Beb0WR2lWsiQeiV1/wgmQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by BL3PR12MB6473.namprd12.prod.outlook.com (2603:10b6:208:3b9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.18; Mon, 2 Mar
 2026 22:22:58 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9654.014; Mon, 2 Mar 2026
 22:22:55 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	stable@vger.kernel.org
Subject: [PATCH rc 2/2] iommupt: Fix short gather if the unmap goes into a large mapping
Date: Mon,  2 Mar 2026 18:22:53 -0400
Message-ID: <2-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>
In-Reply-To: <0-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0179.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::34) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|BL3PR12MB6473:EE_
X-MS-Office365-Filtering-Correlation-Id: aa5e3f64-88c0-448d-b81b-08de78aa3ff7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	p1PrjC68yz44x5a5juCeap0i9VALp651dytXBKnkbTRpnsSwizYPA9am0nUGDplvAe/iICJH2Zvrar6ehHC2DF74OsPxi3FK4vWyJ0GIEIH1EO8bKxX5cdaXEm8RcqmcS/zh7oI7ciMNGB9itF+jE3hNvihDcFSQYIZ0NMgtA1eHJe5OkpUo4U+Gi8BFNqdF3SIQUKDW/QSt/2uk9t4GP8plGeY/uU0arlUqI6nuYPJqiXTtWcEs6B/AiVKXUMG7xph9iKLMZXXf0+cDkslYQ52GegPfGe6yMJOvAZz9wZcUlPPkcuMyBXP4OwEuQIDhrA+VpJPTCFin557V1zJW+TETdzUgG7NULvXGoOiEQpJAPAIrDrNfbWB3Vd7u2Bz5SXyN/P2cFO7Drp5zzXPa4ovwNFAzKSSA9CNNbK5abF2qa4mBmdkKSgdSksZcwc8iaXf+eoWSaa04TR+5Fvqwh8AL8TsBjnBhqlEC3bTIVFajhAOuaaypFunOPR7FeYWnltlRKi6hcSIxkqdEclx7c78lSj87SK99MVlUJHROz848w2MiEhPJmyOxDVfKLsqR/3Je8gz38fQZvcmiDzZmod6/ZiL2hfuHRjC0s6yKcbNwEHlrDQKZnKcoTgkyvyfOW/gtfOHHbX5tneSf7soRTGHtg8lF1dSWIHX9ilm2ct4Ah8S7mJiFGHH8GI9zFvShulpquaK6J3cl+73JimAr/CC03XkXmqLH8m3P9KI89+w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I6ZzCbOZTyLhJKuG6pY11RgPxkBziqeKagX81hUpNaYwEMCa5HzHS3fStj0f?=
 =?us-ascii?Q?+8uKy+/O/2P05B4K3noWMarFTguRagnawCA7eJCldaYIbttlMLDgknau6Zaq?=
 =?us-ascii?Q?G/NrkoW6hrzGSqb0zE78JDttbchfBmKkBw4M/46i3qyVQ3nXaAeCZOxLEb2o?=
 =?us-ascii?Q?Mp09rofuWRgL2y9mTcfdqm02V+dAalqdx6IobErizViDwwkOsPp8VB3gjFJL?=
 =?us-ascii?Q?Q94dW/T6swU/fbXATPWLDFMsGHj1S5SGUrQBnhHQbgcnbLutNd9/UKdraC+N?=
 =?us-ascii?Q?YE4lqFALGz+j2LvI5Aoz8OTH3NulyKWecSsby4tcMOuBRQwCF3IiKx495/dj?=
 =?us-ascii?Q?Lb8MouBqIiBYxgY9kj66sq575GxT2nYEipAWGLQKFp5y3DoPQRvOjnHmz7TJ?=
 =?us-ascii?Q?7/NECNk7NGY/pK0EEpbj5ycdc0F2iCU6b1a5BR4TjLeeC7RD/PIvL6S5CwU6?=
 =?us-ascii?Q?WByyrWWG8oKFVxaRvxJ7pJ6hNUu5rmTH456fpKm0RWPWgGgGhCJZcQLrbbqJ?=
 =?us-ascii?Q?UTas7eQJ7z3NG36j3QswUaVYW9ZuM+H4y/rZkT3esk8Qo68w2fYUiGr6jECd?=
 =?us-ascii?Q?Haj2T2WWRlLscSV1WK1t44WgLGX3S5jZhH0+mocZfxPQjqqkV4qUJSBP7Cjs?=
 =?us-ascii?Q?XhRpzeWGDK2ERs30dGh/5kBwhkjJ4k3RSVq+yG8Vfg5L9Z9jtbtb6sgjmjoM?=
 =?us-ascii?Q?lZkHuWmsE9oO9xuoEnknn+n1itmHK4D2FXteZP83WpVgXRzqYBG0ygUcLLz7?=
 =?us-ascii?Q?yH7ikRXwYk2rfcMqxHOnROUskW8we4hKkWmrVtbP2b2eZ8nTENNO9Nvi8Eh1?=
 =?us-ascii?Q?hOASCsCVctkz1YupcAPuEEkHW7j7QAzintyIdiC9Z7lCWu+sPwfSkPxbqFvL?=
 =?us-ascii?Q?EGPzxCRcQ8/z7YoHkMAlMmWZ3uggFUsCM9BjJgmFvmi3vPzM7oXtfVmcd+o7?=
 =?us-ascii?Q?+9pAhjLpF8LITS3qFKiWkSObgBpjzL6BJZb7gSxGC9X70uQbAFr85i2VqlCl?=
 =?us-ascii?Q?GJWU73W2fE+cu0BEunvfPsJMkBlW+HiV3rwk++2h+wq/Bds+o2ooU2Eg8iVf?=
 =?us-ascii?Q?eMIYvyiE80/bG+PjkX+FC58M14BP0xfBi5UQjLZk4xK5cgwoQYMKo/o2zrgb?=
 =?us-ascii?Q?/D7UPDbI9DH/nK6WfIzbRANrlbZ9p7g/n9e472ZKg+XlaOmWBTEm3zXPVMF6?=
 =?us-ascii?Q?qD+dZgf1+P4uHeL3IlQaOhSfy16RZRxHKgorVDZBoBC+b5Jr80aN79zXLggQ?=
 =?us-ascii?Q?29hSm6Rcm5+sjdjL20OBDQuk614mc3/PUlO2FEoCHkzaSsbSIGlNqBZWcoLn?=
 =?us-ascii?Q?5X1Fk2gdvYFN+xEMyx/Qj8Lc91YD9gPzIYgI9tl1RCQ5sJ58AbEMd/T/Hb2B?=
 =?us-ascii?Q?w5uX5iLZZOIYnEY8/Ov/SvaKEjKDm6lWC6Ut2kyNLitv2kdaK5BsldRU98TM?=
 =?us-ascii?Q?U7zEDkMwc0pHSE/Hq5vE+1MSmukwEQMTay5VweWqK3t+0ycRbXW23bFBSSLQ?=
 =?us-ascii?Q?LWw8aRuEXYRlRdrXP0bu8zL9AdhPUvJ3oS9pDiFWFfvfczuAmstd9iFyhSbD?=
 =?us-ascii?Q?/9P62U0h9OlxanEQMWlFJ9hcErBhlXrKTi9vh2kdqrS0Nh18QpL7oPbEMB75?=
 =?us-ascii?Q?kwC1ZW3dKUw9xKXtta28uIPh8dxxWSMgwMY3DaUC9eLFsc7C6iTucZf4hA2+?=
 =?us-ascii?Q?SuTtWQDlWtK+SUh7D8my1471VkMbjpmbkz1OjvTd7ukAjV5rF3V2Y5n9t3rC?=
 =?us-ascii?Q?ZPOyU82AVw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa5e3f64-88c0-448d-b81b-08de78aa3ff7
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 22:22:55.0066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +KdclZErws7HoaRaxt0RWuSM8+sl/Z0Bru/pGD3IB+H5Zf0MPO76ag5fcnpsqqwS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6473

unmap has the odd behavior that it can unmap more than requested if the
ending point lands within the middle of a large or contiguous IOPTE.

In this case the gather should flush everything unmapped which can be
larger than what was requested to be unmapped. The gather was only
flushing the range requested to be unmapped, not extending to the extra
range, resulting in a short invalidation if the caller hits this special
condition.

This was found by the new invalidation/gather test I am adding in
preparation for ARMv8. Claude deduced the root cause.

As far as I remember nothing relies on unmapping a large entry, so this is
likely not a triggerable bug.

Cc: stable@vger.kernel.org
Fixes: 7c53f4238aa8 ("iommupt: Add unmap_pages op")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 3e33fe64feab22..7e7a6e7abdeed1 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -1057,7 +1057,7 @@ size_t DOMAIN_NS(unmap_pages)(struct iommu_domain *domain, unsigned long iova,
 
 	pt_walk_range(&range, __unmap_range, &unmap);
 
-	gather_range_pages(iotlb_gather, iommu_table, iova, len,
+	gather_range_pages(iotlb_gather, iommu_table, iova, unmap.unmapped,
 			   &unmap.free_list);
 
 	return unmap.unmapped;
-- 
2.43.0

