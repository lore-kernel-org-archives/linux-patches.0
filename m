Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB778F62;
	Tue,  5 Dec 2023 03:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pa043cfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4F48C433C9;
	Tue,  5 Dec 2023 03:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747729;
	bh=fmXIySt2xnOhb+G3GXTokZB5I/SpmrDy08j+J9MHt5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pa043cfjwrB+n6tvpfLx3cOjHlpq2hti32NoD6lzxytDbwanQVxAuEzEWJK6q6wri
	 aywpi2RV3IT+Vic02mRQfWdD7qCpsAmbRx4wNhHjcC4VdkgutVE7m84VtmxKE/Ewez
	 SCNSMSkEqI6kRE/fEWaEBIfk6y1e4Xugr733xFZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 47/67] perf intel-pt: Fix async branch flags
Date: Tue,  5 Dec 2023 12:17:32 +0900
Message-ID: <20231205031522.535920939@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
References: <20231205031519.853779502@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit f2d87895cbc4af80649850dcf5da36de6b2ed3dd ]

Ensure PERF_IP_FLAG_ASYNC is set always for asynchronous branches (i.e.
interrupts etc).

Fixes: 90e457f7be08 ("perf tools: Add Intel PT support")
Cc: stable@vger.kernel.org
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20230928072953.19369-1-adrian.hunter@intel.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/intel-pt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index 7a2ce387079e3..805bad9364e94 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -1346,9 +1346,11 @@ static void intel_pt_sample_flags(struct intel_pt_queue *ptq)
 	} else if (ptq->state->flags & INTEL_PT_ASYNC) {
 		if (!ptq->state->to_ip)
 			ptq->flags = PERF_IP_FLAG_BRANCH |
+				     PERF_IP_FLAG_ASYNC |
 				     PERF_IP_FLAG_TRACE_END;
 		else if (ptq->state->from_nr && !ptq->state->to_nr)
 			ptq->flags = PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_CALL |
+				     PERF_IP_FLAG_ASYNC |
 				     PERF_IP_FLAG_VMEXIT;
 		else
 			ptq->flags = PERF_IP_FLAG_BRANCH | PERF_IP_FLAG_CALL |
-- 
2.42.0



