Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261F63502A2;
	Fri, 21 Nov 2025 13:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732519; cv=none; b=oikdTyab9fxwpt+Pvl1qfFQwvTpxLqWEMOkDR5CycdkwGcdjCqg0vor8wHYEN+qt0bjBvn0NKvTGCABydG9+ikSfbGokQ0Z2P3FgeGcnXhVMcJkPJVsrjDD+OAO2HRpJwEg4tQ3XCv4dv40lXayKyNfxA+EeSIVam1zgyFQ8pLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732519; c=relaxed/simple;
	bh=VbQIlo3T0mkBAJTND9yL02C5qYGFLadpBMugPvtEzv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YhvmULEbm/tA8IUjky3q30LJ6gmlgnMebl+hC9JFosjJbkyP8Er1CtB5cd1RWucvmxbMztquvKW1yHpUNhoRjEPyj7mm+lDdRXj+zI30PIU2nMf+97w0aa94Y+DdiY8P7dnCLYHqjUB54X5JZbv7Yl7WcADSi0qpB6aGJVhW/pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfcGrDHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfcGrDHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4F4C4CEF1;
	Fri, 21 Nov 2025 13:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732519;
	bh=VbQIlo3T0mkBAJTND9yL02C5qYGFLadpBMugPvtEzv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YfcGrDHRogNPMbZ+D1gVzbfVBcyeudoRh4+zI2WHNbpeBi/ZToKDeyZbVXNPzkpNN
	 kbm1grZUPU5CojSGrkHD+Ca1n9nII4+dRiM5RWRZzSCwGqsKG5Ds1xdQRigIjhuu+W
	 z7xI4HrMFM6s/I5XLN74yytv/FWSOawRIjPbxjQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 132/529] drm/bridge: cdns-dsi: Dont fail on MIPI_DSI_MODE_VIDEO_BURST
Date: Fri, 21 Nov 2025 14:07:11 +0100
Message-ID: <20251121130235.715900996@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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



