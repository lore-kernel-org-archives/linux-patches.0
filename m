Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773953;
	b=EphmVRMZWoO/mGLyKT12MOKMus4U2jBnWKxuE7ekOWdWQDOpaHq7Jzh5x+lo3DS3nL65
	 tlSKuGeNm4hXNHRsmJ2X8k2WycsYLNQXGUePhpuDNkACVqMiu21jIed5TjyJ3AGhYLA9C
	 cT29HQcrLgaVrs3GLIgdHxxoohV4Ix3pZR0EpAFBzJ+UTaJPMVVok7J789BgmBK0A8pzq
	 L+a3orIPIUP9gRnQ/59IHVc6sTNdFSR6WrOoKTlAbJk3pFC8d+CyBBKuYf7ZwnGxIsjkM
	 KJ3R9nBEfbItU6nTsdHuya4W7BL5+JncZPnbdjM8jDGrGItCTwyx7qtl1YGNmv0g4/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773953;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x/zW75c5uVngOjQ8+AIRHl3QP0sULj3gqvXQMoJ17Fs=;
	b=F0GM1lzi9wbltjuFLq11DseBd4XEny0GvafFrWpDUt4QKC9el5sVMaCk9I10U1a+kCfe
	 x+Xz3n+5gQljTgl3styXNJ5DHC4n3YgUezKENhSFWrCRkutajZf+TTfxfj0jRkwKQwrT8
	 LdGEHVksNILZL4HJx7fuTgMHCgJQnGMifTMMcl+3+MnXVZSXtoAQy1H8xyFqtNlEUl4k/
	 pj4s8syUA0b55UwswX3RKVGiMlYhAaCqAHPM9kVBjkkSKEJj8Uyllm5NuZU1ont6xBVoO
	 jAleRX/UML4IZ0H1q8dmW09Bjs9TRDmBI1aBJQOSRIX9cWQ2uPGcQQH5U2mfdvoxqTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NiBfLb+1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19CC9606A31A;
	Fri, 23 Oct 2026 16:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NiBfLb+1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB8F1F031E1;
	Fri, 23 Oct 2026 16:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773953;
	bh=x/zW75c5uVngOjQ8+AIRHl3QP0sULj3gqvXQMoJ17Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NiBfLb+1sKRUXGXDXWMP4zNEvCwA54bmuv7bfKdeKBPWdxTluSj2C6V5O5hkvwFPw
	 IOb2oWPvL6dyk8ovEhYLlEyzoJUcwykj2bnSqqSYazRARTXWRs59MdiGpgdStlOkLw
	 bZYLlEeAUtOQauMy/GzPebM2DA4fZ49zNYsDZRSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.18 054/193] samples: pidfd: fix userprogs typo
Date: Fri, 23 Oct 2026 18:35:31 +0200
Message-ID: <20261023163715.483289933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit f1365f97fb7498d805981102eee22d362ae643f2 ]

The Makefile adds pidfd-metadata to "usertprogs-always-y", which kbuild
does not know, so the sample has not been built since the conversion to
userprogs, even with CONFIG_SAMPLE_PIDFD=y.

Fix the variable name. pidfd-metadata.c builds without warnings with
gcc and clang for x86_64 and arm64.

Fixes: 60fb0b1239719 ("samples: pidfd: build sample program for target architecture")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Link: https://patch.msgid.link/20261011223358.2327625-14-sashal@kernel.org
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/pidfd/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/pidfd/Makefile b/samples/pidfd/Makefile
index 9754e2d81f70d..d82409f7061f3 100644
--- a/samples/pidfd/Makefile
+++ b/samples/pidfd/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
-usertprogs-always-y += pidfd-metadata
+userprogs-always-y += pidfd-metadata
 
 userccflags += -I usr/include
-- 
2.53.0



