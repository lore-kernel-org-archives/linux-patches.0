Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5348F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4913C433C8;
	Sun, 16 Jul 2023 20:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539131;
	bh=3Xze7UEVyzESiKgn+fuNt4hPDpK2OF1bCcjDGNa1HDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGvrxXB4+hni8OrjRjjx99+hEkShLekgs1f5+2T8fFB5/xyeSGOgLeq1lDsqIe0KU
	 HrXWQFrncKo7yCUaXRH9fLlL9eR7Dp/nL54QJkbbI+yllrJ/YGBYO70phjrNh27JLC
	 JCIrktC+4k2afWtrHNoyZezOFaXSd1IjBbdHa/4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	=?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 699/800] drm/i915/psr: Fix BDW PSR AUX CH data register offsets
Date: Sun, 16 Jul 2023 21:49:12 +0200
Message-ID: <20230716195005.356222546@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit fdffb7dbc74f48cb1d404d9ab0c9fd769a59caf0 ]

The multiplication got replaced by an addition in some cleanup.
This means we never write the correct data to some of the BDW
PSR data registers and thus we fail to actually wake up the
panel from PSR.

Fixes: 4ab4fa103217 ("drm/i915/psr: Make PSR registers relative to transcoders")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230609141404.12729-3-ville.syrjala@linux.intel.com
Reviewed-by: Jouni Högander <jouni.hogander@intel.com>
(cherry picked from commit 460dc4ba1442b3e5e543328d11db2702b98d3d7c)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr_regs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr_regs.h b/drivers/gpu/drm/i915/display/intel_psr_regs.h
index 958d8cabc44b5..5e3fe23ef8eb2 100644
--- a/drivers/gpu/drm/i915/display/intel_psr_regs.h
+++ b/drivers/gpu/drm/i915/display/intel_psr_regs.h
@@ -75,7 +75,7 @@
 
 #define _SRD_AUX_DATA_A				0x60814
 #define _SRD_AUX_DATA_EDP			0x6f814
-#define EDP_PSR_AUX_DATA(tran, i)		_MMIO_TRANS2(tran, _SRD_AUX_DATA_A + (i) + 4) /* 5 registers */
+#define EDP_PSR_AUX_DATA(tran, i)		_MMIO_TRANS2(tran, _SRD_AUX_DATA_A + (i) * 4) /* 5 registers */
 
 #define _SRD_STATUS_A				0x60840
 #define _SRD_STATUS_EDP				0x6f840
-- 
2.39.2



