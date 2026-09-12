Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B933DD51A;
	Sat, 12 Sep 2026 12:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214627; cv=none; b=EHKp+C3RTnitz7tVYP6bebmiGw20TRppiVRledvN//9MZOr4VPQEjjlPa6ylkw1UjAflhNTuwXrTKHOjrvdjL1MDlcCyF/mOboE9AOd37bK+lUz9bGHlwsZRVkXY11dyvipz0QRVhFzYmwSh3dhDuBKrY3Qj6waftZ3dMaq38H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214627; c=relaxed/simple;
	bh=EtAuicNHm4reWNt61h2l3E99G13x/w7MmZo86Cdo+ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJGYGK99CAbind2/Ry7WBaclxzXZPVMAcMIKTpXe5g4HAgCu9hXlrBBlFx7ri8AnZF+N+Xjvl6+baNtYi70RCct89WzKQZs6BOKOgNiEnpiop3R7xqtNssbtXeEXOEG+uuulysSPs7XB1gPUinmZc7/icUo16EpOUl0TAnLuBAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BLXeNP0I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BLXeNP0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236281F000FF;
	Sat, 12 Sep 2026 12:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214626;
	bh=9ByHD2gmvbvVnfngdRTA+iUEOkj2MKqksJJCmz/3ZnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BLXeNP0IMFsKA3lCuFR/ItrqKPybQQEFad/QOvb5yYxnduKKoNubPuoXhPhydZASj
	 vP/pecIiNkBs05sM+/5aBME/J7WUH1q/YWhg8AQ476qPDPwiBcFa6xAtimo1+B1k/R
	 wgpR9fEya21MeWHMbQjwBQlIYCr8Dcf0apLN8mEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Adam Young <admiyo@os.amperecomputing.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	German Gomez <german.gomez@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Rob Herring <robh@kernel.org>,
	Will Deacon <will@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0364/1376] perf test: Add syscall and address tests to brstack test
Date: Sat, 12 Sep 2026 08:46:30 +0200
Message-ID: <20260912065615.663244741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@linaro.org>

[ Upstream commit 11e59335b0d1c4bc259ee6f0533e04c4b3a9f1dd ]

Test that SYSCALL type branches are emitted from the expected 'getppid'
symbol. Test that when only 'k' is used, sources addresses are all in
the kernel. Test that no kernel addresses leak by checking for them in
the 'u' test.

Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: James Clark <james.clark@linaro.org>
Cc: Adam Young <admiyo@os.amperecomputing.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: German Gomez <german.gomez@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: 344d3aec164d ("perf tests: Fix flakiness in branch stack sampling tests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/test_brstack.sh | 61 +++++++++++++++++++++++++-
 1 file changed, 60 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/test_brstack.sh b/tools/perf/tests/shell/test_brstack.sh
index 46e5aa9ce8ee7..252d22d39c7b0 100755
--- a/tools/perf/tests/shell/test_brstack.sh
+++ b/tools/perf/tests/shell/test_brstack.sh
@@ -64,8 +64,50 @@ test_user_branches() {
 	do
 		check_branches "$x"
 	done
+
+	# Dump addresses only this time
+	perf script -i "$TMPDIR/perf.data" --fields brstack | \
+		tr ' ' '\n' > "$TMPDIR/perf.script"
+
+	# There should be no kernel addresses with the u option, in either
+	# source or target addresses.
+	if grep -E -m1 "0x[89a-f][0-9a-f]{15}" $TMPDIR/perf.script; then
+		echo "ERROR: Kernel address found in user mode"
+		err=1
+	fi
 	# some branch types are still not being tested:
-	# IND COND_CALL COND_RET SYSCALL SYSRET IRQ SERROR NO_TX
+	# IND COND_CALL COND_RET SYSRET IRQ SERROR NO_TX
+}
+
+
+test_kernel_branches() {
+	echo "Testing that k option only includes kernel source addresses"
+
+	if ! perf record --branch-filter any,k -o- -- true > /dev/null; then
+		echo "skip: not enough privileges"
+	else
+		perf record -o $TMPDIR/perf.data --branch-filter any,k -- \
+			perf bench syscall basic --loop 1000
+		perf script -i $TMPDIR/perf.data --fields brstack | \
+			tr ' ' '\n' > $TMPDIR/perf.script
+
+		# Example of branch entries:
+		#       "0xffffffff93bda241/0xffffffff93bda20f/M/-/-/..."
+		# Source addresses come first and target address can be either
+		# userspace or kernel even with k option, as long as the source
+		# is in kernel.
+
+		#Look for source addresses with top bit set
+		if ! grep -E -m1 "^0x[89a-f][0-9a-f]{15}" $TMPDIR/perf.script; then
+			echo "ERROR: Kernel branches missing"
+			err=1
+		fi
+		# Look for no source addresses without top bit set
+		if grep -E -m1 "^0x[0-7][0-9a-f]{0,15}" $TMPDIR/perf.script; then
+			echo "ERROR: User branches found with kernel filter"
+			err=1
+		fi
+	fi
 }
 
 # first argument <arg0> is the argument passed to "--branch-stack <arg0>,save_type,u"
@@ -100,9 +142,26 @@ test_filter() {
 	fi
 }
 
+test_syscall() {
+	echo "Testing syscalls"
+	# skip if perf doesn't have enough privileges
+	if ! perf record --branch-filter any,k -o- -- true > /dev/null; then
+		echo "skip: not enough privileges"
+	else
+		perf record -o $TMPDIR/perf.data --branch-filter \
+			any_call,save_type,u,k -c 10000 -- \
+			perf bench syscall basic --loop 1000
+		perf script -i $TMPDIR/perf.data --fields brstacksym | \
+			tr ' ' '\n' > $TMPDIR/perf.script
+
+		check_branches "getppid[^ ]*/SYSCALL/"
+	fi
+}
 set -e
 
 test_user_branches
+test_syscall
+test_kernel_branches
 
 any_call="CALL|IND_CALL|COND_CALL|SYSCALL|IRQ"
 
-- 
2.53.0



