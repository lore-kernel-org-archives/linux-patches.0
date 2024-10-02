Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DD81CF5FB;
	Wed,  2 Oct 2024 13:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876799; cv=none; b=MKApgRrEL1k96t7f1FQKDA771gwR78uDZU0C6kDrsE3uUrSlPf+EYXH882RIvlJ6PpDitoUXDWT391dwYm13a4wJ+rBaShBtE3B9ICwL3EJDBCra2jIIVDe9E3g5u/edbmHmXWkSz6zEsKotMgE/Ld0W3A+IFhfgMaY5yAtHEso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876799; c=relaxed/simple;
	bh=JALP9xdxWXmXIcpYtRtim5JToUHjSRaVnzuZTVT2D9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUnVkj9QbcS7sfYibJDk9gi1JCx17K1Hk+VZmd3xRNFjHVTcXkDKvH4Fn0kpFchfpHT5WUeoMPXLGMKyW3MJWJvdKJC7Du9CIPk6sRsWZxwmZk44oy1Y6PG+DK2j41GgEX+5xk+oxueifckEF0sO3AWoJokPAIFK7ynzIFo761c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FfJVQ04L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FfJVQ04L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C24DC4CEC2;
	Wed,  2 Oct 2024 13:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876799;
	bh=JALP9xdxWXmXIcpYtRtim5JToUHjSRaVnzuZTVT2D9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfJVQ04LZGqKanFjDFOWeFZ75O9d4fvlTGsfLjogbfHB127Fe5fgZrGzqA6sfvuiz
	 4hBE/4prsO7IaXOYQPk3VxHx5gqxgdyqSldw172gpXC1kdaPKMELNGuT1XXN/PSz/e
	 fQ4W6A8Xgc0So3o6wzyQ/8jYnbjyvfurkvaN8HTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Li <roman.li@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Yihan Zhu <Yihan.Zhu@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.11 558/695] drm/amd/display: Enable DML2 override_det_buffer_size_kbytes
Date: Wed,  2 Oct 2024 14:59:16 +0200
Message-ID: <20241002125844.775778025@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yihan Zhu <Yihan.Zhu@amd.com>

commit f57b77d667dc6bd2b114d08d04b03869539209f6 upstream.

[WHY]
Corrupted screen will be observed when 4k144 DP/HDMI display and
4k144 eDP are connected, changing eDP refresh rate from 60Hz to 144Hz.

[HOW]
override_det_buffer_size_kbytes should be true for DCN35/DCN351.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Roman Li <roman.li@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Yihan Zhu <Yihan.Zhu@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c   |    1 +
 drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn35/dcn35_resource.c
@@ -2153,6 +2153,7 @@ static bool dcn35_resource_construct(
 
 	dc->dml2_options.max_segments_per_hubp = 24;
 	dc->dml2_options.det_segment_size = DCN3_2_DET_SEG_SIZE;/*todo*/
+	dc->dml2_options.override_det_buffer_size_kbytes = true;
 
 	if (dc->config.sdpif_request_limit_words_per_umc == 0)
 		dc->config.sdpif_request_limit_words_per_umc = 16;/*todo*/
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
@@ -2133,6 +2133,7 @@ static bool dcn351_resource_construct(
 
 	dc->dml2_options.max_segments_per_hubp = 24;
 	dc->dml2_options.det_segment_size = DCN3_2_DET_SEG_SIZE;/*todo*/
+	dc->dml2_options.override_det_buffer_size_kbytes = true;
 
 	if (dc->config.sdpif_request_limit_words_per_umc == 0)
 		dc->config.sdpif_request_limit_words_per_umc = 16;/*todo*/


