Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017979;
	b=uQ1wgNt0fBT0Wkxu8/E3Q7IxD0bitdESnq1rI1N+n7I2Y7nCFe/Iu6snkOwBwUO+jf4F
	 jOmn6gA2/lO4o5JeCGde++0XhUUF6ZU9piyccKfztzUjiC3BFYm1fZe3d6kHNuAvG6Eo1
	 BYppcJuJGvt+ICCrSCo3+9KLbeb3kCL+A/hktBcbXEvSjQNYfQVu3Z9Cc8cgjKpApTa44
	 Pia2krkq963lQiZOei0dDcbtckmas3VVsoVb3Ojg62nwLrMtaHG2WtMGy+uNyGQk6oFnP
	 QsIT0dHHTbklzLhv39ZPesgZ4Un+tZXxIr+4xeHj3/w6j73Xpq9TVIA14WZxEXpPCKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017979;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=37h6CYcfVma33ho2vuTjbfnEizJ6N9adnsE75IoM7sI=;
	b=5O2paBlsc4OZetVHZicV+X9KLoMmGij355udaWSvLWxppHLr13DVXhkDbX396l/UMZ8e
	 mPQtS6yF/YD6apZ7oUwYDeu96a69lH4jiaITkuygvOc1aYzZdUEpAJ6Bqqu2YIKGOAdud
	 8ahPXZYcQ+NGIrhA2Qz+f/qJXB0BG3F8eeU4mWlKUDP1DRH6jcjG585lwe5Ddh7d0xC9d
	 q6XgCgp7pS1kQS5hdkOlYQVeEhqS1rKG6jAOUdIuYqTc0YN1eQslDOQ+2kWMJXPZOB1fv
	 G0xVfeJ2/illFpyQxobD0u2CUCpqBz9eHwh2iJl73a9Kouk8bRLlqRo6h/LlUyXjV/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aPiSZ4Ah;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169F7606A31C;
	Wed, 18 Nov 2026 16:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aPiSZ4Ah
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571AD1F000C4;
	Wed, 18 Nov 2026 16:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017978;
	bh=37h6CYcfVma33ho2vuTjbfnEizJ6N9adnsE75IoM7sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aPiSZ4Ahz+LBZI7FchlbKHEMvO1KV+EKkRGnrBRnHBUf05AYl3QBz6dgZim54kCmF
	 TUKL5b8korHMqoF0kUmcDs0rDM1CPDPt+aoTGXHPaYKTpjvcJX+J4TicDmw7tRjxA0
	 WyS08E/OfybUg/Eb3NtQACQy4sbuwmTp8lV4DgM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1076/2651] tools/nolibc: check for overflow in malloc()
Date: Wed, 18 Nov 2026 15:38:36 +0100
Message-ID: <20261118150326.730796147@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 9dc23dcf2c855..e14d054c7a1a9 100644
--- a/tools/include/nolibc/stdlib.h
+++ b/tools/include/nolibc/stdlib.h
@@ -130,7 +130,11 @@ void *malloc(size_t len)
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



