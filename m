Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040494;
	b=shFKwMzuO0ZoV2eKjymxq9zKnx2HaLJQv6+g9sjrrMDPJKHryywp1d8/Gdbr0E3ZE2nQ
	 rY2Ty6pSvHToLabwg4w70suAt3MJov/b/GOns9VeLqwt6v5Hvm57tu1XyIza8FOhluUZ3
	 neDjAtO4i6YycsAq7RbjF0UzwVyGzcvNM6KChGNV8ItRH5MjzB78/Sl1E5m5jLwYnn2v2
	 sRNfeoG9H0B1ax9aWmDJJkrPGZurUUmigZx5Rif90WpNXkM3gZwWbKE72g4VY/jsuYcjX
	 1cCe6PE1s72HaPDobVYo67+z78GEfOD9DaDFdDmSV+EyTR9YPVsEcu+U0lsz1cmeW1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040494;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nQNZ7ePYHLoLH00WvC5XLeJlbqHJBS1jz19zNtMYkm4=;
	b=5DR0Uu2TV1KSYMLZASviGpPhhzJzrstsvpmkjESliuwlvbHWA8Hgb/BXCSAk94d+0yWH
	 9a8vagWF9SfjGo36OSLLepoEdsGPe93/6iq0YcwSS7YiFQrDMRJZeVpleBhZIH8HTPN2N
	 oO/TkZ+K6+whDGgyje2Q7bgHF2mbjzYuQK4czr7rxeXKU5CUt/zsnrPU0hXjFuFpeoFGE
	 8M8Bxo0pwVCAg8oLm7jL8bBXzEUiJ6XuFBSFzX/mSvyTL9TbzuPhiD8JwZFtiFBGDaY9n
	 rC3PG5IMLcXHpXwBnWSCXfaxD6mF6xEkbAoErgWgRJdhx9a2njVqYMRLh97XvHl9aBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="XCk/Fo3s";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFDB606A325;
	Wed, 18 Nov 2026 22:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XCk/Fo3s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2451F000C4;
	Wed, 18 Nov 2026 22:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040494;
	bh=nQNZ7ePYHLoLH00WvC5XLeJlbqHJBS1jz19zNtMYkm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XCk/Fo3seSP4FHAsbbQamfujyM+d9z7EPbpXLP3zLLh9lrod53KbJeRFLT8UZRHfP
	 oK2DEfINwm8oV3PXkxApYq/5rBM0dnXJBaJ97N3DDvp9suTzr/BbtPIFhEPgibiiEx
	 zPpMXHkl683hBeLoFUgTBAR8JbrI0qVFkYpWJpKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2476/3318] tools/nolibc: stop rounding malloc() sizes up to 4096 bytes
Date: Wed, 18 Nov 2026 15:51:38 +0100
Message-ID: <20261118150435.685216820@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit b7db3ba9434cbad3d15f62500104525bfa28a304 ]

malloc() rounds the size of each mapping up to a multiple of 4096,
presumably to align it to a page boundary. But the page size is not 4096
on all architectures, and mmap() and munmap() round the length up to the
page size themselves.

Drop the rounding. As heap->len is no longer rounded up, growing a block
with realloc() now always creates a new mapping.

Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Reviewed-by: Willy Tarreau <w@1wt.eu>
Link: https://patch.msgid.link/20260926152414.251214-2-danishkhateeb03@gmail.com
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Stable-dep-of: 2111eb4273e7 ("tools/nolibc: check for overflow in malloc()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/stdlib.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/include/nolibc/stdlib.h b/tools/include/nolibc/stdlib.h
index 5be9d3c7435a8..5393f001267dc 100644
--- a/tools/include/nolibc/stdlib.h
+++ b/tools/include/nolibc/stdlib.h
@@ -132,9 +132,7 @@ void *malloc(size_t len)
 {
 	struct nolibc_heap *heap;
 
-	/* Always allocate memory with size multiple of 4096. */
 	len  = sizeof(*heap) + len;
-	len  = (len + 4095UL) & -4096UL;
 	heap = mmap(NULL, len, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE,
 		    -1, 0);
 	if (__builtin_expect(heap == MAP_FAILED, 0))
-- 
2.53.0



