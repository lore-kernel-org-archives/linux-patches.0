Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829634;
	b=AtZeD0HeGrFY4s3kS5NhtUqAK4TjWetVu5Ox/nlVfbsgpZxR0bX2Gxu1Qx+Ukh/Ibxt4
	 SBFaI48uM1RO6tov+ba2f6+kZye7N2rWN2j6m3gL0Bz3zNbFbvksCrF3ccRNQdfH6Zjno
	 qP4Hd08q3aK4kqnl6oasT5Xa3DTcuQv695osLjvAGeUYYCjXf42y7NcfwLCkAGk/0Fbtl
	 zz+UwgV5VMGiAPPqBkRThtDK25Bh1y2b5EILLMyvLhp4oohOrYi2u5PgTqmm9tuwr8AJv
	 yCdaIIfstic5p5Jt8HOgX16LPCicqLNo8zW0u+m3fswacHuWYaJxgBt15Ahmfovh/ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829634;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sRNhiJunSaTKYtMmOauBDQkjNIacoHtWUVu8oeVihfQ=;
	b=Jp8b4pgiwwZW2MV2jW5K0XjWzZv02Y6r+btXn5xkztTrKL1VQDEyH0N6kmPApSEpZG7M
	 SECy0nZpvW9YK0lK5x//UGlyXlSy7E96UMQ9EpWbsnZnmprZMaBKyMUYHX4GAQgT7xCZd
	 WwRpF8VkleZtNsPJFP2p1ZsXWsWtf3czaqUZfplvMTCz887UuaxvcndeRJIm6fcY31Xs7
	 PO9BmUftWo9bUHJVHgN26Tqjow45f7hi28iIXe75nxU1uLoHS8WLbhzpzK9q+740F66g/
	 Tt1kpvd/UU906tI467iwfIZaiW5v3XIw6LkTh+h84kROsXT4U0C4CBehTSjmkEjIpVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L1v6UkZS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58A85606AC18;
	Wed,  4 Nov 2026 22:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L1v6UkZS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E748A1F0093A;
	Wed,  4 Nov 2026 22:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829634;
	bh=sRNhiJunSaTKYtMmOauBDQkjNIacoHtWUVu8oeVihfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L1v6UkZSABb1mlyq/8btBzOjN0S3ZaYB8s0e0Fq/ul59Biublbu6ozWiAocOoSqjR
	 iuQUq+WGPEKD0pAPRYcX7KArNTlr0sHujZUBgIiYuRxJ6P8DC7NhFRC4H4t5t4RWeO
	 C3SXcw0Nq4GKqY6iwRJr6fELGyR+yUoG6YY6Hkck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0220/1005] power: reset: piix4-poweroff: add missing MODULE_DEVICE_TABLE()
Date: Wed,  4 Nov 2026 15:59:13 -0500
Message-ID: <20261104211049.979139550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit ffefc5d9a052f67bc87b57d1107fd7cc1fa1a3d4 ]

The driver has a match table for the pci bus wired into its driver
structure, but the table is not exported with MODULE_DEVICE_TABLE().

Add the missing MODULE_DEVICE_TABLE() entry so module alias information
is generated for automatic module loading.

This is a source-level fix.  It does not claim dynamic hardware
reproduction; the evidence is the driver-owned match table, its use by
the driver registration structure, and the missing module alias
publication.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260704152336.51384-1-pengpeng@iscas.ac.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/piix4-poweroff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/reset/piix4-poweroff.c b/drivers/power/reset/piix4-poweroff.c
index e6822c0210000..1a6f3d22d2974 100644
--- a/drivers/power/reset/piix4-poweroff.c
+++ b/drivers/power/reset/piix4-poweroff.c
@@ -96,6 +96,7 @@ static const struct pci_device_id piix4_poweroff_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82371AB_3) },
 	{ 0 },
 };
+MODULE_DEVICE_TABLE(pci, piix4_poweroff_ids);
 
 static struct pci_driver piix4_poweroff_driver = {
 	.name		= "piix4-poweroff",
-- 
2.53.0



