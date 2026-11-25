Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622391;
	b=bqmIkmmU2NCI/xVIyT5QwHsPKhARVDvD5TBuMOWsNEmG+F0IkcX6gmNVV0Yf7lqHmaSw
	 k7NcZuptfm+R3umSwNbjP6g+MqpNvnaOvxwxJO/6xpUx3ygBYzw4VTpqopzazkyFb7d5W
	 Sbv+vEAB32ur+HfBYu97Z2vzUjObVITcV9eqCCX8jxa8Kht+mQVGN0t+XzX2zdljy4MmT
	 wK6tHIaWvXMFHaNy6vqGc+3ZsdIqy0oo/Mh636pXWDtgos45Y8s54+VDowZ7F43dQTCrf
	 lVUr1lsn3QijfgB8kb42H/Gq63GdJHRSLjMG2gLqUSAzcOtr6qpzxY3iGXEpUW9Gv5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622391;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=EQzGAbAVfeimdHEn0Rm1rSyxrFvR5L789e+VIuAvz+A=;
	b=ypY+cHtEnbI5jgFJN4wwL5uRX4FKPpH1NQZc/9sK5yxe5dwzqpqQhmimzTsJ6p8PnFOZ
	 +M9Ba1XFcqxc1TrLFadXjUJ6BwxKYfQRB71rdYnwxDjxtsMDCdVU5SWVjKIX3V8Y4eIGE
	 n6s44el4k3Yo9uq41SCI644pYLFbgqjSj5LF3K2Jzw8ziOiuIBHEUa+WDPRuJrB4gewTk
	 Pze/YztkV8H8pUytGKk42WshcN1my7wH/MFwpccXBP6JJoU3JeWbfmW/5qJkVxzhce7EL
	 4kkAp5iLT/DliDKhkKidIjoAE6aThoGAwnr/omnlz5DExIv33X8opGbggb7dsi6OpLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xWQe1I/u";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13830606A31E;
	Wed, 25 Nov 2026 15:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xWQe1I/u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FED1F000CA;
	Wed, 25 Nov 2026 15:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622390;
	bh=EQzGAbAVfeimdHEn0Rm1rSyxrFvR5L789e+VIuAvz+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xWQe1I/uDPbc3raILLyM22OTW2HZQ5IIapjo/9bTyrkrLz2v3cLQELFv3XHtNRrmL
	 8lx1bmXlWYqVx/wWCMFvMChu3kOtTp07jY/rTsiuK8IQII1Jl/kmf/vDWckjjQebe6
	 syHZzAuHOMH7lW5rsoExo6aZ8yEwf+aY6vqEazto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Maxime Ripard <mripard@kernel.org>,
	=?UTF-8?q?Robin=20R=C3=A4ber?= <robin.raebi@gmail.com>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Sasha Levin <sashal@kernel.org>,
	Igor Paunovic <royalnet026@gmail.com>
Subject: [PATCH 6.18 522/990] drm/connector: hdmi: Handle reset() state allocation failure
Date: Wed, 25 Nov 2026 15:31:29 +0100
Message-ID: <20261125143834.321676050@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 54acd0c74eba2a2c9a726856f5fdc6f9e74ea2e1 ]

In drmm_connector_hdmi_init(), if the reset callback fails to allocate
memory, e.g. inside drm_atomic_helper_connector_reset(),
connector->state will remain NULL.  This is unconditionally passed to
drm_connector_attach_max_bpc_property(), leading to a NULL pointer
dereference.

Bail out with -ENOMEM if the reset callback leaves connector->state
unset.

Fixes: aadb3e16b8f3 ("drm/connector: hdmi: Add output BPC to the connector state")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260723015306.C94241F000E9@smtp.kernel.org/
Link: https://lore.kernel.org/all/20260723015306.C94241F000E9@smtp.kernel.org/
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Tested-by: Igor Paunovic <royalnet026@gmail.com> # RK3588 Orange Pi 5 Plus, dual HDMI
Tested-by: Robin Räber <robin.raebi@gmail.com>
Link: https://patch.msgid.link/20260901-dw-hdmi-qp-scramb-v11-2-bc12954a0688@collabora.com
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
[ sashal: Added braces around the single-statement reset branch in drmm_connector_hdmi_init() to fit this tree's code, which lacks the earlier two-arm if/else context. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_connector.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
index 0326b9adb5f12..3e40efc2298a6 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -612,8 +612,11 @@ int drmm_connector_hdmi_init(struct drm_device *dev,
 	 * drm_connector_attach_max_bpc_property() requires the
 	 * connector to have a state.
 	 */
-	if (connector->funcs->reset)
+	if (connector->funcs->reset) {
 		connector->funcs->reset(connector);
+		if (!connector->state)
+			return -ENOMEM;
+	}
 
 	drm_connector_attach_max_bpc_property(connector, 8, max_bpc);
 	connector->max_bpc = max_bpc;
-- 
2.53.0



