Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030566;
	b=mH6IMMLHqtAjyG9GpuT2hP1U4HgTpXBFVYHR0rM1BaMHqe2tw9bg28cHpuo+9v6aItDk
	 8eRmNKbDPvAAjuoXofpEAZnlSNFE1A+eMxo8opJMui7T6216dk6xgMQWhATpcc3DOA97Z
	 Sqfuwwf6Xst9IQ1KAPTFpaFbj1wWp6dUOZ4FFgWDh/qFxwmbn7Yp4c6fOqCfJUDQfJMbP
	 trL0+MPcUfhzqmop2APDjnW0hfd68vwoAzG48Ov090pFIFxds0L0FzaTlGf4kkiwh8U9C
	 7ao8SgfLWFZk/74UAfRStE9m9NDFLD0/W+piuY/kHWrhM7B0TZjunjBNirFUjuPekfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030566;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jvChcT+CZR4hp4tRT84+rLgGN88+XuyyL4d/150PSRk=;
	b=z9jo6t1ehVa4sRDxUIsqFEYTN1orfvyGqkEZCUmn5ypsmlyWjUID8jtcLeD8ZAqXTpR4
	 ll0mAnYb8H7utKxQtgu70xAUKxA1d5BUlAKRMn3MFRNR4BIqOSRNwtxtqwehgQgWylqDe
	 DU4ylJvK8CKJz9n62hAoK2Q+OecLWsZ1otQe6GIuhDaXJ0wy30DeSlaOGaKZ9YVIBirRF
	 TPW0GTssczw0k2IYiaoNY0+qz5YCv0yMqJ8qAissruclp3J2cykpaI0YP4lDRFgacA5jD
	 K9/l2w9OilZ/7V2pCJHz2WxVD+4jC4AqNrRj/uI8MiFnNvD5v1LX2UNr8EnLayJy5NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=splqznEb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50632606E7C5;
	Wed, 18 Nov 2026 19:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=splqznEb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB451F000C4;
	Wed, 18 Nov 2026 19:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030565;
	bh=jvChcT+CZR4hp4tRT84+rLgGN88+XuyyL4d/150PSRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=splqznEbGsa+AO+DN6Y6FqIzC4d/gqJ6NSmQFopwZ6z+jmZUzmgCh7qN6at4b2cd2
	 /QVFzvVakv5BlYSMejjaYCBu8t0vy4SRtAG5GD3gpevjn1+fnafD/1hT1tEWMZ7a+v
	 iHZrHyuQ8fYZcl/Ycn/xU8GaBtJHS2qCCHN97TqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0743/1756] perf bpf: Move the LIBBPF_CURRENT_VERSION_GEQ macro to bpf-utils.h
Date: Wed, 18 Nov 2026 15:47:50 +0100
Message-ID: <20261118150039.176044928@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 5a022bf88fb0f4edde14b1f6f9029d96bffbf3e6 ]

We need it to fix some other libbpf version dependent issues when
building with LIBBPF_DYNAMIC=1.

Reviewed-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 1fdf657871b9 ("perf thread_map: Add thread_map__tgid()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-filter.c | 1 +
 tools/perf/util/bpf-utils.h  | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/tools/perf/util/bpf-filter.c b/tools/perf/util/bpf-filter.c
index a4fdf6911ec1c..535290000c447 100644
--- a/tools/perf/util/bpf-filter.c
+++ b/tools/perf/util/bpf-filter.c
@@ -55,6 +55,7 @@
 #include "util/debug.h"
 #include "util/evsel.h"
 #include "util/target.h"
+#include "util/bpf-utils.h"
 
 #include "util/bpf-filter.h"
 #include <util/bpf-filter-flex.h>
diff --git a/tools/perf/util/bpf-utils.h b/tools/perf/util/bpf-utils.h
index 86a5055cdfad6..eafc43b8731f1 100644
--- a/tools/perf/util/bpf-utils.h
+++ b/tools/perf/util/bpf-utils.h
@@ -8,6 +8,11 @@
 #ifdef HAVE_LIBBPF_SUPPORT
 
 #include <bpf/libbpf.h>
+#include <bpf/libbpf_version.h>
+
+#define LIBBPF_CURRENT_VERSION_GEQ(major, minor)                       \
+       (LIBBPF_MAJOR_VERSION > (major) ||                              \
+        (LIBBPF_MAJOR_VERSION == (major) && LIBBPF_MINOR_VERSION >= (minor)))
 
 /*
  * Get bpf_prog_info in continuous memory
-- 
2.53.0



