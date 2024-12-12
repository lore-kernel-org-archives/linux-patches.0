Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FA92EAE5;
	Thu, 12 Dec 2024 15:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016827; cv=none; b=FNJOG7QeguS2glZZfmMkqr0teb+lShLq8jN3OFmC+7Y3c5iEFGNr0B+QD5+byLV3sxnwEdRxBFqfHYvB7AiQmMo6DDaIANUPSUMY7KPTnifvILtlw+wQnrGI1wmEP3OPUBvbrZx1aOMHMMb9OpwX3W0lIc4fyLCRymu3cIsV7LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016827; c=relaxed/simple;
	bh=na1GvMrllmTXY4oQYD6aXcJKDqdmAqFAs52npUOrmwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ak+7CcQT20/njub1QxTzRTOdMJv06HwC6mjkWBMK458hMmAuk9ggUxc13aU2z6ACU3P5zb3j3u/V71PeH4C/PCBnyz/54n1T/a/eOg9tJk7jjb8hkrRZMh4O3TDevXIgqibclk6aXFELlHPr4Cre+Yf/afr3S3w5/GaPbruIFX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FILyoj1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FILyoj1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5FBC4CECE;
	Thu, 12 Dec 2024 15:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016827;
	bh=na1GvMrllmTXY4oQYD6aXcJKDqdmAqFAs52npUOrmwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FILyoj1MR0mRRlcjTo3kUKOXAWCc6ZY0E3OBRU0bIlZnTfynZpcfJYklngYysOhyC
	 kFEZHw2M/dXs3ZmvRf3og1FQP1uTE2Q2VS+NFUCxQ2CFy3xowW34dTnpPaZerq8wjw
	 WWgE2VZwBFVKIA8iMMQMWy1suC56Rs5dEam8PjLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Leo Chen <leo.chen@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 308/466] drm/amd/display: Adding array index check to prevent memory corruption
Date: Thu, 12 Dec 2024 15:57:57 +0100
Message-ID: <20241212144318.951363624@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Chen <leo.chen@amd.com>

[ Upstream commit 2c437d9a0b496168e1a1defd17b531f0a526dbe9 ]

[Why & How]
Array indices out of bound caused memory corruption. Adding checks to
ensure that array index stays in bound.

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Leo Chen <leo.chen@amd.com>
Signed-off-by: Wayne Lin <wayne.lin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c    | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
index b46a3afe48ca7..7d68006137a97 100644
--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
@@ -257,11 +257,11 @@ static void dcn35_notify_host_router_bw(struct clk_mgr *clk_mgr_base, struct dc_
 	struct clk_mgr_internal *clk_mgr = TO_CLK_MGR_INTERNAL(clk_mgr_base);
 	uint32_t host_router_bw_kbps[MAX_HOST_ROUTERS_NUM] = { 0 };
 	int i;
-
 	for (i = 0; i < context->stream_count; ++i) {
 		const struct dc_stream_state *stream = context->streams[i];
 		const struct dc_link *link = stream->link;
-		uint8_t lowest_dpia_index = 0, hr_index = 0;
+		uint8_t lowest_dpia_index = 0;
+		unsigned int hr_index = 0;
 
 		if (!link)
 			continue;
@@ -271,6 +271,8 @@ static void dcn35_notify_host_router_bw(struct clk_mgr *clk_mgr_base, struct dc_
 			continue;
 
 		hr_index = (link->link_index - lowest_dpia_index) / 2;
+		if (hr_index >= MAX_HOST_ROUTERS_NUM)
+			continue;
 		host_router_bw_kbps[hr_index] += dc_bandwidth_in_kbps_from_timing(
 			&stream->timing, dc_link_get_highest_encoding_format(link));
 	}
-- 
2.43.0



