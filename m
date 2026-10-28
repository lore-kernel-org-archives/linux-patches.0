Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211456;
	b=kjj+nVpX/jCO1CwZAmVdMQIphvB/SaI3ZweIg+iUxsBPeXFPxoG1aEjD2DWp3hm4u4Ih
	 Lw96DMeVrAU4acfdcG4uwQyIXXadFJpUfJoKHm0FZitUNF/c3ZpEzpPsw0f/8M8ATH4I4
	 5cFKDNGqOXiVo+GArzWuJKIE2yDhjosBRii21Idknnwj2ubauqA8PGal0AMZ0SNZeRd5F
	 /jIcqZRBdC2/frD3OnX8FP11WGN4LRghcGXcQgdEK3ho65N9dJtDye+xUPoJ7UFB43AqO
	 I2bUF2TW7ZibOZTT1XmMU1TbA2UwmQqDiaoCkfK9P/IXxkIostPUcXq7tscE1sZg6yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211456;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=l1NrrT+B2njHeBip697B/XnIyRIPDlAdv8EbKv6rako=;
	b=MlrRYJqolh6HVKilx3obNWY1/OqvUfIsGjeGH5YmcLKA47Jo5WgrzVGu7wXVCpdt4Eh1
	 kxf4/EPKtm0Whto/l/FGWIkSaLrP9elekr+KTpBAAEX5kifsIiHn2PvepewdeX/riEgnj
	 qncK0Kgtm/qUQe3xiq02cAi2xsr5ZUuBG3BXQKzyuKGQ3CEdZQy0MHpeOCEz2Nav+2AiS
	 bn8NHUwL9sBYIBKtZMX2s++rZkHm6FT5l5zCyTELy6l4jx5+OdLleT89+gv6SsBhK8atU
	 2Jpk1nKYWYguzSnRKICZho3f2R2/ila38bGYAQFtPvypdhn3SbE3jvLZh6fKwQZKKqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XQA35deX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEAE606A31E;
	Wed, 28 Oct 2026 18:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XQA35deX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798531F01825;
	Wed, 28 Oct 2026 18:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211456;
	bh=l1NrrT+B2njHeBip697B/XnIyRIPDlAdv8EbKv6rako=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQA35deX3gIO6HNo+2Gg+j6DzAf5WFVyo0SsCzMisWVO35+3l7oinDUuA9FcmwBGW
	 Xgmz1om5kJaKVpmLNUhqpCv6wdoc2gUmB5YK8bdZycMbqFTYu3d3Dt5OfBcXshPe1L
	 pvoolploREsLwk3w+WqabSJKrmeZF9AcWID2AKdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.15 367/571] mmc: cavium-octeon: destroy slot platform devices on remove
Date: Wed, 28 Oct 2026 17:58:34 +0100
Message-ID: <20261028170016.723887241@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


