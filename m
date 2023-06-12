Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CCEC11C88
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:42:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297B3C433D2;
	Mon, 12 Jun 2023 10:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566579;
	bh=4VVWe/qZ7QNynVZRVNjj9geL7VWS+naqZ43tobl/uWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wi52P6Z4tekYzvc36JWABtt94eaVinKI01uV5GUT2LRCR7he8yl/8tunlOqAv9wN8
	 Khx4KdANShayoFNmh2OdG/vn52LiyNpARjJG6VyXFPQO/ABobCHvtgXwj7dTjuAFhz
	 I0q0Y6X4pR6z1ELXT9zEpPx6QP21jLlBNaC57dTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Geliang Tang <geliang.tang@suse.com>,
	Mat Martineau <martineau@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 085/132] selftests: mptcp: update userspace pm subflow tests
Date: Mon, 12 Jun 2023 12:26:59 +0200
Message-ID: <20230612101714.143699758@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101710.279705932@linuxfoundation.org>
References: <20230612101710.279705932@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geliang Tang <geliang.tang@suse.com>

commit 6c160b636c91e71e50c39134f78257cc35305ff0 upstream.

To align with what is done by the in-kernel PM, update userspace pm
subflow selftests, by sending the a remove_addrs command together
before the remove_subflows command. This will get a RM_ADDR in
chk_rm_nr().

Fixes: d9a4594edabf ("mptcp: netlink: Add MPTCP_PM_CMD_REMOVE")
Fixes: 5e986ec46874 ("selftests: mptcp: userspace pm subflow tests")
Link: https://github.com/multipath-tcp/mptcp_net-next/issues/379
Cc: stable@vger.kernel.org
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -925,6 +925,7 @@ do_transfer()
 				sleep 1
 				sp=$(grep "type:10" "$evts_ns2" |
 				     sed -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q')
+				ip netns exec ${connector_ns} ./pm_nl_ctl rem token $tk id $id
 				ip netns exec ${connector_ns} ./pm_nl_ctl dsf lip $addr lport $sp \
 									rip $da rport $dp token $tk
 			fi
@@ -3007,7 +3008,7 @@ userspace_tests()
 		pm_nl_set_limits $ns1 0 1
 		run_tests $ns1 $ns2 10.0.1.1 0 0 userspace_1 slow
 		chk_join_nr 1 1 1
-		chk_rm_nr 0 1
+		chk_rm_nr 1 1
 	fi
 }
 


