Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032653;
	b=TNoge/AeaYmqT9qDyg5LnrOjtmF0hbcAS1l5PnNXa3xlBH1d+8dm5KotAQaFqxVImBPh
	 89vJf60fgwEkaVRG/bQMGTMaTyShiSSAzjwTYfBI79QFTlS+iaNZTiMIz6KbVJPFrNniI
	 wFmAekil9GEQ2ln0VwpbdbFwYqh3vS14WihT2H4/IAkley5N/53z0jEyf8QdXcF9Sz+Mo
	 g4QBuStFnteVOwLP0bvHZGHW+HbHYIfPcWs+HUaoyxDVyarNndegiUC5Yxpi5Mm0BfgSl
	 PlAMRabpUeMbGk/CAgogs87xbh6rwjl+71d5rJW8py/xvJAKFbY3KaCvW3EbAKsCsew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032653;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lY+PUum8d712+I19c+zV2udFQzPd0UyperQq/XraJ6k=;
	b=1Bm4Bv+5fXK3RSjq1q4uolTIIlSDR+capk/vxqQwojWahMSpPril4JhSBUbD34vnNc+u
	 9QSEJ7S26xVOngMBQurgzFQgl+tFlSajZqGXUd+gPFQNa6QbzECzfyUfp2Jv/OWJsiuSC
	 FAxd3BRGkPWu1kUXjIA2/uTAW5ja069WaanSZW/K/cdgrc3mUwCZhN2Y0AtHdSCyYAM0Q
	 EeKJG2VTXkcE/aOxBp6lweNbi45d50e37fTIJf9K8tMQuXGgl6yX8EqCBkqnRMvFuUuWp
	 vQFjnAwit3mTozvDBXZgO3cqtzWuyq7vke1YuimhUX4MZiGeJSXBDQcPVv7P0McQXwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jK46J32c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE9E606A331;
	Wed, 18 Nov 2026 20:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jK46J32c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC4A1F000C4;
	Wed, 18 Nov 2026 20:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032653;
	bh=lY+PUum8d712+I19c+zV2udFQzPd0UyperQq/XraJ6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jK46J32cUQeLn6daOxEJ27B5xufNh36TIbg1pcrMGvU+DANYoaaNxLY85lfhzsbGW
	 ekwxOgW14pgwGes7N7tZRe6tE7nDZ14LTB45lbDKlIB1rD/GKs2ZU6tXy3vBMl/C9X
	 NILwljcTnXi9grlQ/UI8hNcZDI8KWHCyMYdZOHrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1488/1756] Drivers: hv: vmbus: Check ACPI companion before use
Date: Wed, 18 Nov 2026 16:00:15 +0100
Message-ID: <20261118150108.187175666@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 153633bda1426..047831297a0ce 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2459,10 +2459,14 @@ EXPORT_SYMBOL_GPL(vmbus_free_mmio);
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
 
 	hv_dev = &device->dev;
 
-- 
2.53.0



