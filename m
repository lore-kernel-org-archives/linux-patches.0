Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4758132FA29;
	Mon, 29 Dec 2025 16:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025033; cv=none; b=Ix64kHPx2eB+ZQxRWEjdl5xXSXrc5lP4QJwty8geI+yUf8dVqE+7IXAQMqgYDaueWhBq7HwNjdGP/Jg2BlALMbfS10pJt515bqJG1EoJEUmt+Oj3qas7CJRHTmKKEQ1li5FT9uWpjInCU89nvIATGD59GZS6lnZhimDgDsWAenA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025033; c=relaxed/simple;
	bh=iqq2mI2VJE8clUR0dTk40jlFsryT4oHKerrBsBsyj70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EX7IRV8e0PYZD3n0Zkl4Ye/bANieAUSzncHW3hauKc2+NjpkL7yFIYboN91NwTZK5v97mjy6Ec0tQJIGQTR48daZ3HUO+t8uhmkY/GWUUy76SllIg6aWlhFe34VTV527V+CvTLDa/px8zXQWnVA5HklMBwYts4SvHoFPe7Glh8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+YmQGIu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+YmQGIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C348FC4CEF7;
	Mon, 29 Dec 2025 16:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025033;
	bh=iqq2mI2VJE8clUR0dTk40jlFsryT4oHKerrBsBsyj70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+YmQGIuopFL1k2kd4qXstqlC9kVhObvgnApwRkmxuhqOJ+M8wlkk1fMs7jgWMwc8
	 8VgG5lbg3kXIGkffKwFA5NWywNovy0zoXvmPjF/jaPLxclXPE6YjPkNQjxNZqdCE8E
	 k0KppffpfmPd2TNbpdDxgmo8CmBXu8pO6RhWpxuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 071/430] net: ti: icssg-prueth: add PTP_1588_CLOCK_OPTIONAL dependency
Date: Mon, 29 Dec 2025 17:07:53 +0100
Message-ID: <20251229160726.979456134@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 9e7477a427449a8a3cd00c188e20a880e3d94638 ]

The new icssg-prueth driver needs the same dependency as the other parts
that use the ptp-1588:

WARNING: unmet direct dependencies detected for TI_ICSS_IEP
  Depends on [m]: NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_TI [=y] && PTP_1588_CLOCK_OPTIONAL [=m] && TI_PRUSS [=y]
  Selected by [y]:
  - TI_PRUETH [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_TI [=y] && PRU_REMOTEPROC [=y] && NET_SWITCHDEV [=y]

Add the correct dependency on the two drivers missing it, and remove
the pointless 'imply' in the process.

Fixes: e654b85a693e ("net: ti: icssg-prueth: Add ICSSG Ethernet driver for AM65x SR1.0 platforms")
Fixes: 511f6c1ae093 ("net: ti: icssm-prueth: Adds ICSSM Ethernet driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20251204100138.1034175-1-arnd@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index a54d71155263c..fe5b2926d8ab0 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -209,6 +209,7 @@ config TI_ICSSG_PRUETH_SR1
 	depends on PRU_REMOTEPROC
 	depends on NET_SWITCHDEV
 	depends on ARCH_K3 && OF && TI_K3_UDMA_GLUE_LAYER
+	depends on PTP_1588_CLOCK_OPTIONAL
 	help
 	  Support dual Gigabit Ethernet ports over the ICSSG PRU Subsystem.
 	  This subsystem is available on the AM65 SR1.0 platform.
@@ -234,7 +235,7 @@ config TI_PRUETH
 	depends on PRU_REMOTEPROC
 	depends on NET_SWITCHDEV
 	select TI_ICSS_IEP
-	imply PTP_1588_CLOCK
+	depends on PTP_1588_CLOCK_OPTIONAL
 	help
 	  Some TI SoCs has Programmable Realtime Unit (PRU) cores which can
 	  support Single or Dual Ethernet ports with the help of firmware code
-- 
2.51.0



