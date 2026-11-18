Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031221;
	b=m3oq6iwd0NpMtz6bPHEAEQsdDwXd4Tcw6bWvxcObW0ixBga/4ulY8w9S/dp9gRQmbZKE
	 zJlQTAy/ZBtqhAAPud2/VK5pIwdpf3JLhQ7cRJSLZ/84N2413cADAZ3qvqUZf/kGwy2U/
	 4Uw1VE56fSgnmF/SpI8yfxDMmH2VBP/fWIoy1xNx125WTWD0E3tEo08Wgdq6oYsWp7qQq
	 YErhwE7Fwdy9P4WI5ZukYpfvBqk4V+CKVtknwsYNSZgckMeMjrJjI1ElSUnDjkmlKpCGO
	 v0dMkiJhwufMbD8Sqo9XMfvIqXn7OZRQiEKlOrKoE+/sPOHLldahNYAn/46rQnPN5gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sM8ugb4FVv1Wp3tp4T4tWpy6zRJ0BLXdIGkit8UAVn8=;
	b=1/gZXdKoUCrylUDYPMn8hJtPNVyL9U6CK+LKnJDhBIJEV/fLi/S4V4LlVmuvyLN1MF9P
	 ynnH6rff0pvzsO9pGzxws45q7eJvEcOohS7JBJthJn3DThWk4G5hx2BQf1/Ia4MY6i+yH
	 Ggzyy1i6XpnNdV1sMUChMQnno4fcZ4E8rC1rlZmfuf+6bcZNmGRXfzsc0mkpvHb0OoHfi
	 cRo0ZTp3V2PZvaAF2SUO1fnV2Zv0kS5nqP2g/Rt4QRLqCkiXT3ZMpYn3gRCsjyif0BcX2
	 B4MxH2aFpUJHxGJYE0grpCJVWbqoBrUtpSlTmul4/Vmprnn9KDEpLG3CRKOgiqzqyug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=muRSPRav;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656BE606A31C;
	Wed, 18 Nov 2026 19:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=muRSPRav
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964B91F000C8;
	Wed, 18 Nov 2026 19:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031221;
	bh=sM8ugb4FVv1Wp3tp4T4tWpy6zRJ0BLXdIGkit8UAVn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=muRSPRavwsJ742GLKHHi4mYfx67I0nX1TkbfyN8FHH+yGnjEphpqrSSbrqkAT/N3o
	 M/tNMRyn5FCqJiPR4i9r0+/fl3PaqmmPuDE6B0PYW930LG6dHT445MG824Hh7sEqPo
	 PTlPJtLczV8wmpETl/XQmEOozBVoakwyC0YRNm98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0983/1756] drm/amd/display: use right type for amdgpu_dc_performance event entries
Date: Wed, 18 Nov 2026 15:51:50 +0100
Message-ID: <20261118150049.313577288@linuxfoundation.org>
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

[ Upstream commit 99858eda764364bae733448c7eb79145d3d043ec ]

Some amdgpu_dc_performance trace event params are passed as unsigned
long but stored as uint32_t, cutting them off on 64-bit. Use the right
type on entry fields and on printk use unsigned format accordingly.

Fixes: 0cf5eb76e2b4 ("drm/amd/display: Add tracing to dc")
Signed-off-by: Melissa Wen <mwen@igalia.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
index 3151b9b9ae360..a0e8d1c9bfbfd 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -75,10 +75,10 @@ TRACE_EVENT(amdgpu_dc_performance,
 		const char *func, unsigned int line),
 	TP_ARGS(read_count, write_count, last_read, last_write, func, line),
 	TP_STRUCT__entry(
-			__field(uint32_t, reads)
-			__field(uint32_t, writes)
-			__field(uint32_t, read_delta)
-			__field(uint32_t, write_delta)
+			__field(unsigned long, reads)
+			__field(unsigned long, writes)
+			__field(unsigned long, read_delta)
+			__field(unsigned long, write_delta)
 			__string(func, func)
 			__field(uint32_t, line)
 			),
@@ -92,12 +92,9 @@ TRACE_EVENT(amdgpu_dc_performance,
 			*last_read = read_count;
 			*last_write = write_count;
 			),
-	TP_printk("%s:%d reads=%08ld (%08ld total), writes=%08ld (%08ld total)",
-			__get_str(func), __entry->line,
-			(unsigned long)__entry->read_delta,
-			(unsigned long)__entry->reads,
-			(unsigned long)__entry->write_delta,
-			(unsigned long)__entry->writes)
+	TP_printk("%s:%u reads=%08lu (%08lu total), writes=%08lu (%08lu total)",
+		  __get_str(func), __entry->line, __entry->read_delta,
+		  __entry->reads, __entry->write_delta, __entry->writes)
 );
 
 TRACE_EVENT(amdgpu_dm_connector_atomic_check,
-- 
2.53.0



