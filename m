Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3942BF3E2;
	Tue, 10 Mar 2026 11:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141164; cv=none; b=ojNaCkCExP/gYXTzteoOsV6eaWDuR04AM339uufD6CGsasiPs3VCcT/hu8gup32wYmKseeegQIzESbG6foasPck+fdr/yBxTcgX8wRSNirTcdTXv638f2tVBTIH1GUziemvXMAR/1/7Jpxyv8AoYrpxTmlLQfsmL7iGMDFMfnEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141164; c=relaxed/simple;
	bh=RtDFosopD5ZIT2COXOgeb2u867mG6Coye88GlSUP5Cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJ4635rWMCcSvsNe3kswTfKu+Kw+gv/aLZXxjJ5Ib0uIU7ggfRKCjBp97+i7DqpLsXpjrih9IdHj4Z29eYdviaeFpUTMVgUo46dwGhif4XDgv3uPRRpgN/ZRBivGgzIvuN22XysRbZ6P/WBdw7pLqRKwa1vclyQjQ3ulHUkGsxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lF3wWjQo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lF3wWjQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51985C2BC86;
	Tue, 10 Mar 2026 11:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141164;
	bh=RtDFosopD5ZIT2COXOgeb2u867mG6Coye88GlSUP5Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lF3wWjQoBpiw31j0SOkgx5uYdvKsT5/HtD2iTTQ0/imbDjz0ptXMII1gc+arAKm9k
	 xQ2S/kUAsmMXxKLlLmTvBj2JjCDyBAEk0M/B5A1ycIZuw59HHn6SmhJyX9byhc5uco
	 Qcqs+ppxJxoPxLkMrzU3oNOPd0t39qKRxBM6lzyCn4EGwDckvR9mvgEyTYeMG9fQ66
	 BcAaJIgTxO15bCim1YBUx2/YlN2mwSYBJa10L7boNdr46mjcmVlo7TwTtV51XeMi3u
	 LN1CvLPmyLebyH3BLQDn0x0evWDJqwGPlDcQnLQoGlypYtEoNorygLhAq6EfbjjbEK
	 +vC97pn+bTkfg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 166/311] selftests: mptcp: join: check removing signal+subflow endp
Date: Tue, 10 Mar 2026 07:03:33 -0400
Message-ID: <714990aeb35e8154a7f886db73262b1b621bd18f.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index 2e7461c488c71..c739e0185f7fd 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2637,6 +2637,19 @@ remove_tests()
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

