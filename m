Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794785453;
	b=KwYp774K+tBeqcQdRveBy5MOJ8zN2Wb2K0w23CnlMCQ++e1pz7wg4GA33dtZGhLMtXdI
	 G933MBxda+1NG+GL9tOmnbLz+Asf5Ux3VMJvWZ2E6CaEbUG8+EvcGOMfJC04+jTq4AoGJ
	 5vPQg/cQTaPRIgScMmh2b2G/0l3F2M5HqrTiXHUiWvIDQKe0DTtBcTuz1Jh6DvZPOiZg5
	 3/AZu+ooYDstRmNFFr38CbKbT+OiVfJ+3va7N+JkrW9/+TS27YUNcphoyYWeRuXbTLtWh
	 qBPngd43nDwCinSAx8rj6yWa1LwfXXwjloUw/ExbZ108c1RwjanCbqR73iz7SH19hcg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785453;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:In-Reply-To:References:Content-Transfer-Encoding:
	 Content-Type:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=DzKKkEfbjtomr9ILc9WTafrAyNSGs0iQqmSyyeQgMiE=;
	b=uEpzd7OKsuNmS8v65oFrp/pi0nWQwInxSD/DAQT7aVTxzpCeoOFDLhLUhCfjo026E3ib
	 PQI7Pf7eC05qLJhtlpk2EISkaLEpNqVJp7mxs5P1SsrvXld6C9+8JU5E7ub8w2ykLMIVX
	 crKIHnPu3Lp/GUxH6WoH0W/qcaTfxl6zJYFCqI4xhb37FAty224p2xeL0mmtyve7s2iI8
	 8s/hqetCAXjKZsghjA56rT/l5NZSiLfXGkng/FRpxzgUBNTYnB50aq44lTg9bbyo8Oc7R
	 vXKRGKMEXDLOz+Cn8iL7onDm92LTtjmAa4GEJqiq/+jYWzSdP/k3yf+sVAM1Y+3AqLA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JFYqBYz7;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.51
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011051.outbound.protection.outlook.com [40.93.194.51])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F78606A331;
	Sun, 15 Nov 2026 23:30:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64F78606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=JFYqBYz7
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jCQLwity61Jl7a08KzeqfatnagNJCYu8/rYuehDV8P8vX6rMEUOGLRbY+9Oz1OCJ/nXRvFq4IC50KRgGRu+hu74glbG1ndkY9RyISsDIoxDr4g1x5kH5QTztiRDl8sb2i6WrB6lkdN5NGZAsv1ff5W74RtmrznV+dUf+Cvo85P7rKQilSIp+QKy1PBNooMlIB8Cfa7rcYWPESyNhLxkK03vSBzGcaIHXy/bGmxIMdr4n4vt3PR/XtlGfNERREEWZZOrZ0gxLZNmhIzhq3jJUH/B0V5K+gqwLRx/c3bL1R7PePVFxdi0cO9pYhNbhk8pCOXx9bhB+GUbg1dVOuSE10A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DzKKkEfbjtomr9ILc9WTafrAyNSGs0iQqmSyyeQgMiE=;
 b=y8DvmekpySHQHb+9TAiAM4ztVSk5k+c89P9ZT6K43bRIhKigrvE+MTzn4a5ItZzxAnt0gXOTpagKnkCpcrT+fnhhiM+lRBizr/M5Zgu36vdAD+qjLA4sycm2FdRdSh+1aSnCZFV6Sh5J11W4D0suZ9Yk1FDQFg/xbsO/oVtAjdcKWlJatVgokh1ZE4FMxftaU3DxbTeVdmQ9ywXPZXg1dHpTcoYScemz9hF212HqIfS63tHGwXMVMfCW2dl3o0A8IlwjtkiYvcSeHI8vuQ4Wcr0kQ3N8gJIo0dJf95HUibzmDYcEyFjLBx+Ybe7+cR7dvOyatbR9JRRvtQ2a0ejaug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DzKKkEfbjtomr9ILc9WTafrAyNSGs0iQqmSyyeQgMiE=;
 b=JFYqBYz7tVMMWGeMUmQhF8bd3kvmvYayaFe4g6c8Td3FA9H9OKamjSR0VQ84uzWwusdpKu4bS58s6q6poa8JfT86O1ajHttPhvuWNQ2VfhZVzN4zmPnEnkvia4GuNc/fEbNeBA/9Z9VFw/BsH0OxZvXQtFXJPr8rZZU40uEwmZJQi2w8ILU+0DmZXPXgQ/rV60YMxlM+ns/hmc6bqsWXHtfoSRUhGqJYy1L/wzKffNVrNHKI38PlhQsPbnMw5oQ/f8N/7ylbsiTzf8V7PXecxLutUoxnI7z5kBF19ZlptFQVQDYpLouTwD4wdTE7Z0fPhs12cznYB80Yioa8oh359Q==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DS0PR12MB8815.namprd12.prod.outlook.com
 (2603:10b6:8:14f::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Sun, 15 Nov
 2026 23:30:46 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0615.013; Sun, 15 Nov 2026
 23:30:46 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	John Garry <john.garry@arm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 10/13] iommu/arm-smmu-v3: Move the DMA API comment to flush_iotlb_all
Date: Sun, 15 Nov 2026 19:30:40 -0400
Message-ID: <10-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0449.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::34) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DS0PR12MB8815:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f169c9a-37e3-41b8-5c73-08df4370789d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|5023799004|11063799006|56012099006|261026121527099003|261026140227099003|261028144727099003|261022105027099003|261022075727099003|261021123027099003|261021121427099003|261102123227099003|261009223027099003|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	rcG6pdxPefEowOpI/k83mHooQK9IVF70bvTi5S5eUnVHw/WsMaKxDoJp5OeSY0YpxmJjcFCo+0WZknBIkzGZnVuIGQbuqqaoyIKXv5sN69ACxJLKn0UHgLKlK4vVRcNPyw5APiBJ6y3k7TTamZ0b+UNX0J1e0NnJ4h1EKQqOneqBc8j8lolNpPAG3AzkoChM0IEj9ikivtdoirL0LC5HcI47JCFXDZ4oJxFjDtvcjxZfM6XC550bsPCDpHMd2gl61gG2XfHOw06tFlC0Mn/0j7eZhBvNLrhXjv0/uJBYiLiXsxJnuDvUzFBaaADGJG/2ZY1h4Bj1u5puovLKTDSBgHY09aROrP/Tm3SCQrdEYiDrlPH/xM+KklKoD6nbUVOdwA9oarY8JY1AVkhG6Ob5b0VeUkamAQYrRXYpDdYoSTIT/fh6boy+TntWLtleL7vzimFph3bYo1d00M1RTmG0oLAS/t7n1E9XcW72i+sM/HpD0GddZK6Ayg0WUjks5iQjjLD1teYVBw1kX5pNbgczSfKLbYXC1Da+Tg0mSEI52ZHtSHpj7ZY2N+ykZM7Elcd4+UHJtvzPkiABBXDNHLRfENZEm+Fx5hDoamqUyYIjwiTP8DdvVaBWCRmlDD9clJmCkutP0mlIGeKZn0z91mhSnfkT7061Af9bxzRnHtsc/H4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(5023799004)(11063799006)(56012099006)(261026121527099003)(261026140227099003)(261028144727099003)(261022105027099003)(261022075727099003)(261021123027099003)(261021121427099003)(261102123227099003)(261009223027099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?X46qP9q/FYdtuoiili/BFuyqiWwUWole9U8tgJj5WLs2mcGRuYZxpu7x5V24?=
 =?us-ascii?Q?VEEeZ4I5+bz51RnsS6ff5NA6uAFAuO+zaFriErNnOEaJAAXSXWNHlSJyj9ma?=
 =?us-ascii?Q?CpWA8kaakrmlWtlopP1Y14SiyL/UZgMGkVhM8AHqBLlydhVuTxwuM0avSIzD?=
 =?us-ascii?Q?djSxlmQLrJa5IBObc0t1AySRHmbByI+F91kzgU/DHiHdeWqdPcq0E9gmrLGt?=
 =?us-ascii?Q?5AX27raAPfIN/wP/HzhQrQOLe+nXeLI2jb2anZGlMriLGe7dd4sAjpvbHMTw?=
 =?us-ascii?Q?UTi5D9tOVss32VapczBG8bfGlHmiqoT7m7KUlMXbrZrdgSb8T0Kt0Xq+zpkr?=
 =?us-ascii?Q?F0Nty1wsgpLKRWCUUhDjK32YrhjA0ugT0SBW6MV90OtZQw05PxD+EBXBwpeX?=
 =?us-ascii?Q?wGZl+6TRROFzLRaHGYbs+YrmnZeZkaCJubq84qNvrANaOObLlBdZiuabTpBk?=
 =?us-ascii?Q?+//JlDyawNYAdloJjkIq5+LgdOeBMKOkCXE+3tc5AbnErkRqMW669qbxBVjp?=
 =?us-ascii?Q?KM0NL2o35PM3bqmoE5WKVbx+TYV8NK1m7m0lp86WGUDkklqO4rTGqDmnQKAb?=
 =?us-ascii?Q?emj4ALsCF0garcxj+JWiX3fIE+43SCMLk71/XTdZRS6R+3QBrsOax64SyX2x?=
 =?us-ascii?Q?cwotGwy0g+/AMGmTGw/QmWBYwwfjlegSQ5aZLrvpdwSCfn1E8/GglDKJjE/h?=
 =?us-ascii?Q?1/pW17Ugxo0BmNblaJc902f0J/6975GoJB2uIV0NRz+yQM/h/2d3MJZIVz1d?=
 =?us-ascii?Q?nlLyejUzmxwvWdWYMFi0S9NdW5QEdNBKS+LlY0aGmzN0XJNw75U+d+jyiOKv?=
 =?us-ascii?Q?BFLyoIhzkz6YqAWuPcdXqQzsgryrEBM5Fpz/ETCj305RmdeYprnrFxUh8zJd?=
 =?us-ascii?Q?scRpbRNKiHfgfyq+TI1wG40lN8sS8Xuu9GlePJgItH3JL83/HG6OivDH0Frk?=
 =?us-ascii?Q?tmc0mfshRESaBaB16csixnceTBloF98rJAxPyL5tIVv+7zHMc+CbS+VAoJdf?=
 =?us-ascii?Q?uC6iamEy+WIqZ9mrLwb1wK9jvE/a8ksR0MxW39scH9ES9JpdLoh5USgTKmI2?=
 =?us-ascii?Q?NVh8vH9mcMq1YjpRyGVrO9i4QMq/0TgEXS5NF/Sp6H7ypvrxswe8YyRA9i4j?=
 =?us-ascii?Q?yHHn3RX/J/fvBzDlsWXPh5z/Z3VRiPZB8hO/kN1tuK+pDVZSg9EoYFLCdh6z?=
 =?us-ascii?Q?O0lRtuADmJ/H1bt4HWBOYnfD5s0+McXUZVWMmdGzsvNjTwcKbN8JRURcd6M2?=
 =?us-ascii?Q?2H3IPVpUBmBGtJG1rHzUJWt9cyiRQxk/Y4NE38w1A5e4fV43g12d9vtm21BJ?=
 =?us-ascii?Q?t/CMKq07br3RcABqQggUNXpSpz0K5kZIv0MiuIfd7ks2fa3fwQbmbdy1U60d?=
 =?us-ascii?Q?md2hxX3rSlaxD4CypvroIH0yVLWVGejDHOeDdJYNPtLhV57buVobn3r3I3NR?=
 =?us-ascii?Q?aGSgBK8xBvvo6LIOmHBpcPcyejY1Uf97TxamIZTTuFzUjz5bSUWKSqZ+SO29?=
 =?us-ascii?Q?yBXu/dsq0r4E50llTifFFE2sIQv+L2pyM2u6z1w2JVP+xPzDU0LF1rr/isB9?=
 =?us-ascii?Q?I8Si+fxNMM3GOAHdIWnSWXOloBpgK3avYDr14JR3al3lNZMpItdqA4vCKS/Y?=
 =?us-ascii?Q?6meuH4iB624b9PeelUvrKH7qups8MutwXhCTVI3oDi3pW3RqSj1VnumfaYqT?=
 =?us-ascii?Q?YShnkEVX/CXnDCI5Ehfa8ioOtu+myFS3sFI44Ol/wtAuT6Sn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f169c9a-37e3-41b8-5c73-08df4370789d
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2026 23:30:44.9800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s3GLBTeJNTdGQSSsnA031YxHHXC8KQj7eoNPVEv5bkf2iP1g0GrfIplfwcFTXmv3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8815

arm_smmu_tlb_inv_context() is the wrong flush_all for this comment,
it is only called during io-pgtable destruction not during the dma-iommu
operation. Move it to arm_smmu_flush_iotlb_all() which is the flush
that is triggered by the dma-iommu lazy flush thread.

Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 31 +++++++++++----------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 294f9645cdc3db..3eb61eb35d0b38 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2484,21 +2484,6 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 {
 	struct arm_smmu_domain *smmu_domain = cookie;
 
-	/*
-	 * If the DMA API is running in non-strict mode then another CPU could
-	 * have changed the page table and not invoked any flush op. Instead the
-	 * other CPU will do an atomic_read() and this CPU will have done an
-	 * atomic_write(). That handshake is enough to acquire the page table
-	 * writes from the other CPU.
-	 *
-	 * All command execution has a dma_wmb() to release all the in-memory
-	 * structures written by this CPU, that barrier must also release the
-	 * writes acquired from all the other CPUs too.
-	 *
-	 * There are other barriers and atomics on this path, but the above is
-	 * the essential mechanism for ensuring that HW sees the page table
-	 * writes from another CPU before it executes the IOTLB invalidation.
-	 */
 	arm_smmu_domain_inv(smmu_domain);
 }
 
@@ -4309,6 +4294,22 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 
+	/*
+	 * If the DMA API is running in non-strict mode then another CPU could
+	 * have changed the page table and not invoked any flush op. Instead the
+	 * other CPU will do an atomic_read() and this CPU will have done an
+	 * atomic_write(). That handshake is enough to acquire the page table
+	 * writes from the other CPU.
+	 *
+	 * All command execution has a dma_wmb() to release all the in-memory
+	 * structures written by this CPU, that barrier must also release the
+	 * writes acquired from all the other CPUs too.
+	 *
+	 * There are other barriers and atomics on this path, but the above is
+	 * the essential mechanism for ensuring that HW sees the page table
+	 * writes from another CPU before it executes the IOTLB invalidation.
+	 */
+
 	if (smmu_domain->smmu)
 		arm_smmu_tlb_inv_context(smmu_domain);
 }
-- 
2.43.0

