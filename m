Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041065;
	b=QiovM/yCLN54Xmg8fnGYXH+TeoIFutK3W/h6Qg3LwW4ccBaNsd9lAcpkvWN2UG/3l2kd
	 J7W6ezZ/92ybCVrhcle9cjn3WZ72jbWS/Vsw8lHq1cFHBLk0pM5Jz6WwQmKLnuyD8Okti
	 w5Ku1AiJjIVgpemx8FinU6/sz88/oqfkmcTgHg9tD9ZEG+Ooul2NyyVzMPMR4ITrpuax0
	 FjpqKUuPOggIBdh8Z3fjXswQFjVQrNhLYsS+Sk5prlJH+jOt4LT15Cvud0P8ob0OUZGCX
	 XU3+f1GftqIgTJxqszhQFIVaMfFiep2TwnJQ84vG1TOlvoEp56Qa+bMAQpeRPkN6Sbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TVKLMspNS8JOCmJaYXqJ4e6/3KPAF9vlj8LOj6nNfAM=;
	b=HFmoYN3aF38FrtK4w74ZBTuQkiON7cyclMR5ktvfW7WUnMJz4c/6AWm15svqft1n+eJH
	 e7dGUuN6kOETxKIE9HWLbU5LSha3TtrIhCEwja6TTZ2cXQNGmpRFfGUyTSjtfm8QWGC7a
	 laEfHD5AykMkCKpbKw+G9xlrV6xy/nqT89OVXPhRfftdYo9IBVbJZdWjkbrzLHnngXey3
	 f68yEVd8BJulNcwhO4CImX3WVkefCRVrCHfX1LK7ycqla/xSLmc2iNMm8Be2cV0acHTmS
	 ccQYyODgxgKni73roaAxUrQaInrsqzk+GhykPkr4DfYZZpk8zyfZQPWmltsI6VKwFGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ycOq+SzZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E45606A32A;
	Wed, 18 Nov 2026 22:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ycOq+SzZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2897B1F000C4;
	Wed, 18 Nov 2026 22:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041064;
	bh=TVKLMspNS8JOCmJaYXqJ4e6/3KPAF9vlj8LOj6nNfAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ycOq+SzZsl5H/k6K22PQMDZHr080dHI29C2nR7N6CG4HcGhcmKkBh9xjrb6mELwQ/
	 wbmfnXQzH/DXE1HqQKYuUwHJWGs5A4p/O24Hc0coZzpf6qMVApLn0MX+zKiOjo7WSc
	 89l45zyKqH++klXQrtJL6gzbs0bt+iuvJsWTPkV8=
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
Subject: [PATCH 6.6 2681/3318] drm/amd/display: fix vready offset assignment in dcn_optc_lock_unlock_state
Date: Wed, 18 Nov 2026 15:55:03 +0100
Message-ID: <20261118150441.414380323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Melissa Wen <mwen@igalia.com>

[ Upstream commit 3ad7f4ca58efd6c1216632c50873dfffdefbe3ff ]

vready_offset is captured by optc_state, but the trace point entry is
wrongly assigned to vupdate_offset. Fix vready_offset tracepoint field
in dcn_optc_lock_unloack_state to record optc_state->vready_offset.

Fixes: f1943a51f0f9 ("drm/amd/display: Add events log to trace OPTC lock and unlock")
Signed-off-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
index 058a060c04be1..49d3db6a6f704 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -700,7 +700,7 @@ TRACE_EVENT(dcn_optc_lock_unlock_state,
 			   __entry->vstartup_start = optc_state->vstartup_start;
 			   __entry->vupdate_offset = optc_state->vupdate_offset;
 			   __entry->vupdate_width = optc_state->vupdate_width;
-			   __entry->vready_offset = optc_state->vupdate_offset;
+			   __entry->vready_offset = optc_state->vready_offset;
 	    ),
 	    TP_printk("%s: %s()+%d: optc_instance=%d opp_count=%d max_h_total=%d max_v_total=%d "
 		      "min_h_blank=%d min_h_sync_width=%d min_v_sync_width=%d min_v_blank=%d "
-- 
2.53.0



