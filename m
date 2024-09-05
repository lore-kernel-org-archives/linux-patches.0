Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1423C197A77;
	Thu,  5 Sep 2024 09:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725529443; cv=none; b=blU9ZCRwoQIfro523dbhYGCoKTg80CCXRdxFd03F3/osig6lS54c4OsnKT4IcSIevxvFR6YEV3AH1Bcbg8PdQPazfIC6aKeb/HWW+TuCt61irYgetQZsGdVbuDtxYt+QnU3go+7jx9F+VaERtSeBeJyXT7V4q3VQtEGvMSq/jJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725529443; c=relaxed/simple;
	bh=OAGEvi/h64M6Vdoq35z5LJdPxr6YxYAedNPmtoF7JvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cr4SYn8hFZ3IyMqiLruOHfCFzdPKMJUGBiVARjwoJ8Yf9Uqu2OSX8VnoXsBB1/Ps1We2JYerFFBe/PWT8iMRnITQAkom0K6nCu9bBYuLShuc2HLmOdQ1Tjah3Kob4u93rsadtzLLcYBCzGDBMds6qFi8Ukh6+79dkSMijiCZ0lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSECiMNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSECiMNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E45C4CEC3;
	Thu,  5 Sep 2024 09:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725529442;
	bh=OAGEvi/h64M6Vdoq35z5LJdPxr6YxYAedNPmtoF7JvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qSECiMNI0QXUstsgx+FGKF7VvQyHsPIw+XE+1h9lqFnr5+1lEa1vrDuQCiWJEOEmb
	 yXkHV1Q+N0yDFZTplgzQmBOPWaZWM9CJVkrpKutjvxL0YCQbGjQngsCbDlhyLRkk+s
	 0ftjJ9MOrIZrAUXCQ1dEZ2BkUMySxoeSU7FgJjCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 035/184] selftests: mptcp: join: check re-using ID of unused ADD_ADDR
Date: Thu,  5 Sep 2024 11:39:08 +0200
Message-ID: <20240905093733.619294728@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093732.239411633@linuxfoundation.org>
References: <20240905093732.239411633@linuxfoundation.org>
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

[ Upstream commit a13d5aad4dd9a309eecdc33cfd75045bd5f376a3 ]

This test extends "delete re-add signal" to validate the previous
commit. An extra address is announced by the server, but this address
cannot be used by the client. The result is that no subflow will be
established to this address.

Later, the server will delete this extra endpoint, and set a new one,
with a valid address, but re-using the same ID. Before the previous
commit, the server would not have been able to announce this new
address.

While at it, extra checks have been added to validate the expected
numbers of MPJ, ADD_ADDR and RM_ADDR.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: b6c08380860b ("mptcp: remove addr and subflow in PM netlink")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240819-net-mptcp-pm-reusing-id-v1-2-38035d40de5b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1c2326fcae4f ("selftests: mptcp: join: check re-adding init endp with != id")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh  | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index fb2d8326109ef..a4d8475ff45fe 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3630,9 +3630,11 @@ endpoint_tests()
 	# remove and re-add
 	if reset "delete re-add signal" &&
 	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
-		pm_nl_set_limits $ns1 1 1
-		pm_nl_set_limits $ns2 1 1
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_set_limits $ns2 2 2
 		pm_nl_add_endpoint $ns1 10.0.2.1 id 1 flags signal
+		# broadcast IP: no packet for this address will be received on ns1
+		pm_nl_add_endpoint $ns1 224.0.0.1 id 2 flags signal
 		test_linkfail=4 speed=20 \
 			run_tests $ns1 $ns2 10.0.1.1 &
 		local tests_pid=$!
@@ -3644,15 +3646,21 @@ endpoint_tests()
 		chk_mptcp_info subflows 1 subflows 1
 
 		pm_nl_del_endpoint $ns1 1 10.0.2.1
+		pm_nl_del_endpoint $ns1 2 224.0.0.1
 		sleep 0.5
 		chk_subflow_nr "after delete" 1
 		chk_mptcp_info subflows 0 subflows 0
 
-		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.2.1 id 1 flags signal
+		pm_nl_add_endpoint $ns1 10.0.3.1 id 2 flags signal
 		wait_mpj $ns2
-		chk_subflow_nr "after re-add" 2
-		chk_mptcp_info subflows 1 subflows 1
+		chk_subflow_nr "after re-add" 3
+		chk_mptcp_info subflows 2 subflows 2
 		mptcp_lib_kill_wait $tests_pid
+
+		chk_join_nr 3 3 3
+		chk_add_nr 4 4
+		chk_rm_nr 2 1 invert
 	fi
 
 }
-- 
2.43.0



