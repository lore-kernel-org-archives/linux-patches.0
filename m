Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37DE248F6A;
	Tue, 11 Nov 2025 01:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824419; cv=none; b=a6Bn0sUEdDqv1uWtncu5oCu0ssDA0A/gdwFnnLnGKbiT4c0zqjPZTy1ybo5ETTX5f8U7re4dbHjKGqaTx8osN4GQ3E76h1+AcaZ64Tw7InmA1YQ1hotBUA1HqVyU2X/BNKYFu4XUE5wIA/qy7UIm9hi92VogSAq1y6X94GO3Mm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824419; c=relaxed/simple;
	bh=wExKomsksmWmWxeEtjBTaUDJGFtjHB5naps03LFJN+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ph8urSmlcSh1OoQUbmErMWEUHLFWfD4wSuTLEUXGeb1d006YF8pWUJA8LikSR3nMznEJm81sAA3cKUHIKrIDUI91agGJXMmN4XC72nK4LeLpEKLhFTdxaLtTDQbNpfdlo1vm3ngzr+R3VSu/Rdm2cct0PfQcCaeEenf89HcXiHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SZL4/Hwe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SZL4/Hwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F66BC116B1;
	Tue, 11 Nov 2025 01:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824419;
	bh=wExKomsksmWmWxeEtjBTaUDJGFtjHB5naps03LFJN+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SZL4/HweWVPEC1DmMzvn3sMBB8ih6iecu8FATiqNG8FXtRsdjQQdJrDOPb2M4Wv4T
	 R+cQdqXdU6fH2p5GJH6k8XUnkQhB0x/FgatJZtMJQ+C8qj5qjSgcPclLKcVOrIg+Cy
	 TagAkyUqph5K9REu07vwbqaDXrvtGYf2MX/h5JrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 491/849] selftests: mptcp: join: allow more time to send ADD_ADDR
Date: Tue, 11 Nov 2025 09:41:01 +0900
Message-ID: <20251111004548.311837287@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit e2cda6343bfe459c3331db5afcd675ab333112dd ]

When many ADD_ADDR need to be sent, it can take some time to send each
of them, and create new subflows. Some CIs seem to occasionally have
issues with these tests, especially with "debug" kernels.

Two subtests will now run for a slightly longer time: the last two where
3 or more ADD_ADDR are sent during the test.

Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250907-net-next-mptcp-add_addr-retrans-adapt-v1-3-824cc805772b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 5579709c36533..725f1a00bbf19 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2151,7 +2151,8 @@ signal_address_tests()
 		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
 		pm_nl_set_limits $ns2 3 3
-		run_tests $ns1 $ns2 10.0.1.1
+		speed=slow \
+			run_tests $ns1 $ns2 10.0.1.1
 		chk_join_nr 3 3 3
 		chk_add_nr 3 3
 	fi
@@ -2163,7 +2164,8 @@ signal_address_tests()
 		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.14.1 flags signal
 		pm_nl_set_limits $ns2 3 3
-		run_tests $ns1 $ns2 10.0.1.1
+		speed=slow \
+			run_tests $ns1 $ns2 10.0.1.1
 		join_syn_tx=3 \
 			chk_join_nr 1 1 1
 		chk_add_nr 3 3
-- 
2.51.0



