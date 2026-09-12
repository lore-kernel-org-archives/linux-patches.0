Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BFD4BEE54;
	Sat, 12 Sep 2026 09:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205960; cv=none; b=Er0KLytkKIy3ct/eXRrBb92rSbfKI5Wtn+w7kBkBHHoPQYUuiUfLw1n/bNSqDKRLqsTukYJP9r3YtTQ5pBi6HGM8WBDvToj5M8Q5zIsW1n6uDvzCDUMzq6CwM+XvjLwWvM0eXcquqqqj/tFlj/U1FLT5upnOPSSsLwMmtQLs+Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205960; c=relaxed/simple;
	bh=oeZcbSSiLkOKS76E12RBfjGU61KE9d5UeW7iadgFKHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0lj+nuVs2RWwXi58lKMZUiJBRsp0KpSDQ7vfUFutXJMUTtiBG5oM2RAUueE/FpMgR1JC3OVYPvqyCN/qVV8UitrI0yqyzabehwBmpzO5qKn1vFrmo4O9fffzjtclcWD1G3+yTrGJqMqseAKhZ2ro1fn89NP7HYGDWmshpJsFd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FCVmDM+W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FCVmDM+W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06D31F000FF;
	Sat, 12 Sep 2026 09:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205959;
	bh=i2SWWLUH3ILSCv0OhEzIMUEEv5QWrp1CXEr5EMXl518=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FCVmDM+WjlTWwMJdJjVk4ELodxtUt4sQuHgHptoywF2eIgxUZlIxweI9zXIXKAESX
	 oBV7Evk/YsmtEiUMWmq+BzDG20wAFET6C89XdgfqL7gEUJNtVFh3A1OJtPbQjPpmsX
	 EyCgLT3f3k2XHMc+D+EhD7DughUM9A/wvvrUjmKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0109/1518] drm/bridge: cdns-dsi: Return an error pointer on allocation failure
Date: Sat, 12 Sep 2026 08:37:58 +0200
Message-ID: <20260912065625.943506746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <mripard@kernel.org>

[ Upstream commit 79ac5c68f1a49a9fdec596ee47577d5a1d52738f ]

The drm_bridge_funcs.atomic_reset documentation states that the hook
must return either a valid drm_bridge_state object or an ERR_PTR().

The cdns_dsi_bridge_atomic_reset() callback returns NULL when the
allocation of its state fails, violating this contract.

Return ERR_PTR(-ENOMEM) instead.

Fixes: a53d987756ea ("drm/bridge: cdns-dsi: Move DSI mode check to _atomic_check()")
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com> # imx8mp + sn65dsi84 + bridge hotplug
Link: https://patch.msgid.link/20260619-drm-no-more-bridge-reset-v3-1-ff399263111b@kernel.org
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c b/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
index de2a32112913e..16b7e56142006 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
@@ -1015,7 +1015,7 @@ cdns_dsi_bridge_atomic_reset(struct drm_bridge *bridge)
 
 	dsi_state = kzalloc(sizeof(*dsi_state), GFP_KERNEL);
 	if (!dsi_state)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	memset(dsi_state, 0, sizeof(*dsi_state));
 	dsi_state->base.bridge = bridge;
-- 
2.53.0



