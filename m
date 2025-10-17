Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6B0219A7A;
	Fri, 17 Oct 2025 15:28:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714934; cv=none; b=Dzbw6pdTCIV/a5rtmb3on4rVCM8iGhwkuux0N5/Z6AJkb58V6LMJC85Re6PC3nOvxAwEJb45GV7AGmxXAjsHxftHgj4j7YdMr/N60pu2zE2lcyJjTp6OAH3wanBLkLZq2gxEy6tdxq9YIRp7c/SAsR2nrgqnlXZnpmW+Ljc4fKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714934; c=relaxed/simple;
	bh=wjkd/Q6hi8joFYdH8VAUSx75W5wpjf3bc1ervLnRfzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbTDQkLH0tYjiam8sfilJtXe1ZrBr4hdsRI/58e1p67FEGCStvrq0ITk9r8WYtV2GP+pMskx4xTLHt1Nxt9UbEYluuTM56RSUESRt9ajrWXLqNCWyQ5lerplI9BUnlCW/Sk0RayALOwJ1f7mnLz1eZawQxV+s/8uH4BSRXzA1Lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cZtln1Fk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cZtln1Fk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A191DC4CEE7;
	Fri, 17 Oct 2025 15:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714934;
	bh=wjkd/Q6hi8joFYdH8VAUSx75W5wpjf3bc1ervLnRfzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cZtln1FkbNm5JyDMve0IuccIvZx8ng+/4IuTaVwNAko/GYKKBHLVL2Zt5XYXfhvjI
	 CtqFPwmJ/5rEcKiQyUHjewzgkYrJKF7ze/rjz4u/BlPzoJYX8gBef92MeQ0rmkNqxA
	 /7jH+l/0cKpLcWQusUux+yoJjtfvE3aOQsXA3lCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ali Saidi <alisaidi@amazon.com>,
	German Gomez <german.gomez@arm.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Will Deacon <will@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 039/371] perf arm_spe: Correct setting remote access
Date: Fri, 17 Oct 2025 16:50:14 +0200
Message-ID: <20251017145203.214810538@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 039fd0634a0629132432632d7ac9a14915406b5c ]

Set the mem_remote field for a remote access to appropriately represent
the event.

Fixes: a89dbc9b988f3ba8 ("perf arm-spe: Set sample's data source field")
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ali Saidi <alisaidi@amazon.com>
Cc: German Gomez <german.gomez@arm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/arm-spe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
index 8942fa598a84f..8ecf7142dcd87 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -839,7 +839,7 @@ static void arm_spe__synth_memory_level(const struct arm_spe_record *record,
 	}
 
 	if (record->type & ARM_SPE_REMOTE_ACCESS)
-		data_src->mem_lvl |= PERF_MEM_LVL_REM_CCE1;
+		data_src->mem_remote = PERF_MEM_REMOTE_REMOTE;
 }
 
 static bool arm_spe__synth_ds(struct arm_spe_queue *speq,
-- 
2.51.0



