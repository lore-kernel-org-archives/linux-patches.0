Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054018;
	b=GWsYIhzkKorB+m2bDaab1jVCgclTFhqDUXnMNjs49Xl1vdYaTmVdywNBmS+BOqB79ZOB
	 0Le2GvNiLAJmtnQGpheN7YjruEqwc4/sj3dy8Vn7tOc7r0Z/UG8Ivv7gcHHGt2gnGM9aD
	 qBRafoveTgbsxSwLygNCfv3RFTKXNm1ou3j5UtJuHZB0ACe0ooexanNwIozgg3IsXE0Bb
	 AOAMCc+6gFMmY8Ly2da+xbDfgf6jmbZbStnfFhcO46UyD5JeW40oWk31Xs1gmWrzi7+L+
	 DB8gmKjpp5euh00lCGjLfVnRJZTP3Sx5aLyeQYwa2dWuCi1IJi2HOjVqBdR1/RQziqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+ee6Nc/89qgBbky58daqRTz9n5JnwrwziL9fD8DejxQ=;
	b=zlfsCJG29QQ/yH8Ogk1wxYArGr1rrKrdpFEzGd6MBjaQAi2GE+2eZaA+Q95hliTf5t2J
	 CR4OTFvnwVtOFaoqo9Bbeq5EgSSv6xukvOh3ziD6G8yOpjUuwnYcxgbT0LfrNP372oWm1
	 TE899P7nv5+T2YpMOw17dVT3clL7jMvPSpqwMwzmRurtWWut0DIYOSi3jSyifLfpMeVu3
	 iZy5vx7c7V1KkzR4wa6ZM61DkgYf3C4zNsYyzi+P8G8SGvQmfN0JQG0cHOmMEGVDtfjQV
	 88KIH9iqfh6iqbw32er7XrUl0EkF39J8ITXUKe9tnmDx7TkiKs6f3F3BqkRvtPn9ODA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zo9INoTd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE6A3606A31C;
	Thu, 19 Nov 2026 02:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zo9INoTd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9391F000C9;
	Thu, 19 Nov 2026 02:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054018;
	bh=+ee6Nc/89qgBbky58daqRTz9n5JnwrwziL9fD8DejxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zo9INoTdRudh1AN4JRAPwCuNQkg1MJRkdWVp6Wco3byaqo26ZM+yUq6IWMyhjJZVJ
	 POrRLOuxdIhyxkCZ7Ng/XARgovCJBn3AzMPlQKW8kyEQucRw4csCgkJ9Il/UO1anDf
	 Rom47sKF4e7wccauSPy0nABHNjvPk0uH5A16xn3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Foss <robert.foss@linaro.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1127/2214] media: camss: vfe: Remove vfe_hw_version_read() argument
Date: Wed, 18 Nov 2026 15:46:43 +0100
Message-ID: <20261118150057.155474540@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Foss <robert.foss@linaro.org>

[ Upstream commit 5ad5866737991d83cb4a74a02d0c32a18adb9246 ]

The device argument is not needed, since it is accessible through
the vfe_device argument already.

Signed-off-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: e5d4b0e69a40 ("media: qcom: camss: vfe: Fix VFE reset while another line is streaming")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-vfe-170.c | 5 +++--
 drivers/media/platform/qcom/camss/camss-vfe-4-1.c | 4 ++--
 drivers/media/platform/qcom/camss/camss-vfe-4-7.c | 4 ++--
 drivers/media/platform/qcom/camss/camss-vfe-4-8.c | 4 ++--
 drivers/media/platform/qcom/camss/camss-vfe.c     | 2 +-
 drivers/media/platform/qcom/camss/camss-vfe.h     | 2 +-
 6 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe-170.c b/drivers/media/platform/qcom/camss/camss-vfe-170.c
index 9a1f2a6bf3fa7..ad3c375a33fbf 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-170.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-170.c
@@ -176,7 +176,7 @@
 #define VFE_BUS_WM_FRAME_INC(n)			(0x2258 + (n) * 0x100)
 #define VFE_BUS_WM_BURST_LIMIT(n)		(0x225c + (n) * 0x100)
 
-static void vfe_hw_version_read(struct vfe_device *vfe, struct device *dev)
+static void vfe_hw_version_read(struct vfe_device *vfe)
 {
 	u32 hw_version = readl_relaxed(vfe->base + VFE_HW_VERSION);
 
@@ -184,7 +184,8 @@ static void vfe_hw_version_read(struct vfe_device *vfe, struct device *dev)
 	u32 rev = (hw_version >> 16) & 0xFFF;
 	u32 step = hw_version & 0xFFFF;
 
-	dev_dbg(dev, "VFE HW Version = %u.%u.%u\n", gen, rev, step);
+	dev_dbg(vfe->camss->dev, "VFE HW Version = %u.%u.%u\n",
+		gen, rev, step);
 }
 
 static inline void vfe_reg_clr(struct vfe_device *vfe, u32 reg, u32 clr_bits)
diff --git a/drivers/media/platform/qcom/camss/camss-vfe-4-1.c b/drivers/media/platform/qcom/camss/camss-vfe-4-1.c
index 53c56a8d45458..614c266e8cd1f 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-4-1.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-4-1.c
@@ -210,11 +210,11 @@
 #define MSM_VFE_VFE0_UB_SIZE 1023
 #define MSM_VFE_VFE0_UB_SIZE_RDI (MSM_VFE_VFE0_UB_SIZE / 3)
 
-static void vfe_hw_version_read(struct vfe_device *vfe, struct device *dev)
+static void vfe_hw_version_read(struct vfe_device *vfe)
 {
 	u32 hw_version = readl_relaxed(vfe->base + VFE_0_HW_VERSION);
 
-	dev_dbg(dev, "VFE HW Version = 0x%08x\n", hw_version);
+	dev_dbg(vfe->camss->dev, "VFE HW Version = 0x%08x\n", hw_version);
 }
 
 static u16 vfe_get_ub_size(u8 vfe_id)
diff --git a/drivers/media/platform/qcom/camss/camss-vfe-4-7.c b/drivers/media/platform/qcom/camss/camss-vfe-4-7.c
index 13f0fa6a7d60c..aa175e0f6331c 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-4-7.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-4-7.c
@@ -254,11 +254,11 @@
 #define MSM_VFE_VFE1_UB_SIZE 1535
 #define MSM_VFE_VFE1_UB_SIZE_RDI (MSM_VFE_VFE1_UB_SIZE / 3)
 
-static void vfe_hw_version_read(struct vfe_device *vfe, struct device *dev)
+static void vfe_hw_version_read(struct vfe_device *vfe)
 {
 	u32 hw_version = readl_relaxed(vfe->base + VFE_0_HW_VERSION);
 
-	dev_dbg(dev, "VFE HW Version = 0x%08x\n", hw_version);
+	dev_dbg(vfe->camss->dev, "VFE HW Version = 0x%08x\n", hw_version);
 }
 
 static u16 vfe_get_ub_size(u8 vfe_id)
diff --git a/drivers/media/platform/qcom/camss/camss-vfe-4-8.c b/drivers/media/platform/qcom/camss/camss-vfe-4-8.c
index 03f92a6737b0f..b897f5163c5da 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-4-8.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-4-8.c
@@ -247,11 +247,11 @@
 #define MSM_VFE_VFE1_UB_SIZE 1535
 #define MSM_VFE_VFE1_UB_SIZE_RDI (MSM_VFE_VFE1_UB_SIZE / 3)
 
-static void vfe_hw_version_read(struct vfe_device *vfe, struct device *dev)
+static void vfe_hw_version_read(struct vfe_device *vfe)
 {
 	u32 hw_version = readl_relaxed(vfe->base + VFE_0_HW_VERSION);
 
-	dev_dbg(dev, "VFE HW Version = 0x%08x\n", hw_version);
+	dev_dbg(vfe->camss->dev, "VFE HW Version = 0x%08x\n", hw_version);
 }
 
 static inline void vfe_reg_clr(struct vfe_device *vfe, u32 reg, u32 clr_bits)
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index 72a26dea84212..8aeba618ad380 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -1300,7 +1300,7 @@ int msm_vfe_subdev_init(struct camss *camss, struct vfe_device *vfe,
 		return -EINVAL;
 	}
 	vfe->ops->subdev_init(dev, vfe);
-	vfe->ops->hw_version_read(vfe, dev);
+	vfe->ops->hw_version_read(vfe);
 
 	/* Memory */
 
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.h b/drivers/media/platform/qcom/camss/camss-vfe.h
index 844b9275031d9..cca251816d284 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.h
+++ b/drivers/media/platform/qcom/camss/camss-vfe.h
@@ -103,7 +103,7 @@ struct vfe_device;
 struct vfe_hw_ops {
 	void (*enable_irq_common)(struct vfe_device *vfe);
 	void (*global_reset)(struct vfe_device *vfe);
-	void (*hw_version_read)(struct vfe_device *vfe, struct device *dev);
+	void (*hw_version_read)(struct vfe_device *vfe);
 	irqreturn_t (*isr)(int irq, void *dev);
 	void (*isr_read)(struct vfe_device *vfe, u32 *value0, u32 *value1);
 	void (*pm_domain_off)(struct vfe_device *vfe);
-- 
2.53.0



