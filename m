Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054960;
	b=H05ss0tqvRIMhFbQu0zXnNGaZB/2nf/BX/cTj33LtMN0JvmX8/QuTfbWzkh1NFKcV2ol
	 cxOQLejdCTQN9xnJx4GEv78LDWhqF1XaalHs7wa8krdqC7E9hRNfkPlyAQi8LKNVBP901
	 SX7mbjcPWdt7foo0FSDS+6/UVj7sApqsYJFoggW81PQIAJ6uzfef+v7tIWJfytRGgpmyr
	 EVvc10ELcDC9BWEnMX7jhUiosc+sUBRMLX9nkLkel1Zhonh5kUsrxsaTsvUJnk9CPy2Mu
	 nPe2R7NyqWQ+u1VfmI54dQRTNttTiOKOVbUSeXFL6f7imAuQuvqmjdyDhySOx8cvW3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054960;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=W0zERdNOVoXqfYrFewdQ0DngEsO6OJYX+ETOG/atbPA=;
	b=auVoI0yj7eW8MA57RbnF0adpDfknCkNWVCyXwVtNwWKpxTCk91NM4s9Ne99jSnHzpWN0
	 OjuplIqB0VoapzSU+piaKBkcRvTnt6lQa7qCxkUIzQWflBzD4VwE7Si6MHoUvi1RSYYkq
	 xxAjgaCeabGI0p+NGeTTA0WwfxcMcKkrgZINsjO+PcBs0B5r08fuWWRePkwYiHDMnoqc6
	 CLyvcTI+w33CKPQ4yd6GioywkBmbov1D8IH8Br6lIV2JB0kIZogh8ubYCmAH124lQH4S6
	 IT8Z8IlpHR1mIPYmKUUr5JS9SAMHhDkcCQl40zuUqHiSQmaftmnVea0zGTMPYhYedBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="R8/Etgl3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C09606A325;
	Thu, 19 Nov 2026 02:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R8/Etgl3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15161F000C4;
	Thu, 19 Nov 2026 02:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054960;
	bh=W0zERdNOVoXqfYrFewdQ0DngEsO6OJYX+ETOG/atbPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R8/Etgl3B4hrZwk/QAstdZwQba4u6FGvYrtY/BMJH+qlejqi9Vv2jEFLCh6XnLOR3
	 KXaT9RbvSOAkGvMtjHbQp0HUh0sVBU8LFupRYHPg84EeZMdoT2/1JfGJvu/TyC192A
	 Z68mw5kA7nxPfsP+lxywGWU8mfiC7YmbLMhLZUpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH 5.15 1459/2214] Kbuild: use -Wdeclaration-after-statement
Date: Wed, 18 Nov 2026 15:52:15 +0100
Message-ID: <20261118150109.428104618@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 4d94f910e79a349b00a4f8aab6f3ae87129d8c5a ]

The kernel is moving from using `-std=gnu89` to `-std=gnu11`, permitting
the use of additional C11 features such as for-loop initial declarations.

One contentious aspect of C99 is that it permits mixed declarations and
code, and for now at least, it seems preferable to enforce that
declarations must come first.

These warnings were already enabled in the kernel itself, but not
for KBUILD_USERCFLAGS or the compat VDSO on arch/arm64, which uses
a separate set of CFLAGS.

This patch fixes an existing violation in modpost.c, which is not
reported because of the missing flag in KBUILD_USERCFLAGS:

| scripts/mod/modpost.c: In function ‘match’:
| scripts/mod/modpost.c:837:3: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
|   837 |   const char *endp = p + strlen(p) - 1;
|       |   ^~~~~

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
[arnd: don't add a duplicate flag to the default set, update changelog]
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com> # LLVM/Clang v13.0.0 (x86-64)
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Stable-dep-of: e6b49f8016ee ("dmaengine: dw-axi-dmac: Fix LLI dump out-of-bounds access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile                          | 3 ++-
 arch/arm64/kernel/vdso32/Makefile | 1 +
 scripts/mod/modpost.c             | 4 +++-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 215bf5d254d37..5a3fb7729baaf 100644
--- a/Makefile
+++ b/Makefile
@@ -440,7 +440,8 @@ endif
 HOSTPKG_CONFIG	= pkg-config
 
 export KBUILD_USERCFLAGS := -Wall -Wmissing-prototypes -Wstrict-prototypes \
-			      -O2 -fomit-frame-pointer -std=gnu89
+			      -O2 -fomit-frame-pointer -std=gnu89 \
+			      -Wdeclaration-after-statement
 export KBUILD_USERLDFLAGS :=
 
 KBUILD_HOSTCFLAGS   := $(KBUILD_USERCFLAGS) $(HOST_LFS_CFLAGS) $(HOSTCFLAGS)
diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vdso32/Makefile
index 83e9399e38368..50cb1ec092ae5 100644
--- a/arch/arm64/kernel/vdso32/Makefile
+++ b/arch/arm64/kernel/vdso32/Makefile
@@ -76,6 +76,7 @@ VDSO_CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs \
                -fno-strict-aliasing -fno-common \
                -Werror-implicit-function-declaration \
                -Wno-format-security \
+               -Wdeclaration-after-statement \
                -std=gnu89
 VDSO_CFLAGS  += -O2
 # Some useful compiler-dependent flags from top-level Makefile
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index c846928c2a74e..6aa50e7e05d82 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -837,8 +837,10 @@ static int match(const char *sym, const char * const pat[])
 {
 	const char *p;
 	while (*pat) {
+		const char *endp;
+
 		p = *pat++;
-		const char *endp = p + strlen(p) - 1;
+		endp = p + strlen(p) - 1;
 
 		/* "*foo*" */
 		if (*p == '*' && *endp == '*') {
-- 
2.53.0



