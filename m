Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1BED351FBF;
	Fri, 21 Nov 2025 13:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733078; cv=none; b=HJM9GXsUKJ6Ll2atT2JXXAvSpxmHUEHkn/X4gsegiQq8WZ2pI/qfL+8cd+FfnxNm8j/zui2G9s1WpiN7BvWW4pe2gepCo4BPzRoXeUZPOjhgrCZN2nWB2GGEkklco/zmLGniWiQvph0O1ddk5NsR8v57BgEvqlg6I3U8ENrXqNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733078; c=relaxed/simple;
	bh=VMtGZZmyOowG7QXkcfW3iAd0mk3w0Z1ZietlrvQeiXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gll6NELtEeUUQWJW/LVW1+IfG2O0/RLs0iTU8V96QxIjmo/0mtKOzu0bNo3/hn9wl7dz+Wxz/1arQ8zg/1R8SOzJm6YXcbHSMcrfh7XIOB25shSJDvJbVkv1ROE5tEMNLNVBFofW24JKlRYLBlcn7201dF7I+Eo+/2fl1HkVEA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aG52vjES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aG52vjES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260BDC4CEFB;
	Fri, 21 Nov 2025 13:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733078;
	bh=VMtGZZmyOowG7QXkcfW3iAd0mk3w0Z1ZietlrvQeiXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aG52vjESAX/mRzFb3ZzUao0oKmv3MDeycD51wI6ehqOPIpNXWNuuojjTNdGF/cMIo
	 rjDPSOZEcRSfMvL9IJgAALp+tOprlWlRovkd5DUmZ7G0BIbAbGdKhDLqfvHuxKa4ec
	 imMe3NBOz3VaapjuAaPscZ7IOAhQumjeCPVEGhUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 342/529] netdevsim: add Makefile for selftests
Date: Fri, 21 Nov 2025 14:10:41 +0100
Message-ID: <20251121130243.200904914@linuxfoundation.org>
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

From: David Wei <dw@davidwei.uk>

[ Upstream commit 8ff25dac88f616ebebb30830e3a20f079d7a30c9 ]

Add a Makefile for netdevsim selftests and add selftests path to
MAINTAINERS

Signed-off-by: David Wei <dw@davidwei.uk>
Link: https://lore.kernel.org/r/20240130214620.3722189-5-dw@davidwei.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: d01f8136d46b ("selftests: netdevsim: Fix ethtool-coalesce.sh fail by installing ethtool-common.sh")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS                                     |  1 +
 .../selftests/drivers/net/netdevsim/Makefile    | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)
 create mode 100644 tools/testing/selftests/drivers/net/netdevsim/Makefile

diff --git a/MAINTAINERS b/MAINTAINERS
index 294d2ce29b735..c1aafeb3babf9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14725,6 +14725,7 @@ NETDEVSIM
 M:	Jakub Kicinski <kuba@kernel.org>
 S:	Maintained
 F:	drivers/net/netdevsim/*
+F:	tools/testing/selftests/drivers/net/netdevsim/*
 
 NETEM NETWORK EMULATOR
 M:	Stephen Hemminger <stephen@networkplumber.org>
diff --git a/tools/testing/selftests/drivers/net/netdevsim/Makefile b/tools/testing/selftests/drivers/net/netdevsim/Makefile
new file mode 100644
index 0000000000000..7a29a05bea8bc
--- /dev/null
+++ b/tools/testing/selftests/drivers/net/netdevsim/Makefile
@@ -0,0 +1,17 @@
+# SPDX-License-Identifier: GPL-2.0+ OR MIT
+
+TEST_PROGS = devlink.sh \
+	devlink_in_netns.sh \
+	devlink_trap.sh \
+	ethtool-coalesce.sh \
+	ethtool-fec.sh \
+	ethtool-pause.sh \
+	ethtool-ring.sh \
+	fib.sh \
+	hw_stats_l3.sh \
+	nexthop.sh \
+	psample.sh \
+	tc-mq-visibility.sh \
+	udp_tunnel_nic.sh \
+
+include ../../../lib.mk
-- 
2.51.0



