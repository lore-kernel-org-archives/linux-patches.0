Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364392745E;
	Fri, 17 Oct 2025 15:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714586; cv=none; b=UmRZi9mBQR38HDhR9sYvpK0AVI8W83qC00wsHBTe0nCm5z2rly2EsUsXyNUnaqmtlZqJLzMlIFGi/GtvIZW5Z6hQSX5fHdg5AeGAKlmCqLUiNJvQpat9x5egDUUNr5QINR6idctggjet5W2d8nWuRYY8ypfN9RwgVS0mLfrO0ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714586; c=relaxed/simple;
	bh=U/VLIcJKhbdpLJWxBF2/WsAFT2v0Q4KMI50k2fTb190=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mcld1CfNzs/3tNcVjRBST7BpEcyZ5Asg/F6qsOBvAG+6zjsP7B/YX20PxCA6PfWNuI2QmSnSJCU4yOENK+AxeWMGmBqJ68whZVORfdwdAi6jxmjKhXbSNATTcxQY3e2zT8ikOsutv8GjNX+tllccik/Bzu+XwMvhfsAaPHqkXx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2B4paeO/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2B4paeO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF89C4CEE7;
	Fri, 17 Oct 2025 15:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714585;
	bh=U/VLIcJKhbdpLJWxBF2/WsAFT2v0Q4KMI50k2fTb190=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2B4paeO/ZSNIqNl+kqPoWJKfmkWJ+0+iWB23KZAvE/zZsDusJ9DpoSkBTyELydzYs
	 ECAIHGh5Ct9B57EiyT2UHcZdrF5rmgMj/ql8VfprYrXE1Aiqn1zBfTtxYbcbWeuUFz
	 jqImSyts/hrTkT/0C+/2PQfRhI7SuMKPeyCuVaE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 196/277] selftests: mptcp: join: validate C-flag + def limit
Date: Fri, 17 Oct 2025 16:53:23 +0200
Message-ID: <20251017145154.277083912@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 008385efd05e04d8dff299382df2e8be0f91d8a0 upstream.

The previous commit adds an exception for the C-flag case. The
'mptcp_join.sh' selftest is extended to validate this case.

In this subtest, there is a typical CDN deployment with a client where
MPTCP endpoints have been 'automatically' configured:

- the server set net.mptcp.allow_join_initial_addr_port=0

- the client has multiple 'subflow' endpoints, and the default limits:
  not accepting ADD_ADDRs.

Without the parent patch, the client is not able to establish new
subflows using its 'subflow' endpoints. The parent commit fixes that.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: df377be38725 ("mptcp: add deny_join_id0 in mptcp_options_received")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250925-net-next-mptcp-c-flag-laminar-v1-2-ad126cc47c6b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3160,6 +3160,17 @@ deny_join_id0_tests()
 		run_tests $ns1 $ns2 10.0.1.1
 		chk_join_nr 1 1 1
 	fi
+
+	# default limits, server deny join id 0 + signal
+	if reset_with_allow_join_id0 "default limits, server deny join id 0" 0 1; then
+		pm_nl_set_limits $ns1 0 2
+		pm_nl_set_limits $ns2 0 2
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		pm_nl_add_endpoint $ns2 10.0.3.2 flags subflow
+		pm_nl_add_endpoint $ns2 10.0.4.2 flags subflow
+		run_tests $ns1 $ns2 10.0.1.1
+		chk_join_nr 2 2 2
+	fi
 }
 
 fullmesh_tests()


