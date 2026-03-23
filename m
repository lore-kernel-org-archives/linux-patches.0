Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD4A26F28D;
	Mon, 23 Mar 2026 14:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277471; cv=none; b=LfD6lh/16qWq9nlilTk6IdIyRXGej506L5HLTZejXNsLH/RXBx3yDnCumfYQQMhd1xZMCqnWjpA/LWFNUYvbnl7e97mdtHfhcoC1IfciNxYPzVrUgCCTDNVRG09KX2m8NYB3FwcD7VYjLb8I26W/OKEQp1Yr4EdGBn0OS17Oje0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277471; c=relaxed/simple;
	bh=vMiw7AdxNXlu5pxSx1dkJhJGjNO/XcT1D6IvfcrovnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gOoyeRMro7ApibeK72YPt2hEsp9Vw2XDbiHBvUPDa1SOWwuycfhA3jEAoyJ9a5I62tmWeJCF3o+o4plmTJWUgbVELNZ7TuwtT+kJ4pOdoT0MdqERIQvaZpGERAjDG+II0QCHjla9DJqH6JaGHf8x+wolm4QUUhPEXl+E3A3C0N8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZMn18r/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZMn18r/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37318C4CEF7;
	Mon, 23 Mar 2026 14:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277471;
	bh=vMiw7AdxNXlu5pxSx1dkJhJGjNO/XcT1D6IvfcrovnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZMn18r/Ep2pegnVAiHSAfSLb15qyA+M8KGTjqS+NqIWjJl0zT11w+XnD+yO3GmeY
	 ezvw3A49Zw63SEyaMTfiUwpsPno6KjUgi6KIPPkLLLZq7J9h3kiLlUNrw16rK03F7F
	 MnRtNkAU8O5NqR/bspwlcVnJicJwlMJIVOm/rcC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Nguyen <theofficialflow1996@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 452/460] drm/amd: fix dcn 2.01 check
Date: Mon, 23 Mar 2026 14:47:28 +0100
Message-ID: <20260323134537.687756842@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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
index a0c1072c59a23..7de77358e1c08 100644
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



