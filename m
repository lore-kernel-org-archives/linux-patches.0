Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048871;
	b=mxbzjWVzLiLAk2qzaNC+l7ji3QD+YYFuQSps++x94I8XHdieX9a+3o6KT9rzZDUR7V6F
	 XIBKtZkMA1J+GIy6TssDej46lT83v0ySAGExyr/O8yGHKEQcPZEYIa0pDfwVEK6zCjqs+
	 gg/AJRYtRAH87JbqmV6tzgYATbFNLx0F+itguCO7oUtxmZ/3hsjbMZG0MkO5Q8Ftt/7+M
	 VqOU21WuixAuYxXtSAhA+nLVotpqB9Dw51bRZG7tlEY9DjZd0stK7X2/gKjIT71b65xTC
	 rTUVMH3Q77wr1xmunL/Ttn09nh6TET1tTS5lfFNMXWmBCLMXrPFBbBus89DOSsJAG8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048871;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ZNw0gbli3/KuYw0OeExPSUTp8cVeQdAjueD/VqiMJqU=;
	b=MSTgVrPYK1CxsS1GOioArQGPDRvt0GJbz2kaQrUezlrtARwLzJAbMgA9iY92jkb/wEJ0
	 NcadnqXK0X81LC+Kw2mSSO6MrFlqNjpcR48yVpifpUzMWq8ZGmHYxZKvsH8TOqyUT/pgk
	 4tJGgIJJN9nDoxVcUJU5x72Cm2KJ+gWEBbVeApoKA+X3bsbVm8HICoQcogKtERbQqvDOZ
	 y6faHgTXh27jt0CcFxnWmzMPyigUVVVaAEOAhzgib+iz9C2S+y5Zh23TUxW79MMZ9gt3v
	 XZ3f15vPAJ9+yKPQY9rNP8n6IjtcywmsVmEPjLMeY8En3XWdiB59NMMFpmoRkvtQTqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YRXQCSyo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85EB606A325;
	Thu, 19 Nov 2026 00:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YRXQCSyo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85BD1F000C4;
	Thu, 19 Nov 2026 00:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048871;
	bh=ZNw0gbli3/KuYw0OeExPSUTp8cVeQdAjueD/VqiMJqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YRXQCSyo9ZcsK7TPtPPv1HAPuP2UjTc0GuMMHfqOhroKVfu2Ev4L3qfgUcxq35c9Q
	 5YWWmfq+1isO8Rd1PZrB4tl31BBJnbJzJufo0+h4AQ3PigsqcICHXIdnLg7pCfAwHz
	 f0eNePnSFfBqjUIqbMufrfD2+acfKkra2A2j3uss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2148/2857] tools/nolibc: check for overflow in malloc()
Date: Wed, 18 Nov 2026 15:53:02 +0100
Message-ID: <20261118150318.734406511@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 059af4207c93c..10ce2ce39acd7 100644
--- a/tools/include/nolibc/stdlib.h
+++ b/tools/include/nolibc/stdlib.h
@@ -113,7 +113,11 @@ void *malloc(size_t len)
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



