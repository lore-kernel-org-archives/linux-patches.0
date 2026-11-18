Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024955;
	b=rGyyd5VyK9id0VqoeDNryvbCVez/equcg4Uxrm7Od2ILyFbdh5/pmS6kEHLf6eS/GBXR
	 FwdnEirzaKuta1FCHRDMCrncGWd6HqwFZB7kxr/h2lZ44cHzMKC0dfe24HYRclIk1Hfye
	 tcdNtDfOZ6Uuoh+jc3cnxgAZ3+eOOS2stHW/w17ZFJt6+rl0UG8ApmBqODeq/jIdAnXnd
	 01BDjNpvpB8Lee8UGUHIN6M5BLn2zqF+PRhGA3jYAv8a+fnC71INsr6oXep3x7ZAplv2C
	 y849iT8fbFa84vNT8amvWyD+9oeH1zgh3xFf9yxCVCh7NnYbFP+kbLKvsMwjx+GQ1TQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=p6E8ZA2daOVXZvZkCOl3J1Z51/+2KLkE679ZY/M0LUw=;
	b=Tc8J6kyN3GnlYYfr90Vg4UyQ6Q5SavpHDnkEC8ZW6UUNeAQydGsdgslg+Tf+7hpfSlj/
	 +K29pgk+pFaHsRuaoHTxJBuLn4/pkv6avGTfp7J/HY0hfN+JLqOm3XdibPUZRMV7bPUGb
	 2Yvq9gOIhiCu68yjOWbvILKZuIGLTROAAXkhhLtI2K4NL8ABq0gB6ty1Ij1f+rJgGfMxS
	 eZt0gZ8K1HHrKOvV5DEzKL4neTiwfedLjAKjgP3ay9CVeC61XZrfhjMEdP2WZ1gDJkaPH
	 S5obUnL5BMV151dx8nC4q7kAhx63PGgEnQ1kgk+3gC3I/Fwz2BaywT+Fi7lKUBpgofQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AeZZB2X5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66363606A330;
	Wed, 18 Nov 2026 18:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AeZZB2X5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846271F000C4;
	Wed, 18 Nov 2026 18:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024955;
	bh=p6E8ZA2daOVXZvZkCOl3J1Z51/+2KLkE679ZY/M0LUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AeZZB2X5Pyh43akMJZdldv2BMAEaGT7NzawEbCSZTfMYur0iuAOzv4Yxy259LLQnw
	 fENSHj8o9jI7DBQeM8vPBc8mCFfwCOHJKjNMuSYHOSd+KgmHmpVWKjUIs6ch7x5FPY
	 yRnxrVkPKwRnAmkul76uctQNVk0mZ1xJBQR/UlG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0906/2151] tools/nolibc: stop rounding malloc() sizes up to 4096 bytes
Date: Wed, 18 Nov 2026 15:44:01 +0100
Message-ID: <20261118150155.332008578@linuxfoundation.org>
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
index 5fd99a480f821..98714f754f6ed 100644
--- a/tools/include/nolibc/stdlib.h
+++ b/tools/include/nolibc/stdlib.h
@@ -128,9 +128,7 @@ void *malloc(size_t len)
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



