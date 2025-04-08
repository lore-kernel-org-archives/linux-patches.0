Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56EA326982F;
	Tue,  8 Apr 2025 10:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109824; cv=none; b=Lxc+tQo/G3PEUksWznaQABS3RRq3iJRvAg4ocLmAjW3da+vhGHPC44JONhZCSGzE4FeIX3WqiUCdnEY4CGpkTpH0Liif3sBnj1mIAy8PQLC6i8ta2G7yhLjcS2S67TJgrftmKYLS1SSgyTZ/29hNms1uJIK1BCA6yjoCHwv+elI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109824; c=relaxed/simple;
	bh=8lB+f1ulH3EWd6sYabjfjQwmxU1h8gN472xmh3WTzEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pabl/OoDYTFBwOHs6d/KxJV7Ee6mLC2blkGVp1wf1i3XArHRHrvUmkQdV9y5thQRciZtA5M76GdcXa+kyDeVQmnYCJfv5JXSgweES4A6uloenwS9+pqtZVQyJa7mkrYvXs/prOpzlHwaKLAc7xLPrTZkIIV6Rlx8e6JNbIL+bWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BbjtYtKI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BbjtYtKI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A38C4CEE5;
	Tue,  8 Apr 2025 10:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109824;
	bh=8lB+f1ulH3EWd6sYabjfjQwmxU1h8gN472xmh3WTzEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BbjtYtKImy/fPKJnpNyDEhHnxHj9J+c8IGQxNmzijY5yar1V0R89VkuNs1+zJ1CDX
	 u3jvEyGet1jURMzbpE2qTgcE8C68YmAUtHntv06pqpD19xm30DoRVO+1PDJxrJC8uT
	 /bjlBgZLT+F1Z6OrfyBLK0fIRtY9WZwQalL93GIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Ma Ke <make24@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/227] drm/amd/display: Fix null check for pipe_ctx->plane_state in resource_build_scaling_params
Date: Tue,  8 Apr 2025 12:47:24 +0200
Message-ID: <20250408104822.387647155@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

[ Upstream commit 374c9faac5a763a05bc3f68ad9f73dab3c6aec90 ]

Null pointer dereference issue could occur when pipe_ctx->plane_state
is null. The fix adds a check to ensure 'pipe_ctx->plane_state' is not
null before accessing. This prevents a null pointer dereference.

Found by code review.

Fixes: 3be5262e353b ("drm/amd/display: Rename more dc_surface stuff to plane_state")
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 63e6a77ccf239337baa9b1e7787cde9fa0462092)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 9564905c2c797..8dace2e401bbd 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -952,7 +952,8 @@ bool resource_build_scaling_params(struct pipe_ctx *pipe_ctx)
 	DC_LOGGER_INIT(pipe_ctx->stream->ctx->logger);
 
 	/* Invalid input */
-	if (!plane_state->dst_rect.width ||
+	if (!plane_state ||
+			!plane_state->dst_rect.width ||
 			!plane_state->dst_rect.height ||
 			!plane_state->src_rect.width ||
 			!plane_state->src_rect.height) {
-- 
2.39.5



