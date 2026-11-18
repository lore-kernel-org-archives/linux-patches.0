Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057383;
	b=zed1xPiQNIS8Dq5tBOA3vTerqm7TuoT9qdxYwQ5mgaoWAd83I8Y8c7Ju4wJQN9XYcFVp
	 Z/8RW28mbMe3VMUGKtrGi5UweM0MzcvqGRSxCjGKoiXYflq/O+vgc52/AtAUvql92OJEe
	 RJ5+sDOzHDMy6xA3adkLy5+2i3i3sDhe5dm3QFAva5u2xkfD90zV+6enBS8VGsK62x3jg
	 Z79N94NWptYG502QVRI7BhxxCyD1wzNDYwiW8cgmO4ZuwOziNpEErh99X2+N8V0T2PDCY
	 XLovnrPzIvXxagqOocgu3W/SlKNzPBoq+h3DMBnT1YWJdwp0/LBrlArSSkWz6/gQqZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u/RWxLx+i3zjvX8r25CfBpq6+vfwbHqyCyfQjDUxwpE=;
	b=OFn5LdR91aQ0/a+QfwMIpIpWWlnjEhvFLL0R7roX2KVvEldqmwtwCrwA1GRB2M/XUTfZ
	 T+Vr+MZeEbkJI0XzMLRGF/TH209JOm2N2kDtX9uZDTdfDAcV+r5dNeX+dBKQuOYJfJyUL
	 C3p3oL389oNb70K9gbCrPHXmUVYVO2JxrA303RVqrrn3FawLeRdqQ62u2BC4XJiUHE94M
	 oFAzz+aagPcgR4fAcfsd3WzLPwbKEBAyKICjCNd+nOvgH8Ym8gf9XqToQGI4SG4ixhtvQ
	 M6bVltgQQuykdqhFPSTrvb2Yyiqo/iSFzBRYXbI0sieKV0i0K2sxzDJ2Y25PrbsLNSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MMGPFKgC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00BD760A260B;
	Thu, 19 Nov 2026 03:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MMGPFKgC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7981F000C4;
	Thu, 19 Nov 2026 03:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057382;
	bh=u/RWxLx+i3zjvX8r25CfBpq6+vfwbHqyCyfQjDUxwpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMGPFKgCzed9lnZNudRlBrcE6K0XAYgSiavNeSe3N8esPwnjeYMShwaCiA6PW3/WD
	 th5WBzBJ8bcfjRIFxskAvQhRLQlFxzahiSmQOP50TPmq4aM1LatahSmtv1HM0rfcaQ
	 2LDq29NxtBxAbbOSxdzrfn64q8pAP7xVytlCviOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0112/1848] wifi: ath10k: trigger hardware recovery upon rx failures
Date: Wed, 18 Nov 2026 15:35:50 +0100
Message-ID: <20261118145915.690663915@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index 28ec3c5b4d1fc..9218c4c55452b 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2225,10 +2225,8 @@ static int ath10k_htt_rx_handle_amsdu(struct ath10k_htt *htt)
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
 
@@ -3185,6 +3183,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 	if (ret < 0) {
 		ath10k_warn(ar, "failed to pop paddr list: %d\n", ret);
 		htt->rx_confused = true;
+		ath10k_core_start_recovery(ar);
 		return -EIO;
 	}
 
@@ -3218,6 +3217,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 			ath10k_warn(ar, "failed to extract amsdu: %d\n", ret);
 			htt->rx_confused = true;
 			__skb_queue_purge(&list);
+			ath10k_core_start_recovery(ar);
 			return -EIO;
 		}
 	}
-- 
2.53.0



