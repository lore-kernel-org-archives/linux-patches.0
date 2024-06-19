Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4991E14B95F;
	Wed, 19 Jun 2024 13:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803293; cv=none; b=ktRUCjP4Jxu3Dn+Svhv3XK69mSUsyPH1ZPSiOHBm/U5ihBs2stx6u1SlgD1R8eZNO3bmetJooOOgPc5PmfzaS1YqxbVv0R7OLQHMENXOn/WuknG1gSjn+52shPni2lYwmqI7D/n4iwqGBew/rKe7LLD9wXge/ibZDjn2bdHr2oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803293; c=relaxed/simple;
	bh=c/pLYxiI+4mo21F7cPkYMyhO4BWVNYO+crBNBsBKLCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8GpYQFeTplYU5TZKWm3ZeBuo6l7zJPWvdThOjTWcZkkZTaJcBPH8FHi9W00cjk1bnhw67CZtHjBXD0Jt1e8RVm3Z7kO71D+b6ZOQQWJm+Ol6512D9F/qgscRICxZ9ZYlB024Pn5ns10JYiGEN/f/+WL2zhHcI0zwsX4ji9CRd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvKVwb9k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvKVwb9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C046EC2BBFC;
	Wed, 19 Jun 2024 13:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803293;
	bh=c/pLYxiI+4mo21F7cPkYMyhO4BWVNYO+crBNBsBKLCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZvKVwb9k6aaBLgETVqpSk2bxjMNX5b10p5YzPlD6JeJk5Riz4QzDEihIX8nX8oHyL
	 4e9bobgbKAymb+9qoYo7StPzEqqa4nwX2yTvU9ElldVXaQQgIS6UpMUfKX0MPKKrOc
	 5XRZrjG1GXjE0a68IPvQnyFnoV9RulJ/+Qys0v1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Kleen <ak@linux.intel.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.9 219/281] perf script: Show also errors for --insn-trace option
Date: Wed, 19 Jun 2024 14:56:18 +0200
Message-ID: <20240619125618.388332098@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

commit d4a98b45fbe6d06f4b79ed90d0bb05ced8674c23 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-script.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -3806,7 +3806,7 @@ static int parse_insn_trace(const struct
 	if (ret < 0)
 		return ret;
 
-	itrace_parse_synth_opts(opt, "i0ns", 0);
+	itrace_parse_synth_opts(opt, "i0nse", 0);
 	symbol_conf.nanosecs = true;
 	return 0;
 }


