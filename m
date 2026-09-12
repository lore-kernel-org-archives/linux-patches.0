Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948CC3B813A;
	Sat, 12 Sep 2026 07:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196868; cv=none; b=WJ9YVrNgSrzcmYwsJ7xN4/31O70eMPkw0fSTmRme7NIAMNs+1+XVOCZqhrb+4/UdiD5kMejhb5sAlQFRAX0pF0AG7NLUkoC0CkIEUhkN+hbYKOiCs1biGfangII0CD4jR67rl6lhZ5MvemdVisttV143iT9mrqZKvo3tT1/6lFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196868; c=relaxed/simple;
	bh=H+byJcrZv0UNP3KfWQXM3BRtCGbctBQxdnvVGoSmqfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOMTyUHoHdzH7AOMU1YqpNgjjkPAOVE6hN9VvW2/fATbs00p9GltNJHVAofjI9Sg5h9kiCYWA99dfHTxfvDHCF89XqyuE2cO/q9shLuyON0/GZFZ8E4ylBzezzrdaiq2sJR1Y5+7R91kdip0N34g4+INSu/QNr8jbkmJr6VBE/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZCIVAK5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZCIVAK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC3D1F000FF;
	Sat, 12 Sep 2026 07:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196867;
	bh=6PJEXB8iTlGkWAA2cd5a8JLTxJte59BRRB251ju6bPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QZCIVAK5LsMralfY3bJfLUXcjx6/51rmrextcv3IQiQJPAb2vrQ5ZI5T/wAU7UVra
	 o8JIArypHAD2mK7WarMmNvdm4yWGJ98R09SCrfXHmRf+ROcoWJdmy60iZEy598zrBb
	 fqu43+MjGTFHwcJF1CTfjZ98iwrHfjlIO93kO9Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0054/1815] drm/bridge: cdns-dsi: Return an error pointer on allocation failure
Date: Sat, 12 Sep 2026 08:30:04 +0200
Message-ID: <20260912065650.284197027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index cf90d4468b5c1..344c3f4660185 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
@@ -1015,7 +1015,7 @@ cdns_dsi_bridge_atomic_reset(struct drm_bridge *bridge)
 
 	dsi_state = kzalloc_obj(*dsi_state);
 	if (!dsi_state)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	memset(dsi_state, 0, sizeof(*dsi_state));
 	dsi_state->base.bridge = bridge;
-- 
2.53.0



