Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C7D3A4525;
	Tue, 10 Mar 2026 11:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142068; cv=none; b=eySThNQx9NFL1hYnaQLBWMF/Ez66kiPZuZmu0FRB16bD/qqvnEBwyNNlEJhElEQrC2FIya8Yb8+Ia8vCGER9fEGLWUU0SNCRgqVUoqCFnJiRG5zMLXID5TdSQrk4HLXnQPbY+oT9ljg8u0vgW1JFK6+MmdRUVCoJev34k1Q4sIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142068; c=relaxed/simple;
	bh=smNOMKHx9QJnHq+agcIfmK/dt9+thLE8DRfaAJjfb6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inzLjXnPhcr8iGMC3kvlBFKBWdkMb3Epu6LPoo+I7LFQJBxz414lp7ZzspDQxCEXQ0+wqsTRSCtJEfMAyorY6osCnYK+SHc9QVwifw8VNWTBNPvTZxaexzPs8OBKk4M0gOOc6aGC+aYbgkYgcD9HBbsR/RRTLArFzt0cVw7ehuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zf+x3zQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zf+x3zQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB16C2BCAF;
	Tue, 10 Mar 2026 11:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142067;
	bh=smNOMKHx9QJnHq+agcIfmK/dt9+thLE8DRfaAJjfb6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zf+x3zQcyUO32h4daoNGtuH48PL3CoqspnXzZohrejGY6zuGk2/VP2S15mJOlRGLz
	 4b4g7OYoiVATTQ9rE1VmFT55QxQdbG53KDHIbzFdHbcjziqH5BcdB0rOCaECwCnI1G
	 EEQKmDjsAXcibiDP2vOtWdEL6cFOkRCmt7HwtDWJBB9H8fUEW1ydzJk2Rq6XOGbXAy
	 gAaNpU80dDsLEFJvc9r8MDD+JIlTomVCBf48YeVR801HjC1nB52gKCjI2SDisZvp/j
	 J8iie/w+j4N35X1UVo2l1H2pZPU2KmmO0v7+ITMysnwrLQM16GU5bO1F0fjcOA6dDH
	 qWzH/VPGciSqQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 193/314] selftests: mptcp: join: check removing signal+subflow endp
Date: Tue, 10 Mar 2026 07:17:32 -0400
Message-ID: <085f958c196e0412bf4ff27b727a0ba39dddeffe.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit 1777f349ff41b62dfe27454b69c27b0bc99ffca5 upstream.

This validates the previous commit: endpoints with both the signal and
subflow flags should always be marked as used even if it was not
possible to create new subflows due to the MPTCP PM limits.

For this test, an extra endpoint is created with both the signal and the
subflow flags, and limits are set not to create extra subflows. In this
case, an ADD_ADDR is sent, but no subflows are created. Still, the local
endpoint is marked as used, and no warning is fired when removing the
endpoint, after having sent a RM_ADDR.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: 85df533a787b ("mptcp: pm: do not ignore 'subflow' if 'signal' flag is also set")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260303-net-mptcp-misc-fixes-7-0-rc2-v1-5-4b5462b6f016@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index f29a10f2b31b2..8990cd99f4e32 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2613,6 +2613,19 @@ remove_tests()
 		chk_rst_nr 0 0
 	fi
 
+	# signal+subflow with limits, remove
+	if reset "remove signal+subflow with limits"; then
+		pm_nl_set_limits $ns1 0 0
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal,subflow
+		pm_nl_set_limits $ns2 0 0
+		addr_nr_ns1=-1 speed=slow \
+			run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr 0 0 0
+		chk_add_nr 1 1
+		chk_rm_nr 1 0 invert
+		chk_rst_nr 0 0
+	fi
+
 	# addresses remove
 	if reset "remove addresses"; then
 		pm_nl_set_limits $ns1 3 3
-- 
2.51.0

