Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9C734A3A7;
	Tue, 11 Nov 2025 01:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823234; cv=none; b=rPIvNss4478BKPz0LjQKYNmgvBoZLnK7U6i6t472UcPplj0cbkRs75HQDDSzIYQu1wHD1vstR5TKyP7hxa9Ve0uC+qfeUNHXavkgTrHwZnIp2Hl6zOua1z1vVN/w/Ad3Ou9hCV4FHSHjmevp7yAPV4o6H6Ln7AobCRf19KQQmIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823234; c=relaxed/simple;
	bh=0xCZPVD8EQyt4u83QDzNR+sHIomW2r9LD1byuRG/NpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLjG5mBZPWN+3CFOz+MuZ2IN7yqYX0UpwZugsyEUQld2JbQBVLZ3hBUylg8kc6KX0jl5c4IR53nnubKbVvQIpH/ceNufgYm+Rl/tOU/SyxT5dHHHMgTmOODojKWzWmkxq2kx6XJMZhB9FLYp2wm1gfKlF4r7fjnesYRiSAU+jBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrrsfqE7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrrsfqE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8FFC113D0;
	Tue, 11 Nov 2025 01:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823234;
	bh=0xCZPVD8EQyt4u83QDzNR+sHIomW2r9LD1byuRG/NpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vrrsfqE7C2+zwpvZBVve1Zr3HlFI3iJjc59SQ8JU+wkMHwe05PEBjvIqvLZU0MQ7M
	 lAyUNW7UcEUcFeI8uFPZOB1ciCEXaKIZGMqVamqSQQpXjhH+PvbFGgIH5qLL4pHNGw
	 3ckh/BHVoaB9v1uAT2zFsh5gGRmyb7VO3gkmH2fw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 202/565] drm/bridge: cdns-dsi: Dont fail on MIPI_DSI_MODE_VIDEO_BURST
Date: Tue, 11 Nov 2025 09:40:58 +0900
Message-ID: <20251111004531.470616268@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

[ Upstream commit 7070f55f294745c5a3c033623b76309f3512be67 ]

While the cdns-dsi does not support DSI burst mode, the burst mode is
essentially DSI event mode with more versatile clocking and timings.
Thus cdns-dsi doesn't need to fail if the DSI peripheral driver requests
MIPI_DSI_MODE_VIDEO_BURST.

In my particular use case, this allows the use of ti-sn65dsi83 driver.

Tested-by: Parth Pancholi <parth.pancholi@toradex.com>
Tested-by: Jayesh Choudhary <j-choudhary@ti.com>
Reviewed-by: Devarsh Thakkar <devarsht@ti.com>
Link: https://lore.kernel.org/r/20250723-cdns-dsi-impro-v5-15-e61cc06074c2@ideasonboard.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c b/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
index faa0bdfd19370..ddfbb2009c8d3 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
@@ -959,10 +959,6 @@ static int cdns_dsi_attach(struct mipi_dsi_host *host,
 	if (output->dev)
 		return -EBUSY;
 
-	/* We do not support burst mode yet. */
-	if (dev->mode_flags & MIPI_DSI_MODE_VIDEO_BURST)
-		return -ENOTSUPP;
-
 	/*
 	 * The host <-> device link might be described using an OF-graph
 	 * representation, in this case we extract the device of_node from
-- 
2.51.0



