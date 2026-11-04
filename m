Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829607;
	b=F57BKRa0dqGSTV4i7sszYgw+6dq9rZseBm0d5nXS2H3n+Chqb7zmJMgSMmiMMp/5lD6y
	 vtYx/sBXHyBUXi3cWMAmM7HO+4R+Re2gY0cs/MM+kWSS99O3y0AIQcfrWar+M8zxzYswm
	 NDRg4/JrVKDucCOVRbjsnZWLxUao4NaEONAJ5NqeoTXism07EInfwiBPDzq0oN4RInw2b
	 OgLkIZsszGHPctAXjS1kTaAN7ClMq/lfthPyjK6CBCotiD7TQGPXCrcCoCSXT/pd5Tra+
	 EtiSNFKGta60NlVcGsCut57R4TrL2W8NqLo36QybTuIqRliJ872/Cr0KUTBq4fUsoHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829607;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y7ITpCV9ao0YfFrCFV8iebbJAw2Niygh03+Z/g0F7Tc=;
	b=1ozZp0Op+zlGJGX5vAXLSEtW0yPn05SVQBNY/NCF0WuhIc9611ef5buvPErOD6cWzTfz
	 30RdsmEyj282T1hfwa8+FKbNrkuDqE+1rZhEf0R5plS10I1voScIG6bfeIZJhgaAgVPPM
	 k0QeKqHEOWT15nmopkPtFrP75VELHnGwxjQKJJamtLYCktUVNHaW82zigGwqtrpyEoPjm
	 CU2k0diHCCkYzzTipGNbGgMvkfh+TGPJPFoWoU/25be8UL9P3ZnQUU+1beGPDRhffUKeH
	 2RRqYf0MiEIl/dW/LYqavicHN+eaWxehUknMVeyasTmNFoofS5o8ywoxZzG9Bhm6yng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mWkvHECL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8C9606D818;
	Wed,  4 Nov 2026 22:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mWkvHECL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA541F000C1;
	Wed,  4 Nov 2026 22:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829607;
	bh=y7ITpCV9ao0YfFrCFV8iebbJAw2Niygh03+Z/g0F7Tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWkvHECLpw5oRR/xdlBvXuppujUu17RqWLeICuxwMXvKeTUu4B43LL4lYncTF+bcp
	 36x8OfYI/qI7DCuCj4eXIw+sjt1GvR2quQhKqzJ/KxVpWWjV5nJEsk9uXr4TTepf3t
	 IwE9EduNjXYQycx0RfkjxldteJKPttxXru4KUt+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0232/1005] wifi: ath10k: trigger hardware recovery upon rx failures
Date: Wed,  4 Nov 2026 15:59:25 -0500
Message-ID: <20261104211050.343462048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d7e429041065a..e4162d2faae66 100644
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
 
@@ -3313,6 +3311,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 	if (ret < 0) {
 		ath10k_warn(ar, "failed to pop paddr list: %d\n", ret);
 		htt->rx_confused = true;
+		ath10k_core_start_recovery(ar);
 		return -EIO;
 	}
 
@@ -3346,6 +3345,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 			ath10k_warn(ar, "failed to extract amsdu: %d\n", ret);
 			htt->rx_confused = true;
 			__skb_queue_purge(&list);
+			ath10k_core_start_recovery(ar);
 			return -EIO;
 		}
 	}
-- 
2.53.0



