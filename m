Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2076.outbound.protection.outlook.com [40.107.220.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404E41E103B;
	Wed,  9 Oct 2024 16:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728491973; cv=fail; b=YS21hbYPl3fWUC/1/y/muvVkqtwUfGKoS2YhBBRQ3DYrvuUrBPvQMHsCvXWAEYFLMsQT2tPSbVB2oGcUifmEyOd2Vmnkz64jLLIoIJwdcEyM9o76sPsxk6g5dmPiTWUrmu+U/I7cdRE+S59VkPVvVRvC4uKCRxzUcTzdHyI1Z70=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728491973; c=relaxed/simple;
	bh=WHY0ugQOQc57h2ruy5QsClqDYeuYPth4biOz6N5nYOE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ceyCUOvzvev6rndeOeikt7Cb/ukO1KJKC0NvpQ46HJPc95A647vp4Fe0OYuYDno+kRnHRC2g+Ib6z/uT+XnPSxGq2iDYNgZthKW1rP0jt2e3SElu63VNEYrTKO+aD2NnZVXLLUtM6B96RaWGFjdRI9dr8FwOVTLxJFJgdCrFUKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QjYdkPw3; arc=fail smtp.client-ip=40.107.220.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QjYdkPw3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LaFtw89AcmEZOHPs20brj+2z12qL7MpFLD8SNCGIJyF5V49BHAUqedm5dyhs3AcBOBb/1xs9ylh3JD0i0lZZo5i6IYmhLgBGRGoXQC+3jkhROQPzSMHvT3r0LFnxWTwHWp57C+aNOfoleMO5VGMduDt6MUbytQ2mzHjvT+yyGcL5Qi77AtvjP2jVEiTRvOtZwMHtYG4nhYb6jI19cHukyiQmNfBw9PPEz4q2UD4gY4w6D2HQCLNhmo05xjiR1fTb9xhbWaPT2QBNDBqaIgwBApe5fUcaFU0n3c3UtGM+l6ijrdCwjjYfIAwVYdSsvUtvNn6LYJvvrcaW+U2hANf25g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=POe16X6GwCo2gRYg7xg4TtCfWFBZbXsj/TKr5W1vlNg=;
 b=skHIzhhXey2eNLFW/c3m6B44tlILswtN7qxBJU9FIl/KNPhtZ9UgX5ShusoYfy4fNG8JAsL0AjlkX2nqe483MVbLku4ClOK2OTAC/+GPCFFRP1yENY0AvND5mMEhxFvw9hegZuhpZJpWgfO22QtJc/40gR6fDdrfTW8pL1qUoVi9ca0qVaQK/GxyHvvbGURKyXNk32V6KlVLy5pInJ8/75NqYnkMN6CSz1JFIftl3blGVsnnG5lYqYB9nYvPrEa6SAlt3BUjAKAQ1tc36Psf04m8nYIMJnJ0PqHqtTXGUfzeBdBYD3Y4dx6ioEnvgSor1fdA2FgXX0oebFxLVZusjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=POe16X6GwCo2gRYg7xg4TtCfWFBZbXsj/TKr5W1vlNg=;
 b=QjYdkPw3YXxAlnjXwboYvuzS2WPIpjvQ60lwA7w5MuFhVs2eWrXGgrC/QJ2bgaD48piAm+a8wxgTzKp3eEth5mfb6hpnlb9B6YZziRVQa+kz3+9Ef7zOcID0DFiYts4OBW6R/RxyJZ97YionJfQQZAI4m4E6eTE9SAwXseb7hu14EAiu9eNK1fqARQCT5dbcy3kfdXdbe0i91liOeTrhtIY5JGLZfWI4z2XxslJv+tQ5jcRwdYY5jKcw8z84j96YOfkXPM2TGNI4m78EvJ4hQdwcFSaWP4ZVnR/C1PoBsPe5waqY8/ekyP40HjY9uy3LP+KXvPD8y20KrpRDRfT9hA==
Received: from SA1P222CA0119.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c5::18)
 by SA1PR12MB7221.namprd12.prod.outlook.com (2603:10b6:806:2bd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Wed, 9 Oct
 2024 16:39:22 +0000
Received: from SA2PEPF00003F63.namprd04.prod.outlook.com
 (2603:10b6:806:3c5:cafe::45) by SA1P222CA0119.outlook.office365.com
 (2603:10b6:806:3c5::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.17 via Frontend
 Transport; Wed, 9 Oct 2024 16:39:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 SA2PEPF00003F63.mail.protection.outlook.com (10.167.248.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 16:39:22 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 9 Oct 2024
 09:39:12 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Wed, 9 Oct 2024 09:39:11 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Wed, 9 Oct 2024 09:39:10 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>, <will@kernel.org>
CC: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<robin.murphy@arm.com>, <dwmw2@infradead.org>, <baolu.lu@linux.intel.com>,
	<shuah@kernel.org>, <linux-kernel@vger.kernel.org>, <iommu@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kselftest@vger.kernel.org>,
	<eric.auger@redhat.com>, <jean-philippe@linaro.org>, <mdf@kernel.org>,
	<mshavit@google.com>, <shameerali.kolothum.thodi@huawei.com>,
	<smostafa@google.com>, <yi.l.liu@intel.com>, <aik@amd.com>,
	<patches@lists.linux.dev>
Subject: [PATCH v3 12/16] iommufd/selftest: Add vIOMMU coverage for IOMMU_HWPT_INVALIDATE ioctl
Date: Wed, 9 Oct 2024 09:38:24 -0700
Message-ID: <b050efa68fd64cd3880dfb4a2e36d4289f70c036.1728491532.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1728491532.git.nicolinc@nvidia.com>
References: <cover.1728491532.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F63:EE_|SA1PR12MB7221:EE_
X-MS-Office365-Filtering-Correlation-Id: 836f147a-b245-4354-993e-08dce880ee00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?r+MLT17+spxX2L3QYgnK/LC+tx2XvAOgqxvt4F2JTjdcpF6pmElCTzbK1Sbv?=
 =?us-ascii?Q?CqFz4q6uBt5sgFqaaaYV6VblEPGgyoQCTE+7Nqc5ZuOsDTYnhB68gmD9if32?=
 =?us-ascii?Q?XHtNIx4kzUqJXyrfVohU/1D2GVDP6RYsDp+X+xnYIu88QTlKsds0hfjaix+T?=
 =?us-ascii?Q?sKmd6aRzE5eE5IMpEbi+3oXNNg4F7vyB7nwwUkRrpqE4BHQAENjhHu/xcgI0?=
 =?us-ascii?Q?1gbNxszjLD3lDWpIgy19QdR8nioniTwACaEkizG7+cbjwpO8xdeZgO0pJ82D?=
 =?us-ascii?Q?SOgWffAB8Tfi/qILqJo31TJ+Z+t5+hsvVdGG+7Ac+MzZ/ujC/fZpUBluF45z?=
 =?us-ascii?Q?kpCAduh41Yyc6J3BTGlH9qK415Y8DSi6ToatQ+bWrvrlUYUWLMGR+Zj/y8rf?=
 =?us-ascii?Q?IZPhwWH+7udVSRpuS4aq57qloytrG0CThO4sdfYDn57RJQXxfmPGam5EMy/m?=
 =?us-ascii?Q?BCPtBSn2NNAHhQTfFxPrNsXNWp+yiWYPg77bwI5EWK/a7Xi59mvxP4iIWahZ?=
 =?us-ascii?Q?y2kv2czNNFqtNl8m7ttvauAmAlDV6hy86F7uhYfY0UBHHvr7/yHq5m9RML01?=
 =?us-ascii?Q?ECzzbMQQ5YFX1bMmZ9UPBU+f2krQJSH8jZyGT3urMANNz11iiLMqs2VGJoJO?=
 =?us-ascii?Q?pglwlaXTirKafRM5NvLbwAS2hTBM89KiH/FiSauVfinn6+j/XwG14L0xus7e?=
 =?us-ascii?Q?rdF0+t8V4e81NW0nkstA1CUGmLawo52ID/u47CkMDuij/udh1rkuT87OPbF+?=
 =?us-ascii?Q?nzwZLX7Zu6Y0cvoF/nUj45wmFSYNq8zf90N16uUv+yTF5DU7ogZUmvUQLTDk?=
 =?us-ascii?Q?z7o03FMkLwZ3K4DsHVh2+sQB4G+j5Rx3ONEtbZcKq5IED6nYNxRm5Ga4vkY3?=
 =?us-ascii?Q?nbDbYnlGrmCexE4s4mYmG4EHfBlYiYvAQZq3h/oZlzn3wJqteM7TrxxTjyfi?=
 =?us-ascii?Q?b/OPjz4ZGaLzSVETWusujmp4Yb6K9nT3LfuGoqPfZ3pWqVgL4VS8CU/nqaJd?=
 =?us-ascii?Q?Q1FB4LJVAh5NrS8eSjJ2m3EIpU2+rSvD1XFX+ciU1jA2D9BmKt4WK+J9gd8g?=
 =?us-ascii?Q?f59r9bdaSapHMayIg2RiOgJSFULwCFdiQiLi/lpxCpiHdalVVCe5xaaD2IjV?=
 =?us-ascii?Q?vZUoMxMiRy9tkpOFElpU7QwchdZC+YxGeo+L/HCA6hAMzgN/82tmHKWNvR+b?=
 =?us-ascii?Q?++d2ofRy0IYy40L21sU+GwAaXiQWNz/TcTRanKTc3S5FD/+5OuCTXeAamw4x?=
 =?us-ascii?Q?5tSmq+6/o4tAlXlnVP7jnmVOA6nOXv6VlzBYNfQSjnYtkAi7oZXXk2Xy5wYw?=
 =?us-ascii?Q?YCrwmEi9tNuehrJuLvj6G7rl3NLHTwrlml++aU13GvEjbma1Da2BN7mv3VDB?=
 =?us-ascii?Q?QHF9B/B/t7/y+2gO1Ol3gW+Yd8hA?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 16:39:22.4992
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 836f147a-b245-4354-993e-08dce880ee00
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F63.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7221

Add a viommu_cache test function to cover vIOMMU invalidations using the
updated IOMMU_HWPT_INVALIDATE ioctl, which now allows passing in a vIOMMU
via its hwpt_id field.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 tools/testing/selftests/iommu/iommufd_utils.h |  32 ++++
 tools/testing/selftests/iommu/iommufd.c       | 173 ++++++++++++++++++
 2 files changed, 205 insertions(+)

diff --git a/tools/testing/selftests/iommu/iommufd_utils.h b/tools/testing/selftests/iommu/iommufd_utils.h
index b3da8c96a828..29e9cd1fdd82 100644
--- a/tools/testing/selftests/iommu/iommufd_utils.h
+++ b/tools/testing/selftests/iommu/iommufd_utils.h
@@ -289,6 +289,38 @@ static int _test_cmd_hwpt_invalidate(int fd, __u32 hwpt_id, void *reqs,
 					     data_type, lreq, nreqs));   \
 	})
 
+static int _test_cmd_viommu_invalidate(int fd, __u32 viommu_id, void *reqs,
+				       uint32_t data_type, uint32_t lreq,
+				       uint32_t *nreqs)
+{
+	struct iommu_hwpt_invalidate cmd = {
+		.size = sizeof(cmd),
+		.hwpt_id = viommu_id,
+		.data_type = data_type,
+		.data_uptr = (uint64_t)reqs,
+		.entry_len = lreq,
+		.entry_num = *nreqs,
+	};
+	int rc = ioctl(fd, IOMMU_HWPT_INVALIDATE, &cmd);
+	*nreqs = cmd.entry_num;
+	return rc;
+}
+
+#define test_cmd_viommu_invalidate(viommu, reqs, lreq, nreqs)                  \
+	({                                                                     \
+		ASSERT_EQ(0,                                                   \
+			  _test_cmd_viommu_invalidate(self->fd, viommu, reqs,  \
+					IOMMU_VIOMMU_INVALIDATE_DATA_SELFTEST, \
+					lreq, nreqs));                         \
+	})
+#define test_err_viommu_invalidate(_errno, viommu_id, reqs, data_type, lreq,   \
+				 nreqs)                                        \
+	({                                                                     \
+		EXPECT_ERRNO(_errno, _test_cmd_viommu_invalidate(              \
+					     self->fd, viommu_id, reqs,        \
+					     data_type, lreq, nreqs));         \
+	})
+
 static int _test_cmd_access_replace_ioas(int fd, __u32 access_id,
 					 unsigned int ioas_id)
 {
diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index d5c5e3389182..5a41bac3c1ab 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -2495,4 +2495,177 @@ TEST_F(iommufd_viommu, vdevice_alloc)
 	}
 }
 
+TEST_F(iommufd_viommu, vdevice_cache)
+{
+	struct iommu_viommu_invalidate_selftest inv_reqs[2] = {};
+	uint32_t viommu_id = self->viommu_id;
+	uint32_t dev_id = self->device_id;
+	uint32_t vdev_id = 0;
+	uint32_t num_inv;
+
+	if (dev_id) {
+		test_cmd_vdevice_alloc(viommu_id, dev_id, 0x99, &vdev_id);
+
+		test_cmd_dev_check_cache_all(dev_id,
+					     IOMMU_TEST_DEV_CACHE_DEFAULT);
+
+		/* Check data_type by passing zero-length array */
+		num_inv = 0;
+		test_cmd_viommu_invalidate(viommu_id, inv_reqs,
+					   sizeof(*inv_reqs), &num_inv);
+		assert(!num_inv);
+
+		/* Negative test: Invalid data_type */
+		num_inv = 1;
+		test_err_viommu_invalidate(EINVAL, viommu_id, inv_reqs,
+					   IOMMU_VIOMMU_INVALIDATE_DATA_SELFTEST_INVALID,
+					   sizeof(*inv_reqs), &num_inv);
+		assert(!num_inv);
+
+		/* Negative test: structure size sanity */
+		num_inv = 1;
+		test_err_viommu_invalidate(EINVAL, viommu_id, inv_reqs,
+					   IOMMU_VIOMMU_INVALIDATE_DATA_SELFTEST,
+					   sizeof(*inv_reqs) + 1, &num_inv);
+		assert(!num_inv);
+
+		num_inv = 1;
+		test_err_viommu_invalidate(EINVAL, viommu_id, inv_reqs,
+					   IOMMU_VIOMMU_INVALIDATE_DATA_SELFTEST,
+					   1, &num_inv);
+		assert(!num_inv);
+
+		/* Negative test: invalid flag is passed */
+		num_inv = 1;
+		inv_reqs[0].flags = 0xffffffff;
+		inv_reqs[0].vdev_id = 0x99;
+		test_err_viommu_invalidate(EOPNOTSUPP, viommu_id, inv_reqs,
+					   IOMMU_VIOMMU_INVALIDATE_DATA_SELFTEST,
+					   sizeof(*inv_reqs), &num_inv);
+		assert(!num_inv);
+
+		/* Negative test: invalid data_uptr when array is not empty */
+		num_inv = 1;
+		inv_reqs[0].flags = 0;
+		inv_reqs[0].vdev_id = 0x99;
+		test_err_viommu_invalidate(EINVAL, viommu_id, NULL,
+					   IOMMU_VIOMMU_INVALIDATE_DATA_SELFTEST,
+					   sizeof(*inv_reqs), &num_inv);
+		assert(!num_inv);
+
+		/* Negative test: invalid entry_len when array is not empty */
+		num_inv = 1;
+		inv_reqs[0].flags = 0;
+		inv_reqs[0].vdev_id = 0x99;
+		test_err_viommu_invalidate(EINVAL, viommu_id, inv_reqs,
+					   IOMMU_VIOMMU_INVALIDATE_DATA_SELFTEST,
+					   0, &num_inv);
+		assert(!num_inv);
+
+		/* Negative test: invalid cache_id */
+		num_inv = 1;
+		inv_reqs[0].flags = 0;
+		inv_reqs[0].vdev_id = 0x99;
+		inv_reqs[0].cache_id = MOCK_DEV_CACHE_ID_MAX + 1;
+		test_err_viommu_invalidate(EINVAL, viommu_id, inv_reqs,
+					   IOMMU_VIOMMU_INVALIDATE_DATA_SELFTEST,
+					   sizeof(*inv_reqs), &num_inv);
+		assert(!num_inv);
+
+		/* Negative test: invalid vdev_id */
+		num_inv = 1;
+		inv_reqs[0].flags = 0;
+		inv_reqs[0].vdev_id = 0x9;
+		inv_reqs[0].cache_id = 0;
+		test_err_viommu_invalidate(EINVAL, viommu_id, inv_reqs,
+					   IOMMU_VIOMMU_INVALIDATE_DATA_SELFTEST,
+					   sizeof(*inv_reqs), &num_inv);
+		assert(!num_inv);
+
+		/*
+		 * Invalidate the 1st cache entry but fail the 2nd request
+		 * due to invalid flags configuration in the 2nd request.
+		 */
+		num_inv = 2;
+		inv_reqs[0].flags = 0;
+		inv_reqs[0].vdev_id = 0x99;
+		inv_reqs[0].cache_id = 0;
+		inv_reqs[1].flags = 0xffffffff;
+		inv_reqs[1].vdev_id = 0x99;
+		inv_reqs[1].cache_id = 1;
+		test_err_viommu_invalidate(EOPNOTSUPP, viommu_id, inv_reqs,
+					   IOMMU_VIOMMU_INVALIDATE_DATA_SELFTEST,
+					   sizeof(*inv_reqs), &num_inv);
+		assert(num_inv == 1);
+		test_cmd_dev_check_cache(dev_id, 0, 0);
+		test_cmd_dev_check_cache(dev_id, 1,
+					 IOMMU_TEST_DEV_CACHE_DEFAULT);
+		test_cmd_dev_check_cache(dev_id, 2,
+					 IOMMU_TEST_DEV_CACHE_DEFAULT);
+		test_cmd_dev_check_cache(dev_id, 3,
+					 IOMMU_TEST_DEV_CACHE_DEFAULT);
+
+		/*
+		 * Invalidate the 1st cache entry but fail the 2nd request
+		 * due to invalid cache_id configuration in the 2nd request.
+		 */
+		num_inv = 2;
+		inv_reqs[0].flags = 0;
+		inv_reqs[0].vdev_id = 0x99;
+		inv_reqs[0].cache_id = 0;
+		inv_reqs[1].flags = 0;
+		inv_reqs[1].vdev_id = 0x99;
+		inv_reqs[1].cache_id = MOCK_DEV_CACHE_ID_MAX + 1;
+		test_err_viommu_invalidate(EINVAL, viommu_id, inv_reqs,
+					   IOMMU_VIOMMU_INVALIDATE_DATA_SELFTEST,
+					   sizeof(*inv_reqs), &num_inv);
+		assert(num_inv == 1);
+		test_cmd_dev_check_cache(dev_id, 0, 0);
+		test_cmd_dev_check_cache(dev_id, 1,
+					 IOMMU_TEST_DEV_CACHE_DEFAULT);
+		test_cmd_dev_check_cache(dev_id, 2,
+					 IOMMU_TEST_DEV_CACHE_DEFAULT);
+		test_cmd_dev_check_cache(dev_id, 3,
+					 IOMMU_TEST_DEV_CACHE_DEFAULT);
+
+		/* Invalidate the 2nd cache entry and verify */
+		num_inv = 1;
+		inv_reqs[0].flags = 0;
+		inv_reqs[0].vdev_id = 0x99;
+		inv_reqs[0].cache_id = 1;
+		test_cmd_viommu_invalidate(viommu_id, inv_reqs,
+					   sizeof(*inv_reqs), &num_inv);
+		assert(num_inv == 1);
+		test_cmd_dev_check_cache(dev_id, 0, 0);
+		test_cmd_dev_check_cache(dev_id, 1, 0);
+		test_cmd_dev_check_cache(dev_id, 2,
+					 IOMMU_TEST_DEV_CACHE_DEFAULT);
+		test_cmd_dev_check_cache(dev_id, 3,
+					 IOMMU_TEST_DEV_CACHE_DEFAULT);
+
+		/* Invalidate the 3rd and 4th cache entries and verify */
+		num_inv = 2;
+		inv_reqs[0].flags = 0;
+		inv_reqs[0].vdev_id = 0x99;
+		inv_reqs[0].cache_id = 2;
+		inv_reqs[1].flags = 0;
+		inv_reqs[1].vdev_id = 0x99;
+		inv_reqs[1].cache_id = 3;
+		test_cmd_viommu_invalidate(viommu_id, inv_reqs,
+					   sizeof(*inv_reqs), &num_inv);
+		assert(num_inv == 2);
+		test_cmd_dev_check_cache_all(dev_id, 0);
+
+		/* Invalidate all cache entries for nested_dev_id[1] and verify */
+		num_inv = 1;
+		inv_reqs[0].vdev_id = 0x99;
+		inv_reqs[0].flags = IOMMU_TEST_INVALIDATE_FLAG_ALL;
+		test_cmd_viommu_invalidate(viommu_id, inv_reqs,
+					   sizeof(*inv_reqs), &num_inv);
+		assert(num_inv == 1);
+		test_cmd_dev_check_cache_all(dev_id, 0);
+		test_ioctl_destroy(vdev_id);
+	}
+}
+
 TEST_HARNESS_MAIN
-- 
2.43.0

