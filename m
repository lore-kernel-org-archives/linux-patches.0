Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060874;
	b=Fz+4WgVPPgPwx6uOiw5vmgmqTJ0LxLNYckX45z6rS5XiTD5TAlJPBisKtEZwYqvJmcmh
	 X9ZNV1TWiO56oe0VEA/JB9bunPSKuX+f1+VGaK+eFA+4Oty7BJjPe5d0INS1fBh94whVM
	 MhzmuCzE9wCvP9M+e2lSLEJBQlZl89ex/yYNaIoZLkk2JE4DXduBFfvtNY71sokkYzVOa
	 t5B46OxXVsHvg2LMbxsT7cckEsmE/CyQe6ZVqcykXEsuKsYhbukPA1QVDop2lfc80a2Ln
	 6+HbY1RL2QSJKmFbdju892LK9i3F6bOa/9QyECPMA1SxS9s9rahSSNAwJOyGkmcWkjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060874;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R/uFGeq8ulq8CCiC5H/c/kPCUjuEOSPWDit0Lcp5ZC0=;
	b=ZjhqMQ0+Idfs+nyV1KNEdTB4ffcXpL2JH0psttqYI7W1Pfbp+vnUr+wg8LfJdPRYGgYT
	 6zKgzo0ZyJMhgapux9X93h2Tjd8i7YOo42gbLpg4PvOmGT7rZYnZ+sX0jdts83pCJ/K6b
	 ebn/vA9gsc0yyGLAX0dZe6KgwI7p+ZyHyOqE7XfHL0a8j3vyTkMutNthSRc4Rbp18QOyg
	 mRyB+WHanOMZVDbcnMML2s0H+rGkO0+4KTTZz1nZuupkSuar6nlLYEwcq0Fx9ve6DNoeU
	 HXcwnl0szePerU5vblPXhgOLBHem0nV1hyhvXDquVWfQ8IQ2kscEy3OWf72RMLjQUQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sxjTc3tO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A003606A325;
	Thu, 19 Nov 2026 04:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sxjTc3tO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5031F000C4;
	Thu, 19 Nov 2026 04:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060874;
	bh=R/uFGeq8ulq8CCiC5H/c/kPCUjuEOSPWDit0Lcp5ZC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sxjTc3tOr7sewrquN7dsAtMLT77/WWQofnP/1S8EleTxn9hSVwn1+oFbFPmcThgC6
	 AIEhGanlu/EoR+eAyHIxKYTgZBrqXhp28Xe6dOG1ftffxBjjBvTQ6NsAtipBWCV7Hn
	 qjsrok/rbCdisI+IvLhzTvAgJfsNsLYZnqjRiqLQ=
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
Subject: [PATCH 5.10 1355/1848] perf c2c: Fix documented default coalesce fields
Date: Wed, 18 Nov 2026 15:56:33 +0100
Message-ID: <20261118150016.351954951@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c81d72e3eecf4..405a20be8508a 100644
--- a/tools/perf/Documentation/perf-c2c.txt
+++ b/tools/perf/Documentation/perf-c2c.txt
@@ -269,7 +269,7 @@ output fields set for caheline offsets output:
              Code address, Code symbol, Shared Object, Source line
   dso   - coalesced by shared object
 
-By default the coalescing is setup with 'pid,iaddr'.
+By default, coalescing uses `iaddr`.
 
 STDIO OUTPUT
 ------------
-- 
2.53.0



