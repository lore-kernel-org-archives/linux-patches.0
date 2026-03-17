Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5327726FD9B;
	Tue, 17 Mar 2026 17:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767530; cv=none; b=A5PAaD2lKStNFGMUDuxXBEqo76IHZByBQxIuuS2CDDSLcr3Lzl48cJwS1PK0u6zIsc7XS2sDT4ARkZQiegJM2eRTX6XIA/xUnzneFvpZ8/RDZrrYRlhBHCgLCWfqRBDfnXqSyHT13kWiDGZZD61/78+e8UtOl55Oe5M/sIBdYBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767530; c=relaxed/simple;
	bh=oo2NbstKB/aAepC2Rp4mlsF4OXsUSkh06IizCHoKNgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKrbzDbO2lVmud+H6DXEEsideRNH657CEzkJREwie9O/v/9/y8y4HA2xETPqcXacl1H/jJ7SLzNvkx+adHDRy/y+rsZpOwRnq6C2hbnkelLyx7MGQfge+ZJcJTlHl9+r8ORf+pynzfhEEyRlTb7rha+uWfs/lvpntXxiRjBsOAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7zu+p+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7zu+p+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244B3C4CEF7;
	Tue, 17 Mar 2026 17:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767530;
	bh=oo2NbstKB/aAepC2Rp4mlsF4OXsUSkh06IizCHoKNgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i7zu+p+SCogcuhtNVBuCgtxUkl7mUEEx+BgcLK5fG1LiaqgoheHlkxG2DJZb7LY3U
	 opaRgLcCidsiil3Z8CCGWfLHTHsAjuQESM3rNiKquOQcR2QlOiclwBRxxjryPZ9yl9
	 sm7e1Wo//6ISGu355dbrzLe13BH3qWq/LDeG/WYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Chen Ni <nichen@iscas.ac.cn>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Tianyou Li <tianyou.li@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 073/333] perf annotate: Fix hashmap__new() error checking
Date: Tue, 17 Mar 2026 17:31:42 +0100
Message-ID: <20260317163002.083518212@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit bf29cb3641b80bac759c3332b02e0b270e16bf94 ]

The hashmap__new() function never returns NULL, it returns error
pointers. Fix the error checking to match.

Additionally, set src->samples to NULL to prevent any later code from
accidentally using the error pointer.

Fixes: d3e7cad6f36d9e80 ("perf annotate: Add a hashmap for symbol histogram")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tianyou Li <tianyou.li@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/annotate.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index dc80d922f450d..8c493608291c2 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -44,6 +44,7 @@
 #include "strbuf.h"
 #include <regex.h>
 #include <linux/bitops.h>
+#include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/zalloc.h>
@@ -137,8 +138,10 @@ static int annotated_source__alloc_histograms(struct annotated_source *src,
 		return -1;
 
 	src->samples = hashmap__new(sym_hist_hash, sym_hist_equal, NULL);
-	if (src->samples == NULL)
+	if (IS_ERR(src->samples)) {
 		zfree(&src->histograms);
+		src->samples = NULL;
+	}
 
 	return src->histograms ? 0 : -1;
 }
-- 
2.51.0



