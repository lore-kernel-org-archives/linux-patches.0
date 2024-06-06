Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 405EF1BC063;
	Thu,  6 Jun 2024 14:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683501; cv=none; b=eG9BoL6x3N5SmklhL8aohSr0Qys0TQKRvdcj+xVkiMjfe6MtXgmVkyPqQuddDNcHfAa/wt9s7lw0ULgyaBFIthPLAjh9ElpJxzPitzI28X8iPRqtVLXAyRfgRMiBhML49pnqL2Bo1Z/csD6jAZM2vsIZwvk6BjPZgND5GDJpleU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683501; c=relaxed/simple;
	bh=zfmyJw2FKbj3Wmvu8Vosl6rFnS1OLCdQGBqXvWh9YE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUl9623NuM22LmhXYMxpGjFwQXBF612xnNOPkukM6aFs6rDMyHxop3+nKpnIdSGcJI+q77c+kilMJkWwwEGS5eC9DA2yuvBFRbhrYJ37jWtt5r93/RgaWYusWwOpgtENobmz+jrRsrUTlHG9exnOR0O3SClHrwlePep88YslfEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKmOaNOj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKmOaNOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3E1C2BD10;
	Thu,  6 Jun 2024 14:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683501;
	bh=zfmyJw2FKbj3Wmvu8Vosl6rFnS1OLCdQGBqXvWh9YE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKmOaNOjFSmR8REwP6AaJhybXos3E4HSgMbnX+OReiJDxFj3NLzjXPYQ9/sq3Itwv
	 O8UP2eqvDPgUkdS4XOKGv4fx3XKBNxQ+mtFeCuqyEwoee5AomLeMVjWUeQaTpQVONC
	 qkQkhQChO/q/BvPnwa+/Gi7h1EOBcTZH9COjNbsU=
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
Subject: [PATCH 6.6 443/744] perf docs: Document bpf event modifier
Date: Thu,  6 Jun 2024 16:01:55 +0200
Message-ID: <20240606131746.712736117@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d5f78e125efed..69c6d5e46ad88 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -67,6 +67,7 @@ counted. The following modifiers exist:
  D - pin the event to the PMU
  W - group is weak and will fallback to non-group if not schedulable,
  e - group or event are exclusive and do not share the PMU
+ b - use BPF aggregration (see perf stat --bpf-counters)
 
 The 'p' modifier can be used for specifying how precise the instruction
 address should be. The 'p' modifier can be specified multiple times:
-- 
2.43.0



