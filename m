Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048613;
	b=bSTkjFf75ayhD+/cFp+gOS26TrEPXs0JtxGB9/wJOfJceJjveprunT3Z26iQPtIUAJzN
	 XwCOKPIz4DZREjNcStgNMvDmPhiEf2fuy0UHqrBW+MdvxJWLrmlff7Rc4T22I4Hea8E3v
	 FjBf7YSoGSyjMJi34rMhX0nyNEFKvzEmgtMKR8E4aCv5D6kvck+ivpo4RlS21wEaGzafA
	 1+HOK3ri4rPTjOCdNna4GhPJmCtQNG8+mYNF1kcA09TZm1bgol3G9O+r2LUtf1xb5o3JO
	 y0UdOcPWFR5n8va299ROfZB3RQeuTteMZJz+KwKkmQJtROfaRcaFmTlUyEZzaKEIO2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OriWPH6N0eLa9meijG9mXebVWFsoV3YGtzPPzJyp6Qw=;
	b=PMuBx5FVChOWfECgGvwsAd7YIFZpqfYTE5ywCu7vwp6w8+eEBJQYxl9g2XyFBVl0Mnca
	 d/BehurPEVLwF3kztCwI6fvx/y35x0uts7+QK91UImu66l/EHN1nN0wQtYuDQqZ0qVu/6
	 2NCD/MsI00uKG9HqPk4byaJVKppG8BhUS5PG01OvmPEfqKhlwdshnKQnjrr+7qkgiZ+jd
	 l14vkk2vdgvHEg82WtN6fOVETjFGOjEBBL4Rf5tWZSv3z6izS/e4VvCzG2lkRPs+hs2Jl
	 /qgY+4FW84AcBI+HnJ6aDP8JEqN3tpdz3T7/URVU2UjSgRp1N7nSt2AWBJm0MXu0vzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=egUNevsz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2BB606A320;
	Thu, 19 Nov 2026 00:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=egUNevsz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E681F000C4;
	Thu, 19 Nov 2026 00:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048613;
	bh=OriWPH6N0eLa9meijG9mXebVWFsoV3YGtzPPzJyp6Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=egUNevsz4oxXcC+qHxegLg8qzhHBZtvncR8E0L37pwA+5m5+yPkEnlKZ5fWqeHpw6
	 nqS50U3V+47948KYCSk5p09McaCIaOi8hvdpno+5Uc8lB4Q99yP5s3/o0ZCqt9er+j
	 bmgcaVlTFKmmQ/GdxJn3FNRd1qbr5+caW81O6lE0=
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
Subject: [PATCH 6.1 2057/2857] perf c2c: Fix documented default coalesce fields
Date: Wed, 18 Nov 2026 15:51:31 +0100
Message-ID: <20261118150315.481094193@linuxfoundation.org>
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
index 5c5eb2def83e4..cb3385d910527 100644
--- a/tools/perf/Documentation/perf-c2c.txt
+++ b/tools/perf/Documentation/perf-c2c.txt
@@ -294,7 +294,7 @@ output fields set for cacheline offsets output:
              Code address, Code symbol, Shared Object, Source line
   dso   - coalesced by shared object
 
-By default the coalescing is setup with 'pid,iaddr'.
+By default, coalescing uses `iaddr`.
 
 STDIO OUTPUT
 ------------
-- 
2.53.0



