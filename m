Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039223;
	b=gMELyTYSd+YpCksuoDZtmEb0BeBhDpEcKJxJjUmoSE1QTiwcONI0OZpteWL6H+f8YZKu
	 LLRxcjyKMhHeTS3WPCz6eZeYgZSntECIDY1B1C4AfjfUsLgpiSXrM3eUJ69Dl1dW6azwj
	 SGjaT2H+0OWG+iQ4UV//kTpIEjuIyUvz/UIpUBpPGFFhntQZ84NGwVmkiV0DSY8edzIis
	 JYeNLz9NkUmFrRHaRwHuhP0a7ottP+qk3xXzXojolfrJjUp0VPcFXJiFAzjd2+4htBTH3
	 mnhEMOb6+iiIt2vn7/Q1fQEw77L8QpfsAaMv+R9JPhnAP5DRPme1OLvrNkzBz4diBmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o7xQGuZxBIpPqcMwvpFAJDZ/FcEvBpcZ3J3pUBmD9YM=;
	b=svEGj3W6x8hL6YYiqXzLzpwQYn5CrZgCedlv1eK57nWJ20PNFrNIAM08lCgj2rf/i2cg
	 cNQLGAh77LmIBVpGsbtO5JyPFl+9Ytj/YfY4Yea73jjMSLYjLZF0/NbYP/mgVSgsnro1Z
	 b1iynNtU8aFx3uxJQXuWUpBdM9Xs/MlbYN+Dgaq5HRDyoRkgQpH9mYiBoWdd+ubqVZkt4
	 ZVB1gY33iGeNdghIqenMid+Cd95ynnZ4AuOCNAfiPZRrehMkM+Bp28P+YdsSycOwlcrIa
	 SEGaREXMjScIdL2ZuTn1tLq0Z2TBNKweFECgCASNUsf3vlOmkAPr6ITSnH1XkHK5FDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u37niHJe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE17E606A32A;
	Wed, 18 Nov 2026 22:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u37niHJe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E751F000C5;
	Wed, 18 Nov 2026 22:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039222;
	bh=o7xQGuZxBIpPqcMwvpFAJDZ/FcEvBpcZ3J3pUBmD9YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u37niHJeRsJfdS2SolGmzJHrWsv7EZc4TMCCul8/Jq+4wq1RozzP8T42tzUvH3Ro/
	 uS2bPruvnSwoxrD1cbV2u320XIIUeAqqZovPuk+mLtzKSwuxTy2ToXRao2Xdbq3b89
	 Y6XfqKiIdvQo8zjENSc2V3xOoO871w+ehlAmrd08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2024/3318] staging: rtl8723bs: change remaining printk to proper api
Date: Wed, 18 Nov 2026 15:44:06 +0100
Message-ID: <20261118150422.763740278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>

[ Upstream commit e139445ccbe4d902fce1dce517cd3b63f5b68eb8 ]

As part of TODO file for future work, use dyn debug api for
remaining printk statements.

Signed-off-by: Rodrigo Gobbi <rodrigo.gobbi.7@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20241029221544.112800-1-rodrigo.gobbi.7@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: baa84b1bb164 ("staging: rtl8723bs: disable SDIO function on block size failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c     |  6 +++---
 drivers/staging/rtl8723bs/hal/hal_com.c           |  7 +++----
 drivers/staging/rtl8723bs/hal/rtl8723b_hal_init.c | 12 ++++++++----
 drivers/staging/rtl8723bs/os_dep/sdio_intf.c      |  2 +-
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
index 9125b6fed82bc..0d37e78431758 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
@@ -1886,10 +1886,10 @@ unsigned int OnAction_sa_query(struct adapter *padapter, union recv_frame *precv
 	if (0) {
 		int pp;
 
-		printk("pattrib->pktlen = %d =>", pattrib->pkt_len);
+		netdev_dbg(padapter->pnetdev, "pattrib->pktlen = %d =>", pattrib->pkt_len);
 		for (pp = 0; pp < pattrib->pkt_len; pp++)
-			printk(" %02x ", pframe[pp]);
-		printk("\n");
+			pr_cont(" %02x ", pframe[pp]);
+		pr_cont("\n");
 	}
 
 	return _SUCCESS;
diff --git a/drivers/staging/rtl8723bs/hal/hal_com.c b/drivers/staging/rtl8723bs/hal/hal_com.c
index 8522321024331..7db87df03776e 100644
--- a/drivers/staging/rtl8723bs/hal/hal_com.c
+++ b/drivers/staging/rtl8723bs/hal/hal_com.c
@@ -911,10 +911,9 @@ void rtw_dump_raw_rssi_info(struct adapter *padapter)
 
 	for (rf_path = 0; rf_path < pHalData->NumTotalRFPath; rf_path++) {
 		if (!isCCKrate) {
-			printk(", rx_ofdm_pwr:%d(dBm), rx_ofdm_snr:%d(dB)\n",
-			psample_pkt_rssi->ofdm_pwr[rf_path], psample_pkt_rssi->ofdm_snr[rf_path]);
-		} else {
-			printk("\n");
+			netdev_dbg(padapter->pnetdev, ", rx_ofdm_pwr:%d(dBm), rx_ofdm_snr:%d(dB)\n",
+				   psample_pkt_rssi->ofdm_pwr[rf_path],
+				   psample_pkt_rssi->ofdm_snr[rf_path]);
 		}
 	}
 }
diff --git a/drivers/staging/rtl8723bs/hal/rtl8723b_hal_init.c b/drivers/staging/rtl8723bs/hal/rtl8723b_hal_init.c
index c5219a4a4919d..5222094af2ba5 100644
--- a/drivers/staging/rtl8723bs/hal/rtl8723b_hal_init.c
+++ b/drivers/staging/rtl8723bs/hal/rtl8723b_hal_init.c
@@ -63,7 +63,8 @@ static int _BlockWrite(struct adapter *padapter, void *buffer, u32 buffSize)
 	for (i = 0; i < blockCount_p1; i++) {
 		ret = rtw_write32(padapter, (FW_8723B_START_ADDRESS + i * blockSize_p1), *((u32 *)(bufferPtr + i * blockSize_p1)));
 		if (ret == _FAIL) {
-			printk("====>%s %d i:%d\n", __func__, __LINE__, i);
+			netdev_dbg(padapter->pnetdev, "write failed at %s %d, block:%d\n",
+				   __func__, __LINE__, i);
 			goto exit;
 		}
 	}
@@ -86,7 +87,8 @@ static int _BlockWrite(struct adapter *padapter, void *buffer, u32 buffSize)
 			ret = rtw_write8(padapter, (FW_8723B_START_ADDRESS + offset + i), *(bufferPtr + offset + i));
 
 			if (ret == _FAIL) {
-				printk("====>%s %d i:%d\n", __func__, __LINE__, i);
+				netdev_dbg(padapter->pnetdev, "write failed at %s %d, block:%d\n",
+					   __func__, __LINE__, i);
 				goto exit;
 			}
 		}
@@ -128,7 +130,8 @@ static int _WriteFW(struct adapter *padapter, void *buffer, u32 size)
 		ret = _PageWrite(padapter, page, bufferPtr+offset, MAX_DLFW_PAGE_SIZE);
 
 		if (ret == _FAIL) {
-			printk("====>%s %d\n", __func__, __LINE__);
+			netdev_dbg(padapter->pnetdev, "page write failed at %s %d\n",
+				   __func__, __LINE__);
 			goto exit;
 		}
 	}
@@ -139,7 +142,8 @@ static int _WriteFW(struct adapter *padapter, void *buffer, u32 size)
 		ret = _PageWrite(padapter, page, bufferPtr+offset, remainSize);
 
 		if (ret == _FAIL) {
-			printk("====>%s %d\n", __func__, __LINE__);
+			netdev_dbg(padapter->pnetdev, "remaining page write failed at %s %d\n",
+				   __func__, __LINE__);
 			goto exit;
 		}
 	}
diff --git a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
index 258f68c35dc07..b77f1dcfcc7a9 100644
--- a/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
+++ b/drivers/staging/rtl8723bs/os_dep/sdio_intf.c
@@ -73,7 +73,7 @@ static int sdio_alloc_irq(struct dvobj_priv *dvobj)
 	err = sdio_claim_irq(func, &sd_sync_int_hdl);
 	if (err) {
 		dvobj->drv_dbg.dbg_sdio_alloc_irq_error_cnt++;
-		printk(KERN_CRIT "%s: sdio_claim_irq FAIL(%d)!\n", __func__, err);
+		netdev_crit(dvobj->if1->pnetdev, "%s: sdio_claim_irq FAIL(%d)!\n", __func__, err);
 	} else {
 		dvobj->drv_dbg.dbg_sdio_alloc_irq_cnt++;
 		dvobj->irq_alloc = 1;
-- 
2.53.0



