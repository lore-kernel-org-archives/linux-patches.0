Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214858;
	b=Jvb9e/ECrJ0NwYaQvAY1sfjuOtm8uW3R8yXar/oOr4IfYaINJMAnpArItD9zwCuwvBwm
	 FYsVOSkXVRPaonJMhmRfcqlQqjktRIRYFC4otBtXl7/2ed7ZPNBbRbX+RVLCWWHWnoV9G
	 AoSEYXqnZcX/W2xGK5Pttgp6IsPy+gXodOzeTyAuORleCEATow9Bac9todEBhwaWMzHaB
	 4P0Th31Prgw6Lr8Wjrpgr5IbG1cfBfIlfgiKB1nqTrRYX3f7Ef7r42ngNkMG5Zr/tZXn8
	 OSDd+TZ3WjW2Su39poo4HIQIqp3P+ocHKW7Hg0hMGEXGvE+W44tYlVtUFNrTLrADLBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xrmr2QAxpBVGKSvv1F3W4lJQfFI8lil51GMhbnTXLio=;
	b=dACcMfprx1LIC/Gi11RXISppONJZnvo7zHJIgNs60p/13LXJXbDUqL5gkrwu6JykQ6AH
	 UyGhVuzSpcOUvQBHTZtv460CLSb9y9MqEiBSB6ROH+xsQ2ohoVMaKP+2nqeK2OoTOhxAR
	 3GWUXpezMX/7kvGp1KZHs4P8VwZwuwtkOBdFA0WpPfecY+9VSI4f5wXgmlqX2DzV09ysg
	 Am4/whv5IG+1Ph+Aq/AgijKTOhZyEptp4bnvFwyi4tQcMsOTW1v9db5yjEjZolwVVjNjT
	 W93m6p2ZNIL3SoGhPyMJdvvnbBVC1Aaeb7knBiiWj2M+FAAPcexdE87POlc8X8CWIRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zT0kllj8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70062606A31A;
	Wed, 28 Oct 2026 19:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zT0kllj8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5171F01825;
	Wed, 28 Oct 2026 19:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214858;
	bh=xrmr2QAxpBVGKSvv1F3W4lJQfFI8lil51GMhbnTXLio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zT0kllj8Ex2Lg95EKUcFSzLeQtEkVN+caooI8a2DGPwG88G9GVCTVRLJYzc+Y12Bc
	 zk87Iz7mxZVYI+L74ZZFl0YzvwX58botkfCZD/bVbPFgve9JfNsCjCh9aYEueZtM5N
	 /iiV4olDxQMiA3vFnfCAbphBvL8cj1p3v6C30jJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1008/1887] media: hantro: Disable multicore support
Date: Wed, 28 Oct 2026 17:51:44 +0100
Message-ID: <20261028170522.353073361@linuxfoundation.org>
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

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit ccdeb8d57f7fb3e5c05d72cb7dfb9bc78f09f542 ]

Avoid exposing equal Hantro video codecs to userspace. Equal video
codecs allow scheduling work between the cores. For that kernel support
is required, which does not yet exist. Until that is implemented avoid
exposing each core separately to userspace so that multicore can be
added in the future without breaking userspace ABI.

This was written with Rockchip RK3588 in mind (which has 4 Hantro H1
cores), but applies to all SoCs.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: e0203ddf9af7 ("media: verisilicon: Avoid G2 bus error while decoding H.264 and HEVC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/verisilicon/hantro_drv.c   | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/media/platform/verisilicon/hantro_drv.c b/drivers/media/platform/verisilicon/hantro_drv.c
index a35b6ae62d585..092ee1681c3ea 100644
--- a/drivers/media/platform/verisilicon/hantro_drv.c
+++ b/drivers/media/platform/verisilicon/hantro_drv.c
@@ -896,6 +896,49 @@ static const struct media_device_ops hantro_m2m_media_ops = {
 	.req_queue = v4l2_m2m_request_queue,
 };
 
+/*
+ * Some SoCs, like RK3588 have multiple identical Hantro cores, but the
+ * kernel is currently missing support for multi-core handling. Exposing
+ * separate devices for each core to userspace is bad, since that does
+ * not allow scheduling tasks properly (and creates ABI). With this workaround
+ * the driver will only probe for the first core and early exit for the other
+ * cores. Once the driver gains multi-core support, the same technique
+ * for detecting the main core can be used to cluster all cores together.
+ */
+static int hantro_disable_multicore(struct hantro_dev *vpu)
+{
+	struct device_node *node = NULL;
+	const char *compatible;
+	bool is_main_core;
+	int ret;
+
+	/* Intentionally ignores the fallback strings */
+	ret = of_property_read_string(vpu->dev->of_node, "compatible", &compatible);
+	if (ret)
+		return ret;
+
+	/* The first compatible and available node found is considered the main core */
+	do {
+		node = of_find_compatible_node(node, NULL, compatible);
+		if (of_device_is_available(node))
+			break;
+	} while (node);
+
+	if (!node)
+		return -EINVAL;
+
+	is_main_core = (vpu->dev->of_node == node);
+
+	of_node_put(node);
+
+	if (!is_main_core) {
+		dev_info(vpu->dev, "missing multi-core support, ignoring this instance\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 static int hantro_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match;
@@ -916,6 +959,10 @@ static int hantro_probe(struct platform_device *pdev)
 	match = of_match_node(of_hantro_match, pdev->dev.of_node);
 	vpu->variant = match->data;
 
+	ret = hantro_disable_multicore(vpu);
+	if (ret)
+		return ret;
+
 	/*
 	 * Support for nxp,imx8mq-vpu is kept for backwards compatibility
 	 * but it's deprecated. Please update your DTS file to use
-- 
2.53.0



