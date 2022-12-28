Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6F21C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:51:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9341C433D2;
	Wed, 28 Dec 2022 16:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246305;
	bh=+wPILuLBCbghQ1iyYlen45uCRSTuLfYQ5KIGVelLKwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k++NwVCjoeix3NGBjWdujgdlgXsRn5j/wyn3jqypR52uqdg6XyhPox5sxk7ZNlbda
	 2ZIyWaMZ2JqDQCaFPhzuiuvyDNmv9JrA/KezrY1gkIQfcIXkTNzWkjVmBRQUT2Wnqi
	 0nlrzt5zkB5Ri+xxOt9N3XLVrglwTZnDQuTU9QOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dillon Varone <Dillon.Varone@amd.com>,
	Brian Chang <Brian.Chang@amd.com>,
	Ilya Bakoulin <Ilya.Bakoulin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1018/1146] drm/amd/display: Fix display corruption w/ VSR enable
Date: Wed, 28 Dec 2022 15:42:37 +0100
Message-Id: <20221228144358.016911494@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilya Bakoulin <Ilya.Bakoulin@amd.com>

[ Upstream commit e643cd384270fd3a4b66f65f15dafc8db0607adc ]

[Why]
Brief corruption is observed on hotplug/unplug with certain display
configurations when VSR is enabled.

[How]
Work around the issue by avoiding 2to1 ODM when stream plane_count is 0.

Reviewed-by: Dillon Varone <Dillon.Varone@amd.com>
Acked-by: Brian Chang <Brian.Chang@amd.com>
Signed-off-by: Ilya Bakoulin <Ilya.Bakoulin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
index d1598e3131f6..33ab6fdc3617 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_resource.c
@@ -1901,7 +1901,7 @@ int dcn32_populate_dml_pipes_from_context(
 
 		pipes[pipe_cnt].pipe.dest.odm_combine_policy = dm_odm_combine_policy_dal;
 		if (context->stream_count == 1 &&
-				context->stream_status[0].plane_count <= 1 &&
+				context->stream_status[0].plane_count == 1 &&
 				!dc_is_hdmi_signal(res_ctx->pipe_ctx[i].stream->signal) &&
 				is_h_timing_divisible_by_2(res_ctx->pipe_ctx[i].stream) &&
 				pipe->stream->timing.pix_clk_100hz * 100 > DCN3_2_VMIN_DISPCLK_HZ &&
-- 
2.35.1



