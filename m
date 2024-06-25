Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5883513C90B;
	Tue, 25 Jun 2024 10:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309739; cv=none; b=uxSNMG7IcqFz84OkEn4nTMLOfS/884DXnvtRbTibCzecXAUTDpExCVK1CjunMBUbZnvg13NN91BvEq4vDFx9vWkUyf2C3+qANQeeBgb65AslxVofxnfIyJDXooUARm51uzC9rqOrs5J7TeqUXgq/1+NE0oshgC4gEpNC195ReR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309739; c=relaxed/simple;
	bh=+Ck5bKH/mTCJLmcDOa9YZSkY1KBQ2P4YN5UXPUTiZO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4QUG/sWpJ2Gmo/LbyzSzvTwRIsI60MN6DKZXq35d/M2ihFH/ugAi1AuE3Zlvj4shvlj2tuDHvFsRu/nlj0MCYUY6F/wnCXJD2YCeGO4HuTNTHdxuRA2+cducA22CmTr2d51ynGvtERaXAaLnEAVRIuiOki4Xy4DfooIjvW8KLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nepbji0T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nepbji0T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79FDC32781;
	Tue, 25 Jun 2024 10:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309739;
	bh=+Ck5bKH/mTCJLmcDOa9YZSkY1KBQ2P4YN5UXPUTiZO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nepbji0Tu9bmxqQ/hw5HFOlq71zbYUd58mQxDlokIqwKUeIYbUCEnvmEV/cGLqmfy
	 Tb7Cpkgj9zBeXRiR2Fu7HubOnRAHae9JZwPNMIvi5UluNMFyp0iZAx6G6wM2wzpoF/
	 gqF91Ntj8v86wY3gMoJXHowIlByn1c95YmDjDpjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Kleen <ak@linux.intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/131] perf script: Show also errors for --insn-trace option
Date: Tue, 25 Jun 2024 11:34:33 +0200
Message-ID: <20240625085530.420309786@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit d4a98b45fbe6d06f4b79ed90d0bb05ced8674c23 ]

The trace could be misleading if trace errors are not taken into
account, so display them also by adding the itrace "e" option.

Note --call-trace and --call-ret-trace already add the itrace "e"
option.

Fixes: b585ebdb5912cf14 ("perf script: Add --insn-trace for instruction decoding")
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240315071334.3478-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-script.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index af91fdcabb05c..999231d64e225 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -3730,7 +3730,7 @@ static int parse_insn_trace(const struct option *opt __maybe_unused,
 	if (ret < 0)
 		return ret;
 
-	itrace_parse_synth_opts(opt, "i0ns", 0);
+	itrace_parse_synth_opts(opt, "i0nse", 0);
 	symbol_conf.nanosecs = true;
 	return 0;
 }
-- 
2.43.0



