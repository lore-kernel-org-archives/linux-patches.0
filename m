Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8989D1CFECF;
	Wed,  2 Oct 2024 14:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878687; cv=none; b=XKIP3sMv7kNuWkavDDLhetNHFyF0mcAmNF7/o3KgmVQMgpWnyUV0FSUSPQ/Y1knwaL64Bazucltm1ZKAI7+S0J0gupko6my5Ja7u6xeiH6yVwT+f3xuLltBNl1P/iD0hKDKtP1BIohnyshiJ4UT/SK5K3Z8xqaeE0WfXsg+xI3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878687; c=relaxed/simple;
	bh=vl1DYRyyvQI6jB1jaZ4xs7QeuOlD8GZIfLQpxWhdw/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnilPIoyvYuMdU12ndjzxAK9W8iEXRURRsj8/HqR1r+xutsuq6FbvAbOqbGk/z8gRze++PK5MRTBbqBzreqi07zbU8/F+gCHSBpoHaeWqKZlFgy0kMD45qZRfeCC8Sabm4FmpgI9uiarlX8V5mbCofNksVALA0RBh86cRNPQFjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPshxu51; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPshxu51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FE6C4CEC2;
	Wed,  2 Oct 2024 14:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878687;
	bh=vl1DYRyyvQI6jB1jaZ4xs7QeuOlD8GZIfLQpxWhdw/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gPshxu51jK25T8OYgdgBlqCtPtE6ar0vS2F6R08kRxWvvoZQ3Mckh0JaqIf8Pv2sr
	 +0esNce7SGAdAz4CdMD3hITnB73M0yodiS2DYSNcTnl8zhxrWXCUIRa/yXomR83S3Z
	 D1Rb8EY2WGhQXKSRlVVIpcEgoPkbABNj1RgFE6TM=
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
Subject: [PATCH 6.10 498/634] drm/amd/display: Enable DML2 override_det_buffer_size_kbytes
Date: Wed,  2 Oct 2024 14:59:58 +0200
Message-ID: <20241002125830.754926517@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2150,6 +2150,7 @@ static bool dcn35_resource_construct(
 	dc->dml2_options.max_segments_per_hubp = 24;
 
 	dc->dml2_options.det_segment_size = DCN3_2_DET_SEG_SIZE;/*todo*/
+	dc->dml2_options.override_det_buffer_size_kbytes = true;
 
 	if (dc->config.sdpif_request_limit_words_per_umc == 0)
 		dc->config.sdpif_request_limit_words_per_umc = 16;/*todo*/
--- a/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/resource/dcn351/dcn351_resource.c
@@ -2132,6 +2132,7 @@ static bool dcn351_resource_construct(
 
 	dc->dml2_options.max_segments_per_hubp = 24;
 	dc->dml2_options.det_segment_size = DCN3_2_DET_SEG_SIZE;/*todo*/
+	dc->dml2_options.override_det_buffer_size_kbytes = true;
 
 	if (dc->config.sdpif_request_limit_words_per_umc == 0)
 		dc->config.sdpif_request_limit_words_per_umc = 16;/*todo*/


