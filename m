Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BE41DE4EF;
	Sat, 12 Sep 2026 14:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222487; cv=none; b=CRk6CcRXjmGk4dVReEdYJGXsQ3dkhasVTzP4cGPQI4fJjSPGKvvyMerZKa3ypTMAA3MWjZADmD50vUE9W910VsEAcOoxaGxT3WcxTrBu/RI9IGQxKwE1KF2LXPOBNEb2TX+vjF4D7mrZBARtPCZwc2o5eWEIlhXr2KKrUh/rc7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222487; c=relaxed/simple;
	bh=yE0hvsum9uXoPdEsR7fyB0tE+bEhztvEjTg4p9Ed5gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/86QjpkYSIk9f1d+d15/jx2pSgEGnsTsuePHL3ExMp1y7VOlH81qL8H/wnPLgNYpCdnfJwfTQaI7dV/tzVmKdHkSzQIV5mklH+Z+Eqe53MdktB3Zz/o1Wmgu+KGt2YWrDUCxGNyXjBtPoSZ7UPB+YbHAZzlyomLRrnyCfZCvpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZSFb2Yw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZSFb2Yw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA4821F000FF;
	Sat, 12 Sep 2026 14:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222485;
	bh=+87UFvjw0Z2En1+2bBwTOjlFADSF4uEUXCJcooekM78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tZSFb2YwHC+28OYnCT1nbBGiM2pjZkIt1V/L4O4CDkJzRBG3j/9jU0g47XvrMa4Vw
	 5DHFRcD1GTHALhPGq0Gg+Ly0ZqEW/cBWg3FEQ4StZQ+oJQw0ZZhikyzwlYf6zoX6dS
	 ZUvIyK4hRy8IPHBTTP7wPaVDooZuG8INV5TSLJVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0597/1424] perf test stat_all_metrics: Ensure missing events fail test
Date: Sat, 12 Sep 2026 08:50:29 +0200
Message-ID: <20260912065620.661912276@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



