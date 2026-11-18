Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053318;
	b=jYd5iWRZ6u9bZnWjvuzQWq6YVkwKSbYslTxRgb1dpGVhrIFV3J8s4icQqXb5QKvbmBiz
	 IrN1Y9JB3WdmHvnHjZVbm0keAJK6xcPlop9wYqMKcsgtwGfGx1c2pPTAl+lvKEOs0pF/H
	 JUYa0JZB1eA+dj6EINXM+0ZcsNECUAxo6DpZTNV94F8Tio4tA1lFnwIoTqcr7Eqp9/fuM
	 MTrtWQ0wSdsqXECYR/hXK5JfxqyDItH3S8TyAvIQCjqFXCzhGoVB2oyuNdW+GuQOq/zzi
	 AExbXljmtxeYLJRNyTba76LI2VyIDxK3LSLHTTljoKTpb65ImroDCYW1xFEdVAxg4aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3ZCo9Gmb6IN4wjvVAr7Aif014tDdLBVKMJabnboCGo8=;
	b=3qwWO7RWaw66c4CzoK54Jsxpf6teqCMwSDrIsmmwlykzQwO1uY/12BgUM6KRk0hpzd/+
	 L9W1G+o7gaSBHoHqg/U1NgapBDAvBqxGoCOaDjZidRKZrnmPqSptCGnV8+I9QdR87JSk/
	 2BM4RHs1gcUXRtylk1WnGWBeFJvhQCsxqI1UAxKYlD/2o1GCm+ihFHl9dPQ7f19lPrH8y
	 tpwV6Osd61mlTpBrh5iO1cnyzeWgWUsZzys5cYNiYUpya+Wa41w515jc3xmAwGKd/kVPi
	 OR2PbEmxOW/I9XfrYwvCLDlnpSlQHlRUh1eORCnlGOtO1s819NRwAba8rLCCjbJ+Svw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bDKRdSSf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0DB60A2601;
	Thu, 19 Nov 2026 01:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bDKRdSSf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81421F000C7;
	Thu, 19 Nov 2026 01:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053318;
	bh=3ZCo9Gmb6IN4wjvVAr7Aif014tDdLBVKMJabnboCGo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bDKRdSSfDOpHGeQNVbBGOQPLkIpPIRNM+8vLIypnGm3dN/lPprcCglx+LgbVd46Nt
	 2fFxPqqqIelX8FjMNbGb3OT6vHQzYcewYRgn+cwuGmxE0tM3XRE9WareHxeto+3WTM
	 2NSKtVHFORtDYq7NoYmxKOKrFM7Dh2TA+DNzdRN8=
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
Subject: [PATCH 5.15 0876/2214] openrisc: export __mulsi3 for modules
Date: Wed, 18 Nov 2026 15:42:32 +0100
Message-ID: <20261118150047.174908617@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



