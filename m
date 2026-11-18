Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048865;
	b=w4LE69e4wnSzQz4UtLmXH+EgGrJLfo1/UWbzVlfkOQAd7RNoLqRzuptUNTtSEx0c/SoS
	 Fz6vQ2Gk+KhB1R5DbfNuBoxmAAp9yVNAuOtICtiE5451U/R6e1zoN1wg8RKrQ1BtQAzs9
	 dK2b2LQQdkkJrp4KPNuHR/adFkNuL0C5FSIAzK43mgKiQrq4kLVfwAGoNbNmC4yKkZ/Zo
	 Oola32nfd2IZfG9Czb7Csbdvub0KtfP9j9ND0IgRMxqgYMbUZHleBpfdz41Vr5TKaMW0M
	 LvDlflEw/k1tDGuj9/ME1TD4jTnhIhjhA/+85QbA1d+tivrdpvs8dGVn3gxLMivN78w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=UK8r3qfxlmR5Qf13ZbeeQM2kKpNfbuxtLtf/cO+kwoE=;
	b=DSqth7MUJ80o+zCxCQITm0w1PzrozoaTwqKxGSYZZ6Rj4Ri4uZmqVAUXAvuIuABG7KeJ
	 ndYAW+7wmMKqTPVvNQbwSjqG/WbCgz3giymtB1x3GAnYP7gvQADmfBebQeIjiMSUXfrfR
	 nt+InXdms4bd5iMnf3aNxtNuKGD3jCXRvnH73+GihPz8oXikFw+yhMaU8WWQdTopoFe4a
	 /I9le2KyhjvTMDfsSVizBk0NwERYNG/GZzJXc724LDW8h2T14CNvYunI5HT44UnsLJdGb
	 vC8YFEhZisbAyztvvd1wXt7CPUel0m+9yy5Teim7dGxRr/1bMi3VeyI/0vFG9zUM+mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FPKgNl6P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B290F606A320;
	Thu, 19 Nov 2026 00:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FPKgNl6P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F9941F000C4;
	Thu, 19 Nov 2026 00:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048865;
	bh=UK8r3qfxlmR5Qf13ZbeeQM2kKpNfbuxtLtf/cO+kwoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FPKgNl6PiImNoGxzBQRSQva/4YPH/KfO33a562Hm3cuWGYvgHCtGQtGS5gK0MYzHi
	 TjYG6ky7YfbHPfxFTLd3Ym+avAYubADu0O89oHL0o6rmCE0gbDeLxpM5VTpxhbF3rc
	 m/MHTYSI557FSUWTT/L5nQkMteOrKqZWu6gS5CbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2147/2857] tools/nolibc: stop rounding malloc() sizes up to 4096 bytes
Date: Wed, 18 Nov 2026 15:53:01 +0100
Message-ID: <20261118150318.701995489@linuxfoundation.org>
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
index c0c3854b3f35b..059af4207c93c 100644
--- a/tools/include/nolibc/stdlib.h
+++ b/tools/include/nolibc/stdlib.h
@@ -113,9 +113,7 @@ void *malloc(size_t len)
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



