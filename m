Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017965;
	b=p1/YQavrZfr072wOYO3RG4ziIWVaIK3ByPxiykIprO5NMa8H42Fcwli3bOy+2x0LrSl1
	 LUaoSDP6jQOgUMvNbg6hffKL+6eQR48j03KhcUE4NyjPRYdUwklPJzTM89M0EggVv1Tac
	 ttAwdI2yQ+HyZ27I0GaGoe7U6b6BOHDo/2IxexIwAu3VGdkZAWTBSaI26ZXJtkQry68ZY
	 duJ3Fvd+ck2699Ios60PgS+p778Qp6iwDCmhHNZSQ6gbWFVRfkYUDr0+QYVKkqg4gs6m0
	 FFn3h039L+zKOVMF2JogqMh5rF44ftcgdboVOGgTTpWyw1RnXBmATRQaeGt5GOp0sMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iyNwQf7xdf0tYDPZIsxJqv1Gilae7N+HT+B+bQzxjYo=;
	b=A01PiESLTuxMJiZZMo2dF15h3LesalCFYwglEehZ0D9rNnbRINRY9xJK4jXu0Ajvmy1r
	 Cg4Dpjt/6Et3YhHQU+CROjcJmGhDp8xJ2keXjUcOmBb9RRcp7hNwy2NfcNFBWSzX6/MvG
	 4HRVvH4KtB/yH/ZbNnSPM3sCsiQoZNWJEQOl5rR6RNWfc25p9Rhyb3PPDlo0gZFsjgEzg
	 M3OWB09/L7owIXEw2IzzWTaBVwu/NAyr9cuKIhMIqWxpadaApaufChNHQu9j2c+dS5P08
	 hxkz4Pjk3gFgGn+ehWFUvZJfYO8UkhJ9mr978DYQQOEIFK4Dvy+XKzX0ppgSmt6Fprg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JudFy1HX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C82606A32A;
	Wed, 18 Nov 2026 16:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JudFy1HX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566911F000C4;
	Wed, 18 Nov 2026 16:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017964;
	bh=iyNwQf7xdf0tYDPZIsxJqv1Gilae7N+HT+B+bQzxjYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JudFy1HXZmdR98JGUD0cx/r1iJQtGd/zdjg76KiiPGng6jOYQOGVzkdk5o3L8Wm8n
	 vdMSzKv5zVqNzqIEcAcuOPqqmt0mXxab9B7S/9pBKRCBEQldicLzmmM3XslkjqKC6x
	 UeuhDrmfBI1JsneHZkH6wW9X6HafInOt3lHWnx48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Michal Pluta <michalpl2003@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1071/2651] perf symbol: Dont return an unterminated Rust demangle buffer
Date: Wed, 18 Nov 2026 15:38:31 +0100
Message-ID: <20261118150326.542215360@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ad21f9bbe4404..a9ff973e6bb2b 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2765,17 +2765,16 @@ char *dso__demangle_sym(struct dso *dso, int kmodule, const char *elf_name)
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



