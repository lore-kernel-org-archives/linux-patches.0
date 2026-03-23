Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DDE3AD50A;
	Mon, 23 Mar 2026 14:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275048; cv=none; b=jSPF2BdP6guRE39VKdMynohAB9LXiOookNpkJKBVRQz++GUpFzZfWCHP5eBLTAp2/j9StPaN+Xv2MMjJjwIbnN8y8yRCY5neixyuct9I5FgmrbNbDTEL8JnEiTTRMCXvvfp0dd6CzuW8g87s/Ng0DOmsOvtmrWn9moMqY6h9OoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275048; c=relaxed/simple;
	bh=2lBreaDLY4/rx66oQRtnW+4WOnPRpsQfHLYfrEh1LQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEBpYwK0LJWAzYlGhOCYaJpaUT3nnWx8hiY+B3/UjGZwwlKtbkHN87EDicOCdGbTAlhQaFDOj1c3UNGIEAIKm0njnf+v8LKVobLVaeSwFID9jV0SEqmmYq0so7JbgScCJ+o1T09LZaQe96m2Sefjxfjt8hzzdxTqtYHoik60jmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KPrkTDho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KPrkTDho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D163C4CEF7;
	Mon, 23 Mar 2026 14:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275047;
	bh=2lBreaDLY4/rx66oQRtnW+4WOnPRpsQfHLYfrEh1LQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KPrkTDhowcEaMqGAQmIQHgKPqyVrG8kWUeXlxcubkWLdWRJ4dna6/QYhddOP2KEbd
	 smz25TL/XOhs/SZMoUVAi/fmjUeF/amAKF6rC0+tTBXfUowAH10Fl34eRkruCjx6Et
	 ofMVEZO8Exy97/qH8Q0UywIORAdPAZKMBzzc1i2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Nguyen <theofficialflow1996@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 203/212] drm/amd: fix dcn 2.01 check
Date: Mon, 23 Mar 2026 14:47:04 +0100
Message-ID: <20260323134510.201937323@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Nguyen <theofficialflow1996@gmail.com>

[ Upstream commit 39f44f54afa58661ecae9c27e15f5dbce2372892 ]

The ASICREV_IS_BEIGE_GOBY_P check always took precedence, because it includes all chip revisions upto NV_UNKNOWN.

Fixes: 54b822b3eac3 ("drm/amd/display: Use dce_version instead of chip_id")
Signed-off-by: Andy Nguyen <theofficialflow1996@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9c7be0efa6f0daa949a5f3e3fdf9ea090b0713cb)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c
index 15cf13ec53026..c450feae5fa5b 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/clk_mgr.c
@@ -255,6 +255,10 @@ struct clk_mgr *dc_clk_mgr_create(struct dc_context *ctx, struct pp_smu_funcs *p
 			BREAK_TO_DEBUGGER();
 			return NULL;
 		}
+		if (ctx->dce_version == DCN_VERSION_2_01) {
+			dcn201_clk_mgr_construct(ctx, clk_mgr, pp_smu, dccg);
+			return &clk_mgr->base;
+		}
 		if (ASICREV_IS_SIENNA_CICHLID_P(asic_id.hw_internal_rev)) {
 			dcn3_clk_mgr_construct(ctx, clk_mgr, pp_smu, dccg);
 			return &clk_mgr->base;
@@ -267,10 +271,6 @@ struct clk_mgr *dc_clk_mgr_create(struct dc_context *ctx, struct pp_smu_funcs *p
 			dcn3_clk_mgr_construct(ctx, clk_mgr, pp_smu, dccg);
 			return &clk_mgr->base;
 		}
-		if (ctx->dce_version == DCN_VERSION_2_01) {
-			dcn201_clk_mgr_construct(ctx, clk_mgr, pp_smu, dccg);
-			return &clk_mgr->base;
-		}
 		dcn20_clk_mgr_construct(ctx, clk_mgr, pp_smu, dccg);
 		return &clk_mgr->base;
 	}
-- 
2.51.0



