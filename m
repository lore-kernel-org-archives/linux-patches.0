Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735D4159560;
	Mon, 29 Jan 2024 17:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548241; cv=none; b=dYHkvmaPzOOnB3TytqRp2u7nGwbwwp0D30oymSLSw8uT/+bjffu4B0mmETXf7YlpEjJM74h9OQfAaJGp+fxJpAGoBxT8EVAe8LZebt8Nb4TsUqAvMg5kBO5JJw8n9uRU2W3aDVE3mZofznW5eMH7hCV0JF2GboENLD8bGrdVuBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548241; c=relaxed/simple;
	bh=QL/8SAs0I0frgnQGyCbxxfwu0AXmhuCwjverhnfbHP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XPHVWABWK1Rmpb7vYnz8MgKPmbdYrqytJ3GHl7GP6YW6Wcj1tMOzLF5gO86yQhNf4QWHAyPcBv/HFL8KiTv/B1HL7wxUzHsSYFnfbcBRKc097TnADTse3Wm1W985HXjKUMbWSxwrJYMoJlcKIZmchfH5FWGEhL44ioVIA8Bn2yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qsN0N1fO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qsN0N1fO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AABFC43390;
	Mon, 29 Jan 2024 17:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548241;
	bh=QL/8SAs0I0frgnQGyCbxxfwu0AXmhuCwjverhnfbHP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qsN0N1fO3aMNryvmyiFwKIM1aeD17FyM/zlQE8t/ujyr3g6wEaNjw1f0NC/spGQVt
	 r5H4zYiyInGY9Selz61fE3aLJtbozDLfeqTWUOqbwUIPmy4/d1vHY+NTGNLSYBTZn6
	 v3kSnaBnHnkVSRgY2gnuP7u2nhJeRsbq+dq5hjGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Subject: [PATCH 6.7 267/346] drm/amd/display: Fix variable deferencing before NULL check in edp_setup_replay()
Date: Mon, 29 Jan 2024 09:04:58 -0800
Message-ID: <20240129170024.243951448@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

commit 7073934f5d73f8b53308963cee36f0d389ea857c upstream.

In edp_setup_replay(), 'struct dc *dc' & 'struct dmub_replay *replay'
was dereferenced before the pointer 'link' & 'replay' NULL check.

Fixes the below:
drivers/gpu/drm/amd/amdgpu/../display/dc/link/protocols/link_edp_panel_control.c:947 edp_setup_replay() warn: variable dereferenced before check 'link' (see line 933)

Cc: stable@vger.kernel.org
Cc: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Aurabindo Pillai <aurabindo.pillai@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c |   11 ++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
+++ b/drivers/gpu/drm/amd/display/dc/link/protocols/link_edp_panel_control.c
@@ -927,8 +927,8 @@ bool edp_get_replay_state(const struct d
 bool edp_setup_replay(struct dc_link *link, const struct dc_stream_state *stream)
 {
 	/* To-do: Setup Replay */
-	struct dc *dc = link->ctx->dc;
-	struct dmub_replay *replay = dc->res_pool->replay;
+	struct dc *dc;
+	struct dmub_replay *replay;
 	int i;
 	unsigned int panel_inst;
 	struct replay_context replay_context = { 0 };
@@ -944,6 +944,10 @@ bool edp_setup_replay(struct dc_link *li
 	if (!link)
 		return false;
 
+	dc = link->ctx->dc;
+
+	replay = dc->res_pool->replay;
+
 	if (!replay)
 		return false;
 
@@ -972,8 +976,7 @@ bool edp_setup_replay(struct dc_link *li
 
 	replay_context.line_time_in_ns = lineTimeInNs;
 
-	if (replay)
-		link->replay_settings.replay_feature_enabled =
+	link->replay_settings.replay_feature_enabled =
 			replay->funcs->replay_copy_settings(replay, link, &replay_context, panel_inst);
 	if (link->replay_settings.replay_feature_enabled) {
 


