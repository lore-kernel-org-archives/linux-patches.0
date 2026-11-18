Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043256;
	b=21kcNYm5YSohUA/PpiBdaf2nplXMGQ//XaBl87dG3YowskRsKQ8BheMhkyKjYTdeMWuN
	 c5rHXYNsr09suMcScsf/egPzgFslGvxdku3qbrmdbyUPY1cKC5xUb7MOEsSMntFNbLMBp
	 7la/ByH7OKJ/rTFerTtkKCC3UwVCXxui1G1gyfvtx4yZukNfB77RZizELiqbSr0Rm7M5R
	 dHfU8Kp1XaPQwHXCW/4AjoR04M1u5wae3SQubpwjEJ/zRbB38KvQA691bHktd/Jcwc8k5
	 x+Rq2SvAxkS5W2IEaa7+Tc9vX3ryHGT0es6ayfL8TCX0D6+dxNMElxM2Y2W2dg+zJ/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043256;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lXwRjaNgxZhfh9YQ5XMs2IvXQ5NJ5GU6dht1AsxpEQ0=;
	b=DRyINxgQHv/4CsOoQ+JlKzOuwkEVJE7BWG+ZLvHNgJERjgeI9LCUMWVkZUlxSEJEpE52
	 2hyko/jNcHCEWHLuDgnX42aDq21k7kex3P25rdfSx0329IU0mTEVbt+JqG2ViQw7+Mtsg
	 k1AEPRbLdq7O9apyl6Loj/IMtdHKqD8DUNd305rfy2rG3j8auvnGJB2m79J+FzRug880y
	 WkG+1UbLhfc0VWPVglI/PSsV4pk6mmK8zZBote+M+TNzFxQTQhBtv3FPnoey7w15060NM
	 NdZ4o05iE73uuNkm1b0Mk6lO+nepxsJxnWzxeYPYlSFY4nAWHJ2NZrbq19pNIq0DlOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stXr0zYK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD71D606A32F;
	Wed, 18 Nov 2026 23:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=stXr0zYK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DAC1F000C4;
	Wed, 18 Nov 2026 23:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043256;
	bh=lXwRjaNgxZhfh9YQ5XMs2IvXQ5NJ5GU6dht1AsxpEQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=stXr0zYKdeKQHv0USI2NIuLtEx5Bt4LM7tZoKXGtCRBFzbDiqRU3M5pKrg7EDJ5xj
	 QUu/TVCFyD+MpGfRD3GTDnDd47T9Ls1gKJQ8pCtdqpL3u6aKlyarmxRXpP96yBQsB7
	 VIU1UuvUxerpW2Vp9Hl3Wj0hOufQ1nvOvziyrKac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0144/2857] wifi: ath10k: trigger hardware recovery upon rx failures
Date: Wed, 18 Nov 2026 15:19:38 +0100
Message-ID: <20261118150206.535162101@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>

[ Upstream commit f78210dd4bea09090b828adc2733cad4b9916306 ]

When an error occurs during RX packet processing (e.g., MSDU done
failure), the driver sets rx_confused and drops all subsequent RX
packets until a Wi-Fi ON/OFF cycle clears the flag. This can leave
the device in a bad state where it cannot process RX data traffic.

Instead of leaving the device in such a state, trigger hardware
recovery so that such an error state can be reset and the device
can function again normally.

Tested-on: WCN3990 hw1.0 WLAN.HL.3.2.2.c10-00754-QCAHLSWMTPL-1
Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1
Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00189

Signed-off-by: Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260710060406.3323260-1-manikanta.pubbisetty@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index e76aab9733208..b4eb6d28ac8e2 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2345,10 +2345,8 @@ static int ath10k_htt_rx_handle_amsdu(struct ath10k_htt *htt)
 	if (ret < 0) {
 		ath10k_warn(ar, "rx ring became corrupted: %d\n", ret);
 		__skb_queue_purge(&amsdu);
-		/* FIXME: It's probably a good idea to reboot the
-		 * device instead of leaving it inoperable.
-		 */
 		htt->rx_confused = true;
+		ath10k_core_start_recovery(ar);
 		return ret;
 	}
 
@@ -3314,6 +3312,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 	if (ret < 0) {
 		ath10k_warn(ar, "failed to pop paddr list: %d\n", ret);
 		htt->rx_confused = true;
+		ath10k_core_start_recovery(ar);
 		return -EIO;
 	}
 
@@ -3347,6 +3346,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 			ath10k_warn(ar, "failed to extract amsdu: %d\n", ret);
 			htt->rx_confused = true;
 			__skb_queue_purge(&list);
+			ath10k_core_start_recovery(ar);
 			return -EIO;
 		}
 	}
-- 
2.53.0



