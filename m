Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2AC28BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CB0C433EF;
	Tue, 28 Mar 2023 15:04:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015847;
	bh=nYN8+71foBTiqgYHHhcWxzxib4C6f8/REBE4g+lz67w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a4uqbSgB0Z+wCXQ9bMpHAVsfTuPFCYZNCrnJrerECx3Xi6tliULEOcUflD1ummnOu
	 3uR6T6AVN9TP0Ckrode+1j/AG6UkMTMPKq5rfDDO08aKCwqRGpBaYs/j2arxkPYLCC
	 y7Z5m0Y6SYwd7YHLAawtJXzhVGIDtwElikmDmY+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matheus Castello <matheus.castello@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.1 198/224] drm/bridge: lt8912b: return EPROBE_DEFER if bridge is not found
Date: Tue, 28 Mar 2023 16:43:14 +0200
Message-Id: <20230328142625.644546276@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matheus Castello <matheus.castello@toradex.com>

commit 1a70ca89d59c7c8af006d29b965a95ede0abb0da upstream.

Returns EPROBE_DEFER when of_drm_find_bridge() fails, this is consistent
with what all the other DRM bridge drivers are doing and this is
required since the bridge might not be there when the driver is probed
and this should not be a fatal failure.

Cc: <stable@vger.kernel.org>
Fixes: 30e2ae943c26 ("drm/bridge: Introduce LT8912B DSI to HDMI bridge")
Signed-off-by: Matheus Castello <matheus.castello@toradex.com>
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230322143821.109744-1-francesco@dolcini.it
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/lontium-lt8912b.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/bridge/lontium-lt8912b.c
+++ b/drivers/gpu/drm/bridge/lontium-lt8912b.c
@@ -659,8 +659,8 @@ static int lt8912_parse_dt(struct lt8912
 
 	lt->hdmi_port = of_drm_find_bridge(port_node);
 	if (!lt->hdmi_port) {
-		dev_err(lt->dev, "%s: Failed to get hdmi port\n", __func__);
-		ret = -ENODEV;
+		ret = -EPROBE_DEFER;
+		dev_err_probe(lt->dev, ret, "%s: Failed to get hdmi port\n", __func__);
 		goto err_free_host_node;
 	}
 


