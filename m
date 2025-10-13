Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D9C201113;
	Mon, 13 Oct 2025 15:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369342; cv=none; b=OmKN1dnWIsSueLLO0V0EcHinSzWa+ifwB9U7vD7bVLkp2mltOLEicMXYr3zDWW81PQnnbAskCaBwJwYLLHraN4Dy87HEK9D7p4uoPjMMiy7AuOmSImZzNgfE87aH4m7U1ufcGzW6ZJqs1hTqPc72mq/GCW2R2SX84nziqSJWwaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369342; c=relaxed/simple;
	bh=02qBdE6iynxB68yGFgdFZw2CnCjVMlad3Ut0377o97Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3l8/j7NThDABgbFmnR2+JYgWUW73V8G4NLfMt3Nll+q4tTZIuY9rKod0iVw6uQYZcoV8MR5m6Nq500yYqTZmqvyXQqFlFXpc9pRXKXv1ZvvZ+l1MyPjPNxjBpgrpJ1cC40RvXhhkwG/pLChDgmV0Uvf7sLmjGHG75Rza9QAL+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6chcPj2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6chcPj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0018C4CEE7;
	Mon, 13 Oct 2025 15:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369342;
	bh=02qBdE6iynxB68yGFgdFZw2CnCjVMlad3Ut0377o97Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6chcPj2Cu1sd2YL/TlXBOaAakZBCsp0atMYqcbioOZ9h0wejwCe6Edbd6cSCjwyO
	 t3YidlDtF7KEkc8RIGMOCBVWGhXqTbNQPCeWZ1XgDele8K3BBlLPksznfspaldcSFD
	 X54O/Z1DgYKbZ/XIhYKiwa3dAuYUxlQ/6qwYJ6+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 213/563] drm/display: bridge-connector: correct CEC bridge pointers in drm_bridge_connector_init
Date: Mon, 13 Oct 2025 16:41:14 +0200
Message-ID: <20251013144419.000698581@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 92e34a5241ddf4b084df20e6953275d16f156aa8 ]

The bridge used in drm_bridge_connector_init() for CEC init does not
correctly point to the required HDMI CEC bridge, which can lead to
errors during CEC initialization.

Fixes: 65a2575a68e4 ("drm/display: bridge-connector: hook in CEC notifier support")
Fixes: a74288c8ded7 ("drm/display: bridge-connector: handle CEC adapters")
Reported-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Closes: http://lore.kernel.org/r/20250718164156.194702d9@booty/
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://lore.kernel.org/r/20250719-fix-cec-bridges-v1-1-a60b1333c87d@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/display/drm_bridge_connector.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/display/drm_bridge_connector.c b/drivers/gpu/drm/display/drm_bridge_connector.c
index 5eb7e9bfe3611..8c915427d0538 100644
--- a/drivers/gpu/drm/display/drm_bridge_connector.c
+++ b/drivers/gpu/drm/display/drm_bridge_connector.c
@@ -816,6 +816,8 @@ struct drm_connector *drm_bridge_connector_init(struct drm_device *drm,
 
 	if (bridge_connector->bridge_hdmi_cec &&
 	    bridge_connector->bridge_hdmi_cec->ops & DRM_BRIDGE_OP_HDMI_CEC_NOTIFIER) {
+		bridge = bridge_connector->bridge_hdmi_cec;
+
 		ret = drmm_connector_hdmi_cec_notifier_register(connector,
 								NULL,
 								bridge->hdmi_cec_dev);
@@ -825,6 +827,8 @@ struct drm_connector *drm_bridge_connector_init(struct drm_device *drm,
 
 	if (bridge_connector->bridge_hdmi_cec &&
 	    bridge_connector->bridge_hdmi_cec->ops & DRM_BRIDGE_OP_HDMI_CEC_ADAPTER) {
+		bridge = bridge_connector->bridge_hdmi_cec;
+
 		ret = drmm_connector_hdmi_cec_register(connector,
 						       &drm_bridge_connector_hdmi_cec_funcs,
 						       bridge->hdmi_cec_adapter_name,
-- 
2.51.0



