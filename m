Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9350625A323;
	Tue, 27 May 2025 17:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365513; cv=none; b=SBQkqIJcy2S/XDX8ZGoschESyJ6nefDm8jNwtO7D+Xksy3LYtNWTl/sWyWZ6kd/khXgZrhzUqiJZS6i0FCUTDIJyoBruLtpuzH39eKiq2ZMOo9k8Svt1ENaaPlXoHoDvJ9BKJqbYi5H0Iw+jB2xHLH9SXnrG5X1hOsqTT4Dk86w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365513; c=relaxed/simple;
	bh=4cQ7qcBY+5kdfLdRvcYWhEMbd0HCN/74Gj4oNYKdYjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTRGqcNNcqt1LyjxZZIGouinUJg9RMFg/XFwEA0a50nF9xxiyAA+hNw0EGTVxJ20/EFRS6kxqztJTQ3vaPCBr9IYD6RRPjC94I9J48anW4mdE0FCoBCbi0TS3vMc/lMrrRQnv6EqbJFy30lmA74YB6vmFvsI1eHmJ/OfWqMdBS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0zRcnw3c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0zRcnw3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077E6C4CEEB;
	Tue, 27 May 2025 17:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365513;
	bh=4cQ7qcBY+5kdfLdRvcYWhEMbd0HCN/74Gj4oNYKdYjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0zRcnw3cAehd71UHej6pnfLPm2vQuwpP0UEF3R++8uN2dWofWDLrGWlhEvvlXoV09
	 kMY5zmS3SCkBeyQ85XQV9emBSmknFQj4OIoyOx9lNtkSM+XOZRB3XCMMJQUmNedg6Q
	 us++OwFiWvKggmdzpd5XNVpb7itoAJLVb4OyIx+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 400/626] drm/amd/display: Populate register address for dentist for dcn401
Date: Tue, 27 May 2025 18:24:53 +0200
Message-ID: <20250527162501.271107256@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Dillon Varone <dillon.varone@amd.com>

[ Upstream commit 5f0d1ef6f16e150ee46cc00b8d233d9d271fe39e ]

[WHY&HOW]
Address was not previously populated which can result in incorrect
clock frequencies being read on boot.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Signed-off-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c | 2 ++
 drivers/gpu/drm/amd/display/dc/inc/hw/clk_mgr_internal.h       | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c
index 8cfc5f4359374..313e52997596a 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c
@@ -24,6 +24,8 @@
 
 #include "dml/dcn401/dcn401_fpu.h"
 
+#define DCN_BASE__INST0_SEG1                       0x000000C0
+
 #define mmCLK01_CLK0_CLK_PLL_REQ                        0x16E37
 #define mmCLK01_CLK0_CLK0_DFS_CNTL                      0x16E69
 #define mmCLK01_CLK0_CLK1_DFS_CNTL                      0x16E6C
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/clk_mgr_internal.h b/drivers/gpu/drm/amd/display/dc/inc/hw/clk_mgr_internal.h
index 7a1ca1e98059b..221645c023b50 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/clk_mgr_internal.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/clk_mgr_internal.h
@@ -221,6 +221,7 @@ enum dentist_divider_range {
 	CLK_SF(CLK0_CLK_PLL_REQ, FbMult_frac, mask_sh)
 
 #define CLK_REG_LIST_DCN401()	  \
+	SR(DENTIST_DISPCLK_CNTL), \
 	CLK_SR_DCN401(CLK0_CLK_PLL_REQ,   CLK01, 0), \
 	CLK_SR_DCN401(CLK0_CLK0_DFS_CNTL, CLK01, 0), \
 	CLK_SR_DCN401(CLK0_CLK1_DFS_CNTL,  CLK01, 0), \
-- 
2.39.5



