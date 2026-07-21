Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7795F46EF84;
	Tue, 21 Jul 2026 18:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659779; cv=none; b=GQqz4YCJDzCHsl5K2JnoLUahokq0njshRgnaL7DT5eqsI/zF1bgA1/WDZq/Ilv9ISR6USV/GjF1bP7pOzL/phCmvQcLQUUxCTigTVCLgzQmNKMwNq/pTVFugctpwVUzfTPEdXzihuY2CVYZ0rGiwyDolHlw2s5SgaydAxM0jDIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659779; c=relaxed/simple;
	bh=zufJseEQUMwieiqvkDayKC/ixkrOTR04TfkysHEWbVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEZ/24BTwIjfAsQKPPV+rLt6HRilNkDYWN6GFKOH1MwIrUNhFn/snTm3+Ghr4Mp6pFFLmtGSzJ24cj3XRvIhf3GcKwIgxO+R2mBfFMbFLKE5+Bg2Yy0IzwlM4KYyVMYT7llV0DZAZqN5cMVbhG3arVtGKPqNx10WtwQrn6CNPf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IGxEiSyr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IGxEiSyr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4DB81F00A3A;
	Tue, 21 Jul 2026 18:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659778;
	bh=nIdMSQJ6lvxli6Q3hlAB828DqrPAJs7M7VSHc62Ogps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IGxEiSyrvMiq1voa9bl3v4GspOzQwIeV8VFUZZ/DetY/c4ou0kTgUtczb9Zt7LvPi
	 yb3J9e7dNG6N0qWGix5T94KWLbMgA87aa+maMAC85LDadP1ZqaVBC1a0ucge0pf924
	 wChkky4MlJw/FRrfZqpCk1ZZHoEvp/Ii7+hpdcX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Mastro <amastro@fb.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0728/2077] iommufd: Clarify IOAS_MAP_FILE dma-buf support
Date: Tue, 21 Jul 2026 17:06:41 +0200
Message-ID: <20260721152609.970135207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Mastro <amastro@fb.com>

[ Upstream commit 298ab7e6f1637cec44163f52e84e2030ec16ed9d ]

IOMMU_IOAS_MAP_FILE is documented as mapping a memfd, but the
implementation first tries to resolve the fd as a dma-buf and has a
special path for supported dma-buf exporters. In particular, VFIO PCI
dma-bufs exported through VFIO_DEVICE_FEATURE_DMA_BUF can be mapped when
they describe a single DMA range.

Update the UAPI comment so userspace understands that certain kinds of
dma-buf are supported in addition to memfd.

Fixes: 44ebaa1744fd ("iommufd: Accept a DMABUF through IOMMU_IOAS_MAP_FILE")
Link: https://patch.msgid.link/r/20260610-tmp-v1-1-b8ccbf557391@fb.com
Signed-off-by: Alex Mastro <amastro@fb.com>
Assisted-by: Codex:gpt-5.5-high
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/iommufd.h | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index e998dfbd696031..0425d452d41ed6 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -224,13 +224,17 @@ struct iommu_ioas_map {
  * @size: sizeof(struct iommu_ioas_map_file)
  * @flags: same as for iommu_ioas_map
  * @ioas_id: same as for iommu_ioas_map
- * @fd: the memfd to map
- * @start: byte offset from start of file to map from
+ * @fd: the memfd or supported dma-buf file to map
+ * @start: byte offset from start of the file to map from
  * @length: same as for iommu_ioas_map
  * @iova: same as for iommu_ioas_map
  *
- * Set an IOVA mapping from a memfd file.  All other arguments and semantics
- * match those of IOMMU_IOAS_MAP.
+ * Set an IOVA mapping from a memfd file. On kernels with dma-buf support,
+ * supported dma-buf files may also be accepted. This is not a generic
+ * dma-buf import path; currently supported dma-bufs include single-range
+ * VFIO PCI dma-bufs exported through VFIO_DEVICE_FEATURE_DMA_BUF, and
+ * other dma-bufs may be rejected. All other arguments and semantics match
+ * those of IOMMU_IOAS_MAP.
  */
 struct iommu_ioas_map_file {
 	__u32 size;
-- 
2.53.0



