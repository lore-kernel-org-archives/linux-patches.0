Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCB0230BED;
	Mon, 10 Mar 2025 17:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627933; cv=none; b=O8K+IA2d8B3MaLKGriDET6fpHZLsNy1BMCZ6mLYWkhXWyDVHQu0qoh1i1FSYuKKDaDHZzzU+G+Fk5MTswCjIsHmpkg/HC92eQQEU565CKoFeEC5XOfGfruTFUFRnN+L+1ksfk1aybNwsg5/h5X1WeZqxwgEN7Py6wfEOeRj3Tgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627933; c=relaxed/simple;
	bh=A4WYIwcvvBHBe7PxNtbZvOJdwDU1c50pjz5cOlRTV2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lqlsm7gj0fvRK/geciSFCA2Tny3wGemplIwQCEvHq4kwJ3VOdXbK7gxNhGhVwdcKTUm9Adwm1LYPy4PsHtH3gKaUXvVpn9asfPxZzQj63B9xZ8xYcpcAieNwaDugunFCeQ8ite2LLqaELVxHxVlR+1sw/OrUk/YyUqJKZnalBPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRfMtWRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRfMtWRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50BD9C4CEE5;
	Mon, 10 Mar 2025 17:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627933;
	bh=A4WYIwcvvBHBe7PxNtbZvOJdwDU1c50pjz5cOlRTV2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRfMtWRcn8LK5UMdgdio3pbGoAeciNVLLBNtWAQZZuIuRrGUjQh32rUa45wk1Dns1
	 9FN3BBUKOqmvaNZgxVtNW7C4BuBiKN1yC+0NBTDAp+GJK8MGhhdlkfS5bIcfoko6DH
	 GNlg+jHsKM8IpZbmWLlGUoyxSqe57mildDPg+lxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jani Nikula <jani.nikula@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/145] drm/i915/ddi: Fix HDMI port width programming in DDI_BUF_CTL
Date: Mon, 10 Mar 2025 18:04:58 +0100
Message-ID: <20250310170434.918297991@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit 166ce267ae3f96e439d8ccc838e8ec4d8b4dab73 ]

Fix the port width programming in the DDI_BUF_CTL register on MTLP+,
where this had an off-by-one error.

Cc: <stable@vger.kernel.org> # v6.5+
Fixes: b66a8abaa48a ("drm/i915/display/mtl: Fill port width in DDI_BUF_/TRANS_DDI_FUNC_/PORT_BUF_CTL for HDMI")
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250214142001.552916-3-imre.deak@intel.com
(cherry picked from commit b2ecdabe46d23db275f94cd7c46ca414a144818b)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_ddi.c | 2 +-
 drivers/gpu/drm/i915/i915_reg.h          | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
index 9ac9df70e713c..893ecee3949ac 100644
--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -3242,7 +3242,7 @@ static void intel_enable_ddi_hdmi(struct intel_atomic_state *state,
 		intel_de_rmw(dev_priv, XELPDP_PORT_BUF_CTL1(port),
 			     XELPDP_PORT_WIDTH_MASK | XELPDP_PORT_REVERSAL, port_buf);
 
-		buf_ctl |= DDI_PORT_WIDTH(lane_count);
+		buf_ctl |= DDI_PORT_WIDTH(crtc_state->lane_count);
 
 		if (DISPLAY_VER(dev_priv) >= 20)
 			buf_ctl |= XE2LPD_DDI_BUF_D2D_LINK_ENABLE;
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 4e588fd1c82ed..589a10253d898 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -5737,7 +5737,7 @@ enum skl_power_gate {
 #define  DDI_BUF_IS_IDLE			(1 << 7)
 #define  DDI_BUF_CTL_TC_PHY_OWNERSHIP		REG_BIT(6)
 #define  DDI_A_4_LANES				(1 << 4)
-#define  DDI_PORT_WIDTH(width)			(((width) - 1) << 1)
+#define  DDI_PORT_WIDTH(width)			(((width) == 3 ? 4 : ((width) - 1)) << 1)
 #define  DDI_PORT_WIDTH_MASK			(7 << 1)
 #define  DDI_PORT_WIDTH_SHIFT			1
 #define  DDI_INIT_DISPLAY_DETECTED		(1 << 0)
-- 
2.39.5



