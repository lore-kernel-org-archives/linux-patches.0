Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625428;
	b=bsZu0B+pB+MyWjXG/+YzcIjxG6z5AIQ+DVIyS3mjYrXtt1q5+IRYOW9FhBekIFIa9CPy
	 0wuU9xMU5aGbsSLG3OW/8lSBxuqj0eX514qDXc3KVdo+I83exmS0LZLQBUzpIiI2CpfyP
	 lrcixtoLqPofrbo8aDbIUUh6bsFvpFyk71lcC1h1p15knvrVVGyzFsmMadU+FP/ERwqpx
	 U1nU/0uwGfVf6TOvc7KAKIqfaA1C0LZ8y4BHk01VmrW3qHqu3xurm4DSTjRiRnxw2/D+T
	 LnZTjXTT1vLftF9Ayu147aHmorxg8oawoUXPOrkgZ542yB5Uj1QFxJc9slUJoXVOIWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bXVeD5SrgiWyV2c3X2pqFCRxdBlZwThBLOGGLj5akjg=;
	b=n7m1JoRJg98VhOLxULv9ng3RQH+I4ddzR5tT1VI+PlgksRscoXeU9TaDU8REvBCCCcZt
	 yRCgmdufF52JutqiAU5vrAOizMBzyLwG7hM7eoRau53FH733ee9A5pAiQ6gCs5+MjeGFN
	 ckjte3u0XBJkP/V68GNqNqwd6ElCwPtMElP4hM3P02mqqk88l+uky43w53l2Wbf/Fa5ID
	 DzljyvQ1eICkcrPL/gSt5Cwa/FRbSVJUsOezYoLW8suPT/YUnQeAhrd07JgEuxTj7zC0T
	 zOBJLoY0aqbuT41PLQzf3EQeW1lMKubop4dEm65mVY6nJUeF0AR7ky73sTy8OFA3GrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zlFwSRMj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3AD606A31E;
	Wed, 25 Nov 2026 16:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zlFwSRMj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 659491F000C4;
	Wed, 25 Nov 2026 16:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625427;
	bh=bXVeD5SrgiWyV2c3X2pqFCRxdBlZwThBLOGGLj5akjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zlFwSRMjag/wdmP0R39FzTo7uqPyTHnd8aTRLnHhsUEyVXCO6Btj1zP+6IJEPhAH0
	 9Z+VwZxo8zYQS4gSkLjgUoZO8qLkfxYarIedOe4aG01l+8ozaF8tZ3lYA0XB5xr2gz
	 Fs1H5Hw43MBpP9+s7wLkYqTrFDprDsSR4v4SJrmI=
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
Subject: [PATCH 6.12 468/816] drm/amd/display: declare amdgpu_dm_atomic_state_template as an event class
Date: Wed, 25 Nov 2026 15:33:36 +0100
Message-ID: <20261125143900.034721031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced struct drm_atomic_commit with the older struct drm_atomic_state in the TP_PROTO and the state field of the event class, because the type has not been renamed in this tree. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../amd/display/amdgpu_dm/amdgpu_dm_trace.h   | 56 +++++++++----------
 1 file changed, 26 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
index 113b04678dd37..2f97613a647fb 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -310,36 +310,32 @@ DEFINE_EVENT(amdgpu_dm_plane_state_template, amdgpu_dm_atomic_update_cursor,
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



