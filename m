Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865EE2AE96;
	Tue, 29 Apr 2025 18:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950018; cv=none; b=Ghf7oB7U6RWOh8otua12e1DUkUAFU3hXbVUHlc95j8Xby2YuIQ5y6z6eKI5MkAVI29gcpXxXNwqCmB4OFOXH6fwUpSJuZv1WyIB0Gd34ysB+OLu7MrsDU0u0bVz0HM+BDoZPBdkP3ke29Z4hkuTUW/9A+oGEU1ImXmUa5u9j/8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950018; c=relaxed/simple;
	bh=KSklmJWXG2mjd3DsSL0R4p6+YfyQ2vW/P7BvUZM59Yo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AF74N5ia/mOueRhlfm/sPOmAnjioKvEnsKlj//N6f7TpEhERtn+sc/RL42e5R/vJX5xMe14B0yFSfZY1S6RFjbbA/4GvXhRHqKbDqIuE/Gv6SJUeE3DwQgMgB8TEzvjzkWWSkwFXeyWtqQFppKk7veYrjOxQPUp7RCf/o3ozzmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqDAVWBV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqDAVWBV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA57AC4CEE3;
	Tue, 29 Apr 2025 18:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950018;
	bh=KSklmJWXG2mjd3DsSL0R4p6+YfyQ2vW/P7BvUZM59Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqDAVWBVUXVC4gR0doskdG+n8eRM1Dx2C1KHtXraUbPc9GHJFM+lJ1aO3XCQt7kbi
	 6lu/EQMAJ96X3vdbphZIQb0IX0QwD70laWOA7oSCJaU6Q8pIA0dnjbWJ1QQOQUm4Wv
	 z/SrdM8k73xjlXSQhvY4xp3BwlXI5geUGL7A08ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/167] sched/isolation: Make CONFIG_CPU_ISOLATION depend on CONFIG_SMP
Date: Tue, 29 Apr 2025 18:43:51 +0200
Message-ID: <20250429161056.718847157@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit 975776841e689dd8ba36df9fa72ac3eca3c2957a ]

kernel/sched/isolation.c obviously makes no sense without CONFIG_SMP, but
the Kconfig entry we have right now:

	config CPU_ISOLATION
		bool "CPU isolation"
		depends on SMP || COMPILE_TEST

allows the creation of pointless .config's which cause
build failures.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20250330134955.GA7910@redhat.com

Closes: https://lore.kernel.org/oe-kbuild-all/202503260646.lrUqD3j5-lkp@intel.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index b6786ddc88a80..8b6a2848da4a5 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -678,7 +678,7 @@ endmenu # "CPU/Task time and stats accounting"
 
 config CPU_ISOLATION
 	bool "CPU isolation"
-	depends on SMP || COMPILE_TEST
+	depends on SMP
 	default y
 	help
 	  Make sure that CPUs running critical tasks are not disturbed by
-- 
2.39.5



