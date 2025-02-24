Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD6B84A35;
	Mon, 24 Feb 2025 14:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408621; cv=none; b=N7SMSYyo2sTHtGyDuauystWgcAL7M6BTPkVpFOIsXYA3QUqi3AyH5aduHvheA9r9WgdXPWpIEbReN4VB9xJPVQUs7mB26HHKvsclnaBv+Dm7GkO6SS4dX9Idtpu3a99fTmtYrzlHOinjQ3Ylb3G8MOL2zu4R9RclKk4G4N7tfwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408621; c=relaxed/simple;
	bh=gk7ushm3GRG6IV1Zu0GZ2vIyqUUq3Sntj1Csth5XvmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgczdN2yAiEVdFgsX9LYKNas9zSOQO3isr0Gny6aKMefAtCphqDo77G3V7UnAdNPW0IU5BVeAhiKyTMemTzsTjjPZOdsuVUMgkJI/NZbHB7IPumOz8GOesYjemWvZGN6uh36f5oZ5B/RIBOgNl55//j94wJP3NEliDUzqgCQV8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZTLqG2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZTLqG2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9132C4CED6;
	Mon, 24 Feb 2025 14:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408619;
	bh=gk7ushm3GRG6IV1Zu0GZ2vIyqUUq3Sntj1Csth5XvmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZTLqG2oYV8IVxnEQ9VlDWrHICbmDNvIT48EdG9p+0N40Zg1QFLfZGTXM1YW2xTKl
	 S0gn33n+FzGQStiKJVWrSKk1H3q+KyH6s6Baj6aMVKyJpVtAJxI2VAuEXF2cmx9Gje
	 bwZLGNzvR1HPNO/ovnqslIee61GP+s6trGVrMZLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.12 110/154] drm/i915/ddi: Fix HDMI port width programming in DDI_BUF_CTL
Date: Mon, 24 Feb 2025 15:35:09 +0100
Message-ID: <20250224142611.360890186@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 166ce267ae3f96e439d8ccc838e8ec4d8b4dab73 upstream.

Fix the port width programming in the DDI_BUF_CTL register on MTLP+,
where this had an off-by-one error.

Cc: <stable@vger.kernel.org> # v6.5+
Fixes: b66a8abaa48a ("drm/i915/display/mtl: Fill port width in DDI_BUF_/TRANS_DDI_FUNC_/PORT_BUF_CTL for HDMI")
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250214142001.552916-3-imre.deak@intel.com
(cherry picked from commit b2ecdabe46d23db275f94cd7c46ca414a144818b)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_ddi.c |    2 +-
 drivers/gpu/drm/i915/i915_reg.h          |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -3363,7 +3363,7 @@ static void intel_enable_ddi_hdmi(struct
 		intel_de_rmw(dev_priv, XELPDP_PORT_BUF_CTL1(dev_priv, port),
 			     XELPDP_PORT_WIDTH_MASK | XELPDP_PORT_REVERSAL, port_buf);
 
-		buf_ctl |= DDI_PORT_WIDTH(lane_count);
+		buf_ctl |= DDI_PORT_WIDTH(crtc_state->lane_count);
 
 		if (DISPLAY_VER(dev_priv) >= 20)
 			buf_ctl |= XE2LPD_DDI_BUF_D2D_LINK_ENABLE;
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3869,7 +3869,7 @@ enum skl_power_gate {
 #define  DDI_BUF_IS_IDLE			(1 << 7)
 #define  DDI_BUF_CTL_TC_PHY_OWNERSHIP		REG_BIT(6)
 #define  DDI_A_4_LANES				(1 << 4)
-#define  DDI_PORT_WIDTH(width)			(((width) - 1) << 1)
+#define  DDI_PORT_WIDTH(width)			(((width) == 3 ? 4 : ((width) - 1)) << 1)
 #define  DDI_PORT_WIDTH_MASK			(7 << 1)
 #define  DDI_PORT_WIDTH_SHIFT			1
 #define  DDI_INIT_DISPLAY_DETECTED		(1 << 0)


