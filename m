Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048547;
	b=YimZeREVxyUVSzOz7zmjzfw0QQkoat2OoBIpJ+Ws8D9TrH+t9eWOT6j25K4R3FQigzkm
	 K8FyDqOO0zgCGnz6fqMzgH98155WSMF/QopdptM+awdJWxcjBg7dpo2l34PM+6//oXdZg
	 apeSbq0ySiVUs6ee/eNHtrm2JKAUUuHM9E/oHWzuMDp12HIuYJlEWAfbAWZrNcQR/K4KG
	 xeijuWQ6yl+fcKIddA9N+ySdFBWe5laIpDuzPDgekaQMKeUWJbVevaGSktvSLlfdlx8rP
	 6pOs2OgUj2xvD8KnaSuZez264/Xv+JOWF4On3JXqr/cF9KcUUyTAavgLOISr61SGEdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ySzGI+2FBhsAS+81sXRUWUw3HoPulEydlprQXirfA5Y=;
	b=fMbHhxeXqda+SEBz9St/k3qXop+svMu7kdY8USVIIMAbE3sS1ipNS8vEzchZjpLBZPw9
	 4Qcon2x6yDO5WJ0tzHpvWNGWQz6oyVAvibePQ30xqoiqJPO3Ck7alCscTZzSArggxShFV
	 3ws8VDMaBkO3yJMVobgWq8OEQzIT53TQFhJptD0uIZa62wYkmxamJYdDime1pTNYvXiZd
	 Sl1viqNWwEQJtwocTcmBHvnqDaKwH8XLXCHwIgM8yTlW6Ja1d3/kwQ0uMU1QIjmpIS3ON
	 00mYlHSginS2I76ruAfZrncYlu2CP7H3ncjBBWTniixdsCq8N9aDhbTd6ec5+Su5GEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0jod0Bp2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C27E606A325;
	Thu, 19 Nov 2026 00:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0jod0Bp2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB401F000C4;
	Thu, 19 Nov 2026 00:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048547;
	bh=ySzGI+2FBhsAS+81sXRUWUw3HoPulEydlprQXirfA5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0jod0Bp28/H9euS4JjvicIxjjCpc4lXarnsTZ0fyCUdwazIYw85tWxi1EtEQ77UxD
	 K8g04ZdGV6LhB3eDSz3sHEfx1nLQi44Y0XGxMXrO0ZXnX356DTtGj2xpSELLQOn7Ls
	 2PkXp9YbnYQBQA53cIyYls1BBCzEx0JUcz+U5E6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1992/2857] perf build: Check the version of the compiler that is used
Date: Wed, 18 Nov 2026 15:50:26 +0100
Message-ID: <20261118150313.098510165@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 43f74f5b96f8c..fd9305d2c4163 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -277,7 +277,7 @@ bison_flags := -DYYENABLE_NLS=0 -Wno-unused-but-set-variable
 
 # Old clangs don't grok -Wno-unused-but-set-variable, remove it
 ifeq ($(CC_NO_CLANG), 0)
-  CLANG_VERSION := $(shell $(CLANG) --version | head -1 | sed 's/.*clang version \([[:digit:]]\+.[[:digit:]]\+.[[:digit:]]\+\).*/\1/g')
+  CLANG_VERSION := $(shell $(CC) --version | head -1 | sed 's/.*clang version \([[:digit:]]\+.[[:digit:]]\+.[[:digit:]]\+\).*/\1/g')
   ifeq ($(call version-lt3,$(CLANG_VERSION),13.0.0),1)
     bison_flags := $(subst -Wno-unused-but-set-variable,,$(bison_flags))
     flex_flags := $(subst -Wno-unused-but-set-variable,,$(flex_flags))
-- 
2.53.0



