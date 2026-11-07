Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063859;
	b=GOJEsZ0DxK4uxeyIX+CMYMrpkxZuSGTpoqoWUn+sKgekTe6Jo3aCMocZQjXU3vaQ9Ikq
	 tZIq8gbwXeJtTJI82+/5SJVuNWtgDCgQrMu3HBZfCbkhEaCFNlElITpps+3pYj59X6dWm
	 7h501UgGJoxzhogRC/LUDMgAWV8yFX3tpliezTtcoq3Jj9CJ7mqn8KaqNfdjdBSAOWET3
	 Yqxc+PaHjKLZpLkdFYzs/ADweLFN1updIzk0ss9202OvhALETGMPlnItNAL6nB9r7T1kE
	 zeGtEYybnICEpO4yWLqwGso2n9mwbZoIdYv79e6wE4Lozl1V3CTrI2POKBHsOb59Htw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063859;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kkxq3DQ9Gq22KLCYppUi8GwVoHsesSolngFfVQawd9c=;
	b=MvU499EfRoD3OwG1SdwABw3W1LxpzbEPRmoT8iYD87dvSnGsa7n0ZuVe3hWQAm2+NyMT
	 oStBDyFu3ODlU83I8I47OH87oCyBLb5XQGH6Ka2fLSoC4fvuYJ1pyanwUD2yMoIBOdw9q
	 m+NTM2bRn9tkOWssJ3MvL3EhMYt2AnXRlsvjdhhXBK5BlFYlJjN1lCFROXq0IH7o5K9Hy
	 AdwHaAW68VasNYCDkI3THrqnf4yD1jj5skgTEF8AR09mFENu4Wsuy8qTdLzTszwVNCFzq
	 vUaMU2lVkJ0djuvxGSRPPFfyJmEJSlxte1Pt8OpDfR/JlrlnG5QIQyuxfZzEyrdK5Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pFC59Iru;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B722E606A9FF;
	Sat,  7 Nov 2026 15:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pFC59Iru
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D8B1F008A1;
	Sat,  7 Nov 2026 15:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063858;
	bh=Kkxq3DQ9Gq22KLCYppUi8GwVoHsesSolngFfVQawd9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pFC59IrudCmKvrdW/lVmaVA8Sj7lqX16os+44RLZHnbgDrB+y47usN+LePS1f9cHo
	 bJdWWrqRVGpXOac1W2TMzcDkgbUgrYz8R5YogN6eQX+T+IURr3liC9HR/h7uwhtw9t
	 wNBbx4NjDSUddrvpqWQShYRcetWdeYI/AfQnhDfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antti Laakso <antti.laakso@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0066/1257] media: i2c: cvs: Add sensor node in bound callback
Date: Sat,  7 Nov 2026 08:39:22 -0500
Message-ID: <20261107134941.219216673@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Antti Laakso <antti.laakso@linux.intel.com>

[ Upstream commit 7456b40bc992a3fc34b587545716729923d507b9 ]

Sensor device nodes are created in the complete callback, which is only
called when all devices are successfully registered. If any device fails
to register, e.g. due to a missing driver, the complete callback is
never invoked and sensor nodes are not created.

Create sensor device nodes in the bound callback instead, ensuring they
are available as soon as sensor is bound regardless of other devices
registration status.

Fixes: 8e2b43d2c10b ("media: i2c: cvs: Add driver of Intel Computer Vision Sensing Controller(CVS)")
Cc: stable@vger.kernel.org
Signed-off-by: Antti Laakso <antti.laakso@linux.intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/cvs/v4l2.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/cvs/v4l2.c b/drivers/media/i2c/cvs/v4l2.c
index 9fadca7a3beed..863112cde2665 100644
--- a/drivers/media/i2c/cvs/v4l2.c
+++ b/drivers/media/i2c/cvs/v4l2.c
@@ -13,6 +13,7 @@
 #include <media/v4l2-async.h>
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-device.h>
 #include <media/v4l2-event.h>
 #include <media/v4l2-fwnode.h>
 #include <media/v4l2-mc.h>
@@ -400,7 +401,7 @@ static int cvs_csi_notify_bound(struct v4l2_async_notifier *notifier,
 				struct v4l2_async_connection *asc)
 {
 	struct icvs *ctx = notifier_to_csi(notifier);
-	int pad;
+	int pad, ret;
 
 	pad = media_entity_get_fwnode_pad(&sd->entity, asc->match.fwnode,
 					  MEDIA_PAD_FL_SOURCE);
@@ -409,9 +410,13 @@ static int cvs_csi_notify_bound(struct v4l2_async_notifier *notifier,
 
 	ctx->remote = &sd->entity.pads[pad];
 
-	return media_create_pad_link(&sd->entity, pad, &ctx->subdev.entity,
-				     ICVS_CSI_PAD_SINK, MEDIA_LNK_FL_ENABLED |
-				     MEDIA_LNK_FL_IMMUTABLE);
+	ret = media_create_pad_link(&sd->entity, pad, &ctx->subdev.entity,
+				    ICVS_CSI_PAD_SINK, MEDIA_LNK_FL_ENABLED |
+				    MEDIA_LNK_FL_IMMUTABLE);
+	if (ret)
+		return ret;
+
+	return v4l2_device_register_subdev_nodes(sd->v4l2_dev);
 }
 
 /**
-- 
2.53.0



