Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D026E305E3A;
	Tue, 11 Nov 2025 01:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823375; cv=none; b=eSmHBO51Fk3vkIKT+nq7BJgN9c509D67nZ6eSgzFq0t7IyKBlZGGwEUgKByGFn7MDaZ9Lu3S0Xe6UHlTvpn2kIzLftebWtSeipAs25/pv4jQmAAkohaASRuXMNLWc5bziIMlRwq4h31u3YaoioUuh35Z8HNoOx2lG2hGPmTdioc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823375; c=relaxed/simple;
	bh=K4WAVLN7q5rUazgtzb+eX1PwRbikDXtH8nl2umbM/8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b2wKSTUnUW/BcuA2vybJJZCKXdP7u4FDHMHM9iM1dARg06Ux0QEwVcp889I0zOsDlaDuOi08+l/r2LRPHnAzVCUEB+tzEV4HPixS1RuRppHSkwKxPXlhIQFdH5n3u5CdTDSrbk26OBaLjuxX3xkRyY1efdlb+0Ykg12EP/VS85U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFejr8YZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFejr8YZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70BE4C113D0;
	Tue, 11 Nov 2025 01:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823375;
	bh=K4WAVLN7q5rUazgtzb+eX1PwRbikDXtH8nl2umbM/8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFejr8YZ7Q3s3gAW7A35+/93mAwi8FzSf7e5NrgjIL/iKM8AoaNE6celsK1+h/Tnx
	 4Z4KQEvqfjyGXONqgYpp3VBo54Tik1F2c/RI+V4Y31ErDpCGljWRO415Q+N1Ygnef/
	 f1wc+UI7QeNOqMa4qLRDkREkf55wy7MKwLhDMQmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 286/849] drm/bridge: cdns-dsi: Dont fail on MIPI_DSI_MODE_VIDEO_BURST
Date: Tue, 11 Nov 2025 09:37:36 +0900
Message-ID: <20251111004543.326722257@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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
index 9f1c460d5f0d4..0cc83bdb130fc 100644
--- a/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
+++ b/drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c
@@ -1088,10 +1088,6 @@ static int cdns_dsi_attach(struct mipi_dsi_host *host,
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



