Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026032;
	b=KK97lYYSqCfMcM23dFbnTfXyW3XdP7qOtpbz1DxhB8B4bgWYb+3P8JQ0cwTQ0dx7XvGG
	 bGRyPzBx32xxqUT7/pD0mw9RPymN42r543ETLPY5DHFo2sStRjr5PLKL6X/MlaOW7lU2Z
	 abNUXPXrEQ40SSJz4lWCiqXc9psxXhWxULAQU5XTMZrxHpj7eBiKUBOKi8YjaRVaugCFL
	 gWB8O6B8BdzZbxzJMHGSOKjXE/dINSKAjRvACVIqPk4PcyyetxLKNi7mxFwl7prYv/GmS
	 jXE/i3YjdWT7GP+pfZf9sTUUn5nLTCdGRuQqvb+Av86ZGpUth+vDRCicfNK8urL4RyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/HJTCxMxh0d1i4YNz2cMFwq8bO9bqjW/mfVY7HUolHo=;
	b=vpOxFd3S7f04ztffXcyP/lsN1jPaX4fPUHh6dPPIVrlsaTZ78l9Yf716YpR+O0CFNPQB
	 pOagvYOzawQ2hKKa1I+7s4mmuV+Q7lT8c5INv+rOli/IsYz6jIyw4iFuhTMqn7LTD4S4m
	 z6KRw0SK91ZejM5SHxJmBlCzt2LIndNpVu4zsxwHq7tJc1Djziph4m0bvj2/iomFd/MOj
	 T2b0q8LSEdLpv3x5Prs4YlhyYpQq/ZRQF2y52+Dbc/OoOy+yMISrXK+NtG91xPqy81Wd6
	 2+pHXD65vGat7zkICZp8OlxUys0LGF3CGblGpLHDxqZX1gYLMqIA09qxQguYrU/rhMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TKUZjFjJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14C0606A31C;
	Wed, 18 Nov 2026 18:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TKUZjFjJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 235081F000C4;
	Wed, 18 Nov 2026 18:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026032;
	bh=/HJTCxMxh0d1i4YNz2cMFwq8bO9bqjW/mfVY7HUolHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TKUZjFjJFXnxfteQqDQrvd+dAhz+ozpltxBwWUMRJM3lGP1y4U20ICAn2CASBxA/j
	 /BoAbXYFrjczZ7ouFXrkq7R0iotmPwffdXl3r57x2xnupApQIUDXF+Wzqx+ZCY4TEO
	 aCFUsHgdF8s1JC8s/XkWcbaqhIVgcLpR0xcZNDJQ=
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
Subject: [PATCH 6.18 1248/2151] drm/amd/display: copy function name into dcn_fpu trace event
Date: Wed, 18 Nov 2026 15:49:43 +0100
Message-ID: <20261118150207.627003553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 0cb355a0e97d0..d0b40f0eb9eca 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -642,20 +642,20 @@ TRACE_EVENT(dcn_fpu,
 
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



