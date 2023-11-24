Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE0E39FF7;
	Fri, 24 Nov 2023 18:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/j7KmR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A946DC433C8;
	Fri, 24 Nov 2023 18:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850334;
	bh=UasVns6ddnhY/O8uo0sKy+GVZWbCjfd+WfSkzEZo6CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/j7KmR2DENZsKnO2PFYH3ekqmX5MB1OntRIIfJiiQE+MwRHo9fKVVq5aDpL74Bve
	 d/xWJbDlZLQ4eklsDeSF7P9cNBZJj1bW3g8gxjw7BvLxddtrr7pTXfWJ3wrikVqGuA
	 WV01Ha53HYNQgkmwfGwoD6EsNePp8DJrZiIMOCkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Martin Leung <martin.leung@amd.com>,
	Gabe Teeger <gabe.teeger@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.6 510/530] drm/amd/display: Add Null check for DPP resource
Date: Fri, 24 Nov 2023 17:51:16 +0000
Message-ID: <20231124172043.686718615@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabe Teeger <gabe.teeger@amd.com>

commit e186400685d8a9287388a8535e2399bc673bfe95 upstream.

[what and why]
Check whether dpp resource pointer is null in advance and return early
if so.

Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Reviewed-by: Martin Leung <martin.leung@amd.com>
Signed-off-by: Gabe Teeger <gabe.teeger@amd.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -996,7 +996,7 @@ static void adjust_recout_for_visual_con
 	struct dc *dc = pipe_ctx->stream->ctx->dc;
 	int dpp_offset, base_offset;
 
-	if (dc->debug.visual_confirm == VISUAL_CONFIRM_DISABLE)
+	if (dc->debug.visual_confirm == VISUAL_CONFIRM_DISABLE || !pipe_ctx->plane_res.dpp)
 		return;
 
 	dpp_offset = pipe_ctx->stream->timing.v_addressable / VISUAL_CONFIRM_DPP_OFFSET_DENO;


