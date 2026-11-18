Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017261;
	b=M30xpMVBrgSm3Qd9H3n48pG8kToXYiSYjCXaqUzTrgVa/qyt4hkODWPvoTk3+nkabXck
	 QTREP1NQoNf+WFSg1RNKjh4PONZhXLyX2CLxtBjdwPecibdP3//AfLFpX/a+DlGA/RCvu
	 Cxhj/fuzPAYg+14fJfMXxocpOyl1SACysRKtdJIIR0iwpYYKnjoE357qpSMBszIEEqGE8
	 XHg2yGrU4JJs0BvjFPCJY6nYBaFBipRcHK9Mmg3H0Ff9gjdIKnfcr5CJ6GIi6lvcfGWlJ
	 Bo6XMXGosqB28Xd0htHsf7EgNlk9LB9CUcI9qoGnOBDKa/kTgeil9wc94FLupXTeUyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=68fqJL1AYNsU2B+r1ZSrADkBw2+p9tbe+JJ3PLiR9ys=;
	b=FPEO8GpD8RBzjdhEEOPo2B0PZ55y8ZuxlESDtbsxDyIm6YHjZTRG9xe/6B5MQJrhZP9/
	 4zmfPekOuE1EypbU/zbK81w2ET9hCOmYBX8FFi6DwJRTWtJdsCa84wWEz6JctmDRLaTaO
	 0Ah1bQ43dF6oil0V9SncCblnQRwkhjKLjtO0nJnVW/58eKxPS9FsJxtMJQ54M3EU/2ohI
	 oUXPzhxhdqykZsJrv4OH7N9t+x7YXU4GBfas1AgdYOvE8fXOwajOpM6mG/npdeMg96NLS
	 p+SHdD4xrQoj7f3ckIRa7tYDUusCbttXkRzP33x1Iq5tSwUMLqo/Yopvk/D7h6bFQKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ytP79Adu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99120606A32A;
	Wed, 18 Nov 2026 15:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ytP79Adu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE661F000C4;
	Wed, 18 Nov 2026 15:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017261;
	bh=68fqJL1AYNsU2B+r1ZSrADkBw2+p9tbe+JJ3PLiR9ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ytP79AduBaWJ+UX5DX/D+tm9mIZhPczjMpayFM3UpuYJCsg121eVWJFDHZuWBE8/S
	 y0zGU2VIoqrBnPGdSnKIUW2p0CPmo1zQGtg0K2wUXVRwZnDB2pjgzZbjMpXYsQ9KTB
	 omDquigZKBMhHTbFEH09FMeJezXVB3dwvniSqWmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0819/2651] iio: accel: bma220: publish the SPI driver ACPI alias
Date: Wed, 18 Nov 2026 15:34:19 +0100
Message-ID: <20261118150317.379292017@linuxfoundation.org>
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

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit cdc7d3dd101251a6373332726b8d6fad35e83b8a ]

The SPI driver advertises an ACPI match for BMA0220 but does not export
that table. A modular build therefore lacks the ACPI alias used to load
the driver when the device is enumerated through ACPI.

Export the ACPI table. Move the existing SPI export next to its SPI ID
table so each export is adjacent to the table it describes.

The issue was found by our static-analysis tool.

Fixes: bf2a5600a3eb ("iio: accel: Add support for Bosch BMA220")
Assisted-by: LLM
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/bma220_spi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/accel/bma220_spi.c b/drivers/iio/accel/bma220_spi.c
index d6c1087cc3c0f..d7a95289df481 100644
--- a/drivers/iio/accel/bma220_spi.c
+++ b/drivers/iio/accel/bma220_spi.c
@@ -28,12 +28,13 @@ static const struct spi_device_id bma220_spi_id[] = {
 	{ .name = "bma220" },
 	{ }
 };
+MODULE_DEVICE_TABLE(spi, bma220_spi_id);
 
 static const struct acpi_device_id bma220_acpi_id[] = {
 	{ "BMA0220", 0 },
 	{ }
 };
-MODULE_DEVICE_TABLE(spi, bma220_spi_id);
+MODULE_DEVICE_TABLE(acpi, bma220_acpi_id);
 
 static const struct of_device_id bma220_of_spi_match[] = {
 	{ .compatible = "bosch,bma220" },
-- 
2.53.0



