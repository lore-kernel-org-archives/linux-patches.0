Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019180;
	b=09XCurV2PFX6auiGYz/A2yHIgeFaE9y+p2IlVc32U/0CEie3HpcboLpXwEa7ET6GPk9/
	 8GP0HivPlOKE7ovGh+xLVtIxWeOytJut2KNF7W+Fo8QD9iF2gMWYYGgLMrKKEmWA7t7dZ
	 prZt7heN/JIRsrsLpZ/NN/S0rtQeapBw1EoJXOHGKPPBav3KgeLR8RD72JUiHyEWK1Sue
	 wu71cbQ81S/nEXqiWcGMwMjIraJZZghuZk38Yl5j9Zh9+ak0Y1SR+vrMwcOtgkFvZpp8k
	 QA8VppYvKNaf6i4CktBV2rwbLSmqM5znKREOoRLIFuEyspJndruDF2OWx5WaNd+vfQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RiJHEQYjyXbZS99Cwjrba3/NPySIt5FnDIg67gwNddk=;
	b=vys4BKidgdmtP/iiZXJfO1ImRdk5zb20CLWPMSCqIiksbQgSUeDj7jLk0tbG9YVczjIa
	 jgpT1V+nwuyBH0TUmmsaX+vOL/RpO65ijwzfqSz82pQxGWVNLjp44oYT0oDzMRz2pjm46
	 yJP5Y9UZ8AtEqsbAdN++VzZQMzRdtvCuJqoRofp2V32fan1F2pJtV+cD4qW9G7UHue1c9
	 CwGLlKjHqSWH287Mjiv3RQWPBHPhs0+p+zy9VteGeM/CWFVpMioJc3mFu//VqOi0nhxW2
	 TJcmXFp8uZoqw/6v2rVupkfYk13wF2CUvf+zy03PQ7QbAbncOH+NGXBycPu/rIMX2Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JJl9SaaN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27FA8606A31C;
	Wed, 18 Nov 2026 16:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JJl9SaaN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760B51F000C4;
	Wed, 18 Nov 2026 16:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019180;
	bh=RiJHEQYjyXbZS99Cwjrba3/NPySIt5FnDIg67gwNddk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JJl9SaaNIp/2+wLQQq8S+eyioo0wWGvWz78W7qRHjL1vbNcQFJpr7/l5/HVQyPtPg
	 mqXkUvPgNzeyKkELp7S4/IuS9YRchfUivDykKsb7kfuirnImx+/pZiSNJaJPPDaPxc
	 ihjpLi+i4OhO0RRLLwpdyVZJssAw53bvEmF7ncd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1504/2651] drm/amd/display: copy function name into dcn_optc_lock_unlock_state trace event
Date: Wed, 18 Nov 2026 15:45:44 +0100
Message-ID: <20261118150342.161232134@linuxfoundation.org>
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

[ Upstream commit 624a5a158c2a49f07edba7f8653eeecca114921f ]

Userspace trace tools that use libtraceevent to read binary buffer only
see a kernel address when printing const char *. Use string macros in
dcn_optc_lock_unlock_state to copy the function name into the trace
event.

Fixes: f1943a51f0f9 ("drm/amd/display: Add events log to trace OPTC lock and unlock")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Melissa Wen <mwen@igalia.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
index 4c87c30f57e89..7d46631854c68 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -661,7 +661,7 @@ TRACE_EVENT(dcn_optc_lock_unlock_state,
 	    TP_ARGS(optc_state, instance, lock, function, line),
 
 	    TP_STRUCT__entry(
-			     __field(const char *, function)
+			     __string(function, function)
 			     __field(int, instance)
 			     __field(bool, lock)
 			     __field(int, line)
@@ -679,7 +679,7 @@ TRACE_EVENT(dcn_optc_lock_unlock_state,
 			     __field(int, vready_offset)
 	    ),
 	    TP_fast_assign(
-			   __entry->function = function;
+			   __assign_str(function);
 			   __entry->instance = instance;
 			   __entry->lock = lock;
 			   __entry->line = line;
@@ -701,7 +701,7 @@ TRACE_EVENT(dcn_optc_lock_unlock_state,
 		      "min_v_blank_interlace=%d vstartup_start=%d vupdate_offset=%d vupdate_width=%d "
 		      "vready_offset=%d",
 		      __entry->lock ? "Lock" : "Unlock",
-		      __entry->function,
+		      __get_str(function),
 		      __entry->line,
 		      __entry->instance,
 		      __entry->opp_count,
-- 
2.53.0



