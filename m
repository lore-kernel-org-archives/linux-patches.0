Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033982;
	b=YUOEH4S4VpsdCgu5CWZSiSf+0WC6R4GHrQk0ar3zUrOYOAGovxf1BbYcPb+sVelKx2j3
	 B2PA2cQPxkirhf4ro+GPZ5axjyMZbo/QiHfG0AvpqNOSDE3THCUCIigE28ORgrubllBQC
	 y1UVs1NqYTtz/iWoTYh1nBGXIxPB59Nuu+IZFlTGHh/cDY6FGW/erP1ipvvDN5uMKPYFn
	 p6wl21VXIPuZl7D9Q1LECeN197lcRV11v3ISm9JDj0YlOcgttPuC44r2d7dn28kjPd2v0
	 X/2O11iUmevcRMYPZg6d1olmnwVSkm8+conqIO2rdBPrmuXHeTR33ElqIyV32GjC2cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KdpuPcdiALfW32MkSUywJiw8s7kzmwUjErNIBWptpug=;
	b=VIbrRmrtRmLx0DT8xYjILgtKERyYBZpImzImpOc2SMSHoAs2ra//mywveLx5mzss49cR
	 C1P/nugF5LpheS63/t9Xpe/VcdgK1jIVnC57F0ijCeyekFkKAEwyztbWRSzUjtqpz8iMZ
	 XtbYZVwGBTjEmdBlRELf74MTbRnoM4TOzJZ2mAEG8GCyGOi1kiYitIXs5RzHorBXIj1rs
	 hQ7zzFW23PAkfqOX8ZTZRA58r8NmJ/1yYBikf1Xhqt1BapvU5K3KWz6y6CWlff0hLx0/8
	 d2u4tOS+SpVfuAhFMG2svkVxJ/VeivOutQLpOFtZwabKVm5CzdyKkL7fetgsGHF/jxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VO8Bne3L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0773606A338;
	Wed, 18 Nov 2026 20:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VO8Bne3L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5C91F000C6;
	Wed, 18 Nov 2026 20:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033982;
	bh=KdpuPcdiALfW32MkSUywJiw8s7kzmwUjErNIBWptpug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VO8Bne3LsvU/M/2cpJfek3T63wAVZy02OIM8CMssV3a/OPQK0Dv9cNXIeGcH8R5Bz
	 3LLfI/vTz1x5gvTWWoYWJDwWRvVYc0rGMBaaGTTIxX+Dctps1ExZtqFYKdFv83w6VU
	 QG+j2+PtIdFOQC4J6GMoausZBR+62QLE8JYhVUBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0167/3318] wifi: ath10k: trigger hardware recovery upon rx failures
Date: Wed, 18 Nov 2026 15:13:09 +0100
Message-ID: <20261118150319.632360254@linuxfoundation.org>
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
index 51855f23ea266..2b9bdbc24eadf 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2341,10 +2341,8 @@ static int ath10k_htt_rx_handle_amsdu(struct ath10k_htt *htt)
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
 
@@ -3310,6 +3308,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 	if (ret < 0) {
 		ath10k_warn(ar, "failed to pop paddr list: %d\n", ret);
 		htt->rx_confused = true;
+		ath10k_core_start_recovery(ar);
 		return -EIO;
 	}
 
@@ -3343,6 +3342,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 			ath10k_warn(ar, "failed to extract amsdu: %d\n", ret);
 			htt->rx_confused = true;
 			__skb_queue_purge(&list);
+			ath10k_core_start_recovery(ar);
 			return -EIO;
 		}
 	}
-- 
2.53.0



