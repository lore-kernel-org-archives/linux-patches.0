Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730732AF00;
	Fri, 24 Nov 2023 18:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T9JDeUzP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002B7C433C8;
	Fri, 24 Nov 2023 18:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849381;
	bh=WtwxF5/GHATmn08Y/R8I2u1AuPa5f6kPT/ilYjSrLCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9JDeUzPLeZ4GFQHEjKsIRdHpqjQ8QQiT1QmpTIAi+r2fIMv/faz4ZN3belf+gx4h
	 RFkCRqZG3gO/7Ltl7O84+6eAi5rB2zr7i6Kut7YXIrkd090GxyFo2stirk0Uykq8pq
	 w2FWiTu/wNE68rOIFb1dzp60W42PM/RFCkHC4VxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Jean Delvare <jdelvare@suse.de>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/530] i2c: i801: Add support for Intel Birch Stream SoC
Date: Fri, 24 Nov 2023 17:45:00 +0000
Message-ID: <20231124172032.169193904@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit 8c56f9ef25a33e51f09a448d25cf863b61c9658d ]

Add SMBus PCI ID on Intel Birch Stream SoC.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/i2c/busses/i2c-i801.rst | 1 +
 drivers/i2c/busses/Kconfig            | 1 +
 drivers/i2c/busses/i2c-i801.c         | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/Documentation/i2c/busses/i2c-i801.rst b/Documentation/i2c/busses/i2c-i801.rst
index e76e68ccf7182..10eced6c2e462 100644
--- a/Documentation/i2c/busses/i2c-i801.rst
+++ b/Documentation/i2c/busses/i2c-i801.rst
@@ -47,6 +47,7 @@ Supported adapters:
   * Intel Alder Lake (PCH)
   * Intel Raptor Lake (PCH)
   * Intel Meteor Lake (SOC and PCH)
+  * Intel Birch Stream (SOC)
 
    Datasheets: Publicly available at the Intel website
 
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 6644eebedaf3b..97d27e01a6ee2 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -158,6 +158,7 @@ config I2C_I801
 	    Alder Lake (PCH)
 	    Raptor Lake (PCH)
 	    Meteor Lake (SOC and PCH)
+	    Birch Stream (SOC)
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index 1d855258a45dc..89631fdf6e2fe 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -79,6 +79,7 @@
  * Meteor Lake-P (SOC)		0x7e22	32	hard	yes	yes	yes
  * Meteor Lake SoC-S (SOC)	0xae22	32	hard	yes	yes	yes
  * Meteor Lake PCH-S (PCH)	0x7f23	32	hard	yes	yes	yes
+ * Birch Stream (SOC)		0x5796	32	hard	yes	yes	yes
  *
  * Features supported by this driver:
  * Software PEC				no
@@ -231,6 +232,7 @@
 #define PCI_DEVICE_ID_INTEL_JASPER_LAKE_SMBUS		0x4da3
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_P_SMBUS		0x51a3
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_M_SMBUS		0x54a3
+#define PCI_DEVICE_ID_INTEL_BIRCH_STREAM_SMBUS		0x5796
 #define PCI_DEVICE_ID_INTEL_BROXTON_SMBUS		0x5ad4
 #define PCI_DEVICE_ID_INTEL_RAPTOR_LAKE_S_SMBUS		0x7a23
 #define PCI_DEVICE_ID_INTEL_ALDER_LAKE_S_SMBUS		0x7aa3
@@ -1044,6 +1046,7 @@ static const struct pci_device_id i801_ids[] = {
 	{ PCI_DEVICE_DATA(INTEL, METEOR_LAKE_P_SMBUS,		FEATURES_ICH5 | FEATURE_TCO_CNL) },
 	{ PCI_DEVICE_DATA(INTEL, METEOR_LAKE_SOC_S_SMBUS,	FEATURES_ICH5 | FEATURE_TCO_CNL) },
 	{ PCI_DEVICE_DATA(INTEL, METEOR_LAKE_PCH_S_SMBUS,	FEATURES_ICH5 | FEATURE_TCO_CNL) },
+	{ PCI_DEVICE_DATA(INTEL, BIRCH_STREAM_SMBUS,		FEATURES_ICH5 | FEATURE_TCO_CNL) },
 	{ 0, }
 };
 
-- 
2.42.0



