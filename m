Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026035;
	b=SaBGbKKo6KL2aY5R1eu5gx0IaFbTOTIgLRuQd27dnj2YS+EJAHJXytniDpXyNcs4t6x/
	 grzvEodCL7vsJOQ0X6/c+RhXKd0K6W7cpUDxvs/PYBnZe39d+IdP8vSsZl9OZCZTTM9er
	 N54EaN91ZdSMME0xLqJoZo2TKPpDVCUWyOrz2hO5vqhjKZxAYlY3q8huJ2tRBOEBbxwKN
	 2T5k1R/A4I57jBUrJuc3haGfGFAY7jK9vBOW8rfj7x5+Y4dOYYyDn3QT8ylZL8Y6Z/v2w
	 0WIgMGjSVFmbt65RfYdSJe0xME/QzOqv6KW7rGQrvXPVQT9+DWEIU5/FZvHsMDmstZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J3det6FYH/WfgIJUmIsa0xvXm3nPLjih2Cewag3Uj1Y=;
	b=EJA8gk7QPvQGk+M9HprNf4J9wY2ZqWVUj8n6E7lAoV+blKHkahYI94XfEl5kug93zwfp
	 4vwV8kw9MIL6hTVQMZ+FAzgnVGcukTq/w+NPqiUZjtMWqV6qrU/nnKnBkgpiuZMpNIu25
	 ibWCzkodxxyNHPw6xzDbB0libPBrb+RVd96+AL8cx+Toa1bTVl5I3IRcx3YEptancm5KH
	 4jXlHaZ35w0zZ+oQ/xM52Pw8XTPBGEqadPDpwRoI9BphtGYJarjDOX5JhMcdske9W05YR
	 ZqZ146PJSWHBRW3zlX3QpA2gZgcwbbX2htqExxX1YNfcxlSAP6scFj2uYEVbmwUaY/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0cg1A5PS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C985E606A31C;
	Wed, 18 Nov 2026 18:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0cg1A5PS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95A21F000C4;
	Wed, 18 Nov 2026 18:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026035;
	bh=J3det6FYH/WfgIJUmIsa0xvXm3nPLjih2Cewag3Uj1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0cg1A5PStKq/3Z9/IGWdmPR6s1Hgwq77mk4uv0UBOMLasOspClLoegvm+EGL1HzpM
	 ahG4GjFwhp2+VZS5tBfMqdjg0HkPNcCwAMsOjMXxBgbEroUSbvFrImVviUuDZasrzO
	 7nmoh73QHpXKHKMHXZ+6jcuzkP2Zm4tsaFJeAAM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1249/2151] drm/amd/display: copy function name into dcn_optc_lock_unlock_state trace event
Date: Wed, 18 Nov 2026 15:49:44 +0100
Message-ID: <20261118150207.662181650@linuxfoundation.org>
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
index d0b40f0eb9eca..a8f52c35a94d3 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -665,7 +665,7 @@ TRACE_EVENT(dcn_optc_lock_unlock_state,
 	    TP_ARGS(optc_state, instance, lock, function, line),
 
 	    TP_STRUCT__entry(
-			     __field(const char *, function)
+			     __string(function, function)
 			     __field(int, instance)
 			     __field(bool, lock)
 			     __field(int, line)
@@ -683,7 +683,7 @@ TRACE_EVENT(dcn_optc_lock_unlock_state,
 			     __field(int, vready_offset)
 	    ),
 	    TP_fast_assign(
-			   __entry->function = function;
+			   __assign_str(function);
 			   __entry->instance = instance;
 			   __entry->lock = lock;
 			   __entry->line = line;
@@ -705,7 +705,7 @@ TRACE_EVENT(dcn_optc_lock_unlock_state,
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



