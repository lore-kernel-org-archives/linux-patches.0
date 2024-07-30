Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87A21A6195;
	Tue, 30 Jul 2024 16:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358515; cv=none; b=Hxv4Z9EMf3hjGhkoXIw8Q5ru2TonFaNFpcJQQoisK6M1WdPCGhyPYysEYSBp3hVewlIfLbiauvFx5NoRuVBxO1TJfPfXjS0J6YuTvtNlQPpYPReNE4esCKK0KvMxZRdAJfY+JEJ4g1P17zoOItk+Q29pT6pGtG59x/U0eqjf7ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358515; c=relaxed/simple;
	bh=xMe9p67AR7S/q+0h/BuL1kkEd8CJYTQDkzUClpl9Lig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYjMBTBAth8nMW8o+LJts3WIEc8IxVqMHD0/7rgVK39dLv5SLY37DXdps4F+/42YILXrzE6asVqZ97C2qjhDNmwSoyHmq/bewOpYggjq402NbWDd66eJTvqRkbvK+dtUYZBHi/NJKcTdMUrQFrQ3hSE2Yfg0wP8MHNcr82P5/5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SVUtkc/c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVUtkc/c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241ACC32782;
	Tue, 30 Jul 2024 16:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358515;
	bh=xMe9p67AR7S/q+0h/BuL1kkEd8CJYTQDkzUClpl9Lig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SVUtkc/ceEJDiAxDoW9wMILnrgyIqByQupsqTBf9aLRoeEYIQBIvpRqPG38Z04MWA
	 ruxRT6vZYeCkK/vKPKpiyAWope46eEK5/tBeFV91bLH31njGCuMB8ToOch4bmIa7a8
	 rKBi7MDu4Fly45YT32ElesJT5o4FNWD8YUptdPN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 366/809] mfd: rsmu: Split core code into separate module
Date: Tue, 30 Jul 2024 17:44:02 +0200
Message-ID: <20240730151739.110065231@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c879a8c39dd55e7fabdd8d13341f7bc5200db377 ]

Linking a file into two modules can have unintended side-effects
and produces a W=1 warning:

scripts/Makefile.build:236: drivers/mfd/Makefile: rsmu_core.o is added to multiple modules: rsmu-i2c rsmu-spi

Make this one a separate module instead.

Fixes: a1867f85e06e ("mfd: Add Renesas Synchronization Management Unit (SMU) support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20240529094856.1869543-1-arnd@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/Makefile    | 6 ++----
 drivers/mfd/rsmu_core.c | 2 ++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index c66f07edcd0e6..db1ba39de3b59 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -280,7 +280,5 @@ obj-$(CONFIG_MFD_INTEL_M10_BMC_PMCI)   += intel-m10-bmc-pmci.o
 obj-$(CONFIG_MFD_ATC260X)	+= atc260x-core.o
 obj-$(CONFIG_MFD_ATC260X_I2C)	+= atc260x-i2c.o
 
-rsmu-i2c-objs			:= rsmu_core.o rsmu_i2c.o
-rsmu-spi-objs			:= rsmu_core.o rsmu_spi.o
-obj-$(CONFIG_MFD_RSMU_I2C)	+= rsmu-i2c.o
-obj-$(CONFIG_MFD_RSMU_SPI)	+= rsmu-spi.o
+obj-$(CONFIG_MFD_RSMU_I2C)	+= rsmu_i2c.o rsmu_core.o
+obj-$(CONFIG_MFD_RSMU_SPI)	+= rsmu_spi.o rsmu_core.o
diff --git a/drivers/mfd/rsmu_core.c b/drivers/mfd/rsmu_core.c
index 29437fd0bd5bf..fd04a6e5dfa31 100644
--- a/drivers/mfd/rsmu_core.c
+++ b/drivers/mfd/rsmu_core.c
@@ -78,11 +78,13 @@ int rsmu_core_init(struct rsmu_ddata *rsmu)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(rsmu_core_init);
 
 void rsmu_core_exit(struct rsmu_ddata *rsmu)
 {
 	mutex_destroy(&rsmu->lock);
 }
+EXPORT_SYMBOL_GPL(rsmu_core_exit);
 
 MODULE_DESCRIPTION("Renesas SMU core driver");
 MODULE_LICENSE("GPL");
-- 
2.43.0



