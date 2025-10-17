Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7541D32C957;
	Fri, 17 Oct 2025 15:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714090; cv=none; b=fuj4hJrH7UIYMvPzA1MbQ2fzfFFFgij6PDx/Xxm8GWS5DE8aY1IVqH6tZgtLJfpma17ANrhGCXQ6k3jGXrxfZp3anHsOVH4bUBuZYoPOpI4Q101Ivn5G7nvhE1OQuefdDW42is65m6Llje3CTdvLO9CN/l2QFClzGPz0IjAfsx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714090; c=relaxed/simple;
	bh=STTE/AOKuzM53F9RNIPePIgjEPllAMQ39kYzcvFtko0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qRSHl6A6twjt3Mbw5l69VEL1AkzCQdnCHyvS+vhKYgJHcYkPdkRGWrrPs2pzWo035R8+iSScRPcAGzi+N282avsj5sPfRwp/lfcxlMqASQgF58yekstb3wzy9y+jVtTarIlkbNx4b1bI5okSyM9pjZPgFJmXbXp3rjx/FL9+jjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJ+MwQU8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJ+MwQU8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9618C4CEE7;
	Fri, 17 Oct 2025 15:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714090;
	bh=STTE/AOKuzM53F9RNIPePIgjEPllAMQ39kYzcvFtko0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJ+MwQU8uqoIIfKcIpITQhe0UBYODUszAY8Ki0AJv096Xt4SLoTO9LnC+D0KqTxBW
	 y1oTy0dVnvXq9QtGuuuHP/qTrp69HxS+w76P38EqfD991JFUGqWGeUHjfPLG6nRXQp
	 Xp4JKH30sPM6pdEZV1UKhObCfl76LlWvju4tIfkc=
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
Subject: [PATCH 6.12 023/277] perf arm_spe: Correct setting remote access
Date: Fri, 17 Oct 2025 16:50:30 +0200
Message-ID: <20251017145147.994884084@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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
index 2c06f2a85400e..921b1c6e11379 100644
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



