Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016768;
	b=1UvzRK/3tA/TXxHI5kufz07GSDtyZVDYFG2f9AWIQLCPCm8Fqh7KkREiFkmIi2Wn07Sc
	 eku9SpwnhuoHF34L6w464Vd4bMDtOGu382gfwfP6VGTNPrAGu5dwVw2zb3+lGc3ag25/p
	 2UdKLNr9OzSzt5rh4ZCKtVqAI+20do3yHGuMRD97FXIzUoLFp2TIoKjDu8e39i44P91zm
	 R+YYvDOQpEFf39Htk4c8Y6gkSXGaHAtX9YxwjDbVy0KGvxkJ2ldt0Y/P6vdbfpyEO60pb
	 2CTfyTbW7VzSEHQBuIPwQcWrStB/IkReusuZ6jjJALSx06INIEWyaOvo1wre6wW8yPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016768;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=86h2Zh6UfH/9/x/1G+VJ2ZX6X6+uw0PNrr/hFw3GkHo=;
	b=5VYXD/kjTp3PZhqF5v6nmOmNxooyhgOA5sgdqiz3Mljlgh1QbD3iMlHlHaTApkk3Bj98
	 FLdOrnpfJwcMrOIFz7csXQ2PT8XPqlgfQoDBWYtlTUtK+8m1HMbeSTeEmz+EHvyUvZUZu
	 LeIbddsRM++olTfRcw+fd4h3oIiTHq7Si4G5WTiU9L3cbSnk+tZQe/39DFKRPi/SAiEA3
	 RLcOLNed/QP0CONwVkqNsNawj/6FC3W7n6U8p51a8/nv7AxclyzaX+0lSp8kLUciFO3Tf
	 633UAcRLOYk2dSS+HuALhXloCq9QFL1Em31UTyeIYKDoujchj6LmXeqbKSLjgpVkZDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxpyE0fd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31CB606A31C;
	Wed, 18 Nov 2026 15:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hxpyE0fd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBEC1F000C4;
	Wed, 18 Nov 2026 15:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016768;
	bh=86h2Zh6UfH/9/x/1G+VJ2ZX6X6+uw0PNrr/hFw3GkHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hxpyE0fdUk4McI/CoEGA52UelOIfWLaXCCOPWDzXB24vETqAw7PNt493xBNbE0XQG
	 6/+BUk67B3V8l2NVBZWpnRVyzJ7//sGkZLfSoA2Ar+bIoXBfiywpLZyuYc2ukdhWFY
	 5oZLMOM+eZX4MxQpCTxm6GxO4K5Kfd3HFiQP46xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0644/2651] perf build: Check the version of the compiler that is used
Date: Wed, 18 Nov 2026 15:31:24 +0100
Message-ID: <20261118150310.866200804@linuxfoundation.org>
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
index b26a0b1ddfa3a..776b2230309c3 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -340,7 +340,7 @@ bison_flags := -DYYENABLE_NLS=0 -Wno-unused-but-set-variable
 
 # Old clangs don't grok -Wno-unused-but-set-variable, remove it
 ifeq ($(CC_NO_CLANG), 0)
-  CLANG_VERSION := $(shell $(CLANG) --version | head -1 | sed 's/.*clang version \([[:digit:]]\+.[[:digit:]]\+.[[:digit:]]\+\).*/\1/g')
+  CLANG_VERSION := $(shell $(CC) --version | head -1 | sed 's/.*clang version \([[:digit:]]\+.[[:digit:]]\+.[[:digit:]]\+\).*/\1/g')
   ifeq ($(call version-lt3,$(CLANG_VERSION),13.0.0),1)
     bison_flags := $(subst -Wno-unused-but-set-variable,,$(bison_flags))
     flex_flags := $(subst -Wno-unused-but-set-variable,,$(flex_flags))
-- 
2.53.0



