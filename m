Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827157;
	b=kWEjbZNyqn++TOX/+NaDov2ZGUORec8IYUR0gH21G3BgdUJ+7KqY8CffOK+51G9tk0Qy
	 h7O6zefLFzrfBIUhcvdNGNLqlI7LaZ40Tfpuqq/IFwDuGOJo2w38vlayfcdUnlOm7z+pN
	 Hb4lWsrJ9ACt8w+JIeEN0KDGtXysILt+gjUzi2gu7y6oe8Mg/zz2PQ+uN3VkrY6KhByx4
	 YlX4GWDMwWEYAXxyVIH6sWVqhveXWd/YknUJqFsGWbsbDXYCVrobrS7b9wIOfrZM+PsPf
	 WXsVtsgMSzBl0RjxlgvQE2PowrPXnFLioAIcVQUkTyjP5dABaFXMZhSrzFSBNN+K+8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827157;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bHJ2KI2d+PALIGVD4ybGZs/OpkaAnpNuWJr68RWqxxA=;
	b=xJfvrIAIZzvHudsREshTcvOrgbxDU5iC/Muxil68AiIIg/C4viSF24a1KMmpVISl31sJ
	 8k3uugfnzyyCQy2brIzEPvMN+prs2rF3NbL/MjZFoayvqcqGeh8gEE2wUjwBGn/GxOzM5
	 H3q0PSLx9TI5GMAAGlRBoWAeACeT84qPAfp4seh7nr8Qxm5kTQV2THRXK7seu/SUsv+hG
	 VVVwNQ/fDIcK4EJLfJ16OOqaTSL2Z2aYhRRCTUQ2uxR5GrbRF1KalyO8tFOeo44/S39ZU
	 /fNpoX/LIhdNvtf+2RkDJ0KQsZ2JZJuTjqUfxW+uNSVkTGUMTsEmF/iyE+1Zteazgsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="dzzT//pK";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 935A5606A86E;
	Wed,  4 Nov 2026 21:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dzzT//pK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA561F000C1;
	Wed,  4 Nov 2026 21:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827157;
	bh=bHJ2KI2d+PALIGVD4ybGZs/OpkaAnpNuWJr68RWqxxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dzzT//pKu1xhj5RazZ8vdo7Ukc/UxZh7VpfEbkxt1n2c+ves6VkdtBcxN1tj6CkIi
	 KDBNIxmfs7rON6vpr3NIXmZh0krXegUD9IWonTyYd0WFBWWNjrOAG5HkAngfoMlXbN
	 vcTRumR6PWERFOkOLHXnBBOm11T86KFixv3AuadA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.3 230/547] media: microchip-isc: take a reference on the parsed endpoints
Date: Wed,  4 Nov 2026 16:06:54 -0500
Message-ID: <20261104211044.693197496@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balakrishnan Sambath <balakrishnan.s@microchip.com>

commit f2eb2fd388bf3f1959556a326e797cacca341c86 upstream.

for_each_endpoint_of_node() drops the reference on the current node as
it advances. xisc_parse_dt() and isc_parse_dt() store the node in
subdev_entity->epn and release it later with of_node_put(), but never
took their own reference, so the stored pointer refers to an
already-released node. This underflows the refcount and can
use-after-free, reachable through the camera device tree overlay.

Take a reference with of_node_get() when storing the node, and drop it
in microchip_isc_subdev_cleanup() so the entities the bind loop never
reaches on an early exit do not leak it.

Fixes: c9aa973884a1 ("media: atmel: atmel-isc: add microchip-xisc driver")
Fixes: d6701f13bd07 ("media: atmel: Use v4l2_async_notifier_add_fwnode_remote_subdev")
Cc: stable@vger.kernel.org
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/microchip/microchip-isc-base.c    |    6 +++++
 drivers/media/platform/microchip/microchip-sama5d2-isc.c |   17 ++++++++++-----
 drivers/media/platform/microchip/microchip-sama7g5-isc.c |   17 ++++++++++-----
 3 files changed, 30 insertions(+), 10 deletions(-)

--- a/drivers/media/platform/microchip/microchip-isc-base.c
+++ b/drivers/media/platform/microchip/microchip-isc-base.c
@@ -1860,6 +1860,12 @@ void microchip_isc_subdev_cleanup(struct
 	list_for_each_entry(subdev_entity, &isc->subdev_entities, list) {
 		v4l2_async_nf_unregister(&subdev_entity->notifier);
 		v4l2_async_nf_cleanup(&subdev_entity->notifier);
+		/*
+		 * Release the endpoint reference taken while parsing. It is
+		 * NULL for entities the bind loop already consumed, so this
+		 * only drops the ones left over on an early exit.
+		 */
+		of_node_put(subdev_entity->epn);
 	}
 
 	INIT_LIST_HEAD(&isc->subdev_entities);
--- a/drivers/media/platform/microchip/microchip-sama5d2-isc.c
+++ b/drivers/media/platform/microchip/microchip-sama5d2-isc.c
@@ -356,28 +356,30 @@ static int isc_parse_dt(struct device *d
 	struct device_node *epn;
 	struct isc_subdev_entity *subdev_entity;
 	unsigned int flags;
+	int ret;
 
 	INIT_LIST_HEAD(&isc->subdev_entities);
 
 	for_each_endpoint_of_node(np, epn) {
 		struct v4l2_fwnode_endpoint v4l2_epn = { .bus_type = 0 };
-		int ret;
 
 		ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(epn),
 						 &v4l2_epn);
 		if (ret) {
-			of_node_put(epn);
 			dev_err(dev, "Could not parse the endpoint\n");
-			return -EINVAL;
+			of_node_put(epn);
+			ret = -EINVAL;
+			goto err_cleanup;
 		}
 
 		subdev_entity = devm_kzalloc(dev, sizeof(*subdev_entity),
 					     GFP_KERNEL);
 		if (!subdev_entity) {
 			of_node_put(epn);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto err_cleanup;
 		}
-		subdev_entity->epn = epn;
+		subdev_entity->epn = of_node_get(epn);
 
 		flags = v4l2_epn.bus.parallel.flags;
 
@@ -398,6 +400,11 @@ static int isc_parse_dt(struct device *d
 	}
 
 	return 0;
+
+err_cleanup:
+	list_for_each_entry(subdev_entity, &isc->subdev_entities, list)
+		of_node_put(subdev_entity->epn);
+	return ret;
 }
 
 static int microchip_isc_probe(struct platform_device *pdev)
--- a/drivers/media/platform/microchip/microchip-sama7g5-isc.c
+++ b/drivers/media/platform/microchip/microchip-sama7g5-isc.c
@@ -340,6 +340,7 @@ static int xisc_parse_dt(struct device *
 	struct isc_subdev_entity *subdev_entity;
 	unsigned int flags;
 	bool mipi_mode;
+	int ret;
 
 	INIT_LIST_HEAD(&isc->subdev_entities);
 
@@ -347,23 +348,24 @@ static int xisc_parse_dt(struct device *
 
 	for_each_endpoint_of_node(np, epn) {
 		struct v4l2_fwnode_endpoint v4l2_epn = { .bus_type = 0 };
-		int ret;
 
 		ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(epn),
 						 &v4l2_epn);
 		if (ret) {
-			of_node_put(epn);
 			dev_err(dev, "Could not parse the endpoint\n");
-			return -EINVAL;
+			of_node_put(epn);
+			ret = -EINVAL;
+			goto err_cleanup;
 		}
 
 		subdev_entity = devm_kzalloc(dev, sizeof(*subdev_entity),
 					     GFP_KERNEL);
 		if (!subdev_entity) {
 			of_node_put(epn);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto err_cleanup;
 		}
-		subdev_entity->epn = epn;
+		subdev_entity->epn = of_node_get(epn);
 
 		flags = v4l2_epn.bus.parallel.flags;
 
@@ -387,6 +389,11 @@ static int xisc_parse_dt(struct device *
 	}
 
 	return 0;
+
+err_cleanup:
+	list_for_each_entry(subdev_entity, &isc->subdev_entities, list)
+		of_node_put(subdev_entity->epn);
+	return ret;
 }
 
 static int microchip_xisc_probe(struct platform_device *pdev)


