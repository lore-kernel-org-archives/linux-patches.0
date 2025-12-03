Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4F11F181F;
	Wed,  3 Dec 2025 16:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779619; cv=none; b=meCk26vgXOxzAof9lgbYy+ElAN9xS9sHtd8AA0wnzSKW1Fnd6BMV7gFrD7AzWERSVQqsrGRwDXBoOsesxvAZJ2WDkOC2/hjaaIW98DqfCCZpDCdbtxcVtlk5atu4eSRn3564EXrZqGdVXNs8k9rONnHTc1Fer5TdGGJYBAEIhMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779619; c=relaxed/simple;
	bh=prOWeDRR4HfvK5WVcY3bKmpgtQTMFMxBuJDwEur/Zjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R210muWwo9vlKRaYTFflXUsJd/llnvgBsQ0o0+7RFxQbpjZJoWaG0vXugEF5Q0PDvtCaZVv/FyJ1rfEImWmCh97rOZIOs0Y+F0FtByAPMEc2JcDjZmcEyYCobPJ9r7tZ8OM9f/CLie2hVGT//S7H8BhyX0oL8QfFzWkELkBGwE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oAoSd+Hv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oAoSd+Hv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F0AC4CEF5;
	Wed,  3 Dec 2025 16:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779619;
	bh=prOWeDRR4HfvK5WVcY3bKmpgtQTMFMxBuJDwEur/Zjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oAoSd+HvWvzB5R0jBAbON8ED3LatTr5GHsCcm6rIsW22/ZYxhSHd2LRp/ph5SnhfK
	 tCTK9PWaeKby4Hr8KZ4j96GSZg7/Wb/Vt/CNEHIsQfUtEWMjRFrSWpUr+XqycXRuUs
	 cJYT+a1ulPF5rpQn6oOhVWXjBmTHr0Yqy9YoVJ5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Liang <wangliang74@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 310/568] selftests: netdevsim: Fix ethtool-coalesce.sh fail by installing ethtool-common.sh
Date: Wed,  3 Dec 2025 16:25:12 +0100
Message-ID: <20251203152452.069324793@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



