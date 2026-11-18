Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020811;
	b=dc5TXk1VwNnwpwW+kcKoeBbzhFY3lANfCAg57FX62VepKqvUjnANLKsQn810l6nu4ngP
	 /x1LWIV1CAgeIWcLdXxqb6FoSv2cAVbjKPXfUuDA2PK0eg7iBhJOvlCD22v5lvmLZdpvk
	 l6v4n/+m45uOQLPVCADOxMlW5f3+eDS9brGIdjBRLNnEb0vYeWd1Dpp1r4u5ouCukukRd
	 CB1gDOea0byxMN0VoUPih6D79Lw94T1xSp3xxovF5wP/bIw/c100bCGILhWwWS6/ikNEu
	 mJ3VlCDhJ+A1AvXfpCs/YrHIQ5qCREadRg2YkZYqj8K2khlXtPrVDc4XyyijQ7J7Snw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Aige4PbjWn+3wxkR6PHkBhQCy/BAvq9VH+d/4fKbHLA=;
	b=uUESdGtNsJcm2KYqRN4M6YWoEPER0Brk1qB7OnIjn9kpGh16Y0vmNCChawcxwC23GmKD
	 A+EJWm8uPqAAMKVjXP17lPGdlkXzBp4DO2CuqRcXQR5XHfkst3timIOoOsEOBtsogzYWK
	 ISnCosl5ULIfypLYC1uOW1WnQ4AFOfm1lsiVQkn6vcc25S/Zq3M0Xm5gPCijIvL5LorwQ
	 FkEE+xHo1Mr4tsfJqeGYyC65POtIPbq0D49+aFVDPAayhyUBjeySf5KCy14FAYwJeZA8U
	 e2x8/N69xcukBaavljnoXr1LpcMtqKG4tTGwvXMSVbd27VmPEn85nXjszufE7mq28zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZxR8z93Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4359606A33F;
	Wed, 18 Nov 2026 16:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZxR8z93Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77E21F000C9;
	Wed, 18 Nov 2026 16:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020811;
	bh=Aige4PbjWn+3wxkR6PHkBhQCy/BAvq9VH+d/4fKbHLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZxR8z93QeFLaKhw3I8AK5sZC5D5kONbT1h/xuj2FsT1mcrKndrEX6flbFw5mx7k/5
	 EFFKVti7ZvhjE/TkMr/oFI59pSeYWpxLTL3CeCRMbXReaDPVoinzkcV7bXmR8qr6T+
	 0uOdSxAmMtNuZ1WYE9Z2pKChMGJTyMjTrMRJsh1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2083/2651] perf evsel: Mark the event as supported when retrying an open
Date: Wed, 18 Nov 2026 15:55:23 +0100
Message-ID: <20261118150401.013697396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit cc956e0cd6a405fbc6ad3055cbbdb178562ef27d ]

Opening a group with perf record on a machine with perf_event_paranoid >
1 and no CAP_PERFMON fails the first perf_event_open() with EACCES, after
which evsel__open_cpu() clears evsel->supported; evsel__fallback() then
adds exclude_kernel and record__open() retries, and the retry succeeds
with supported left false.  get_group_fd() treats unsupported events as
ungroupable, so the retry opens the group members without their leader:

  sys_perf_event_open: pid 12345 cpu 0 group_fd -1
  FAILED '.../test-record-group-sampling1' - group failure

which fails the group subtests of "perf test 82", the Perf attribute
expectations test, when it is run as a regular user, while it passes as
root or with CAP_PERFMON, where the first open doesn't fail.

commit 2cc7aa995ce9 ("perf stat: Refactor retry/skip/fatal error handling")
dropped the pos->supported = true that record__open() did after a
successful open and moved the resets into the stat code only, while
saying "When an event is tried the supported is set to true again".  Do
that in evsel__open_cpu(), which every open entry point funnels through,
so that a retry describes its own try instead of the previous failure.

Fixes: 2cc7aa995ce9ecd8 ("perf stat: Refactor retry/skip/fatal error handling")
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Ian Rogers <irogers@google.com>
Cc: Ian Rogers <irogers@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 806a9e56b8e6c..12e05676b0daa 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2997,6 +2997,12 @@ static int evsel__open_cpu(struct evsel *evsel, struct perf_cpu_map *cpus,
 	enum rlimit_action set_rlimit = NO_CHANGE;
 	struct perf_cpu cpu;
 
+	/*
+	 * A failed attempt being retried after evsel__fallback() would
+	 * otherwise keep group members out of their group in get_group_fd().
+	 */
+	evsel->supported = true;
+
 	if (evsel__is_retire_lat(evsel)) {
 		err = evsel__tpebs_open(evsel);
 		goto out;
-- 
2.53.0



