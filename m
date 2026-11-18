Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026827;
	b=MbHbkzWC9gzMEEsOHYpi8VfGMATfC2WnteeEMkIdkn33C68PS2Ca1J5ywRk5cqV/rId9
	 nF8hyQjf73oujjhBsc5XsbkhLmvQsXWsSQqq3+mFLlhKGDO4fYvDBnSOfFVXlwplZ0YjK
	 dVbv3xNFeaMdZtUhBu5pVpNW3l1RNMp52JXWu8x9+V6+E2YS3j1+PAWblpe0q7IeXD3yH
	 lcFv9UXM6sjlI+REhwfMxTeSd+ktnrpRVRnvuBYMiNDr7ATa02HvP3CVOgCOji6bn20aw
	 qYT8ptxUYlrFrqMeJq6YMNCODA84XEwjiws01C+mP2vcoBIVhKkD4FioHs9GveKxRLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=KWIP5l1Q5jULetmQ5bY2atIOFkIT8SzjDFX/5husaak=;
	b=H1qBgzvxLIUz/5moKI/2OvfB0EQb93udIfQadz8CmHmzpSE58/FbUwUkpeYGX+wnhc6Y
	 SNyBKPeVA5uYwed3Yyg5mMH91zmgPqpNW8RHvXhp7EKqlXRIPyJjSZ31WYhJ99HIhcbfG
	 4xVhX01nEA2Q0ewoMVXCkWwM054Icrb+d2CdDYy7PxXevhI+qqvO49G5UukYbWLk2bGiF
	 fGFIBMzGaX0TBZyHhKamhktXvsG5t7ufAw3vPc9NuZ1BPLN2XRxCCZawwcG8IOfIW6y+5
	 aHH38SjB7MRodIf6TYIdI4eS9hoSg2xOGVz4JoaVpv6xIP1l58r+iTsoJLvlpPwnOxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I6rUk2pD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644CB60A2606;
	Wed, 18 Nov 2026 18:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I6rUk2pD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 961631F000C4;
	Wed, 18 Nov 2026 18:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026827;
	bh=KWIP5l1Q5jULetmQ5bY2atIOFkIT8SzjDFX/5husaak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I6rUk2pD5ZDUaTMHzsVO0UiMOhLLk8yqwU8qdRFa1ImBW8XMJMpI98Y3T+2olN6Bl
	 4jPR1tfwu+lYtRMBMxNJKalbW5OdfM5NdZXuNu7wo+Wxa45g0fBCQ9MBoYoxt6gvPa
	 2GCEUgetY6Nu+xuIGeeyYGqIeDi0DdFQJERXTxFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
Subject: [PATCH 6.18 1556/2151] selftests/nolibc: use the configured kernel header directory
Date: Wed, 18 Nov 2026 15:54:51 +0100
Message-ID: <20261118150218.576465304@linuxfoundation.org>
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

[ Upstream commit f9532b372e415e8198287ce010efa22f337857b5 ]

The freestanding build hardcodes the source tree's usr/include even when
selftests exports KHDR_INCLUDES for an output-directory build. Use the
exported header location while preserving -nostdlib, -nostdinc and static
linkage. GCC 14 and Clang 21 builds then find the generated UAPI headers.

Fixes: eb1353110831 ("selftests/nolibc: integrate with kselftests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Link: https://patch.msgid.link/20261014200142.1364761-1-sashal@kernel.org
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/nolibc/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/nolibc/Makefile b/tools/testing/selftests/nolibc/Makefile
index 43f0b608c7960..e3c66f568ddca 100644
--- a/tools/testing/selftests/nolibc/Makefile
+++ b/tools/testing/selftests/nolibc/Makefile
@@ -10,7 +10,7 @@ cc-option = $(call __cc-option, $(CC),,$(1),$(2))
 include Makefile.include
 
 $(OUTPUT)/nolibc-test: CFLAGS = -nostdlib -nostdinc -static \
-	 -isystem $(top_srcdir)/tools/include/nolibc -isystem $(top_srcdir)/usr/include \
+	 -isystem $(top_srcdir)/tools/include/nolibc $(KHDR_INCLUDES) \
 	 $(CFLAGS_NOLIBC_TEST)
 $(OUTPUT)/nolibc-test: LDLIBS = $(if $(LLVM),,-lgcc)
 $(OUTPUT)/nolibc-test: nolibc-test.c nolibc-test-linkage.c | headers
-- 
2.53.0



