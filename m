Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024033;
	b=unXlMoBkg+/DaBFSAOuvFce45U9txkDnVa0K3+9Fp/3nr/lbBnbi+NeMZrVDJhBNNvVM
	 wHT82afTVAcnw13yUiN7xdoA9JNV7qKTL/bhcNX+9Tdky1XWPOP1drZI1tGgdem0Hvo42
	 ZrSdYdo1W9T3vM6Do2tKl1uzSvpE02XWBpHpWwfSKIX/1XcBgoRWrBBp+Qc+MiyRa3mII
	 9VOcLwhekl8ee+aAhIn7ewr3gvNm3tnCCbKQIEUbL2IBHkhzH6Ndodep6NWWqlGt9j9k/
	 6WuCqoXdo06jBEuENU1slJGq5AaqPln/Gtx89Ro0tI1Iwe53Gmcth/qGOJo3JkFynng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WWlgBzG3NRHXDl0jrYQBxL+V3MUdfTDHwAc+lBP/84M=;
	b=q3xOuM1Ogm3Va1mmHJpe19TpAie1n6k0oR6NgrT0Uasg+u69AOdQsEjScUauJSnplrMM
	 dhl2uEZsl1Mk8LeGVfyXpeSANZNIsC4hbbutSKxh17ceLi/9tD1+NIeeiqs84gpJmRgfp
	 7mi2Z3RXDlFxffnM9AWehwB0IgGVrI/WQXB+3S5ixy1JCY9MqLMus8/wR3XUj+DtX+o1Y
	 y5fweiftdTtnj1h3RUvsdHS79LoM6GYd5LD7VOJ7/FIm9dxzUglsamdS5IBNtR9ZF3aqt
	 ZYIiL+G3oJwHYCxEOPGLVKv5njL02NHkf9ENGkVv7uXVHxldMnjssc5nQCeLvdW4Pgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zcz1fL5l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A103606A31C;
	Wed, 18 Nov 2026 17:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zcz1fL5l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456A51F000C4;
	Wed, 18 Nov 2026 17:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024032;
	bh=WWlgBzG3NRHXDl0jrYQBxL+V3MUdfTDHwAc+lBP/84M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zcz1fL5lxUgkHRz2unCOUUmFgITbR3LSvsNfG8w1dxJzBsC34NN6RvTrp+vUQi4+l
	 AbYvWYF3OmQ+XArqvrF4Uv2lrDIRcLcA9Fahi8L8VoYtM9UmMSuXSR7EwlLGAri/YN
	 cEDbEwEXJGw5T0gSC1CuJOEniH3kD3uot/oM9poM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Derek Foreman <derek.foreman@collabora.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0581/2151] perf check: Add libbabeltrace to the listed features
Date: Wed, 18 Nov 2026 15:38:36 +0100
Message-ID: <20261118150143.120380962@linuxfoundation.org>
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

[ Upstream commit 8772598b7801a2bb235bd35a858017e0fb939c38 ]

This enables scripts to more easily determine if `perf data --to-ctf`
is supported.

Committer testing:

  $ perf check feature libbabeltrace
         libbabeltrace: [ on  ]  # HAVE_LIBBABELTRACE_SUPPORT
  $ perf check feature -q libbabeltrace && echo have libbabeltrace support
  have libbabeltrace support
  $

Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Derek Foreman <derek.foreman@collabora.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: a5cac2df8b4a ("perf build: Remove leftovers of removed build options")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-check.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-check.c b/tools/perf/builtin-check.c
index d19769a8f6897..a6e4cc6bd51a4 100644
--- a/tools/perf/builtin-check.c
+++ b/tools/perf/builtin-check.c
@@ -43,6 +43,7 @@ struct feature_status supported_features[] = {
 	FEATURE_STATUS("dwarf_getlocations", HAVE_LIBDW_SUPPORT),
 	FEATURE_STATUS("dwarf-unwind", HAVE_DWARF_UNWIND_SUPPORT),
 	FEATURE_STATUS_TIP("libbfd", HAVE_LIBBFD_SUPPORT, "Deprecated, license incompatibility, use BUILD_NONDISTRO=1 and install binutils-dev[el]"),
+	FEATURE_STATUS("libbabeltrace", HAVE_LIBBABELTRACE_SUPPORT),
 	FEATURE_STATUS("libbpf-strings", HAVE_LIBBPF_STRINGS_SUPPORT),
 	FEATURE_STATUS("libcapstone", HAVE_LIBCAPSTONE_SUPPORT),
 	FEATURE_STATUS("libdw-dwarf-unwind", HAVE_LIBDW_SUPPORT),
-- 
2.53.0



