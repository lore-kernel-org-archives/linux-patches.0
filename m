Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30C3207E14;
	Tue,  8 Apr 2025 11:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112463; cv=none; b=LzolSedOe8JbcEjCW+TfhZvlrJCCluXp7iFjE060qCLgJ9kn8rYaT8E15Arc6Y54SM0wSgN/bdmi9fPtP/u+4QLBBAapzZzPa5FmVEpx7nySwTfzCwptDyPFUTFAjfKisyGTWrwPdiPK9/eqkXBHdr/23T632cHsimIRiY+f/44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112463; c=relaxed/simple;
	bh=5an+s9gKEOdi7GVR9gH0q6vyqQ6EYTy5QZ81mhVYIEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEVWQbALqRU5683atGWXj6GohlwSoPUX83ZCO356p3/O9ZuQrjXu/gfJyWrSVgGjiiOw29R5/hsAABb/z64Bc46Q9SkhB8BHTVmMG1a6e6PNXTwfaLJXxhKaKA9/9JPtLeUcMC7YoSnoiR6ZT3OT8WFFfAnPbcvF7NF0B6YyiAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANC4kpgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANC4kpgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52266C4CEE5;
	Tue,  8 Apr 2025 11:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112463;
	bh=5an+s9gKEOdi7GVR9gH0q6vyqQ6EYTy5QZ81mhVYIEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ANC4kpgiAvmYBnCDCsI+XOFG+lIbmTypi1D2vMD2Xagbyykq6Me76IB6E0Wwin1HB
	 ZYAlM4o7omB0VFb0YpItuglKSf6VHIj3cs69Zj+8y4526vvJw0Gn0GDyPRmSilS7gE
	 N1TBYvh0EmDqumLw7IQGOSKUOEYe50gEz6GiFzWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Ma Ke <make24@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 076/279] drm/amd/display: Fix null check for pipe_ctx->plane_state in resource_build_scaling_params
Date: Tue,  8 Apr 2025 12:47:39 +0200
Message-ID: <20250408104828.397190936@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index de5192ee2b022..a84280b65821b 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1026,7 +1026,8 @@ bool resource_build_scaling_params(struct pipe_ctx *pipe_ctx)
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



