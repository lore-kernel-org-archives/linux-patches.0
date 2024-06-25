Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0C11465A8;
	Tue, 25 Jun 2024 09:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308983; cv=none; b=EnvSUxyxudZ3TVqA/hwtLLHeHC9OwiPRV5jhCbP3KOYROMgIw5rrnVAV6BcL2idEKBGRwL6jRlso9H4Eo/+lvXdYLnvj6/mgX6Ru/1HBGvnrUwI15501nJjet/cXAn9FXuZhQOUHvnUWX0njsQJ/9nmb6AxtsBUxH9bIqS7sD34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308983; c=relaxed/simple;
	bh=cqxzQcvc+H5YhdeXpnLUK0/stEFWNeexajWSqv+1AjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTNMSj7bgqYOHZC35CHayxlVh4d29ZLA3nyFycbr6T4j8nUeDDmrbAz5pBQf05IokqT5+3as+HAsr2oTcDetGTLJsK3acApsWPqt5uoZcv21J4a9DrVVR+NjDBPGxM0pyA9A8QW1NZeWy3gLa/Vsh1fvxQPTuk9wLNPw8THRmMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eHeyIwqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eHeyIwqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9CFC32789;
	Tue, 25 Jun 2024 09:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308983;
	bh=cqxzQcvc+H5YhdeXpnLUK0/stEFWNeexajWSqv+1AjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eHeyIwqzkvg5NeTIvA2IP2BXxPg3WSlbIOGdlBAJe8KwQS+kUgXlATXYupse66FPr
	 mMHDgw+q3plCKZiQ1NqTVYjFXlSB7rZGqf0Y7GUAbXZajocsoOl0KnWwJD9aigTvvz
	 XLrZay82HpPpllDkgNrX8TtfWPxMhlVm0cNTPTMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parker Newman <pnewman@connecttech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/192] serial: exar: adding missing CTI and Exar PCI ids
Date: Tue, 25 Jun 2024 11:32:08 +0200
Message-ID: <20240625085539.321608861@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Parker Newman <pnewman@connecttech.com>

[ Upstream commit b86ae40ffcf5a16b9569b1016da4a08c4f352ca2 ]

- Added Connect Tech and Exar IDs not already in pci_ids.h

Signed-off-by: Parker Newman <pnewman@connecttech.com>
Link: https://lore.kernel.org/r/7c3d8e795a864dd9b0a00353b722060dc27c4e09.1713270624.git.pnewman@connecttech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_exar.c | 42 +++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/tty/serial/8250/8250_exar.c b/drivers/tty/serial/8250/8250_exar.c
index 4d20f3aa280cd..27430fdd9e761 100644
--- a/drivers/tty/serial/8250/8250_exar.c
+++ b/drivers/tty/serial/8250/8250_exar.c
@@ -41,8 +41,50 @@
 #define PCI_DEVICE_ID_COMMTECH_4228PCIE		0x0021
 #define PCI_DEVICE_ID_COMMTECH_4222PCIE		0x0022
 
+#define PCI_VENDOR_ID_CONNECT_TECH				0x12c4
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_2_SP_OPTO        0x0340
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_4_SP_OPTO_A      0x0341
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_4_SP_OPTO_B      0x0342
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_2_XPRS           0x0350
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_4_XPRS_A         0x0351
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_4_XPRS_B         0x0352
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_8_XPRS           0x0353
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_16_XPRS_A        0x0354
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_16_XPRS_B        0x0355
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_2_XPRS_OPTO      0x0360
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_4_XPRS_OPTO_A    0x0361
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_4_XPRS_OPTO_B    0x0362
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_8_SP             0x0370
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_8_SP_232         0x0371
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_8_SP_485         0x0372
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_4_4_SP           0x0373
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_6_2_SP           0x0374
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_2_6_SP           0x0375
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_8_SP_232_NS      0x0376
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_2_XP_OPTO_LEFT   0x0380
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_2_XP_OPTO_RIGHT  0x0381
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_4_XP_OPTO        0x0382
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_4_4_XPRS_OPTO    0x0392
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_8_XPRS_LP        0x03A0
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_8_XPRS_LP_232    0x03A1
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_8_XPRS_LP_485    0x03A2
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCI_UART_8_XPRS_LP_232_NS 0x03A3
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCIE_XEG001               0x0602
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCIE_XR35X_BASE           0x1000
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCIE_XR35X_2              0x1002
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCIE_XR35X_4              0x1004
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCIE_XR35X_8              0x1008
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCIE_XR35X_12             0x100C
+#define PCI_SUBDEVICE_ID_CONNECT_TECH_PCIE_XR35X_16             0x1010
+#define PCI_DEVICE_ID_CONNECT_TECH_PCI_XR79X_12_XIG00X          0x110c
+#define PCI_DEVICE_ID_CONNECT_TECH_PCI_XR79X_12_XIG01X          0x110d
+#define PCI_DEVICE_ID_CONNECT_TECH_PCI_XR79X_16                 0x1110
+
 #define PCI_DEVICE_ID_EXAR_XR17V4358		0x4358
 #define PCI_DEVICE_ID_EXAR_XR17V8358		0x8358
+#define PCI_DEVICE_ID_EXAR_XR17V252		0x0252
+#define PCI_DEVICE_ID_EXAR_XR17V254		0x0254
+#define PCI_DEVICE_ID_EXAR_XR17V258		0x0258
 
 #define PCI_SUBDEVICE_ID_USR_2980		0x0128
 #define PCI_SUBDEVICE_ID_USR_2981		0x0129
-- 
2.43.0



