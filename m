Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826813;
	b=Ntaq6Wpg+OXX9BcEOkFR31JEmnng+iOBAXMDajgEi82qUHZu2cJ2k85bPWYEUZI7urZB
	 sPk/LfyYfkPzkcMObVMapDVYe8wSE93KhItEY7IjBAwnmCsVRH7AeCF95ypbVIVSxsWeA
	 V9/UL5PpSevcBVcWTeRU3/NRSNXK3DIl37gQCDh4cch3RjUS98r8rKfnteWwHuWFWIXYA
	 m0UeOBJujXg6jEY0HJz0GKXRB4o4ZES2KoWe7Ciw/s6ogLEUZG5pGlCBHalahGa+anktQ
	 fF/lGCEvQdQmgnVQLuxHV5kD6iDCWuT21oUDHJ8JBJ3JsCfAfnYFoUHpdTJ/28ab1Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w8SWHBAhwRoLoLj+B34cMtMxkwcJBhNsVYMv6fWh9vw=;
	b=iZNHola8ECDfp0ZGlqutpZu7odzUIHuPQTIWW05ebFxNKJ07YRpjP5kSzddN8nUZl5CF
	 pvuVIpft6yyNyEKFgGIiUruKXlF0PAz1QIejmtKNmChhk/ODO7BtU4+Pt30tuRtCo9BFU
	 tBHXBLy5HxgCSXXo0uGCae8UObdH18+rQIbG1N7cCQ7l2YE+k9Lg+KIWDc1jevsmfuwHq
	 8nyp8xedNVEpPUugzthFMON1UNs2bZFzEpGBTA5ubzv+gu7hzCe0oLKycowJsRDsyVNIc
	 pnNQVVprcPp64y6xCxZHuaf0ycB8dfcdw6oFX4jTEJi/EWQ8sdSJOzXYvBwy934lxxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lpzt6OtZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4031606A338;
	Wed,  4 Nov 2026 21:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lpzt6OtZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993561F00919;
	Wed,  4 Nov 2026 21:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826812;
	bh=w8SWHBAhwRoLoLj+B34cMtMxkwcJBhNsVYMv6fWh9vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lpzt6OtZqECsyfu1Zo5YFI5yqHUTK4xAUYlIcr80eUDIddLVk+hOmQQcNI5uzlV7G
	 9iy2ESOffCOp4Ot067g8HgOxTuYaN3/laqb8lGSt+bo7YQfLYKFVDB1I2FGVHfXaFO
	 1voDz616E2LQO4B/dBZ1dGVeEdHdkMjJNjA1Kemc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>,
	Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 015/547] wifi: ath12k: Increase RXDMA buffer ring size for default memory profile
Date: Wed,  4 Nov 2026 16:03:19 -0500
Message-ID: <20261104211038.811358755@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>

[ Upstream commit 15f7603b69a83a0acc7fcc8992ecbea6110f9424 ]

The default RXDMA buffer ring size of 4096 entries can become a
bottleneck under high RX traffic load, resulting in reduced receive
throughput due to limited buffer availability.

Increase the RXDMA buffer ring size to 8192 entries for the default
memory profile to provide additional RX buffering and improve RX packet
processing efficiency.

This increases memory consumption by approximately 9-10 MiB and improves
RX throughput by ~20% with the default memory profile
(ATH12K_QMI_MEMORY_MODE_DEFAULT).

Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00074-QCACOLSWPL_V1_TO_SILICONZ-1

Signed-off-by: Pavankumar Nandeshwar <pavankumar.nandeshwar@oss.qualcomm.com>
Signed-off-by: Aaradhana Sahu <aaradhana.sahu@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Link: https://patch.msgid.link/20261007-mpp_ws-v1-2-739b1fb87d24@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/core.c b/drivers/net/wireless/ath/ath12k/core.c
index a4e4abfb46e60..b25202effb002 100644
--- a/drivers/net/wireless/ath/ath12k/core.c
+++ b/drivers/net/wireless/ath/ath12k/core.c
@@ -54,7 +54,7 @@ ath12k_mem_profile_based_param ath12k_mem_profile_based_param[] = {
 			.num_pool_tx_desc = 32768,
 			.rx_desc_count = 12288,
 			.rx_release_ring_size = 16384,
-			.rxdma_buf_ring_size = 4096,
+			.rxdma_buf_ring_size = 8192,
 		},
 	},
 [ATH12K_QMI_MEMORY_MODE_LOW_512_M] = {
-- 
2.53.0



