Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC235198E96;
	Wed,  6 Nov 2024 12:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896416; cv=none; b=m8vxJePOEa0Ui16aKpJhRPSuZnvPD5Q4p70wcYmRts3QAtt25tlvh9+3XXMWHmn4T0iGzm8Prq3R/nrilRPFEG+c881vVgLorNPtSTlZZ3v2I2WnkzNEodZMo4Kz+Vb4huzRX8nIFO6gkLmAFQftHNfN17fhAS2zO4EYiValvGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896416; c=relaxed/simple;
	bh=K0kAEpU12/kiHZQqpwhf75xwBGaC4wjEmsi+TEAJsvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFtPkTw4ZCyeKZgnIjlsxyu52GxkFEg3Ni/kolfWSguaykxvQCP0dr5yS4/wc/7FCbb9PtfmtYdywLpExGUb3Zd+BKQXSGAjS9f74lzns2Bp2eH+EaqH6h1/bJdaO5QwXE/8y0s/DJ/uPKGKK8huhe2NZ2gGJDVSOnD9WzkHLVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BMpPEi01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BMpPEi01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AAFC4CECD;
	Wed,  6 Nov 2024 12:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896415;
	bh=K0kAEpU12/kiHZQqpwhf75xwBGaC4wjEmsi+TEAJsvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BMpPEi01REyCciFqC6jQ/EboYfJ4/OgEr3F/fcXsVfvOLrL+Vclwx40KfZqcX5vCX
	 UlBnmDTNwznum7S9keRKjdMAPVukxQbT8kByCp4i6Euo+I9V8m9DXoVkydb2OgMi3B
	 8Ii0ccI7FwwAg1GaX1WCJ5SbBFxwfwSWiMb8fL7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 193/245] drm/xe: Fix register definition order in xe_regs.h
Date: Wed,  6 Nov 2024 13:04:06 +0100
Message-ID: <20241106120323.996636849@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 9dae9751c7b0086963f5cbb82424b5e4cf58f123 ]

Swap XEHP_CLOCK_GATE_DIS(0x101014) with GU_DEBUG(x101018).

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Reviewed-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240702183704.1022-2-michal.wajdeczko@intel.com
Stable-dep-of: 993ca0eccec6 ("drm/xe: Add mmio read before GGTT invalidate")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/regs/xe_regs.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/xe/regs/xe_regs.h b/drivers/gpu/drm/xe/regs/xe_regs.h
index 23e33ec849022..23ecba38ed419 100644
--- a/drivers/gpu/drm/xe/regs/xe_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_regs.h
@@ -24,12 +24,12 @@
 #define   LMEM_INIT				REG_BIT(7)
 #define   DRIVERFLR				REG_BIT(31)
 
-#define GU_DEBUG				XE_REG(0x101018)
-#define   DRIVERFLR_STATUS			REG_BIT(31)
-
 #define XEHP_CLOCK_GATE_DIS			XE_REG(0x101014)
 #define   SGSI_SIDECLK_DIS			REG_BIT(17)
 
+#define GU_DEBUG				XE_REG(0x101018)
+#define   DRIVERFLR_STATUS			REG_BIT(31)
+
 #define XEHP_MTCFG_ADDR				XE_REG(0x101800)
 #define   TILE_COUNT				REG_GENMASK(15, 8)
 
-- 
2.43.0



