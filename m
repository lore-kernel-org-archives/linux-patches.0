Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFB1313546;
	Wed,  3 Dec 2025 16:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778004; cv=none; b=VyDRCDnBcOuEzpEamn7GeRASbM+UN2df3ABvrMZhexTqj4iurIUR4mgmlkpWpJ8nFQXbq9Zrdc7ZdxXZ0NrHTU6lcdG++ny9CNJI0Tx7qVQi7dvev7iyVeMAnnuAmg6KdOv/arZRRet9sSw/j2fGEZSgiAlWEAsIA3hDY3sxqc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778004; c=relaxed/simple;
	bh=Viy5N1/pfijpzZ+A2KraPvwIX4zpLS4q4Qc6xtXOQmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnlK+cI+QYgcoxG2Xo94Lrktrh6mbBXL2tczVIiO4Gvz1PG65uWN1sw9TbVecAKzT6r2Bh2SEMT5XLQyBK9R2BFMF/WFc1aXL3mn7Gpx/RPtJYG7HQ/TmcpK62dfy8dzD9f9p+m70ArFLwjrmbMbkXHyLtO/BqhpWKr1zIKvrzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1p87gpzn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1p87gpzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26ECC4CEF5;
	Wed,  3 Dec 2025 16:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778004;
	bh=Viy5N1/pfijpzZ+A2KraPvwIX4zpLS4q4Qc6xtXOQmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1p87gpznGFiEz+MzsGM6aZ7x/A7eaiARXOMWnW5xxdY6ZbHrNd7lJCdn54LCoKHNY
	 Ym6lz7oPUpIAZ2SaeNVwJFgj7zTlooYhWWRh1jrdyK/29RSDZwc0887IYg9UN53NPT
	 zEx8H9Ih786VC6iy4dE3L7UqQOv3mDTyUMOzp36Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Liang <wangliang74@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 214/392] selftests: netdevsim: Fix ethtool-coalesce.sh fail by installing ethtool-common.sh
Date: Wed,  3 Dec 2025 16:26:04 +0100
Message-ID: <20251203152422.047973833@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



