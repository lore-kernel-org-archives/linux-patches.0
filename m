Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9A35381A;
	Sun,  1 Sep 2024 16:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208273; cv=none; b=mMAtKvJgmDwacvPEQAet4DlkIpBn1a+L9JQXj4BRhMcZVfBL4HfCj8VUuYEnyC5RQgjD0YxXSobXOFhSTjvOAwOZpJby6zhOaZBU6K7iBPQ7m2aBHCavkOAtPy/5XH0EthC9JP7tfJbI5RnJj+NYx+xhjeB6fz25OXgwVgINQHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208273; c=relaxed/simple;
	bh=ho7BwAHeBi1ryyGxEmQu3l6NfJ1ga9HYje020TjbYrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLwnZy0SN80z0biR7YR8k6ubILAYJx7BgQfrhUxQ/0gP27hItuIraeOLwFSFZ4Lr8Ms7+jiiT9ZlNXAnX7LUnSeH0SOqgPkvhhJzFLv0j+M7TGT6k7XgpfqOzDcQ/tCoFvEGoRkucZnAWGonYuU9L3nGGbDOebJWyq1HsF8QN8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cNnpbV9q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cNnpbV9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52492C4CEC4;
	Sun,  1 Sep 2024 16:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208273;
	bh=ho7BwAHeBi1ryyGxEmQu3l6NfJ1ga9HYje020TjbYrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cNnpbV9qaoRgzXrXwUm46wUpRn0GAf3/sUgb2jigfKyx5RWs1wtQei4tiytT4iT/d
	 kOKbtN11oN6X4nV504P3ZxyZLtamv32fFr0XBM7q4tDpV0x3THJfvAqc2yWF5c5OdM
	 UTiHJOZn8TckUxGV3BXv1envDb0SGaD79ENtv92A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.10 032/149] selftests: mptcp: join: no extra msg if no counter
Date: Sun,  1 Sep 2024 18:15:43 +0200
Message-ID: <20240901160818.671105966@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 76a2d8394cc183df872adf04bf636eaf42746449 upstream.

The checksum and fail counters might not be available. Then no need to
display an extra message with missing info.

While at it, fix the indentation around, which is wrong since the same
commit.

Fixes: 47867f0a7e83 ("selftests: mptcp: join: skip check if MIB counter not supported")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1112,26 +1112,26 @@ chk_csum_nr()
 
 	print_check "sum"
 	count=$(mptcp_lib_get_counter ${ns1} "MPTcpExtDataCsumErr")
-	if [ "$count" != "$csum_ns1" ]; then
+	if [ -n "$count" ] && [ "$count" != "$csum_ns1" ]; then
 		extra_msg+=" ns1=$count"
 	fi
 	if [ -z "$count" ]; then
 		print_skip
 	elif { [ "$count" != $csum_ns1 ] && [ $allow_multi_errors_ns1 -eq 0 ]; } ||
-	   { [ "$count" -lt $csum_ns1 ] && [ $allow_multi_errors_ns1 -eq 1 ]; }; then
+	     { [ "$count" -lt $csum_ns1 ] && [ $allow_multi_errors_ns1 -eq 1 ]; }; then
 		fail_test "got $count data checksum error[s] expected $csum_ns1"
 	else
 		print_ok
 	fi
 	print_check "csum"
 	count=$(mptcp_lib_get_counter ${ns2} "MPTcpExtDataCsumErr")
-	if [ "$count" != "$csum_ns2" ]; then
+	if [ -n "$count" ] && [ "$count" != "$csum_ns2" ]; then
 		extra_msg+=" ns2=$count"
 	fi
 	if [ -z "$count" ]; then
 		print_skip
 	elif { [ "$count" != $csum_ns2 ] && [ $allow_multi_errors_ns2 -eq 0 ]; } ||
-	   { [ "$count" -lt $csum_ns2 ] && [ $allow_multi_errors_ns2 -eq 1 ]; }; then
+	     { [ "$count" -lt $csum_ns2 ] && [ $allow_multi_errors_ns2 -eq 1 ]; }; then
 		fail_test "got $count data checksum error[s] expected $csum_ns2"
 	else
 		print_ok
@@ -1169,13 +1169,13 @@ chk_fail_nr()
 
 	print_check "ftx"
 	count=$(mptcp_lib_get_counter ${ns_tx} "MPTcpExtMPFailTx")
-	if [ "$count" != "$fail_tx" ]; then
+	if [ -n "$count" ] && [ "$count" != "$fail_tx" ]; then
 		extra_msg+=",tx=$count"
 	fi
 	if [ -z "$count" ]; then
 		print_skip
 	elif { [ "$count" != "$fail_tx" ] && [ $allow_tx_lost -eq 0 ]; } ||
-	   { [ "$count" -gt "$fail_tx" ] && [ $allow_tx_lost -eq 1 ]; }; then
+	     { [ "$count" -gt "$fail_tx" ] && [ $allow_tx_lost -eq 1 ]; }; then
 		fail_test "got $count MP_FAIL[s] TX expected $fail_tx"
 	else
 		print_ok
@@ -1183,13 +1183,13 @@ chk_fail_nr()
 
 	print_check "failrx"
 	count=$(mptcp_lib_get_counter ${ns_rx} "MPTcpExtMPFailRx")
-	if [ "$count" != "$fail_rx" ]; then
+	if [ -n "$count" ] && [ "$count" != "$fail_rx" ]; then
 		extra_msg+=",rx=$count"
 	fi
 	if [ -z "$count" ]; then
 		print_skip
 	elif { [ "$count" != "$fail_rx" ] && [ $allow_rx_lost -eq 0 ]; } ||
-	   { [ "$count" -gt "$fail_rx" ] && [ $allow_rx_lost -eq 1 ]; }; then
+	     { [ "$count" -gt "$fail_rx" ] && [ $allow_rx_lost -eq 1 ]; }; then
 		fail_test "got $count MP_FAIL[s] RX expected $fail_rx"
 	else
 		print_ok


