Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3773216F8FA;
	Wed,  3 Jul 2024 11:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004819; cv=none; b=P7KRsxQuS2dkcUd2OxfV4F7gU31GIovmlfmnu7lzCqyi9zzDFwwX3I/ilYRIr+mk124CP3qa9kB2bW5ckm0m2nFhblzegHUpIt4eahbg6F/M/eaK3ca1tYVnbp+0KyMcId8afrByT4783KPh3X/l59GR9dLny/aQezkFZ2AnVg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004819; c=relaxed/simple;
	bh=MhRk/IX6Vc9g3SozI72H+yuIXBx8ZE6uKUtb7NTr5T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNweADJFzCeakSKFsMqa8ZWlexYJVwiNhlBAj+D+CosclOA7I9MTy2glmrf+ZbxA/bSmHjDma0+2JuQ7ckiTFTefg0Tigo5uds2+5dxGgtCbFrxlYanDc0GGERdNMPpR7Bg/9qow/4jjgM4VNq4ciJgzFvoLGblt8rET5eENHh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MAbcI1qG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MAbcI1qG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE734C2BD10;
	Wed,  3 Jul 2024 11:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004819;
	bh=MhRk/IX6Vc9g3SozI72H+yuIXBx8ZE6uKUtb7NTr5T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MAbcI1qGPT5fZ4fQZPSgBsO0PGLgQ+xGUUt2euVEXLqfnNDnQaCDd+0k1PZAOFqrJ
	 hL915PxDaMs3mZtfMf44+sJD17sd/A02SxJz6YZrA/W+athzF6r3FNS0fI4zZjrtvi
	 jUdu1VK4Q89ClrX5NjLemyy+XRhJPOzZ2PDDlkDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Wayne Lin <wayne.lin@amd.com>,
	Martin Leung <martin.leung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 5.10 170/290] drm/amd/display: revert Exit idle optimizations before HDCP execution
Date: Wed,  3 Jul 2024 12:39:11 +0200
Message-ID: <20240703102910.596564582@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Leung <martin.leung@amd.com>

commit f2703a3596a279b0be6eeed4c500bdbaa8dc3ce4 upstream.

why and how:
causes black screen on PNP on DCN 3.5

This reverts commit f30a3bea92bd ("drm/amd/display: Exit idle
optimizations before HDCP execution")

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Martin Leung <martin.leung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp.c    |   10 ----------
 drivers/gpu/drm/amd/display/modules/inc/mod_hdcp.h |    8 --------
 2 files changed, 18 deletions(-)

--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp.c
@@ -86,14 +86,6 @@ static uint8_t is_cp_desired_hdcp2(struc
 			!hdcp->connection.is_hdcp2_revoked;
 }
 
-static void exit_idle_optimizations(struct mod_hdcp *hdcp)
-{
-	struct mod_hdcp_dm *dm = &hdcp->config.dm;
-
-	if (dm->funcs.exit_idle_optimizations)
-		dm->funcs.exit_idle_optimizations(dm->handle);
-}
-
 static enum mod_hdcp_status execution(struct mod_hdcp *hdcp,
 		struct mod_hdcp_event_context *event_ctx,
 		union mod_hdcp_transition_input *input)
@@ -456,8 +448,6 @@ enum mod_hdcp_status mod_hdcp_process_ev
 	memset(&event_ctx, 0, sizeof(struct mod_hdcp_event_context));
 	event_ctx.event = event;
 
-	exit_idle_optimizations(hdcp);
-
 	/* execute and transition */
 	exec_status = execution(hdcp, &event_ctx, &hdcp->auth.trans_input);
 	trans_status = transition(
--- a/drivers/gpu/drm/amd/display/modules/inc/mod_hdcp.h
+++ b/drivers/gpu/drm/amd/display/modules/inc/mod_hdcp.h
@@ -143,13 +143,6 @@ struct mod_hdcp_ddc {
 	} funcs;
 };
 
-struct mod_hdcp_dm {
-	void *handle;
-	struct {
-		void (*exit_idle_optimizations)(void *handle);
-	} funcs;
-};
-
 struct mod_hdcp_psp {
 	void *handle;
 	void *funcs;
@@ -259,7 +252,6 @@ struct mod_hdcp_display_query {
 struct mod_hdcp_config {
 	struct mod_hdcp_psp psp;
 	struct mod_hdcp_ddc ddc;
-	struct mod_hdcp_dm dm;
 	uint8_t index;
 };
 


