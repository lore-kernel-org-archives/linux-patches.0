Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214864;
	b=mjP2toQRfdwvG5KapFqKG4VV5KIRrI2qtdKKZ6duovurpl7346QY3jdtDJnZN7+bxmDg
	 81Fm0hUojgNlyo+pnGS4R+Z8mLH+GCZLp2I/o7LLPlex6e7+FMu7K8tE7BgIfCInTHLgC
	 jddoH0KBWDJ2uxRgAX46QLLh61eAB0yKsJQu8mL78EsLD0kLjzTZqrKaCuh7TmPwF8AG+
	 yTRGdJrmQIcLEwdh5ZUZONn7PQG/S3kvSeR+DvS8SXoqFwlLFhAxAR6WarGesfErePyZ4
	 TaqtP4EgkyDEKFPxOOWdSQarBFo67+TJuuf0SMpy36CnVoy1qXRejw4NVq0GCXmk/+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214864;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CRIRrXCPaow1McgmTvoz80cHC41hCuOYBrTV8DXnpxE=;
	b=JET7wd23YkXugzgCr4K3E+DvFxKDXYEForz0DhQmuZWZ0AnnAs+e/I5/zTrADTBiJGl2
	 rc7mso7WibnjXjofA4y/G100OGn3Y7+tc8+LUz26rJRZqQfE/KDEDuxLsjIOfGLeJNekX
	 yW73E0xZeuUhPiOz9vMzislEhVREkDoA5SkKKEZVxMfph7mTP9IMNv2PCN1Xy36vDcTKk
	 onnVbvl9l9CIQj1NZIRdtHctyOTzY4t6FsIa8rb7BF2K/YG/sY3ItS2K6BzSCCaHrpaPp
	 6w1ORyxo8+n4RYp8rJRiQ+A21yq5Trg3rhY1OCNRkSQ8s5yfDEPqzsJWoCwVDvMVTxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pYj5oxnF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB67606A329;
	Wed, 28 Oct 2026 19:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pYj5oxnF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD8C1F01825;
	Wed, 28 Oct 2026 19:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214864;
	bh=CRIRrXCPaow1McgmTvoz80cHC41hCuOYBrTV8DXnpxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pYj5oxnFSlodjYfvlYqqwjnxt17SNk9eVmEJSjK3NBjMT4sQRrqjqRivJYtwqrg5L
	 juTZQoKnyvbGFVUBPqzw/HkbQA+j0g1xa7UPA6UWEjRNSR4jEtcW8ieum0A+esCnHF
	 Nd4CltLk3IN4S9VNtJ5nDlogmdK6SrJwDijhKxCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1010/1887] media: verisilicon: Avoid G2 bus error while decoding H.264 and HEVC
Date: Wed, 28 Oct 2026 17:51:46 +0100
Message-ID: <20261028170522.399131320@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@oss.nxp.com>

[ Upstream commit e0203ddf9af7c8e170e1e99ce83b4dc07f0cd765 ]

For the i.MX8MQ platform, there is a hardware limitation: the g1 VPU and
g2 VPU cannot decode simultaneously; otherwise, it will cause below bus
error and produce corrupted pictures, even potentially lead to system hang.

[  110.527986] hantro-vpu 38310000.video-codec: frame decode timed out.
[  110.583517] hantro-vpu 38310000.video-codec: bus error detected.

Therefore, it is necessary to ensure that g1 and g2 operate alternately.
This allows for successful multi-instance decoding of H.264 and HEVC.

To achieve this, g1 and g2 share the same v4l2_m2m_dev, and then the
v4l2_m2m_dev can handle the scheduling.

Fixes: cb5dd5a0fa518 ("media: hantro: Introduce G2/HEVC decoder")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Co-developed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/verisilicon/hantro.h   |  2 +
 .../media/platform/verisilicon/hantro_drv.c   | 42 +++++++++++++++++--
 .../media/platform/verisilicon/imx8m_vpu_hw.c |  8 ++++
 3 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/verisilicon/hantro.h b/drivers/media/platform/verisilicon/hantro.h
index 2989ebc631cc0..fca6ef4a11665 100644
--- a/drivers/media/platform/verisilicon/hantro.h
+++ b/drivers/media/platform/verisilicon/hantro.h
@@ -76,6 +76,7 @@ struct hantro_irq {
  * @double_buffer:		core needs double buffering
  * @legacy_regs:		core uses legacy register set
  * @late_postproc:		postproc must be set up at the end of the job
+ * @shared_devices:		an array of device ids that cannot run concurrently
  */
 struct hantro_variant {
 	unsigned int enc_offset;
@@ -100,6 +101,7 @@ struct hantro_variant {
 	unsigned int double_buffer : 1;
 	unsigned int legacy_regs : 1;
 	unsigned int late_postproc : 1;
+	const struct of_device_id *shared_devices;
 };
 
 /**
diff --git a/drivers/media/platform/verisilicon/hantro_drv.c b/drivers/media/platform/verisilicon/hantro_drv.c
index 092ee1681c3ea..29baefc93628c 100644
--- a/drivers/media/platform/verisilicon/hantro_drv.c
+++ b/drivers/media/platform/verisilicon/hantro_drv.c
@@ -13,6 +13,7 @@
 #include <linux/clk.h>
 #include <linux/module.h>
 #include <linux/of.h>
+#include <linux/of_platform.h>
 #include <linux/platform_device.h>
 #include <linux/pm.h>
 #include <linux/pm_runtime.h>
@@ -939,6 +940,41 @@ static int hantro_disable_multicore(struct hantro_dev *vpu)
 	return 0;
 }
 
+static struct v4l2_m2m_dev *hantro_get_v4l2_m2m_dev(struct hantro_dev *vpu)
+{
+	struct device_node *node;
+	struct hantro_dev *shared_vpu;
+
+	if (!vpu->variant || !vpu->variant->shared_devices)
+		goto init_new_m2m_dev;
+
+	for_each_matching_node(node, vpu->variant->shared_devices) {
+		struct platform_device *pdev;
+		struct v4l2_m2m_dev *m2m_dev;
+
+		pdev = of_find_device_by_node(node);
+		if (!pdev)
+			continue;
+
+		shared_vpu = platform_get_drvdata(pdev);
+		if (IS_ERR_OR_NULL(shared_vpu) || shared_vpu == vpu) {
+			platform_device_put(pdev);
+			continue;
+		}
+
+		v4l2_m2m_get(shared_vpu->m2m_dev);
+		m2m_dev = shared_vpu->m2m_dev;
+		platform_device_put(pdev);
+
+		of_node_put(node);
+
+		return m2m_dev;
+	}
+
+init_new_m2m_dev:
+	return v4l2_m2m_init(&vpu_m2m_ops);
+}
+
 static int hantro_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match;
@@ -1093,7 +1129,7 @@ static int hantro_probe(struct platform_device *pdev)
 	}
 	platform_set_drvdata(pdev, vpu);
 
-	vpu->m2m_dev = v4l2_m2m_init(&vpu_m2m_ops);
+	vpu->m2m_dev = hantro_get_v4l2_m2m_dev(vpu);
 	if (IS_ERR(vpu->m2m_dev)) {
 		v4l2_err(&vpu->v4l2_dev, "Failed to init mem2mem device\n");
 		ret = PTR_ERR(vpu->m2m_dev);
@@ -1134,7 +1170,7 @@ static int hantro_probe(struct platform_device *pdev)
 	hantro_remove_enc_func(vpu);
 err_m2m_rel:
 	media_device_cleanup(&vpu->mdev);
-	v4l2_m2m_release(vpu->m2m_dev);
+	v4l2_m2m_put(vpu->m2m_dev);
 err_v4l2_unreg:
 	v4l2_device_unregister(&vpu->v4l2_dev);
 err_clk_unprepare:
@@ -1157,7 +1193,7 @@ static int hantro_remove(struct platform_device *pdev)
 	hantro_remove_dec_func(vpu);
 	hantro_remove_enc_func(vpu);
 	media_device_cleanup(&vpu->mdev);
-	v4l2_m2m_release(vpu->m2m_dev);
+	v4l2_m2m_put(vpu->m2m_dev);
 	v4l2_device_unregister(&vpu->v4l2_dev);
 	clk_bulk_unprepare(vpu->variant->num_clocks, vpu->clocks);
 	reset_control_assert(vpu->resets);
diff --git a/drivers/media/platform/verisilicon/imx8m_vpu_hw.c b/drivers/media/platform/verisilicon/imx8m_vpu_hw.c
index d89c2c3501aa8..80539f7573c18 100644
--- a/drivers/media/platform/verisilicon/imx8m_vpu_hw.c
+++ b/drivers/media/platform/verisilicon/imx8m_vpu_hw.c
@@ -359,6 +359,12 @@ const struct hantro_variant imx8mq_vpu_variant = {
 	.num_regs = ARRAY_SIZE(imx8mq_reg_names)
 };
 
+static const struct of_device_id imx8mq_vpu_shared_resources[] __initconst = {
+	{ .compatible = "nxp,imx8mq-vpu-g1", },
+	{ .compatible = "nxp,imx8mq-vpu-g2", },
+	{ /* sentinel */ }
+};
+
 const struct hantro_variant imx8mq_vpu_g1_variant = {
 	.dec_fmts = imx8m_vpu_dec_fmts,
 	.num_dec_fmts = ARRAY_SIZE(imx8m_vpu_dec_fmts),
@@ -372,6 +378,7 @@ const struct hantro_variant imx8mq_vpu_g1_variant = {
 	.num_irqs = ARRAY_SIZE(imx8mq_irqs),
 	.clk_names = imx8mq_g1_clk_names,
 	.num_clocks = ARRAY_SIZE(imx8mq_g1_clk_names),
+	.shared_devices = imx8mq_vpu_shared_resources,
 };
 
 const struct hantro_variant imx8mq_vpu_g2_variant = {
@@ -387,6 +394,7 @@ const struct hantro_variant imx8mq_vpu_g2_variant = {
 	.num_irqs = ARRAY_SIZE(imx8mq_g2_irqs),
 	.clk_names = imx8mq_g2_clk_names,
 	.num_clocks = ARRAY_SIZE(imx8mq_g2_clk_names),
+	.shared_devices = imx8mq_vpu_shared_resources,
 };
 
 const struct hantro_variant imx8mm_vpu_g1_variant = {
-- 
2.53.0



