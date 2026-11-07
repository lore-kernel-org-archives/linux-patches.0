Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060565;
	b=EQyb90RH/aVDkcAIv/OGko88RsH57pVQNRz1qvkMG2kOVXs+Vw4QmgicGQnYU4fUsQEe
	 KhBBhxSmuNev/jnIaTbUcTQBR0cyqiE2Pe2CnkW9lhk/qXmZcUutimUiavNeMSfuLWF18
	 LZmkAB/iNqpQIKLD1qxpDbRVrN4mz09+NuIeBypJkv1itec9oPZoSs5vwF7yahyXwiIAH
	 aTfS/BHbVe6wTK+RpUqbDDbTsB2VOFWZQuRI1pt9ss64lTGATFU5vB/GNrZCnYf4Jq1+B
	 SjLrnBKPG6RrpQFWEykaA2eUl3GiDt65tmnBo2UIJSDoATkyvIMWS5Zu+mhDXNvLivg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zw61CW5pG2xWHsDm8BhjaYoQKJeKSp3yA6c7iPw/8b8=;
	b=HzpJu2dgY84ECIPmd0BtznKUhMy+n+dYEMV1refekZ13Uk3WJgwN41xVgypZGAT05o55
	 /5w65QEy5qP7u5MLmWtI0pB21L8y5qx6g3xJ4BKgDnei6g41Y07TkTZGpXuFZPzfmE6EZ
	 SLpqJIAlRguda3YSbVnMLxvR1R/VHP/0mzvbm2Skr8/e/t5sZqC8Yjy8y8k0mYlgzIAqB
	 5xVfLoQKLTMHQ9W7n1qKGlt31dJ2gCIGG/WNRRP5Ld0nXxUc0wTTwcSXEF8vyBSHhnWWo
	 Hj0QxosbYIzI/0v84q5T6ht15BVRkCtX3pGFBbGaoG6cYH4RXaCKqqkSVeZkbhOpbaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q44ueUsJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EFD606A331;
	Sat,  7 Nov 2026 14:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q44ueUsJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F230C1F0089F;
	Sat,  7 Nov 2026 14:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060565;
	bh=zw61CW5pG2xWHsDm8BhjaYoQKJeKSp3yA6c7iPw/8b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q44ueUsJekkJZJ00nikXHJoBOf1jDouTRoGufFcl6p/NIcWoYToxUAXXNotNt+dH4
	 052uIHUQhImeNCoLjd9olOLhfiYJabw6IBfb0H57Q3J5N2chdeoJZ2xZcC5ATQ0Riq
	 8w3kaVGMeNdyLCiiIkx2fKvgoj/yUuJ7uhPO+c7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <dillon.varone@amd.com>,
	Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>,
	Charlene Liu <Charlene.Liu@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0027/1536] drm/amd/display: fix max dispclk_khz/dppclk_khz double 1000
Date: Sat,  7 Nov 2026 08:34:03 -0500
Message-ID: <20261107134958.437948809@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charlene Liu <Charlene.Liu@amd.com>

[ Upstream commit f48124ff35357d05a98d9cd5cb7982e7e5509003 ]

[why]
Fix regresson caused by double roundup and index out of range

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Reviewed-by: Dmytro Laktyushkin <dmytro.laktyushkin@amd.com>
Signed-off-by: Charlene Liu <Charlene.Liu@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
index 20c643ab756eb..445c5ae951ea1 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/dml21/dml21_wrapper.c
@@ -175,16 +175,16 @@ static void dml21_calculate_rq_and_dlg_params(const struct dc *dc, struct dc_sta
 	context->bw_ctx.bw.dcn.clk.bw_dispclk_khz = context->bw_ctx.bw.dcn.clk.dispclk_khz;
 	if (in_ctx->v21.dml_init.soc_bb.clk_table.dispclk.num_clk_values > 1) {
 		context->bw_ctx.bw.dcn.clk.max_supported_dispclk_khz =
-			in_ctx->v21.dml_init.soc_bb.clk_table.dispclk.clk_values_khz[in_ctx->v21.dml_init.soc_bb.clk_table.dispclk.num_clk_values] * 1000;
+			in_ctx->v21.dml_init.soc_bb.clk_table.dispclk.clk_values_khz[in_ctx->v21.dml_init.soc_bb.clk_table.dispclk.num_clk_values - 1];
 	} else {
-		context->bw_ctx.bw.dcn.clk.max_supported_dispclk_khz = in_ctx->v21.dml_init.soc_bb.clk_table.dispclk.clk_values_khz[0] * 1000;
+		context->bw_ctx.bw.dcn.clk.max_supported_dispclk_khz = in_ctx->v21.dml_init.soc_bb.clk_table.dispclk.clk_values_khz[0];
 	}
 
 	if (in_ctx->v21.dml_init.soc_bb.clk_table.dppclk.num_clk_values > 1) {
 		context->bw_ctx.bw.dcn.clk.max_supported_dppclk_khz =
-			in_ctx->v21.dml_init.soc_bb.clk_table.dppclk.clk_values_khz[in_ctx->v21.dml_init.soc_bb.clk_table.dppclk.num_clk_values] * 1000;
+			in_ctx->v21.dml_init.soc_bb.clk_table.dppclk.clk_values_khz[in_ctx->v21.dml_init.soc_bb.clk_table.dppclk.num_clk_values - 1];
 	} else {
-		context->bw_ctx.bw.dcn.clk.max_supported_dppclk_khz = in_ctx->v21.dml_init.soc_bb.clk_table.dppclk.clk_values_khz[0] * 1000;
+		context->bw_ctx.bw.dcn.clk.max_supported_dppclk_khz = in_ctx->v21.dml_init.soc_bb.clk_table.dppclk.clk_values_khz[0];
 	}
 
 	/* get global mall allocation */
-- 
2.53.0



