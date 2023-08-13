Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA699446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3F9BC433C8;
	Sun, 13 Aug 2023 21:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962470;
	bh=9QkjKkl+8zNwYbZlRf/+Eo93FkXOkOII/J04Ooy06XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aWWKhK98YmYNQ5oIZ0oHZ9FbvQoHzLfUTJS7qhZpeGrjGytD0Jn78uoGpc/nLscll
	 7ii26ER920ia3QYlf7ORWQf4/gOw8hiqlheRug1QYzTV7CumwtlExTe2atRz0dEiVR
	 yr3lhYVarb4pZ2ZQ/5XFk23QGxBDE9C1gkM6H0xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.1 041/149] drm/amd/display: Handle virtual hardware detect
Date: Sun, 13 Aug 2023 23:18:06 +0200
Message-ID: <20230813211720.039406492@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>

commit 987b96eb860036ab79051fb271f7fbdc01c9daf5 upstream

If virtual hardware is detected, there is no reason to run the full
dc_commit_streams process, and DC can return true immediately.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Co-developed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -1942,6 +1942,9 @@ enum dc_status dc_commit_streams(struct
 	struct pipe_ctx *pipe;
 	bool handle_exit_odm2to1 = false;
 
+	if (dc->ctx->dce_environment == DCE_ENV_VIRTUAL_HW)
+		return res;
+
 	if (!streams_changed(dc, streams, stream_count))
 		return res;
 


