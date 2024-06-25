Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43EE41465A8;
	Tue, 25 Jun 2024 09:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308798; cv=none; b=AisDYrxf0WJYZrJCgVZeevfJdbJOqKlpP0RRZaeRXESGIlLrkG3YPEpXVMj5PPQ4PGG+0XOj7IRllzEzFYtp1i0piOmXTxvpnEWUfmD9dnWyz0x+nXjRwwgkxBs3m+BOpSXcTHW35tqoBYZ7A94qMyUBduOECXmWAG6W3LC15wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308798; c=relaxed/simple;
	bh=RZGKUZe/6Gc4y2P2W4SnwIWQRrjtcEURmjEsJl5Wlr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPdLcWQuG6LQcSXWBjbpksTn0sF7o6p2J3yYT1+qIJr319+hso8s7ZX8fvTSIdYIWpt7nD+qmQYEfl0dD8fAhzxrn8e/77NQb1teh6MoO/X/5m3t/oigohfeALls7CzEuFAB6bsPJYRA1PgmSjeWDztxXPELOF42+/v9egZA0ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5qsIMiZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5qsIMiZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEDBC32781;
	Tue, 25 Jun 2024 09:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308798;
	bh=RZGKUZe/6Gc4y2P2W4SnwIWQRrjtcEURmjEsJl5Wlr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5qsIMiZ8/p3KzInE6qdUPQYQJRFD4605Z3UGKsK1gqRdIFNtC5eO9GJMelJrJ43/
	 LHu/pUWFw9uhRSiNwdSe+dTvxMfQ2DeFswHIXZ3oFc704yiKCJw2jN9WDB3KgMUmIq
	 oKIFpHSxQpOFSFAVuaPliNkSB0f4yqtrtFFMyLG4=
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
Subject: [PATCH 6.9 244/250] drm/amd/display: revert Exit idle optimizations before HDCP execution
Date: Tue, 25 Jun 2024 11:33:22 +0200
Message-ID: <20240625085557.417922516@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
 


