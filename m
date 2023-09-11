Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2EE1171B
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3333C433C8;
	Mon, 11 Sep 2023 15:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444526;
	bh=Lt1DKVdQWbJn/6aPuY3u5XWxJ3qu7InJMh4b+tQNUr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QuJol/dRDdn67F8Sk+Mu9X6nfh002ieyTdYqgmLLlYBSbXvuXky/mfop6y8t8ETH+
	 t9k77Es65Sq428jncE1x694hKG21PjC50Gk7fKKzDytM32viqOEY4Se6lQQlvnUIrp
	 O2z90PSEvgSzMmZ7QMmsm37dYFEQdtzXcINbplq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/600] Revert "MIPS: unhide PATA_PLATFORM"
Date: Mon, 11 Sep 2023 15:40:42 +0200
Message-ID: <20230911134633.893259953@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Maciej W. Rozycki <macro@orcam.me.uk>

[ Upstream commit 1e13da548fbffb807633df85a244b70caa90bdf7 ]

Revert commit 75b18aac6fa3 ("MIPS: unhide PATA_PLATFORM") now that
HAVE_PATA_PLATFORM is set selectively for all the relevant platforms.

Verified with `db1xxx_defconfig' and `sb1250_swarm_defconfig' by making
sure PATA_PLATFORM is still there in `.config' with this change applied,
and with `malta_defconfig' by making sure it's now gone.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index cf1fbf4eaa8a0..0e62f5edaee2e 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -83,7 +83,6 @@ config MIPS
 	select HAVE_LD_DEAD_CODE_DATA_ELIMINATION
 	select HAVE_MOD_ARCH_SPECIFIC
 	select HAVE_NMI
-	select HAVE_PATA_PLATFORM
 	select HAVE_PERF_EVENTS
 	select HAVE_PERF_REGS
 	select HAVE_PERF_USER_STACK_DUMP
-- 
2.40.1



