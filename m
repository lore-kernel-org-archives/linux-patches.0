Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625125;
	b=fxr+pYMxqa0QKBm7cB7pKtGmojTc8zF0V5g+zyAB8iZuZWRaC8BH/VK0tH9Wzb3eMSlw
	 usipfoTvDmOY1Zhz0xfShpOmFN47EJbVOqqpT+OkELRjERWd5OllnAWT4IozEOsrSPnXQ
	 tp/yj2cDwnLwvUzZlEvb+qA7b/WDi8QA8ZW2Sf/UdqgypVMVQhMvZ1GZDKwlsQemI6uwB
	 Kkg0cuwxUQJRlQ6IcrZD8hgJA0z5p0d8uIZ/mI8tR8z0a4TMlkH5SgLL/OVRAQ9wrW5d1
	 1/3UDHRyOsmhfVE5Z7X/39HpLsUkq25Hmab7U7c3RZl8tUF3lITXDS1KoKMphxToMzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625125;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=LOF+kp51zA8+GxCLTidDd55huwo1JaOGeSzDBzPyirQ=;
	b=zTB0U2bNvjVuGeSbruJwSJ9uAJi+HEhsU/+xjBvRyU7Nvp8DI6Sy6US28wMnhDThWVc4
	 HgJPQR+sEDukzLBCkbNR9r7DOEQUKn1tVAspU9qPEuTLdypdzFisYv6kyrLe0b9Oh/mvV
	 16Khfg5yd7kBURkpCj2FAAiWA3VQagK+CtDeNOmhrUWH1dXuv/2Ok4LTH40HNuoUwEgsJ
	 cR0j/YGaoJopIb6tGeZHX/bc06rahsh7ydhEiQafF35AYXEDsW8CAD0a0Nyyjkiybazg3
	 pgXGsEzExwT7kwT1STr8kAzBunzkG93xrpmM81BqERlrdIO7fgCsAKBh+p9N81cHWCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cC1BcJa0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB475606A327;
	Wed, 25 Nov 2026 16:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cC1BcJa0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED48A1F000C6;
	Wed, 25 Nov 2026 16:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625125;
	bh=LOF+kp51zA8+GxCLTidDd55huwo1JaOGeSzDBzPyirQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cC1BcJa0hfvtHFRm34Ki4EWIjv1ZbiB8X2q0eZrDolStcjDR7ABAB6So0X5/4wXMk
	 EFmC0dT5UT1hoQsUTE1cveMrOpPGyRKXe4x8BkQBhQqPTfbQghKNv/xSNwARRmB/Dl
	 mG2swUdD41wwJqVKsJnpIdixTsBUH2Xjbe2nY570=
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
Subject: [PATCH 6.12 413/816] drm/connector: hdmi: Handle reset() state allocation failure
Date: Wed, 25 Nov 2026 15:32:41 +0100
Message-ID: <20261125143858.755045521@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Added a NULL check after reset() returning -ENOMEM, with braces added around the single reset() call because the older code lacks the newer state-allocation structure. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_connector.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
index 6c1a49fe9fc66..8814c9b6907a3 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -526,8 +526,11 @@ int drmm_connector_hdmi_init(struct drm_device *dev,
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



