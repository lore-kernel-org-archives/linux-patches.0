Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061569;
	b=dAUk+oJVPvOhrxyCaUnjp11uB8StAomgO9A7dOejTQQMfVn5PjcIZmkaHfliHcdTgKBO
	 WQpQ45RhICxOn6qgW6klBhksF61uZrYRgLszG5PeU9C1HP4oV37WqgPptPABr7U/fgK5e
	 ZBKROwcqWAR9/94CEIzb0Tc71gReiZ8t5Ejg931Zksree5Q6/5c+gLKYPG1Lwd8BlyoWx
	 PM3y5GEPvz15myRBtVaO5lQgPlJu0IvpWgb63nNOHODYzM69mQdUuxG6AjU/eIKKK3ujD
	 eliPx4KfBGVPg86y57xt/YN+vRiAagIEVuWXHc7poRpnQbxkxlkkG9t5Bou7rVsySnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061569;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LYc2XGzDH8iU7uVSqtVVjX9u9pvE8TdTBxG2NxqFWBU=;
	b=V+rjxpSzyAtkSn9i3kb+jiKaLCl2mERB8FNKpjyNT2embasrfsWEvIIWYmMbcldRKqqp
	 9g3x4QXgeBbf/IK7NdJ6M+QCCAmGaqVdxO7niRhkI0QsoMQ8wRZAdcoL34Ig0SM01KOce
	 OQIYV43TnGp6HiRjQWCAG4ps53yqJ2UsKHsdv9oihaGf7CtDN4UmUzz3OOkUSgoLrMiV+
	 TrCpstdWgKpV6/ke9tkyKYJs7UqNnOU3EOLZ9DgrDpr7MKm0Knrn1jY8klzBZBzdb9aoZ
	 5W4joDX02JERSNecWztEyEZHM6AEknW9n3yxmzkLwt6Ra7OzjEqTgNPUnNV003GogDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sODydWq+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332E2606A326;
	Sat,  7 Nov 2026 14:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sODydWq+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58631F0089F;
	Sat,  7 Nov 2026 14:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061569;
	bh=LYc2XGzDH8iU7uVSqtVVjX9u9pvE8TdTBxG2NxqFWBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sODydWq+aeymAGmn1yCAMK/5ykkHM7etlGssYC2+Chgu4o5J9I4M+8BEGH2S0aIas
	 JZX9q/LBFefhk14OhU1jYIiG7uHrQwKocWUss6EZVBXex+3UfZ8KrO+jZ8BnBoxmRS
	 iLcdzB4yXh5sm/FSIVJUnuRfU6SOazKR8/VKzVGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0648/1536] media: microchip-isc: take a reference on the parsed endpoints
Date: Sat,  7 Nov 2026 08:44:24 -0500
Message-ID: <20261107135015.727876737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1862,6 +1862,12 @@ void microchip_isc_subdev_cleanup(struct
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


