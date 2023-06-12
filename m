Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F01B18C35
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DACC433EF;
	Mon, 12 Jun 2023 10:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565765;
	bh=2RHFQ/BPw0p3OXEEHAkTbn4lw54TNqA+qaR4zPdfRKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BbRAlOGFflkgGN28azb+n1b3oMu1lQ/+r2ctWmQu/WTZWUc8XaGIKkYCm0iDkP7kC
	 AOM3U8+Q1p7YDOXazIq5Q6ANVKiNSm1XODO8QVxpt9e90hhl0CA1HlPGoDhyhYbX9l
	 gGpDvDgk5+FOwYQJnoaV85QSfDUpNqiJUKjgvh6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Hutchings <ben@decadent.org.uk>,
	Philipp Hortmann <philipp.g.hortmann@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 21/21] Revert "staging: rtl8192e: Replace macro RTL_PCI_DEVICE with PCI_DEVICE"
Date: Mon, 12 Jun 2023 12:26:16 +0200
Message-ID: <20230612101651.766042597@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101651.048240731@linuxfoundation.org>
References: <20230612101651.048240731@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit 8809b5e3bca90170deb466d7f4447dc91c8569da which is
commit fda2093860df4812d69052a8cf4997e53853a340 upstream.

Ben reports that this should not have been backported to the older
kernels as the rest of the macro is not empty.  It was a clean-up patch
in 6.4-rc1 only, it did not add new device ids.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Philipp Hortmann <philipp.g.hortmann@gmail.com>
Cc: Sasha Levin <sashal@kernel.org>
Link: https://lore.kernel.org/r/aa0d401a7f63448cd4c2fe4a2d7e8495d9aa123e.camel@decadent.org.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c |    6 +++---
 drivers/staging/rtl8192e/rtl8192e/rtl_core.h |    5 +++++
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -61,9 +61,9 @@ static const struct rtl819x_ops rtl819xp
 };
 
 static struct pci_device_id rtl8192_pci_id_tbl[] = {
-	{PCI_DEVICE(0x10ec, 0x8192)},
-	{PCI_DEVICE(0x07aa, 0x0044)},
-	{PCI_DEVICE(0x07aa, 0x0047)},
+	{RTL_PCI_DEVICE(0x10ec, 0x8192, rtl819xp_ops)},
+	{RTL_PCI_DEVICE(0x07aa, 0x0044, rtl819xp_ops)},
+	{RTL_PCI_DEVICE(0x07aa, 0x0047, rtl819xp_ops)},
 	{}
 };
 
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
@@ -67,6 +67,11 @@
 #define IS_HARDWARE_TYPE_8192SE(_priv)		\
 	(((struct r8192_priv *)rtllib_priv(dev))->card_8192 == NIC_8192SE)
 
+#define RTL_PCI_DEVICE(vend, dev, cfg) \
+	.vendor = (vend), .device = (dev), \
+	.subvendor = PCI_ANY_ID, .subdevice = PCI_ANY_ID, \
+	.driver_data = (kernel_ulong_t)&(cfg)
+
 #define TOTAL_CAM_ENTRY		32
 #define CAM_CONTENT_COUNT	8
 


