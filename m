Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039012;
	b=IsV8UYT5k+BDjXTgOmSMUBqiU/h/m5D0h4jHiUYo26QoUVF8avkafYe5v4e1/XNq4zEa
	 450LISdZhLRbbaB33Y7lhXvWbnfzgIoncZpbUuIb7aUz6FYyxdCwgQdnE6wuId1/mgkmR
	 UUIQjZkRR/sC4vnC8WDJnlmvWyAQZ1OZVFTUJGXjY6MGcUIXlE/2QTAm8Vx0VwigOYRIG
	 eGCzhadtt2PFHSotNyaRNK+++B2NEYwPgTxN0P1zeU0Rk1ZeQ7o3WgwSVySDxUZ9SlxEF
	 ScOTFTubwTnwoV1FwGS3WkmbdB3HX3sy1j3LWVyQri6o4tzDGznnufsbeDAxygawb1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039012;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OpiyOWZ+heMvURECJ3Mdx69KrSzPV1FQpI1vih1/BI8=;
	b=h9NfMSBCRkurWeSRMAPxaGW5CbeLVyjy0AgsUCAgfmgphl6cCB6ikdts87bDWTOOC/mR
	 mL9PYkx5oek+IdxE+ZiefSDXyQ/0t7YGlF6euIZyVYuvxwi0L8F7l64l97MjvL3OQ32Up
	 Vi3OOMDqTnwMa8S1m9GJJHr0kXWCvhrmtN562r/0vjFlIkuIT1OGB/t7x+XzdQOQgmPsz
	 HQcijaq24rraz6dv3l4XnlkStw9+cVq4NQpwWBItcvYq0Z1ATsdjbhDWyjmVr4gWHMsta
	 Vtl/Rp8vgvmsRIGmNYB5Zh9yh+sXbFHHJ1Fp0pYqb9T3hLdj1i0DcQuRULOEho8Y1Cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fMC2z9xz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3053606A331;
	Wed, 18 Nov 2026 21:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fMC2z9xz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD061F000C7;
	Wed, 18 Nov 2026 21:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039012;
	bh=OpiyOWZ+heMvURECJ3Mdx69KrSzPV1FQpI1vih1/BI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fMC2z9xzvOGSw+wsGDDbq33c4avJdd4PLONRnDg7iAPPjD0jSU40UrE82Mv687vlx
	 VtnaVrrBGysm8ThCA4hZtdBuungxW3euSclonTugDQqYcoeBxUAYa2JuXGz6lM2Vdm
	 D3IcRe74wHkstJ7yviZGtxaofmlkznP8mf8jmtnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Misha Nasledov <misha@nasledov.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1947/3318] drm/amd/display: Drop clock requirements on DCN32 when no displays are active
Date: Wed, 18 Nov 2026 15:42:49 +0100
Message-ID: <20261118150420.468004446@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted the dml1_validate() change to dcn32_validate_bandwidth() after its existing MALL state restore. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dcn32/dcn32_resource.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
index ab6b4f44f537c..f85672062af30 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -1860,8 +1860,21 @@ bool dcn32_validate_bandwidth(struct dc *dc,
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



