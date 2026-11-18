Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040601;
	b=j7fg23okdjfZ2DVJXfAG2UVX07fWNVB7vq7BMt4SGVPnlmJdQkDIXmYW1gYIRLuSeu89
	 00NjON8WxfmQ6nDZD2uaZFvT4wJs8lg8LQL5iYGlus9oA5H9Er269eM5kZDzLzN4tUITd
	 Sp1wKB6qIz5dYR+hELwAlqde98xAUWvjSMoqDK8XrqBlJnh2XbALBPE2v/zqoJYT2huKN
	 yBil5+RZfRKNmlai0uHDuAvxPDJ/byWYDAr+yPSoMQtRr3WbGEQD+/gDoYr/PxCeLMXuc
	 Ek0mNIfMpT+Kmtt/X1ytsASudUSmcbaJ3Dti9zmOKxjMpi6nIuO13ISyLui2jXH0JjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040601;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aTiqHigKgOc/Krwsi6gZF81YJryd+5H1rd3ozAgR2FY=;
	b=h/ML5fTcO4sMJ3KWadj3Jjn+3zBqZ54dkpl1ykt1IteITDHgoTEqKyWSbPfJ0JyD4bxc
	 EiaGSlDl9j8z2FjB//hB7hHLbGRH07Zqzai17VpvZVDUNUnf5OHUMAos/9N2U4n8xU9jh
	 tJkT1O4QF9mJTE4x7Pmi/jesENtnDNQFVIeJqBQuzXap8/84haWHdw0JQg2w6ubtrotom
	 sHCnqlUhbtzBUBRm2xVCR50ve/wxlCZO0HgOEPXP22dFB+RUgtOpugSxFjDTbIaNWWfOQ
	 dK8BAaZNiZ7NK/NaQB09vdXdtzE/4f9FJZsMiXoDEe1X1LfGJ8f0BycRm2jQr+tnXRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UG3fnc4L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDEB606A320;
	Wed, 18 Nov 2026 22:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UG3fnc4L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55F61F000C4;
	Wed, 18 Nov 2026 22:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040601;
	bh=aTiqHigKgOc/Krwsi6gZF81YJryd+5H1rd3ozAgR2FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UG3fnc4LOb4moG67aZbiZYQrQ939LZv8aI0ooJf6z3CXmzp/PYFGnCudU1pMQFVmL
	 N96nCl8Ng8sPnwYQ3a1F+cxufIoEazlXILjP/w/x/14nhPaPO2vr5xHl1EzUEnqUDR
	 0yETqve0fiyq8/S/BLdkRqk5GYs0YoV35LJbtmuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2515/3318] ALSA: ump: Avoid dereference with max_src_size=0
Date: Wed, 18 Nov 2026 15:52:17 +0100
Message-ID: <20261118150436.828948995@linuxfoundation.org>
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
index 70c74207b6c0f..14085bbb16034 100644
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



