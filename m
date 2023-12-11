Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEDFFC06;
	Mon, 11 Dec 2023 18:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zht9+fyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788A7C433C7;
	Mon, 11 Dec 2023 18:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320285;
	bh=hXTxoYEThrEdGQKaEfDSR+JEpNBkAAIncN4fKgLnemY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zht9+fyfoWmvWMoSK/CKmTTVHXJLLSHm2LwuhiNONbYCxkvbPGYhk9x7uteSCvVIR
	 UbOmvshxx9za7kbsr7BM4p8E0JAo7Pi59WRr0tM+1n96QOaySRMlb109UWI26HxTTT
	 ZSOxBlzF4YAwxlrt56ItPwyZHoRptKLHVNMVjKbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.4 62/67] tools headers UAPI: Sync linux/perf_event.h with the kernel sources
Date: Mon, 11 Dec 2023 19:22:46 +0100
Message-ID: <20231211182017.650909072@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182015.049134368@linuxfoundation.org>
References: <20231211182015.049134368@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

commit 65ba872a6971c11ceb342c3330f059289c0e6bdb upstream.

To pick the trivial change in:

  119a784c81270eb8 ("perf/core: Add a new read format to get a number of lost samples")

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20220819003644.508916-2-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/uapi/linux/perf_event.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/tools/include/uapi/linux/perf_event.h
+++ b/tools/include/uapi/linux/perf_event.h
@@ -273,6 +273,7 @@ enum {
  *	  { u64		time_enabled; } && PERF_FORMAT_TOTAL_TIME_ENABLED
  *	  { u64		time_running; } && PERF_FORMAT_TOTAL_TIME_RUNNING
  *	  { u64		id;           } && PERF_FORMAT_ID
+ *	  { u64		lost;         } && PERF_FORMAT_LOST
  *	} && !PERF_FORMAT_GROUP
  *
  *	{ u64		nr;
@@ -280,6 +281,7 @@ enum {
  *	  { u64		time_running; } && PERF_FORMAT_TOTAL_TIME_RUNNING
  *	  { u64		value;
  *	    { u64	id;           } && PERF_FORMAT_ID
+ *	    { u64	lost;         } && PERF_FORMAT_LOST
  *	  }		cntr[nr];
  *	} && PERF_FORMAT_GROUP
  * };
@@ -289,8 +291,9 @@ enum perf_event_read_format {
 	PERF_FORMAT_TOTAL_TIME_RUNNING		= 1U << 1,
 	PERF_FORMAT_ID				= 1U << 2,
 	PERF_FORMAT_GROUP			= 1U << 3,
+	PERF_FORMAT_LOST			= 1U << 4,
 
-	PERF_FORMAT_MAX = 1U << 4,		/* non-ABI */
+	PERF_FORMAT_MAX = 1U << 5,		/* non-ABI */
 };
 
 #define PERF_ATTR_SIZE_VER0	64	/* sizeof first published struct */


