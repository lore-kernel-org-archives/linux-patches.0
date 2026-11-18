Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055917;
	b=CetrXFLVQ4XXd4YdtE2cJQnugfhin6EWvJW4FGKperW4iHQfhRWdtPvcJaExNEAubIRX
	 4hAj8dwC8NJf9PE3fDqdo401Mm7/fYHAt7ax0yGRPPJPuRbA0zlvK426pMfCXb/AHEDG3
	 MLmEufNEFuS7Odzt7QQH//NJv6cqWVrNQRtbjctBtbYGOEkmMfDeTwiey4S0kuvGs7DdM
	 cuTTGz/eEVhV1dV3F1gF9jf5IxJWvIAWDGPKMbhrP/JuchIaWIG8XlYWgkjjg7bq6eY+A
	 gBPGujYpzLe1nuflejG9CduOpK7qF7Csf+RG2rOD2B7pxmYST9LSMPJrZ2D8UJd1T5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0pPYY6Kq77KIc4RsRiNcm52My7+0ZbQHvxui6g4jn24=;
	b=liT0o85P3QKR2zz0NqixMvsMkfqYtbI0S1l67exs1SGQsFYno9puG9ZNk1f1QzJT+ODR
	 OipViPWWslB3LRMNQW+NN2sOr7x/eadupsbWdFiM47/or8jJiwi1gBZPe5Hem5PFbK73i
	 A9Ya5zEB/V4FIekz00E5pO82kTTtp/HTC97ZkVbK3+N+4QklZPf5tt1K/fGk7pjq05KAw
	 kWa6vdb9w4YWy8o0p6/YWE/EZ9ImenPdWLZ0cNhAIXSuJNpWEqnaZtFhWv+lBYBlbo42L
	 KXWe0M6LnfqC9Ps49oia1pvoJcThpcl47sTQEHgNqQU0CKAYy0Tk7lls8wxgDY8nUXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fgVxX+WA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915F4606A32F;
	Thu, 19 Nov 2026 02:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fgVxX+WA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72E01F000C4;
	Thu, 19 Nov 2026 02:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055917;
	bh=0pPYY6Kq77KIc4RsRiNcm52My7+0ZbQHvxui6g4jn24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fgVxX+WABy02kJgVFJy33vW8LG2yWEgcQm2trnjZMlk67DckqoP1xeM7KvzZbn9LH
	 s6ZRco6GUu8v08wHSaYrV8iSl+XZ6hB6BDndu4RiBLzjpMYOkIXrj4X9HnX3I2yA7a
	 EfUpaiY0JhHbOShxWSczW+wDKXhP6hK4KHAxrH4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1801/2214] drm/amd/display: use right type for amdgpu_dc_performance event entries
Date: Wed, 18 Nov 2026 15:57:57 +0100
Message-ID: <20261118150123.550441259@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c344a94402da7..f6887f0bfbf36 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -73,10 +73,10 @@ TRACE_EVENT(amdgpu_dc_performance,
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
@@ -90,12 +90,9 @@ TRACE_EVENT(amdgpu_dc_performance,
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



