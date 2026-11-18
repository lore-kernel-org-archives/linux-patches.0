Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035818;
	b=IqvdyaggB/4xBD/5qEMAsOk/rgS1e7Tq1dPSIjlN8fxGBlZmLh+TWIRCxAuzwq3x1s26
	 p9oJdOqBQrOowgI/74VfPY5zx+H5c5hjWsoM5k6jlNFqt8h5vn1z2VquV5LlClMMcH33Q
	 xpouQYDwOPNpk1GH0Qn6J7fNX3YhSowxrOU/A0+hR038qwA/jRPsNgT8QSu9Qp4am0B37
	 oWDSpJDvO77egClFp4FsF8RcyHjFfNjnx1aTbHmgwLu7CWYbkk7LFithgAHt5z0kSjGpM
	 2dsSp4hqMttJUm0irVsbVXiLvK9AVHzMD0DX9/UQmGV4EC456bJUOkZMWbIA0+k80gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pp8z/2eWaaQhzt7Lg815L8BJep8BZ7ONXqZ7ry9ma4s=;
	b=2Xp23AwvnWoae44boLoEUfrZGr1FBo5h8cWPjYK38o/JPf+mMv0Km51DTcAnkIThmuW0
	 /KFTsmwKMecEHjWeaBJRJlwCnafVCP6UtXh0PsgTov6nBfypf900hSEYvHYEj3rFoNodl
	 ucxHG6eVaMTXdnJEvIwfRz8Lw5jY1coK6n8hueURpPVchFDd4iFe54u+NG4qO376C5Ozt
	 YdTSL6XxpoA5szQS2xsacz7sTQY9QiOq+o998rG2vZ4GZz55/7lfQ2OtcoH26+t8VyCbV
	 YnuHIS2uwbpY+YqohnTUI5vUN2G/vxtiIDx/PHiLkNRM737ZtJeDtBNUY9Qgbf81MKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vJOccRht;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61575606A331;
	Wed, 18 Nov 2026 21:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vJOccRht
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E051F000C4;
	Wed, 18 Nov 2026 21:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035818;
	bh=Pp8z/2eWaaQhzt7Lg815L8BJep8BZ7ONXqZ7ry9ma4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vJOccRht7P5COVilqoV4zk8/KRm3xJok356SeQT3G3sJz0Krp0R+qs4wqwt9r9jcK
	 mk0zeSsE3D/dKOOlyZhTotj9dlOh1nXkwzw1WxviFISNFkQMTOwHt9tCRCM1NK2vbP
	 mL4CFwryPUsFlRM4at3Yh6M6bdpdD45027oZhq90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0786/3318] media: microchip-isc: take a reference on the parsed endpoints
Date: Wed, 18 Nov 2026 15:23:28 +0100
Message-ID: <20261118150342.438231430@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balakrishnan Sambath <balakrishnan.s@microchip.com>

[ Upstream commit f2eb2fd388bf3f1959556a326e797cacca341c86 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/microchip/microchip-isc-base.c     |  6 ++++++
 .../platform/microchip/microchip-sama5d2-isc.c  | 17 ++++++++++++-----
 .../platform/microchip/microchip-sama7g5-isc.c  | 17 ++++++++++++-----
 3 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/microchip/microchip-isc-base.c b/drivers/media/platform/microchip/microchip-isc-base.c
index 8dbf7bc1e863b..78a26babf3894 100644
--- a/drivers/media/platform/microchip/microchip-isc-base.c
+++ b/drivers/media/platform/microchip/microchip-isc-base.c
@@ -1902,6 +1902,12 @@ void microchip_isc_subdev_cleanup(struct isc_device *isc)
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
diff --git a/drivers/media/platform/microchip/microchip-sama5d2-isc.c b/drivers/media/platform/microchip/microchip-sama5d2-isc.c
index 60b6d922d764e..4033bfc96bb77 100644
--- a/drivers/media/platform/microchip/microchip-sama5d2-isc.c
+++ b/drivers/media/platform/microchip/microchip-sama5d2-isc.c
@@ -356,28 +356,30 @@ static int isc_parse_dt(struct device *dev, struct isc_device *isc)
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
 
@@ -398,6 +400,11 @@ static int isc_parse_dt(struct device *dev, struct isc_device *isc)
 	}
 
 	return 0;
+
+err_cleanup:
+	list_for_each_entry(subdev_entity, &isc->subdev_entities, list)
+		of_node_put(subdev_entity->epn);
+	return ret;
 }
 
 static int microchip_isc_probe(struct platform_device *pdev)
diff --git a/drivers/media/platform/microchip/microchip-sama7g5-isc.c b/drivers/media/platform/microchip/microchip-sama7g5-isc.c
index e97abe3e35af0..58cfbf6fcd668 100644
--- a/drivers/media/platform/microchip/microchip-sama7g5-isc.c
+++ b/drivers/media/platform/microchip/microchip-sama7g5-isc.c
@@ -340,6 +340,7 @@ static int xisc_parse_dt(struct device *dev, struct isc_device *isc)
 	struct isc_subdev_entity *subdev_entity;
 	unsigned int flags;
 	bool mipi_mode;
+	int ret;
 
 	INIT_LIST_HEAD(&isc->subdev_entities);
 
@@ -347,23 +348,24 @@ static int xisc_parse_dt(struct device *dev, struct isc_device *isc)
 
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
 
@@ -387,6 +389,11 @@ static int xisc_parse_dt(struct device *dev, struct isc_device *isc)
 	}
 
 	return 0;
+
+err_cleanup:
+	list_for_each_entry(subdev_entity, &isc->subdev_entities, list)
+		of_node_put(subdev_entity->epn);
+	return ret;
 }
 
 static int microchip_xisc_probe(struct platform_device *pdev)
-- 
2.53.0



