Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF90155389;
	Mon,  6 Jan 2025 15:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177060; cv=none; b=W6T4EeWfVmaF7TocR6MqS3/z5riQJnTtokX0+DkQzaQbmyAwPoboudb38e5yEWyAHWtFaUCNMhdHLdAWCdJdPBrak0oorPRtUBtlz3lc87yp16yWRcLusgBokiMhMMOE3JqCEORNyAVek1Ll6hT8r3DpFDjOY27jl0hATs70pnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177060; c=relaxed/simple;
	bh=78zKPoyE9p9adugYQDKwn3cjzZT0xGFFTCJ2W+Mxf6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AdhcINenJHaEYSnlwCX8n8T249ZbiNIhIcx8vXmrHzRxYHgneHF4/wN/5b3AoBam1bceDlk29n8rVWoLVWTQaim6t5Ir3zfjJ1Br9ia84rn4tN+PEcZPr0fAuB275eT2RMOicZVXUQyIJO4OcTbZgBRFVyqpzAc3kRV3rBx6u3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d39QofMk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d39QofMk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726FFC4CED2;
	Mon,  6 Jan 2025 15:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177059;
	bh=78zKPoyE9p9adugYQDKwn3cjzZT0xGFFTCJ2W+Mxf6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d39QofMkvlCsiIoA1ZlfIvpCL7HEue6illQBp3Sl7PQUs2m0ubiLq4P6uq2SWkIDm
	 JfPhHVNopSPvtanOrZpsluRn3K+DQ4xbEBV1+BQUkCUrW4zTHHdPRzPaHdE7lAJcY/
	 mzmw7m8PDw9wJHlCJA8TmkudOBvIWpKoT5V4ZnzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/222] i2c: i801: Add support for Intel Panther Lake
Date: Mon,  6 Jan 2025 16:14:02 +0100
Message-ID: <20250106151152.045771508@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit bd492b58371295d3ae26162b9666be584abad68a ]

Add SMBus PCI IDs on Intel Panther Lake-P and -U.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/i2c/busses/i2c-i801.rst | 1 +
 drivers/i2c/busses/Kconfig            | 1 +
 drivers/i2c/busses/i2c-i801.c         | 6 ++++++
 3 files changed, 8 insertions(+)

diff --git a/Documentation/i2c/busses/i2c-i801.rst b/Documentation/i2c/busses/i2c-i801.rst
index c840b597912c..47e8ac5b7099 100644
--- a/Documentation/i2c/busses/i2c-i801.rst
+++ b/Documentation/i2c/busses/i2c-i801.rst
@@ -49,6 +49,7 @@ Supported adapters:
   * Intel Meteor Lake (SOC and PCH)
   * Intel Birch Stream (SOC)
   * Intel Arrow Lake (SOC)
+  * Intel Panther Lake (SOC)
 
    Datasheets: Publicly available at the Intel website
 
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 0dc3c91f52a8..982007a112c2 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -160,6 +160,7 @@ config I2C_I801
 	    Meteor Lake (SOC and PCH)
 	    Birch Stream (SOC)
 	    Arrow Lake (SOC)
+	    Panther Lake (SOC)
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called i2c-i801.
diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
index ed943f303cdb..18c04f5e41d9 100644
--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -81,6 +81,8 @@
  * Meteor Lake PCH-S (PCH)	0x7f23	32	hard	yes	yes	yes
  * Birch Stream (SOC)		0x5796	32	hard	yes	yes	yes
  * Arrow Lake-H (SOC)		0x7722	32	hard	yes	yes	yes
+ * Panther Lake-H (SOC)		0xe322	32	hard	yes	yes	yes
+ * Panther Lake-P (SOC)		0xe422	32	hard	yes	yes	yes
  *
  * Features supported by this driver:
  * Software PEC				no
@@ -258,6 +260,8 @@
 #define PCI_DEVICE_ID_INTEL_CANNONLAKE_H_SMBUS		0xa323
 #define PCI_DEVICE_ID_INTEL_COMETLAKE_V_SMBUS		0xa3a3
 #define PCI_DEVICE_ID_INTEL_METEOR_LAKE_SOC_S_SMBUS	0xae22
+#define PCI_DEVICE_ID_INTEL_PANTHER_LAKE_H_SMBUS	0xe322
+#define PCI_DEVICE_ID_INTEL_PANTHER_LAKE_P_SMBUS	0xe422
 
 struct i801_mux_config {
 	char *gpio_chip;
@@ -1049,6 +1053,8 @@ static const struct pci_device_id i801_ids[] = {
 	{ PCI_DEVICE_DATA(INTEL, METEOR_LAKE_PCH_S_SMBUS,	FEATURES_ICH5 | FEATURE_TCO_CNL) },
 	{ PCI_DEVICE_DATA(INTEL, BIRCH_STREAM_SMBUS,		FEATURES_ICH5 | FEATURE_TCO_CNL) },
 	{ PCI_DEVICE_DATA(INTEL, ARROW_LAKE_H_SMBUS,		FEATURES_ICH5 | FEATURE_TCO_CNL) },
+	{ PCI_DEVICE_DATA(INTEL, PANTHER_LAKE_H_SMBUS,		FEATURES_ICH5 | FEATURE_TCO_CNL) },
+	{ PCI_DEVICE_DATA(INTEL, PANTHER_LAKE_P_SMBUS,		FEATURES_ICH5 | FEATURE_TCO_CNL) },
 	{ 0, }
 };
 
-- 
2.39.5



