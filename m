Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA9735F8AF;
	Wed,  3 Dec 2025 16:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779616; cv=none; b=bLYrU6nkPsZ+ubc6dm/akrk72yRY0ahExI4pdOzeJLANmU9mCvsAf3/0ZqYRkbRnYD9/XkQ/t2yb6kiAPKZYE9kHgJ7rrlbqmAHviG2aF0ZJwQIW7hMfR+jDs+uSA4MIEaUftijlhsJSpliQsz3xykBc79g4eIj4V4HRg6mg9Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779616; c=relaxed/simple;
	bh=TIuF290OcthXpvt7fBxS3mxjiEekJN57wm4xyKRHiZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYiIeoHqF7fR1jrNxCGB8AITpofJY5zOqiSH/DhRQkU9Fqy3hVpMfb4bYm+FZXOZFQE/iZU1EGFTYDIX8qIKs/qQhcY2LDfAX3Ij9oSLgM9UobdRMyT4vlc/5KAWerU1KCNlTswi7fpcdoS7jynud5nPM2Cc6+ZeEPhMKfoCpkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=efhW9kpH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efhW9kpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92846C4CEF5;
	Wed,  3 Dec 2025 16:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779616;
	bh=TIuF290OcthXpvt7fBxS3mxjiEekJN57wm4xyKRHiZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=efhW9kpHaslQT95nTRTz/n3coo+5O+w3QAHLMRfEj7vbqyKIQ8dDIW6qpby0B98wP
	 iBXqvYNRcLuYKE6Ep41BoJoau4by0ivyVW6COsznGr+GJjE1gSYpn4Y35w4oF3c4ii
	 Uupl559QXUVm8N5Ovb1e3z2xwUDgbfbUk4UmOrOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 309/568] netdevsim: add Makefile for selftests
Date: Wed,  3 Dec 2025 16:25:11 +0100
Message-ID: <20251203152452.033252644@linuxfoundation.org>
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
index 428b2259225dd..9ed8ee40a2176 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14221,6 +14221,7 @@ NETDEVSIM
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



