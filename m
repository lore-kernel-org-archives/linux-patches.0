Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026796;
	b=ssnJULiAeKHgr317Cl2aGUihaYgXPTWM/O1jzasJOj7X/1HnyJzfQ0EgxYl1x72hdX6x
	 vFXLztjPPoDmtGDDRxwYFC+wGlocRZUoZttDctgbKSCiAE56cELFebsnFlES8yWGeXVR9
	 s80/PscmiDjwmU2sU6+sYmdbwE7LBFKB51uqZheX9N/HP7SSsGciMAvRakYKgZMUR1UYx
	 gLgb9OKjwoymGGOvWe5DAIorD27jIrjmoVNF5/cyyaqqxmqsI7giEKf77552CNulkCRFs
	 wIpPQ5z+p9/kZW7CAVDgS1/C8pwZP01K8B0xjY7fIR3x+mCPSJenuDMGcbQqbkOzASw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=4FD4rbvZNpyDs6V72x7g2fU5/z1nmqDeobl7+UdpGRE=;
	b=sANRHqPyaVdkUAZNAlyVJyx1+lk14/wzGiflkY64hc+FXp/NdAoD6D4eLjNeeYVd2dMc
	 +FS3g/0w/4qBqmnDT/jvx3BlWDpKwNl6QL0VaboDwiVeUM3LKbE5/h5JFS5wTCYA1y259
	 FM/egvKCTNZqX2g0lZmh3E56MFsIdUtOyehoCrQNZSSFiC+pPKVfvSk9hDVgAAsaWsvj8
	 37RPC0X2EfEA2LjYjBeQ0I30flBZsLxjmLv9m9qaMPnMaCLjjV6Cqx0sZMjXtLqbset2F
	 wf4EFHmjeSTvWF+gKr6r6ungvSNzdTMF/3SdlszMtK05x32xuc7uKiii74Ue4IzshYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GAZFlSqP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145CE606A31C;
	Wed, 18 Nov 2026 18:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GAZFlSqP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D56C1F000C4;
	Wed, 18 Nov 2026 18:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026795;
	bh=4FD4rbvZNpyDs6V72x7g2fU5/z1nmqDeobl7+UdpGRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GAZFlSqPJ8oT32twCkI5q8cIvOLzf6SLcmbXU2jWLtAssFNBZ6ZM272NjD83duhQw
	 hXeviY1xgLyS1DKi/zv+dhJcktUO8rqnmvzgQvwt456HGhNm4wH1TqPS5ApICkY0rR
	 PGp26MqrFGMiyqd5N3uGGrMUjxrjd0HIRpNUIQuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1555/2151] selftests/nolibc: scope custom flags to the nolibc-test target
Date: Wed, 18 Nov 2026 15:54:50 +0100
Message-ID: <20261118150218.539524612@linuxfoundation.org>
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

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 20c72de1f8a9e338531579bd784371aba4b7dd2c ]

A new target for 'libc-test' is going to be added which should not be
affected by these options.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Acked-by: Willy Tarreau <w@1wt.eu>
Link: https://patch.msgid.link/20260106-nolibc-selftests-v1-2-f82101c2c505@weissschuh.net
Stable-dep-of: f9532b372e41 ("selftests/nolibc: use the configured kernel header directory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/nolibc/Makefile | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/nolibc/Makefile b/tools/testing/selftests/nolibc/Makefile
index 40f5c2908ddae..43f0b608c7960 100644
--- a/tools/testing/selftests/nolibc/Makefile
+++ b/tools/testing/selftests/nolibc/Makefile
@@ -9,14 +9,10 @@ cc-option = $(call __cc-option, $(CC),,$(1),$(2))
 
 include Makefile.include
 
-CFLAGS = -nostdlib -nostdinc -static \
+$(OUTPUT)/nolibc-test: CFLAGS = -nostdlib -nostdinc -static \
 	 -isystem $(top_srcdir)/tools/include/nolibc -isystem $(top_srcdir)/usr/include \
 	 $(CFLAGS_NOLIBC_TEST)
-
-ifeq ($(LLVM),)
-LDLIBS := -lgcc
-endif
-
+$(OUTPUT)/nolibc-test: LDLIBS = $(if $(LLVM),,-lgcc)
 $(OUTPUT)/nolibc-test: nolibc-test.c nolibc-test-linkage.c | headers
 
 help:
-- 
2.53.0



