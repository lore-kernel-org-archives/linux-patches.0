Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030586;
	b=lBHSN1m6dvmDiZZkjkF5wE/L/eeEVZLfkl+Wtni/3Nim7eRel1KjGVug4WIT11bJNv5f
	 2IVKvDaSese94cC8oeM6KTwDUqUdvdjTFIdvLTRouEJSMEOeiNrXjs9hafXf6LlPRTvMw
	 +VTADZqwgIqCdiSG1gaXyNDlhAUFNUblJy1asa88NS8PeQvD9PXq+8KDvGJDqerWi1SHA
	 gDEcfslFRE1TqJIJ4d6CmBvlchuvQDeZlTV90igMgw9ah71nOvbM03VXrTyzE0iW5In0B
	 jvCfEIbFb4Wuoq5RmSPTtEhxo59xPgHMKTZBjbUomvXHVYunE3i5e+rMSjip1yKhfXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GocIgbtK7v3C3rK9LHg8Lcy6Il47mYNe6V7aHqKUaOs=;
	b=MxKxEA2zT0oPzEtPSLpDHqVY+p0rNWmGuqdhLYYGiX5fCcXN666HreTKqZqhsjzdq+zB
	 xO+E42Td7NbGPNt4tyKZUwjQlnMZINO4Z84II/QtKW1i3ZlypS2dXMnUMJmtbF9uRwAL/
	 xv/xs0I2fLmnc5ck4NGuGPpVpiDa73bsZfAmIEiXVhK5cw8QI4CvpTcUw4Hoy5sUA0LbX
	 ROPKe3RwgMlTUIStMUVKq95VLNNN+3twkGHHylHN57XQMA6UFs17i392Mkz0At3YUQPWS
	 TLOLPnEtYZkU5gNOR8Oxfq2cYnReJEHur0zfRYb41iBa6/qDkk71mMm18FxBXrYySFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fg6pihOv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08BB60A6F48;
	Wed, 18 Nov 2026 19:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fg6pihOv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACBC1F000C9;
	Wed, 18 Nov 2026 19:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030585;
	bh=GocIgbtK7v3C3rK9LHg8Lcy6Il47mYNe6V7aHqKUaOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fg6pihOvN1jBNO8d6phTSsfxlwAXH3dV4PE0jGeXUj0QPjG+8N9RRfni+CbV+h64s
	 ++HU7wb3tp5kmj9j0/uzepBMXWJHWxL42tn4rJGnRTuJhuyu/imIiY+JuAlMHPItE7
	 72LGrXr9ydG6AzAmHcPjhMLMyIngBsVqmSaFYOyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0758/1756] ALSA: ump: Avoid dereference with max_src_size=0
Date: Wed, 18 Nov 2026 15:48:05 +0100
Message-ID: <20261118150039.806259968@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit b61a2369085fd995c8ad44245d3fbd45b1216f71 ]

safe_copy_string() refers the source pointer for a NUL terminator
before verifying the source size.  When max_src_size=0, it may
dereference wrongly.  Fix the verification order.

Only hypothetical hardening, and we see no actual issue in the current
code, as they are all valid sources.

Fixes: e3f035edadcc ("ALSA: ump: Copy FB name string more safely")
Link: https://patch.msgid.link/20261002081823.680131-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/ump.c b/sound/core/ump.c
index 6542206747a3d..e35253cc019d2 100644
--- a/sound/core/ump.c
+++ b/sound/core/ump.c
@@ -66,7 +66,7 @@ static void safe_copy_string(void *dst, size_t max_dst_size,
 
 	if (!max_dst_size--)
 		return;
-	for (s = src; max_dst_size && *s && max_src_size--; s++) {
+	for (s = src; max_dst_size && max_src_size-- && *s; s++) {
 		if (!isascii(*s) || !isprint(*s))
 			continue;
 		*d++ = *s;
-- 
2.53.0



