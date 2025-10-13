Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD9A17A2EC;
	Mon, 13 Oct 2025 15:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369422; cv=none; b=t7XeZW5H9+V968JLK7e4EPTqsA8+ajR3SF0QuyX+Eq2RvZKG+iufL+U1vN7Pgi9X/FXLUFsKLqSe1mqMBA6FS5lIwGISQCMWiXoFN3f8W2estktuNtXdS8SQy3ZdZxaL1ItSp8idAQPO2N8YJoJdKYB68CtjWsuqQsWR6lAyvvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369422; c=relaxed/simple;
	bh=t9HuVU1QIqGWlyNzrWCGlK3ZKS2uf3bRkQS/L5H0BaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3fn8edSUKG5fpzFOBY7J+bJ8n266uQXIkMx9pdHRvq+vbVaiYE0O4wmICD7c++xsuroocXJIXs7BlCGsf6bDV9cMnufnYfQEnEYtIGqjxcpO7HQFHpiWoNc+6rGFRGFneUrFJF7QTSxfV62kgQHqqhFZFLXRXatTzFT9t0IJfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5CsVdhu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5CsVdhu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74300C4CEE7;
	Mon, 13 Oct 2025 15:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369421;
	bh=t9HuVU1QIqGWlyNzrWCGlK3ZKS2uf3bRkQS/L5H0BaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5CsVdhuRmmnmI1tEWcoBsgEuICEm5OSR7OO9OtAZsL30Kyvk49dFKKFeQOEM0X9M
	 GwK5ZJpZFQv4O4Itk33F5+/5AIvbiswJ48Br4AzaYvZNHKhTXkVEXimApDHIOKUHgp
	 pGIsdSdwsW+8M1isVXCskzAOPMfob53hCRVs/AOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 233/563] drm/bridge: cdns-dsi: Fix the _atomic_check()
Date: Mon, 13 Oct 2025 16:41:34 +0200
Message-ID: <20251013144419.720989474@linuxfoundation.org>
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

From: Aradhya Bhatia <aradhya.bhatia@linux.dev>

[ Upstream commit 04864af849d9ae0dd020798f5b3632d9cf26fa03 ]

Use the "adjusted_mode" for the dsi configuration check, as that is the
more appropriate display_mode for validation, and later bridge enable.

Also, fix the mode_valid_check parameter from false to true, as the dsi
configuration check is taking place during the check-phase, and the
crtc_* mode values are not expected to be populated yet.

Fixes: a53d987756ea ("drm/bridge: cdns-dsi: Move DSI mode check to _atomic_check()")
Signed-off-by: Aradhya Bhatia <aradhya.bhatia@linux.dev>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Tested-by: Jayesh Choudhary <j-choudhary@ti.com>
Reviewed-by: Devarsh Thakkar <devarsht@ti.com>
Link: https://lore.kernel.org/r/20250723-cdns-dsi-impro-v5-1-e61cc06074c2@ideasonboard.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c b/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
index a57ca8c3bdaea..695b6246b280f 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
@@ -997,10 +997,10 @@ static int cdns_dsi_bridge_atomic_check(struct drm_bridge *bridge,
 	struct cdns_dsi_input *input = bridge_to_cdns_dsi_input(bridge);
 	struct cdns_dsi *dsi = input_to_dsi(input);
 	struct cdns_dsi_bridge_state *dsi_state = to_cdns_dsi_bridge_state(bridge_state);
-	const struct drm_display_mode *mode = &crtc_state->mode;
+	const struct drm_display_mode *adjusted_mode = &crtc_state->adjusted_mode;
 	struct cdns_dsi_cfg *dsi_cfg = &dsi_state->dsi_cfg;
 
-	return cdns_dsi_check_conf(dsi, mode, dsi_cfg, false);
+	return cdns_dsi_check_conf(dsi, adjusted_mode, dsi_cfg, true);
 }
 
 static struct drm_bridge_state *
-- 
2.51.0



