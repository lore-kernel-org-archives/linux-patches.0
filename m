Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025273;
	b=J4Xl33919M0AbYeuUOxtV7hdikQYVwfNlxh9G5X6nejdofYMUbKhjwbkotW4R5jaXc/u
	 1Bp4e+MyxudUUfXa7eWDaI5c6a+hBeRZd9ebe78LJuPyurII92j+NxuLiXTiVdakhCaJt
	 xkgiJtWY/zEYXarCw5sz2dGWLDCCel/s5FTPJmp4taaHQRouiPCiMeDiREL2cA21Wnhal
	 FtUrK16r65hTwmmbjqCFOPWDyoE39FQRSIDrGiuhd165rcwHNqurHiBU5HdvUwHu1Uz5J
	 DTqR2k4ba9vRRaOhU5tLbzmNBKdtn9A/kxRycMeoJj2ruyLiKxbB4umWdjijR9k+dDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025273;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7HFpkdTZxbXMjOnq4aysDsqpMcJrgaVg/+owcarkEfk=;
	b=NKK6h+ksvt6N8hVzSMSATMyhc2OsX1xc4Im6usWDSbd8T+sNdQS0KDC2zYYU9xUcqwe9
	 IFWG/AzkIPL8K3Zd87kBZJcSW5Vddwbk6KyzYgoQPkea3T7g/alN1cmgcYRhXRcwDh0wR
	 /D9vaTeILYprulttudYi70ck4JYC2nZVGFLIKom5LOX603Urc56BiQ+2YaBINYw6gJ5Te
	 s0Vs3kpPvPr4zGK3aUZZ7a1egPmVxkFh3CI9zV1bzpj+GQNmZNbaHNwCiwcUbr265iM4J
	 iBK1FQxFpka9VltlR6JHwXyodbDjRYEaIkxHXbjzQRYrkMFmrkHMih8guh49tM1TCSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A2hX62ut;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B6F60A260F;
	Wed, 18 Nov 2026 18:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A2hX62ut
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC6C1F000C4;
	Wed, 18 Nov 2026 18:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025273;
	bh=7HFpkdTZxbXMjOnq4aysDsqpMcJrgaVg/+owcarkEfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A2hX62ut83yc1XCFg+z4VgfiCrBzs682UQzb2rLAHXUo8TBF+AYQlAe/4BaeOLEMa
	 d9OZEMGLAryG9nHLMF3+XX6Nvt0LLp1tg9bka6K6RWOvq350FOH2EovlQfYseUjCFn
	 DPAzMh1kEbURUyymNEtCN/U7SIjY3VaQxxvzVnQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0979/2151] perf python: Track linked libraries as extension dependencies
Date: Wed, 18 Nov 2026 15:45:14 +0100
Message-ID: <20261118150158.152071306@linuxfoundation.org>
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

From: James Clark <james.clark@linaro.org>

[ Upstream commit 2ed38aa8a52d3e245a9f71b98825ad7f77956d50 ]

Since the Python extension switched to linking perf libraries, setup.py
only lists util/python.c as a source. The libraries are supplied through
LDFLAGS, which setuptools does not consider when deciding whether the
extension needs to be rebuilt.

When a library changes, make invokes setup.py, but setuptools can skip
the build and the recipe copies the stale cached extension back into
python/. This leaves perf and its Python module running different
versions of the same code.

Pass the linked library paths to setup.py and declare them as Extension
dependencies so that library changes trigger a rebuild. Include
EXTRA_PERFLIBS in the shared library list so that both make and
setuptools track those inputs as well, preserving the existing linker
order.

Fixes: 9dabf4003423c8d3 ("perf python: Switch module to linking libraries from building source")
Reviewed-by: Ian Rogers <irogers@google.com>
Assisted-by: Codex:GPT-6-Astra
Signed-off-by: James Clark <james.clark@linaro.org>
[ Applied manually to address some fuzz ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.perf | 5 +++--
 tools/perf/util/setup.py | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 21a25a938acf3..3146b119e3d9b 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -482,8 +482,8 @@ endif
 EXTLIBS := $(call filter-out,$(EXCLUDE_EXTLIBS),$(EXTLIBS))
 LIBS = -Wl,--whole-archive $(PERFLIBS) $(EXTRA_PERFLIBS) -Wl,--no-whole-archive -Wl,--start-group $(EXTLIBS) -Wl,--end-group
 
-PERFLIBS_PY := $(call filter-out,$(LIBPERF_BENCH) $(LIBPERF_TEST),$(PERFLIBS))
-LIBS_PY = -Wl,--whole-archive $(PERFLIBS_PY) $(EXTRA_PERFLIBS) -Wl,--no-whole-archive -Wl,--start-group $(EXTLIBS) -Wl,--end-group
+PERFLIBS_PY := $(call filter-out,$(LIBPERF_BENCH) $(LIBPERF_TEST),$(PERFLIBS)) $(EXTRA_PERFLIBS)
+LIBS_PY = -Wl,--whole-archive $(PERFLIBS_PY) -Wl,--no-whole-archive -Wl,--start-group $(EXTLIBS) -Wl,--end-group
 
 export INSTALL SHELL_PATH
 
@@ -744,6 +744,7 @@ $(shell [ -d '$(OUTPUT)python' ] || mkdir -p '$(OUTPUT)python')
 $(OUTPUT)python/perf$(PYTHON_EXTENSION_SUFFIX): util/python.c util/setup.py python/perf.pyi $(PERFLIBS_PY)
 	$(QUIET_GEN)LDSHARED="$(CC) -pthread -shared" \
         CFLAGS='$(CFLAGS)' LDFLAGS='$(LDFLAGS) $(LIBS_PY)' \
+	  PYTHON_EXT_DEPS='$(PERFLIBS_PY)' \
 	  $(PYTHON_WORD) util/setup.py \
 	  $(python_setup_quiet) build_ext; \
 	cp $(PYTHON_EXTBUILD_LIB)perf*.so $(OUTPUT)python/; \
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 8380980ade4c4..3b6a59f66944c 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -173,6 +173,7 @@ def main() -> None:
     perf = Extension(
         'perf',
         sources=[os.path.join(src_perf, 'util/python.c')],
+        depends=shlex.split(os.getenv('PYTHON_EXT_DEPS', '')),
         include_dirs=['util/include'],
         extra_compile_args=cflags,
     )
-- 
2.53.0



