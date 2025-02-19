Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84691D6DB1;
	Wed, 19 Feb 2025 09:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955916; cv=none; b=SnRyjr13dh1SHfG1eJsnLJUpC9x8fg+CAlSm7EgCZdWHYF6tevR9aqtCRKDqjf4bVFsyUImNRBJCPIe0JcZj6PSan4bZeeNkRLFYqm/OsmDkowPH2pqGCaY34McVEsGAdq//1VEY6MHBfqKnctnntE2B2Iuby2iestTfjQMCisM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955916; c=relaxed/simple;
	bh=Pa5i4u+AWIOpeSXLc4jPGliAkxSpRBOxFtOLA/iZxDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYTD0BX2Hl+/E14e9n9ktzyuYhLD/2Krt4sKsoHyqfnZMpoVYDkvEIp7RbIbGwaQbsElExOQR0jc4FQ2QlbXu8uyT/A1GqAH0YbC8xD3HV7q8DoFuIKI06rIddIEw9W0FnkH+oOgLxrY5MUS48i/eY/TcabItAHsZ5A0qvtl7JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezIEWPgX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezIEWPgX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD1DC4CEE7;
	Wed, 19 Feb 2025 09:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955916;
	bh=Pa5i4u+AWIOpeSXLc4jPGliAkxSpRBOxFtOLA/iZxDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezIEWPgXPo6fUss0q2sYpzG7yXgvURTuYugoFXILwDA3ZPdi6KNpxecYCmS9PWnU2
	 R/+4x3oPZiBXbJigGgvo8TWNv5d/EFsafr1VRlPhudFJCgQKwkjmxdi/Q+5cAUd/NU
	 OwVh5EFS1+6AfHFIOMoirMHTVRxYg0HvSbakDLCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <rodrigo.siqueira@amd.com>,
	Jerry Zuo <jerry.zuo@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.6 135/152] drm/amd/display: Pass non-null to dcn20_validate_apply_pipe_split_flags
Date: Wed, 19 Feb 2025 09:29:08 +0100
Message-ID: <20250219082555.386027187@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alex Hung <alex.hung@amd.com>

commit 5559598742fb4538e4c51c48ef70563c49c2af23 upstream.

[WHAT & HOW]
"dcn20_validate_apply_pipe_split_flags" dereferences merge, and thus it
cannot be a null pointer. Let's pass a valid pointer to avoid null
dereference.

This fixes 2 FORWARD_NULL issues reported by Coverity.

Reviewed-by: Rodrigo Siqueira <rodrigo.siqueira@amd.com>
Signed-off-by: Jerry Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ dcn20 and dcn21 were moved from drivers/gpu/drm/amd/display/dc to
  drivers/gpu/drm/amd/display/dc/resource since commit
  8b8eed05a1c6 ("drm/amd/display: Refactor resource into component directory").
  The path is changed accordingly to apply the patch on 6.6.y. ]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c |    3 ++-
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c
@@ -2026,6 +2026,7 @@ bool dcn20_fast_validate_bw(
 {
 	bool out = false;
 	int split[MAX_PIPES] = { 0 };
+	bool merge[MAX_PIPES] = { false };
 	int pipe_cnt, i, pipe_idx, vlevel;
 
 	ASSERT(pipes);
@@ -2050,7 +2051,7 @@ bool dcn20_fast_validate_bw(
 	if (vlevel > context->bw_ctx.dml.soc.num_states)
 		goto validate_fail;
 
-	vlevel = dcn20_validate_apply_pipe_split_flags(dc, context, vlevel, split, NULL);
+	vlevel = dcn20_validate_apply_pipe_split_flags(dc, context, vlevel, split, merge);
 
 	/*initialize pipe_just_split_from to invalid idx*/
 	for (i = 0; i < MAX_PIPES; i++)
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -800,6 +800,7 @@ bool dcn21_fast_validate_bw(struct dc *d
 {
 	bool out = false;
 	int split[MAX_PIPES] = { 0 };
+	bool merge[MAX_PIPES] = { false };
 	int pipe_cnt, i, pipe_idx, vlevel;
 
 	ASSERT(pipes);
@@ -842,7 +843,7 @@ bool dcn21_fast_validate_bw(struct dc *d
 			goto validate_fail;
 	}
 
-	vlevel = dcn20_validate_apply_pipe_split_flags(dc, context, vlevel, split, NULL);
+	vlevel = dcn20_validate_apply_pipe_split_flags(dc, context, vlevel, split, merge);
 
 	for (i = 0, pipe_idx = 0; i < dc->res_pool->pipe_count; i++) {
 		struct pipe_ctx *pipe = &context->res_ctx.pipe_ctx[i];


