Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019166;
	b=2AF0qj+CnCkWnw2/AVbHl7Y/tTvhQfoAa+Tnk6MOzeL+1063lVxzTzH92I095Afxzvrn
	 ktuu6wjP9rnlBeqqY1JCJuNDhEweVSN54jP+YzofIZHYP9sot6D3whjlQIYcqdqk6JquY
	 LHGDzA7DtYXMtqfy7CxJW5GB0HIsYb0mtd8D05cznxWhIjThxk5VD4DXqiq5WSuk36xz6
	 a2CWNnO6M7srwZz5XELCFel6psQSMl0OUsKX0+XJp6PrdC6u8NUaqnb0ibfoTos7zvSpY
	 DoziDB7Y6wO6SxBJQHiVmZ38iNKI/FG99G6h+Y39bOBnvA1h4w3j4ysI1stUBGrCmbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rWVbqstLLeqpo5RxkcnLaZwBKSjbHe6Cs1YLVAwzvpA=;
	b=N79w1u8move+INIUqdgsoksCNf0oNZEPmTtqhvau3OdVKBStIp2DsxtUIzeH40H3OmvH
	 sGFlfb6rk6vGIrz2EiGNaZobTEnVAMDRjdqvLDp3sPfXiMnAZ2Ug3hOwh4MyTr+022Y+U
	 FDx4oXwKkKhLvIbu+rZHut0YKh4pHnJwuxYL6SeBAqzaVMwACaN5NtEETZItFETFtQ4d9
	 w5ANrJT8WGTfXO8wY1Jrh2gQBP+FyY8ZL/bJH1VcOuYL0t83Vo5noajKAXpeqHknUWw8A
	 iI84S4K6QDhQffNq9qI22cb2ZDc5twEke2Yccjwxf8vbd+WJH3FQYYyEZO18VHdBBug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RMq+zBNK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E01606A31C;
	Wed, 18 Nov 2026 16:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RMq+zBNK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31D91F000C4;
	Wed, 18 Nov 2026 16:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019166;
	bh=rWVbqstLLeqpo5RxkcnLaZwBKSjbHe6Cs1YLVAwzvpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RMq+zBNKzHpMDWIwWJ8IHEV9X9Lw0pAxq7FoQixOc+X5LkR3yPQtGQblz2skyx3H3
	 JdBnKHHvfh495ch7SyLYv/IQBHzgdQp6tkNJ3p2Kuhah8Y6wG/OA7nFLwl9YoINzkt
	 ORpe5YEHpw8o/vGfi7zKZAyOQwyKsY2RAJH0093g=
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
Subject: [PATCH 7.3 1500/2651] drm/amd/display: fix vready offset assignment in dcn_optc_lock_unlock_state
Date: Wed, 18 Nov 2026 15:45:40 +0100
Message-ID: <20261118150342.019806658@linuxfoundation.org>
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
index 887ebac8c97ed..f5c2f589f691f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -701,7 +701,7 @@ TRACE_EVENT(dcn_optc_lock_unlock_state,
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



