Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024406;
	b=gmGFdd5I508iIWelQ90uRRgYmiMNVuXQ8sREafvXtK6rACSKb+yZlXWHE8fpDNTowQ3j
	 pbabqLhBYA5efaCW+LorKWEKd3HxnC6uhIYITLQiCemYx1BaO/tpUm554QAVkOEKdsQ/p
	 IiGDot7V9BzUr1RB5zpAZhkePpukKxSbgJ6d64FeYTCauDUCbXZPL/vgusrtCYDQ+1vKz
	 GpHfki7D5d63jIkZyuuaNAHzzdHGuDWkWT/kZVRg7uqSeQ17r3YXQpAzOtLkcIRFZD/6f
	 AGo9Zn8uWcqW0CxSn9ab/JTSyUhNiDQVApMaowvC8tYLZZB/lI4xjxy+t7Jpt1a9N4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a7iD47orujyatOtgPEZK3crvIf+N3QA3F1MGqcW5mD4=;
	b=oDb8qXl94ZvyoxSlippjEwzkpw1gH2mVonOQaLkOz52zUCwDo5n5x6jLR+S9PW7pu+kx
	 zLYKAffcluEoSYCn+jz3EFnekUcbhTsWDlNsjvd1y/JPq3s9GEBV9uj7Rrgrx260qKtZC
	 5+JdY+z0t2SUQDjDWNtpQenW6EmrjYXEJWpG5cm2WUO0GdOM6Zaez0CLEo8DIrnJoyPhy
	 8iZ4JyS1sn8QdqVlzgtd4eri7uaB+qED8ogGH0BK5JCOyNWzYfLesuCWHqduBfxyxadpe
	 MmNGnLMJCAMPMVhPNIgZcaiTeJTXyAE6jV5RSZQcZnIbS/hC1M+ajLp3EkhPcJDJZIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=phhvpNvc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CF0B606A320;
	Wed, 18 Nov 2026 17:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=phhvpNvc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738111F000C4;
	Wed, 18 Nov 2026 17:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024406;
	bh=a7iD47orujyatOtgPEZK3crvIf+N3QA3F1MGqcW5mD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=phhvpNvc10wCxce+Kn6RRWTsrMe0LIa0nkILF0+nWwFTUpaTLJmmXrIznhYW9HXO4
	 6PlRVHAC+WHygRwiyJeL7cjJF8y+TPu8iy6zElBbutOPFK+6Sxnoj2rPbO8nNvDiSi
	 eFcaiYRcJ9SM0wlJ58xIttTh36il8r41ohjJfdRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	jiawen <1298662399@qq.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0714/2151] spi: rockchip-sfc: disable runtime PM in remove
Date: Wed, 18 Nov 2026 15:40:49 +0100
Message-ID: <20261118150147.889437561@linuxfoundation.org>
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
index 8acf955636977..4ad845cf70670 100644
--- a/drivers/spi/spi-rockchip-sfc.c
+++ b/drivers/spi/spi-rockchip-sfc.c
@@ -744,6 +744,11 @@ static void rockchip_sfc_remove(struct platform_device *pdev)
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



