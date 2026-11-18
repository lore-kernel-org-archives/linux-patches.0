Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030109;
	b=MZLvLZMZBs5rBs6I6JMyqx1kczDat+uBs6CACXheNo0ghM1rl9U8OEOoq1z1HOXBZuw6
	 ZALk+GIN5/LmS8CdU+vIhgnLt1kKBj4WjcATitIRaL7GolMi4br0O+DHOXqeTClo7D0aZ
	 dqM6mSoM6F/RIu/727EBCDaqyVvEQnM3StuD4z1dnSD8xCvnqt82+KDf+dEziiKk3RNni
	 AQVj9igj2FgMEdWOIKfie+mfc0rQeQjpKGZTRl45iPq18ehbhqLNgIQNV7vugiTG4ZNLv
	 1wtZbzrsAR0oxCXtEff3XfH62kaWGwzmuJMu02NxdPKrc7F7v4+ExCYn3+e8O9uciCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030109;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ApgaGTx8XDCRbSKQUYKJdyjKTVVIedJ3SkkK7SaLl0c=;
	b=tujW4+wpDsAaLwHQApY9a2zmvdYkRBObXZUuNmSTfhlACT2nEXdAkEnbRE9Wr9cHlNi5
	 WlsbAVlam07Rq9mZRdGEWMeZeD547KbDy+tB09bLKCAcHR3YoQx4eKfXHLvT96hP1/KY1
	 UFrw2YjBRuyNsra+jVJ1T+evXy+nWhTFYA4M92zCE4gOfELnQDtYrEd8o6qhx1pHFuF5H
	 vH7S446gizXaOHTa5K84iC7HtnX7J5pRBxB+Bl2dWMiOnkSBOFx13SRnoqKPF+tWyEiO2
	 ptCmRrgpgOcGaay6qWydCbJrICeOzoHavUtQwXXmf19lSo2aoMNgvDj9JUPaoa5c2Bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EWcVXF3A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C03606A7D4;
	Wed, 18 Nov 2026 19:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EWcVXF3A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD0B1F000C5;
	Wed, 18 Nov 2026 19:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030109;
	bh=ApgaGTx8XDCRbSKQUYKJdyjKTVVIedJ3SkkK7SaLl0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EWcVXF3AFu6wIjUSXv6oYQdfjWLlSThFGOQRJX7u4UxCb3zC4/pB+IubgKKrz0HcT
	 V5RMicjCqkhgYrc56cC3XX5OpXlTGk/lUBQxe3sXDuv7wRSsEe5uwEBaTeumuFGQmU
	 MjHWZxvNJo7EpSQ87KMQPW84LPCUSHgElo5hKwDM=
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
Subject: [PATCH 6.12 0587/1756] perf c2c: Fix documented default coalesce fields
Date: Wed, 18 Nov 2026 15:45:14 +0100
Message-ID: <20261118150032.387329287@linuxfoundation.org>
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
index 856f0dfb8e5a3..d744b43769a0b 100644
--- a/tools/perf/Documentation/perf-c2c.txt
+++ b/tools/perf/Documentation/perf-c2c.txt
@@ -304,7 +304,7 @@ output fields set for cacheline offsets output:
              Code address, Code symbol, Shared Object, Source line
   dso   - coalesced by shared object
 
-By default the coalescing is setup with 'pid,iaddr'.
+By default, coalescing uses `iaddr`.
 
 STDIO OUTPUT
 ------------
-- 
2.53.0



