Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13E2336EC2;
	Fri, 17 Oct 2025 15:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713577; cv=none; b=UGMmxiHPtwc29yeCWaqvjje4d1RsRs5W5/caZkd1xNnI9U1SYUZR9U7s9ef1SyvRGyAKnEtqVCkTGqlM+zUViZBXqpA4En01PHv2M+xiI+8Oadope2io3fslrPIj8Eh6u0cCIWT2kTW3O870iQjgMnaGkqAZkqa0K5QDoea0264=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713577; c=relaxed/simple;
	bh=d9I0yZyQEh5rSbN2B8ugYI/Io5O+Rh4tMhkELTeJIQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dTm/CtuHMqpyr1yj/OhaXqtvNhGlTrmPyO9jV/pdCD8sq4JCANXnvpGJ5F9SHVGq9ER2Wvt1nJqHLIbzjf6ej2NngLxbw0rZBsR6CCqNCvCetXBljQEWXGjCSY8uXQ1orpoHTX8D57K3zQcNnnhRpJoREDQTBmCQexCydz71aRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kz/B7YDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kz/B7YDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B41DC4CEFE;
	Fri, 17 Oct 2025 15:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713576;
	bh=d9I0yZyQEh5rSbN2B8ugYI/Io5O+Rh4tMhkELTeJIQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kz/B7YDkpliCvnz67hpEzRyZ/Xfrnb75TFpxDW2DslRI3Rjtnltaiv+7tECT8hyXW
	 frAmbVivDEAy85OtVU7jwpJ6UCSw/8vadd5P7EjXmYftZU5OvpGJ5HCGMHVrvDjNTD
	 J2Hbmi3xX+7kNVFcJzNVow0CB4ESsESfThgOv1Fc=
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
Subject: [PATCH 6.6 013/201] perf arm_spe: Correct setting remote access
Date: Fri, 17 Oct 2025 16:51:14 +0200
Message-ID: <20251017145135.220317452@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
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
index 9848310cee5f3..0faa4cfaf1f91 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -514,7 +514,7 @@ static void arm_spe__synth_data_source_generic(const struct arm_spe_record *reco
 	}
 
 	if (record->type & ARM_SPE_REMOTE_ACCESS)
-		data_src->mem_lvl |= PERF_MEM_LVL_REM_CCE1;
+		data_src->mem_remote = PERF_MEM_REMOTE_REMOTE;
 }
 
 static u64 arm_spe__synth_data_source(const struct arm_spe_record *record, u64 midr)
-- 
2.51.0



