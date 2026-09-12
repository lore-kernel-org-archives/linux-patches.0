Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107412DBF75;
	Sat, 12 Sep 2026 12:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214623; cv=none; b=EIZu3UTf4LxDquZMy33eG1cSO5QBRnNC+5GssuZiB5VZ2fBDrnu3rC83nw6jEYFJiCD+S3KsbbmGeW3qWcxssk51t95zWhkYenv6fZOhzv4aMaonR/RV0ihYKLwpvGg5Cvu0uIRm2G6tVHdPVZykeRrV824pWWiEbBPw/YmOPo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214623; c=relaxed/simple;
	bh=kiVfB33z65hOGfiORZLoU52YCbCycbJC6eGLvQA9PvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkh3vIo714+G1Njy2ag7mwOexSfUSuE/y887PJ0ejCyVWFJwyN6AEKzob+Tc7M/cNeVCGV0Bp4X1NKN4Ey0iFOUTftlehNgrasnc3MwTXM/8Qw6sy26QxHOTKcVKwMDf5MD91p8DCVNjZDqyftXNbEfB9j04QG0gQwxyg/x8kU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Xp8LDKT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Xp8LDKT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B0B1F000FF;
	Sat, 12 Sep 2026 12:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214621;
	bh=Fhc7XnPsFnypcHbrdBG89fdDugg/SfWgzlRp8TfRlWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Xp8LDKTcrSEd92MEPOm/A7dYygNcSF2k4WF4m+ITkrs2Y64V1/J1A6509fVHki6q
	 i5sVlGZvxPHxLsJm2oru1CWeYEMvrog9vKBOiajlbVYOtr7aYBh3LVHZU1RrtEl6Fr
	 5KXIQ6eINSDycqWFjn5POEEZjxW2dQ2vxyc1D8kM=
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
Subject: [PATCH 6.12 0363/1376] perf test: Refactor brstack test
Date: Sat, 12 Sep 2026 08:46:29 +0200
Message-ID: <20260912065615.640903787@linuxfoundation.org>
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

[ Upstream commit f15548b277cc107d41b88b1a63bd4942b703666b ]

check_branches() will be used by other tests in a later commit so make
it a function. And the any_call filters are duplicated and will also
be extended in a later commit, so move them to a variable.

No functional changes intended.

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
 tools/perf/tests/shell/test_brstack.sh | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/tools/perf/tests/shell/test_brstack.sh b/tools/perf/tests/shell/test_brstack.sh
index 9138fa83bf36d..46e5aa9ce8ee7 100755
--- a/tools/perf/tests/shell/test_brstack.sh
+++ b/tools/perf/tests/shell/test_brstack.sh
@@ -34,6 +34,13 @@ trap_cleanup() {
 }
 trap trap_cleanup EXIT TERM INT
 
+check_branches() {
+	if ! tr -s ' ' '\n' < "$TMPDIR/perf.script" | grep -E -m1 -q "$1"; then
+		echo "Branches missing $1"
+		err=1
+	fi
+}
+
 test_user_branches() {
 	echo "Testing user branch stack sampling"
 
@@ -55,11 +62,7 @@ test_user_branches() {
 	)
 	for x in "${expected[@]}"
 	do
-		if ! tr -s ' ' '\n' < "$TMPDIR/perf.script" | grep -E -m1 -q "$x"
-		then
-			echo "Branches missing $x"
-			err=1
-		fi
+		check_branches "$x"
 	done
 	# some branch types are still not being tested:
 	# IND COND_CALL COND_RET SYSCALL SYSRET IRQ SERROR NO_TX
@@ -101,14 +104,16 @@ set -e
 
 test_user_branches
 
-test_filter "any_call"	"CALL|IND_CALL|COND_CALL|SYSCALL|IRQ"
+any_call="CALL|IND_CALL|COND_CALL|SYSCALL|IRQ"
+
+test_filter "any_call" "$any_call"
 test_filter "call"	"CALL|SYSCALL"
 test_filter "cond"	"COND"
 test_filter "any_ret"	"RET|COND_RET|SYSRET|ERET"
 
 test_filter "call,cond"		"CALL|SYSCALL|COND"
-test_filter "any_call,cond"		"CALL|IND_CALL|COND_CALL|IRQ|SYSCALL|COND"
-test_filter "cond,any_call,any_ret"	"COND|CALL|IND_CALL|COND_CALL|SYSCALL|IRQ|RET|COND_RET|SYSRET|ERET"
+test_filter "any_call,cond"	    "$any_call|COND"
+test_filter "any_call,cond,any_ret" "$any_call|COND|RET|COND_RET"
 
 cleanup
 exit $err
-- 
2.53.0



