Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B30D2EA14D;
	Tue, 17 Jun 2025 15:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175740; cv=none; b=CGykGGpf7AecWQMOpeLzQASpdj9M6IdpSDc9aas0YvTdO6bRdp/R3TN+SbuzNpybf6xKjGbOgH3Y/G43bcnURZCtO32uniQCLwzzmjbBRxMKJ9ZBgBr8wc95hNMFr41JvfTXU7jfHHDiQqfIHeZt+Q3y+JEm9WlFksNdroj23AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175740; c=relaxed/simple;
	bh=KKIvWSatVogonE2dcE+3GeR96DSCk+TRVsXJbJhZ3Dk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqPifgC/xbvrq1XadDfTqYuRgVv11OYR6NJeG0Nx8DDjxagYGljWUF+p1d5UtLo9S5Fc0X5HZvm01R5I7jp98aM9Th5YV2rZvM3f1h9KBV053fDrubpGf2z9YhzcyEiyMcyfdSazNtqHoC7gC4eMgUrcw9ZpHU0S/AgjxQMFRU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqsRkEk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqsRkEk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF08FC4CEF0;
	Tue, 17 Jun 2025 15:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175740;
	bh=KKIvWSatVogonE2dcE+3GeR96DSCk+TRVsXJbJhZ3Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yqsRkEk/o9phcpWeICxXEZyEX8AGPGciMx00Flj5B98JRhVj/ATW6Ja2M04U+T3f2
	 biDYAWm/XWVAeCTfZnzpS6F2c4nY3U/SitPjCXmo13+iBvsb2DDbgg3i1IQPtncG/r
	 M+7ZSD2Z6rGZYjsVdNU+fp47LXscfF2s6Vjfzz1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Tony Jones <tonyj@suse.de>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 209/356] perf scripts python: exported-sql-viewer.py: Fix pattern matching with Python 3
Date: Tue, 17 Jun 2025 17:25:24 +0200
Message-ID: <20250617152346.624229199@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 17e548405a81665fd14cee960db7d093d1396400 ]

The script allows the user to enter patterns to find symbols.

The pattern matching characters are converted for use in SQL.

For PostgreSQL the conversion involves using the Python maketrans()
method which is slightly different in Python 3 compared with Python 2.

Fix to work in Python 3.

Fixes: beda0e725e5f06ac ("perf script python: Add Python3 support to exported-sql-viewer.py")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Tony Jones <tonyj@suse.de>
Link: https://lore.kernel.org/r/20250512093932.79854-4-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/scripts/python/exported-sql-viewer.py | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/scripts/python/exported-sql-viewer.py b/tools/perf/scripts/python/exported-sql-viewer.py
index 13f2d8a816109..99742013676b3 100755
--- a/tools/perf/scripts/python/exported-sql-viewer.py
+++ b/tools/perf/scripts/python/exported-sql-viewer.py
@@ -680,7 +680,10 @@ class CallGraphModelBase(TreeModel):
 				s = value.replace("%", "\%")
 				s = s.replace("_", "\_")
 				# Translate * and ? into SQL LIKE pattern characters % and _
-				trans = string.maketrans("*?", "%_")
+				if sys.version_info[0] == 3:
+					trans = str.maketrans("*?", "%_")
+				else:
+					trans = string.maketrans("*?", "%_")
 				match = " LIKE '" + str(s).translate(trans) + "'"
 			else:
 				match = " GLOB '" + str(value) + "'"
-- 
2.39.5



