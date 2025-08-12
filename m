Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D002C21F6;
	Tue, 12 Aug 2025 18:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024527; cv=none; b=MzS/mPhKKCRVZlTk52yqLq6VuJsk7dCnzK7ozIxGE281DEsUPkhKLDlvtqrL2ETxcUEcUB0oZHf5GHkNDIGyZXSL9nfFPu1HkiyMDzB55tjnha+MB0oRLwPgFbH+L7l5KCJ+vZiMSfR8GBfZQH6lPC0j2hTq/ncJJHcDRDbl2eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024527; c=relaxed/simple;
	bh=D/v1IojSKKjeugYF8GOTYYKPGhqGdcCbNHUjvB4CPnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bc7cpYjbW1X7iNkdvOIbH+bKyiYdih1UPuuVIbAhLuL6zDp8ZQK8RluV+7mGyFFkpac7U94ptj/BG3Ol3uC+OafW83gUFEYSb0TDbjyNk7LR6+zydVvNKRDwmI1jEwOuGmv23halhcWSbztpQM0aVBOGLfZD0TaGFO8ILY/DgII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UioSlpld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UioSlpld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7EFC4CEF0;
	Tue, 12 Aug 2025 18:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024526;
	bh=D/v1IojSKKjeugYF8GOTYYKPGhqGdcCbNHUjvB4CPnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UioSlpldYp3CfdWLgOKdJ0Hp0VC2C+PTgNuBDgMLeySaQpkUJs14FYGnIxgq3kloG
	 b6ONUMa2I7I2+4IjFzDktz6kpWz6KM3JbDutjrGzD1yuaA5aQY15KuenzsRbMxyYzK
	 olfar1NspGeqjSLZ5YW9mIn48gpwBCHaP+QNMh98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 382/627] perf hwmon_pmu: Avoid shortening hwmon PMU name
Date: Tue, 12 Aug 2025 19:31:17 +0200
Message-ID: <20250812173433.826782160@linuxfoundation.org>
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

[ Upstream commit 28f5aa8184c9c9b8eab35fa3884c416fe75e88e4 ]

Long names like ucsi_source_psy_USBC000:001 when prefixed with hwmon_
exceed the buffer size and the last digit is lost. This causes
confusion with similar names like ucsi_source_psy_USBC000:002. Extend
the buffer size to avoid this.

Fixes: 53cc0b351ec9 ("perf hwmon_pmu: Add a tool PMU exposing events from hwmon in sysfs")
Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250710235126.1086011-2-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/hwmon_pmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/hwmon_pmu.c b/tools/perf/util/hwmon_pmu.c
index c25e7296f1c1..75683c543994 100644
--- a/tools/perf/util/hwmon_pmu.c
+++ b/tools/perf/util/hwmon_pmu.c
@@ -344,7 +344,7 @@ static int hwmon_pmu__read_events(struct hwmon_pmu *pmu)
 
 struct perf_pmu *hwmon_pmu__new(struct list_head *pmus, int hwmon_dir, const char *sysfs_name, const char *name)
 {
-	char buf[32];
+	char buf[64];
 	struct hwmon_pmu *hwm;
 	__u32 type = PERF_PMU_TYPE_HWMON_START + strtoul(sysfs_name + 5, NULL, 10);
 
-- 
2.39.5



