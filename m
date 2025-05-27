Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C1A1D63EF;
	Tue, 27 May 2025 17:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367788; cv=none; b=GXcqBN3mfxrPWgUoTgOF+sPzd55QiqbSzCOpOTQ3xHeUEH5IqbWgfmi20Z9VorZBQAx1JZJtOaJPy+TYTCvPHr54Sy44ZsJaWen7D9CnfEjt3bseZ4j/skS+i2WWyPdKGjeFNxM8cLFjsqsBpukGwkHn2AZkwmvTU85SwrN1mY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367788; c=relaxed/simple;
	bh=VOmh2smeaZCVlAH8M/nKicoFifVVewWPWiOACmoNFeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4ysTmI+C/7B2MhLpfpm+vyO7UtNWZblVPzpay6BdqpwRb09EEXkk31LURFYIt5vGv1uNWa1mzWqkQwAHI7xOeNoAf7eIx2VQCh1H5TQItm/4nqwnSQgIUhm/Tyz+5+pec4v0yLjLS68QJHUpe/3fsVXP1WrloGRteIUwGXh1Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z1j+vcdT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z1j+vcdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A30C4CEE9;
	Tue, 27 May 2025 17:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367788;
	bh=VOmh2smeaZCVlAH8M/nKicoFifVVewWPWiOACmoNFeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z1j+vcdTJJYi+gLCP7kGNZjSc30OJAAW549Q8tuvS+EOlUxOxCki6gT+vqqXbsnc/
	 JHJPS9fcMMr8ynoJEEQQwXViVma+Q8tJ0kN+zNumVb/grsbiuwq2Qi7YQ9sdi3m+Fn
	 KuiZYxFZMNpha6mrl0YC/zmIlS2ISzBKEG9pg9gw=
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
Subject: [PATCH 6.14 499/783] drm/amd/display: Populate register address for dentist for dcn401
Date: Tue, 27 May 2025 18:24:56 +0200
Message-ID: <20250527162533.461650606@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 8082bb8776114..a3b8e3d4a429e 100644
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



