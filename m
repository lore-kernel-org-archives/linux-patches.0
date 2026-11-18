Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031225;
	b=FJzywlHtPFJwxIKkbOimR2tnTihtqLrKF0BIgwT0uQWZSch2DA84QTPoNmM6tPJUeBtA
	 9H1Fpz116XmOfgX9fQ1GQwkRpIR1Sc8kSlMwb7uT7xt6EXUZ6j1QZ6DibUF4zMpQ0lLLx
	 lGT56cDcyvc5t6i8jS01EaRrpO4OLwMunh+NA0NXbSTO/uXlX9HWvNt2YEOkAJSWzwsxn
	 XjzDKtp/gD397jixVJiLQ8PukPs39Aa+TVwLxcNZtcSHDOR1K9r9wr8ByzaR93J/58HDM
	 /uagYvH/RdUXLdjzN8S+/gpNJZCHY1cyyc5Adk1wmctbqQeJHXAXAjlVtHY6csKlpog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031225;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AJYltfB5GOxpV/gtiUy3ivMG80ZBmSXInkDJCGDSrls=;
	b=cR1zzj9jAMho3DBxqr3VK5bms6sM4op44KKc2ZXNgKwrlxZcPkLOUwg9lj5Z+YC7wDWn
	 LmZQS7dBYvRZwen/rzQVD06iBdz2qIRu1DAEASx3tstT++J0R4il3TngUygclf+I90V/B
	 PQC67RzKZhP0flG4DVKBKfmhru32f5ZZniqgd0p34R2/GBAzHFtx7wgIVaNoXcjeU2Qrs
	 znXKiG8NoqJwal7mqPzaNk4LZjetcTFExCZ5sn+ux8OEuPZZVMsMc0RcIwj8D6rA4Mohs
	 eac+H1WBW8q1vHY0ZjNm6vTCyWX/0oxOenTCe16nZY4N3kN5AZgW6CFBGAV5bbz/NTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DNTJ9FVw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A51606A31C;
	Wed, 18 Nov 2026 19:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DNTJ9FVw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716631F000C4;
	Wed, 18 Nov 2026 19:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031225;
	bh=AJYltfB5GOxpV/gtiUy3ivMG80ZBmSXInkDJCGDSrls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DNTJ9FVw5PxicDKRZtyVyGPX6uf31c3YvWotRNUjIYIlheQg4EqfhjIcft0EdZZ1h
	 13ji0BOnmhTOFGQ3SOtYeRAIUv3+EfvodogHIf5rz8xlFQW+K2MBBWdj3yyM7xfnW9
	 LXGVCLZ0hTKQXyB6M5mNWHKbeOD2utC3I3xZ8sgw=
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
Subject: [PATCH 6.12 0984/1756] drm/amd/display: copy function name into dcn_fpu trace event
Date: Wed, 18 Nov 2026 15:51:51 +0100
Message-ID: <20261118150049.355518134@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index a0e8d1c9bfbfd..8043c4ac31d5b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -641,20 +641,20 @@ TRACE_EVENT(dcn_fpu,
 
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



