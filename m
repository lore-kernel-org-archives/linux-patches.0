Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A36570838;
	Mon, 23 Jun 2025 21:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713005; cv=none; b=FpcOAdk9Eyy7UwAtlyx6nHzT7bnxj34LjhCAbzvZlJJlWabewm5eLk/U08Xxf9TCA58rvrjS4Toa6QTSq/nLWtPwzQJEhg1Shx0OjcEKg4QhHBaE8yPNA0w34jWoKXueX3yv+V1FrjHbnF8almcR//l/xgJLUIAKKXe1Fy3Jl9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713005; c=relaxed/simple;
	bh=NlJWI5s7kNfxQcrVFPfLwbwJU/JAAsSLI1ewjvmHfGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnBGrDTeB+P/BaZdWsG4XsDy9OTEnNZszhvLz+59Q4aOhQI03FLYbxKJPE6Om9d3ypShcmGD6DU70JVBmBROsUZBfqMJxHOu3Zk8Uxk+CHcNNl24V6wbu5BXrdP+J9tcqYGl5i/HSM/2MYa/LhvvqGYichdFlrrGeG4Z9jrJWp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDD+GFyI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDD+GFyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DF7C4CEEA;
	Mon, 23 Jun 2025 21:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713004;
	bh=NlJWI5s7kNfxQcrVFPfLwbwJU/JAAsSLI1ewjvmHfGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDD+GFyIYFk4vBfay4afZ3Y80aIcDYjaSY2D6VOAuGf8LXZxixM9NbZtwA408sHsT
	 OZq/1LGr8wDEgWDEdyTztAIJJIrCb//M9gmEvJwgnoHlBhkr0noShVxqaIwvxCYQec
	 UAOy7H8JbaXi+l10BwvGV70Ro0BEPSPopfBRx/GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/411] perf record: Fix incorrect --user-regs comments
Date: Mon, 23 Jun 2025 15:04:04 +0200
Message-ID: <20250623130636.014127177@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit a4a859eb6704a8aa46aa1cec5396c8d41383a26b ]

The comment of "--user-regs" option is not correct, fix it.

"on interrupt," -> "in user space,"

Fixes: 84c417422798c897 ("perf record: Support direct --user-regs arguments")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250403060810.196028-1-dapeng1.mi@linux.intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b92c26f6aa1d7..701592342d150 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -2547,7 +2547,7 @@ static struct option __record_options[] = {
 		    "sample selected machine registers on interrupt,"
 		    " use '-I?' to list register names", parse_intr_regs),
 	OPT_CALLBACK_OPTARG(0, "user-regs", &record.opts.sample_user_regs, NULL, "any register",
-		    "sample selected machine registers on interrupt,"
+		    "sample selected machine registers in user space,"
 		    " use '--user-regs=?' to list register names", parse_user_regs),
 	OPT_BOOLEAN(0, "running-time", &record.opts.running_time,
 		    "Record running/enabled time of read (:S) events"),
-- 
2.39.5



