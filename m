Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017330;
	b=XcjGbH2IInTYmseYV1aViJ/tM2F/C7xotFn4FS7sjL5sssweA/Z0QfA6rRUORWBxOnc6
	 jwcU1Y1QhYJ/fPb8iq+ils9ErbyAPu97aWghFN0ga/R3mrHb8UOpeKPmSYNm946siUTlB
	 pZBqBIJZYNnVmDErG5BYLv7gyrDvffbeW98IUM7roCApAFqoIiJNIAiCYiAb1ywJFbNWx
	 657rRZ8xq+hwN6vOzKzUz6G6+RVMN0FaLDD3QjM8AkXoxQoylrpQAN9wGtT9xazpAIHMt
	 LyLIoI3XRCZIP/Z1Y2ZK2SfaWtaDgXSthi480cZxKVOxW3x5wQ2W97luWhYc3yS0jVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xi6X/y/OSuHYM7x2X/17mfOibLQfoqGt7Lr6jS32naw=;
	b=K50ELWVUE+kbcSQg+Ewgqx99v4hielAdLZUMlp2H9/jgDhHR0SN5/0QpLR5m5gDVFf7V
	 P77juq/wPQp9cqvMcO/y6FfBntaUx4M9tSBgUmN6WYMGNxCaXsj36Wdl8zoVznwCuJ/Ck
	 OX/qrvbhCIwsQY9svn3QV0iok8i1cnoY1+od6sc5BjSOGqEI9rDsEqyJPBndG0qsgD7/I
	 EoosQM+zdpNAGT/jCKwl+zxF9X5fnOozkzYa92ZoFoMpernoqt+cAKPag8YycPjqowDWB
	 1K5DYaT8Qw5TD1AjoOrXI4q5uHUEnGvQ1+3hlelXauGrCnpsrmZ+duLjxOkOmIzwLGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=miK1ozch;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D0360A2604;
	Wed, 18 Nov 2026 15:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=miK1ozch
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B611F000C4;
	Wed, 18 Nov 2026 15:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017330;
	bh=Xi6X/y/OSuHYM7x2X/17mfOibLQfoqGt7Lr6jS32naw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=miK1ozchvtL8cfhdFQ7WRWtqOvd3wtyybXFngJSVnah1Rn3h/1KQXaRkQRv1DyL8L
	 4mYCHcVr2ySm2Jmq3/jtxKPzXIdP2BJBM60LxfF1IyQHkJU+C9EYL9mrAvK4tiELcH
	 Vr+wO0/vKjPZtGcj/ZlN1GcB46ACxrHYBL0Lj1do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyou Li <tianyou.li@intel.com>,
	Wangyang Guo <wangyang.guo@intel.com>,
	Jiebin Sun <jiebin.sun@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0846/2651] perf c2c: Fix documented default coalesce fields
Date: Wed, 18 Nov 2026 15:34:46 +0100
Message-ID: <20261118150318.337480037@linuxfoundation.org>
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

From: Jiebin Sun <jiebin.sun@intel.com>

[ Upstream commit b36a6f180baad35a962677ae181681ca60dda35b ]

The default coalesce fields dropped pid in favor of iaddr, but the man
page still documents the old pid,iaddr default. Update it to match the
command.

Fixes: 423701a0c8d754d9 ("perf c2c: Change the default coalesce setup")
Reviewed-by: Tianyou Li <tianyou.li@intel.com>
Reviewed-by: Wangyang Guo <wangyang.guo@intel.com>
Signed-off-by: Jiebin Sun <jiebin.sun@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Thomas Falcon <thomas.falcon@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Documentation/perf-c2c.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-c2c.txt b/tools/perf/Documentation/perf-c2c.txt
index 8775889bc0a39..9e58a51c55de9 100644
--- a/tools/perf/Documentation/perf-c2c.txt
+++ b/tools/perf/Documentation/perf-c2c.txt
@@ -341,7 +341,7 @@ output fields set for cacheline offsets output:
              Code address, Code symbol, Shared Object, Source line
   dso   - coalesced by shared object
 
-By default the coalescing is setup with 'pid,iaddr'.
+By default, coalescing uses `iaddr`.
 
 STDIO OUTPUT
 ------------
-- 
2.53.0



