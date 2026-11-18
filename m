Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024030;
	b=GABG7qgpuCZwOpUXx74uHriJi5xiyBMptk4zF7ES+rlswy3s9uHveMn6NNH55Ojmfm8m
	 t8EdQgQX01Sb9oB9Q0kaG4uooLRXrItCENsdhwnAHbxuJF1sSACBlJDNy+qE2DterMWRV
	 p1/+RMajuagmLJy0C4ov3OMbFn/pw9K0nURTk+blKFmP5YGGPRQQl8AfL+2tjCsk1YuEc
	 U1iuLgwIa6D5EZTBvVSXnWqtIUkq3mqJGKm7DiVBX6zLSjjeisfGtAG4Xq+oKFZwcqkFH
	 jQb4xHE+NuPTCsHaDSw5/OPzyORAGGCZ/D9uqaC3KnjU8roTRUPJn0D2tpu3tX+haew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024030;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PFX0LlQQSB6lxuz2zlwouOd0tHvDEv5TPuJL43e07fk=;
	b=GEeWhxVHKi7voTRuI0MzK+qi0EWQish/UTGSIBCfBADVfQ2FeoYPJ1o8vISyL/Tk2kjd
	 9PHGfDwUolgIRVeBohrhdhh09jRdMUAo9TVS5aXjqXKf5pyfoU2a8mUwHssF311CmzDm/
	 hwesuSkxLDYXkr0AHhNlmCsm3tDWIjvtfkwLNsFZwJtJJq0ES8+2zj8W1+7yAetNt1Tsw
	 XCA+e4Lfy/CLd38c01mNpTZ7szEQV9b/BEuT1qj75fSc9HPRCnVIn0n6nAalopkEs1I30
	 FFqv/1ICKw2RgVaX+JSr53Kba3FzGrxpDjPsqBrMKh1D+pWX5ZnFIkRBnGebDV+oDig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fksidb2R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB74606A31C;
	Wed, 18 Nov 2026 17:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fksidb2R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A9B1F000C6;
	Wed, 18 Nov 2026 17:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024030;
	bh=PFX0LlQQSB6lxuz2zlwouOd0tHvDEv5TPuJL43e07fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fksidb2RfqxnBNbidHBmuKdxn3wD6AZ0mVzGMy2fWZAcOuta7n/Hsm5bGd/3XudH8
	 rOkNiBQYHyI+OojMi6XA4hs6eIPrNoyeD6L8crkbbfM88q7uiuYiC31KPJLOFjz+X0
	 zV0QexMuAZ3i2JBK/te11R3TAUthsqEXRRvp5Yqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0580/2151] perf build: Check the version of the compiler that is used
Date: Wed, 18 Nov 2026 15:38:35 +0100
Message-ID: <20261118150143.081165933@linuxfoundation.org>
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
index 1c2a43e1dc68e..dd4bd73f6c281 100644
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



