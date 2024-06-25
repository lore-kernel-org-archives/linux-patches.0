Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E297E149E0A;
	Tue, 25 Jun 2024 09:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309404; cv=none; b=IdMbQPAisCojHPyD+mSS9zngRvLlHI5ExOBCp+SB8a6LTFmNPVY92Ux2m5cl6seIPHEtx1q2tSnpYJMyWTir4f/Nc6dW9YjCqOyROdv8zmDFc2Wpp6bMqHYptU96tLB01bGTUfEaU7bLGnx32ZEoQvi1DNf/1oPVQu8jljOL8Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309404; c=relaxed/simple;
	bh=0fTvRF7RyP3p1Rwr3QnhCvUScoW90hy/CB3K4eDn/w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtbakoEcJkuNPCj4/8eQXj3yh3VaeStAuYKI8d2MEzRPn+dgK4y4trYjZCk5z/ySFZ0fj7Qv+w5i/UvIl7KjVp/iIxUhDgfRwOVtetnoHke0xnYI0Sl879G4OKdbziXJe9M8/YUewO+4TIWuSeuTPVBvxPhv38A4GdqZEG5X/A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g7NLkEvf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g7NLkEvf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B29C32781;
	Tue, 25 Jun 2024 09:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309403;
	bh=0fTvRF7RyP3p1Rwr3QnhCvUScoW90hy/CB3K4eDn/w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7NLkEvfTNZ9zXIlvvfQc6cidHPecOA/jY5hwr2Xj1PziNJ/Z15/jhPJyXB3hRuW2
	 iq1kTMgBCP4ay9F7sVhoPuJEkTGCVtC1YGNzHaYv/FteRKdvS4WBa/NSjj2hq1Vwdp
	 5lunz/rkvQ2lF8wm1A0u83VSuttcm/9iCVpGU/rQ=
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
Subject: [PATCH 6.6 187/192] drm/amd/display: revert Exit idle optimizations before HDCP execution
Date: Tue, 25 Jun 2024 11:34:19 +0200
Message-ID: <20240625085544.338366686@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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
@@ -88,14 +88,6 @@ static uint8_t is_cp_desired_hdcp2(struc
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
@@ -551,8 +543,6 @@ enum mod_hdcp_status mod_hdcp_process_ev
 	memset(&event_ctx, 0, sizeof(struct mod_hdcp_event_context));
 	event_ctx.event = event;
 
-	exit_idle_optimizations(hdcp);
-
 	/* execute and transition */
 	exec_status = execution(hdcp, &event_ctx, &hdcp->auth.trans_input);
 	trans_status = transition(
--- a/drivers/gpu/drm/amd/display/modules/inc/mod_hdcp.h
+++ b/drivers/gpu/drm/amd/display/modules/inc/mod_hdcp.h
@@ -156,13 +156,6 @@ struct mod_hdcp_ddc {
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
@@ -279,7 +272,6 @@ struct mod_hdcp_display_query {
 struct mod_hdcp_config {
 	struct mod_hdcp_psp psp;
 	struct mod_hdcp_ddc ddc;
-	struct mod_hdcp_dm dm;
 	uint8_t index;
 };
 


