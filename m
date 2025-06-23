Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064AC1AD3FA;
	Mon, 23 Jun 2025 21:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715832; cv=none; b=WTSB+NzxOE9uqWztqxIiElZPInv6GGJtAKsLy2CX/tE+5RUmEQ+DH1t2kHdzF4a7zdWeHwUNKtcNFgT9M91egqC2ydLyBwsjVy9dfhsEA2JBTLK7Rfqus0Rg2pXHsDTm4X3vy2EyMxt4dRxuOQ5UwfQ68m9vJsiy4cjZ23Yy/yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715832; c=relaxed/simple;
	bh=MYc+oUy8PfUZaIjBcItiReFa/jortP7htFkllkjUN4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYDsb7drxHdzQHeHyEMn7cubHbDSP+mS8M7fcq7HhBMhl9xrUAGOzKvBw7194uf36BRxCS7e+s8QFWzvQrc66efioZ9pK+D3rhVrMFXDBksljycT4qV1TdqD61mcJAuKOqfMH2i9srK0ayL3RrTBjM83uvdvH7CdrlUKqP+fCWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=axquwhkI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="axquwhkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE4AC4CEEA;
	Mon, 23 Jun 2025 21:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715831;
	bh=MYc+oUy8PfUZaIjBcItiReFa/jortP7htFkllkjUN4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axquwhkIUy57XLk+AFTiqaXn21FBWUnJmUUTkPvh7MnW1nSB84LjbkFjkT0pHVecg
	 oWxKGQoV6ai1MFOf2/LwY0eGzNCz542CGwyWg+84OHuoVXZ+pFX4uMZJ+C83nR9m3Y
	 zJBhCdVJGTJeaH0BEm+Uuq9TioJhMdiU0h3RKONA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"James A. MacInnes" <james.a.macinnes@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 506/592] drm/msm/disp: Correct porch timing for SDM845
Date: Mon, 23 Jun 2025 15:07:44 +0200
Message-ID: <20250623130712.471243374@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James A. MacInnes <james.a.macinnes@gmail.com>

[ Upstream commit 146e87f3e11de0dfa091ff87e34b4bc6eec761a4 ]

Type-C DisplayPort inoperable due to incorrect porch settings.
- Re-used wide_bus_en as flag to prevent porch shifting

Fixes: c943b4948b58 ("drm/msm/dp: add displayPort driver support")
Signed-off-by: James A. MacInnes <james.a.macinnes@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/636945/
Link: https://lore.kernel.org/r/20250212-sdm845_dp-v2-2-4954e51458f4@gmail.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c   | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
index 8220a4012846b..c3c7a0d56c410 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
@@ -94,17 +94,21 @@ static void drm_mode_to_intf_timing_params(
 		timing->vsync_polarity = 0;
 	}
 
-	/* for DP/EDP, Shift timings to align it to bottom right */
-	if (phys_enc->hw_intf->cap->type == INTF_DP) {
+	timing->wide_bus_en = dpu_encoder_is_widebus_enabled(phys_enc->parent);
+	timing->compression_en = dpu_encoder_is_dsc_enabled(phys_enc->parent);
+
+	/*
+	 *  For DP/EDP, Shift timings to align it to bottom right.
+	 *  wide_bus_en is set for everything excluding SDM845 &
+	 *  porch changes cause DisplayPort failure and HDMI tearing.
+	 */
+	if (phys_enc->hw_intf->cap->type == INTF_DP && timing->wide_bus_en) {
 		timing->h_back_porch += timing->h_front_porch;
 		timing->h_front_porch = 0;
 		timing->v_back_porch += timing->v_front_porch;
 		timing->v_front_porch = 0;
 	}
 
-	timing->wide_bus_en = dpu_encoder_is_widebus_enabled(phys_enc->parent);
-	timing->compression_en = dpu_encoder_is_dsc_enabled(phys_enc->parent);
-
 	/*
 	 * for DP, divide the horizonal parameters by 2 when
 	 * widebus is enabled
-- 
2.39.5



