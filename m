Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED9E2AE96;
	Tue, 29 Apr 2025 17:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949504; cv=none; b=OStWp31jmtJwTUkI9COP2GHBhFFjv4+CpkbCop3p9qxfUlo4WdqsWlUNO/EPlnIH+K83kLw86f6mM6G/X/6vclMbaCDQgrRLcNULPlGr1X5ZD6T4uSe9FzctAGxJUJ3bGkMUk8HWvp6JfYdhk39tHy/hn4g/AvK+SV5dh/rS8Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949504; c=relaxed/simple;
	bh=HAH2yo4p2xhlDJVA1gU0AGUsOsah+PSzXsRjJVOZF6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QR3XcK5mKv5+dhJTkZWjazjcUu/mNQoq44DBTWb7Ker36M+0NpjoiQavoD2oI7vZlto1xPA7szIUcAHSiJgXN6xWjyWFzXySTH/+IALDjf8tTxLHEDdv5Oj0vgrP0Ayd6wAV6GbaPFyW9ixOZwzmlccbgimbRqZPmnPk1HMmdQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DmDsAgvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DmDsAgvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA4AC4CEE3;
	Tue, 29 Apr 2025 17:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949503;
	bh=HAH2yo4p2xhlDJVA1gU0AGUsOsah+PSzXsRjJVOZF6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DmDsAgvqjUv63gPSLUvehpMkMNjykZ+mFFHeAP3EhRhEU/BroliwDBAFGBsbKgie8
	 A1TUQGgNTeZtNoREtgWH9fQx5csvItta07lfhuzjOfHlYUI2XNjMd0eXDX6ze43w3M
	 5VfZmnyKOoxnQbPo2Zwq+hHWztRwme1WxtTXU2QE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 339/373] sched/isolation: Make CONFIG_CPU_ISOLATION depend on CONFIG_SMP
Date: Tue, 29 Apr 2025 18:43:36 +0200
Message-ID: <20250429161137.075900893@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4c9cacc866d4c..b66259bfd2352 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -674,7 +674,7 @@ endmenu # "CPU/Task time and stats accounting"
 
 config CPU_ISOLATION
 	bool "CPU isolation"
-	depends on SMP || COMPILE_TEST
+	depends on SMP
 	default y
 	help
 	  Make sure that CPUs running critical tasks are not disturbed by
-- 
2.39.5



