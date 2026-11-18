Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047642;
	b=XYWRI1Uq3+oHdkooY9CNgLKsPRAJWqo5f5P3hqa5hu11Q/Pqw9JPwlpJrAGu3e8WqHNn
	 MjyZUu0sN11HXSeEjI+QiQ0OMb56mnNz6yM3Bx6tQdiR2fVHBGPp1fEfF1/nNpypbPRfR
	 i96DOWGJShNXzVwvEVG8dPePMv6AkR1K4hJspJSJ0CdErhjfGf9JlIY0C0Vz6KybBm87B
	 WSbLVRw226hiIMX1ZWYYf8HKcFk3VQV6rcoGbBEBC4AZ3T0uMV1zAc2BvmcS7gPQkbQy7
	 2GaQs8+B9r6B0kjiDj/3xy+SLv1eMM62tT+aCjX7dm3bN1e+miALialPgjkVHTj1Olw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GZd8tVTFayU/q0PIUCIK54NzKDkelz/2mQrID+wFkFk=;
	b=lAlgMQ9y/oWlH92r9yUfgBMHGEcE61bDETC0o/q/69DGFKnLdSsThXuJsLhnfnwLQQIl
	 uP0kXHikeV7uqsbB8HhmaJdDTS0UAzmwDFZx8AcXG9DRPzjGE49HhwZ7r8+jIgsasykAM
	 36pG1VBqViffHDeUkS1mm1Ml0ACEMNIFU7wOa0YiD63mn/1r9yiqcKb9J3aaudQ3wUGIp
	 UxP0+A54mzkj0GPGOMO8Ee7lTKOfuT9b4m/pYEokoq1yz3NsYFHblUX7FDk1r9oi/dnPO
	 E6EbGcQuqnXJrvdbOcFvpvDQgZmmxohv/BVuaRSH8v6MP7rAtADHIY95YJmHLzgmE0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UU3bhtex;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A86606A325;
	Thu, 19 Nov 2026 00:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UU3bhtex
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC231F000C4;
	Thu, 19 Nov 2026 00:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047641;
	bh=GZd8tVTFayU/q0PIUCIK54NzKDkelz/2mQrID+wFkFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UU3bhtex6l+Q5jZVkNstP6BmbtMCfoMDUHc1rZpHinL0DkuBwd+GwoYgFppr6iwHY
	 YhbLa/fposS3XCMH3EVN0S4NStVmysQSUSmUHILIMdoVfEp0X+NkIt2kjgjkfVEOrz
	 eqEEReI4lMlpzQJ6qb7vGHvFu67Srnein/fm/VT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Misha Nasledov <misha@nasledov.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1684/2857] drm/amd/display: Drop clock requirements on DCN32 when no displays are active
Date: Wed, 18 Nov 2026 15:45:18 +0100
Message-ID: <20261118150301.968171959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: applied the change in dcn32_validate_bandwidth() instead of dml1_validate() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dcn32/dcn32_resource.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
index 9f5425e6474fb..3195fe12fc1b9 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -1870,8 +1870,21 @@ bool dcn32_validate_bandwidth(struct dc *dc,
 	if (fast_validate)
 		dcn32_restore_mall_state(dc, context, &mall_temp_config);
 
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



