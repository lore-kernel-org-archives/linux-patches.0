Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4802AB21
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 287B5C433C8;
	Wed, 20 Sep 2023 11:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211103;
	bh=o2+2QFuetaz7sAB2hXicbP/f/HSCh2Lx4Z4YRThuGnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YUiUfjBzlPXWssbnd8R+hwKpjtBzRAoLdM82cS0hlmia4ttSyGrG7euc57wdiUKyY
	 bJS3GFzHAAwYUt6XATblamiTytTmgA+LdVg/0ka2aQMFxqRtq+qQtoT439pAEZgnTO
	 qnvWpBcmdhKrzmB5GcNP/yOiR26YnEVEbmIqCNu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Baoquan He <bhe@redhat.com>,
	Derek Kiernan <derek.kiernan@amd.com>,
	Dragan Cvetic <dragan.cvetic@amd.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/139] misc: open-dice: make OPEN_DICE depend on HAS_IOMEM
Date: Wed, 20 Sep 2023 13:30:14 +0200
Message-ID: <20230920112838.638910824@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
References: <20230920112835.549467415@linuxfoundation.org>
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

From: Baoquan He <bhe@redhat.com>

[ Upstream commit aefc8b57af7787c80686e49a5841e9289cb11f53 ]

On s390 systems (aka mainframes), it has classic channel devices for
networking and permanent storage that are currently even more common
than PCI devices. Hence it could have a fully functional s390 kernel
with CONFIG_PCI=n, then the relevant iomem mapping functions
[including ioremap(), devm_ioremap(), etc.] are not available.

Here let OPEN_DICE depend on HAS_IOMEM so that it won't be built
to cause below compiling error if PCI is unset:

------
ERROR: modpost: "devm_memremap" [drivers/misc/open-dice.ko] undefined!
ERROR: modpost: "devm_memunmap" [drivers/misc/open-dice.ko] undefined!
------

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202306211329.ticOJCSv-lkp@intel.com/
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Derek Kiernan <derek.kiernan@amd.com>
Cc: Dragan Cvetic <dragan.cvetic@amd.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20230707135852.24292-4-bhe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 358ad56f65245..0cef98319f0e5 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -474,6 +474,7 @@ config HISI_HIKEY_USB
 config OPEN_DICE
 	tristate "Open Profile for DICE driver"
 	depends on OF_RESERVED_MEM
+	depends on HAS_IOMEM
 	help
 	  This driver exposes a DICE reserved memory region to userspace via
 	  a character device. The memory region contains Compound Device
-- 
2.40.1



