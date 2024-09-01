Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA81184529;
	Sun,  1 Sep 2024 16:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207935; cv=none; b=GQAoYVTY2YiViBH0Ecbsu5IleHgx8qS/8ICcYEkoR3E6pIdBxwMA4H+2etDJ9ITtadC8uW48Q1Hlm29IuRpNrYF2SGOeESw1IaIcfSCSWsx9EOCr1RmgMrE+7GDr1k5SDiWZOC/vvGziHq7Waii7njkJRG7O8wUY7Hoq2qvwHjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207935; c=relaxed/simple;
	bh=VVSXkFYHUDFG5P6Ry+z2W/JGwc8VwMZcad1j45e/dOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4eY0OCSInP2UHturZ0pv9RntDTM7ZDNMG6I5p/OqijEkk9mFnd5KBtRBW3h8I86uXdiOdMgyWNxdBDYmhoPAH5cJ2DUmWDFq4WSnNh8ydxKRGu9ik1ZX9Mwhp29WVXacQ317+0Y8GpozjRqmjuDRLPwEF7Mj4LBftalfDncqLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1Dy14uw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1Dy14uw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FE9C4CEC4;
	Sun,  1 Sep 2024 16:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207934;
	bh=VVSXkFYHUDFG5P6Ry+z2W/JGwc8VwMZcad1j45e/dOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1Dy14uwuRdWZJh5lwzjSSKEm9Hk9nWudi+0Q80Ci3P+iCfOiWuuBLwC9nYdYUWXC
	 4xHxzcXkKHMzvQq8QZSq/CpPelPzlKM5s6+9tuH8QP/SCWSBTbrTQi0WWCQdmo8oct
	 PVGPJJW0AugZcHLf26TsTjRdFahxSDdYZNRrSmEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 22/93] selftests: mptcp: join: no extra msg if no counter
Date: Sun,  1 Sep 2024 18:16:09 +0200
Message-ID: <20240901160808.195140469@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1256,26 +1256,26 @@ chk_csum_nr()
 
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
@@ -1313,13 +1313,13 @@ chk_fail_nr()
 
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
@@ -1327,13 +1327,13 @@ chk_fail_nr()
 
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


