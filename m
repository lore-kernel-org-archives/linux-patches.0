Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041067;
	b=ZdMHmLuKQLeSdqMlGFRdS4RhXh8OIKB2/JJenEmyN7I6X6yVRFjeGj1HzZ5Uj4xbFfZk
	 vfZC7nFMAlXA5JT85D7XeCrLKhQdhD2v9wRGNhxGfdPIl7f+4De61nmajXSV4n1q7frSM
	 Hqxyo44j6Ge0BJAhGcy0YGVjL5meIp0Y9eCj6GB8hcoBYqhz3h/sv0AsdnnMl4AibvXu9
	 KBseGWG217FIDLVIMoZ1j0a/z0Z2WifT5QDeucsAQr9lpj1wBMdbovzCQL6+6LtOf25/1
	 qzRLf0frj4wumRmMeFD8RwZoWO5hl+PqsWtYS616m4Cc4yCv0l79sgvxtpUSKOsWqwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EiDhsG7ix0yv+3uV31uyeA+xcoCFqsnjo1Zu/RMJs+g=;
	b=kBWAM3v4EF2VUYg17Fxo212SqhhOAXedRmuf7FBnGAYU63H8WcwvsT35qgFu9nmqPU4o
	 X3DUuT2QTS1MUtMSuYaF0YQKyXjdR45feLlt6kVOpx3LViy0iWoC7wc+wp+M7xJ/WtmTc
	 oECyraHX1IQOrGeAjXU1YRlKkJiddYXgfMeisBLBASzv0e6/53qqkAYiMmdTJm8ooM6BQ
	 Egb8ef5B9X7cxVqCFg04wVoTmQsA38zKepbdl3qVT5CZ+KDrW6+vXww9xtknsWTKjXMdJ
	 1cF37iJxJIYjL5U9kkLhLs7z6j9rG627AvYuUfccsjWA6QB4Ie6lZlS3aWzkXshSIuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WD5wEufT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D202A606A31C;
	Wed, 18 Nov 2026 22:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WD5wEufT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C201F000C4;
	Wed, 18 Nov 2026 22:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041067;
	bh=EiDhsG7ix0yv+3uV31uyeA+xcoCFqsnjo1Zu/RMJs+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WD5wEufTLePuu/gRWi41UnwbafyjaQKKgv2AXB0z+UJXes3G7N+LefW8Aqic/YS6s
	 jrO/DEYsYTxyCViYGgKzSuTyBQs8+gOk8YYUbepZJl7QDUp0or6Jw+x5RHRduW0epY
	 h+w/OhT02Xa3C5PsOkeO1hqDJbomwcbF6UnEF+EY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2682/3318] drm/amd/display: use right type for amdgpu_dc_performance event entries
Date: Wed, 18 Nov 2026 15:55:04 +0100
Message-ID: <20261118150441.441894901@linuxfoundation.org>
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
index 49d3db6a6f704..6ec98d240fef7 100644
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



