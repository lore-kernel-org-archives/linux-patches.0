Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852471474CC;
	Tue, 12 Aug 2025 18:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024727; cv=none; b=CseJn7Y8TV9QfiAGVrK5YeRjQ+XILLudAN+agPoU+vAZUK2/zp9PapKdNB/TevGrpd0heY1mRiDK0Xq+IfegHrLXFVG8IzqHbOEieI1VY018EViC35WADd94RmbeWparNpM3TTe75Qm5tJLqhI7o9KHRVlf8jp4nwdyL4hmcbPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024727; c=relaxed/simple;
	bh=JVnQhT/c9gUhPMYQASiYdoaaF5eVLQVUXXV3RyvrD3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3BqgEJEusMgGgMsbB4fDW1n23Ui5lzVxJ01gVM3HehTsHsay0SD5Q2FZFaz8oKQjvLHAr2ZoOYrOLP5bRyZqQRRMg/QIMwm8MePLYxn0qIT2VLfQpb8zZr3CjOl9uyMmPS+NC/RAjUT2SphSbf9rhLILgr076yeOehNMGYX8rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iusniunh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iusniunh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080D9C4CEF0;
	Tue, 12 Aug 2025 18:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024727;
	bh=JVnQhT/c9gUhPMYQASiYdoaaF5eVLQVUXXV3RyvrD3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iusniunh0f781UgTehGoAnJr6mj4YwOi+tZw7eaAr4fFcxhN1mynpyWtgEaU+ho85
	 cHIndCaUYjcNfMDD2W6xHeGMt2J0irVBQ0FPinrlWyIfJEDFXDyLFme54z92AB8kSf
	 W5KThTixFO6rH/7FHkpSa9ZX/uRWY4Ti+0j7EcPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 416/627] perf pmu: Switch FILENAME_MAX to NAME_MAX
Date: Tue, 12 Aug 2025 19:31:51 +0200
Message-ID: <20250812173435.110107337@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 82aac553372cd201b91a8b064be0cd5a501932b2 ]

FILENAME_MAX is the same as PATH_MAX (4kb) in glibc rather than
NAME_MAX's 255. Switch to using NAME_MAX and ensure the '\0' is
accounted for in the path's buffer size.

Fixes: 754baf426e09 ("perf pmu: Change aliases from list to hashmap")
Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250717150855.1032526-2-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/pmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 609828513f6c..55ee17082c7f 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -452,7 +452,7 @@ static struct perf_pmu_alias *perf_pmu__find_alias(struct perf_pmu *pmu,
 {
 	struct perf_pmu_alias *alias;
 	bool has_sysfs_event;
-	char event_file_name[FILENAME_MAX + 8];
+	char event_file_name[NAME_MAX + 8];
 
 	if (hashmap__find(pmu->aliases, name, &alias))
 		return alias;
@@ -752,7 +752,7 @@ static int pmu_aliases_parse(struct perf_pmu *pmu)
 
 static int pmu_aliases_parse_eager(struct perf_pmu *pmu, int sysfs_fd)
 {
-	char path[FILENAME_MAX + 7];
+	char path[NAME_MAX + 8];
 	int ret, events_dir_fd;
 
 	scnprintf(path, sizeof(path), "%s/events", pmu->name);
-- 
2.39.5



