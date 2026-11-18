Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024947;
	b=HYYBCu77kT4zyP9+zZm2/nZb68TeIEPZLboJBMBcCv1cPbqfJ9fDFOOV+wv2YUTux5Vp
	 hx+xNhCrogDqV4BdhgEuoShNoA7J6AkUAwlcIX1QGtCAOj3SoHwnHVQdHe7ynj4eZtoGG
	 hM3Ppd5EV1SpVMuK7kciQ4sZ2fY7p3SPCz0vjxd13OCgON2KsUPgshtk8rTjNSdAsiZqz
	 zSTqSoVkic7cczS4/yEnByqIM9otKoQGK/nQBzJ8VzpQ3MDe2cAU1ZeHPgrN9/pqFHDxF
	 CPBcxQ/85LFcILaVF6C0JxXEdG3SCS/l/MgDLqzTY27KBO1cmb+6oFjb5dO6sUTLYzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8N0n15fnq88wTVtr7d2oFuEGyjIPDB12b9BsRhR3yvo=;
	b=k+KuhrJN5dwMk4n4f7RZAWJ/l5kCdDGVHh/oPDq2Xlhv+xV1b4AVXNgJ3lFX/0ANvT9X
	 YW/qql+nfKwX3wZx7rBu2ZcJiSYu1QL6c8nXMT+J9scG8plQiqwq4js+1tovflZ0/aW9G
	 aA6Sfd5qOUBxX70D0BZExgIhecvgK9mZRybF8VJu8kJKax8a/FLr7C7HkcBhWhGy2foJV
	 tLptcwhKZXJVk5dh0yrJ1hb6Rrn8wpSkTuqnpbryrHJrkkbHWdegTJZAQH97liVEgsq25
	 77e9f5oIPp6Y2ec3I0VSlTFWtJA0aPvGLKlbhgVpoKIY4o5d0TnXswK5YMqZyEYPL3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VFNYKuz5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 069F7606A31C;
	Wed, 18 Nov 2026 18:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VFNYKuz5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CE11F000C4;
	Wed, 18 Nov 2026 18:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024946;
	bh=8N0n15fnq88wTVtr7d2oFuEGyjIPDB12b9BsRhR3yvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VFNYKuz5L+Il6S2b4p8BWN4AXDy/fIzcbV1iqKkS/y1kXUD4FeIaSODQligl7xwCA
	 jEwVEcQN709ZtbiHGNgWITCWQF3oZb461tbIs/v5oNj5zhG6B8z1AA4zRYNaLTcRgy
	 OuNuOAOXb5IeIcSMsUEsG/dIdbxOiY8G8hhnr7ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Michal Pluta <michalpl2003@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0904/2151] perf symbol: Dont return an unterminated Rust demangle buffer
Date: Wed, 18 Nov 2026 15:43:59 +0100
Message-ID: <20261118150155.252848296@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Pluta <michalpl2003@gmail.com>

[ Upstream commit 0b0752e8a493634915e16456df609c08c0595e85 ]

When dso__demangle_sym() runs out of retries or fails to grow the
output buffer for a Rust v0 symbol, it returns the buffer and callers
blindly use it as the demangled symbol name.  However,
rust_demangle_display_demangle() doesn't NUL terminate its output when
it reports OverflowOverflow, so the buffer isn't a string.

Free the buffer and return NULL in both cases.  Callers already fall back
to the mangled name when no demangled name is returned.

Fixes: e20848c317b51e74 ("perf symbol-elf: Integrate rust-v0 demangling")
Reviewed-by: Ian Rogers <irogers@google.com>
Assisted-by: LLM
Signed-off-by: Michal Pluta <michalpl2003@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 9bcd95390980e..e64668cca6b29 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2611,17 +2611,16 @@ char *dso__demangle_sym(struct dso *dso, int kmodule, const char *elf_name)
 		     buf_len < 1024 * 1024; buf_len += 32) {
 			char *tmp = realloc(demangled, buf_len);
 
-			if (!tmp) {
-				/* Failure to grow output buffer, return what is there. */
-				return demangled;
-			}
+			if (!tmp)
+				break;
 			demangled = tmp;
 			if (rust_demangle_display_demangle(&rust_demangle, demangled, buf_len,
 							   /*alternate=*/true) == OverflowOk)
 				return demangled;
 		}
-		/* Buffer exceeded sensible bounds, return what is there. */
-		return demangled;
+		/* Failure to grow output buffer or buffer exceeded sensible bounds. */
+		free(demangled);
+		return NULL;
 	}
 
 	demangled = cxx_demangle_sym(elf_name, verbose > 0, verbose > 0);
-- 
2.53.0



