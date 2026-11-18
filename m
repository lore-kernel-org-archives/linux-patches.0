Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019174;
	b=WDwpx+WDuWLQEgtweNXk4/H4cor8A6IJwoW2yvamEt3EEyayPLzdRzoHEcOoy35J4ydc
	 4A7ZSe9FoRufTxjj+G2/MxIMi5MX+lY2/P2AqQr5KEylpG6IUWQhoGIKffpcAPN1C+Oy4
	 6+n6qITBAuQqUHl74dSRPAH5dnhky2/m93ztVkv35Rmo3F1XQoAz5J+F9zv3NiZLTfrLs
	 x0hBIIO5wDw4pfj38dRZiIhZRoMBbxM9U0zNsXLuzymmah+CkxMAD1aPwxUpjWZq+3fSA
	 ESOmuRmtS5F2/r2IWlO9MYnRPtPIzs+Irq6urjBSy/qvhAg6o2ltC6k3tyHkbY6Ut0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pd6gCIimwH5P4eIs2U575n532CvsDJ1ZbkcUeYgm1K0=;
	b=B/PWpd5WO6WFfDbQU8wNc+5Eu5MEMw6WHGQC+U8coyScDIydK6fkpvuwCSnuRjEssLHA
	 cM+OzE1s5qQlpQkPSZyYbxYLaqtKy2qOecJp1Kt2i9IzWcAxzYd3b2laXjc2RMEQy9L1G
	 yG3zvV1wnZi5MowZrsb4sGSL3tvh/foAXYhUgnK/jiSh/JxODz9bhduqZdfisx2sVc/tk
	 bbu8pWHhiGbPRrOE/eYNpzM3qN9jv79szU7EexOeQw9k1+tS9kOfv/7+x0L8M2shupPmv
	 9QqMIQa+KOjXoIePyScLqflm6d4byF8TBVVzkBd+5QQtV35bufFfpsIuITr/wgVLAPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E2kGIlD4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3C9606A31C;
	Wed, 18 Nov 2026 16:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E2kGIlD4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F090F1F000C4;
	Wed, 18 Nov 2026 16:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019174;
	bh=Pd6gCIimwH5P4eIs2U575n532CvsDJ1ZbkcUeYgm1K0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E2kGIlD4rxTKet4Qj8dDKwzuoGkVir3NJZVdEzezTHwPKwJe12Iv0QNB7PKTTn0aA
	 MS54JnfJPIol79sP2sO+2xu8YCb63Tj/7X9Wg+vK9HoUIVg5S/x0+L/bBx8t+fEi0t
	 FUa/rFdi1QKDjfqju3cu4JRcxp3A0xESN+ORM3Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1502/2651] drm/amd/display: use right type for amdgpu_dc_performance event entries
Date: Wed, 18 Nov 2026 15:45:42 +0100
Message-ID: <20261118150342.088869287@linuxfoundation.org>
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
index c59ba41a97210..26c85d95bcc0b 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -76,10 +76,10 @@ TRACE_EVENT(amdgpu_dc_performance,
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
@@ -93,12 +93,9 @@ TRACE_EVENT(amdgpu_dc_performance,
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



