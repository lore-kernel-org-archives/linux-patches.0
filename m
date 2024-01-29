Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B9415A488;
	Mon, 29 Jan 2024 17:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548248; cv=none; b=l9khw6IbUgEFzrJylNNFSUAGDEVJucLZpQtu0t8dr98oxwmmoF2dPI9wvCJ/f+9GPy0re+FlzYU27ftosd3/bMPbHCBSxIlP9bzkcq0D4FvgY/seXgNHheDu1JJVS1kUxUe73KVLUFvtQ9+xOOHBWKBGKdxMwaw1sovFiu8RtsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548248; c=relaxed/simple;
	bh=tLD2maDb2/ZKIzza1ESYZiazXiJYWfDW2MWJhH1Rtkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ly85N1zwntsEeeEWv+mKRdY4aTfXApUC+fQYdiONlr3O2C9MiLsL9LmQ4GCry72RQWrgmSez33+qwYR3/Fq24eRoyogSZBxUJIUw9CpZEYxv6uAOo1u1O3poiGevG/RvBWTJFM06z80DVgJmD4xXK0F1lxqtfKJIwI3+aBFvCoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hcF9/IxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hcF9/IxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCD72C433C7;
	Mon, 29 Jan 2024 17:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548248;
	bh=tLD2maDb2/ZKIzza1ESYZiazXiJYWfDW2MWJhH1Rtkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcF9/IxCs4stcM97nvHrYlGpiJnMqeLHoJJtgfdcjC0U6yruMw1Ei3vDOk69/aQc4
	 rHjuN1dBpb7K0HnOjeIBzzIzlcZIdYoJ+zvQ0bCiVH+oPpVAJEHLR8PT7IvFWijHi6
	 5KT4uOVzYO312rHjJQa4znNfHE6vD7jzSRFmX1Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Wenjing Liu <wenjing.liu@amd.com>,
	Qingqing Zhuo <qingqing.zhuo@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.7 271/346] drm/amd/display: Fix late derefrence dsc check in link_set_dsc_pps_packet()
Date: Mon, 29 Jan 2024 09:05:02 -0800
Message-ID: <20240129170024.353423360@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

commit 3bb9b1f958c3d986ed90a3ff009f1e77e9553207 upstream.

In link_set_dsc_pps_packet(), 'struct display_stream_compressor *dsc'
was dereferenced in a DC_LOGGER_INIT(dsc->ctx->logger); before the 'dsc'
NULL pointer check.

Fixes the below:
drivers/gpu/drm/amd/amdgpu/../display/dc/link/link_dpms.c:905 link_set_dsc_pps_packet() warn: variable dereferenced before check 'dsc' (see line 903)

Cc: stable@vger.kernel.org
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Hamza Mahfooz <hamza.mahfooz@amd.com>
Cc: Wenjing Liu <wenjing.liu@amd.com>
Cc: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/link_dpms.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
+++ b/drivers/gpu/drm/amd/display/dc/link/link_dpms.c
@@ -875,11 +875,15 @@ bool link_set_dsc_pps_packet(struct pipe
 {
 	struct display_stream_compressor *dsc = pipe_ctx->stream_res.dsc;
 	struct dc_stream_state *stream = pipe_ctx->stream;
-	DC_LOGGER_INIT(dsc->ctx->logger);
 
-	if (!pipe_ctx->stream->timing.flags.DSC || !dsc)
+	if (!pipe_ctx->stream->timing.flags.DSC)
+		return false;
+
+	if (!dsc)
 		return false;
 
+	DC_LOGGER_INIT(dsc->ctx->logger);
+
 	if (enable) {
 		struct dsc_config dsc_cfg;
 		uint8_t dsc_packed_pps[128];


