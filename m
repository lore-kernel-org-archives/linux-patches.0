Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019823;
	b=lgK6DXuyqKyorJXScQJKPNXYSyM+rPrWPRRPu5hR6ZzGsKuZPE7CMb3x22GSE+8AERiD
	 RWuH2YEZy3gHbIWo3ALG1cEZQ2rP/20iPHEidamVXRuRxL6BeXEkszvcyY96m9LvrzoqB
	 qHmF2IyWYg4MSELfR+eNkNqW1ZQBCrNwXq6dJXoSoExYNqhWN/B6mg//DNapXt357lL3p
	 3d2rZWmpgt4PrHex93PJF3VHybygxJkwc2ovCrdS298C/kcVCPYRZVAvUUIuJVGvpm8RU
	 Ofa7F5hQFopadgIMqaJxtTJASbI0uJERQzpu/EAe4++wajuFC1ou+4MGXSMOc/w/ScQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z8cEMCv1ZPsEOwlaFL4eF4eRSE2Fxro94KD+GxnUnQM=;
	b=Ig6tYBOFOVsgMvvfitmbuwiGeMmO9eHfzlkwB+tz7/JTX/vrp/DCpB9VY61Ci9o5ODyy
	 zJWz8S1GBkxJCD6X52cNW7GYk+26qxucQjV0P0TO3pdPF2Xj5svfEW5NNupMkXVGj5Q1m
	 olkCEtUO1W6gRuG1j04VowNuO1AcsuY0xme7PvpyxNPXBKvsaRhUsgJCCqLvCFDeWO07G
	 Wzzzg9hyq7JTR8iHw8grGhR1MWlGhEvqt2MBaXoBDIiYxBeBK4FiAfOPD7y/ZhVLHrIw7
	 Ev9O1kgp45vQxG7Fj86q/FeGmvcdhxx0fnVKQAEZtkTDc4dykgmz2d4qY1kJ7HQ3M0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBp17eBC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF7F60A2622;
	Wed, 18 Nov 2026 16:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBp17eBC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4989F1F000C7;
	Wed, 18 Nov 2026 16:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019822;
	bh=Z8cEMCv1ZPsEOwlaFL4eF4eRSE2Fxro94KD+GxnUnQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HBp17eBCqqfuqPa+XmM9YgCdP8uvaiz3cUaQi9gV3qkMIvIbDltJWiej3r4vrhe4u
	 j5fb8tDrlq56vwblBfCZ5bog+Q6r678dHSEwSXoqGeaYNMLA7OsRBLTNVlwG+blXdC
	 yqKkGajoy/Bt5aOlKUFi2MdkTJ2/aZgO4WKPIlZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1732/2651] perf test attr: Source setup_python.sh instead of calling python
Date: Wed, 18 Nov 2026 15:49:32 +0100
Message-ID: <20261118150349.970582586@linuxfoundation.org>
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



