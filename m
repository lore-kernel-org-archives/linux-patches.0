Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054021;
	b=d3PZHEVPP7IXeEAxNRS1piWO+AaN8kybEECLrzjIQ3kZ1fm2uTdNOjwuGRACkktlni4Q
	 gjNBUZBmHMFRxIsR9343TFBs9CxAdtcSTFpCaIjqtWunqGFW2uBEeOxfm6GAfcbUQp/I9
	 91eodH4egIddlk79MSVM6FcDPaW7ilGW6kAw4STJf18vCA+FytbCVfXLCZ1LQGYjKYwkT
	 FgM4DcxhGSrpUBLFkYTxG7Fqmw/Hc2UVhiTM31m2YhjDuc3s4Ct68ZuPoqi8HLDWQUED9
	 97UCLaEyfEIAa3fYmEgDFZHYPB4ex0HEWjbuR7SRPDM60KJtxfWbgd3GkUkFg+nhAHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H3d24QQcJYRb47pRo1CuIEzlc9oQulW05hHCWUkTeis=;
	b=ipPi6UqbqF2UzEM/MxdBW26NgEUJepWr3GbwVmNrMpuyqPAKSlsYI5g9cdeWViEkgS0o
	 3db7YfgAG3bPknhqvLbfm1zV8FqhJ+PxUt5J0nEfgGJkLElXCI5/s2mbOdC9ta2WKFsYv
	 vHXMCIh4I4wqtA8bd3+mDix/Dk/LEyYKGTsJJaUXyxLd8/wc6e+uJEbC/zOUhu8qqgZ4I
	 nOubgnPG6ukGJTr0So/+RjLfGqDTxNhPsD57GVknyfTr2DuFEFevEhBW15EYvyO0+bQLK
	 YNGWM0qBRk2TcL6FOijivwsiCIfzjwQi6uZhLoY0RRStwsPY++H+TncuOawNGbxFMiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xWrEMjMp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F10E606A32C;
	Thu, 19 Nov 2026 02:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xWrEMjMp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E74341F000C7;
	Thu, 19 Nov 2026 02:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054021;
	bh=H3d24QQcJYRb47pRo1CuIEzlc9oQulW05hHCWUkTeis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xWrEMjMp53Kw7a4ThjVYXQY/6FyducD3jyCVSTz6Y0YtZNSsbSoiG18C8tQ3EuwXY
	 3AMcsMa2dcfMYc/D0nNS6/r/bwCPcJtbn1A8LK/bOM+Ii0bhsj1JND2ORsyCNjWG7D
	 PjMo4Zo2PVXj22L7zXBoHpFHr7C42amKmvQcbtww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Foss <robert.foss@linaro.org>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1128/2214] media: camss: vfe: Rework vfe_hw_version_read() function definition
Date: Wed, 18 Nov 2026 15:46:44 +0100
Message-ID: <20261118150057.192732669@linuxfoundation.org>
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

[ Upstream commit d2e86540366e1701baf852ee0301323ff113459c ]

Expose the VFE version by returning the value read from the HW_VERSION
register.

Secondly, change the name of this function to conform with the CSID
equivalent.

Signed-off-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: e5d4b0e69a40 ("media: qcom: camss: vfe: Fix VFE reset while another line is streaming")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-vfe-170.c | 6 ++++--
 drivers/media/platform/qcom/camss/camss-vfe-4-1.c | 6 ++++--
 drivers/media/platform/qcom/camss/camss-vfe-4-7.c | 6 ++++--
 drivers/media/platform/qcom/camss/camss-vfe-4-8.c | 6 ++++--
 drivers/media/platform/qcom/camss/camss-vfe.c     | 2 +-
 drivers/media/platform/qcom/camss/camss-vfe.h     | 2 +-
 6 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe-170.c b/drivers/media/platform/qcom/camss/camss-vfe-170.c
index ad3c375a33fbf..e2ca0aec3a697 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-170.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-170.c
@@ -176,7 +176,7 @@
 #define VFE_BUS_WM_FRAME_INC(n)			(0x2258 + (n) * 0x100)
 #define VFE_BUS_WM_BURST_LIMIT(n)		(0x225c + (n) * 0x100)
 
-static void vfe_hw_version_read(struct vfe_device *vfe)
+static u32 vfe_hw_version(struct vfe_device *vfe)
 {
 	u32 hw_version = readl_relaxed(vfe->base + VFE_HW_VERSION);
 
@@ -186,6 +186,8 @@ static void vfe_hw_version_read(struct vfe_device *vfe)
 
 	dev_dbg(vfe->camss->dev, "VFE HW Version = %u.%u.%u\n",
 		gen, rev, step);
+
+	return hw_version;
 }
 
 static inline void vfe_reg_clr(struct vfe_device *vfe, u32 reg, u32 clr_bits)
@@ -745,7 +747,7 @@ static void vfe_subdev_init(struct device *dev, struct vfe_device *vfe)
 
 const struct vfe_hw_ops vfe_ops_170 = {
 	.global_reset = vfe_global_reset,
-	.hw_version_read = vfe_hw_version_read,
+	.hw_version = vfe_hw_version,
 	.isr_read = vfe_isr_read,
 	.isr = vfe_isr,
 	.pm_domain_off = vfe_pm_domain_off,
diff --git a/drivers/media/platform/qcom/camss/camss-vfe-4-1.c b/drivers/media/platform/qcom/camss/camss-vfe-4-1.c
index 614c266e8cd1f..7b7c9a0aaab28 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-4-1.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-4-1.c
@@ -210,11 +210,13 @@
 #define MSM_VFE_VFE0_UB_SIZE 1023
 #define MSM_VFE_VFE0_UB_SIZE_RDI (MSM_VFE_VFE0_UB_SIZE / 3)
 
-static void vfe_hw_version_read(struct vfe_device *vfe)
+static u32 vfe_hw_version(struct vfe_device *vfe)
 {
 	u32 hw_version = readl_relaxed(vfe->base + VFE_0_HW_VERSION);
 
 	dev_dbg(vfe->camss->dev, "VFE HW Version = 0x%08x\n", hw_version);
+
+	return hw_version;
 }
 
 static u16 vfe_get_ub_size(u8 vfe_id)
@@ -1004,7 +1006,7 @@ static void vfe_subdev_init(struct device *dev, struct vfe_device *vfe)
 
 const struct vfe_hw_ops vfe_ops_4_1 = {
 	.global_reset = vfe_global_reset,
-	.hw_version_read = vfe_hw_version_read,
+	.hw_version = vfe_hw_version,
 	.isr_read = vfe_isr_read,
 	.isr = vfe_isr,
 	.pm_domain_off = vfe_pm_domain_off,
diff --git a/drivers/media/platform/qcom/camss/camss-vfe-4-7.c b/drivers/media/platform/qcom/camss/camss-vfe-4-7.c
index aa175e0f6331c..2836b12ec9891 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-4-7.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-4-7.c
@@ -254,11 +254,13 @@
 #define MSM_VFE_VFE1_UB_SIZE 1535
 #define MSM_VFE_VFE1_UB_SIZE_RDI (MSM_VFE_VFE1_UB_SIZE / 3)
 
-static void vfe_hw_version_read(struct vfe_device *vfe)
+static u32 vfe_hw_version(struct vfe_device *vfe)
 {
 	u32 hw_version = readl_relaxed(vfe->base + VFE_0_HW_VERSION);
 
 	dev_dbg(vfe->camss->dev, "VFE HW Version = 0x%08x\n", hw_version);
+
+	return hw_version;
 }
 
 static u16 vfe_get_ub_size(u8 vfe_id)
@@ -1196,7 +1198,7 @@ static void vfe_subdev_init(struct device *dev, struct vfe_device *vfe)
 
 const struct vfe_hw_ops vfe_ops_4_7 = {
 	.global_reset = vfe_global_reset,
-	.hw_version_read = vfe_hw_version_read,
+	.hw_version = vfe_hw_version,
 	.isr_read = vfe_isr_read,
 	.isr = vfe_isr,
 	.pm_domain_off = vfe_pm_domain_off,
diff --git a/drivers/media/platform/qcom/camss/camss-vfe-4-8.c b/drivers/media/platform/qcom/camss/camss-vfe-4-8.c
index b897f5163c5da..19519234f727c 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-4-8.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-4-8.c
@@ -247,11 +247,13 @@
 #define MSM_VFE_VFE1_UB_SIZE 1535
 #define MSM_VFE_VFE1_UB_SIZE_RDI (MSM_VFE_VFE1_UB_SIZE / 3)
 
-static void vfe_hw_version_read(struct vfe_device *vfe)
+static u32 vfe_hw_version(struct vfe_device *vfe)
 {
 	u32 hw_version = readl_relaxed(vfe->base + VFE_0_HW_VERSION);
 
 	dev_dbg(vfe->camss->dev, "VFE HW Version = 0x%08x\n", hw_version);
+
+	return hw_version;
 }
 
 static inline void vfe_reg_clr(struct vfe_device *vfe, u32 reg, u32 clr_bits)
@@ -1180,7 +1182,7 @@ static void vfe_subdev_init(struct device *dev, struct vfe_device *vfe)
 
 const struct vfe_hw_ops vfe_ops_4_8 = {
 	.global_reset = vfe_global_reset,
-	.hw_version_read = vfe_hw_version_read,
+	.hw_version = vfe_hw_version,
 	.isr_read = vfe_isr_read,
 	.isr = vfe_isr,
 	.pm_domain_off = vfe_pm_domain_off,
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index 8aeba618ad380..ce8c53f07ea70 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -1300,7 +1300,7 @@ int msm_vfe_subdev_init(struct camss *camss, struct vfe_device *vfe,
 		return -EINVAL;
 	}
 	vfe->ops->subdev_init(dev, vfe);
-	vfe->ops->hw_version_read(vfe);
+	vfe->ops->hw_version(vfe);
 
 	/* Memory */
 
diff --git a/drivers/media/platform/qcom/camss/camss-vfe.h b/drivers/media/platform/qcom/camss/camss-vfe.h
index cca251816d284..f166d176cb771 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.h
+++ b/drivers/media/platform/qcom/camss/camss-vfe.h
@@ -103,7 +103,7 @@ struct vfe_device;
 struct vfe_hw_ops {
 	void (*enable_irq_common)(struct vfe_device *vfe);
 	void (*global_reset)(struct vfe_device *vfe);
-	void (*hw_version_read)(struct vfe_device *vfe);
+	u32 (*hw_version)(struct vfe_device *vfe);
 	irqreturn_t (*isr)(int irq, void *dev);
 	void (*isr_read)(struct vfe_device *vfe, u32 *value0, u32 *value1);
 	void (*pm_domain_off)(struct vfe_device *vfe);
-- 
2.53.0



