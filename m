Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018179;
	b=TiejvWiijv/rdofk51urrIm9VgOy817Zyz7yrDKrinL1IEf/3YeuYeHLUz6ICP2koCdy
	 mtHQWgZCIxcpq4FQSJ/bv0xEQRQ/m+JrK2aCBjgXDE537h9lvKRWHfr/K7HgdFra3LNiJ
	 v6eUKKLH553R8/ZeVjKC5tErUBwwwPnw+p7Jf4Gf554Y+MX/dE8lMu+cHX5F4iTkTrAYL
	 GCjvOwaKOuQofWq/cfxrQAX58ogMZm8ywzm2AzZRHn6Nbj2kIKXiw3L4Xd1GY71o7i/lr
	 aV2801XD6El1442zrSXt85QRcNg/NKaDa0XXDP1ZLgkaeByRtB9LAC5tzVwlz9gZqyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ExV3F7qTViIOma2PbQ7XfMiANQty8Pnxib7/F6IssBY=;
	b=ZnHcNcrioggeWp1C5mC1mLpp9jwvRvP3baRNbwbTJOM/aiGfTdg6qb3H5xJCc+bVg3pt
	 h624KlDOmX14pxgkptdaMeN6oyt406XAGfuFGBG49XqgNFEhWuUfWQ2qwdv+NWPV76+l/
	 hAJVblo4bu8lKAwzSKw8hP5sdAWfjv6J3GDfcsNPEN2eqbNI21D6y3dFnD2sxtFaXRNBn
	 NPWoDvef/DX+/vQTcxxOeXXxbpC5eFjD6Djmqs1nBd8NegM5coleDfEjb9ynhmyQInayv
	 XAVxqopCSo+Gw5V8smkacaFmQqbGvlL2UeaWmBAlpVtGCytOZUXs1ACH8s64G+KDAsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FATOzonN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE21E606A320;
	Wed, 18 Nov 2026 16:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FATOzonN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4C01F000CC;
	Wed, 18 Nov 2026 16:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018179;
	bh=ExV3F7qTViIOma2PbQ7XfMiANQty8Pnxib7/F6IssBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FATOzonNvh7Gm7mqI6f+RgviYNLIioGvNrcOAbUrvbIjiixL3pDumub1kVDMjUHt6
	 69zT3goejbxRAgowzVLbAR59SLxN0ovYRnzrzdJrj47KWNhumokO8aSADgFjuX8qg7
	 dkYIJNdBi9T9ubHuOiR72N2i9HOLamDg9xozclHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1131/2651] drm/amd/display: fix unused function warnings
Date: Wed, 18 Nov 2026 15:39:31 +0100
Message-ID: <20261118150328.725720300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit a387d5d707850627b0a6d6fd479afc7c83cdb02a ]

When CONFIG_DRM_AMD_DC_DCE is disabled, most functions insde dce110_hwseq.c
are no longer referenced, causing a lot of warnings such as

drivers/gpu/drm/amd/amdgpu/../display/dc/hwss/dce110/dce110_hwseq.c:3510:13: error: 'dce110_enable_analog_link_output' defined but not used [-Werror=unused-function]
 3510 | static void dce110_enable_analog_link_output(
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/gpu/drm/amd/amdgpu/../display/dc/hwss/dce110/dce110_hwseq.c:3391:13: error: 'dce110_set_cursor_attribute' defined but not used [-Werror=unused-function]
 3391 | static void dce110_set_cursor_attribute(struct pipe_ctx *pipe_ctx)

Replace the #ifdef with an IS_ENABLED() check that leads to an empty function
in this configuration, so the compiler can eliminate the unused functions
and not complain about it.

Fixes: cd2cfe4d1504 ("drm/amd/display: gate DCE ASIC code behind CONFIG_DRM_AMD_DC_DCE")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Fangzhi Zuo <jerry.zuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c  | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
index f974968af21b2..f593aae34745e 100644
--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -3619,7 +3619,6 @@ void dce110_disable_link_output(struct dc_link *link,
 	dc->link_srv->dp_trace_source_sequence(link, DPCD_SOURCE_SEQ_AFTER_DISABLE_LINK_PHY);
 }
 
-#if defined(CONFIG_DRM_AMD_DC_DCE)
 static const struct hw_sequencer_funcs dce110_funcs = {
 	.program_gamut_remap = program_gamut_remap,
 	.program_output_csc = program_output_csc,
@@ -3685,9 +3684,8 @@ static const struct hwseq_private_funcs dce110_private_funcs = {
 
 void dce110_hw_sequencer_construct(struct dc *dc)
 {
-	dc->hwss = dce110_funcs;
-	dc->hwseq->funcs = dce110_private_funcs;
+	if (IS_ENABLED(CONFIG_DRM_AMD_DC_DCE)) {
+		dc->hwss = dce110_funcs;
+		dc->hwseq->funcs = dce110_private_funcs;
+	}
 }
-
-#endif /* CONFIG_DRM_AMD_DC_DCE */
-
-- 
2.53.0



