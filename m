Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209168;
	b=cV6uwagqYi52sXpBCzgLs22Ut6aORcPLcWHfg52UnSvltgUhKxB9VLBUPOPt4FLxeHuH
	 pyKIvKfxje7U/pF1SYxxs7LW14oaplxZ9+LfpEgqekuWmbp4s2EnIZtzT8eCb3P7p0EFQ
	 Nxs3TyMisQ6RU2g/4xYQieUqVFed9svVP7N0Uh5E4lRVbHbN9V0haJpOGYPjfGBcAV4Tm
	 B5El2D05HaE7C1IClBiztR7Gvs/705L/9rjGchuij6fsCgIazuT8GS/2UmYs6CjbbybEZ
	 ivl8St+xh3GGmPJoZh/iW3mbJT4W8LfMulpedL2ox3cVkObb6Ff5yJ7EXtDRlC1f90Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KGRa0X8Nbsx6i/2FJotX7sFgcVCACjwYpu1y+bW1hhk=;
	b=HeWvGy+uA4E1FiXkD5ayOYyDLCuzSoA9FoJg+TEAL3Y2+Ql7x7TSA3mHABFsxxmfJn1P
	 8mu6Yrnc8qN7Db5ZGvSNPcGwfrctUZ1z2YXVB/CN799yLnDVnfJYNRC0VytPrIn+X+Euy
	 RXq939O9oSmmlszod7H5K9DznkBTUTtBHDhMXQdpK3AmvH607fAyg1L40D4a+hxJkqp7j
	 9cKWYgPg51RS3mEDbUKR/lS6MKaF0JBExRjgg5J4RzfeeLwXu3g3tnCQiULIWdY92ampo
	 QJEY22LxkZ+06GrIuwzn0VFjbG8oCTMszN6UloVA94v1zRxQTkZp81GEmcCn1kzHcYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUx+dSSi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD0A606A31C;
	Wed, 28 Oct 2026 17:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUx+dSSi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3795A1F01825;
	Wed, 28 Oct 2026 17:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209167;
	bh=KGRa0X8Nbsx6i/2FJotX7sFgcVCACjwYpu1y+bW1hhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mUx+dSSiaBFb3qtkW2m1i2Lmdd5u5zHzlG5G1en0jCpWeGDch+WT9s3JIv1Q6iA/b
	 4EZVnNt8CYhgH4eNPKo9a0eL/jxOc87kD3dHlHXOAeRau6M2qT2b6MaOvapIqyy63k
	 N7CLcCHTH/ur9F71RCsznH16nyF4qI9IWvLuCKLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.10 333/516] mmc: cavium-octeon: destroy slot platform devices on remove
Date: Wed, 28 Oct 2026 17:58:05 +0100
Message-ID: <20261028170011.376861903@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


