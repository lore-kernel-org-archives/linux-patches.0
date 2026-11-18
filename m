Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035674;
	b=DPnbZUTzrP4vv+ul2xQvC8FmsDZ6/HyeoYhp5/s+xyOdG8HPXUpHICvxJgXsXLcc//qi
	 6gdolvCcl2Vivove5rOcC4b2R5MHViACuXKD5YSxwGNH3hgROeXV3ChHCu15flzSgUAnm
	 EM8FcBH29b28Z0pV0pi24tS71l3Ta4zikUaDzYOnYER2Bp4EU10DxD4d5H86Eh+95aPME
	 BZB/SCrejt19KGM8hz21dkbvzJzgsPAMGGD+rligExTuZNp+PlPq/chL+Vah+t/oDlyyO
	 Xfy3MUKgR8t3Z4/oQhpJZQiz+OSm9uEIEWpztzt6GHTbCYm+LSjlARDioiEzlvqjq7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mJhWh2fvWA86s0mjEgnCVRilAD3O7QfjfDLYcqA4VfU=;
	b=Kqgz+TIBRYOLKe5PSzxqb09B7rQqJZCEZGYKFLx0lnLX1TDcN3xPEKq/XTcO8xA3V8sZ
	 ofosABBS1F+C3ArMYv5L2JZdh2e9dLts4z/qGOLbwp7gfrVeNg/ZAd1n7Qk2O3DbNWZuL
	 8zrcRTFLUizcZKzvqxEjiUo9wecSllcNnbCyjhIy4I3mf+Br5xIjJJ3AlA8oYzOKBw0V+
	 sGYrCLM5Pm8lhFhfb9Tvc+xQ6E2d/NAEQZuFYgDSldtEq4ZtBbuavKXlKwFEhinsyEZdr
	 u9v5grFxOKzwHauVPBpIPKw2KC7cxynzZOXkJLEB0tgr7GeeJNvGLAAfuSSunVSmhNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="N4Sd56/3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A565560A2603;
	Wed, 18 Nov 2026 21:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N4Sd56/3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E91021F000C7;
	Wed, 18 Nov 2026 21:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035674;
	bh=mJhWh2fvWA86s0mjEgnCVRilAD3O7QfjfDLYcqA4VfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N4Sd56/3S+RZ79lMaWu4TTKpxnvXrYQfREumvqG5GfYfBLkteeF86ds7/tqU7YKGC
	 l0a2QYrHeAdmFSusvisQQtVGzjy/jaiJ7C0Ow9w7fbeE+DvPLUdPfogd5VoWrEoO+A
	 Drcn6eEKgCQP/tZy3X880HNYORr/r+v7dCjMPUek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0785/3318] media: platform: microchip: use for_each_endpoint_of_node()
Date: Wed, 18 Nov 2026 15:23:27 +0100
Message-ID: <20261118150342.399768706@linuxfoundation.org>
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

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 68a1560c3b7f8bb23423b272334fc19279e82d9a ]

We already have for_each_endpoint_of_node(), don't use
of_graph_get_next_endpoint() directly. Replace it.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: f2eb2fd388bf ("media: microchip-isc: take a reference on the parsed endpoints")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../microchip/microchip-sama5d2-isc.c         | 21 +++++++------------
 .../microchip/microchip-sama7g5-isc.c         | 21 +++++++------------
 2 files changed, 16 insertions(+), 26 deletions(-)

diff --git a/drivers/media/platform/microchip/microchip-sama5d2-isc.c b/drivers/media/platform/microchip/microchip-sama5d2-isc.c
index 5ac149cf3647f..60b6d922d764e 100644
--- a/drivers/media/platform/microchip/microchip-sama5d2-isc.c
+++ b/drivers/media/platform/microchip/microchip-sama5d2-isc.c
@@ -353,33 +353,29 @@ static const u32 isc_sama5d2_gamma_table[][GAMMA_ENTRIES] = {
 static int isc_parse_dt(struct device *dev, struct isc_device *isc)
 {
 	struct device_node *np = dev->of_node;
-	struct device_node *epn = NULL;
+	struct device_node *epn;
 	struct isc_subdev_entity *subdev_entity;
 	unsigned int flags;
-	int ret;
 
 	INIT_LIST_HEAD(&isc->subdev_entities);
 
-	while (1) {
+	for_each_endpoint_of_node(np, epn) {
 		struct v4l2_fwnode_endpoint v4l2_epn = { .bus_type = 0 };
-
-		epn = of_graph_get_next_endpoint(np, epn);
-		if (!epn)
-			return 0;
+		int ret;
 
 		ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(epn),
 						 &v4l2_epn);
 		if (ret) {
-			ret = -EINVAL;
+			of_node_put(epn);
 			dev_err(dev, "Could not parse the endpoint\n");
-			break;
+			return -EINVAL;
 		}
 
 		subdev_entity = devm_kzalloc(dev, sizeof(*subdev_entity),
 					     GFP_KERNEL);
 		if (!subdev_entity) {
-			ret = -ENOMEM;
-			break;
+			of_node_put(epn);
+			return -ENOMEM;
 		}
 		subdev_entity->epn = epn;
 
@@ -400,9 +396,8 @@ static int isc_parse_dt(struct device *dev, struct isc_device *isc)
 
 		list_add_tail(&subdev_entity->list, &isc->subdev_entities);
 	}
-	of_node_put(epn);
 
-	return ret;
+	return 0;
 }
 
 static int microchip_isc_probe(struct platform_device *pdev)
diff --git a/drivers/media/platform/microchip/microchip-sama7g5-isc.c b/drivers/media/platform/microchip/microchip-sama7g5-isc.c
index 73445f33d26ba..e97abe3e35af0 100644
--- a/drivers/media/platform/microchip/microchip-sama7g5-isc.c
+++ b/drivers/media/platform/microchip/microchip-sama7g5-isc.c
@@ -336,36 +336,32 @@ static const u32 isc_sama7g5_gamma_table[][GAMMA_ENTRIES] = {
 static int xisc_parse_dt(struct device *dev, struct isc_device *isc)
 {
 	struct device_node *np = dev->of_node;
-	struct device_node *epn = NULL;
+	struct device_node *epn;
 	struct isc_subdev_entity *subdev_entity;
 	unsigned int flags;
-	int ret;
 	bool mipi_mode;
 
 	INIT_LIST_HEAD(&isc->subdev_entities);
 
 	mipi_mode = of_property_read_bool(np, "microchip,mipi-mode");
 
-	while (1) {
+	for_each_endpoint_of_node(np, epn) {
 		struct v4l2_fwnode_endpoint v4l2_epn = { .bus_type = 0 };
-
-		epn = of_graph_get_next_endpoint(np, epn);
-		if (!epn)
-			return 0;
+		int ret;
 
 		ret = v4l2_fwnode_endpoint_parse(of_fwnode_handle(epn),
 						 &v4l2_epn);
 		if (ret) {
-			ret = -EINVAL;
+			of_node_put(epn);
 			dev_err(dev, "Could not parse the endpoint\n");
-			break;
+			return -EINVAL;
 		}
 
 		subdev_entity = devm_kzalloc(dev, sizeof(*subdev_entity),
 					     GFP_KERNEL);
 		if (!subdev_entity) {
-			ret = -ENOMEM;
-			break;
+			of_node_put(epn);
+			return -ENOMEM;
 		}
 		subdev_entity->epn = epn;
 
@@ -389,9 +385,8 @@ static int xisc_parse_dt(struct device *dev, struct isc_device *isc)
 
 		list_add_tail(&subdev_entity->list, &isc->subdev_entities);
 	}
-	of_node_put(epn);
 
-	return ret;
+	return 0;
 }
 
 static int microchip_xisc_probe(struct platform_device *pdev)
-- 
2.53.0



