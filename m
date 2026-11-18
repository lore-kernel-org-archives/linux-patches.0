Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021438;
	b=bJhurfUadRLsM76vuGM0C28dr08IV303VihpyfQ98S6/gy9a/fADYChA7NuT4pld2KYK
	 7kxk0dyTcdFI9tOaUGV5TI+76ZMOxNRXzLU+VzJQR0qU1u1XA4nPuMvAP4bLC8OHuRpyp
	 jddA69siiaB1bxyoFat/W16bB6HnX9V8AJCaSsxdpQxUiE6EISZ0XFDWMraswLq8eAdLQ
	 GQeymaSgHPLIiuBPR8oGLxFaTiV4+gZFKVadcvAcArhBysv42to6IKike2ymjUoTi8HQZ
	 43iW8Nqm/aF08cHuChdFyBc0Ti7JtEdiBurbRbNpj/dC7Ortxy60fFootEcpvKASOnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021438;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zt4hI86N1g81je4kT5O7jDldYDMlnydK8ZemDdg9zZw=;
	b=oEhR3DfzsTz14L6N2Kg7PmPkWmZl0UpMftSxhNwpeNX0kxhJZCCbcaj+/RZkCvpJylTO
	 7pX8L0CnZh8RWOTRTRAHlcd24FJ5iCJecQrtjJHBsv38ny1zgOBOat66rASkDRAJzBEFK
	 1DA1kXt/J1uXiK3wDgIq48imeizYEcKJRpjTs7Rpc0yYMTfL/yng2aJzNi5FHvVsBod3M
	 NqTSIMPhTVEpuH8E5oszPs/PIxZhBUZc9xcXM+kkS3jo87fLqPv9NBywwjC1eNWbXEQzL
	 xx4Tb8RaZxE4HMkjAfDoYsitx2c8BWfVYWDWN5m6MUTFq7AMERe5vX3WUfYBCRK4Bag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vR0u3vwN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B294A606A320;
	Wed, 18 Nov 2026 17:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vR0u3vwN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD391F000C5;
	Wed, 18 Nov 2026 17:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021438;
	bh=zt4hI86N1g81je4kT5O7jDldYDMlnydK8ZemDdg9zZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vR0u3vwNnEh59V6bFA8ThvDIg7VBFe4tISWSgaKpPaOZX9gwmRBurUYd1jnIdUwFH
	 FRCAIxyXPY2ccpxzYzu1K6ratAOAwQ+htrs1U+aFnSxBbShj65nwM4tFP2lQcNwa9w
	 HUj3Av4s/Y9JibC1dF4bKhlZ9SqmGGtaKuanDuHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Naman Jain <namjain@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2306/2651] Drivers: hv: vmbus: Check ACPI companion before use
Date: Wed, 18 Nov 2026 15:59:06 +0100
Message-ID: <20261118150408.276241810@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 4692687cdbf3b..28f459679406a 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2571,10 +2571,14 @@ EXPORT_SYMBOL_GPL(vmbus_free_mmio);
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



