Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017976;
	b=H2R9Mashc1cGSpQwFb0K1N3aDJ3H3z4SNIv9XPV2R9LyNNkTzA29UnDdXgDjL9y0vgKQ
	 XBZnR+/BHVKm2FJq1/XWwjH78uUccpL3LQZ9RTWR6s6FbYjGObvsNDJJWjbejwNnCh3fp
	 mVINYNL2ljzaoQuvEd4cin4iIaC2jeiWwb/C8oYgBNyn9+8Qwc9BTWyIG5O727OohdRvK
	 cFnOFlLKaqgeM0vFVrlW30LHmlM4p1t1yd/B4PnzWRvykoNZpr+gbkxyEoykUhIC8TMUZ
	 LIQ7fISZG2y7PlpR7NnTAe8lJ2l23ilI8ZIHiJgHAszcbjdJnG9ebp2I53tremWjhGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4y7gYhBRHKmsT+7vtMZnaWL5r+xiF8DZkdR53IGNRp8=;
	b=B8okepzG/zRFO7LAcOV4TLJSEdl10X/LPPN+7FhD4M0wOspKZGKzvQMTIqWCylakaQ4h
	 aazFlYLG8uhNB0m5T6O7X3MKWjBW7nRngMIQUiMjdJdBsSr77pucyb8q2rmH/1FTDG4Cq
	 RfSLlNcE6jCerZg2v97rSLkvuKxNIED8rLdO4oyFjtYncbM29ca6t1tiliEYyO6hTAK/u
	 TV93i0/v7fu80GNEW8sOhT4qb08IJuPzA0AOt5ghOd1ibddjot75bik2SLNDt7vBLNygT
	 QJlszqqDXhQpNU7OHcWRNhi3/qOHOMtzFCfh249CZkInI6ehE08WeMzexfMfQxoIIeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HF80zNU0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB91606A31C;
	Wed, 18 Nov 2026 16:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HF80zNU0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F081F000C4;
	Wed, 18 Nov 2026 16:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017976;
	bh=4y7gYhBRHKmsT+7vtMZnaWL5r+xiF8DZkdR53IGNRp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HF80zNU0Xbao90f82ZqAD/kFktUOK0LSlBMyQ9pOebpDIKLg5W9ulEOhwkxxnw7nP
	 Kd7Xee1VweCY0BDWzi1N/Mz9+5C4/uCl+4Vwg8lAbiLoSM2ZnwnGD367Z9Foeq1Lcw
	 wxDmjpBgh0oDmadbS5ZymFuGOsdNXRKCP7Vttr60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	Willy Tarreau <w@1wt.eu>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1075/2651] tools/nolibc: stop rounding malloc() sizes up to 4096 bytes
Date: Wed, 18 Nov 2026 15:38:35 +0100
Message-ID: <20261118150326.691912151@linuxfoundation.org>
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
index 1816c2368b680..9dc23dcf2c855 100644
--- a/tools/include/nolibc/stdlib.h
+++ b/tools/include/nolibc/stdlib.h
@@ -130,9 +130,7 @@ void *malloc(size_t len)
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



