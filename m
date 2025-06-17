Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A038C285079;
	Tue, 17 Jun 2025 16:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178525; cv=none; b=g0h15ROna3N22LhILNdZFSZ2ci5x3j2SmyEEcBvP6JZ+GemUeXCsktHunwnAjCsG593gaYO6Og7QSvOJY8XpLW9P8P6HrNVXTBqlola+Rq7HirDum/y+UIycfKc2Ll9HuXaN9Cnq4ItQXWTsK5H9uLQZt7eQuwebN5UXYZkaWfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178525; c=relaxed/simple;
	bh=Q5BWIfSIBwlCYQshA5R6avMIZpVCHIv4VPcZydIg0YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVkuebv3QJ+UZXkgg0nZgr73zKN9g+KzofHu3dFnm+yVEJrCtL2af9JGbsbd1pdyODoa93FdTeV52qmNfNzcLgXVsWpP9+DaavOvVpBiTgLk/zV0/t+fgilYWTTI6iVf3oXeNPar9EKLfD3sVnfeiSj6CUBf0y89C7IwsF1rKXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDfrFipO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDfrFipO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2D6C4CEE3;
	Tue, 17 Jun 2025 16:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178525;
	bh=Q5BWIfSIBwlCYQshA5R6avMIZpVCHIv4VPcZydIg0YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VDfrFipOJtFIvxjjxuKGUuypVQ7OcbGlE01geWaNi1SEWGovrAIVIYNKns/AzpE5w
	 BatUiSCDsej5YcprBVlGMQER/n1vQjh905EQsGB20ojhWXVw2Z4dd/KJmuWF4IpOAR
	 uyTlX1JFIXgYqoev42GlBpIYr82tLVj7KOBaYFh4=
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
Subject: [PATCH 6.15 472/780] perf record: Fix incorrect --user-regs comments
Date: Tue, 17 Jun 2025 17:23:00 +0200
Message-ID: <20250617152510.712169307@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index ba20bf7c011d7..d56273a0e241c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -3480,7 +3480,7 @@ static struct option __record_options[] = {
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



