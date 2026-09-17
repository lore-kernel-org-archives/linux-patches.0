Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BAC50E5BA;
	Thu, 17 Sep 2026 17:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667638; cv=none; b=mksV7xNqw5ORvbmE4wlkNIz0wsWrmXaBk41iP/Dd84NHgVi6HG3ajoxZVCHlrMY6Zgn3TvEN0yw2LS5EmCOKs5ohovmnYWUKkwU23egZUXyRdiyWy/VsGv68rITppr2dfqMnOGoWL+8kuy5nUPmxrmO3cB9kd0be1NL4xZisX0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667638; c=relaxed/simple;
	bh=5ncq+uNGa1xQ6LzLevZEy8kUXS2Voj0Rb9R0RKLAAgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJI4lKbhiCDgclv2oa/WA9NbWE/UdnnyBMzB17ysiQpJWkjWuJ3dBWRR6ziR2oGGS7ECyzOWx2jCAVNh+6RRdMZbXBDsYiuNFmkdGZQ/OydgR6Kmn3t8uYTU8VdCzE+Gghepw7HgOBuysFEjUROEcRyTW+2uFMv6gj1uUI9e3HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VlkP7FIQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VlkP7FIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956F31F000FF;
	Thu, 17 Sep 2026 17:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667637;
	bh=ymhRzpPyu4pU8C45n3tDxF1voDamBAqNPa+Byp99qIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VlkP7FIQ3pvMaf4tP4zjpbvoU2UQRAuy4ceJ0w7lOphPHfzMK6abHfaZuGGrGMH7f
	 dKy9LPULFBFIWBd12gBg4bGZdDj6C+Jx88ltkbyhX6ogHS19V3l+hSKLNDq9rZ7zSR
	 naKtRdosTB/5tUjuEO2llFhsRoPLFtzzMWMbsp74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Mika Kahola <mika.kahola@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Shawn C Lee <shawn.c.lee@intel.com>
Subject: [PATCH 6.12 0158/1102] drm/dp: Add DSC virtual DPCD quirk for Realtek MST branch device
Date: Thu, 17 Sep 2026 16:01:41 +0100
Message-ID: <20260917151543.502101543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit bff2da7aa0020eb72e42d63868dc5adaa0fb85d3 ]

The ASUS DC301 USB-C dock containing a Realtek MST branch device
supports the DSC decompression functionality on each of the dock's
downstream connectors, even though there is no discoverable peer-to-peer
virtual device in the MST topology (which the DP Standard
requires/suggests to control the DSC functionality on a per-DFP basis).
Add the DP_DPCD_QUIRK_DSC_WITHOUT_VIRTUAL_DPCD quirk for this branch
device as well to enable the DSC decompression functionality on all DFP
connectors of the dock, similarly to how this is done for dock's
containing older Synaptics branch devices.

Cc: Lyude Paul <lyude@redhat.com>
Reported-and-tested-by: Shawn C Lee <shawn.c.lee@intel.com>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patch.msgid.link/20260525125516.2794636-1-imre.deak@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/display/drm_dp_helper.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/display/drm_dp_helper.c b/drivers/gpu/drm/display/drm_dp_helper.c
index abcc2538b9bee..2ba6d10247f4f 100644
--- a/drivers/gpu/drm/display/drm_dp_helper.c
+++ b/drivers/gpu/drm/display/drm_dp_helper.c
@@ -2280,6 +2280,8 @@ static const struct dpcd_quirk dpcd_quirk_list[] = {
 	{ OUI(0x00, 0x00, 0x00), DEVICE_ID('C', 'H', '7', '5', '1', '1'), false, BIT(DP_DPCD_QUIRK_NO_SINK_COUNT) },
 	/* Synaptics DP1.4 MST hubs can support DSC without virtual DPCD */
 	{ OUI(0x90, 0xCC, 0x24), DEVICE_ID_ANY, true, BIT(DP_DPCD_QUIRK_DSC_WITHOUT_VIRTUAL_DPCD) },
+	/* Realtek DP1.4 MST hubs can support DSC without virtual DPCD */
+	{ OUI(0x00, 0xe0, 0x4c), DEVICE_ID('D', 'p', '1', '.', '4', 0), true, BIT(DP_DPCD_QUIRK_DSC_WITHOUT_VIRTUAL_DPCD) },
 	/* Synaptics DP1.4 MST hubs require DSC for some modes on which it applies HBLANK expansion. */
 	{ OUI(0x90, 0xCC, 0x24), DEVICE_ID_ANY, true, BIT(DP_DPCD_QUIRK_HBLANK_EXPANSION_REQUIRES_DSC) },
 	/* MediaTek panels (at least in U3224KBA) require DSC for modes with a short HBLANK on UHBR links. */
-- 
2.53.0



