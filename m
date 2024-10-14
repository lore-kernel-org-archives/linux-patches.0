Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA28E571;
	Mon, 14 Oct 2024 14:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915824; cv=none; b=PMWkKYcplsyJ1v2puSDTtSPKh4j1zgYtv/u//6PxsKQROBK0CYo/nZkhy/J6a0LPhbcdH7CAWq0rE+VKwuQQcwgTn9xZfpWKSFscj8uiCNZURFNIyvh09b0jF7HViYMX8rWlB8zoUnKSLClUQeobo4byPccvJ/eI0JYJadmNt78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915824; c=relaxed/simple;
	bh=a13LlJ29dHr0cCvNg6BAOtKnfpmALSssKtDZsIRMTr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oesim/bcmFvyn5S0MGN0Ko4seg7Go4Iwiz7YJWL0yBQhiEGirQVlCqBfSNHhOUsIzUxKkBKMWhhRIeiIfdvtCbHOGpX2rnN1sg0MyMwMKi5ujMU8xBDYubLvzR/ufVBuQyhTZJM0fXm0fBeDpWZ8Iq11y0XCIjVCxnthD/pcSVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xQetZE/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xQetZE/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B82C4CEC7;
	Mon, 14 Oct 2024 14:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915824;
	bh=a13LlJ29dHr0cCvNg6BAOtKnfpmALSssKtDZsIRMTr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xQetZE/vxI/SCndLdv4sIZ9vAOvbZelw4iI49k3XjbQiBKT0yliuTxK9fnm5tvzrJ
	 Np11YAh7A7iogUZUyiwXRoSQ4TxdD7Oz1qaUppEahm7zG+da6gNHPe611yHZ7s0Yf8
	 /9Uy0jfmD30/SRXS7pF4Ah9Y8VTqlIN4k1sY9DHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 010/214] perf vdso: Missed put on 32-bit dsos
Date: Mon, 14 Oct 2024 16:17:53 +0200
Message-ID: <20241014141045.394941233@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 424aafb61a0b98d7d242f447fdb84bb8b323e8a8 ]

If the dso type doesn't match then NULL is returned but the dso should
be put first.

Fixes: f649ed80f3cabbf1 ("perf dsos: Tidy reference counting and locking")
Signed-off-by: Ian Rogers <irogers@google.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20240912182757.762369-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/vdso.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index 1b6f8f6db7aa4..c12f5d8c4bf69 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -308,8 +308,10 @@ static struct dso *machine__find_vdso(struct machine *machine,
 		if (!dso) {
 			dso = dsos__find(&machine->dsos, DSO__NAME_VDSO,
 					 true);
-			if (dso && dso_type != dso__type(dso, machine))
+			if (dso && dso_type != dso__type(dso, machine)) {
+				dso__put(dso);
 				dso = NULL;
+			}
 		}
 		break;
 	case DSO__TYPE_X32BIT:
-- 
2.43.0



