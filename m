Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA1740801C;
	Thu, 28 May 2026 19:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998156; cv=none; b=O0cPCHzckYMRsGeVBwGYyZKdzXwY5qgp5gjGNQuKE9LNs8jZpLazDWQ129Pnn3LKmkgD3O8hrAkDZlQuLq8z2zqLQ62pRIVJxEc0I7sTE0h0GrY6glLcXNkRa8Yx1CKl7WO/cTIaXdmf15yge4wx3SRYh9jxfG6Yx046NV5Ckwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998156; c=relaxed/simple;
	bh=NGKtidqFnXZ4LNAQvLBAtdvXDWDINnZnBXcpn9UXvJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALD6uUfCjf6cWbZpIbkYg+2WLypXm17unHHKNBKXech6fEt6MugtlUhHDYM2ig6rOvc3RRlUMrCmDCByJ+T7dpAxI5QE5ZEJIGHHi2N6vQN0APMeTV+GHZ696IAFfUMhw7Zr8+k/KxrZQQRz1akHAY9zH7oWStXEDzAM5K15ONA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQZWIwzq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQZWIwzq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB921F000E9;
	Thu, 28 May 2026 19:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998155;
	bh=LBcvB3d32vjoEgOIroNLZ4vSumLd5BO7/LjS//OpnlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cQZWIwzqrHPIMDdGTY+MhkduwaynPqoVGAyDUPNyFxlwG/opUU5jmVHCPr6akLrEy
	 CR/dUMzApxdMv6RQr9kjj0EcPeh3oYaExOnUWZysLVhXKg/4gl/eEH7poLQdsjGA93
	 R+kjLCgDfNZE3MNt5cNZbh+REKZkE/+NzdV120XI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.0 072/461] selftests: mptcp: drop nanoseconds width specifier
Date: Thu, 28 May 2026 21:43:21 +0200
Message-ID: <20260528194649.004686256@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 01ff78e4b3d98689184c52d97f9575dfbdc3b10f upstream.

Using the format specifier +%s%3N with GNU date is honoured, and only
prints 3 digits of the nanoseconds portion of the seconds since epoch,
which corresponds to the milliseconds.

The uutils implementation of date currently does not honour this, and
always prints all 9 digits. This is a known issue [1], but can be worked
around by adapting this test to use nanoseconds instead of microseconds,
and then divide it by 1e6.

This fix is similar to what has been done on systemd side [2], and it is
needed to run the selftests on Ubuntu 26.04, containing uutils 0.8.0.

Note that the Fixes tag is there even if this patch doesn't fix an issue
in the kernel selftests, but it is useful for those using uutils 0.8.0.

Fixes: 048d19d444be ("mptcp: add basic kselftest for mptcp")
Cc: stable@vger.kernel.org
Link: https://github.com/uutils/coreutils/issues/11658 [1]
Link: https://github.com/systemd/systemd/pull/41627 [2]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260515-net-mptcp-misc-fixes-7-1-rc4-v2-6-701e96419f2f@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_connect.sh |    6 +++---
 tools/testing/selftests/net/mptcp/mptcp_lib.sh     |   10 +++++-----
 2 files changed, 8 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_connect.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect.sh
@@ -401,7 +401,7 @@ do_transfer()
 	mptcp_lib_wait_local_port_listen "${listener_ns}" "${port}"
 
 	local start
-	start=$(date +%s%3N)
+	start=$(date +%s%N)
 	ip netns exec ${connector_ns} \
 		./mptcp_connect -t ${timeout_poll} -p $port -s ${cl_proto} \
 			$extra_args $connect_addr < "$cin" > "$cout" &
@@ -423,7 +423,7 @@ do_transfer()
 	fi
 
 	local stop
-	stop=$(date +%s%3N)
+	stop=$(date +%s%N)
 
 	if $capture; then
 		sleep 1
@@ -439,7 +439,7 @@ do_transfer()
 	fi
 
 	local duration
-	duration=$((stop-start))
+	duration=$(((stop-start) / 1000000))
 	printf "(duration %05sms) " "${duration}"
 	if [ ${rets} -ne 0 ] || [ ${retc} -ne 0 ] || [ ${timeout_pid} -ne 0 ]; then
 		mptcp_lib_pr_fail "client exit code $retc, server $rets"
--- a/tools/testing/selftests/net/mptcp/mptcp_lib.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_lib.sh
@@ -28,7 +28,7 @@ declare -rx MPTCP_LIB_AF_INET6=10
 MPTCP_LIB_SUBTESTS=()
 MPTCP_LIB_SUBTESTS_DUPLICATED=0
 MPTCP_LIB_SUBTEST_FLAKY=0
-MPTCP_LIB_SUBTESTS_LAST_TS_MS=
+MPTCP_LIB_SUBTESTS_LAST_TS_NS=
 MPTCP_LIB_TEST_COUNTER=0
 MPTCP_LIB_TEST_FORMAT="%02u %-50s"
 MPTCP_LIB_IP_MPTCP=0
@@ -236,7 +236,7 @@ mptcp_lib_kversion_ge() {
 }
 
 mptcp_lib_subtests_last_ts_reset() {
-	MPTCP_LIB_SUBTESTS_LAST_TS_MS="$(date +%s%3N)"
+	MPTCP_LIB_SUBTESTS_LAST_TS_NS="$(date +%s%N)"
 }
 mptcp_lib_subtests_last_ts_reset
 
@@ -255,7 +255,7 @@ __mptcp_lib_result_check_duplicated() {
 __mptcp_lib_result_add() {
 	local result="${1}"
 	local time="time="
-	local ts_prev_ms
+	local ts_prev_ns
 	shift
 
 	local id=$((${#MPTCP_LIB_SUBTESTS[@]} + 1))
@@ -265,9 +265,9 @@ __mptcp_lib_result_add() {
 	# not to add two '#'
 	[[ "${*}" != *"#"* ]] && time="# ${time}"
 
-	ts_prev_ms="${MPTCP_LIB_SUBTESTS_LAST_TS_MS}"
+	ts_prev_ns="${MPTCP_LIB_SUBTESTS_LAST_TS_NS}"
 	mptcp_lib_subtests_last_ts_reset
-	time+="$((MPTCP_LIB_SUBTESTS_LAST_TS_MS - ts_prev_ms))ms"
+	time+="$(((MPTCP_LIB_SUBTESTS_LAST_TS_NS - ts_prev_ns) / 1000000))ms"
 
 	MPTCP_LIB_SUBTESTS+=("${result} ${id} - ${KSFT_TEST}: ${*} ${time}")
 }


