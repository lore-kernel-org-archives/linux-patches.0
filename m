Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209171;
	b=MbuTODNInQU1kamXpeOETRLxKsDzIWG47ApWndKrmdwnJBxRGyAjoq1Q+ZT3FPtdEU05
	 ry2Ql7mt9qY3DDnMbstQmcHPbJ+rd6oXTVVSDGZuuDHGzbCFx4V7qqPfvN2lSFAWSVxKh
	 Bh47IGZUWYc+pnlDA0iITuiVauG61cj+pc7hFt62uXBQ+Rni/MsVtVYZ1zVxDsQCbdvlx
	 Ziu1BNH+oQpRNSx9CES1Cx5/eTliPtQ0XtsHebPu0tqVwe3cI0bRonTXaqPzvb4wKpb+l
	 xQHXh0/rtpHDK7ROFwkmM1HduPVpa9vflCcl1wS4WIpyXC1egseJcb6R8S8yWY0THKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FARsiIhQgjFgR+R971hkhPaiydq3d88blwaDXpKlXlE=;
	b=Q6Bui073EP+gtsXcIGQEYTUScbLvbtIMuYFoZfW1MwBrY/9zy3hV/hAr+MiLALaOJoGH
	 t+j4ZD1kVELOQbxfz289oCkQ6q4UPumWVJwIxUBho7gSAzhB3J7lK6fQHfctvodCm/m7c
	 OHASwaEfCPXWEmdZt6VCYxiF0FDHNfbVcSBLDsniuuCb5niiWDJSwmHzo5s8tgKztMILv
	 claOIgyi21JpZZlVV/QmTIsq8/OD89/GKXXcPCnrYq5PQGkKOd5pb6rHSN2pfJDIgQJ1o
	 GIAKJR3unzFfQfw/cGizpD2/1KWIjuUNeK8o88rkj/6YmPSZdySPsRMISh/+KBOvkUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0PIhqj2K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9580606A31D;
	Wed, 28 Oct 2026 17:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0PIhqj2K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173E01F01825;
	Wed, 28 Oct 2026 17:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209170;
	bh=FARsiIhQgjFgR+R971hkhPaiydq3d88blwaDXpKlXlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0PIhqj2KS32Ni6nF8fJioF9HzM4JZ6enCY0VfTqcs15MVhdTm1zdm5NViQmApNyH+
	 IpoESlab2x018B5v/d9vMwvOGlQaXcyh3ccRdVX8wFbYH5NWA571BJUvCN1H705xXn
	 OAP4lBsEcUi0UvxkOiAmPDlJsC8SZE24I1yzCfFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 5.10 334/516] mmc: cavium-thunderx: destroy slot platform devices on remove
Date: Wed, 28 Oct 2026 17:58:06 +0100
Message-ID: <20261028170011.400493671@linuxfoundation.org>
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


