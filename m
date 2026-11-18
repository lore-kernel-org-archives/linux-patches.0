Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015749;
	b=IQcCPA1Yi07lGVw9ejR8RE+nntqJpZN2sbuyKvZOUuJ4ViTtd9rhZykPDb4NZdZtiQEr
	 kvuIXnpfQIY1kARXa/ohMZrqbgI8Ur2ECYUA79J+AAZl9lxBN0UgvlEJLGRdatLGRaQqN
	 XpIovyzsiMUKhjkqQHM34doQs0tzpbCmqeq16liRJY2wC9qyzG48RDd2vDfrzeeH9EUi/
	 GS1LNSuD/wegdqid9nBXYfIgycG6xBfEk97lOzxDhVMhBKZwNjhMR98wFpDEx8CyecU0P
	 OndSNiQAMr5vcEYFCLfn53bj1ajrsEmTA2qwDyi/UQtttYICBt9eGv8X95ttBvadmvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015749;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eFJeA137oM2LSwO7+jPNURiQBk9rLicAzkPlMRkr/jA=;
	b=Sx3oJO/am4Q23tExfbOqfBCRwwYkm3WERcls9A6DqKpi/JOFVzunA4v5oNvn7SuWTf9Y
	 MMm+MsD2SUVtTGOc4dN2So/dqIHIwe1jwxrfzWXCz5/oWULZH2fKMnD1Vl5Nkq4znXAzD
	 0ADYxWecGsRkJkRpbiTPU93Lz//miPxMLgmiyGFWp1GbrKCLT2s/0Rn8BRpzuKReO16n2
	 +FbLVeh1cuafST0eZo8U3uH7O50tZg+oGXXgEPNh4X3dt240t/dppmIES5rVpxlJZee3V
	 qER03zeQKfNPQhRPWrQYa8kNXiCPfpz1JSQRVvD0WkzpP6K2bnGOS/pn4lmQ7UcB2nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g0aLwUvY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D09606A33E;
	Wed, 18 Nov 2026 15:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g0aLwUvY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930B31F000C8;
	Wed, 18 Nov 2026 15:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015749;
	bh=eFJeA137oM2LSwO7+jPNURiQBk9rLicAzkPlMRkr/jA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g0aLwUvYlsbuRFlGL3baWtfI3w14/tScIWanjnvqyXemy8mMkkRt2Q057xOQCzcMG
	 EScsFGgJXVlsnvKV+6RNzpn1MGdrAr6qKDPtfRPDh9deyyBse1XMBsPm1gFC9TxB3/
	 jQJHxrrr8FY5QrtyTS9dHr41IRmMSEGjsY+z8R08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Tomlin <atomlin@atomlin.com>,
	Ian Rogers <irogers@google.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0283/2651] perf test: perf stat tests fails on s390
Date: Wed, 18 Nov 2026 15:25:23 +0100
Message-ID: <20261118150258.099540546@linuxfoundation.org>
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

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 454e049a3f6528a04f96afb4cbef1fcbb49c2d0f ]

The test case 'perf stat tests' fails on s390 z/VM machines. The
root cause is the unsupported CPU measurement facility on z/VM.
Therefore the events cycles and instructions do not exist and
are unsupported. This cause the subtest
  Hide zero events stat test
to fail.

Output before:
 # perf test 116
 116: perf stat tests  : FAILED!

 === Test Summary ===
 Passed main tests : 0
 Passed subtests   : 0
 Skipped tests     : 0
 Failed tests      : 1
 List of failed tests:
  116: perf stat tests
 #

Output after:
 # ./perf test 116
 116: perf stat tests  : Ok

 === Test Summary ===
 Passed main tests : 1
 Passed subtests   : 0
 Skipped tests     : 0
 Failed tests      : 0
 #

Fixes: 64724095a33fbee8 ("perf stat: Add --hide-zero-events option to suppress zero-count events")
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Cc: Aaron Tomlin <atomlin@atomlin.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/stat.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/tests/shell/stat.sh b/tools/perf/tests/shell/stat.sh
index 298ce454b45a1..1f5d4cc05807a 100755
--- a/tools/perf/tests/shell/stat.sh
+++ b/tools/perf/tests/shell/stat.sh
@@ -583,6 +583,11 @@ test_hide_zero_events_stat() {
   # Check that --metric-only works with --hide-zero-events
   if ! perf stat --hide-zero-events --metric-only -e instructions,cycles true > "${stat_output}" 2>&1
   then
+    if grep -sq 'No supported events found' "${stat_output}"
+    then
+      echo "Hide zero events stat test [Skipped - events not supported]"
+      return
+    fi
     echo "Hide zero events stat test [Failed - metric-only command failed]"
     err=1
     return
-- 
2.53.0



