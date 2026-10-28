Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213300;
	b=eddP69g+axq7jJ8zB1GK583nJ8X1A+GMpQWi4xrIPew1tFWdalh/z/mjX57sPXD7bi7i
	 2aen1SZaWIKqovlaxOnHAPf+pWR/JIAcFlp5sPGnLxvAMlamXhyWvRBliP51ytJ+MQ7Up
	 nuFi1EA6NMwT+hg+1RQgp43l4XhzpYo5Hg6CMV0a+1m/DnL1vrWq3TcRDWqc4HnImK3lC
	 jcnXLfoRTcsM9TIFlNyF6NHC9iLH8UlBZbEcnPG+slOQwoJzYOi4i9Xb+Ve+0cHlp9h+7
	 ZAKZaxx8pGrA7oX5obCoat+ZLUhKbUI/01dT02syrl0JhvAKI0F5C2JxIAmAQjUHKlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hSNI82uhBT4XyngXOXW+G99zLZv5lLY5ulUVh6giMec=;
	b=1g/RAWeHhSV71q13abiJTJwlbCu70ZlIQ/iprDr+ESY5fERkloO9s6PGZpeMEYQnzTvM
	 t8KbheCLvsThb4+LZ+jT+xfviDh8+TPG1mAa1bcXEk9sMlkGVZLjxBuWLQ6Ps2H9KO4u5
	 iq/FZNaRQWRWfynltgAScDrwSVwfCA/J7RBUJSC/kirxH5dSvpk0vEzEa/taoM8qSR731
	 IP0O9fmUUoT3Pmaeeiq7C1Wph+62KmTzYWbkvxm9k/JBQVUdJxlLmTM62uUI2YrPdofqx
	 uJ2R6jX7OIvZm1iVEpYJzvAuOGb2Q+hygc6lch9EjJ5GD/j2Nuv8d/kzamqfXOW04cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d1N1oohI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180F3606A31A;
	Wed, 28 Oct 2026 18:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d1N1oohI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6685B1F01825;
	Wed, 28 Oct 2026 18:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213299;
	bh=hSNI82uhBT4XyngXOXW+G99zLZv5lLY5ulUVh6giMec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d1N1oohIV8gGMhy6e/wRnvmQxJBMQeVhm7pruDGy50rcBH2rLSMysuhFMw5A9Apf1
	 gORzSHadPgGK8rGYnUFEjBsq+TwQK4LQNFaYTwLZIf7N3pcho7KJwi4pmhc+dmVO8e
	 gCdUw84gUu339QqbXxXJH1SBmQxNEX4Bql3u0ooc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.1 0457/1887] mmc: cavium-octeon: destroy slot platform devices on remove
Date: Wed, 28 Oct 2026 17:42:33 +0100
Message-ID: <20261028170509.631465062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 0f4d4424fc1d651ec3fa63a0a8060ba9087eb0ec upstream.

octeon_mmc_probe() creates host->slot_pdev[i] with
of_platform_device_create(), while octeon_mmc_remove() does not destroy
the child platform devices.

The probe failure path removes each MMC slot and destroys its associated
platform device, but the normal remove path only removes the MMC slot.
As a result, the child platform devices remain registered after the
Octeon MMC controller is removed.

Destroy each slot platform device during removal after cleaning up the
corresponding MMC slot, matching the probe failure cleanup path.

This issue was found by manual code inspection.

Fixes: 01d95843335c ("mmc: cavium: Add MMC support for Octeon SOCs.")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/cavium-octeon.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/cavium-octeon.c
+++ b/drivers/mmc/host/cavium-octeon.c
@@ -300,9 +300,12 @@ static int octeon_mmc_remove(struct plat
 	u64 dma_cfg;
 	int i;
 
-	for (i = 0; i < CAVIUM_MAX_MMC; i++)
+	for (i = 0; i < CAVIUM_MAX_MMC; i++) {
 		if (host->slot[i])
 			cvm_mmc_of_slot_remove(host->slot[i]);
+		if (host->slot_pdev[i])
+			of_platform_device_destroy(&host->slot_pdev[i]->dev, NULL);
+	}
 
 	dma_cfg = readq(host->dma_base + MIO_EMM_DMA_CFG(host));
 	dma_cfg &= ~MIO_EMM_DMA_CFG_EN;


