Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024957;
	b=CyNja8Tv8ubvdShhlmXAziJn2Hu/FHFXxzAQMCsyYj8r8GA9QyY5d6UxyUqu1kErNdPl
	 g++HZsfHWFx1iFpweTR9N94uL6mxy2kHi40WVLJ0jt5rR4GhB811JoLDEw1SNrc40c3KD
	 qYnUXxqJhqQe3Xg67tExszz3rG+AcjvOkvCXDXsQ9QBAxm5yyTDZozi+hoQdPjzq9JuFt
	 xB8CAO5/75IE/J2VNlPpXLSrTSzf5MRwy7uwJikV7ZhtalikV8HAWiFxdQuYGCnPDTvr2
	 hUP1OUFnkk5N/xg7O8AkTAZwn8aUECGDUJ7Voz/ciLrz0AbhHxL+4TWgyP3U+Vj8+bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+knSToivuwywsvfffz48aRBzryBOtixkAWgD+OcOTgc=;
	b=XAH2bYwpd+7t3jQ55XRclKBNMnBaV+7mh4vk2kTPhUYkRxGD60vcwmcLUWXKfmji0otH
	 IbelBPxZifRB0usfiweu1W3ZyIVYCNva0+oxOALPGuAkW1ZJmL0rESO3+gYK7fo4Ih/Bs
	 S2nhmWm1a+FoxnMCr/gp5Yjmqa/K1yafg+PI6uvlsjepXtASbT7JXUjtMIrRy+f/Iglj3
	 BIYuu0pcP8wUpH4bFO2l59cArMXxaGJq3NppsBQ5/AGMGqDhzPfnGn9yNQeatTruXjjHo
	 sP8L0rFEAvKfCiLPm+FrkeZJD1L9VTWFhet/pcf7bgIibbjYu7qVpGOCQ8eNUFmPgBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vsdGMpoD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE496606A32F;
	Wed, 18 Nov 2026 18:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vsdGMpoD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5DE1F000C4;
	Wed, 18 Nov 2026 18:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024957;
	bh=+knSToivuwywsvfffz48aRBzryBOtixkAWgD+OcOTgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vsdGMpoD2P3lSHgosbXX4n6y2iLS3fmFCdxWWXSNLK2Nm/Bxko9bHB3YVoy7uQ0L+
	 HeQR1bZWOS0Tb6/vR7AQWGuiL7UakNOfu+PxG5TqXDqgMLQDg5y045GrTDtqWqBDeP
	 LdPxP8oh1pggSZaa/xkglb/WUFwM0k9Yr4t94U18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0907/2151] tools/nolibc: check for overflow in malloc()
Date: Wed, 18 Nov 2026 15:44:02 +0100
Message-ID: <20261118150155.394985885@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit 2111eb4273e7fda0815de85319653104f323c441 ]

malloc() adds the size of its header to the requested size without
checking for overflow. For a size within the header size of SIZE_MAX,
the sum wraps around to a few bytes, and malloc() returns a single page
instead of NULL.

calloc() checks its multiplication for overflow, but then passes the
product to malloc(), so calloc(SIZE_MAX, 1) returns a single page too.
So does realloc(ptr, SIZE_MAX).

Such a size is usually a bug in the caller, for instance a length of -1
used as a size_t, and returning a page instead of NULL can turn it into
a heap overflow.

Fail with ENOMEM when adding the header overflows, as glibc does for
sizes this large.

Fixes: 0e0ff638400b ("tools/nolibc/stdlib: Implement `malloc()`, `calloc()`, `realloc()` and `free()`")
Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Link: https://patch.msgid.link/20260926152414.251214-3-danishkhateeb03@gmail.com
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/stdlib.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/include/nolibc/stdlib.h b/tools/include/nolibc/stdlib.h
index 98714f754f6ed..4e129a8fcf0a7 100644
--- a/tools/include/nolibc/stdlib.h
+++ b/tools/include/nolibc/stdlib.h
@@ -128,7 +128,11 @@ void *malloc(size_t len)
 {
 	struct nolibc_heap *heap;
 
-	len  = sizeof(*heap) + len;
+	if (__builtin_expect(__builtin_add_overflow(len, sizeof(*heap), &len), 0)) {
+		SET_ERRNO(ENOMEM);
+		return NULL;
+	}
+
 	heap = mmap(NULL, len, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE,
 		    -1, 0);
 	if (__builtin_expect(heap == MAP_FAILED, 0))
-- 
2.53.0



