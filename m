Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0963161AD;
	Thu, 16 Jul 2026 14:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211667; cv=none; b=Udi07mv269PfAXMmkmc6/W7Ft5wMt89Xbu3jZCvPUBc+vBkLz+p54qeJ4CFJKJahWm/IEAkMfgccpWE+hMKNTJCchfiVVlnZ/Us/zG2HfHvyfNgRt/TGWyMov9le9dnNkd4nGnL/iPm0IzBwpeNf3RQIKdMI3YnR+DYZ3cMP6PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211667; c=relaxed/simple;
	bh=Bm0EVJ/KFLp6Ek1H+61ZJp75NA5OQwxa782Ejpv9gaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5ZvbMlyx9dXWS+PPlTbanfYAvuwfq6XNeIfrPUK0xcmA27LzdezdeIaA8D/9Tsy+46dWQx6vX/IuTu7GWIARgzaIl+MVQkaOfEAn2Xm0/GBxsGdS6jUPqt4cGUy1psg4v4PKjNsN7ftkO92WB9+EVZXS9CQiIxTZ1tdQsz/8B8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MreRj+0j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MreRj+0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5541F000E9;
	Thu, 16 Jul 2026 14:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211666;
	bh=iRjF+VMrQuhUIs5FGyhgvi0bhIGbxNSK7cffuwD6clU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MreRj+0jxXJN4asNk6QORQKjVOSEsrlRGAmte8kKNKZ2Wf5K36Ctor9ZTf3jHINwJ
	 ZPH/8UG01TCVCQlqpApsAtHyVIQMoQRv7FTGnGaQTaepTeomfHtA5vdNaw4XSO35+5
	 xHcCdD7QNfX6FbWMYLXfsFmXtaLTZfhlMij7j6DY=
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
Subject: [PATCH 6.12 033/349] perf trace beauty fcntl: Fix build with older kernel headers
Date: Thu, 16 Jul 2026 15:29:27 +0200
Message-ID: <20260716133034.051011875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 #include <linux/fcntl.h>
 
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


