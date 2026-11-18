Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019171;
	b=yfXwWeRQX7kMLgBk/cF2QY+txOMvI/03b1tPrOwuFa8aNxud7qvAC50NpXYR8VMxBtd9
	 K6j/iJQh7AyPI+svdflKjJnaMQsjnlKAGA/AU2xyWgvhAhFbOI05B/v2+xyK8fZ0fIyW5
	 AVWSBXNc+viQFMxK7JKJo1GmSkdrg2yYrEx1D8Y9UC6nPD+6qowOBbRpDWuzcn8W6/VAh
	 ZG/yeD5Ese5vfybvCaTp/0xGAQw8n3BcJoEstREZ6mD+iv18ouqyQGT5tRw2gJQ/FS66C
	 M7hMXCd4lfkdT1c7PWK2UPxZnmDvAUpj6Ji6ICFQgh4mLzykF76B7eGusT3for0S+cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WK4Xdgw9oUAgAVNO3gtv4bVaCjdnozjyntnvdn12hy0=;
	b=z1HuFDdlOwrX29yIhTn9JJkpvZMV5Hj3nHcoUoOGLfzg7z8qnhWllJG5zE4l0N1KuOQ7
	 iAJNOmrYhOffXKaV4uYcIAckRglv9D5PVmBrYgKqvWOLY94hJWFIDNxUa60wcOR/Ptdbj
	 o/78IKjgGWpPLQdlqqLDmDy94t3gGmsTr/lvUiFISuYAw6PwjlhOF9AWTePv10SC/rxgj
	 RIjDWweQA/2/zNaTLvjCEHOany0tPAHloXH9D4GQbVHqxZuyE6yY9wbXF/OYHkYG3zwpG
	 Tpn7FEa8qJCfmvHXkVm0veWVJTtFqOQaro9kDoZTfGLoqzxGlIx4AcuZ6/uvhFPSN9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="S/3lFLdk";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49E4606A320;
	Wed, 18 Nov 2026 16:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S/3lFLdk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3DD1F000C4;
	Wed, 18 Nov 2026 16:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019171;
	bh=WK4Xdgw9oUAgAVNO3gtv4bVaCjdnozjyntnvdn12hy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S/3lFLdkJr3goChEgpQ8psG/Eh7TkMMBWGR3FTSC/RCuuWbUy0ztLn8Wpp1X8UA9W
	 3cR+Jw8nslRv0OA/ExgY+yjuFMZ+SlLVCq6u/6M5y2fGwRM4WrFrgQm6oihRhFo9gI
	 bx5+/Q+xwzdbIO+nL3+G0CM9xwDtnluK9A7yj3mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1501/2651] drm/amd/display: declare amdgpu_dm_atomic_state_template as an event class
Date: Wed, 18 Nov 2026 15:45:41 +0100
Message-ID: <20261118150342.052540337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melissa Wen <mwen@igalia.com>

[ Upstream commit 6c4f8c5cc00326f6c709bff0d640d504c90862ca ]

Don't create an amdgpu_dm_atomic_state_template event since this is just
a template. Declare the template as an event class that will be used by
actual event tracers.

Fixes: e8a982355f96 ("drm/amd/display: Add tracepoint for amdgpu_dm")
Signed-off-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_trace.h   | 56 +++++++++----------
 1 file changed, 26 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
index f5c2f589f691f..c59ba41a97210 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -314,36 +314,32 @@ DEFINE_EVENT(amdgpu_dm_plane_state_template, amdgpu_dm_atomic_update_cursor,
 	     TP_PROTO(const struct drm_plane_state *state),
 	     TP_ARGS(state));
 
-TRACE_EVENT(amdgpu_dm_atomic_state_template,
-	    TP_PROTO(const struct drm_atomic_commit *state),
-	    TP_ARGS(state),
-
-	    TP_STRUCT__entry(
-			     __field(const struct drm_atomic_commit *, state)
-			     __field(bool, allow_modeset)
-			     __field(bool, legacy_cursor_update)
-			     __field(bool, async_update)
-			     __field(bool, duplicated)
-			     __field(int, num_connector)
-			     __field(int, num_private_objs)
-	    ),
-
-	    TP_fast_assign(
-			   __entry->state = state;
-			   __entry->allow_modeset = state->allow_modeset;
-			   __entry->legacy_cursor_update = state->legacy_cursor_update;
-			   __entry->async_update = state->async_update;
-			   __entry->duplicated = state->duplicated;
-			   __entry->num_connector = state->num_connector;
-			   __entry->num_private_objs = state->num_private_objs;
-	    ),
-
-	    TP_printk("state=%p allow_modeset=%d legacy_cursor_update=%d "
-		      "async_update=%d duplicated=%d num_connector=%d "
-		      "num_private_objs=%d",
-		      __entry->state, __entry->allow_modeset, __entry->legacy_cursor_update,
-		      __entry->async_update, __entry->duplicated, __entry->num_connector,
-		      __entry->num_private_objs)
+DECLARE_EVENT_CLASS(amdgpu_dm_atomic_state_template,
+		    TP_PROTO(const struct drm_atomic_commit *state),
+		    TP_ARGS(state),
+		    TP_STRUCT__entry(__field(const struct drm_atomic_commit *, state)
+				     __field(bool, allow_modeset)
+				     __field(bool, legacy_cursor_update)
+				     __field(bool, async_update)
+				     __field(bool, duplicated)
+				     __field(int, num_connector)
+				     __field(int, num_private_objs)
+		    ),
+		    TP_fast_assign(__entry->state = state;
+				   __entry->allow_modeset = state->allow_modeset;
+				   __entry->legacy_cursor_update = state->legacy_cursor_update;
+				   __entry->async_update = state->async_update;
+				   __entry->duplicated = state->duplicated;
+				   __entry->num_connector = state->num_connector;
+				   __entry->num_private_objs = state->num_private_objs;
+		    ),
+		    TP_printk("state=%p allow_modeset=%d legacy_cursor_update=%d "
+			      "async_update=%d duplicated=%d num_connector=%d "
+			      "num_private_objs=%d",
+			      __entry->state, __entry->allow_modeset,
+			      __entry->legacy_cursor_update, __entry->async_update,
+			      __entry->duplicated, __entry->num_connector,
+			      __entry->num_private_objs)
 );
 
 DEFINE_EVENT(amdgpu_dm_atomic_state_template, amdgpu_dm_atomic_commit_tail_begin,
-- 
2.53.0



