Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031228;
	b=RhhB9iUPLjQw91K4+z2Rd5XMY3fVxBgt8Wd9VtyxmDDgQUmabtduZpBu2PgqAEHcbnVK
	 C2AlYGOPLysqyKpixpTYDKcXnwmP/qaCgYQKLpM2AfvuaKON+0bEKdQ414JXL75MSSZzw
	 Of0mfzCivCmv6fBKtpy26jHZUiFb7w8dAZSazqKHo1qSLSObiEgSu+lUgehBSAWaCLrDZ
	 xx7mcGGN7YgUsBbMvEu/gornT5dZuTaYOg1yvy+THhZl2daJTaMUWArwigVI09adKtXFc
	 vNcxnFAMGjvaKuk3Si88KX4W6J9mkmvA36dr0EOwCtnhd5rKUggRwmISu3iHiKY+4YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031228;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4Q47AWZQE1NqgJXokIzwbGKKuyHnA3pxHyRUEz8zGuI=;
	b=bDjcDAPPxGKK/3DEJYrfcazl0rQ1DElskJetvlNM6mL9AaXnJ7esWFpZ/c27hiYtzVex
	 ce8I1jWw7LJ32iBwP2y4zP7BG1r+9ZxZPdHCIT6ygzqQDVd15aYsusvlc26QkQ5vYBPIk
	 ttKbmvIhoMFrKwKb24qsE6pHVcJzMaz1tlu2U3GKNZtf4SOuRJR/BWwiBEFDFk5rCqcbI
	 pUR2FVn4qm+eSCR3R41HdvrLwc4OYHkz2fV15R5xrTOIKXZILCgqcgzXN2ZE+QdWS+Q2N
	 xRKqOg6N4oum2p3i73dohaq0Loh3aP8838mtZylaxCePj1I5ppTS7zEf+uzQ7yXBG2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E+uJYt1p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFF2606A31C;
	Wed, 18 Nov 2026 19:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E+uJYt1p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E560E1F000C4;
	Wed, 18 Nov 2026 19:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031228;
	bh=4Q47AWZQE1NqgJXokIzwbGKKuyHnA3pxHyRUEz8zGuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E+uJYt1perW0bxRFR+0UuoRsJMFFQn3bTEfafvDA8q289cQ/Cn8KPaiXRAC3v6gEP
	 p6N6CQVgaWB1tW3qqdpS1bFeROZpwytM/09uJQOvf66fliQBUh2Osub1NMDjSwZhFX
	 b4T/WyAsVtBiAzge3Jh6gzapvlYQe2ldqeL/vn/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0985/1756] drm/amd/display: copy function name into dcn_optc_lock_unlock_state trace event
Date: Wed, 18 Nov 2026 15:51:52 +0100
Message-ID: <20261118150049.391816289@linuxfoundation.org>
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
index 8043c4ac31d5b..113b04678dd37 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -664,7 +664,7 @@ TRACE_EVENT(dcn_optc_lock_unlock_state,
 	    TP_ARGS(optc_state, instance, lock, function, line),
 
 	    TP_STRUCT__entry(
-			     __field(const char *, function)
+			     __string(function, function)
 			     __field(int, instance)
 			     __field(bool, lock)
 			     __field(int, line)
@@ -682,7 +682,7 @@ TRACE_EVENT(dcn_optc_lock_unlock_state,
 			     __field(int, vready_offset)
 	    ),
 	    TP_fast_assign(
-			   __entry->function = function;
+			   __assign_str(function);
 			   __entry->instance = instance;
 			   __entry->lock = lock;
 			   __entry->line = line;
@@ -704,7 +704,7 @@ TRACE_EVENT(dcn_optc_lock_unlock_state,
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



