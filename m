Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1EF302761;
	Tue, 11 Nov 2025 01:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823908; cv=none; b=qYxdpWwF5a2LknZ8+Dpi6nQWGJwsdlsRYhhK63oTgUwbwejkxLeRiirM9L3GboZTRvAMlKi8xgGL4rWlKTqAeaS2Ieuxg6vnysunyH9gU/HMjNw0BYgzsBV8vml2NPlT6G6dL4ytcT19WcxWBhggJLcuH7HK1eP954esLwVox6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823908; c=relaxed/simple;
	bh=y7WBj7oA5olGtx11BmEYQFv0B2XLbIXca9Ces9a/MLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KFaqeo7X3d7HLZZa/LCxa5y1HM60ApVJkQKe0dVAwNEsN3uYAW4Cchjl1SczDe9F3dE7zGhBYTN1O7cL8MpUFnl2uVCnabjA5qTo0kZZCK5UCA1ObGKfrJi/z98zC8IiHkIDilk451R/1nYcKLSJkFMd/M02BAcNhYx+62cz6JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAYXxPLh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAYXxPLh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F08AC116B1;
	Tue, 11 Nov 2025 01:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823908;
	bh=y7WBj7oA5olGtx11BmEYQFv0B2XLbIXca9Ces9a/MLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JAYXxPLhlsTWva8zAHGq0Zp3jWWoFHxsobRuQe5Pw6RRFY8Yjdm757eaBcf8grH2v
	 2hpHIKJIBm1swP79pcFH+RXmGjjgQSYvYAMSdpaAqqUB8m79prCl3O3GjErkaEU6zp
	 /Y5Sg8+0Xfl6aVaEFOcCv5WPhfvu9dt3ML6AjVcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 321/565] selftests: mptcp: join: allow more time to send ADD_ADDR
Date: Tue, 11 Nov 2025 09:42:57 +0900
Message-ID: <20251111004534.107543703@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index ec7547bdda89f..7ac63821a8842 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -2125,7 +2125,8 @@ signal_address_tests()
 		pm_nl_add_endpoint $ns1 10.0.3.1 flags signal
 		pm_nl_add_endpoint $ns1 10.0.4.1 flags signal
 		pm_nl_set_limits $ns2 3 3
-		run_tests $ns1 $ns2 10.0.1.1
+		speed=slow \
+			run_tests $ns1 $ns2 10.0.1.1
 		chk_join_nr 3 3 3
 		chk_add_nr 3 3
 	fi
@@ -2137,7 +2138,8 @@ signal_address_tests()
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



