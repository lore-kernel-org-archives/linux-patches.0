Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EA513D28F;
	Thu,  5 Sep 2024 10:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530427; cv=none; b=Z+SITSBmPCyZ9F1sQFafJChGDkNcuD5zmAmTjQz1ZtrFblOSeoq+rOf+ObvhuRhXg2Tt9DAL4My8ooCGU0p7IazGwZp0BXwlUamqzusMA21Nj3D2iB9jZN06TsyBjDVSzYNyhVDghwBgCNwNfVWSnFBMc2cLTL1MkvQYTBD5w54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530427; c=relaxed/simple;
	bh=1nuiIj0mevOe3y74RopIrmQ2tiDXvinm7XX2GbuHVmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3TmsDmPSNCxhZe43uTgHVRww6GFMVTD4zpG3W7492bpMy1vrfbN3KsFDeb6xkPVUeQhWSbkpYel4Mvo+cwSUft4OIw0NJcN5BW+upZQD1UWnFvcus5XymmvX+gSften/Z5ffYwMT+A9Z6364oHrAkEv+FmJeBX43pOx0YBYy7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oQ0pCNBH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oQ0pCNBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E47CC4CEC3;
	Thu,  5 Sep 2024 10:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530427;
	bh=1nuiIj0mevOe3y74RopIrmQ2tiDXvinm7XX2GbuHVmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQ0pCNBHnQ/ouV2xMvKtSx9kY9aRUL+INCzMH6QpK0ZrRkQ0x0+5o96U6mBB6q9xl
	 31L0vDgkZH1R522QOWD4cBSPJo6rPlxQJneMIM+tbK+X/Ig7zYrj8hZGNiVyTQDI1Y
	 eNmK4Psy8Xj91JWI0I/QVjPWcYfVGu/bT5202YkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 020/101] selftests: mptcp: join: test for flush/re-add endpoints
Date: Thu,  5 Sep 2024 11:40:52 +0200
Message-ID: <20240905093716.904198679@linuxfoundation.org>
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

commit e06959e9eebdfea4654390f53b65cff57691872e upstream.

After having flushed endpoints that didn't cause the creation of new
subflows, it is important to check endpoints can be re-created, re-using
previously used IDs.

Before the previous commit, the client would not have been able to
re-create the subflow that was previously rejected.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: 06faa2271034 ("mptcp: remove multi addresses and subflows in PM")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240819-net-mptcp-pm-reusing-id-v1-6-38035d40de5b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ No conflicts, but adapt the test to the helpers in this version:
  - run_tests has been modified a few times to reduce the number of
    positional parameters
  - no chk_mptcp_info helper
  - chk_subflow_nr taking an extra parameter
  - kill_tests_wait instead of mptcp_lib_kill_wait ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   29 ++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3262,6 +3262,35 @@ userspace_tests()
 		kill_tests_wait
 	fi
 
+	# flush and re-add
+	if reset_with_tcp_filter "flush re-add" ns2 10.0.3.2 REJECT OUTPUT &&
+	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_set_limits $ns2 1 2
+		# broadcast IP: no packet for this address will be received on ns1
+		pm_nl_add_endpoint $ns1 224.0.0.1 id 2 flags signal
+		pm_nl_add_endpoint $ns2 10.0.3.2 id 3 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_20 2>/dev/null &
+		local tests_pid=$!
+
+		wait_attempt_fail $ns2
+		chk_subflow_nr needtitle "before flush" 1
+
+		pm_nl_flush_endpoint $ns2
+		pm_nl_flush_endpoint $ns1
+		wait_rm_addr $ns2 0
+		ip netns exec "${ns2}" ${iptables} -D OUTPUT -s "10.0.3.2" -p tcp -j REJECT
+		pm_nl_add_endpoint $ns2 10.0.3.2 id 3 flags subflow
+		wait_mpj $ns2
+		pm_nl_add_endpoint $ns1 10.0.3.1 id 2 flags signal
+		wait_mpj $ns2
+		kill_wait "${tests_pid}"
+		kill_tests_wait
+
+		chk_join_nr 2 2 2
+		chk_add_nr 2 2
+		chk_rm_nr 1 0 invert
+	fi
 }
 
 endpoint_tests()


