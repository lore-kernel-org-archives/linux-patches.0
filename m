Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3FB18B483;
	Tue, 30 Jul 2024 16:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356204; cv=none; b=pwvAeH/HtK30zKml24b5tFreVcWG/al8FOdEi8ZFFtm2g+nZV2ZVQwLxfTG3a84Aqu2pYdVXYVoM4y9XHEKVMyo3V4ob1uV1yKjtCZCrubcNNEj2cfZUhE6kmUsbcUfvmTjeCZaYvVmGpnrcDPqyFsIgNwZRGf3ouFrvTChj6LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356204; c=relaxed/simple;
	bh=uaxnvbV7kdVRZXKGniXv7A3bNJJ4/qRr3vGUX55MzA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuoNArM6Unrf5EX53HRwAHLZOBFpaP+1tA0mVVWageEQ1LzANnAB5jUY1zaz0pcg93Ja4BzeYiGRMNpWA9d435IMdImab2D+8uW6vBJPnyFstpdohTxWOGZJaMNLVM6ALgNMIKRQMsd9rdSIgGq99fljrGceN9dM4/DS0gF7ClU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvVi2iHZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvVi2iHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E497CC32782;
	Tue, 30 Jul 2024 16:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356204;
	bh=uaxnvbV7kdVRZXKGniXv7A3bNJJ4/qRr3vGUX55MzA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvVi2iHZtKkRD7+MAkq6HlowFFcBVNewxuYi4pN54XyHsOIvrXCaW4GsehgZ9COOB
	 1yK9PtQAXrr1IyeTSoF1qpxGe5vJiZXFlz9r19trbPAswauaznGMRbSA5jyVRgMWs1
	 wn3APrgI2tLvEM2EdXLkLYYLyE4kg4Cy2eoQr36Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 168/440] mfd: rsmu: Split core code into separate module
Date: Tue, 30 Jul 2024 17:46:41 +0200
Message-ID: <20240730151622.431716063@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index 7ed3ef4a698cf..e26c64bf7cb77 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -276,7 +276,5 @@ obj-$(CONFIG_MFD_INTEL_M10_BMC)   += intel-m10-bmc.o
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



