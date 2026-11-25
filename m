Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622552;
	b=DJs5r5c3j2uGdxyqn/NnMy2MNNIN80QYS8G2Mui0RZSRKDgEXAmrH+yXEzTwKYpDuULW
	 nt66AmhqcMwZnZJ0UQ1NKvMNc/qU2KTgG6hQfKRGq2g53f//NIPzmcpaKcs6l89abQDP0
	 5Me3ahzpt+leGJ5HTr9ElHJtxL78aA/QDuY84jNtZ3Ah7Ivp+HvUMNItnVVBDrnHpO+Ox
	 o0vB9x8MSyQ2BW3EBamnkz63WeKtqFfTWjgfcYMh6JqnzPXiaGcxSLVg3XS4N7W72nIEw
	 xLbBeVsTMFCzN8XcxncwmZB6Ls8XVZuQzLekYtjRnzmKqJvIs1pqSR2I/iY/a0RKgCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jxHNPweTAJZdr4Vs6mYKaC3EmJ5qBgUBpwzWSlpvHw0=;
	b=tWUl6UOw6TtUBh+j+XfsPueKqlBwHOo4JLzE0rh8EVt0qMrzWlHG4wNy1hpcO6fgBk19
	 yTNqJzrpbXh4RJvHK8xbRDFQldQ7lcxKhfBCDEGfNfY3WGny9ZBpcf/aw06u+YeKhLvHl
	 DqfG3ZEcvx+XGrh2yLFyKndnP5ks9zjknuucSBJtkutcewreHZjgcOmtgW3cdHeNswRg0
	 2aE9WaMogqNd9z7r+zNovSPDQjs6v9N9qML8qkcqSHmNLVZjb2K5z6o7kbUCODVhNWeq1
	 TQS1oL4Bh7Zqf+HAANfkTiXwl/2IypRzylLk9tLpIFZiicOwTYmR4fgarSTagxOXcGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=maX8VUym;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3E9606A31E;
	Wed, 25 Nov 2026 16:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=maX8VUym
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115E91F000C6;
	Wed, 25 Nov 2026 16:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622552;
	bh=jxHNPweTAJZdr4Vs6mYKaC3EmJ5qBgUBpwzWSlpvHw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=maX8VUymB7Ys2uixcR2BwPro3Q7wnu2UvmBZcU9xQDPjcb4X7nv4d/W8p8xH347UD
	 ANEI4RQkUANpK8cDcdupxF49A39VpO755lkOzs9wc7EQg66icK3AV+rsZKRF/V+4OF
	 T9InAHnnnC15Gwfth76jD8HADsXSu755gwAT1pWU=
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
Subject: [PATCH 6.18 573/990] drm/amd/display: declare amdgpu_dm_atomic_state_template as an event class
Date: Wed, 25 Nov 2026 15:32:20 +0100
Message-ID: <20261125143835.514130161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced struct drm_atomic_commit with struct drm_atomic_state in TP_PROTO and __field, since the rename isn't present in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_trace.h   | 56 +++++++++----------
 1 file changed, 26 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
index a8f52c35a94d3..ec8b39b8342fb 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -311,36 +311,32 @@ DEFINE_EVENT(amdgpu_dm_plane_state_template, amdgpu_dm_atomic_update_cursor,
 	     TP_PROTO(const struct drm_plane_state *state),
 	     TP_ARGS(state));
 
-TRACE_EVENT(amdgpu_dm_atomic_state_template,
-	    TP_PROTO(const struct drm_atomic_state *state),
-	    TP_ARGS(state),
-
-	    TP_STRUCT__entry(
-			     __field(const struct drm_atomic_state *, state)
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
+		    TP_PROTO(const struct drm_atomic_state *state),
+		    TP_ARGS(state),
+		    TP_STRUCT__entry(__field(const struct drm_atomic_state *, state)
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



