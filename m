Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30BB71494DB;
	Thu,  5 Sep 2024 10:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530545; cv=none; b=JMMoKIuSt8yqBlaD/360rVoDaU/frqDdYs39eR3TNOs3wqDMEs7kkFH9HRTBG9XCpXn/kjNU0grr9WRmyy77vMd8VB3oSuKfhv/Sw/uJo944hYcwRs+g06/+rst8i5EcO0ctAzu6VTl9bEoOYJGRjDYQbk9ySlEmwF8etM2nVwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530545; c=relaxed/simple;
	bh=OgcqFzMhLW1ZjCpIPpCghiM4+cyutWCz9q6BOgqiq5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHuY7v3qbLJGZA19xEIa0BGAwXcuNgSiHGnb5CYpnsRFdrs2K2ZZUW1jFNic/0L37iR4dJuv3erDvyTTAErZ0XZ8MqfBwdHONmvsGsrTmKD18zYIOOBHsoR5Rm24C8qhsJ0d/GNa3Iq5gAZURog97gsfDxZaAO4Y0NN7beozTuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUL1CwDE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUL1CwDE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96688C4CEC3;
	Thu,  5 Sep 2024 10:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530545;
	bh=OgcqFzMhLW1ZjCpIPpCghiM4+cyutWCz9q6BOgqiq5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUL1CwDEjjLu4DtY2l655iTMohYtyqQhd/UWW6jXPueU2h3tPzwx+hJb/YeyRNUCx
	 zz2kY6VFJg+4HXbDm6y2i0+AJRVG66nLtLlybsQSDVP5KOqC5cFNJzM32j+gKI+sdn
	 De/2H78LYSmiCBmnuZvmmZXLrlleYfTear1zGT1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 026/101] selftests: mptcp: join: no extra msg if no counter
Date: Thu,  5 Sep 2024 11:40:58 +0200
Message-ID: <20240905093717.146671776@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

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
[ Conflicts in mptcp_join.sh, because the context is different, but the
  exact same fix can still be applied on the modified lines: adding
  '[ -n "$count" ]', and fixing the indentation. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1252,13 +1252,13 @@ chk_csum_nr()
 
 	printf "%-${nr_blank}s %s" " " "sum"
 	count=$(get_counter ${ns1} "MPTcpExtDataCsumErr")
-	if [ "$count" != "$csum_ns1" ]; then
+	if [ -n "$count" ] && [ "$count" != "$csum_ns1" ]; then
 		extra_msg="$extra_msg ns1=$count"
 	fi
 	if [ -z "$count" ]; then
 		echo -n "[skip]"
 	elif { [ "$count" != $csum_ns1 ] && [ $allow_multi_errors_ns1 -eq 0 ]; } ||
-	   { [ "$count" -lt $csum_ns1 ] && [ $allow_multi_errors_ns1 -eq 1 ]; }; then
+	     { [ "$count" -lt $csum_ns1 ] && [ $allow_multi_errors_ns1 -eq 1 ]; }; then
 		echo "[fail] got $count data checksum error[s] expected $csum_ns1"
 		fail_test
 		dump_stats=1
@@ -1267,13 +1267,13 @@ chk_csum_nr()
 	fi
 	echo -n " - csum  "
 	count=$(get_counter ${ns2} "MPTcpExtDataCsumErr")
-	if [ "$count" != "$csum_ns2" ]; then
+	if [ -n "$count" ] && [ "$count" != "$csum_ns2" ]; then
 		extra_msg="$extra_msg ns2=$count"
 	fi
 	if [ -z "$count" ]; then
 		echo -n "[skip]"
 	elif { [ "$count" != $csum_ns2 ] && [ $allow_multi_errors_ns2 -eq 0 ]; } ||
-	   { [ "$count" -lt $csum_ns2 ] && [ $allow_multi_errors_ns2 -eq 1 ]; }; then
+	     { [ "$count" -lt $csum_ns2 ] && [ $allow_multi_errors_ns2 -eq 1 ]; }; then
 		echo "[fail] got $count data checksum error[s] expected $csum_ns2"
 		fail_test
 		dump_stats=1
@@ -1315,13 +1315,13 @@ chk_fail_nr()
 
 	printf "%-${nr_blank}s %s" " " "ftx"
 	count=$(get_counter ${ns_tx} "MPTcpExtMPFailTx")
-	if [ "$count" != "$fail_tx" ]; then
+	if [ -n "$count" ] && [ "$count" != "$fail_tx" ]; then
 		extra_msg="$extra_msg,tx=$count"
 	fi
 	if [ -z "$count" ]; then
 		echo -n "[skip]"
 	elif { [ "$count" != "$fail_tx" ] && [ $allow_tx_lost -eq 0 ]; } ||
-	   { [ "$count" -gt "$fail_tx" ] && [ $allow_tx_lost -eq 1 ]; }; then
+	     { [ "$count" -gt "$fail_tx" ] && [ $allow_tx_lost -eq 1 ]; }; then
 		echo "[fail] got $count MP_FAIL[s] TX expected $fail_tx"
 		fail_test
 		dump_stats=1
@@ -1331,13 +1331,13 @@ chk_fail_nr()
 
 	echo -n " - failrx"
 	count=$(get_counter ${ns_rx} "MPTcpExtMPFailRx")
-	if [ "$count" != "$fail_rx" ]; then
+	if [ -n "$count" ] && [ "$count" != "$fail_rx" ]; then
 		extra_msg="$extra_msg,rx=$count"
 	fi
 	if [ -z "$count" ]; then
 		echo -n "[skip]"
 	elif { [ "$count" != "$fail_rx" ] && [ $allow_rx_lost -eq 0 ]; } ||
-	   { [ "$count" -gt "$fail_rx" ] && [ $allow_rx_lost -eq 1 ]; }; then
+	     { [ "$count" -gt "$fail_rx" ] && [ $allow_rx_lost -eq 1 ]; }; then
 		echo "[fail] got $count MP_FAIL[s] RX expected $fail_rx"
 		fail_test
 		dump_stats=1


