Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590460;
	b=ToAeMvSU7fC5XKeaIvVhvX1jAssd/MQhSF3+OhUBbiwbu8SYLF+DRj3CbYGq/aRYiJS+
	 aX0RH3J/RO59xAkjVxR1K7eSJEWmhV4hDtjH2vsku6vFTgUS+K6Cl9gYVlaKU4rrVvSIm
	 74VOgMDNmW0MUnuqtxhljArEJq9vtGS0rHxFXLB+HWp+5LiT8NG/623qEk8PvP1F8+5Os
	 7sBnRrICYoBzPZJpMYOLkgDhqXF6NbFihddBzowUFHa75lv5QFL0RcSvBu8efAqXWDHPh
	 cevtOOjdZF51H2Z+HPIzrTRSMCrim0kDMyg7fkTOrfE0OfZtSQViPR5SFfDf/C8ZjJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tzen5WbREjqA5bnDr+iGjHRC8nuY58QSdl6ydieclkk=;
	b=VgHu7LWT/qYya/58YcpCrF6jQ0y+h3uYwRpOJ2K6dtfndrgTJgkJXMz/Eevx8CBRgQFn
	 j97Ljt3La49w5sXIz36ZLWeS8/N15ZEcM+zQjKOv7Oi2M6V/UHezVBpgbQMJ8jc5RuQDC
	 OHIlLl7YAv+CvPnroRxlh69t4LB9qZRaJG0AKxUMWgbow0r5n0jOijMBRtHKgxq17w/Nr
	 ABOJYxmP7Bgtx/Mh982TTndMPTzO3Y5A//ULV2LrDifj+s4IX0LHtEVuvnXsGFoEMZ2Ah
	 8VRqhw82H4S3+niGh4VHfmYY5ouAOulYSHA3l2B+pAZBPk4lUnLQ8CudbYo/+9WbLug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=znp6PMa8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5F3606A339;
	Fri, 13 Nov 2026 17:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=znp6PMa8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CC61F000C4;
	Fri, 13 Nov 2026 17:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590459;
	bh=tzen5WbREjqA5bnDr+iGjHRC8nuY58QSdl6ydieclkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=znp6PMa83ilrQbNuKmsQIxLO6MtNI/bk0tw43UDIJvYOP+mlLp7NHXMGJsLY66HpV
	 xA5H/dBa6fOpnfDA6BwV48Q4X646IvUGwYEoADkdKUdaZPGcFWXP9xmRcUC5idS/40
	 z/iceZnBPFxaO0iZXT6fNFovvQi4eyrFTvDXpeKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Misha Nasledov <misha@nasledov.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 409/686] drm/amd/display: Drop clock requirements on DCN32 when no displays are active
Date: Fri, 13 Nov 2026 10:49:02 -0500
Message-ID: <20261113153834.839521817@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Misha Nasledov <misha@nasledov.com>

[ Upstream commit bba4dc3306483335ddbe065c05b2d8359ec387a4 ]

amdgpu_dm builds the new dc_state as a copy of the old one. When the last
stream is removed, dml1_validate() returns early on pipe_cnt == 0 and
never reaches dcn32_calculate_dlg_params(), so bw.dcn.clk keeps the
dramclk/dcfclk/fclk requirements of the display that was just turned off.
dcn32_update_clocks() then keeps those hard minimums applied.

On an RX 7900 XTX this leaves UCLK at 456 MHz and DCFCLK at 637 MHz with
the monitor off, and the board idles at 28.4 W. With this change they
drop to 96 MHz and 145 MHz and board power falls to 15.3 W.

Reset the clock requirements in that case, as calculate_dlg_params()
already does when no HUBP is active and as the DML2 path does for
stream_count == 0.

Signed-off-by: Misha Nasledov <misha@nasledov.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 0261a0ef89f37ef962fbc9dbc724ebf65fe681cf)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../display/dc/resource/dcn32/dcn32_resource.c    | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
index e655772986851..61cb8d051917a 100644
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn32/dcn32_resource.c
@@ -1777,8 +1777,21 @@ static bool dml1_validate(struct dc *dc, struct dc_state *context, enum dc_valid
 	out = dcn32_internal_validate_bw(dc, context, pipes, &pipe_cnt, &vlevel, validate_mode);
 	DC_FP_END();
 
-	if (pipe_cnt == 0)
+	if (pipe_cnt == 0) {
+		/* The context is a copy of the previous state, so without this the
+		 * clocks the last display needed stay applied with all displays off.
+		 */
+		context->bw_ctx.bw.dcn.clk.socclk_khz = 0;
+		context->bw_ctx.bw.dcn.clk.dppclk_khz = 0;
+		context->bw_ctx.bw.dcn.clk.dcfclk_khz = 0;
+		context->bw_ctx.bw.dcn.clk.dcfclk_deep_sleep_khz = 0;
+		context->bw_ctx.bw.dcn.clk.dramclk_khz = 0;
+		context->bw_ctx.bw.dcn.clk.fclk_khz = 0;
+		context->bw_ctx.bw.dcn.clk.p_state_change_support = true;
+		context->bw_ctx.bw.dcn.clk.fclk_p_state_change_support = true;
+		context->bw_ctx.bw.dcn.clk.num_ways = 0;
 		goto validate_out;
+	}
 
 	if (!out)
 		goto validate_fail;
-- 
2.53.0



