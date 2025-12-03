Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD20313558;
	Wed,  3 Dec 2025 16:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778001; cv=none; b=mainhc05euYie2jLn1Q3p+GzQ5PvpGjO3WA7AwQey8jhvMniHlGPTPPuruWX+p/SQRQUPDV+767TNSrf7lBz16oTab14NN+yLe27NPl+odw8AZMthSMjj8+g/T/oIn4VY7OGC5S86dvJdjgfQO1etU7kthT2trSEqh0ELjXQbXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778001; c=relaxed/simple;
	bh=SpugAN5EEf2RW9z4Km8ZC6BPCK+8tVUHWf9OwmDZvIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tetk4vgtbpcUEba3NjNugMLPxpOKqATpvdfmBJjbqcE8myK2j6TItYaHZae8IffiD96Ultx0CgfjMN/MrOluX0fyy+ObuSnCC7zKl1tzsmXpmoCjElypBcNhLhePp7LUi4eaJGvTq+iaQoksjCXZY+SAf8FMZvw71vLasTiXcNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkb29Lzu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkb29Lzu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7118DC4CEF5;
	Wed,  3 Dec 2025 16:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778000;
	bh=SpugAN5EEf2RW9z4Km8ZC6BPCK+8tVUHWf9OwmDZvIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkb29Lzu+5gOgWGO1O7T7juYNaymjeEYkmx4eYh2G8W744IXiFCnr75oZCCB+VyFW
	 b93IbiNEqsFaCyXqdp5TOl/2GymGXOITMSxvzZJ/dt6JBIRZqbVNtfOc3VO86vuGyK
	 CwmWQ76GP+ZUNxa+zus8MxpWSl9SNbvIThfKw084=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Wei <dw@davidwei.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 213/392] netdevsim: add Makefile for selftests
Date: Wed,  3 Dec 2025 16:26:03 +0100
Message-ID: <20251203152421.908015159@linuxfoundation.org>
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
index 6bfc75861c8c0..c88de6f356d11 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12939,6 +12939,7 @@ NETDEVSIM
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



