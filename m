Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039954;
	b=d6esG83tcFGWFRglr0js+Cssi0UKs+fXL+Pq8lqArppcPixZ9Zd8YlHQVoxuqopPMmb+
	 UfFeu+O+pJj8ZnCpN8SmPLMHfSCx3jLwZ+u3ueM2Biw5UWZP4pK323RPIpjPlVn8LEL5I
	 SxvTu6B+1xaJnYOU30O4ssLk9x2M2n9Mib+S+7gg/EOd5rIIYlQ5doXLSq1w/mRN1pI4V
	 wj5hG/3fWt+c/SohtoeFpO5nYyUoQjfCubBevSQKq6GepiGCiWEoLP8lC7kf6POOoSf/E
	 HyFsXbDFMCM92TLuWPRr4Djq/YmjlWpQOjWuNd8IBsCmcQsByozkf0EVUfuEz+82/eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RolVt10ChfzYEYtrm3NrNifa5YVYY/ulpq9AwnlKbOg=;
	b=g3dTd32D6VAgmHg3kMI2/Zy+hoJx9h/HmlvubKVN9lzyd4BAzjYseZL2gzvnXRGP4tMY
	 KmKXjQ9mEatlFUxtreJzKPgaj2jGBhdjwp0CNZKvC94mXTgO8nDd+egmfbyymMC0HOZtI
	 BCPs1skX9Vf31FL+h3QiMLPy5HEGVcOx3lpFdmPi5/YkViTs+9TIOJf1PCvnTYOd8gPDp
	 vDGfpCdliwZU1N+58rd9DJ8DkRiwAjNz/agoMfB5Bx4zVxGPDaa7Y/d0nqIeuRSl8Rnzm
	 StEL0wXIjOeaD1ianTNxr/Y6Ous5mUMklDzS00iLHYBLpm/cqF0DiC5dnNR1oUZ2GPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bg4zvR9k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDD6606A320;
	Wed, 18 Nov 2026 22:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bg4zvR9k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E8F1F000C4;
	Wed, 18 Nov 2026 22:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039953;
	bh=RolVt10ChfzYEYtrm3NrNifa5YVYY/ulpq9AwnlKbOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bg4zvR9klAKOqHnfKMAjDY2HR5vbKpvkVsS0DZr+5ymHirrovuxc26llYofYkFIgv
	 JxcC0OzIVUys5MqZ6DASs4tZzdnKOrTiz5dQ3y0Ons80g4N7/tdrTA9b10ePHqpoAI
	 Tk4/uiM++B95/+HHjP1uehCV9hWDY/UfqY+iNlLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2285/3318] perf build: Check the version of the compiler that is used
Date: Wed, 18 Nov 2026 15:48:27 +0100
Message-ID: <20261118150430.308240812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6d657c9927f7d..f67ef7ccc0e65 100644
--- a/tools/perf/util/Build
+++ b/tools/perf/util/Build
@@ -305,7 +305,7 @@ bison_flags := -DYYENABLE_NLS=0 -Wno-unused-but-set-variable
 
 # Old clangs don't grok -Wno-unused-but-set-variable, remove it
 ifeq ($(CC_NO_CLANG), 0)
-  CLANG_VERSION := $(shell $(CLANG) --version | head -1 | sed 's/.*clang version \([[:digit:]]\+.[[:digit:]]\+.[[:digit:]]\+\).*/\1/g')
+  CLANG_VERSION := $(shell $(CC) --version | head -1 | sed 's/.*clang version \([[:digit:]]\+.[[:digit:]]\+.[[:digit:]]\+\).*/\1/g')
   ifeq ($(call version-lt3,$(CLANG_VERSION),13.0.0),1)
     bison_flags := $(subst -Wno-unused-but-set-variable,,$(bison_flags))
     flex_flags := $(subst -Wno-unused-but-set-variable,,$(flex_flags))
-- 
2.53.0



