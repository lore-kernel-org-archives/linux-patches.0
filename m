Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019177;
	b=4TY1I1ah8jHCZqd4IfUJZ3qxHuWEK409ebjNKJhWF0l58eoU5vIB67XyXcaYeHarFWiV
	 CcnUWnxzQfMm8bDHmRUNPW8ZdjG6jxuYKfbI9YS3A5QEDRvZG6Qkm1Mw+NPW/sLQ3BNmJ
	 H0zKWNdTbK+DafCZ7HkysSOslm5qzqp68T74Uo3fFXlfN0ntQw8N3i9vAcSXuS0FhLcuC
	 CwY3mbNevU9OnAlZevxXPeBCZGLKWMpAHKZ92w+ert0GIoV0gCn5j4esmuBYxLcB1/dtU
	 3ks6CfrMdqjNzFCKIPI2P3YS+33tb3Itxu16kMv121b3pBkz+mGXDZ27itL18wxQrzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fxC9wHpW+hWQN50dyZgNV4WjdixsIDxNtQkb3XGlqLg=;
	b=BCMAXhCtQho2klawUDCDDP72GeckoP32H2i6WwvkDvll1eo+181JYL2grr7pFnsmNz48
	 9u5aFBxq4ECSB9YqeOL2UmgoV+klYn+Ezu/cw4FUqRCcsPhqnmqpHY+fD6tBcv6l4U+GI
	 7OsLLPTppywWoRYyOw/P0NNWuREeBQaQU8RMTlmDfBtppm3h9hXfISQEQQnxbYRbEyZmf
	 tUiB6wvY5Xsj/mIkZHkQ3I+FjDe4kq0sNXptHj/CrIRdKjx8GGWwuPFKu5CWRP3DnqJVC
	 HLjcM9aNuF3ZznxSgpcv7kpLZnjfY9d/XnO+1ngcyj9yrd1Skan5rRXGP6VC5uhyfGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aBocO0BY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46612606A31C;
	Wed, 18 Nov 2026 16:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aBocO0BY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A953D1F000C4;
	Wed, 18 Nov 2026 16:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019177;
	bh=fxC9wHpW+hWQN50dyZgNV4WjdixsIDxNtQkb3XGlqLg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aBocO0BY4mqj2UHwuqX3RYI6phErdNh6Z82vp/vKrQO9r+yrdlz7aAsih4gJzFW4X
	 xjBIER3tSn7+M5jpmiE0QV3AObj4uz33y8yv0K2wWK0+zUvGlmkAOqWBigOO8Wbu7C
	 L+joSQfW8xpSR44vPt0zT6CZ5BJdGgBJsIQQ4Kls=
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
Subject: [PATCH 7.3 1503/2651] drm/amd/display: copy function name into dcn_fpu trace event
Date: Wed, 18 Nov 2026 15:45:43 +0100
Message-ID: <20261118150342.127161851@linuxfoundation.org>
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

[ Upstream commit b4d41522012d91cd875cebdfd1a3bbb04eb863dd ]

Userspace trace tools that use libtraceevent to read binary buffer only
see a kernel address when printing const char *. Use string macros in
dcn_fpu to copy the function name into the trace event.

Fixes: 96ee63730fa3 ("drm/amd/display: Add control mechanism for FPU")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Melissa Wen <mwen@igalia.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
index 26c85d95bcc0b..4c87c30f57e89 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -638,20 +638,20 @@ TRACE_EVENT(dcn_fpu,
 
 	    TP_STRUCT__entry(
 			     __field(bool, begin)
-			     __field(const char *, function)
+			     __string(function, function)
 			     __field(int, line)
 			     __field(int, recursion_depth)
 	    ),
 	    TP_fast_assign(
 			   __entry->begin = begin;
-			   __entry->function = function;
+			   __assign_str(function);
 			   __entry->line = line;
 			   __entry->recursion_depth = recursion_depth;
 	    ),
 	    TP_printk("%s: recursion_depth: %d: %s()+%d:",
 		      __entry->begin ? "begin" : "end",
 		      __entry->recursion_depth,
-		      __entry->function,
+		      __get_str(function),
 		      __entry->line
 	    )
 );
-- 
2.53.0



