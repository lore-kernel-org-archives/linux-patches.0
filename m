Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FB4336888;
	Tue, 21 Jul 2026 17:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653775; cv=none; b=tsQp+sctbS+dnvy2fyJdJBm+gEpzI2+RGou98/X1UbX3vlQ4cx9QNjRBrXvIeJQRTaRbnRW7xjy/9dgvKkcorbk3nFjr0oM44MsG1mJYuu9iPbMsD1RJFp6VHQ4mCUOIZWJ9IBLsNShJGftypHAm8VOLcbqweCSIekm2xojuIVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653775; c=relaxed/simple;
	bh=GYxHBJJs8XP5hfPjvg7y41SC/3xuDOg6txWM6YlvaaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qmdV5pAnNUoBHz7O//+iEAq5g7sy/aXMSZltl6yL1ORrWRgByLJdqKA6BMvvWTO+ztMctNfjYwi2IYSHWW328v/h8ID1zCcAeR99xngxbOf8A1anJ1BD9fmpw0KxaZ+bCcEzr/IJ6QIUqqWqhTRWCla3VALS2uvtSkXUB3ou3ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pd1wREvv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pd1wREvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B381F00A3A;
	Tue, 21 Jul 2026 17:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653774;
	bh=t2W/P5OsA2kP8GzOTIHUJp8//BVfiKyAn29sSwZLW70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pd1wREvvTx+44HELDQrLwW0M4aKYNXaqnXLstq9zVkMDIaDoooPb+IgqaPlJyw+AV
	 D0t2AmyfIlK19nRhZK2xNm6Ti0VeB8qa22EbTKvdpNK/VjvehbW9O5y0Y22wYn9T+p
	 iBnAf3o5I/gEa2gNO9D807R1ENf3iGCwGAGnJGJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1454/2077] drm/i915/ltphy: Fix SSC Enablement bit in PORT_CLOCK_CTL
Date: Tue, 21 Jul 2026 17:18:47 +0200
Message-ID: <20260721152627.095143272@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Kandpal <suraj.kandpal@intel.com>

[ Upstream commit e91da9053006da622b865e672a4a37439a3bb88b ]

According to Bspec we only need to write SSC Enable PLL A bit
and leave PLL B bit alone in PORT_CLOCK_CTL register.

Bspec: 74667, 74492
Fixes: 3383ba2479f7 ("drm/i915/ltphy: Enable SSC during port clock programming")
Signed-off-by: Suraj Kandpal <suraj.kandpal@intel.com>
Reviewed-by: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Link: https://patch.msgid.link/20260701091503.1302226-3-suraj.kandpal@intel.com
(cherry picked from commit 8e27f752037e72ccee9c4a7c4a6202ecf3daf603)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_lt_phy.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_lt_phy.c b/drivers/gpu/drm/i915/display/intel_lt_phy.c
index 657ad5cb0eff92..af5391ba855f1f 100644
--- a/drivers/gpu/drm/i915/display/intel_lt_phy.c
+++ b/drivers/gpu/drm/i915/display/intel_lt_phy.c
@@ -1223,11 +1223,7 @@ intel_lt_phy_program_port_clock_ctl(struct intel_encoder *encoder,
 	else
 		val |= XELPDP_DDI_CLOCK_SELECT_PREP(display, XELPDP_DDI_CLOCK_SELECT_MAXPCLK);
 
-	 /* DP2.0 10G and 20G rates enable MPLLA*/
-	if (port_clock == 1000000 || port_clock == 2000000)
-		val |= XELPDP_SSC_ENABLE_PLLA;
-	else
-		val |= ltpll->ssc_enabled ? XELPDP_SSC_ENABLE_PLLB : 0;
+	val |= ltpll->ssc_enabled ? XELPDP_SSC_ENABLE_PLLA : 0;
 
 	intel_de_rmw(display, XELPDP_PORT_CLOCK_CTL(display, encoder->port),
 		     XELPDP_LANE1_PHY_CLOCK_SELECT | XELPDP_FORWARD_CLOCK_UNGATE |
-- 
2.53.0



