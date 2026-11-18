Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017238;
	b=GYRHcaC+yYpcHSBSvdsnPZzxb17SXVI8O4pWT9mxXkuukX4RmKrGcl0li2eZDAYWsqVZ
	 vAJZW+aoM197+ljGpDw+lIgyncYA88huoRbpd8CXLSWu1fN19yLIK1GTvOL5aFEZ7XSrV
	 1EM0QA/7yH5wpPkbvo5eLV2NbflG0VkXyc1STlFar0Mx1F6Hf6HIe1gHWKuCMIDuzpif7
	 KGlGMvhNm4mKkGJETufU/SS+bo6RYjkCrtusd/Isqj3cLq+ra1B6H+tXoPM7cSBlEqNt1
	 rlFUyDBQZxHH64qs8EjHefymK5erDn3l3iF5TnYtBE4kdxLkPuM9kOiX9w4BE7+prgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2fZoMLX8NTPvhhCdWiEXouNA2avVmfcZ+wSqKGxlveU=;
	b=tXygxaVkX+7cKvHYjb4MEZYDEeA5AAnH/YH1PiL8fwnjg5sVrSoOjZK3k3f+FXDnUsDC
	 ytzdqArAO58Yb6oZNt8w8dTebj4W6cn7ZPVTY9TO4SYPzvnCZ//3oXyU/rWPOJe9SzUdC
	 LPW8MFBeb7Bgem1v6O+2S/t1T/jxBdPQWx7pQLqfHhvqKbLUqHev/30+V4Bs5qfnLalwl
	 +0+cyRzY7gU118GBTKitqk+d2kI/o1b3qQ1dfK76neR7MPcMqo16M2oj961HzPHao4ShS
	 Ab/Dj/m8eVQZ3gCEsXVu7S2PjvKtWM0hy28hU4G/JgIBwJ7zS4wO6f7t8C/nSs5rn1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9QkulMl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9F6606A336;
	Wed, 18 Nov 2026 15:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9QkulMl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B711F000C5;
	Wed, 18 Nov 2026 15:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017238;
	bh=2fZoMLX8NTPvhhCdWiEXouNA2avVmfcZ+wSqKGxlveU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9QkulMlcYumhjW352IYqVBeAsIJ9sVtz9P67ZYkPoaLGvPKeJAgLHxrCp/rrZbbM
	 XW1gt9LAQwgNm1hALObQGv3aYbta1hgSaZIL41ZlGy3a1z9oM0qyaIyRvtQiWcZUFT
	 aO/74AjRiox0KZgLp0RKsPL+3P4jkqSgezosVUos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jiawen <1298662399@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0812/2651] spi: rockchip-sfc: disable runtime PM in remove
Date: Wed, 18 Nov 2026 15:34:12 +0100
Message-ID: <20261118150317.134158085@linuxfoundation.org>
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

From: Jiawen Liu <1298662399@qq.com>

[ Upstream commit 34e32e9ade58e32daf933974c9b697d066fc5aaa ]

rockchip_sfc_probe enables runtime PM and leaves the device active with
a usage count held by pm_runtime_get_noresume(). The remove callback
only disables the clocks and does not disable runtime PM, leaving the
device in an inconsistent state and leaking the runtime PM reference.
Add the missing runtime PM teardown in rockchip_sfc_remove to balance
the probe's enable and get_noresume calls.

Signed-off-by: jiawen <1298662399@qq.com>
Link: https://patch.msgid.link/tencent_DD16C0EEDFEF4ACAFAB5A23EC8235D462707@qq.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 926f9c44a76f ("spi: rockchip-sfc: skip DMA cleanup in PIO mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rockchip-sfc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/spi/spi-rockchip-sfc.c b/drivers/spi/spi-rockchip-sfc.c
index 662a994da60be..43e91b49bb1dc 100644
--- a/drivers/spi/spi-rockchip-sfc.c
+++ b/drivers/spi/spi-rockchip-sfc.c
@@ -743,6 +743,11 @@ static void rockchip_sfc_remove(struct platform_device *pdev)
 	struct spi_controller *host = sfc->host;
 
 	spi_unregister_controller(host);
+	pm_runtime_get_sync(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
+	pm_runtime_disable(&pdev->dev);
+	pm_runtime_set_suspended(&pdev->dev);
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	dma_unmap_single(&pdev->dev, sfc->dma_buffer, sfc->max_iosize,
 			 DMA_BIDIRECTIONAL);
 	free_pages((unsigned long)sfc->buffer, get_order(sfc->max_iosize));
-- 
2.53.0



