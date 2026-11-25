Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618622;
	b=z42suuT3OEeudnevq4Sbeolw5cokblgq5HZeciuGTbBUpgKs8xipQKXSXNfE8S+Z+may
	 d92gc9eSaCSH8F+QB3ICZ04n+kUBvQ9YLf2adXI8McjY4uy+Q9Ts9jAz3BShHHIFtwhaT
	 KwfLTCKPc1knhu+yvCsb/jImSiQfvGEACErl7kooXN3L6HgVYoFKkPIHKeCaxKh0jEjBZ
	 /WWKdWmwcQsoojvwQSglRAdZLPwaLfi7itJCsqICZsE22kUCTVNaxivr3CydfOTUsvSk0
	 7e/tgjkP3fYqu1ejozR5SshqaLacpBV1B9ZLnSjvNcLKEKAbRDzHmdcc1IfablWSX/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m2wWFuPllTMrxuclMyAzI0AailKXYtwagxaSWfYQRvs=;
	b=CJlNNRo7wtIXUD2X/5avaTo0R7xeQ2tyS47Pbl8u1bpGLGeCTRqkkvgewGZJjhS1fB8f
	 wyV+tmI9bGdgXzp3JBAvVuCRATiTB6NWJn0qTsGivezVH8jNvjIzFlcYMZ8yC8ILIOZjp
	 P9SmrRZ8ZHx/sChIDHxAuI70yrxC1M2Rs61aCW/0Usj7dFK1LmWfdAdSf6u9SnczZ3gAu
	 +Z+pueezLIG1ks+hQLPsu6w5Cm0am6FKzl75UWPzXA9HEjP8nP0zaD+c10z1ouMrolJm9
	 MPh/CvXYuLt6DeaLqiEbK3aKFA0jO4HlGBTcyvX3EpW2Vw37v6V2IWPJDObkISkkHMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XrC82MJ6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A70D606A31E;
	Wed, 25 Nov 2026 14:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XrC82MJ6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055871F000C4;
	Wed, 25 Nov 2026 14:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618621;
	bh=m2wWFuPllTMrxuclMyAzI0AailKXYtwagxaSWfYQRvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XrC82MJ6sCo+tSUcnUPtyFiaL0sox0P1KGlERIE4DtJZpv7UkOrRvXPdEqHAUsBF0
	 4NHHtZaN9ANvYh7Nt/DAdz1mf/az/mbNGTRmyfKc+mo2kPYrXZu1xg5ja2+s/U9o6l
	 aTNIwel1zKWz4smg1nA91cf05oLpTpUJYzh6DCms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0337/1005] perf/core: Clamp deferred callchain entry count to fit u16 header.size
Date: Wed, 25 Nov 2026 15:27:55 +0100
Message-ID: <20261125143829.629100186@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 5e4d83fb3616ebf807df1ce1b0ee7a8cdcb5ff87 ]

In perf_callchain_deferred_output(), if trace->nr is large enough that
sizeof(deferred_event->event) + trace->nr * sizeof(u64) + id_header_size
exceeds U16_MAX, header.size wraps while the output loop still writes
all trace->nr entries into the ring buffer.

Clamp nr per event (accounting for event->id_header_size when
sample_id_all is enabled) so the record never overflows u16 header.size.

Fixes: c69993ecdd4d ("perf: Support deferred user unwind")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://patch.msgid.link/20261025215508.1237480-2-irogers@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2cd3c5def0499..2f1b4c6ba1cae 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -10397,8 +10397,6 @@ struct perf_callchain_deferred_event {
 	struct {
 		struct perf_event_header	header;
 		u64				cookie;
-		u64				nr;
-		u64				ips[];
 	} event;
 };
 
@@ -10407,12 +10405,19 @@ static void perf_callchain_deferred_output(struct perf_event *event, void *data)
 	struct perf_callchain_deferred_event *deferred_event = data;
 	struct perf_output_handle handle;
 	struct perf_sample_data sample;
+	u64 nr = deferred_event->trace->nr;
+	u16 size, id_size, max_payload;
 	int ret;
-	u16 size = sizeof(deferred_event->event) + (deferred_event->trace->nr * sizeof(u64));
 
 	if (!event->attr.defer_output)
 		return;
 
+	id_size = event->attr.sample_id_all ? event->id_header_size : 0;
+	max_payload = round_down(U16_MAX - sizeof(deferred_event->event) -
+				 sizeof(u64) - id_size, sizeof(u64));
+	nr = min_t(u64, nr, max_payload / sizeof(u64));
+	size = sizeof(deferred_event->event) + sizeof(u64) + nr * sizeof(u64);
+
 	/* XXX do we really need sample_id_all for this ??? */
 	perf_event_header__init(&deferred_event->event.header, &sample,
 				PERF_RECORD_CALLCHAIN_DEFERRED,
@@ -10426,8 +10431,10 @@ static void perf_callchain_deferred_output(struct perf_event *event, void *data)
 		return;
 
 	perf_output_put(&handle, deferred_event->event);
-	for (int i = 0; i < deferred_event->trace->nr; i++) {
+	perf_output_put(&handle, nr);
+	for (u64 i = 0; i < nr; i++) {
 		u64 entry = deferred_event->trace->entries[i];
+
 		perf_output_put(&handle, entry);
 	}
 	perf_event__output_id_sample(event, &handle, &sample);
@@ -10442,7 +10449,6 @@ static void perf_unwind_deferred_callback(struct unwind_work *work,
 		.trace = trace,
 		.event = {
 			.cookie = cookie,
-			.nr = trace->nr,
 		},
 	};
 
-- 
2.53.0



