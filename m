Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213303;
	b=frfOniL3LQ6vhE7phJBLxu6qLDthGpjg+DSgKGk6oKEzsf9tF+zjx6u03QELGbP/DiPj
	 gqZ+j++HMSOYcgiQ5JxzNabASrMcShloLg2tRGSPrczXlVAVZetRX7WEw32FP9VRqwIu3
	 6d9fgQdeF7h6z++m12nWyhzRemzatct7w+GB0uUEf5E2be/R7Nj9j940683egM8LTItyu
	 AJsEq7zSmEGFWMF4G0UxfzF+Xy4H3GRxJYHeNNkw89uqAhO2eZkqX39S/qyR1eUomWd/+
	 NM/R7pobWkGyb/ZcN5+MXzlddNIqqlmcHCiT1DS1M6fEwCogpL2LG/6BUgfNArXFZTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KMpuGKJMoZYSOsYOdBI19pkc2/1NuEfQkQL0te3CXug=;
	b=N1ACN0XlL0ahKCkgiyUoL5w1lamjgIOr/nfsK0lhHQJh8lzgbaK7mN+eMOyOcpOqLM34
	 mzlewRa2/SQz93cvB3eL+OrN2rnx3zNGIYHXiO3hLWyaeb4w5tN1b3ErL8Ii3IbydkpFT
	 4tATzkVdeWxB/dEFJu8u6Bsd6JwVKrvOV5YGRC0zhzz50G7xnDl/DIeyZxro6saBKhhlI
	 /70IkRshXkIVrZOk+1xUyq/PRlOEY4bZJtiGStbwITFTIJ6Qf8AJOErEr2JyvC4NwDNwl
	 cry8DV5VtuIO8DLftmbPpX5L/F0bwzNr7zaXaF9a2avpaCdFAoRjEqeh7jeux+UMXtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KGU8MqiK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76EB606A31A;
	Wed, 28 Oct 2026 18:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KGU8MqiK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBA91F01825;
	Wed, 28 Oct 2026 18:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213302;
	bh=KMpuGKJMoZYSOsYOdBI19pkc2/1NuEfQkQL0te3CXug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KGU8MqiKKbqabz4mAL8UfBbQs/K6r0Ddu5ISY4Lyx3THMGO8UgFUOgECmUabw102/
	 41TuvkfoeoXDZ5GmdpZIxQVYw3sysHDjTs9xEqA3DizkqPnSb8Kis1jLebGf42Z1WN
	 aXXqUFJ6C5xUeGL1TWCcnl2scVHXOeibwJwlD7Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.1 0458/1887] mmc: cavium-thunderx: destroy slot platform devices on remove
Date: Wed, 28 Oct 2026 17:42:34 +0100
Message-ID: <20261028170509.654794477@linuxfoundation.org>
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

commit 29ee8cf18a21b02cd0b2e35f741b61cd1fe3e14e upstream.

thunder_mmc_probe() creates host->slot_pdev[i] with
of_platform_device_create(), while thunder_mmc_remove() does not destroy
the child platform devices.

The probe failure path removes each MMC slot and destroys its associated
platform device, but the normal remove path only removes the MMC slot.
As a result, the child platform devices remain registered after the
ThunderX MMC controller is removed.

Destroy each slot platform device during removal after cleaning up the
corresponding MMC slot, matching the probe failure cleanup path. Keep an
extra device reference around of_platform_device_destroy() as done in
the existing error path.

This issue was found by manual code inspection.

Fixes: 166bac38c3c56 ("mmc: cavium: Add MMC PCI driver for ThunderX SOCs")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/cavium-thunderx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/cavium-thunderx.c
+++ b/drivers/mmc/host/cavium-thunderx.c
@@ -173,9 +173,12 @@ static void thunder_mmc_remove(struct pc
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


