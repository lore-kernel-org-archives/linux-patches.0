Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024480;
	b=erRqoK/Bu8uYcNsBMlQ04MpSg4yfSkFfxbW5SfOWALn/6nuXio0u/BO2PQbCmj2FTBxF
	 4xiXPryEeE8Up9akYWfa6PW0BICoCnyDEh911eE6IF38G4ymBjk6KHbxXXwaPB6vtldFW
	 5QwCz1gURabBEUzq7xA4yYoCKPj7g/iQfxOVcTQzS4miVythCV2M2Ww7E3XD7c6b6UeoJ
	 YEU4YVdlVW/p83SwBWlGn21FDK8Pok0oBXRSy4iVQtS89J1pkdso4pe1cWXWZBB/IhG7F
	 vPNs2zMaoYY1+kd3blj9Nx2NEuXuNNG7PFwpwFfT6PtSQeBov47OSPfIr1G2kn1t0Mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uITsLQWJfFkGumeZDX4XFJp818/728eKn3Uvwqd039A=;
	b=1/KXbTAFMs5+CcW9GIQMRzALgMIA1ohXZD0kHFVD7Lq/LRYivgNcxlT7CPHn3nXUxHAZ
	 5QNlbOyrO6N/EqDb/cIowhyoL1VZhIvM1fwlULVgM2Eo42I2hGez3JHOkDN/j8GXrqqm0
	 FxLcwQ1y/e8kK4KnCkcqYwAllAAp/ruHQwDN3rraQpX/6Rfkl6zlAkEQX8L9hOhCLMAQJ
	 PJqk9n/Z5sdXimTfbMvAJcaQL4YL3R41p4JkyjxtuoXOUpj0JtcxLNp3boXgQXLcftOxn
	 uyeVsv6i4kcxNx8REHs38uXV7XaGpJ/gXUAgNcePnbFCUpMX88QYd/rM6uDpelEXiZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1a1O0qCx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53257606A320;
	Wed, 18 Nov 2026 17:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1a1O0qCx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651DC1F000CC;
	Wed, 18 Nov 2026 17:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024480;
	bh=uITsLQWJfFkGumeZDX4XFJp818/728eKn3Uvwqd039A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1a1O0qCxaGmiP232JbAS5tr2+C9tXnMqdDhJSPyYZLrTK1SmQC5J0WW4jB497In2t
	 FZ/m73kp0zVhRnw1UE2DWyR8x9DjLFZq7bH/idWBm0xnLoMq9V7Ci8jElNBmE6za6x
	 gZtYrEQxpe6X2bVfLZgrEtxkqD8DvLWniEQ05a28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Leo Yan <leo.yan@linux.dev>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0690/2151] perf mem: Fix size tracking for mem_lvls in perf_script__meminfo_scnprintf()
Date: Wed, 18 Nov 2026 15:40:25 +0100
Message-ID: <20261118150146.930000137@linuxfoundation.org>
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

From: Thomas Falcon <thomas.falcon@intel.com>

[ Upstream commit 06d5ce78e4fea2cf0738da903aa248a81101c155 ]

When printing memory info in perf script, the entire size of the
buffer is passed to perf_mem__lvl_scnprintf() instead of the remaining
size. Pass the remaining buffer size instead.

This issue was detected by sashiko during an internal code review.

Fixes: fdefc3750e847a91 ("perf mem: Print memory operation type")
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Leo Yan <leo.yan@linux.dev>
Assisted-by: Sashiko:gemini-3.1-pro-preview
Signed-off-by: Thomas Falcon <thomas.falcon@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/mem-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/mem-events.c b/tools/perf/util/mem-events.c
index 80b3069427bc4..ae9c78a75fd89 100644
--- a/tools/perf/util/mem-events.c
+++ b/tools/perf/util/mem-events.c
@@ -607,7 +607,7 @@ int perf_script__meminfo_scnprintf(char *out, size_t sz, const struct mem_info *
 	i += scnprintf(out, sz, "|OP ");
 	i += perf_mem__op_scnprintf(out + i, sz - i, mem_info);
 	i += scnprintf(out + i, sz - i, "|LVL ");
-	i += perf_mem__lvl_scnprintf(out + i, sz, mem_info);
+	i += perf_mem__lvl_scnprintf(out + i, sz - i, mem_info);
 	i += scnprintf(out + i, sz - i, "|SNP ");
 	i += perf_mem__snp_scnprintf(out + i, sz - i, mem_info);
 	i += scnprintf(out + i, sz - i, "|TLB ");
-- 
2.53.0



