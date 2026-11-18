Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018376;
	b=Cii+YqR3dURVtirFFjk0S5Y9b3XydVdnzmpg9evaUpkwX36+G7d7S6Z208VJnnBRvumm
	 FrccSLxzvthjmpe2TPaTlDmLRVv+QP7dCu5rxB9IjHVvBzcYlj4LhohcWBKyP8pCGGQbU
	 urb0+jYQFcDHJXh7QgtPW8APTToqAyC1XTuSLUdN5UwyvbbVUEDrG8vHptC1W+MgwdSmp
	 m9AztFFmv3+XP6+zERepk4Voc/oiAzDgDHV45qSWWvzDkhsyZis5HuCs+4rSyf17kfOfv
	 IXJ7LtxnFazyAxX7BlK4G2BJcXuPvPjxzYkiticxLfMJx5nBGvEoJHHVnf17cbQiT6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018376;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DSYteJZTp6WxpeaIBZXoAb+EomHl1Hr1OysP75CirgQ=;
	b=oisM5JFATUKVigf/UJROQQUqW/496bQvRxuCcr9b48p+PKTM0k9jmGlID1nkNNF8Dp0I
	 kwEcaNaNBAMkyHCbI3vAPegLjoe7YU1IPinGNb2InCyBS1FKShpyO8wPu2yN0MeYXsUWM
	 1b4KCMCvHki3GTVu0pW0z3haj/N+0ePTmmmI2cYGkQLAJCUjcm2xupkpoqS36mENIayrJ
	 wvSW1YeEifNrh4W/S5R9M79/JtFLT0kzXffoT9e9ZGsiDVQU44/Eelq1ydKfjx561R9kx
	 hLbdU6x5pGSXHVkt8wXNE9SV84DTe6ztLDXHDalEii3Tw465kkvff+MTiRg42A2HTGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2njw1HZ8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DFA606A336;
	Wed, 18 Nov 2026 16:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2njw1HZ8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6601F000C4;
	Wed, 18 Nov 2026 16:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018376;
	bh=DSYteJZTp6WxpeaIBZXoAb+EomHl1Hr1OysP75CirgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2njw1HZ82EmVX9D20olxjY2KpjG1kpm/O3lanXhBosuc3OjIDad6oRTUKe5t0dKxS
	 0qG6yTNkSy4u984Pemd1TweiVoDpMmhxmA+E+EAAz0F4DXuVkk/2AWNj1rUkhbheWw
	 4zK8uqaCPlNx9/5aD2TOeGyWAbPhUQvlGJ+FnoGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1178/2651] perf python: Track linked libraries as extension dependencies
Date: Wed, 18 Nov 2026 15:40:18 +0100
Message-ID: <20261118150330.418261798@linuxfoundation.org>
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
index 4841a7204a308..00f6a13f9a1b1 100644
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
 
@@ -515,6 +515,7 @@ $(shell [ -d '$(OUTPUT)python' ] || mkdir -p '$(OUTPUT)python')
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



