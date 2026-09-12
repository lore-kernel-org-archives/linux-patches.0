Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20BC38AC9A;
	Sat, 12 Sep 2026 12:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214567; cv=none; b=KEYiWWILEfdjag8l87OAQ4RPKWEBvkIAFHHCp0uyQoJ1TYbtEIU2jy/7ASBodUa8hPJalbG+12oIzuBYXlfmU36OahHRmGeL0Q6KjIpAY/lTWLBp8bzxF/GMGajRzj6OSwFEjDQNdhGMeBc5wDX/Eev/+3ehXmvEd4gnm7tChgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214567; c=relaxed/simple;
	bh=iyiWQVYwSY777z10hZ35wq4I4sSrWe1VUAU4OUnLEOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iT/3OZ0/lLh3V/pM/fEcFIGE6WNepX9iUuxjgSV9maJbXgW9LNdsjOGjgYnpJawFE3w/lF3RFcFCu50NSoO7MzDr5i7ZT9iudVeOHF7xWdNfUHDdRfCqBchIEnzygH7BKCXWhoeDlAraOVX5O5Y8zPXdhZ2jcdypdUy+v25dQOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDZxhC1w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDZxhC1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EADE1F000FF;
	Sat, 12 Sep 2026 12:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214565;
	bh=UIfTtHp4szHfbmXfhWUdfQjETTJjtOAD/3jvnSyFDSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VDZxhC1wXhxoh+hxtqA9hX6ZppZFzBDZpfZGffcGkno1XrNc1sYpLiTeyr2gCXOhM
	 q1gKNT3wrnVajmA4p7gGcwNNeQHGWdVfbNhvYOYJ7hPELRnOdMo7NKL23hsED2Rphw
	 bkwH94wjhBr51Hnvn7lL+z/VVxvT4Z2jNWZbzKn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0352/1376] perf test stat_all_metrics: Ensure missing events fail test
Date: Sat, 12 Sep 2026 08:46:18 +0200
Message-ID: <20260912065615.396727630@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 08d9e883481b2c38326ed37314b1f6a1284c03d8 ]

Issue reported by Thomas Falcon and diagnosed by Kan Liang here:
https://lore.kernel.org/lkml/d44036481022c27d83ce0faf8c7f77042baedb34.camel@intel.com/
Metrics with missing events can be erroneously skipped if they contain
FP, AMX or PMM events.

Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Kan Liang <kan.liang@linux.intel.com>
Tested-by: Thomas Falcon <thomas.falcon@intel.com>
Link: https://lore.kernel.org/r/20250211213031.114209-25-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 8953bfd8820b ("perf tests: Skip metrics validation if system-wide recording lacks permission")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat_all_metrics.sh | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/stat_all_metrics.sh b/tools/perf/tests/shell/stat_all_metrics.sh
index 73e9347e88a96..ee817c66da061 100755
--- a/tools/perf/tests/shell/stat_all_metrics.sh
+++ b/tools/perf/tests/shell/stat_all_metrics.sh
@@ -20,7 +20,13 @@ for m in $(perf list --raw-dump metrics); do
   result_err=$?
   if [[ $result_err -gt 0 ]]
   then
-    if [[ "$result" =~ \
+    if [[ "$result" =~ "Cannot resolve IDs for" ]]
+    then
+      echo "Metric contains missing events"
+      echo $result
+      err=1 # Fail
+      continue
+    elif [[ "$result" =~ \
           "Access to performance monitoring and observability operations is limited" ]]
     then
       echo "Permission failure"
-- 
2.53.0



