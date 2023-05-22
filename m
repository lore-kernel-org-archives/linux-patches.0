Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ABD2171BA
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:43:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A504C433D2;
	Mon, 22 May 2023 19:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784629;
	bh=iqHnxB0a5D8XNdGhishRtWcJrx4X4FcFwoiryho7Jvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kPe4hSZVBhX+cUemjCarG1I+ZbfuGERpr5AOjXik/bAjqfFRF/GMcxmMfm2dggF+z
	 pN4ySMrcjhhE11bXV1alIsPrQdiLJToxgh6Yyf7agAA4xreWRwbZg7KM3s7T8yBtYY
	 AOfgVTJO5EYRIfoL02+aAOa8yg5opuBvYF/LeLls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Hortmann <philipp.g.hortmann@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 145/364] staging: rtl8192e: Replace macro RTL_PCI_DEVICE with PCI_DEVICE
Date: Mon, 22 May 2023 20:07:30 +0100
Message-Id: <20230522190416.389735437@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Philipp Hortmann <philipp.g.hortmann@gmail.com>

[ Upstream commit fda2093860df4812d69052a8cf4997e53853a340 ]

Replace macro RTL_PCI_DEVICE with PCI_DEVICE to get rid of rtl819xp_ops
which is empty.

Signed-off-by: Philipp Hortmann <philipp.g.hortmann@gmail.com>
Link: https://lore.kernel.org/r/8b45ee783fa91196b7c9d6fc840a189496afd2f4.1677133271.git.philipp.g.hortmann@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c | 6 +++---
 drivers/staging/rtl8192e/rtl8192e/rtl_core.h | 5 -----
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index 72d76dc7df781..92552ce30cd58 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -48,9 +48,9 @@ static const struct rtl819x_ops rtl819xp_ops = {
 };
 
 static struct pci_device_id rtl8192_pci_id_tbl[] = {
-	{RTL_PCI_DEVICE(0x10ec, 0x8192, rtl819xp_ops)},
-	{RTL_PCI_DEVICE(0x07aa, 0x0044, rtl819xp_ops)},
-	{RTL_PCI_DEVICE(0x07aa, 0x0047, rtl819xp_ops)},
+	{PCI_DEVICE(0x10ec, 0x8192)},
+	{PCI_DEVICE(0x07aa, 0x0044)},
+	{PCI_DEVICE(0x07aa, 0x0047)},
 	{}
 };
 
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.h b/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
index fd96eef90c7fa..bbc1c4bac3588 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
@@ -55,11 +55,6 @@
 #define IS_HARDWARE_TYPE_8192SE(_priv)		\
 	(((struct r8192_priv *)rtllib_priv(dev))->card_8192 == NIC_8192SE)
 
-#define RTL_PCI_DEVICE(vend, dev, cfg) \
-	.vendor = (vend), .device = (dev), \
-	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID, \
-	.driver_data = (kernel_ulong_t)&(cfg)
-
 #define TOTAL_CAM_ENTRY		32
 #define CAM_CONTENT_COUNT	8
 
-- 
2.39.2



