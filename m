Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952A034164B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301196; cv=none; b=Pkxzcw0yRri11GcVjIZ5PfR/YrXDZWld25g7NsYMRURhAAgYeDl3Sruvt1sYnD4C9A2RE20u6jiVkC9UrPJ8vvh9Vl8ykFyg96psNR2WgchxtLFqNL6+UTMVnu5AfdmKn07W9erTO25t4Jj6p6P0Qi6NLG24goS1Yuaz3ME4zI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301196; c=relaxed/simple;
	bh=SmIZ7eLhuIMXWv0+9VOXp6q9bv9TM4DpcEnGvHeowfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7bPjimCAfty37CIYDZcKlnjqs4XQCj59pcMooLmiB7s/qqgBcpSxUVFdeTmmWL5+BNyE9ksnmfEorvtnuFR+G0KnazlSE5Vb77gkzXJrRUZjJG9wWy6+DTcfnxY2cI1EDPGIo0eJnQgRBDu1/KugcNzlXL6udh0h2gZVU0vE8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eVvZdqfg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eVvZdqfg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E618DC19423;
	Sat, 28 Feb 2026 17:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301196;
	bh=SmIZ7eLhuIMXWv0+9VOXp6q9bv9TM4DpcEnGvHeowfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eVvZdqfgiJ+zkDYjXKVrDe9IBpayM/S7iOSCsh03XQk0e4LmRi/cbZGX1d2Y0Zk5a
	 Tb0e8KlgwXhn4PoWjjWfhWk9L9z2hdscw9Wvx7pXDuLRWjaOw0wDbSVLRvHDS3fqse
	 Zu0zqanF6rjnI7CZOLA1tTc6pHLFNo/u1W0L7WJB7g8KNaZhJjzAGSokv5AsUNzi+S
	 OTJXk3pemJqiLlJtHIDiPnLbooyBXfBCV7zFj+JM3VtAw7UZZ2CQ9k9S81XxggPAZK
	 A+3qmpO/KA3BN4ejCvPUyR1h4C1nt0SF30iFNlAL9kGqzFrLhE/m/enyr4lmScLnUX
	 IShKtKKCeUr6g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Phil Sutter <phil@nwl.cc>,
	Alyssa Ross <hi@alyssa.is>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 368/752] include: uapi: netfilter_bridge.h: Cover for musl libc
Date: Sat, 28 Feb 2026 12:41:19 -0500
Message-ID: <20260228174750.1542406-368-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 4edd4ba71ce0df015303dba75ea9d20d1a217546 ]

Musl defines its own struct ethhdr and thus defines __UAPI_DEF_ETHHDR to
zero. To avoid struct redefinition errors, user space is therefore
supposed to include netinet/if_ether.h before (or instead of)
linux/if_ether.h. To relieve them from this burden, include the libc
header here if not building for kernel space.

Reported-by: Alyssa Ross <hi@alyssa.is>
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/netfilter_bridge.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/netfilter_bridge.h b/include/uapi/linux/netfilter_bridge.h
index 1610fdbab98df..ad520d3e9df8f 100644
--- a/include/uapi/linux/netfilter_bridge.h
+++ b/include/uapi/linux/netfilter_bridge.h
@@ -5,6 +5,10 @@
 /* bridge-specific defines for netfilter. 
  */
 
+#ifndef __KERNEL__
+#include <netinet/if_ether.h>	/* for __UAPI_DEF_ETHHDR if defined */
+#endif
+
 #include <linux/in.h>
 #include <linux/netfilter.h>
 #include <linux/if_ether.h>
-- 
2.51.0

