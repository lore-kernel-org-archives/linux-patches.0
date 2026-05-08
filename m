Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010047.outbound.protection.outlook.com [40.93.198.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121F13EE1CC;
	Fri,  8 May 2026 14:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778252009; cv=fail; b=Bblx9LHywjB4gwhByyODgje0v89io1Us9tWaTZ9GwDjaRfvgFkzV5tuOzpydMOhz69GIzZZq15R208YnklwOy5hWemlazPz7MdwaEYXGm/n1Sh+d8SogYigt2xGY3CxPf9qZNqXhf3EW4wS4loqjjfFC9u2flGStb+VNJmAPij8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778252009; c=relaxed/simple;
	bh=cpRVHrQ3HvTpXe3wBlOF4636v8otIqpfD3jyAOGsA60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=U5qNvWpXOPBZLbMyH4iE2pPlIqYhraBUHbgAF9lwZNgwt4/Qv8mnU/KGr5pC2uz40uaWbOahD5ZxGJMfSIHCAbQuYe+dC0/Q5UR6LSbfsVP04kl71//orpxSBOwXrUdMG0gsD3V6uzWHbRYyogxr0P3jU7bejqiPF+KYNNamd8U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Y/Ini6x8; arc=fail smtp.client-ip=40.93.198.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Y/Ini6x8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MxsVtz/NWZUh12mZGRG5ZwjqaPs8Md+orKJVHWmgcVGT6j72zaOAYqLUOcQEYRySSJwbjxZa2mpufmDwW7G7AC54f17uKdFkyIsXR/26x9Vyy56ku2+4d0HSN2D0yfaBdjI+80C3VOArQ4TelIFS5dTV/m0Srf83AxZafWR57q4fIapArdB4HIOhkU0aDYuW7ZmLUUWKCGZH7vCkNKQ6oqcgW/yQPDaEJ448272lKG/PKCFXtnVhuCef+irlu7g8QiGNGw7Dzm0fnmr2jvJO7sbkGHh8uU10aPGbCqOpXSTkmwHRnvXncQYGm5KEU0YdY2Zz2E0I1hhayZf9+5NBuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rmZEFNNG7gQBiFUKTmyQB4xTIt4wKHLTBozzzQIaQN0=;
 b=AqB5VfBr87TnjwKE/ZAJxU5tedJ6J3+6WFXDDfI1JE4cpoVio4gYpTjeqe/F2U1L0OnPEDRlnw5yFWb07vjEzhxYeDXIQN29Ze42sQzXqcx3fy5Gy1ZQmoTdKqpGHJtWpxXQQhUBBGyyU5O5l3/kXRsfA/dAuN90oWTj6Pcc4MPFmeX3h4uXfcuF4xJazE64/8YIRmULrmITctYpRvXi/Pugwnbc4ErYbZA0l+BcywbZaVKdDxOGXF2YXirHNBSOcvKrix7F+75zEh6Wha/5p3z3DICMQjsjrv7J1IKdV0P95g5bVp1idtg9O4q3aBGH1FDI03bgYpdX2ep+AiK0Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rmZEFNNG7gQBiFUKTmyQB4xTIt4wKHLTBozzzQIaQN0=;
 b=Y/Ini6x85uwYftjHomc6ytGznAYo+zG5wGJiZfLwknNnUeQschNWYOtk5/1EZovKoWwuqRpDEGF/OfiYkg1rkHbZPx26Xbn11SUrXtN7PhKuM7V5pxeAWaAFKtdUtrG2TW4224lz9K+E+oZI/TCfW01xoOiv/G+FXqhC/Uof28tOLeLyAHR627/74sJiXquJfr+eWlN0INSfO0i8djZyuxe0ydGJD7Ed7oFloe+hVY6ATyAGI6Sc9n90Ny5gWfJLyoHcvQ+a8RwaFWgBSMfAbnd07FlBIF+DYZ15+Hjdj39+0RUvyqKB42xnfSqaihXSDdUIon6OxQr4MLuvaqzmIg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MN0PR12MB6224.namprd12.prod.outlook.com (2603:10b6:208:3c0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.20; Fri, 8 May
 2026 14:53:11 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9891.017; Fri, 8 May 2026
 14:53:11 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>
Cc: Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 7/8] iommu/riscv: Include the dword number in RISCV_IOMMU_CMD macros
Date: Fri,  8 May 2026 11:53:06 -0300
Message-ID: <7-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
In-Reply-To: <0-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0255.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::20) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MN0PR12MB6224:EE_
X-MS-Office365-Filtering-Correlation-Id: e1481133-e778-4e73-dce7-08dead118608
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|921020|22082099003|18002099003|56012099003|3023799003;
X-Microsoft-Antispam-Message-Info:
	0qaH5FVfrj/XgeO6pldpxuzg1dJeN+0NrzTlV27BjCdA/0oPqa1gaejnZRPOEPS7PaVy1tbXlHiH769QRywy1dxJbmcB9zd6NLCEnDtc5HbsPYZ4z2zfjN1aKJs/007NihPuYXZaCWtmRKGzCSeppyI0Qb9w5mTcJ02wTpf2qkOWKLz1c+zIiUfHbalWDkm+W9I8EF7uaaNg4YGdXTsx+EIGobgoGFzPcBJWp72ooLyLyJ2J9108tDxbcvf0Zqf8sRvlhXPnvia7gidDnmMAqkyAZUlTXUS7fhGTyfoqNK828AdMebB/qWroaGq/yViXG/cxkpHJqAo5D+9LvrbkueMVgo/5Ix1ozfaQqSALQ4evsHWg0EPCIcdh8ddm+Kn95gGhKN84xgFPWuwjUp52q8RFAAtK5Kn8fTQmMXIABprnFiVKvOkIfcg2YuR6+cY39tMf5AMqDtxg8Cz8JAt4MqqxV3L8HAxHtWjXjww7u2QR2B03TRNAYV+Fa5aqZhuCB5BgSSTUmmsD4eEkXO5KM9XtOTqMfkmjsrzP6PjsDrYh/M2WU4cYCPcM3b6Yu4+cLyrY451vqRxigrK14QeJK+aQNk4khrzIFjcdr9bXFhJ+eh3NzFbWJ7eu6liOvsbuqa7IEFx+0AOchID+M0oa+ybLtohdXMCc1BKpg+/g2d+4ePr8CdvIFYmjUV6/KmDVdAGjzgVPyMuUlDjlk4bPSrI8t0zWirhktDSE3vrZvFteJzGL6SFEk3mXpxHqlIu5
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(921020)(22082099003)(18002099003)(56012099003)(3023799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BjGLCEHNc0Qg9TPkvGM8kJaG1afWvvLY5kH98IDvtkYWVYMQ5CPODx7y4nx1?=
 =?us-ascii?Q?YIZzFmM1zxYGky/7ZBQR31AnbyQnk9vI1eaLT+b9o+j8FH08oIhISGiXL0r2?=
 =?us-ascii?Q?W+0GZyNgZ1YHTqK8V1rN0me7z62Hcds4kJYgPSqGaTPNykCOTen3NjVpKXIr?=
 =?us-ascii?Q?jRG/3iVyfmDNAXooXI+23O1eseGi3514AxCndFzTm4UKwYPfM5TuJSGJFoGe?=
 =?us-ascii?Q?V2fzEqkdGyHmyANhk12drvjHdfVWECcfP55uax8Y7BIBGXvemeSlweiWd4Vf?=
 =?us-ascii?Q?wIYdtqWGd6IZxbPbqushWXkXAcfLswjgXp0xTIi/9cb45MLrCjj4MeT/BvRR?=
 =?us-ascii?Q?HESdFKUwKnCjR67l+L353PrfHBfCt+cZy9FN9P42gA4847yXkkRU/nPWPuKz?=
 =?us-ascii?Q?mNdSJU2kpUQAgVmnwJwe8eqoI8BiUI5PAbxs/7LdHDnnm+FBegKG8BHOGEUO?=
 =?us-ascii?Q?nkdM0OQQtC1vc2lbH2LHg3xtDRaz/oK4vGeObsih501t9f/aCbpa3AVt0MmS?=
 =?us-ascii?Q?wfHCxVCO6dbgEzo76PChGWjLj2HShqIWXTEtrwinMl/9oAFS/A/aFRRiCq/5?=
 =?us-ascii?Q?VE92q5pHWg1RCtiYPqW4fcBtKnjFJBP5G/WacUIr1E07zv91tuVl1f9l0U4J?=
 =?us-ascii?Q?AvyleDhjwUjUEoHjDv6pQjxIxVgFNrHw1au7oUEquw06dgL3KZP1jE9hU7AI?=
 =?us-ascii?Q?YdaJxMY2epLy/udfc864FHGBQp5U48u2WYY+INolzZtqlUwyXlkYQlk9hA61?=
 =?us-ascii?Q?kppfmda3u3B6OjEm8JOidkmtB0lWSNyrv5lq33AxTyg+mTcCT6Jj8l5xYW8Y?=
 =?us-ascii?Q?1nFtvxYqQNdEitoUTKrDZJCQN5VfolgT1yGPmK/d1LPnfuenxIbGEyRNhHfw?=
 =?us-ascii?Q?ZCQXaYaAO1SSXjg3oJnka+7/BnaH0/cWlTWDRhbb425LmDMqzbZLd2HWiFpc?=
 =?us-ascii?Q?c1b5sVMM8kvRajMw/nKaks3Rm2uFWDgJMVuqDihhXF5BhjcQWWCnsoSy3i9T?=
 =?us-ascii?Q?WVOhsluusxwlKix/BCAun5WYx+cE1tGRh4PdpImQ/KI7Kej49UsGsVg/WYf4?=
 =?us-ascii?Q?OV7caqSQqA1n/a2HC0CnHIuLPqi0d95aFKDYPDeEGA2ZODoCtJMtFsUaUhwk?=
 =?us-ascii?Q?3G06kYPBHM8A2V2VlUZxW0/N0f7rgVNJEGS/4p7HJ6sJP38df/laHM7Q9u4c?=
 =?us-ascii?Q?B4gq24V+FZpxHvi5sYUib11bSkh4BHA5ZajEUYZpCHw+YJokWTgnsnsOomUL?=
 =?us-ascii?Q?4TqblGj2ftORVvzGbk135lv3zQKZZ578k+lqZ5tOTh3GCn/dk0qCesT2k1t/?=
 =?us-ascii?Q?GCQeSobfLsi5B/12nSnxfhH0GPoatuKi7bLvFhAnplDKLqFeJCCmkXu9np0b?=
 =?us-ascii?Q?FgosgUlY1meNXJqud6SxcP8qz4t2t/2mMxHe/BzU4mLXnlE0gcAz4YTopycw?=
 =?us-ascii?Q?nxW8hF0dn+QlXB2fvtfi90JAnOFmiZpD8w5X59SCIJliJClF1rvImt5fHiqM?=
 =?us-ascii?Q?drBoHdNyM4TPm2s5p03Ow2l73/MafTPFdk2z3HyZsgj5Pfryz4CdRyb9gM2h?=
 =?us-ascii?Q?4VQkRJzbC1ZucH0CwgVUqcgpnjGomn5yfjW1zkPZ0qe/X2RvKkgvwqoTa7Jy?=
 =?us-ascii?Q?UaqBwq4vmQHpYRfm08p3t2wL/inlUqsGNEYzcreFttAUu6zb3fa2/jFQIxjA?=
 =?us-ascii?Q?5ybPg7Zu+K5mLTbeF0g91R5TbwUaZG91Hz+v+5WE5SCaxCv/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1481133-e778-4e73-dce7-08dead118608
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 14:53:11.0148
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2V1AkzeJgflnNdpMoDoiXIaM0CYA31o0LMSQ7PNBgPl0txqmeGU8HigjWNv86LHl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6224

The command queue entry format is 128 bits. Follow the pattern of the
other drivers and encode the 64 bit dword number in the macro
itself. RISC-V further has similarly named macros that are not field
layout macros, but field content macros which won't get a new number.

Overall this is clearer to understand the code and check for errors like
using the wrong macro in the wrong spot.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/iommu-bits.h | 102 +++++++++++++++----------------
 1 file changed, 51 insertions(+), 51 deletions(-)

diff --git a/drivers/iommu/riscv/iommu-bits.h b/drivers/iommu/riscv/iommu-bits.h
index f01b49ac815586..8c60780363da72 100644
--- a/drivers/iommu/riscv/iommu-bits.h
+++ b/drivers/iommu/riscv/iommu-bits.h
@@ -461,32 +461,32 @@ struct riscv_iommu_command {
 };
 
 /* Fields on dword0, common for all commands */
-#define RISCV_IOMMU_CMD_OPCODE	GENMASK_ULL(6, 0)
-#define	RISCV_IOMMU_CMD_FUNC	GENMASK_ULL(9, 7)
+#define RISCV_IOMMU_CMD0_OPCODE	GENMASK_ULL(6, 0)
+#define RISCV_IOMMU_CMD0_FUNC	GENMASK_ULL(9, 7)
 
 /* 3.1.1 IOMMU Page-table cache invalidation */
 /* Fields on dword0 */
 #define RISCV_IOMMU_CMD_IOTINVAL_OPCODE		1
 #define RISCV_IOMMU_CMD_IOTINVAL_FUNC_VMA	0
 #define RISCV_IOMMU_CMD_IOTINVAL_FUNC_GVMA	1
-#define RISCV_IOMMU_CMD_IOTINVAL_AV		BIT_ULL(10)
-#define RISCV_IOMMU_CMD_IOTINVAL_PSCID		GENMASK_ULL(31, 12)
-#define RISCV_IOMMU_CMD_IOTINVAL_PSCV		BIT_ULL(32)
-#define RISCV_IOMMU_CMD_IOTINVAL_GV		BIT_ULL(33)
-#define RISCV_IOMMU_CMD_IOTINVAL_GSCID		GENMASK_ULL(59, 44)
-#define RISCV_IOMMU_CMD_IOTINVAL_NL		BIT_ULL(34)
+#define RISCV_IOMMU_CMD0_IOTINVAL_AV		BIT_ULL(10)
+#define RISCV_IOMMU_CMD0_IOTINVAL_PSCID		GENMASK_ULL(31, 12)
+#define RISCV_IOMMU_CMD0_IOTINVAL_PSCV		BIT_ULL(32)
+#define RISCV_IOMMU_CMD0_IOTINVAL_GV		BIT_ULL(33)
+#define RISCV_IOMMU_CMD0_IOTINVAL_GSCID		GENMASK_ULL(59, 44)
+#define RISCV_IOMMU_CMD0_IOTINVAL_NL		BIT_ULL(34)
 /* dword1[61:10] is the 4K-aligned page address */
-#define RISCV_IOMMU_CMD_IOTINVAL_ADDR		GENMASK_ULL(61, 10)
+#define RISCV_IOMMU_CMD1_IOTINVAL_ADDR		GENMASK_ULL(61, 10)
 
 /* 3.1.2 IOMMU Command Queue Fences */
 /* Fields on dword0 */
 #define RISCV_IOMMU_CMD_IOFENCE_OPCODE		2
 #define RISCV_IOMMU_CMD_IOFENCE_FUNC_C		0
-#define RISCV_IOMMU_CMD_IOFENCE_AV		BIT_ULL(10)
-#define RISCV_IOMMU_CMD_IOFENCE_WSI		BIT_ULL(11)
-#define RISCV_IOMMU_CMD_IOFENCE_PR		BIT_ULL(12)
-#define RISCV_IOMMU_CMD_IOFENCE_PW		BIT_ULL(13)
-#define RISCV_IOMMU_CMD_IOFENCE_DATA		GENMASK_ULL(63, 32)
+#define RISCV_IOMMU_CMD0_IOFENCE_AV		BIT_ULL(10)
+#define RISCV_IOMMU_CMD0_IOFENCE_WSI		BIT_ULL(11)
+#define RISCV_IOMMU_CMD0_IOFENCE_PR		BIT_ULL(12)
+#define RISCV_IOMMU_CMD0_IOFENCE_PW		BIT_ULL(13)
+#define RISCV_IOMMU_CMD0_IOFENCE_DATA		GENMASK_ULL(63, 32)
 /* dword1 is the address, word-size aligned and shifted to the right by two bits. */
 
 /* 3.1.3 IOMMU Directory cache invalidation */
@@ -494,9 +494,9 @@ struct riscv_iommu_command {
 #define RISCV_IOMMU_CMD_IODIR_OPCODE		3
 #define RISCV_IOMMU_CMD_IODIR_FUNC_INVAL_DDT	0
 #define RISCV_IOMMU_CMD_IODIR_FUNC_INVAL_PDT	1
-#define RISCV_IOMMU_CMD_IODIR_PID		GENMASK_ULL(31, 12)
-#define RISCV_IOMMU_CMD_IODIR_DV		BIT_ULL(33)
-#define RISCV_IOMMU_CMD_IODIR_DID		GENMASK_ULL(63, 40)
+#define RISCV_IOMMU_CMD0_IODIR_PID		GENMASK_ULL(31, 12)
+#define RISCV_IOMMU_CMD0_IODIR_DV		BIT_ULL(33)
+#define RISCV_IOMMU_CMD0_IODIR_DID		GENMASK_ULL(63, 40)
 /* dword1 is reserved for standard use */
 
 /* 3.1.4 IOMMU PCIe ATS */
@@ -504,25 +504,25 @@ struct riscv_iommu_command {
 #define RISCV_IOMMU_CMD_ATS_OPCODE		4
 #define RISCV_IOMMU_CMD_ATS_FUNC_INVAL		0
 #define RISCV_IOMMU_CMD_ATS_FUNC_PRGR		1
-#define RISCV_IOMMU_CMD_ATS_PID			GENMASK_ULL(31, 12)
-#define RISCV_IOMMU_CMD_ATS_PV			BIT_ULL(32)
-#define RISCV_IOMMU_CMD_ATS_DSV			BIT_ULL(33)
-#define RISCV_IOMMU_CMD_ATS_RID			GENMASK_ULL(55, 40)
-#define RISCV_IOMMU_CMD_ATS_DSEG		GENMASK_ULL(63, 56)
+#define RISCV_IOMMU_CMD0_ATS_PID		GENMASK_ULL(31, 12)
+#define RISCV_IOMMU_CMD0_ATS_PV			BIT_ULL(32)
+#define RISCV_IOMMU_CMD0_ATS_DSV		BIT_ULL(33)
+#define RISCV_IOMMU_CMD0_ATS_RID		GENMASK_ULL(55, 40)
+#define RISCV_IOMMU_CMD0_ATS_DSEG		GENMASK_ULL(63, 56)
 /* dword1 is the ATS payload, two different payload types for INVAL and PRGR */
 
 /* ATS.INVAL payload*/
-#define RISCV_IOMMU_CMD_ATS_INVAL_G		BIT_ULL(0)
+#define RISCV_IOMMU_CMD1_ATS_INVAL_G		BIT_ULL(0)
 /* Bits 1 - 10 are zeroed */
-#define RISCV_IOMMU_CMD_ATS_INVAL_S		BIT_ULL(11)
-#define RISCV_IOMMU_CMD_ATS_INVAL_UADDR		GENMASK_ULL(63, 12)
+#define RISCV_IOMMU_CMD1_ATS_INVAL_S		BIT_ULL(11)
+#define RISCV_IOMMU_CMD1_ATS_INVAL_UADDR	GENMASK_ULL(63, 12)
 
 /* ATS.PRGR payload */
 /* Bits 0 - 31 are zeroed */
-#define RISCV_IOMMU_CMD_ATS_PRGR_PRG_INDEX	GENMASK_ULL(40, 32)
+#define RISCV_IOMMU_CMD1_ATS_PRGR_PRG_INDEX	GENMASK_ULL(40, 32)
 /* Bits 41 - 43 are zeroed */
-#define RISCV_IOMMU_CMD_ATS_PRGR_RESP_CODE	GENMASK_ULL(47, 44)
-#define RISCV_IOMMU_CMD_ATS_PRGR_DST_ID		GENMASK_ULL(63, 48)
+#define RISCV_IOMMU_CMD1_ATS_PRGR_RESP_CODE	GENMASK_ULL(47, 44)
+#define RISCV_IOMMU_CMD1_ATS_PRGR_DST_ID	GENMASK_ULL(63, 48)
 
 /**
  * struct riscv_iommu_fq_record - Fault/Event Queue Record
@@ -713,8 +713,8 @@ struct riscv_iommu_msipte {
 
 static inline void riscv_iommu_cmd_inval_vma(struct riscv_iommu_command *cmd)
 {
-	cmd->dword0 = FIELD_PREP(RISCV_IOMMU_CMD_OPCODE, RISCV_IOMMU_CMD_IOTINVAL_OPCODE) |
-		      FIELD_PREP(RISCV_IOMMU_CMD_FUNC, RISCV_IOMMU_CMD_IOTINVAL_FUNC_VMA);
+	cmd->dword0 = FIELD_PREP(RISCV_IOMMU_CMD0_OPCODE, RISCV_IOMMU_CMD_IOTINVAL_OPCODE) |
+		      FIELD_PREP(RISCV_IOMMU_CMD0_FUNC, RISCV_IOMMU_CMD_IOTINVAL_FUNC_VMA);
 	cmd->dword1 = 0;
 }
 
@@ -722,72 +722,72 @@ static inline void riscv_iommu_cmd_inval_set_addr(struct riscv_iommu_command *cm
 						  u64 addr)
 {
 	cmd->dword1 =
-		FIELD_PREP(RISCV_IOMMU_CMD_IOTINVAL_ADDR, PHYS_PFN(addr));
-	cmd->dword0 |= RISCV_IOMMU_CMD_IOTINVAL_AV;
+		FIELD_PREP(RISCV_IOMMU_CMD1_IOTINVAL_ADDR, PHYS_PFN(addr));
+	cmd->dword0 |= RISCV_IOMMU_CMD0_IOTINVAL_AV;
 }
 
 static inline void riscv_iommu_cmd_inval_set_nl(struct riscv_iommu_command *cmd)
 {
-	cmd->dword0 |= RISCV_IOMMU_CMD_IOTINVAL_NL;
+	cmd->dword0 |= RISCV_IOMMU_CMD0_IOTINVAL_NL;
 }
 
 static inline void riscv_iommu_cmd_inval_set_pscid(struct riscv_iommu_command *cmd,
 						   int pscid)
 {
-	cmd->dword0 |= FIELD_PREP(RISCV_IOMMU_CMD_IOTINVAL_PSCID, pscid) |
-		       RISCV_IOMMU_CMD_IOTINVAL_PSCV;
+	cmd->dword0 |= FIELD_PREP(RISCV_IOMMU_CMD0_IOTINVAL_PSCID, pscid) |
+		       RISCV_IOMMU_CMD0_IOTINVAL_PSCV;
 }
 
 static inline void riscv_iommu_cmd_inval_set_gscid(struct riscv_iommu_command *cmd,
 						   int gscid)
 {
-	cmd->dword0 |= FIELD_PREP(RISCV_IOMMU_CMD_IOTINVAL_GSCID, gscid) |
-		       RISCV_IOMMU_CMD_IOTINVAL_GV;
+	cmd->dword0 |= FIELD_PREP(RISCV_IOMMU_CMD0_IOTINVAL_GSCID, gscid) |
+		       RISCV_IOMMU_CMD0_IOTINVAL_GV;
 }
 
 static inline void riscv_iommu_cmd_iofence(struct riscv_iommu_command *cmd)
 {
-	cmd->dword0 = FIELD_PREP(RISCV_IOMMU_CMD_OPCODE, RISCV_IOMMU_CMD_IOFENCE_OPCODE) |
-		      FIELD_PREP(RISCV_IOMMU_CMD_FUNC, RISCV_IOMMU_CMD_IOFENCE_FUNC_C) |
-		      RISCV_IOMMU_CMD_IOFENCE_PR | RISCV_IOMMU_CMD_IOFENCE_PW;
+	cmd->dword0 = FIELD_PREP(RISCV_IOMMU_CMD0_OPCODE, RISCV_IOMMU_CMD_IOFENCE_OPCODE) |
+		      FIELD_PREP(RISCV_IOMMU_CMD0_FUNC, RISCV_IOMMU_CMD_IOFENCE_FUNC_C) |
+		      RISCV_IOMMU_CMD0_IOFENCE_PR | RISCV_IOMMU_CMD0_IOFENCE_PW;
 	cmd->dword1 = 0;
 }
 
 static inline void riscv_iommu_cmd_iofence_set_av(struct riscv_iommu_command *cmd,
 						  u64 addr, u32 data)
 {
-	cmd->dword0 = FIELD_PREP(RISCV_IOMMU_CMD_OPCODE, RISCV_IOMMU_CMD_IOFENCE_OPCODE) |
-		      FIELD_PREP(RISCV_IOMMU_CMD_FUNC, RISCV_IOMMU_CMD_IOFENCE_FUNC_C) |
-		      FIELD_PREP(RISCV_IOMMU_CMD_IOFENCE_DATA, data) |
-		      RISCV_IOMMU_CMD_IOFENCE_AV;
+	cmd->dword0 = FIELD_PREP(RISCV_IOMMU_CMD0_OPCODE, RISCV_IOMMU_CMD_IOFENCE_OPCODE) |
+		      FIELD_PREP(RISCV_IOMMU_CMD0_FUNC, RISCV_IOMMU_CMD_IOFENCE_FUNC_C) |
+		      FIELD_PREP(RISCV_IOMMU_CMD0_IOFENCE_DATA, data) |
+		      RISCV_IOMMU_CMD0_IOFENCE_AV;
 	cmd->dword1 = addr >> 2;
 }
 
 static inline void riscv_iommu_cmd_iodir_inval_ddt(struct riscv_iommu_command *cmd)
 {
-	cmd->dword0 = FIELD_PREP(RISCV_IOMMU_CMD_OPCODE, RISCV_IOMMU_CMD_IODIR_OPCODE) |
-		      FIELD_PREP(RISCV_IOMMU_CMD_FUNC, RISCV_IOMMU_CMD_IODIR_FUNC_INVAL_DDT);
+	cmd->dword0 = FIELD_PREP(RISCV_IOMMU_CMD0_OPCODE, RISCV_IOMMU_CMD_IODIR_OPCODE) |
+		      FIELD_PREP(RISCV_IOMMU_CMD0_FUNC, RISCV_IOMMU_CMD_IODIR_FUNC_INVAL_DDT);
 	cmd->dword1 = 0;
 }
 
 static inline void riscv_iommu_cmd_iodir_inval_pdt(struct riscv_iommu_command *cmd)
 {
-	cmd->dword0 = FIELD_PREP(RISCV_IOMMU_CMD_OPCODE, RISCV_IOMMU_CMD_IODIR_OPCODE) |
-		      FIELD_PREP(RISCV_IOMMU_CMD_FUNC, RISCV_IOMMU_CMD_IODIR_FUNC_INVAL_PDT);
+	cmd->dword0 = FIELD_PREP(RISCV_IOMMU_CMD0_OPCODE, RISCV_IOMMU_CMD_IODIR_OPCODE) |
+		      FIELD_PREP(RISCV_IOMMU_CMD0_FUNC, RISCV_IOMMU_CMD_IODIR_FUNC_INVAL_PDT);
 	cmd->dword1 = 0;
 }
 
 static inline void riscv_iommu_cmd_iodir_set_did(struct riscv_iommu_command *cmd,
 						 unsigned int devid)
 {
-	cmd->dword0 |= FIELD_PREP(RISCV_IOMMU_CMD_IODIR_DID, devid) |
-		       RISCV_IOMMU_CMD_IODIR_DV;
+	cmd->dword0 |= FIELD_PREP(RISCV_IOMMU_CMD0_IODIR_DID, devid) |
+		       RISCV_IOMMU_CMD0_IODIR_DV;
 }
 
 static inline void riscv_iommu_cmd_iodir_set_pid(struct riscv_iommu_command *cmd,
 						 unsigned int pasid)
 {
-	cmd->dword0 |= FIELD_PREP(RISCV_IOMMU_CMD_IODIR_PID, pasid);
+	cmd->dword0 |= FIELD_PREP(RISCV_IOMMU_CMD0_IODIR_PID, pasid);
 }
 
 #endif /* _RISCV_IOMMU_BITS_H_ */
-- 
2.43.0

