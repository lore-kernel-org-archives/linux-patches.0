Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059060;
	b=4W1kdVQvvbp39RM6k09M2pjD3lK9Rr7r5D6aar/uKHPEfcTwBlv1QkT5nVyviyhkuAdp
	 8RMKtzuRtS6xMRCk0bDh4wRGKGTE62vQm6wK6ReDBG3w8cphMmM/FtIxONxMgS46CnwcG
	 HLBqfPPgz8T0t7dobBrTqFTdXy4zY2vuYh6EcDpPt0PirwrVSe2DZ4DSEJ8YWA50GD+3P
	 mtscepCeAjXU6pv881d+k53p6d7HXHCd4XsLqHcmusPdKn7K+dkVvu1MKcZtE/PVybYd0
	 khATgZSw0/WOWrPmPKE4bB7uQBra4MTtMU6ZuvXJ+psqCqtAizcLGLt4wdzYvVMjxjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZJzydq58jJV0JFASCdKJI6LJI7GXZJNoH8WdwvF92ww=;
	b=Wbk88SBLJFh4NXVR+giyQPql40O0hmB0PFygpDXcoCldzOq1CnRK3ESgT3j6ZhvZv6ZB
	 uvLd1LihuzkvkGPPufCbDckE0Egk/UguFJW+8B07QyRpeqHqIkYZroDQBcLcGksydONhZ
	 D0CRaTD6Hmt9ZRphTqzzfOOANelVE8tz97Bzv62bxjBQ6Ji1B9lPpKiPqbE89Qs2OVoih
	 xXZ5iOfjpBqMB6zBkDU0jClnm+u99Uu4mLKVS5bdrojeWfPkyf8ffA2hYoCrE1QJ8O/4K
	 RCFIH1a9myQRRv8tPzJRH/mqtnBrgKKD2oZBTuYJtmMjq98j92twvuiJJ9iQ2yXB6EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AxF1f1En;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAF4606A320;
	Thu, 19 Nov 2026 03:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AxF1f1En
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BF21F000C4;
	Thu, 19 Nov 2026 03:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059060;
	bh=ZJzydq58jJV0JFASCdKJI6LJI7GXZJNoH8WdwvF92ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AxF1f1EnsXaEmtJCqOxEShq5MiyF1PsSm7j+Xg31ingXSJy4gcQGZV5ddGnYNPz1a
	 Ar351HSuxA6s65sPphy91EcfXdgybcMAFBjITDHcqkO6X+BfJO/RR6KNUuzN0HrhqC
	 V7xTAFtgH8sh8Y80FgIOjKfzLJlkVjnLx8sOr/Do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	kernel test robot <lkp@intel.com>,
	Bradley Morgan <brads@mainlining.org>,
	Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0705/1848] openrisc: export __mulsi3 for modules
Date: Wed, 18 Nov 2026 15:45:43 +0100
Message-ID: <20261118145945.391560206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

[ Upstream commit 8ff981aa283a0ce516c2dc65a48a185ed336c657 ]

OpenRISC configurations without hardware multiplication fail to build
modules which contain compiler-generated calls to __mulsi3.  The failure
is widespread, affecting filesystems, drivers and KUnit tests at modpost.

When CONFIG_OPENRISC_HAVE_INST_MUL is disabled, the architecture Makefile
passes -msoft-mul to GCC.  The multiplication helper is supplied by the
libgcc archive linked into vmlinux, but or32_ksyms.c does not export it.
Built-in callers can therefore link while module callers cannot resolve
the symbol.

Export __mulsi3 alongside the other compiler-generated helpers.

The omission predates 7c3f4d699f34 ("resource, kunit: stop selecting
GET_FREE_REGION"), which the robot identified when reporting an additional
failing module.  It was already present in the initial OpenRISC export
list.

Fixes: 616257669e1a ("OpenRISC: Miscellaneous")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202610290106.o8Fs3NvO-lkp@intel.com/
Reviewed-by: Bradley Morgan <brads@mainlining.org>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Karl Mehltretter <kmehltretter@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/openrisc/kernel/or32_ksyms.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/openrisc/kernel/or32_ksyms.c b/arch/openrisc/kernel/or32_ksyms.c
index 212e5f85004cc..c63d7f25bc575 100644
--- a/arch/openrisc/kernel/or32_ksyms.c
+++ b/arch/openrisc/kernel/or32_ksyms.c
@@ -35,6 +35,7 @@ DECLARE_EXPORT(__divsi3);
 DECLARE_EXPORT(__umodsi3);
 DECLARE_EXPORT(__modsi3);
 DECLARE_EXPORT(__muldi3);
+DECLARE_EXPORT(__mulsi3);
 DECLARE_EXPORT(__ashrdi3);
 DECLARE_EXPORT(__ashldi3);
 DECLARE_EXPORT(__lshrdi3);
-- 
2.53.0



