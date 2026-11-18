Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029838;
	b=DeWDzjIuG9TkMlKGudlVgKzrWtNq0ebT+LKCOI1ql5tbnznmcWB1UOXsXFNm1KrxNs+R
	 0d7RKbzt7yA1ifHku4JkehwwZIbLDvrFUOIGSPrSVs1ldsnAALY5F8kTC1+EVQo7UYu74
	 311NbFSLsdJHSIsbVNv8TMNRCpOjKO4+G2+Lc5qlsZ8JPz5eZHgY9vxFN37v8GT5E4Qx0
	 XUoexDcmskcmpW78DeEVQyrAeV8ELql4yaj2JED0vM9Oy/EqnTMJI6ucvjL4nNmX3rQa8
	 G/72CgumKOhGGTBMNO/czX3HGerPiQMsWtBvoGj12oyAf5sfbk5AMakVMxQqKpHunaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NajUN2i8WJQ0d6nQ/hRZ7dHWTYENqe1SFFPVFp/xDis=;
	b=NiHs8Lgy6G79m4XEd8Eo0f5Cgc1tRP/3tW5fB1k/FzNKsQqJbbwhHq5eq7iws1QPlyo/
	 vI4ynPsLKVWmzFYuTDYqe8JHoKsMD3uJ7X0/v4XnMYa9lVb5bYUNT4slcWYEAiuPU32ol
	 zoAuqikNzAf24DmGuX/V33uX2nRGOA9Y1+BrICW3Lwu6ofu++zmlmrNatenW1arVHuwhA
	 xz+6dZ4R3CXV5gOAugt8lmCTPDkpqv2vCCHWylHbTHmZfLnSQJEz2+gy93ztM+UKHrWHs
	 g8Noz6GMDLFGx/1muesqwrzoqPSuD9BassUISe0c5/Lu0cHgnm9yz+gd32TI/qyuLcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LRNE+s7b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2473606A31C;
	Wed, 18 Nov 2026 19:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LRNE+s7b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8BB1F000C4;
	Wed, 18 Nov 2026 19:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029838;
	bh=NajUN2i8WJQ0d6nQ/hRZ7dHWTYENqe1SFFPVFp/xDis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRNE+s7baqHiSQoAeSU3NmY/BQzwDvdegmlE1EmO9rJMYMSyG+aq1ReqzOJ8DBrnZ
	 MPbcAhlM8DycrrlGAHRj0KtLky1QYIn7F0WzO6kfiFBqQQqqzRRopHaCWTOF3avcXB
	 T33mO5bbGhCe4TYZOiBK6zHUkcrJDMOlZOKsOG4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0492/1756] perf build: Check the version of the compiler that is used
Date: Wed, 18 Nov 2026 15:43:39 +0100
Message-ID: <20261118150028.688223156@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 4f4387a07f601988e44fc6a4f4663aa1ff264f94 ]

The flex and bison flags are adjusted for clang older than 13.0.0, which
doesn't grok -Wno-unused-but-set-variable. The test is reached because
CC_NO_CLANG says CC is clang, but the version comes from $(CLANG), which
defaults to plain "clang" and needn't be the compiler in use:

  $ make CC=clang-19 CLANG=clang-12
  version from $(CLANG) -> 12.0.0, flag stripped
  version from $(CC)    -> 19.1.7, flag kept

Dropping the flag lets the warnings it suppresses in the generated flex
and bison code through, and those are errors under -Werror.

Ask $(CC) instead, as that is what compiles the code.

Fixes: 878460e8d0ff84a0 ("perf build: Remove -Wno-unused-but-set-variable from the flex flags when building with clang < 13.0.0")
Signed-off-by: Ian Rogers <irogers@google.com>
Assisted-by: Antigravity:gemini-3.1-pro
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/Build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/Build b/tools/perf/util/Build
index 7659db6039367..f26016fe43941 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -319,7 +319,7 @@ bison_flags := -DYYENABLE_NLS=0 -Wno-unused-but-set-variable
 
 # Old clangs don't grok -Wno-unused-but-set-variable, remove it
 ifeq ($(CC_NO_CLANG), 0)
-  CLANG_VERSION := $(shell $(CLANG) --version | head -1 | sed 's/.*clang version \([[:digit:]]\+.[[:digit:]]\+.[[:digit:]]\+\).*/\1/g')
+  CLANG_VERSION := $(shell $(CC) --version | head -1 | sed 's/.*clang version \([[:digit:]]\+.[[:digit:]]\+.[[:digit:]]\+\).*/\1/g')
   ifeq ($(call version-lt3,$(CLANG_VERSION),13.0.0),1)
     bison_flags := $(subst -Wno-unused-but-set-variable,,$(bison_flags))
     flex_flags := $(subst -Wno-unused-but-set-variable,,$(flex_flags))
-- 
2.53.0



