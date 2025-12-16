Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55E6F355806;
	Tue, 16 Dec 2025 12:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886919; cv=none; b=SJj2vTSeX0pfct0orcVEpzEe5sOoGE/WSfNlDP0evjvYS7yxQKbsBKO6b/69h+ltvcTH7Y6/ks7rYGDOQkE9+LENNBOF31KYMsvRlsHiHKQqTqim8paAAkWmrOJb3yl42w/cNF771fSJL07RM67XhKULA48HOotT3QovgCIjxiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886919; c=relaxed/simple;
	bh=uUc0+4lN71JXXCYeNevgKXna330XwikMG5preszWY4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usqT9Mmd7Bv6j4u+TVZNXQOWDEcXOjfalwKZWL5S2CLh9NGW6mX0befaqGuYqqhg/qI0P58BcwUwd0WBCGhvDnAmKToPx7hcjDF/FD1SMksS4aaIaH8VfnmJoBdsA8uKCeT9CCxTiaBvELAq3Oz8n5nUzMMAcA8kOCPXmItZav4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+GYVZRM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+GYVZRM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B744BC4CEF1;
	Tue, 16 Dec 2025 12:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886919;
	bh=uUc0+4lN71JXXCYeNevgKXna330XwikMG5preszWY4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+GYVZRMV8yEk+d9ElqcZIagyNXKRb7pvxMdGWcjX0HUO4fTbh1nS4JtdgUaz5b6s
	 7Aj3KaA8tbVtIKdBJwnmrnn2YT0qlWljeIwWLsMjsu/3fh8wP8rMguBFD/WtpyahOL
	 NFymha6Kso1AFYGMqBv4ZO1EgWyVIoWsMKpRs7lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Tianyou Li <tianyou.li@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 073/614] perf annotate: Check return value of evsel__get_arch() properly
Date: Tue, 16 Dec 2025 12:07:20 +0100
Message-ID: <20251216111403.960913234@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Tianyou Li <tianyou.li@intel.com>

[ Upstream commit f1204e5846d22fb2fffbd1164eeb19535f306797 ]

Check the error code of evsel__get_arch() in the symbol__annotate().
Previously it checked non-zero value but after the refactoring it does
only for negative values.

Fixes: 0669729eb0afb0cf ("perf annotate: Factor out evsel__get_arch()")
Suggested-by: James Clark <james.clark@linaro.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tianyou Li <tianyou.li@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/annotate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index a2e34f149a074..1d6900033b3a0 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1021,7 +1021,7 @@ int symbol__annotate(struct map_symbol *ms, struct evsel *evsel,
 	int err, nr;
 
 	err = evsel__get_arch(evsel, &arch);
-	if (err < 0)
+	if (err)
 		return err;
 
 	if (parch)
-- 
2.51.0



