Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7B32EA17C;
	Tue, 17 Jun 2025 16:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177110; cv=none; b=nnAXXBh+xcxukLu7fVGEoqMMU+xTDqFJgjTs4arNoj58CiGqPDL3mlmSO+hnpiY+c/K/Yg60Uok5aegMly14jobJUoVWh4KWgcrRxcVlgf9t2oSlyKTZEQbuvCgYbQ2E8mi0/2J4wslMr8o/73yhE/N94CvkS3JNoammRCWW55E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177110; c=relaxed/simple;
	bh=+Hatp4nQE5AhRQ9DJMMlt5+EN33aZtsSgAYrDSdpaeY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K0yU6nN2jBSajWMgratSQ4Pvf9Ux+vm3YVZ6rvQ9jnbZe51XorbU55pHf+URUYe4UZ742ftffZ2mEvWlOjZEJnQ5sOhGsTaqOyl5YZI9cvMV04aE310YdQOkboqOIRG+h2aPhYcgQY8Dx+2uboxfekZntAwDeTJY1egWaA8cR94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BB9cLQhf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BB9cLQhf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7E2C4CEE3;
	Tue, 17 Jun 2025 16:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177109;
	bh=+Hatp4nQE5AhRQ9DJMMlt5+EN33aZtsSgAYrDSdpaeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BB9cLQhf/XyZJgupd+8HkQZyGA/yZUh+oxl63cJ34rhzv5hsbDozyXvlDGroeygb6
	 czbMwGOEYbuZJoPbyHUt8p1fMTtc8w3s9u3adNk3CPeVefYIG0tmsmCOnwL02V9Vbb
	 d0HBScuxJh3y/LZiBA3Zqa3aPMk1Y7gJNJ0wElKc=
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
Subject: [PATCH 6.12 298/512] perf record: Fix incorrect --user-regs comments
Date: Tue, 17 Jun 2025 17:24:24 +0200
Message-ID: <20250617152431.672173494@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index adbaf80b398c1..ab9035573a15e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -3471,7 +3471,7 @@ static struct option __record_options[] = {
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



