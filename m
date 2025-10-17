Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A52F3370FB;
	Fri, 17 Oct 2025 14:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760712997; cv=none; b=dNPHPxoKv5pkf7PlgKvmdldVWfskSkFgoOTUIIct5MsqFP3GDv0IsVj2y3f1WJ6VZ5IbRg5anx1cChkVbWrjBCp3jX/j2p9a14D4DQ5KfegUYctNiJ7Qvyn6RRUAHDfjpoVXDaD9tk1/PB5pNuIHVMhWjHxnOnjV333e8+nyUVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760712997; c=relaxed/simple;
	bh=aZZwKnacziJUjcoR8aYz6ZgqqQ0jxFFoHixlVTbMGLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mv8smHwNCYMd5NlpXXj1RCkBSSrjf4V8JNi4b1QfAhzMSQKMxtLnZnGOnUquOJWb7paiya+3gz+QCErsrEJnRTUM+fwRG0peVZuef8xnW0pwimS+eyxIa4K5Uf7VkxBOeTK9EgDpOHaxWZL8e5njyYDD5sbkVye4DPsmuCS7Igw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBVwSv7v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBVwSv7v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A848C4CEE7;
	Fri, 17 Oct 2025 14:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760712996;
	bh=aZZwKnacziJUjcoR8aYz6ZgqqQ0jxFFoHixlVTbMGLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBVwSv7vIKs9vUdoSssoqmbNdZxUzmXCInb5av5R2bslTyKVW9yFZLuv4bXm1ESts
	 EOjzlBgP1CU2WsPbR4CXLEMLH9Lz7sE/0OwNRAX9zYj89dKESLXtSfIv8jWMPv2/fN
	 tnPw/jCZ0JL56Vm8waqoy7a7J1gh8IsEUh3c6iMc=
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
Subject: [PATCH 6.1 012/168] perf arm_spe: Correct setting remote access
Date: Fri, 17 Oct 2025 16:51:31 +0200
Message-ID: <20251017145129.466696764@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 906476a839e1f..98e3c3fce05a2 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -492,7 +492,7 @@ static void arm_spe__synth_data_source_generic(const struct arm_spe_record *reco
 	}
 
 	if (record->type & ARM_SPE_REMOTE_ACCESS)
-		data_src->mem_lvl |= PERF_MEM_LVL_REM_CCE1;
+		data_src->mem_remote = PERF_MEM_REMOTE_REMOTE;
 }
 
 static u64 arm_spe__synth_data_source(const struct arm_spe_record *record, u64 midr)
-- 
2.51.0



