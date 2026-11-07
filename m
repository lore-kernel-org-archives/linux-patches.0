Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060791;
	b=1IsrdbAxuiG1xXksHSdV/WOuJrbe/RNe9f+98Eg0+L2ZfLQeplZskbNPPGi31f8KoVab
	 tV295UDzUA/N6XdmrXicSg783USaztWwaTYhn/GfEYqF4HjvZ2UT5RFXZmHlxD0zfSauD
	 FPPsbzlE8zrKzC6Cj6iUUWroCfbaIMhYIrKD/B0Nt9AI3M9BqA0bENdz2wl3zUj7CWULg
	 qIeWCXieGH4b79nMDsBptnsWcDS2H6MKmgTeL99RoSacV9dxwuHRZ6vQTIRqJb8PrKgmJ
	 yu3KBx+NuurQGl5oivfJwtjFRPx1w4YWlXOlkn8+asTe10ODu1iOT7zFygnmgyyPPQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=987Cph4dJFaRDp/uDXKMCVRzAHX/13bchC3UMZoAiqE=;
	b=Z7QK9kiItf4q3vOsUuW9GcaohskkdXjZKM9uWuDwTl4tuJ85uMa67UD02fNqz8FxNvKu
	 ZHcsfObjSwcF8pPQqs4r9Q0Z8a7L72ezsHe/eWpfHRRWBJzVqvF7aBxaO6cVt6rcZsUO0
	 k6U8YpYhADWyikDod2crV7x0624yFML9wtCR35BvgbTIEsEGAW5jexV4OBmY65h1GFBPE
	 KcY1YX/6Kb93QR0VNKr8rXQmIuFFSSF0IjF2AWAL7hTteYB4mE/9PstSl789yaxDTawrs
	 ZQdMY86HJFzm/6p+AwVW+Orr+7P85+sqvlG3aB5mRw/BTsZf3fiskWaHu0iup+RiiFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SeeyrUj3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A055606A332;
	Sat,  7 Nov 2026 14:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SeeyrUj3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378D61F0089F;
	Sat,  7 Nov 2026 14:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060791;
	bh=987Cph4dJFaRDp/uDXKMCVRzAHX/13bchC3UMZoAiqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SeeyrUj3uWk6ckqrDLM++9j6BzaC8UbTengkGhReSXqdKDfi1TLyrwUU/3xybheTR
	 s0z2UqB2ADOIaa5zRIDzRHm45KcXKLsUSGPMOk7lS5hK8h0QqazTQsv0ReBXQBC3ZA
	 l6RMtv1wzE8nZq778qnq/bUbPx5DGDQsqgybluys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0194/1536] wifi: ath10k: trigger hardware recovery upon rx failures
Date: Sat,  7 Nov 2026 08:36:50 -0500
Message-ID: <20261107135003.108590379@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 42b75961cb962..f529195cebd4f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2344,10 +2344,8 @@ static int ath10k_htt_rx_handle_amsdu(struct ath10k_htt *htt)
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
 
@@ -3312,6 +3310,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 	if (ret < 0) {
 		ath10k_warn(ar, "failed to pop paddr list: %d\n", ret);
 		htt->rx_confused = true;
+		ath10k_core_start_recovery(ar);
 		return -EIO;
 	}
 
@@ -3345,6 +3344,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 			ath10k_warn(ar, "failed to extract amsdu: %d\n", ret);
 			htt->rx_confused = true;
 			__skb_queue_purge(&list);
+			ath10k_core_start_recovery(ar);
 			return -EIO;
 		}
 	}
-- 
2.53.0



