Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD20330B20;
	Fri, 17 Oct 2025 15:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716264; cv=none; b=ekIGakj1A99BUqykImXQSLRn1Bj50C6QMakT/9gCMb8LEhZTFnLzq1ucGMsGnijrSBZtmTTkv8iH/ug1eVB/l5Xs2NE5sS/xdUIvW9AArYRTPNG8qc+K0OKIGjgfcG2eYuPZeBcAXx8hJdy7bGxAhKVKwzj3n75tH3u8QxCiiIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716264; c=relaxed/simple;
	bh=lFWowcWNwKepT+xT7JGSXJ7z4LAWoWhO3de49c2bAzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gyg1rThfxd0Y59lbYFZ55kpJXvOhlCUO+kbIYnh8WW6X/X+AqLUPXwnBpVJrkBeYt/zpTy+zf5lO6S6XPC3LsuFGAyFm9j3/ZT70myAL2XbueP19q6VWOq3NRefakTsVuTGudyvRj8JB6tkDMaapxg4GKs6p7BLlg9r9eq0o5II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0EobsqMd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0EobsqMd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14FDC4CEFE;
	Fri, 17 Oct 2025 15:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716264;
	bh=lFWowcWNwKepT+xT7JGSXJ7z4LAWoWhO3de49c2bAzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0EobsqMdhrMSNf+OS3HqqTfgrlX8iavRYaAS6zbcWd8wkl11qmbKwVYOeLCLp2AaC
	 Uam43QGGSR3X0ZJ0qmyTH0P0DfvjDPL6JImkq02gp9Rv/QmHM6q3knY0hB1H08oFr7
	 sjf3beVeEXjhuRckHZn13jETTCMxYRzXhvlRXeE4=
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
Subject: [PATCH 5.15 130/276] perf arm_spe: Correct setting remote access
Date: Fri, 17 Oct 2025 16:53:43 +0200
Message-ID: <20251017145147.228493085@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7b16898af4e7f..9e7e56596c60e 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -417,7 +417,7 @@ static void arm_spe__synth_data_source_generic(const struct arm_spe_record *reco
 	}
 
 	if (record->type & ARM_SPE_REMOTE_ACCESS)
-		data_src->mem_lvl |= PERF_MEM_LVL_REM_CCE1;
+		data_src->mem_remote = PERF_MEM_REMOTE_REMOTE;
 }
 
 static u64 arm_spe__synth_data_source(const struct arm_spe_record *record, u64 midr)
-- 
2.51.0



