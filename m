Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018207;
	b=pzSFcmfY+HJWD7lsmHvC5vecXPLad4tI87mtWIK0zMjqp/SFPZ9wmfPRl2GUxGgASqBx
	 R+S3Jj9ElNcJJzRSvyOBQqTDiQXb0RDFDJgnsBgiy1r5ih3/o8lGHHK4ylg75xmzQJnhH
	 pg8ks/3Nj3D2kCXlyXBsWdAeRfnln6XwhSsftm3IsYBckHXDv5ENd5tRy/5nuG2mXYFWm
	 oEwow+TMeJjeWSb8YogZUoFBdd4OQIfmnY8IIUG5ZGFsNSyzLb2l+iJpQ25CyhWaYZEo9
	 EJuVmT4qt3v/Kou6CaSHh8Y8d9vGOylC58bMMU82trnLF7ZISN4Yo5bHnSFThvdz4bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8njh4r8PgfDpDsWHiDrEQmmopratthVkHIv3cRdaD64=;
	b=W1jRFe1ihWed2Gh52YF3nY7GzNl5s9tJjWqMpokFbXQ3LRqb5SaSO6OLyWq+4A8yLCkc
	 FUQ5yTXhU1I/egIPRBjmfwEqE26dzjJTU7iuu+uBp1lHmbAja4MwZZECvysQBC0CPugJh
	 LLB3V2uKzUotdQJNjpKZHJBf2dz3Scw02Ei8HfErAXy0Z8sWJwDF/21W7E60iHJ8xFn2A
	 efdsICPIO8JSkzrdlYZ6HOSKu4d2I52rwoe6fKkU99YV/2acL22Yw3Q9xd1HwPM08G5kP
	 DXyNCByWltBgS9wRJljELmn9n2RAZLXRKcUkX5V+oXfpElEjIDtCmva4Lv/pVvPeptQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d2xVJpgO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C186F606A32A;
	Wed, 18 Nov 2026 16:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d2xVJpgO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C4DA1F000C9;
	Wed, 18 Nov 2026 16:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018207;
	bh=8njh4r8PgfDpDsWHiDrEQmmopratthVkHIv3cRdaD64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d2xVJpgOMJIjFIMhH3DEu71eRmALViLpzQ5fVuBf/fxyVlGjMztFDc4SomousLFaW
	 eGz/4pPnr2HDQLG8t9o2Lk+CJlS85dpZ7Qbye54gI40t28Vb0xaP5X939jUh1dzas7
	 PysZPH7g/4tCr7k+4DdRUz5wzMUJYAQAqdzqWPok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1158/2651] ALSA: ump: Avoid dereference with max_src_size=0
Date: Wed, 18 Nov 2026 15:39:58 +0100
Message-ID: <20261118150329.700166432@linuxfoundation.org>
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
index 3d1a2ed3b476d..f6482a9bfe614 100644
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



