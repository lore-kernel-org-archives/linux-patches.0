Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017233;
	b=mYI6S/C6xtQsM4sBByIl0nQHEWTUkPuS9Mvk2Y4qeI6TtMlyh5kgUR2PrRclhg/jwOd8
	 MnBORxFKN7tEvoIggj201o0BRIU+W/ykDPFbSmeG8nzLqieDQRhBCsCgL7cK4bD5ry305
	 etyiB084Ffl5/DkaRkLq7FKIsZ+/ePo3XmNkuiILEXP6DqM4ABkTnqK9yFiSlFr2kzGYf
	 ZqWB01CFQToZZRed39vSKN74BjyALrT3qjR4LjZp5lNBBs8SQmWhO5i9Bnu0mxxGtpIUv
	 ceZTnWlk2S9NHjXDhc9CXmTUwXz6rCIUXnbUrz6aHdwaXkEmX+ruCkPJJFQ2lywqZNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yBkVNoqmawtkm7MdMzqKDrSNpXhP1BPNx/9OKkOTOIk=;
	b=z77QLEK3hWZU10rhXYSoot8pcllXGlpER1s3X/BtLYQqLzS5iGfvF00SnUEc0k20WJDx
	 hrZPDcD8HCTS0SPk/2K3AVnlVyslNXkyYaNr/pC0KS8ULE05JK4OxnMrHR/X8cmskw6mE
	 QgJ55tgLJpK6s89BU3+Vnu+OI985r34RC/nLPkzT2BliepuTmCqjtB6AcIKc9sn3HFjhe
	 EyYriZRsFkMu4Ea0hdxJmWjPqLw2Oea8GCTq9HsvgqXRXrK6IEi0RQHOxDFlCNqcvTZYd
	 uQZ5CbF4AnySRAb3IH+Ms6OmuN+1AmO07AHpu1dLYNvO4sYIZFkZ4TSrVNlNviLuy5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QBpDshFU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D3660A2603;
	Wed, 18 Nov 2026 15:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QBpDshFU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444441F000CF;
	Wed, 18 Nov 2026 15:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017232;
	bh=yBkVNoqmawtkm7MdMzqKDrSNpXhP1BPNx/9OKkOTOIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QBpDshFUJ7/67c2Cv85sBPxp3q26RCfwrvDYSD01slJDdDqQ0IjtqFsChHZca+FgV
	 ZIyy/8KQRoM0VpQenRSYbWXC/kdPSf3b+XGpQgM+Jng4mUDFjLuLBPbX9E9bs81ZOa
	 oBCzZfdmodNBBxCY6gg9PaKchFh+BITljmBZV00Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0810/2651] perf buildid-list: Fix empty output for AUX data
Date: Wed, 18 Nov 2026 15:34:10 +0100
Message-ID: <20261118150317.055199174@linuxfoundation.org>
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

From: James Clark <james.clark@linaro.org>

[ Upstream commit 3b364119a9afef9d22b9aee64c96b54553a7117d ]

perf record enables buildid_all for AUX trace because buildid-list does
not decode AUX data to identify hit DSOs. Historically those build IDs
were available in HEADER_BUILD_ID, and buildid-list disabled hit
filtering when HEADER_AUXTRACE was present.

Build IDs are now carried by MMAP2 records by default and the build-ID
header is omitted. perf_session__list_build_ids() forces with_hits when
the header is absent so that it processes the event stream. That also
filters the result to DSOs referenced by ordinary samples. AUX data has
no such samples unless the trace is decoded, so every DSO is dropped and
perf archive reports that no build IDs were found.

Process the event stream whenever the build-ID header is absent,
allowing MMAP2 build IDs to be read, but do not enable hit filtering for
AUX data, this ensures that all build-IDs are included for AUX data.

Fixes: 6bd89ae7d14788ba ("perf record: Make sure to update build-ID cache")
Reviewed-by: Ian Rogers <irogers@google.com>
Assisted-by: Codex:GPT-5.6-Sol
Signed-off-by: James Clark <james.clark@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-buildid-list.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
index e0881b0ac38ff..5555f5dcefe43 100644
--- a/tools/perf/builtin-buildid-list.c
+++ b/tools/perf/builtin-buildid-list.c
@@ -87,6 +87,7 @@ static bool dso__skip_buildid(struct dso *dso, int with_hits)
 static int perf_session__list_build_ids(bool force, bool with_hits)
 {
 	struct perf_session *session;
+	bool has_auxtrace, has_build_id;
 	struct perf_data data = {
 		.path  = input_name,
 		.mode  = PERF_DATA_MODE_READ,
@@ -118,11 +119,19 @@ static int perf_session__list_build_ids(bool force, bool with_hits)
 	 * We take all buildids when the file contains AUX area tracing data
 	 * because we do not decode the trace because it would take too long.
 	 */
-	if (!perf_data__is_pipe(&data) &&
-	    perf_header__has_feat(&session->header, HEADER_AUXTRACE))
+	has_auxtrace = !perf_data__is_pipe(&data) &&
+		perf_header__has_feat(&session->header, HEADER_AUXTRACE);
+	has_build_id = perf_header__has_feat(&session->header, HEADER_BUILD_ID);
+
+	if (has_auxtrace)
 		with_hits = false;
 
-	if (!perf_header__has_feat(&session->header, HEADER_BUILD_ID))
+	/*
+	 * Without a build-ID header, the event stream is processed below to find
+	 * build IDs in MMAP2 records. For AUX data keep all DSOs because the trace
+	 * is not decoded and consequently none of them can be marked as hit.
+	 */
+	if (!has_build_id && !has_auxtrace)
 		with_hits = true;
 
 	if (zstd_init(&(session->zstd_data), 0) < 0)
@@ -132,7 +141,7 @@ static int perf_session__list_build_ids(bool force, bool with_hits)
 	 * in pipe-mode, the only way to get the buildids is to parse
 	 * the record stream. Buildids are stored as RECORD_HEADER_BUILD_ID
 	 */
-	if (with_hits || perf_data__is_pipe(&data))
+	if (with_hits || perf_data__is_pipe(&data) || !has_build_id)
 		perf_session__process_events(session);
 
 	perf_session__fprintf_dsos_buildid(session, stdout, dso__skip_buildid, with_hits);
-- 
2.53.0



