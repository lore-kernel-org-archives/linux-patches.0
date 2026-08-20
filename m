Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B64247D925;
	Thu, 20 Aug 2026 16:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243734; cv=none; b=czHaFIzk8jvKnhYY2p/7kZ7d+MegaQuh5wA1rHwXPSFcglzTR3T3Cyyd/Bz/5lOimCBpTU5+mo6f0uf8C5pdO9L3+mSzXq+9SwnHqDsycPAoqVhD4CVjtIQ7ekGABcJH5M3qf3EHy8htawGGgvwzVMPaYiILT/sDscilTA+/knk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243734; c=relaxed/simple;
	bh=V/NJb35MGtzMh6U9i2g9DYD1zkak5ikh7a/gD03P3MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orL0/KkpI8Z4M24iu7P8HoIYLyJHXqSIfMwx+8/kJvSuup7/wht0J9YayhvQbY7luTQXj6AlR3p4KUyEbrwSUhvKXI4rdq9j9IMsp54FtcuIgj6zewTM89gbG06eN+D+kIMrSejuhflemRs1ws6Y+KXwhMGF3T0dxId0n/G8rhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J6AwTblx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J6AwTblx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599481F000E9;
	Thu, 20 Aug 2026 16:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243732;
	bh=kDnF14K+xPcjeXJ+GWcueqIGGdAMJYuleO0YsTGK1/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J6AwTblxnyS/RZIQ+Z7nj2H8on+/Za+r2+fhlmNB+P2XhYQvY02N4o0Z0LJocGeY0
	 ncCI0YruuR+Xh0CywaNKo6OgiW1xdEbt/Zj7XD4necb93iFMdSGZW+IdX+tfIeiULr
	 PI/B5eNODb4daklJeVGbv+8ZdY0ubYT9JB3JFadg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 195/272] wifi: brcmfmac: fix 43752 SDIO FWVID incorrectly labelled as Cypress (CYW)
Date: Thu, 20 Aug 2026 16:56:19 +0200
Message-ID: <20260820145237.320607558@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>

[ Upstream commit 74e2ef72bd4b25ce21c8f309d4f5b91b5df9ff5b ]

Cypress(Infineon) is not the vendor for this 43752 SDIO WLAN chip, and so
has not officially released any firmware binary for it. It is incorrect to
maintain this WLAN chip with firmware vendor ID as "CYW". So relabel the
chip's firmware Vendor ID as "WCC" as suggested by the maintainer.

Fixes: d2587c57ffd8 ("brcmfmac: add 43752 SDIO ids and initialization")
Fixes: f74f1ec22dc2 ("wifi: brcmfmac: add support for Cypress firmware api")
Signed-off-by: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20250724101136.6691-1-gokulkumar.sivakumar@infineon.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Stable-dep-of: 29ab31f3f271 ("wifi: brcmfmac: set F2 blocksize to 256 for BCM43752")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c |    2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   |    2 +-
 include/linux/mmc/sdio_ids.h                              |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -989,9 +989,9 @@ static const struct sdio_device_id brcmf
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4354),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4356),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_4359),
+	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_43752),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_4373),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_43012),
-	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_43752),
 	BRCMF_SDIO_DEVICE(SDIO_DEVICE_ID_BROADCOM_CYPRESS_89359),
 	{ /* end: all zeroes */ }
 };
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4270,8 +4270,8 @@ static void brcmf_sdio_firmware_callback
 				   bus->hostintmask, NULL);
 
 		switch (sdiod->func1->device) {
+		case SDIO_DEVICE_ID_BROADCOM_43752:
 		case SDIO_DEVICE_ID_BROADCOM_CYPRESS_4373:
-		case SDIO_DEVICE_ID_BROADCOM_CYPRESS_43752:
 			brcmf_dbg(INFO, "set F2 watermark to 0x%x*4 bytes\n",
 				  CY_4373_F2_WATERMARK);
 			brcmf_sdiod_writeb(sdiod, SBSDIO_WATERMARK,
--- a/include/linux/mmc/sdio_ids.h
+++ b/include/linux/mmc/sdio_ids.h
@@ -75,7 +75,7 @@
 #define SDIO_DEVICE_ID_BROADCOM_43364		0xa9a4
 #define SDIO_DEVICE_ID_BROADCOM_43430		0xa9a6
 #define SDIO_DEVICE_ID_BROADCOM_43455		0xa9bf
-#define SDIO_DEVICE_ID_BROADCOM_CYPRESS_43752	0xaae8
+#define SDIO_DEVICE_ID_BROADCOM_43752		0xaae8
 
 #define SDIO_VENDOR_ID_MARVELL			0x02df
 #define SDIO_DEVICE_ID_MARVELL_LIBERTAS		0x9103


