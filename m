Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58D2C1EA8A
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9484CC43395;
	Fri, 21 Jul 2023 16:20:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956460;
	bh=fOk4TtPQ00xcnVxjBFG2/79tzX745u1MGI8ciu6g3RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ropXCmwNTFibgP9TMM4HeoXgZH7BNmh4FWPZHNREBORRcLTM6NtWqhBGxnUf/HR1z
	 BT6E+zaKW3aoo/dCSXLN0StorUHqItYxXg2h2ox+uaCa1IpkWaj+otLNQjKc2bi3WX
	 cxH/wirDX4J/vCU93hWt8mDQw80oXn38kdb57bIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alvin Lee <alvin.lee2@amd.com>,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Austin Zheng <austin.zheng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.4 201/292] drm/amd/display: Remove Phantom Pipe Check When Calculating K1 and K2
Date: Fri, 21 Jul 2023 18:05:10 +0200
Message-ID: <20230721160537.519027291@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Austin Zheng <austin.zheng@amd.com>

commit 1966bbfdfe476d271b338336254854c5edd5a907 upstream.

[Why]
K1 and K2 not being setting properly when subVP is active.

[How]
Have phantom pipes use the same programing as the main pipes without
checking the paired stream

Cc: stable@vger.kernel.org
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Acked-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Austin Zheng <austin.zheng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hwseq.c
@@ -1125,10 +1125,6 @@ unsigned int dcn32_calculate_dccg_k1_k2_
 	unsigned int odm_combine_factor = 0;
 	bool two_pix_per_container = false;
 
-	// For phantom pipes, use the same programming as the main pipes
-	if (pipe_ctx->stream->mall_stream_config.type == SUBVP_PHANTOM) {
-		stream = pipe_ctx->stream->mall_stream_config.paired_stream;
-	}
 	two_pix_per_container = optc2_is_two_pixels_per_containter(&stream->timing);
 	odm_combine_factor = get_odm_config(pipe_ctx, NULL);
 


