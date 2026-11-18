Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024035;
	b=wdZVJ8xfJ5j3LUKltUq6tzKVC6Il7Jhs+Q3eVFbWQwpndDF0xlQMM/oDXYivHx18GBgy
	 Jhn1ix3y0CUY84ZQdLzPDkrIsGQPS5z5vl+fS2TNP9GImRik1kijcTEUJcsZyfN8Rcqpd
	 6Ojkcypa0khZXLgj5gsjDVIOKz1pkgGSegpF1J7vdgN4rgmNi1rV13nxFa4UYPG411xfd
	 o5GMl7bFjBC6K4R3gIPRMnZWUnyjip3Dk/DjQxG6yGojnTPn348zlQTQHOHUzNTap7czp
	 JsWHXB404bxsbeLU6LhE/abNqjdRCZNsu0b4DV17Ran8Hvv/9uXG+mbnZnhHzNTGwHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sUhxxh7flmn1IDO0ew9d4kmEramY42vivluG4X/wJcw=;
	b=5jVqOjokP1RkXGio4oK8vaud2Z17ww4PPuoZ46AbTsLqDfXoS2wV2kJDiRQk5mKmvGY3
	 nfUHAK00wzEBoK3lk9anCRsa1kJptSz/qsvaeLm9RFVi2Kxq3YGVF49QGs0l+U7DQT1Gy
	 q4QKykCyY4wVBhaFLkvz4pMjw4KPKm5gac0kU3BO6IopUmRr3btWHcAN68t3Pg6bZ+Kb+
	 YAip3oQE9tL1Lblb5B3sIaf/Wn5m7WFfTMaJumQlvGVMLlrF7+u/XIEe35tpLPoOQsZV1
	 6MDPy9/t/MNfrt7tCsUtXzvLZjTpHCwzGrwmx/1daUjW5S8s29px7z8CZtrZNaUp52w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2XsxCQ53;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE0B606A320;
	Wed, 18 Nov 2026 17:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2XsxCQ53
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C921F000C4;
	Wed, 18 Nov 2026 17:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024035;
	bh=sUhxxh7flmn1IDO0ew9d4kmEramY42vivluG4X/wJcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2XsxCQ53MaMsUIZIpx9WSIyZHohxjrxEAE2mFIIk79Qjb7u1MtvSaqqPoDqERhvs6
	 1dvBF0Fdq0JA8AcgvA5jx9vXRz5IQ0ZIerK/pz0qMyufrFwm2sNYZrvVLSIzoAmdM7
	 PFaePaaDUZU2UX/Y8hWNdnyVTUSY8KT/zRvObfZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Derek Foreman <derek.foreman@collabora.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0582/2151] perf test: perf data --to-ctf testing
Date: Wed, 18 Nov 2026 15:38:37 +0100
Message-ID: <20261118150143.154328966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 9083ce531a1f7fb5186be934f42d884de34698da ]

If babeltrace is detected check that --to-ctf functions with a data
file and in pipe mode.

Committer testing:

  $ perf test 'perf data convert --to-ctf'
  124: 'perf data convert --to-ctf' command test                       : Ok
  $ perf test -vv 'perf data convert --to-ctf'
  124: 'perf data convert --to-ctf' command test:
  --- start ---
  test child forked, pid 556008
           libbabeltrace: [ on  ]  # HAVE_LIBBABELTRACE_SUPPORT
  Testing Perf Data Conversion Command to CTF (File input)
  [ perf record: Woken up 1 times to write data ]
  [ perf record: Captured and wrote 0.021 MB /tmp/__perf_test.perf.data.9TxzZ (115 samples) ]
  [ perf data convert: Converted '/tmp/__perf_test.perf.data.9TxzZ' into CTF data '/tmp/__perf_test.ctf.f5EkS' ]
  [ perf data convert: Converted and wrote 0.012 MB (115 samples) ]
  Perf Data Converter Command to CTF (File input) [SUCCESS]
  Testing Perf Data Conversion Command to CTF (Pipe mode)
  [ perf record: Woken up 2 times to write data ]
  [ perf record: Captured and wrote 0.047 MB - ]
  Failed to setup all events.
  [ perf data convert: Converted '/tmp/__perf_test.perf.data.9TxzZ' into CTF data '/tmp/__perf_test.ctf.f5EkS' ]
  [ perf data convert: Converted and wrote 0.000 MB (0 samples) ]
  Perf Data Converter Command to CTF (Pipe mode) [SUCCESS]
  Unexpected signal in main
  ---- end(0) ----
  124: 'perf data convert --to-ctf' command test                       : Ok
  $

Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Derek Foreman <derek.foreman@collabora.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: a5cac2df8b4a ("perf build: Remove leftovers of removed build options")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../shell/test_perf_data_converter_ctf.sh     | 104 ++++++++++++++++++
 1 file changed, 104 insertions(+)
 create mode 100755 tools/perf/tests/shell/test_perf_data_converter_ctf.sh

diff --git a/tools/perf/tests/shell/test_perf_data_converter_ctf.sh b/tools/perf/tests/shell/test_perf_data_converter_ctf.sh
new file mode 100755
index 0000000000000..334eebc9945eb
--- /dev/null
+++ b/tools/perf/tests/shell/test_perf_data_converter_ctf.sh
@@ -0,0 +1,104 @@
+#!/bin/bash
+# 'perf data convert --to-ctf' command test
+# SPDX-License-Identifier: GPL-2.0
+
+set -e
+
+err=0
+
+perfdata=$(mktemp /tmp/__perf_test.perf.data.XXXXX)
+ctf_dir=$(mktemp -d /tmp/__perf_test.ctf.XXXXX)
+
+cleanup()
+{
+	rm -f "${perfdata}"
+	rm -rf "${ctf_dir}"
+	trap - exit term int
+}
+
+trap_cleanup()
+{
+	echo "Unexpected signal in ${FUNCNAME[1]}"
+	cleanup
+	exit ${err}
+}
+trap trap_cleanup exit term int
+
+check_babeltrace_support()
+{
+	if ! perf check feature libbabeltrace
+	then
+		echo "perf not linked with libbabeltrace, skipping test"
+		exit 2
+	fi
+}
+
+test_ctf_converter_file()
+{
+	echo "Testing Perf Data Conversion Command to CTF (File input)"
+	# Record some data
+	if ! perf record -o "$perfdata" -F 99 -g -- perf test -w noploop
+	then
+		echo "Failed to record perf data"
+		err=1
+		return
+	fi
+
+	# Cleanup previous ctf dir
+	rm -rf "${ctf_dir}"
+
+	# Convert
+	if ! perf data convert --to-ctf "$ctf_dir" --force -i "$perfdata"
+	then
+		echo "Perf Data Converter Command to CTF (File input) [FAILED]"
+		err=1
+		return
+	fi
+
+	if [ -d "${ctf_dir}" ] && [ "$(ls -A "${ctf_dir}")" ]
+	then
+		echo "Perf Data Converter Command to CTF (File input) [SUCCESS]"
+	else
+		echo "Perf Data Converter Command to CTF (File input) [FAILED]"
+		echo "    Output directory empty or missing"
+		err=1
+	fi
+}
+
+test_ctf_converter_pipe()
+{
+	echo "Testing Perf Data Conversion Command to CTF (Pipe mode)"
+
+	# Cleanup previous ctf dir
+	rm -rf "${ctf_dir}"
+
+	# Record to stdout and pipe to $perfdata file
+	if ! perf record -o - -F 99 -g -- perf test -w noploop > "$perfdata"
+	then
+		echo "Failed to record perf data"
+		err=1
+		return
+	fi
+
+	if ! perf data convert --to-ctf "$ctf_dir" --force -i "$perfdata"
+	then
+		echo "Perf Data Converter Command to CTF (Pipe mode) [FAILED]"
+		err=1
+		return
+	fi
+
+	if [ -d "${ctf_dir}" ] && [ "$(ls -A "${ctf_dir}")" ]
+	then
+		echo "Perf Data Converter Command to CTF (Pipe mode) [SUCCESS]"
+	else
+		echo "Perf Data Converter Command to CTF (Pipe mode) [FAILED]"
+		echo "    Output directory empty or missing"
+		err=1
+	fi
+}
+
+check_babeltrace_support
+test_ctf_converter_file
+test_ctf_converter_pipe
+
+exit ${err}
-- 
2.53.0



