Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5845B2D77E5;
	Mon, 20 Apr 2026 15:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700142; cv=none; b=ACV/lSVMTfCIHksNLkqXANARDt7ahYG5ugD+tn6jEKdG80v7ExL6Fq1Jhs09QwwpTtZsVT+fy9jrTjU1NxVQndQZL6nBPJ3ULtwQB/wF1D7YEt0XWX3QIrq4GV9CC0Y/fKMgTkjAX4oh/NLOsULNICNE8K1wG6afR1raMq2A7go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700142; c=relaxed/simple;
	bh=A5/b1ZjJz2ip38kipbuSbyCuIbpurAWSnE/UE4OrKO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmPrZPlPQiAXFOggC4YP+az6BdAL7PzC4YxJtOOr4ipDp3ToGfPkTNYqd9E4pGIreRImtVaznIzu+V5ed+kQ5zNNfSJgOKDAMf4n3VdUJE/pzfN9Rkiq1gMa+b/zih/Z/WiX8S0KQQvk1tgTAnI7EEKhf0nnZzOEHK/s1ztN49A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TmEnPL6s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TmEnPL6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C90C19425;
	Mon, 20 Apr 2026 15:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700142;
	bh=A5/b1ZjJz2ip38kipbuSbyCuIbpurAWSnE/UE4OrKO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TmEnPL6seHXd/h0fKnENEU8rQGgJ4TcL4I7TJZ7LmRaASRaEw+k7F9Jhh8IDEOwUm
	 20RxrTJ04AA1VwlU+I0cyYWRIWzEDuzB9fKoq/Qhbn5CqDbc9fAlLcubn7l2xalnqV
	 Tr+sN19EvOqk1H0JqU1eCdwo+XIF767qCKlmWhaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 058/220] tools/power turbostat: Fix incorrect format variable
Date: Mon, 20 Apr 2026 17:39:59 +0200
Message-ID: <20260420153936.130911921@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

[ Upstream commit 23cb4f5c81766e70e5f32ed0987ee8fb5ab2e00a ]

In the perf thread, core, and package counter loops, an incorrect
'mp->format' variable is used instead of 'pp->format'.

[lenb: edit commit message]
Fixes: 696d15cbd8c2 ("tools/power turbostat: Refactor floating point printout code")
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 83a90f413f976..603651e74dacf 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -3330,7 +3330,7 @@ int format_counters(PER_THREAD_PARAMS)
 	for (i = 0, pp = sys.perf_tp; pp; ++i, pp = pp->next) {
 		if (pp->format == FORMAT_RAW)
 			outp += print_hex_value(pp->width, &printed, delim, t->perf_counter[i]);
-		else if (pp->format == FORMAT_DELTA || mp->format == FORMAT_AVERAGE)
+		else if (pp->format == FORMAT_DELTA || pp->format == FORMAT_AVERAGE)
 			outp += print_decimal_value(pp->width, &printed, delim, t->perf_counter[i]);
 		else if (pp->format == FORMAT_PERCENT) {
 			if (pp->type == COUNTER_USEC)
@@ -3400,7 +3400,7 @@ int format_counters(PER_THREAD_PARAMS)
 	for (i = 0, pp = sys.perf_cp; pp; i++, pp = pp->next) {
 		if (pp->format == FORMAT_RAW)
 			outp += print_hex_value(pp->width, &printed, delim, c->perf_counter[i]);
-		else if (pp->format == FORMAT_DELTA || mp->format == FORMAT_AVERAGE)
+		else if (pp->format == FORMAT_DELTA || pp->format == FORMAT_AVERAGE)
 			outp += print_decimal_value(pp->width, &printed, delim, c->perf_counter[i]);
 		else if (pp->format == FORMAT_PERCENT)
 			outp += print_float_value(&printed, delim, pct(c->perf_counter[i], tsc));
@@ -3558,7 +3558,7 @@ int format_counters(PER_THREAD_PARAMS)
 			outp += print_hex_value(pp->width, &printed, delim, p->perf_counter[i]);
 		else if (pp->type == COUNTER_K2M)
 			outp += sprintf(outp, "%s%d", (printed++ ? delim : ""), (unsigned int)p->perf_counter[i] / 1000);
-		else if (pp->format == FORMAT_DELTA || mp->format == FORMAT_AVERAGE)
+		else if (pp->format == FORMAT_DELTA || pp->format == FORMAT_AVERAGE)
 			outp += print_decimal_value(pp->width, &printed, delim, p->perf_counter[i]);
 		else if (pp->format == FORMAT_PERCENT)
 			outp += print_float_value(&printed, delim, pct(p->perf_counter[i], tsc));
-- 
2.53.0



