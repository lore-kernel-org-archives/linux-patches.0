Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211487;
	b=0S5YgzEUMsz0f6KjGjYwON1qptRe8R/1ejHY5/h5OTRyBwYerCgjdakT0RE2GJuZX3yn
	 OUNeAlxObwK3AZ+a2Lh01QbI0+vnujDxkxQ6Kci+kX43LsrVBQHo46abCqHbeCLP/CVRw
	 0MHB1/eG1Y/ntcJcwCHOuZSSiLJpREo4IUCPmlPpbXyfdcHPfJ3v4SWoaBBmhc7xYA/M+
	 Ojy8pSzpbe9tiikl19innATNgPzpwQMiuLsvgA052y24R6usHRpLdWe4UkbPPQpwlFpHU
	 t/yUBkLFy7BKlCrs4XbjEgmjV3eGD1fU1Smy7UHurLsaRvR+dGi/fJUfKn4mVSHcpQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IUtOYqtbx86czmtp6ftg14LT4k/j0A82K+9oHN6tpqY=;
	b=ABddEOv+gng+DGy/cAOXA3KY/yS+0rfInvitDwilHuPZwbdM3MlXTOkLiiRYAS4EOuwN
	 pNB3Tzx9qxZ+VCMOUFeyI1T2u0LtTe73mXmYVSM8fegBYAm+VZtoo4J/VL9ebMWoYHYqG
	 yI4kCR7d9BTusR0jrC38Wzk6SUJ1B+CbfCxu1xXahuOTwmRnAoNfJSoxjK/afgjI32rY6
	 7cUcszc5qBJPmV+RgjE8QoYnrqZox6MNh1PiAaJCD2HZpxrN6lomGBBCd23aSNaSXLEVf
	 lxoCu5Bm5glWN5RsQAtniLar+DJVanJCk7UJEo0/I8VjSrtAKKFB6m2Yn1raRa/uM3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iCgr8MLW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67711606A31D;
	Wed, 28 Oct 2026 18:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iCgr8MLW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99911F01828;
	Wed, 28 Oct 2026 18:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211487;
	bh=IUtOYqtbx86czmtp6ftg14LT4k/j0A82K+9oHN6tpqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iCgr8MLWiFr3xCgpllGvmhr9COO+o8NafSlYJkTJudKruJJB1nz7a9KPARQiovxeP
	 BUc9OuA/lypKQrLWwmnAFSKXgE6n8hiKcAwdmGsoTmYrH0f/FlFNFrQGi+lNWxNBab
	 0kvoo+TkYgp9PXp2jr6Mi1ZpJsFimSbkmBd20UVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.15 368/571] mmc: cavium-thunderx: destroy slot platform devices on remove
Date: Wed, 28 Oct 2026 17:58:35 +0100
Message-ID: <20261028170016.747109515@linuxfoundation.org>
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


