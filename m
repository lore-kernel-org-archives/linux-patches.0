Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09D9433ADB0;
	Tue, 21 Jul 2026 19:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661419; cv=none; b=bcIZoXcYfCYnXPn1C+gmvUd7I8PJTicUa4pIhYaNr/jxXLsea2qnG+oR+WyQUElDfE3aj3RT/pE2NyUI0Hx6HEJQO+AFofqjssTkXJnbQnKK9QUR0jzt1m9mLcVvDYdN+/KOgHElkKBWPgHDw8qRUOK4MloC5Oxci1ndEpuk64A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661419; c=relaxed/simple;
	bh=3uXjBlGy7Cj4H9CmdShkNNaZdJdY77lTQf1CL8f795c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRP0MOTA+HjnGSSrUuZfSyVYjzDy0utiJc471qd9t4opjHgeengcFEEcnZxyKiAx5tpQNwtFdQcEkvWIGE37/3190jwZEDNkcz1QpEtsiO4I3K6zX1wiBa8mFvMrAullFNDJIaxMVoN4tExejcOPNBFF8GEdypNJwk3PoDyTJ8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A7+8HwUl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7+8HwUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 398B41F000E9;
	Tue, 21 Jul 2026 19:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661417;
	bh=qExmIFzJN9m0SuvQvbcUd3YKXj5BNPX9BIGto5ov79o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A7+8HwUlQigJsMWwybhh1B51eupBaNbdHkvoyVsVmvHTvjwnOEZMhwMk+TgtpdHBS
	 cgqMaE0y8gv+MpNplJlz1k00g0dEIgxhFLodsAlRBa82xcMiJBJ2swU0ylrzsNuH/K
	 V6Zx6URUwyqwSpubH69n4OhF+D/ARJ7L1RjThgi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0060/1276] drm/tidss: Drop extra drm_mode_config_reset() call
Date: Tue, 21 Jul 2026 17:08:23 +0200
Message-ID: <20260721152447.427133871@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit f468fef38716f667e805e0fa2c497c6b9c325bb9 ]

We are calling drm_mode_config_reset() twice at probe time. There's no
reason for this and the second call can be removed, reducing work at
probe time slightly.

Fixes: 32a1795f57ee ("drm/tidss: New driver for TI Keystone platform Display SubSystem")
Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://patch.msgid.link/20260311-tidss-minor-fixes-v2-1-cb4479784458@ideasonboard.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tidss/tidss_kms.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/tidss/tidss_kms.c b/drivers/gpu/drm/tidss/tidss_kms.c
index f371518f869710..bc385d31ee6d74 100644
--- a/drivers/gpu/drm/tidss/tidss_kms.c
+++ b/drivers/gpu/drm/tidss/tidss_kms.c
@@ -267,8 +267,6 @@ int tidss_modeset_init(struct tidss_device *tidss)
 	if (ret)
 		return ret;
 
-	drm_mode_config_reset(ddev);
-
 	dev_dbg(tidss->dev, "%s done\n", __func__);
 
 	return 0;
-- 
2.53.0



