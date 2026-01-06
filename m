Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2037035F8D3;
	Tue,  6 Jan 2026 17:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721709; cv=none; b=Sbvsj8HnS7GgJ/w/33xOtd9M0uF7fkMDfEofEjoB3oYdPPHkQBtpYi2Z09TXnyBDvYR+xzWuVRO1jRgyqpl7yC+YFcSyMFgjDIP1JT8AL3aRnGVZqOmR3WDRtvzyEvNbxhyT2kubMr9lxfOFVmEloggP+VPmu190l2vlg4+6ScM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721709; c=relaxed/simple;
	bh=sajxAa95S3oQLraWLwCERTyVAYWDAoLajdSNmYCRK78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVcaaSYwmRV1EYZhkBlKDK5mig8BiIjm9Kiu7VVVhvKV5NvT0SWIo4z98lQ2tYpeHxpOrJkcC5nMFOiu6oeL2GIbEyq/dVd5omrxuvonviEsIoTetMeeRxDl/jUKfud9B5GtfUHQxfygCFa9s07sPxKpt21YzhgigrwfY1NzpP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bjnJ8uy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bjnJ8uy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AC2C116C6;
	Tue,  6 Jan 2026 17:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721709;
	bh=sajxAa95S3oQLraWLwCERTyVAYWDAoLajdSNmYCRK78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1bjnJ8uyuSxS2xDbHV2S+AbngrlSgLkcnBYMMZVXsBpKmRvdNbbAKJXlcVNbX6aV9
	 fxpbS458s1M24fX6F729ZnroKSXM6M3MDeJVLLlwt/ICq3YkrpB4yaeqNiZdxpyWzp
	 Llq8lQHmIPS80jse72nfAkkjsH++UIDaEY9YhDiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajashekar Hudumula <rajashekar.hudumula@broadcom.com>,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Bhargava Chenna Marreddy <bhargava.marreddy@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 047/312] bng_en: update module description
Date: Tue,  6 Jan 2026 18:02:01 +0100
Message-ID: <20260106170549.558220342@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Rajashekar Hudumula <rajashekar.hudumula@broadcom.com>

[ Upstream commit d5dc28305143f126dc3d8da21e1ad75865b194e2 ]

The Broadcom BCM57708/800G NIC family is branded as ThorUltra.
Update the driver description accordingly.

Fixes: 74715c4ab0fa0 ("bng_en: Add PCI interface")
Signed-off-by: Rajashekar Hudumula <rajashekar.hudumula@broadcom.com>
Reviewed-by: Vikas Gupta <vikas.gupta@broadcom.com>
Reviewed-by: Bhargava Chenna Marreddy <bhargava.marreddy@broadcom.com>
Link: https://patch.msgid.link/20251217104748.3004706-1-rajashekar.hudumula@broadcom.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/Kconfig          | 8 ++++----
 drivers/net/ethernet/broadcom/bnge/bnge.h      | 2 +-
 drivers/net/ethernet/broadcom/bnge/bnge_core.c | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
index 9fdef874f5ca..fe15d684990f 100644
--- a/drivers/net/ethernet/broadcom/Kconfig
+++ b/drivers/net/ethernet/broadcom/Kconfig
@@ -254,14 +254,14 @@ config BNXT_HWMON
 	  devices, via the hwmon sysfs interface.
 
 config BNGE
-	tristate "Broadcom Ethernet device support"
+	tristate "Broadcom ThorUltra Ethernet device support"
 	depends on PCI
 	select NET_DEVLINK
 	select PAGE_POOL
 	help
-	  This driver supports Broadcom 50/100/200/400/800 gigabit Ethernet cards.
-	  The module will be called bng_en. To compile this driver as a module,
-	  choose M here.
+	  This driver supports Broadcom ThorUltra 50/100/200/400/800 gigabit
+	  Ethernet cards. The module will be called bng_en. To compile this
+	  driver as a module, choose M here.
 
 config BCMASP
 	tristate "Broadcom ASP 2.0 Ethernet support"
diff --git a/drivers/net/ethernet/broadcom/bnge/bnge.h b/drivers/net/ethernet/broadcom/bnge/bnge.h
index 7aed5f81cd51..0c154995d9ab 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge.h
+++ b/drivers/net/ethernet/broadcom/bnge/bnge.h
@@ -5,7 +5,7 @@
 #define _BNGE_H_
 
 #define DRV_NAME	"bng_en"
-#define DRV_SUMMARY	"Broadcom 800G Ethernet Linux Driver"
+#define DRV_SUMMARY	"Broadcom ThorUltra NIC Ethernet Driver"
 
 #include <linux/etherdevice.h>
 #include <linux/bnxt/hsi.h>
diff --git a/drivers/net/ethernet/broadcom/bnge/bnge_core.c b/drivers/net/ethernet/broadcom/bnge/bnge_core.c
index 2c72dd34d50d..312a9db4d75d 100644
--- a/drivers/net/ethernet/broadcom/bnge/bnge_core.c
+++ b/drivers/net/ethernet/broadcom/bnge/bnge_core.c
@@ -19,7 +19,7 @@ char bnge_driver_name[] = DRV_NAME;
 static const struct {
 	char *name;
 } board_info[] = {
-	[BCM57708] = { "Broadcom BCM57708 50Gb/100Gb/200Gb/400Gb/800Gb Ethernet" },
+	[BCM57708] = { "Broadcom BCM57708 ThorUltra 50Gb/100Gb/200Gb/400Gb/800Gb Ethernet" },
 };
 
 static const struct pci_device_id bnge_pci_tbl[] = {
-- 
2.51.0



