Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AD616EBF2;
	Wed,  3 Jul 2024 11:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005893; cv=none; b=XUQ+YYZCToFXDqno+hARjq1v76ifhCHnro2k3mUUJ6E4pmPoP6h1aifilD5+gsmmkjNDpVSg36WsB3Ilvifv5hUUTqzoEJXVHTkwZ/Oh7i63V66vcWAeaxEOvUOJMOt5VObHCa5WaGKdRKu+coLLZwkoQdOXhkSPjtVQ0UPxfCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005893; c=relaxed/simple;
	bh=qta9eh5EC2cNwEug9t8y5/4fau9gQMzaZbbdaVptJk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngKNuCptUdmqGEQ+SFzI/nacpHsDXx1+yy/naYR1h6p7eivQx3yhQjae0aQLbMTK1OHBcTa1um3WfqO+Cv6JyQouiUg3vXrNNj40jT8t+fQLrwDTe+izP0H5cgboukLCqw1oZZk8TlB3IzAUsYIQZo02WU6frQe9sH+eIhSIkZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YgGmpmLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YgGmpmLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80AA9C2BD10;
	Wed,  3 Jul 2024 11:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005892;
	bh=qta9eh5EC2cNwEug9t8y5/4fau9gQMzaZbbdaVptJk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgGmpmLqFJcMzwueHPQXjUcUI7S0f4Kp7JNXPT355ricbSiwi5tp8s1DSBlCFcTK6
	 t5ONEYTmFUKn8u4Oo4e9WxD1rWvONL7Y70RmO/3T4LDB6HSIRF2gIlNLIeDzzbxEPe
	 oqsz6VsFxb8PTEhfVQKMbAbooIXtdRMmGm8nARY0=
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
Subject: [PATCH 5.15 231/356] drm/amd/display: revert Exit idle optimizations before HDCP execution
Date: Wed,  3 Jul 2024 12:39:27 +0200
Message-ID: <20240703102921.852517172@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -515,8 +507,6 @@ enum mod_hdcp_status mod_hdcp_process_ev
 	memset(&event_ctx, 0, sizeof(struct mod_hdcp_event_context));
 	event_ctx.event = event;
 
-	exit_idle_optimizations(hdcp);
-
 	/* execute and transition */
 	exec_status = execution(hdcp, &event_ctx, &hdcp->auth.trans_input);
 	trans_status = transition(
--- a/drivers/gpu/drm/amd/display/modules/inc/mod_hdcp.h
+++ b/drivers/gpu/drm/amd/display/modules/inc/mod_hdcp.h
@@ -154,13 +154,6 @@ struct mod_hdcp_ddc {
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
@@ -276,7 +269,6 @@ struct mod_hdcp_display_query {
 struct mod_hdcp_config {
 	struct mod_hdcp_psp psp;
 	struct mod_hdcp_ddc ddc;
-	struct mod_hdcp_dm dm;
 	uint8_t index;
 };
 


