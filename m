Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026415;
	b=kLz6DeCKaR1ST2g7PfaYEU4W4EnKC8qXk4G1DugKA5Hc5CiIFqoIsfE/YHseUEMi/FDf
	 XHQ2GMBznZCqhmueKu6Yrw7mYLz/LCfncKvhqMBhmUnN4EOkkYkCuGlg2SVBkaT/+SNgd
	 ZHGjfSq1Hq4HFGfRBtM83F66XLrIny/0SV6oWW8F7RJ7E1g5XmbQXK/ZxXveFXBCm/0Zl
	 Bneek70CeMmnIQEs020BOFDNZPYrltPSBl8tMxnHlxmmTljzSkAh6HlJUQ3BtMYyZdUXt
	 efY/pXD+lFclSPjF1aBGCbKjSkQXCttdw0wfv6n4utJG456mvbtLrQm2ny2xVTpQrFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026415;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q0W8FppdrUHXK/10/3novnDl4uELzAD2eROr6bUkA3w=;
	b=GhJZJuNwSE44u6Jjldi2TP8tbOMWPcq/aK2KrusVpPGL/uXmwJcmje6PrHFprfMn2D3G
	 GblpOAZkpFk3ub/ph90dEXE0MKqx4SfMI8N3P9FHOHh+s72pV8aT+HqzWz5bR8hNzaKCp
	 igiyK8zEhHXhGAsLDDAuKj3/cMg/ksA8gqiA2//kMI0qCQpXP6n1/z5gsAf+t6J5664aL
	 brNT0IpBBfoJ/112jvbxfLxFBCW/jgcm2H32c/Axj3Yb1naGoIMANNCUoFo6KibdNKN8V
	 GCz3WXSLUHG/GD0X9IErvQC7V9EgAiIa+xjypJP8GfKr30cNOaXp0JLGqrOBImBuAYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2i444RU3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E774606A31C;
	Wed, 18 Nov 2026 18:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2i444RU3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C681F000C4;
	Wed, 18 Nov 2026 18:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026415;
	bh=q0W8FppdrUHXK/10/3novnDl4uELzAD2eROr6bUkA3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2i444RU3sSWDJf8TCoMVRFD4EHh0uQqDh+oHApBz1n3msYByUbLNgGKpRERfMn6wr
	 SpQfyguC+YGgrY1jQIv8TETZmBf3Esp+MPn9QDQsEru0MusIpCkR24nnflUWKNgkwz
	 UNnRGlXmqb9wfoHfY8N7bFbc37unMESlJjv4fNhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1420/2151] perf test attr: Source setup_python.sh instead of calling python
Date: Wed, 18 Nov 2026 15:52:35 +0100
Message-ID: <20261118150213.688673101@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 3b05843302202598a6d25f3e2543c8182e6a930c ]

The "Perf attribute expectations test" (perf test 82) fails on machines
that don't ship a bare 'python' binary, i.e. distributions that provide
only python3 unless python-is-python3 or an equivalent is installed.
Namhyung Kim hit this and posted the fix applied here in
<asWLmvF-3YtoKJ7j@google.com>:

  /home/namhyung/project/linux/tools/perf/tests/shell/attr.sh: line 20: python: command not found
  ---- end(-1) ----
   82: Perf attribute expectations test : FAILED!

attr.sh is the only shell test that still invokes python directly; do
what the others do: source lib/setup_python.sh, which prefers python3,
falls back to python and skips the test when no interpreter is found,
then run $PYTHON.

Fixes: 8519e4f44c2af722 ("perf test: Add a shell wrapper for "Setup struct perf_event_attr"")
Reported-by: Namhyung Kim <namhyung@kernel.org>
Suggested-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/linux-perf-users/asWLmvF-3YtoKJ7j@google.com/
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/attr.sh | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/attr.sh b/tools/perf/tests/shell/attr.sh
index 307e1535795a3..ca3ca4a193971 100755
--- a/tools/perf/tests/shell/attr.sh
+++ b/tools/perf/tests/shell/attr.sh
@@ -4,6 +4,10 @@
 
 err=0
 
+shelldir=$(dirname "$0")
+# shellcheck source=lib/setup_python.sh
+. "${shelldir}"/lib/setup_python.sh
+
 cleanup() {
   trap - EXIT TERM INT
 }
@@ -17,7 +21,7 @@ trap trap_cleanup EXIT TERM INT
 
 shelldir=$(dirname "$0")
 perf_path=$(which perf)
-python "${shelldir}"/lib/attr.py -d "${shelldir}"/attr -v -p "$perf_path"
+$PYTHON "${shelldir}"/lib/attr.py -d "${shelldir}"/attr -v -p "$perf_path"
 err=$?
 cleanup
 exit $err
-- 
2.53.0



