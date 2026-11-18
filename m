Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027649;
	b=RTem/gJXn22kIjODKf251eDfox8E5lOpLqExKKh4pnaWAJGBDoB15PyTX1I0lj5DmE1Y
	 YSWAZ3khCc5IKGlQtrXg35+3sufEIvYQ5iNDBW0L02vwcWMYka3+vQWSj9jC5QtoI4MMg
	 sCCR/QXyMNyACsY8qnq8Ek8kjbTdEkfXRNmoUiHkF/DNtpW7zFi4qaIiREFSz8jxwdtkg
	 nuk84FJChzIZAqU0Sp2CKlpKtGwcd7aNqZTdeye40CifT2UfxPUg/19rrXWuCukwoaKZ4
	 deT5MLS6PzL3BxzejJM6tz7v1eqlI/f1nQ0JnN9hCFDpv+3zES7qCgEGOmifxuUSRKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XRAjOB63YbKkfofrv6trV+PuXlxEtbziShVtbwXFstg=;
	b=VmZ8CAufpJigGjM4iC78sR86PuNhy4xq5DIP7+kRrbKj0/KWhtLJCOcmidcRQ038cje3
	 v2d418rLBUcia+uXPLLaC5skyg444gbpZpgEmwtDZEyqR0gDdResEkotHQ5oIolLGWedF
	 TQyq7gNtrWjAtSnEKKOwtiIHPkCGbDjg7KhgXWW7VgsEQHWm8z71NkiYhTp8B3x0GmFXI
	 ekab1otmPQA+qJhP6BYg+G2HA6clOVzroYWGgmcHVenh/8XtvaJFfcLR+CAXd4OucH+rk
	 2gDSeXx/1igxSFj8UiMoKeVKwkYDY9IcNIvfJ6476lPuKTLvB5C9y1F1RIxt/09p/ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y825bcYK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4D3606A338;
	Wed, 18 Nov 2026 18:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y825bcYK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B356B1F000C4;
	Wed, 18 Nov 2026 18:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027649;
	bh=XRAjOB63YbKkfofrv6trV+PuXlxEtbziShVtbwXFstg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y825bcYKS6zSPxub0cA01lMKIGsk6ca5fIs4lRHnA+NterHTB2EC2ruxdPnpBN6L+
	 SF8NV0OTR0ACPH98jPlRu5AHmtXWrX2Q9lC1qdRRMKaD1H/ddO0Hf4cDaFwUMuvnFy
	 seAT/9jr+Ax1cPaOqRiq5wZN0nfiR1rEDjth9x8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1862/2151] Drivers: hv: vmbus: Check ACPI companion before use
Date: Wed, 18 Nov 2026 15:59:57 +0100
Message-ID: <20261118150229.629825285@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit dd57772e36f72f8d9a53d7fa4d90c974d8ebbcff ]

Platform drivers can be forced to bind to devices outside their match
tables through driver_override. vmbus_acpi_add() assumes that every bound
device has an ACPI companion and dereferences it without checking.

Return -ENODEV when the companion is absent to avoid a NULL pointer
dereference.

Signed-off-by: Jiale Yao <yaojiale02@163.com>
Fixes: 9c8434238041 ("Drivers: hv: vmbus: Convert acpi_device to more generic platform_device")
Reviewed-by: Naman Jain <namjain@linux.microsoft.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/vmbus_drv.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 1dc371eb53400..5b55a44c3dd96 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2545,10 +2545,14 @@ EXPORT_SYMBOL_GPL(vmbus_free_mmio);
 #ifdef CONFIG_ACPI
 static int vmbus_acpi_add(struct platform_device *pdev)
 {
+	struct acpi_device *ancestor;
+	struct acpi_device *device;
 	acpi_status result;
 	int ret_val = -ENODEV;
-	struct acpi_device *ancestor;
-	struct acpi_device *device = ACPI_COMPANION(&pdev->dev);
+
+	device = ACPI_COMPANION(&pdev->dev);
+	if (!device)
+		return -ENODEV;
 
 	vmbus_root_device = &device->dev;
 
-- 
2.53.0



