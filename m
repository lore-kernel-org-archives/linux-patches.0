Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EBF19D073;
	Thu,  6 Jun 2024 14:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683086; cv=none; b=guhvLSviX3bniNpFKxumNd3Q8I3zcToiI5gcVYj2M7y40xY8GWkd7H0V3dBYzUdjhSq3Bd7NO31y17xa0JOTTvFBj9llL7V2nE0aMdR4A/7eVzFpBeuouc5MfCmLBXP2Qefqg4iN4zkgZeaD0uRBIkuW2jc40JttBvsGW1xWtA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683086; c=relaxed/simple;
	bh=WuXWWCZXz3EU0rGZrdikQMDVnJqifYsKufl1H2OVH8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/V6HfjGtA7sB88RjOldajn6kk24RTdGGxp1BtaG5Ej1VL0Lk5CdKH/Ux43oPZHrw/lASAPwl6kXGwhR9+7g2vIqfI9eVQCErx71PPUBA0W34O96hgxunfMlNJuoWCC3DTN7e2f086AETficMAEWAsQs2yoHZvSPGUZqPNpfb7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijAbc0Rj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijAbc0Rj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80596C4AF0A;
	Thu,  6 Jun 2024 14:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683086;
	bh=WuXWWCZXz3EU0rGZrdikQMDVnJqifYsKufl1H2OVH8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijAbc0Rj8/pPJwj6pguLizifFS233uMQmliFlmzj6NYc4ryqSXotPuFFfpuo7FkWm
	 scZnyhlBMNN3EZ2HUM5Sz0gSDpzvre2Z67pU19VaVMVGFNwWf+sZTZV61Ysv5qulSH
	 4HPeB6bqxL15X/kplhfgxuxYF9Hg/I8NKiG+Yo+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 323/374] selftests: mptcp: join: mark fastclose tests as flaky
Date: Thu,  6 Jun 2024 16:05:02 +0200
Message-ID: <20240606131702.687601035@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 8c06ac2178a9dee887929232226e35a5cdda1793 ]

These tests are flaky since their introduction. This might be less or
not visible depending on the CI running the tests, especially if it is
also busy doing other tasks in parallel, and if a debug kernel config is
being used.

It looks like this issue is often present with the NetDev CI. While this
is being investigated, the tests are marked as flaky not to create
noises on such CIs.

Fixes: 01542c9bf9ab ("selftests: mptcp: add fastclose testcase")
Link: https://github.com/multipath-tcp/mptcp_net-next/issues/324
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240524-upstream-net-20240524-selftests-mptcp-flaky-v1-3-a352362f3f8e@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index e4403236f6554..908ef799b13a0 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -262,6 +262,8 @@ reset()
 
 	TEST_NAME="${1}"
 
+	MPTCP_LIB_SUBTEST_FLAKY=0 # reset if modified
+
 	if skip_test; then
 		MPTCP_LIB_TEST_COUNTER=$((MPTCP_LIB_TEST_COUNTER+1))
 		last_test_ignored=1
@@ -449,7 +451,9 @@ reset_with_tcp_filter()
 # $1: err msg
 fail_test()
 {
-	ret=${KSFT_FAIL}
+	if ! mptcp_lib_subtest_is_flaky; then
+		ret=${KSFT_FAIL}
+	fi
 
 	if [ ${#} -gt 0 ]; then
 		print_fail "${@}"
@@ -3178,6 +3182,7 @@ fullmesh_tests()
 fastclose_tests()
 {
 	if reset_check_counter "fastclose test" "MPTcpExtMPFastcloseTx"; then
+		MPTCP_LIB_SUBTEST_FLAKY=1
 		test_linkfail=1024 fastclose=client \
 			run_tests $ns1 $ns2 10.0.1.1
 		chk_join_nr 0 0 0
@@ -3186,6 +3191,7 @@ fastclose_tests()
 	fi
 
 	if reset_check_counter "fastclose server test" "MPTcpExtMPFastcloseRx"; then
+		MPTCP_LIB_SUBTEST_FLAKY=1
 		test_linkfail=1024 fastclose=server \
 			run_tests $ns1 $ns2 10.0.1.1
 		chk_join_nr 0 0 0 0 0 0 1
-- 
2.43.0



