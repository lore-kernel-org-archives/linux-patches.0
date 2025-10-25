Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008B378F36;
	Sat, 25 Oct 2025 16:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409283; cv=none; b=M4yKDrviBXym1M/Te6VsMU+I/r5bUIDMmwVqhj4lXaaY2c9lBzySqIqsLDbYHrkvR6LxAWxLm+3LEHGqtL9FmmWgz7wtpCPsF4fcbu4Hapd1YyTS5Tsnhy417ZbUlc/emPy7hdT1QWCKeHH5YArGyYOvN9XvCinXRq5bmZrz+A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409283; c=relaxed/simple;
	bh=9pR0XHht0t3AY7m5dgV5Hw/iFD1ls0qq6ofsQgv+VMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B7c6nDdi0UklXm/JvZlG7cTajfvqLjwkNXq6kNdGOhIvaua/0RA/zN/6HPhh6Nbf1mdBAcDfM3hevaZ7Y7lF7YUWY9E3s80VzZoyfNiReVWbr9dtiYlEpsxxPBVDQAeEZwg7gXiBmgFD3dRdZgpkEPW1z8H4xwJ0KtKmjT6TU1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SO5VvCXC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SO5VvCXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58AA1C116D0;
	Sat, 25 Oct 2025 16:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409281;
	bh=9pR0XHht0t3AY7m5dgV5Hw/iFD1ls0qq6ofsQgv+VMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SO5VvCXCXeHUckLaHIcxoOcqhkxatCajTKGwyjMJje04t7dEWgm2gWCzyzLAGPTVF
	 wLk8rfOElBE82b/xntNPuQ39KGRVxlxq632iBkq5kdYVaI1BdRZRfVede8UGl2MXUM
	 m6f34UNsl7Nk57XvTdDtZg/+Nab2xRFoPZLnQ/++36+Pp2kSW1SrlLYhWEbzVL6weq
	 WSFDfDMX5N9dNsNY9v5pHFXp01cxiqOGNFYAwMfLNKpMrDVYil89KAq20fEYb4eNgN
	 FskTBymHa00j+gcp0ZTVKSPDr7nnnXigAUXBMMG0uYL63TGfyG5T+0x+r6n6/e5fR3
	 GcGzAiRA4vxAw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Parth Pancholi <parth.pancholi@toradex.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Devarsh Thakkar <devarsht@ti.com>,
	Sasha Levin <sashal@kernel.org>,
	aradhya.bhatia@linux.dev,
	lumag@kernel.org,
	mripard@kernel.org,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-6.6] drm/bridge: cdns-dsi: Don't fail on MIPI_DSI_MODE_VIDEO_BURST
Date: Sat, 25 Oct 2025 11:58:11 -0400
Message-ID: <20251025160905.3857885-260-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

YES

Rationale
- User-visible bugfix: The driver currently rejects any device that sets
  `MIPI_DSI_MODE_VIDEO_BURST`, causing attach to fail for many common
  DSI bridges/panels that default to burst mode (e.g., TI SN65DSI83).
  This is a functional regression for users of the Cadence DSI host
  where the sink would work fine in non-burst/event mode. Removing the
  hard failure allows these devices to work.
- Minimal, localized change: The patch only removes an early return in
  `cdns_dsi_attach()` that rejects `MIPI_DSI_MODE_VIDEO_BURST`:
  - drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c:956-958
    - Comment “We do not support burst mode yet.”
    - `if (dev->mode_flags & MIPI_DSI_MODE_VIDEO_BURST) return
      -ENOTSUPP;`
- No behavioral change for supported paths: The Cadence driver does not
  use `MIPI_DSI_MODE_VIDEO_BURST` anywhere else. A search shows the only
  use is this attach-time rejection
  (drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c:957). All actual mode
  programming is driven by:
  - `MIPI_DSI_MODE_VIDEO` checks (e.g.,
    drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c:890, 907)
  - `MIPI_DSI_MODE_VIDEO_SYNC_PULSE` (e.g.,
    drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c:479, 529, 593, 817,
    824, 890)
  - `MIPI_DSI_MODE_NO_EOT_PACKET` (e.g.,
    drivers/gpu/drm/bridge/cadence/cdns-dsi-core.c:831, 904)
  The driver never sets BURST-related registers (e.g., `BURST_MODE`,
`VID_VCA_SETTING1`), so ignoring the burst bit simply means the host
runs in event/sync-pulse video mode as before.
- Proven practical benefit: The commit message cites enabling the TI
  SN65DSI83 driver. In this tree, that driver sets burst mode by default
  (drivers/gpu/drm/bridge/ti-sn65dsi83.c:657), so the current Cadence
  driver categorically fails to attach even though it could operate in
  non-burst. This change removes an unnecessary blocker.

Risk assessment
- Very low regression risk:
  - Existing working users (who do not request burst) see no change.
  - Devices requesting burst but able to function in event mode will now
    work (previously failed to attach).
  - If a device really requires burst-only operation, it did not work
    before (attach failed); after this change, the host will attempt
    event mode; if the link budget is insufficient, mode
    validation/config will still fail. Users are not worse off than
    before.
- No architectural changes: No clocking or register programming changes,
  no new behavior at runtime beyond not returning `-ENOTSUPP` on attach.
- Subsystem scope: Limited to the Cadence DSI bridge driver; does not
  touch core DRM or DSI frameworks.

Historical/context notes
- The attach-time burst rejection has existed since the original driver
  (git blame shows it dates back to initial integration). Other DSI
  hosts generally don’t reject burst flags at attach; they either
  implement burst or ignore it.
- This patch aligns the driver with a more permissive, capability-
  fallback style: support event/sync-pulse even when the sink asks for
  burst.

Stable backport fit
- Fixes a real, user-facing interoperability issue without adding
  features.
- Small and self-contained with no dependencies on later refactors (the
  only required change on stable trees is removing the three-line
  check).
- No observable side effects beyond enabling previously blocked
  configurations.

Conclusion
- This is an excellent stable backport candidate: it unblocks real
  hardware, is minimal and low risk, and does not introduce
  architectural changes.

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

