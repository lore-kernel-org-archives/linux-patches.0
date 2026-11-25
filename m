Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625213;
	b=dbGtMpjKGIROPOIasOs8ftmKMgAauqjEnn4iisPAzXpPSmaS6Cto12dA4NoUA+geHLqP
	 +9JBATe+htOE2o6rmZTen4R5DmouOa5Ric8lAbl+PFhyc15rsJe8XUxSF8KSZ92tQ9cfc
	 JMltFPC2e3tdd8lETk5tgqllTJSBVB5t5DdNW05dqd+cg1pz0FmNaEApqHZBzKRvm8Fvj
	 9arXzHbrkWqH7bDvBOKHeC+ac8No617rp/pL4mfMVa2Hcws3urSKmF7FP0PdFElvKNu4I
	 cPg9+zV9G1isHdGNehnypYB617W89YX0KPOaPggRI2yyOhhBA8sz2RTvMIDXdHx2BmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bV+fDPSeVGGZhLOuzOxk+1msPMjiZfuh4pD4uHcPFTs=;
	b=kvQm4+YjUWeQ66eLfUn7xtOoCLF8Z3qE/DE0XEOUW+Qhdhqdw71Pb1ldA8AnUCIdmKd7
	 ztFqVEjZYeIGn604phOrqtWwwusRxEJ4DgwvTY8oAna5moz3we9s2owCqFFI8PiSu7GDH
	 yLvlvt4hqQ96+wo5Cou1nKFMLyO/6rzhb5w5p3XJqD7YLEDdhy9NPzOVHrGjBP4N2mmqh
	 ekK2hjOefMy1UrwCAX98iKwjyROIflmMBZ4Ea9SuokuMDWYYUPUtzwG8c1Se06DV+P11E
	 fhK6vCmdhQ7L7f4f/l32VlO9kggA0rgWEfyL7tVYjQu7L+L1ADUVcOORVaVx7MOdgvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bBsGcOuJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D618606A31E;
	Wed, 25 Nov 2026 16:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bBsGcOuJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC55F1F000CA;
	Wed, 25 Nov 2026 16:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625213;
	bh=bV+fDPSeVGGZhLOuzOxk+1msPMjiZfuh4pD4uHcPFTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bBsGcOuJ1DRkOKI4pSjroqyaWrUTCUqp3ixwxiV2NBiCTi2SuMKfOhzHCdZ7BwXJC
	 lsE5PeJxX4Tsd6aXzwJSsbqFl9z+CDQrCwKesAld5Rvi00Ft2KK0U/qnuV/hP0iY4Z
	 ZsMXt5kY/TYHSp8WQZN6kvvecyWyOnsqH4u3LSv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Song Liu <songliubraving@fb.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 443/816] perf evsel: Clamp sample_id size for ksymbol, bpf, and text_poke events
Date: Wed, 25 Nov 2026 15:33:11 +0100
Message-ID: <20261125143859.445378082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 7c89ea1bd4c612eb5cc2e6c01f77ebfc21d5c95d ]

On kernels without the fix ("perf/core: Restore header fields in
sideband output callbacks") to restore event_id.header.size in
perf_event_ksymbol_output(), perf_event_bpf_output(), and
perf_event_text_poke_output(), concurrent perf sessions cause those
sideband records to be emitted with header.size inflated by multiple
id_header_size increments while the single id_sample is written
immediately after the event payload. Indexing backwards from
event->header.size reads uninitialized ring-buffer bytes at the end of
the record, causing evlist__event2evsel() to fail with -EFAULT.

Add evsel__event_size() to clamp the effective size used to locate the
trailing id_sample for PERF_RECORD_KSYMBOL, PERF_RECORD_BPF_EVENT, and
PERF_RECORD_TEXT_POKE to payload + id_hdr_size while leaving
event->header.size intact for advancing the ring-buffer/file stream.

Fixes: 9aa0bfa370b278a5 ("perf tools: Handle PERF_RECORD_KSYMBOL")
Fixes: 45178a928a4b7c60 ("perf tools: Handle PERF_RECORD_BPF_EVENT")
Fixes: 246eba8e9041c477 ("perf tools: Add support for PERF_RECORD_TEXT_POKE")
Link: https://lore.kernel.org/r/20260929014206.4175245-1-irogers@google.com
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Song Liu <songliubraving@fb.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
[ sashal: Adapted to older code by using the evlist->id_pos/is_pos fields and the pointer-walking loop in perf_evsel__parse_id_sample(), swapping in evsel__event_size() for header.size. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evlist.c |  6 ++--
 tools/perf/util/evsel.c  | 59 +++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/evsel.h  |  1 +
 3 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index dac87dccaaaa5..bdf923e6570af 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -701,13 +701,15 @@ static int evlist__event2id(struct evlist *evlist, union perf_event *event, u64
 	const __u64 *array = event->sample.array;
 	ssize_t n;
 
-	n = (event->header.size - sizeof(event->header)) >> 3;
-
 	if (event->header.type == PERF_RECORD_SAMPLE) {
+		n = (event->header.size - sizeof(event->header)) >> 3;
 		if (evlist->id_pos >= n)
 			return -1;
 		*id = array[evlist->id_pos];
 	} else {
+		u16 size = evsel__event_size(evlist__first(evlist), event);
+
+		n = (size - sizeof(event->header)) >> 3;
 		if (evlist->is_pos > n)
 			return -1;
 		n -= evlist->is_pos;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 6798db83bf7cc..0cb488017bbbe 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2524,7 +2524,7 @@ static int perf_evsel__parse_id_sample(const struct evsel *evsel,
 	bool swapped = evsel->needs_swap;
 	union u64_swap u;
 
-	array += ((event->header.size -
+	array += ((evsel__event_size(evsel, event) -
 		   sizeof(event->header)) / sizeof(u64)) - 1;
 
 	if (type & PERF_SAMPLE_IDENTIFIER) {
@@ -3109,6 +3109,63 @@ u16 evsel__id_hdr_size(const struct evsel *evsel)
 	return size;
 }
 
+/*
+ * Prior to kernel fix, perf_event_ksymbol_output(), perf_event_bpf_output(),
+ * and perf_event_text_poke_output() in kernel/events/core.c did not save and
+ * restore event_id.header.size across perf_iterate_sb() iterations. When
+ * multiple perf_events had attr.ksymbol, attr.bpf_event, or attr.text_poke
+ * enabled, header.size was incremented by id_header_size for each matching
+ * event while only a single id_sample was written immediately after the event
+ * payload. Clamp the effective size used to locate the trailing id_sample to
+ * payload + id_hdr_size so events recorded on unpatched kernels can be parsed
+ * without reading uninitialized ring-buffer bytes.
+ */
+u16 evsel__event_size(const struct evsel *evsel, const union perf_event *event)
+{
+	u16 size = event->header.size;
+	u16 id_hdr_size;
+	size_t payload;
+
+	if (!evsel->core.attr.sample_id_all)
+		return size;
+
+	switch (event->header.type) {
+	case PERF_RECORD_KSYMBOL: {
+		const char *name = event->ksymbol.name;
+		size_t fixed = offsetof(struct perf_record_ksymbol, name);
+		size_t max_len, len;
+
+		if (size <= fixed)
+			return size;
+		max_len = size - fixed;
+		len = strnlen(name, max_len);
+		if (len == max_len)
+			return size;
+		payload = fixed + PERF_ALIGN(len + 1, sizeof(u64));
+		break;
+	}
+	case PERF_RECORD_BPF_EVENT:
+		payload = sizeof(struct perf_record_bpf_event);
+		break;
+	case PERF_RECORD_TEXT_POKE: {
+		size_t fixed = offsetof(struct perf_record_text_poke_event, bytes);
+
+		if (size < fixed)
+			return size;
+		payload = PERF_ALIGN(fixed + (size_t)event->text_poke.old_len +
+				     event->text_poke.new_len, sizeof(u64));
+		break;
+	}
+	default:
+		return size;
+	}
+
+	id_hdr_size = evsel__id_hdr_size(evsel);
+	if (payload + id_hdr_size < size)
+		return payload + id_hdr_size;
+	return size;
+}
+
 #ifdef HAVE_LIBTRACEEVENT
 struct tep_format_field *evsel__field(struct evsel *evsel, const char *name)
 {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index dc0d300776f16..7f2f5d85edf70 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -435,6 +435,7 @@ int evsel__parse_sample_timestamp(struct evsel *evsel, union perf_event *event,
 				  u64 *timestamp);
 
 u16 evsel__id_hdr_size(const struct evsel *evsel);
+u16 evsel__event_size(const struct evsel *evsel, const union perf_event *event);
 
 static inline struct evsel *evsel__next(struct evsel *evsel)
 {
-- 
2.53.0



