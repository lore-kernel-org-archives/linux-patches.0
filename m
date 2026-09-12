Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4B61DE4EF;
	Sat, 12 Sep 2026 14:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222329; cv=none; b=b1nEi5x0mxtiUeNPAObroQdZuZNL5kuzI28uuBej4+CIKVVfKBcwVAVKcQoUqvpBrpP1CDGLQEJG5ZJUmhs63LWAVj3AjaGU+dMoB5JKfBfMQc0KzUwocbsxj0JZ8Rkd8f9d4qf2+at5Pwje2WIjJMSh6oaPSniZ/R0vl19cr5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222329; c=relaxed/simple;
	bh=pqhh1nVxJKniOEvffZhSihfsyEFUWmJKpMqR6bMIBoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QX3K3O9xfIURJEtue357+W90cbbOBOdJUF+WELWFgLs/go1GOqcPo1YzWMD486qtoMPZfUHtzX/SikEFXl790sWS24ELJilGg3Bv+B6lUBMnPyXRcgTs87dK5ekpl6mw0DlksFS8ZkJ/1N4WYfVWr1SFK7u29U7Mi2IR4frIsHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FISDyDtD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FISDyDtD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DF71F000FF;
	Sat, 12 Sep 2026 14:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222327;
	bh=2wQiLwBoHwr1x05opMB5+B8SV9sfT09tvvixGIxVKqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FISDyDtDZXvQeF2j9VAuzUHkyiTtyBrxep7EIg70DiwP7XxWFkzu03/hB9NEnh2/g
	 KCqBCxIa6VLb1aQA93gQGKkXEivqdH79OvB8vBEy+FSeyAiFU6HvB2d0tvf5cuk0no
	 UmuW/Lrl0wrTcJuvK6Wm0eOrHFGOlmOK6Tp6rq88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0564/1424] drm/bridge: cdns-mhdp8546: Return an error pointer on allocation failure
Date: Sat, 12 Sep 2026 08:49:56 +0200
Message-ID: <20260912065619.936257368@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <mripard@kernel.org>

[ Upstream commit 30ac1d403438a6c6039f0af5bb2df3d021f96036 ]

The drm_bridge_funcs.atomic_reset documentation states that the hook
must return either a valid drm_bridge_state object or an ERR_PTR().

The cdns_mhdp_bridge_atomic_reset() callback returns NULL when the
allocation of its state fails, violating this contract.

Return ERR_PTR(-ENOMEM) instead.

Fixes: fb43aa0acdfd ("drm: bridge: Add support for Cadence MHDP8546 DPI/DP bridge")
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com> # imx8mp + sn65dsi84 + bridge hotplug
Link: https://patch.msgid.link/20260619-drm-no-more-bridge-reset-v3-2-ff399263111b@kernel.org
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
index 44955601a9dfc..eeefb0fa70d88 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-mhdp8546-core.c
@@ -2161,7 +2161,7 @@ cdns_mhdp_bridge_atomic_reset(struct drm_bridge *bridge)
 
 	cdns_mhdp_state = kzalloc(sizeof(*cdns_mhdp_state), GFP_KERNEL);
 	if (!cdns_mhdp_state)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	__drm_atomic_helper_bridge_reset(bridge, &cdns_mhdp_state->base);
 
-- 
2.53.0



