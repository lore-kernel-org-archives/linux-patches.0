Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026030;
	b=iDEx0WkTiQxst8moRAvxYjSBLjVGHIuOHNBwKZk/rtwo12Tjh5F7fyfhmas/UWFFyByb
	 ZLzEHhXLiWhuKvtTEnMVNn61QwsJbRfRG3pfAlNa2qPm+HHiYBOAtZEkoOI+yDeRtpM1Y
	 3kHZ1tITlCEkCuzwqhBog3C32JRIcDFuPD+KxyPcARIy7+FupZaAsyJQutDlAK5vj3sbl
	 NnuJCvumOREIf9h0aYsKYPWEuF4QVoX5YHfekl450EEWfczzwWaxRjO86PaYD5MaiXEHE
	 efhohJDVqlj8EZA+gXQmnFzmT8OblY5kSkbAUtaQP5V6E6XdZtuzCa3f3H9+obK2tvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gmcg/9Cbh7YmLc7rk2D6VNmUrlOUt5LtMURKT/MojbA=;
	b=zqQZVQveY3+LL4XBMtJSC5fIRpdhoB/o30KlIi5J2bS1io4rlRAma38cLMfPY3XaPgeV
	 XfS+QCKvrhFvt3isAiSXDrB36Hl42kevbH44+7Z3Ukb9m8AwOR9f6H464v3bXgVhYld/1
	 6g/W7uJKTJnhqeR7R+Y1xbQ+U+3AZKR4Sz9uWIr1zNZUWSqcKEE6bMCOoUZVKipS8+2N7
	 iKo8GAtUTDypjuzogIgyiIaVrcOYAs31TRGH9GGfOG8/Tkbc3LvTgEGjQ9sGNLwFiXwTc
	 H9Yoq5PvVH2w0f2Rp2eqABp/vSiBP0aui5LIt67/n6In1/mMSi9HDtIUrL72YUrMAxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h+jI2cAm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6710606A31C;
	Wed, 18 Nov 2026 18:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h+jI2cAm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B2F1F000C5;
	Wed, 18 Nov 2026 18:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026029;
	bh=gmcg/9Cbh7YmLc7rk2D6VNmUrlOUt5LtMURKT/MojbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h+jI2cAmnBkI8tbCKYpJCvckAGcocGdEYeyZqLWeYgtHnqunBSDWVFn5Hf8ZGTLYY
	 YrJfjWe3vBHI1kr6DRytwJKDTwf04nMdK66Hva9yjhHEHXbc8mPhPH1FobOxjBZbvc
	 T/Fi5Hm0syfu83b6sCZKN+5KCTDJBbxOb+xmR9pI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Melissa Wen <mwen@igalia.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1247/2151] drm/amd/display: use right type for amdgpu_dc_performance event entries
Date: Wed, 18 Nov 2026 15:49:42 +0100
Message-ID: <20261118150207.591882192@linuxfoundation.org>
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
index 2e25990db002c..0cb355a0e97d0 100644
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



