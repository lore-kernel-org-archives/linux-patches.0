Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023916;
	b=r7DUtxILuwptklGvaT9/K4wOU25AtNYvFWlj+yslNltYqeb+A3im6ZpNPwYMHItX+SyN
	 w6S6wYl/9MSgWbMWXE6CuRetYMdBYSQMKxdOlHCllZKOYiRlIUKPkXsztuilfc2zUxuKO
	 HqSs7u7XyFsnkW0Qw/dQ7RNQBKkJ3cxicPGI9lTSVN3sc6BcAODxH3fxFmC54VcyNlbsb
	 USxoWALq+2HSGdfEEPcuSPp1TODWOY4xkEA13yCKJNH8mMZev0r12TrVa1t9lxYAXiQZE
	 IiKRkxh0Wlw7WjWJcbi73yvN9Y1NBbc3+Op3CLQ+EtvicIC1Up0iYaBY55BvhFDQHhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cbAPngunrWWmUyiHeaNcqYEtZP3/voeWZsrfZo7wnTE=;
	b=ERQtPudY6CmoHVW3DGrA4k9ksMCYC+RzqXoHE2+5FuqTd5pUtz3FSIYmMrR3EDvkIm3i
	 fZUPFJTTJOpNnGTiIrBcGmXKhbv3k0G84q83OY6simDdT64Bsbz7sqLm1lx1seIHur8A2
	 YSvCsp9MqeBZXEZQLA9I8qE7pcSnrlPP1qCpEWjt628a6W8U7Tzl6bHXJ+akcGFQQe8OA
	 Ki79TEDc48xI1AqvSkEuHbj6+VWqpO1VGcrzpGqmC1yY4yer8DdE6uJaCnJR5+5WyUNKl
	 g+M6eXInmzWN4Y40OQtlYw1IazBDf5SmAXYjBQiiHrTxqQ2QuKWiTDMbsWGiqyZC8Jg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xfA95DgP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FF7606A32A;
	Wed, 18 Nov 2026 17:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xfA95DgP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A3991F000C6;
	Wed, 18 Nov 2026 17:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023915;
	bh=cbAPngunrWWmUyiHeaNcqYEtZP3/voeWZsrfZo7wnTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xfA95DgPeCkemIElR98XObORqdXF17bIfzJInxebHbqAuSr7YOrWXrqtVnGZW/hOa
	 lihOcva1eT1+VQY0YLVRH+K1JCPw7cbPS7bceS4vOwufL21FtLhACuoH8nRPhc/sWY
	 j/d98K1SoTapMjJq21x7FSU3HJiVEszAQNpoiWGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0539/2151] perf build: Dont add NO_AUXTRACE if missing feature-get_cpuid
Date: Wed, 18 Nov 2026 15:37:54 +0100
Message-ID: <20261118150141.637821474@linuxfoundation.org>
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

[ Upstream commit 2566bbfc0a042feadeb0bea1f1f4b2b13f91c664 ]

The intel-pt code dependent on __get_cpuid is no longer present so
remove the feature test in the Makefile.config.

Signed-off-by: Ian Rogers <irogers@google.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 0824af00a8d2 ("perf topdown: Don't require config1==0 for a slots event")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.config | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 8ae13809f68b2..d91ec4450cc66 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -1114,16 +1114,8 @@ ifndef NO_CAPSTONE
 endif
 
 ifndef NO_AUXTRACE
-  ifeq ($(SRCARCH),x86)
-    ifeq ($(feature-get_cpuid), 0)
-      $(warning Your gcc lacks the __get_cpuid() builtin, disables support for auxtrace/Intel PT, please install a newer gcc)
-      NO_AUXTRACE := 1
-    endif
-  endif
-  ifndef NO_AUXTRACE
-    $(call detected,CONFIG_AUXTRACE)
-    CFLAGS += -DHAVE_AUXTRACE_SUPPORT
-  endif
+  $(call detected,CONFIG_AUXTRACE)
+  CFLAGS += -DHAVE_AUXTRACE_SUPPORT
 endif
 
 ifdef EXTRA_TESTS
-- 
2.53.0



