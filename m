Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABFD1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE26C433D2;
	Wed, 28 Dec 2022 15:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242299;
	bh=PkRZ+5E/QkjOJ/PWYL2le7UQYhBZe46413TgpDr4zKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oP28YrKnDxjUr5HwXdaqWzwsbzyzFFUxzra+L0BepCN6VXjlywxRZi95vvnh9LSYu
	 3y4N/uJL06fvXho6LwmgR1rQ2v9EH+mVeF0I6AirbkNMfJKxPKdUfGW59FQF4U8iF4
	 r0y6ZNfd2Dj1VFo2M608O4+GlqSaZhtHMbSkPaU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0390/1073] media: sun6i-mipi-csi2: Require both pads to be connected for streaming
Date: Wed, 28 Dec 2022 15:32:58 +0100
Message-Id: <20221228144338.613428917@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit f042b08b833de3be810f8769d88ca44aeefd7eba ]

The bridge needs both its pads connected to be able to stream data.
Enforcing this is useful to produce an error when no sensor is
connected.

Fixes: af54b4f4c17f ("media: sunxi: Add support for the A31 MIPI CSI-2 controller")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c  | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c b/drivers/media/platform/sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c
index 30d6c0c5161f..340380a5f66f 100644
--- a/drivers/media/platform/sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c
+++ b/drivers/media/platform/sunxi/sun6i-mipi-csi2/sun6i_mipi_csi2.c
@@ -519,8 +519,10 @@ static int sun6i_mipi_csi2_bridge_setup(struct sun6i_mipi_csi2_device *csi2_dev)
 
 	/* Media Pads */
 
-	pads[SUN6I_MIPI_CSI2_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
-	pads[SUN6I_MIPI_CSI2_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE;
+	pads[SUN6I_MIPI_CSI2_PAD_SINK].flags = MEDIA_PAD_FL_SINK |
+					       MEDIA_PAD_FL_MUST_CONNECT;
+	pads[SUN6I_MIPI_CSI2_PAD_SOURCE].flags = MEDIA_PAD_FL_SOURCE |
+						 MEDIA_PAD_FL_MUST_CONNECT;
 
 	ret = media_entity_pads_init(&subdev->entity, SUN6I_MIPI_CSI2_PAD_COUNT,
 				     pads);
-- 
2.35.1



