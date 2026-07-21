Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD1D441616;
	Tue, 21 Jul 2026 22:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673104; cv=none; b=F9QAZS44tKPW/4h/5l+1NLsV0xvTm13UCnkoMYQEvRlEQyvMMDM20O5XEGVphrCdT/iXi1PTNcQxLhPj8WKCultRyWSgi7u/VWwZJ4tLirET+Dcb4pNCMkL/aSETgSi5w4Iw4i3eDoRwid1u20nfSuEhsyOstd6F/NDGqIF9n5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673104; c=relaxed/simple;
	bh=8PmhEtFnRBTNJMj/U5l9fjXF2JFpG9Yj6tImbwA130o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qHFoBWbgayG+wsKhBWwMixRmyj95yw7oUtwlON3+rpz+zdW6xN6ZtVt9+sO7uSv3Wepgj9ItulK1fbb0lYkkuwSAJ5UBDTw2/3HB2wPEjKunyDbgCpOr3KCQ6u/UpvJYO4J5DukKoyrn1LDk5qENoMzYy8GAR2dyD5S6U02esT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xgYzNkat; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xgYzNkat"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36C81F000E9;
	Tue, 21 Jul 2026 22:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673103;
	bh=Z1o8wEMaGs/uQv3ZU11DfN3aAHCwnTYw/yzoiZyBG/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xgYzNkatXoPdTFh9uefrRwreYvLWA+slcI6avinwC1ighBFU3deQ1PlkkggHGXK7e
	 +y+UBq9vlKZYYOAry+zlvVe50BnsCwBiHm0+i/vNvmaWhnSH1VW8qFR1K+5dNPqMrc
	 eyYNCxzc9ZFFxChxehujjrJGLqLh9fvT3/NP/Ctw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Markus Mayer <mmayer@broadcom.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 010/699] perf trace beauty fcntl: Fix build with older kernel headers
Date: Tue, 21 Jul 2026 17:16:09 +0200
Message-ID: <20260721152355.912181197@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

commit 7ee7f48413c42b90230de4a8e40898b757bc8e82 upstream.

Toolchains with older kernel headers that do not include upstream commit
c75b1d9421f80f41 ("fs: add fcntl() interface for setting/getting write
life time hints") will now fail to build perf due to missing definitions
for F_GET_RW_HINT/F_SET_RW_HINT/F_GET_FILE_RW_HINT/F_SET_FILE_RW_HINT.

Provide a fallback definition for these when they are not already
defined.

Fixes: 9c47f66748381ecb ("perf trace beauty fcntl: Basic 'arg' beautifier")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Markus Mayer <mmayer@broadcom.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/trace/beauty/fcntl.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/tools/perf/trace/beauty/fcntl.c
+++ b/tools/perf/trace/beauty/fcntl.c
@@ -9,6 +9,22 @@
 #include <linux/kernel.h>
 #include <uapi/linux/fcntl.h>
 
+#ifndef F_GET_RW_HINT
+#define F_GET_RW_HINT		(F_LINUX_SPECIFIC_BASE + 11)
+#endif
+
+#ifndef F_SET_RW_HINT
+#define F_SET_RW_HINT		(F_LINUX_SPECIFIC_BASE + 12)
+#endif
+
+#ifndef F_GET_FILE_RW_HINT
+#define F_GET_FILE_RW_HINT	(F_LINUX_SPECIFIC_BASE + 13)
+#endif
+
+#ifndef F_SET_FILE_RW_HINT
+#define F_SET_FILE_RW_HINT	(F_LINUX_SPECIFIC_BASE + 14)
+#endif
+
 static size_t fcntl__scnprintf_getfd(unsigned long val, char *bf, size_t size, bool show_prefix)
 {
 	return val ? scnprintf(bf, size, "%s", "0") :


