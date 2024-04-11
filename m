Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 818A61448F3;
	Thu, 11 Apr 2024 10:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829968; cv=none; b=ndznJU7G9UeCtsY63aRVaHhhtoOhMfLzj+2jwAP3cTAgl01zU1jWJx7g2wwFoSlj75nYxLE2Zb+0Ac50GG8933me1REeBhUAtEJaPI0Hz2ecNxHPpEdL4v6f/R6S8jRwsvgReRfiPd/0AUC9K1evycJOE8rB9MfvnuBRulrydPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829968; c=relaxed/simple;
	bh=S33aXnIqGbNsFMOQVUVbqZfjzx7xSfl4iS262qxU1tA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTBxj5HqENEmd0bowD2NjVoPGMZu45iEWodw86cWUWatml0bIXLql6O8ksVyQ4F8d2TaJuvfAVuoiUKcwRXTf4RA0QPkHthIN0Hzt11EtAyVBro1msujrh2wax/SZyGROnVMNA7n4vapHvjQAWfhCbpmMF1uK/gkAHAN9o2WQDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M8Yu2gX4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M8Yu2gX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E8CC433C7;
	Thu, 11 Apr 2024 10:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829968;
	bh=S33aXnIqGbNsFMOQVUVbqZfjzx7xSfl4iS262qxU1tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M8Yu2gX4i3n9Dkq9shDA64bsxPfzibafLC+R5Kjwgot8dXakPNvrwjZcaDxEGaYd8
	 yNnFyJlQQ4AnQlojDtTSzMOE71n+oiIuysWwZSGhXpA3CpTZbDdqkqwRSKhDBmuvLF
	 Es3n3XGy969vzM2RPiL/hFF9HjpipRVEaVaP5ViQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.org>,
	Stefan Wahren <wahrenst@gmx.net>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 128/175] staging: mmal-vchiq: Avoid use of bool in structures
Date: Thu, 11 Apr 2024 11:55:51 +0200
Message-ID: <20240411095423.418639459@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.org>

[ Upstream commit 640e77466e69d9c28de227bc76881f5501f532ca ]

Fixes up a checkpatch error "Avoid using bool structure members
because of possible alignment issues".

Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.org>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f37e76abd614 ("staging: vc04_services: fix information leak in create_component()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../vc04_services/bcm2835-camera/mmal-vchiq.c        | 12 ++++++------
 .../vc04_services/bcm2835-camera/mmal-vchiq.h        |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
index daa2b96565529..00c943516ba38 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.c
@@ -845,9 +845,9 @@ static int port_info_get(struct vchiq_mmal_instance *instance,
 		goto release_msg;
 
 	if (rmsg->u.port_info_get_reply.port.is_enabled == 0)
-		port->enabled = false;
+		port->enabled = 0;
 	else
-		port->enabled = true;
+		port->enabled = 1;
 
 	/* copy the values out of the message */
 	port->handle = rmsg->u.port_info_get_reply.port_handle;
@@ -1283,7 +1283,7 @@ static int port_disable(struct vchiq_mmal_instance *instance,
 	if (!port->enabled)
 		return 0;
 
-	port->enabled = false;
+	port->enabled = 0;
 
 	ret = port_action_port(instance, port,
 			       MMAL_MSG_PORT_ACTION_TYPE_DISABLE);
@@ -1335,7 +1335,7 @@ static int port_enable(struct vchiq_mmal_instance *instance,
 	if (ret)
 		goto done;
 
-	port->enabled = true;
+	port->enabled = 1;
 
 	if (port->buffer_cb) {
 		/* send buffer headers to videocore */
@@ -1502,7 +1502,7 @@ int vchiq_mmal_port_connect_tunnel(struct vchiq_mmal_instance *instance,
 			pr_err("failed disconnecting src port\n");
 			goto release_unlock;
 		}
-		src->connected->enabled = false;
+		src->connected->enabled = 0;
 		src->connected = NULL;
 	}
 
@@ -1746,7 +1746,7 @@ int vchiq_mmal_component_disable(struct vchiq_mmal_instance *instance,
 
 	ret = disable_component(instance, component);
 	if (ret == 0)
-		component->enabled = false;
+		component->enabled = 0;
 
 	mutex_unlock(&instance->vchiq_mutex);
 
diff --git a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h
index b0ee1716525b4..b3c231e619c90 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h
+++ b/drivers/staging/vc04_services/bcm2835-camera/mmal-vchiq.h
@@ -47,7 +47,7 @@ typedef void (*vchiq_mmal_buffer_cb)(
 		unsigned long length, u32 mmal_flags, s64 dts, s64 pts);
 
 struct vchiq_mmal_port {
-	bool enabled;
+	u32 enabled:1;
 	u32 handle;
 	u32 type; /* port type, cached to use on port info set */
 	u32 index; /* port index, cached to use on port info set */
@@ -81,7 +81,7 @@ struct vchiq_mmal_port {
 };
 
 struct vchiq_mmal_component {
-	bool enabled;
+	u32 enabled:1;
 	u32 handle;  /* VideoCore handle for component */
 	u32 inputs;  /* Number of input ports */
 	u32 outputs; /* Number of output ports */
-- 
2.43.0



