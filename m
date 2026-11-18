Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030473;
	b=XivB3vDfdlLjLv3la5Q9D2vukTBijm04WIH/qQctdqqkpyD4j3T8unEYuHpilbY6WgGX
	 n6GCvfxzW6wsuQeoU1eHvo75qtg3taQdLfKMNVGf1XHccaKuDwAlsDoFaBM8WKYLGQeUp
	 JSlEn7WNggohPLYgTNXiZZH3Dw9cBI5H91qErG38VR7ShKKR6yU1I9z/tudvojWFRpH6Q
	 R7o/wg9pnz8o7hqAACCUcVXUqyL9Tz/lXwyuVeT3R6vA0c6GTVECbKJCMa0la5R4ju22C
	 0+fFYKP8qYHve6sbEbGbSbe6jID+Yv+6MvW3rhj/0dwLUM/gMxjA4++r0Mm09vCuYYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=54cnjLTeUU0hiTgoQqgLob2Ots/eFY3r3spWXxUAbbM=;
	b=UYAx8lu9wVHdRhk9Jz13Aw/YyYNCjwKdWpae02fS3C8uyBEUTZ465Bj/L3OwOKDRiRHR
	 OwwdJNYkaBQEXLcXL16NMbJckCINAS7FB79c5tculahw9bIS2egzGyiC4KiMJBZrJqSii
	 99lUNhznJHAH/qvn1jMRFwF4ymsibS8kOogZ5zl69k5UiUkRdmiln4Tfv8o+CqJdSSK6U
	 ajyxBsiNYIME/tUaxi3F6YfPqa/3RhhTzxJ1czY/qCnrHz0bN0DhvlBauu2aXtnh4RbQB
	 dlxdZY0usSw5LK18rz7TTqyMgg6SufSZKv5+4BjJZj2iRkzFFfNVc6AvVxxzzRbNSMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="unq8Cv3/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5951606BB43;
	Wed, 18 Nov 2026 19:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=unq8Cv3/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FE21F000C5;
	Wed, 18 Nov 2026 19:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030473;
	bh=54cnjLTeUU0hiTgoQqgLob2Ots/eFY3r3spWXxUAbbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=unq8Cv3/GTnO51tWvWzdv26BK0QmGYZIFUYciNS3tptIhNgjy2H+H263EQriINIS4
	 tnUxJuBM+NAG4daMn5BvogkzlaBj8Er1VndW+KhER6fZ1yfT70vmVH1pUOAkzVD52D
	 N3LKvo6l3FV7iMNigmODKjEMkKKKelKbbSPLRGVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0717/1756] tools/nolibc: check for overflow in malloc()
Date: Wed, 18 Nov 2026 15:47:24 +0100
Message-ID: <20261118150038.106073175@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4c2da9731b1e7..577cd2966f093 100644
--- a/tools/include/nolibc/stdlib.h
+++ b/tools/include/nolibc/stdlib.h
@@ -132,7 +132,11 @@ void *malloc(size_t len)
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



