Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65275351FDB;
	Fri, 21 Nov 2025 13:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733081; cv=none; b=fDeV8TPcQ7HQmcg55JNde2Oiu2nbY9TIV3RLOigfC2BJl+rLV3SkFQePjGWI5clZwR/iwqEbX3UQFyyeYYbhM8opxBSglqqS8IbrQ4mgpd+HOfZq9QVoMzc5pwjLTD4/S0lOiSJfVC2ZGl1dRkJvUuWJQdIHVLaGSa/jwyUU3PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733081; c=relaxed/simple;
	bh=wSL9WYsMpS4SS8PpSty/Je8MdEto/qicmIquwrCLTao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MkSK1Egx7l4MwIyxxOMGf180Jbo+SkPmL2jh6mTODNUKqVTt/bKXpq4r2oUHbuLvRBysozAxOm/7o8eChXqoREBMTZGu8G8JyC3wbf5Kwre63bqXRvTbPeOLMgXiHKRel4zlw2NbdZaQ+wqMcAIHob4AVA515AJmmJH4+u2R3Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IArZqCTy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IArZqCTy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A2BC4CEF1;
	Fri, 21 Nov 2025 13:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733081;
	bh=wSL9WYsMpS4SS8PpSty/Je8MdEto/qicmIquwrCLTao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IArZqCTyLUX+DGhSn5ch30OQ1LwLPnA9el+9PPkXk7Uq0UoCuiS8GxF89ER/Ktn40
	 3nEfgVzAO9EXmFDdVNtnewh7BD9EyTiSbmr6Vv/nolTsJI0/gsBDXHK7qo8oyvLiok
	 b9nrQTv0lIrfbrflH890B7waa/g81gD47oJPTrao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Liang <wangliang74@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 343/529] selftests: netdevsim: Fix ethtool-coalesce.sh fail by installing ethtool-common.sh
Date: Fri, 21 Nov 2025 14:10:42 +0100
Message-ID: <20251121130243.236052979@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Wang Liang <wangliang74@huawei.com>

[ Upstream commit d01f8136d46b925798abcf86b35a4021e4cfb8bb ]

The script "ethtool-common.sh" is not installed in INSTALL_PATH, and
triggers some errors when I try to run the test
'drivers/net/netdevsim/ethtool-coalesce.sh':

  TAP version 13
  1..1
  # timeout set to 600
  # selftests: drivers/net/netdevsim: ethtool-coalesce.sh
  # ./ethtool-coalesce.sh: line 4: ethtool-common.sh: No such file or directory
  # ./ethtool-coalesce.sh: line 25: make_netdev: command not found
  # ethtool: bad command line argument(s)
  # ./ethtool-coalesce.sh: line 124: check: command not found
  # ./ethtool-coalesce.sh: line 126: [: -eq: unary operator expected
  # FAILED /0 checks
  not ok 1 selftests: drivers/net/netdevsim: ethtool-coalesce.sh # exit=1

Install this file to avoid this error. After this patch:

  TAP version 13
  1..1
  # timeout set to 600
  # selftests: drivers/net/netdevsim: ethtool-coalesce.sh
  # PASSED all 22 checks
  ok 1 selftests: drivers/net/netdevsim: ethtool-coalesce.sh

Fixes: fbb8531e58bd ("selftests: extract common functions in ethtool-common.sh")
Signed-off-by: Wang Liang <wangliang74@huawei.com>
Link: https://patch.msgid.link/20251030040340.3258110-1-wangliang74@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/netdevsim/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/Makefile b/tools/testing/selftests/drivers/net/netdevsim/Makefile
index 7a29a05bea8bc..50932e13cb5a8 100644
--- a/tools/testing/selftests/drivers/net/netdevsim/Makefile
+++ b/tools/testing/selftests/drivers/net/netdevsim/Makefile
@@ -14,4 +14,8 @@ TEST_PROGS = devlink.sh \
 	tc-mq-visibility.sh \
 	udp_tunnel_nic.sh \
 
+TEST_FILES := \
+	ethtool-common.sh
+# end of TEST_FILES
+
 include ../../../lib.mk
-- 
2.51.0



