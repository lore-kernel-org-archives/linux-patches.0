Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0612013BAEB;
	Thu,  6 Jun 2024 14:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683429; cv=none; b=bPQrzNiVZeQDhHM5Ks6Mle9P22CII4A+W3BvodGnDZIs53XufbOqo5jY23S2uMq6eO40WgrNZaP5YuaRa0WdVx5E+yXoSqCRfJVdqD61g6P/N1BAsPdfGKAYR++QwZFJnQIJb4G3XpXcX1SF4xAB5kyqPhBTdYGrUjKIYFzOKuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683429; c=relaxed/simple;
	bh=7A+fG8RMS1ovUq6lS2F3PAaP2ZrWfEv+gIQdX+QtxNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpLoTLukWpkBtTbvG7ks7z1BEZMBmLvcqwkXNA0+dKOFHSWx829hNOg7uGlkf+AKkfQMoYAUDsRi+95M06zrEWf9S/QmrTr5GbaxS3yenLdfd90qGSPwpUeDfu7WJrQ3bIEYS8MqmBS6jFnBNhICIYRtyoELv0os/H5n9ABJZ+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Amy4F1oI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Amy4F1oI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75E2C32781;
	Thu,  6 Jun 2024 14:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683428;
	bh=7A+fG8RMS1ovUq6lS2F3PAaP2ZrWfEv+gIQdX+QtxNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Amy4F1oIzPmHgeTKAjJT0MN+KG6Zub/cTP72dUTXnnBSAatWXDZ+Rg3VVFI5o9NSi
	 t02T1Ov+domMdsRVsbdgDtxffU3JOdvmdJKU6TE6pP5syVBGoMNk1967c6vSQCG4dE
	 1iIq96zH5FhuiAQZ4IXHqHJIFtsPmcuh50cr4U/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Song Liu <song@kernel.org>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 314/473] perf docs: Document bpf event modifier
Date: Thu,  6 Jun 2024 16:04:03 +0200
Message-ID: <20240606131710.318009104@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit eb4d27cf9aef3e6c9bcaf8fa1a1cadc2433d847b ]

Document that 'b' is used as a modifier to make an event use a BPF
counter.

Fixes: 01bd8efcec444468 ("perf stat: Introduce ':b' modifier")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Song Liu <song@kernel.org>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Link: https://lore.kernel.org/r/20240416170014.985191-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Documentation/perf-list.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index 57384a97c04f4..3dae696b748a6 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -63,6 +63,7 @@ counted. The following modifiers exist:
  D - pin the event to the PMU
  W - group is weak and will fallback to non-group if not schedulable,
  e - group or event are exclusive and do not share the PMU
+ b - use BPF aggregration (see perf stat --bpf-counters)
 
 The 'p' modifier can be used for specifying how precise the instruction
 address should be. The 'p' modifier can be specified multiple times:
-- 
2.43.0



