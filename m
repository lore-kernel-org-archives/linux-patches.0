Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0863E44AB66;
	Thu, 30 Jul 2026 16:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427435; cv=none; b=eb9c7jMgD3hZwBpqZOmtybfAUfhl0wcaS2DmSg4B87TSfUie3xptuJNhibrkMrmZQnaY+KAlW0Fv8TrXCO4Wdf9n+TK5pllhVaC5obRbuTBVqYIHQP2zDcXn5sCw60K/hvSaeBN4CfbifemJjcw5iINPHmQyfolXzc7V32oQjXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427435; c=relaxed/simple;
	bh=8YshSFE9H/nuqCVB9cxNHxU7bqOZfQ279v/tmjGBiMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rj9imJcQZQaaLKs7KDGqlAsU0FXV2TFGj/nLABGVxAjJ4xH/qpIhnZn+Bub9tEHuihLIPYD2cvOnTPFGy9PBHdZtCm36fqGcq7hV1NpBdUwNyhpRO2V0FpWYLjc5SX2St5zJYxT4KrPdsK9gbHBSigMFeXFQgTb3f2F/WCEjzmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1+uhLM7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1+uhLM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 643201F000E9;
	Thu, 30 Jul 2026 16:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427433;
	bh=LKZF78OKJLB0R+liQEsJARiZHsG0GXwKcYPZllmZRYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D1+uhLM7KwtQwiiwIsEH19bomd3yFIYE1yrGgIJvPTol4DHSWYzBIxp3CRmab+KdN
	 L+KzBLS0ZAbV1DwxYMKI12PiXH2VmnCPk/xCNfIMeN6SjPZ3fd4d3sKHIhoIFBdm2F
	 HlTi8lZWmmnIEIrpBmWIFolq/9VpeuiChAnvvLv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 168/484] selftest: af_unix: Add Kconfig file.
Date: Thu, 30 Jul 2026 16:11:05 +0200
Message-ID: <20260730141427.118614498@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 11b006d6896c0471ad29c6f1fb1af606e7ba278f ]

diag_uid selftest failed on NIPA where the received nlmsg_type is
NLMSG_ERROR [0] because CONFIG_UNIX_DIAG is not set [1] by default
and sock_diag_lock_handler() failed to load the module.

  # # Starting 2 tests from 2 test cases.
  # #  RUN           diag_uid.uid.1 ...
  # # diag_uid.c:159:1:Expected nlh->nlmsg_type (2) == SOCK_DIAG_BY_FAMILY (20)
  # # 1: Test terminated by assertion
  # #          FAIL  diag_uid.uid.1
  # not ok 1 diag_uid.uid.1

Let's add all AF_UNIX Kconfig to the config file under af_unix dir
so that NIPA consumes it.

Fixes: ac011361bd4f ("af_unix: Add test for sock_diag and UDIAG_SHOW_UID.")
Link: https://netdev-3.bots.linux.dev/vmksft-net/results/644841/104-diag-uid/stdout [0]
Link: https://netdev-3.bots.linux.dev/vmksft-net/results/644841/config [1]
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20240617073033.0cbb829d@kernel.org/
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f8b1abed7361 ("selftests: af_unix: add USER_NS config")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/af_unix/config | 3 +++
 1 file changed, 3 insertions(+)
 create mode 100644 tools/testing/selftests/net/af_unix/config

diff --git a/tools/testing/selftests/net/af_unix/config b/tools/testing/selftests/net/af_unix/config
new file mode 100644
index 00000000000000..37368567768cc0
--- /dev/null
+++ b/tools/testing/selftests/net/af_unix/config
@@ -0,0 +1,3 @@
+CONFIG_UNIX=y
+CONFIG_AF_UNIX_OOB=y
+CONFIG_UNIX_DIAG=m
-- 
2.53.0



