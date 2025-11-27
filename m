Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343E73346B6;
	Thu, 27 Nov 2025 15:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255932; cv=none; b=GFVsnHxMlrP4MI5rqH4xUzyl3v5IWZIA0E6aUhr8Pgz1CQY9nwl0X3r7d8liKphyMvIyuxnPQ1VLq6cgKxxhD1Ztrck4L9MTge4VTFQZ4k8lU01Fzpnyle5TLvuB09Rd6Ovsw4xVxmgyb/vvHxpJmzcsRDdjB4B/JR7iQu1wAs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255932; c=relaxed/simple;
	bh=IE5FwuaDmVjNOWi1OVa3wo/707CcKF0iI0Q1Dc4OoCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jy5OSWsD2SIH33mrbkkG8HAx75gPvekaBe37sLkt0Uhpg4t+vW+gt9MVTUjnNC+zAzsrCswfZQrmo9UvEdL72Kkl41P76N1cUlxnUv61DNdaufvMHPs1tX1/LSB5cpx6XJjwJGe5IR+8QBhtTJo2ybed0o25Ow8kanLxOo/zLDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezwuV+Yx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezwuV+Yx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634B4C4CEF8;
	Thu, 27 Nov 2025 15:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255931;
	bh=IE5FwuaDmVjNOWi1OVa3wo/707CcKF0iI0Q1Dc4OoCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezwuV+YxUcfj/xvU4JoV5/YenRbEiT79gDdFE1bgSp/SfoNFnvPiEXpu9st+uN/0f
	 nnV4Nd7Hule7du2/GJKAJ6dAq2hIuICebrzl1XJPwKF4UtcrmP3LB1SNX6Di9WexQP
	 aJHcnF6oSFkE8Q3pyRkLh9/OBHevW9Kycc01t6O8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Animesh Manna <animesh.manna@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 163/175] drm/i915/dp_mst: Disable Panel Replay
Date: Thu, 27 Nov 2025 15:46:56 +0100
Message-ID: <20251127144048.904550247@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit f2687d3cc9f905505d7b510c50970176115066a2 ]

Disable Panel Replay on MST links until it's properly implemented. For
instance the required VSC SDP is not programmed on MST and FEC is not
enabled if Panel Replay is enabled.

Fixes: 3257e55d3ea7 ("drm/i915/panelreplay: enable/disable panel replay")
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/15174
Cc: Jouni Högander <jouni.hogander@intel.com>
Cc: Animesh Manna <animesh.manna@intel.com>
Cc: stable@vger.kernel.org # v6.8+
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patch.msgid.link/20251107124141.911895-1-imre.deak@intel.com
(cherry picked from commit e109f644b871df8440c886a69cdce971ed533088)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -602,6 +602,10 @@ static void _panel_replay_init_dpcd(stru
 	struct intel_display *display = to_intel_display(intel_dp);
 	int ret;
 
+	/* TODO: Enable Panel Replay on MST once it's properly implemented. */
+	if (intel_dp->mst_detect == DRM_DP_MST)
+		return;
+
 	ret = drm_dp_dpcd_read_data(&intel_dp->aux, DP_PANEL_REPLAY_CAP_SUPPORT,
 				    &intel_dp->pr_dpcd, sizeof(intel_dp->pr_dpcd));
 	if (ret < 0)


