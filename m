Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051258;
	b=UsP0E1Pvjmp4p9NfR4ImiGoASa36rBd2xStGvsCtgPPWWIqFKncNfjx1B+17/iOk4DXG
	 HcnygdPr89ncMfXLXU1RDhKjfsQHCGcH3yfCFdzITHJd8LoWXnUi2gu/vGDPVWB+UVJXu
	 kJ7sEH6qBvWqpIeZs3Ti32m69aGFUk7YOw6Pk05pqGu5hEtcFCpM276jithDHPJLNN7Da
	 +4FUInlPoCKMoThYkn1NZtzAa1dZe1DgVtUmgDuFMt0QwPSqD6rdmVgLvieMLJmqtXvKT
	 u4+sSj76n6/w489fQ4MTB6ItBVXVWudq3XLxBSB6HihAglgKUVib6eEyCbN/tX/P5EQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gZfv2QXgR0W1BkUZFah2j3GgMBsqZMzo9rn4tvUfSFo=;
	b=RGniPtPMySOf1vSDfJsQFbtv3p+ZGxhP5MiBN/houCIoXuBD8CpnjaK7D5swJQJVp1je
	 Kj19yGRONz06k6jJrj62EfOtyLCOwvxIcLhBoXoIPWeM+DQm0/G83tXcpxwOM6qwUkbki
	 UKuCFBBXllY2BLufbFX+36Espaoxl/2TMiAlIM/3es4M2bgEyOkW45s1Usav0usm5IjNN
	 b3VQs5cfIIxNE7VKOJw5JEIn4pbYAzgbUdhvgmJIVJU1S/jrwfsoBhd79Rdp7cO1XM4Qd
	 EW7z9h/cxZRQ+Sw92qb3rFwRuOC6eCd45LCajdq30QoLuf+ya+F6Btvoiv9LTnvu8Yw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kGA83ckd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C79606A31C;
	Thu, 19 Nov 2026 01:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kGA83ckd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A5D1F000C4;
	Thu, 19 Nov 2026 01:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051258;
	bh=gZfv2QXgR0W1BkUZFah2j3GgMBsqZMzo9rn4tvUfSFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kGA83ckddEF4mkdBDOwloGtwXzJQ0w+8xJqYxT3mbHb+nzogGedXqJhORtKbxUksG
	 4xLVj04DSoq/ZXG4RoFQrCd36HojNg28ce8deoz0Voa2VKkGfOOzMw0vccJnDK/muo
	 SFG9Zhnh4fvVqrq/BpPK977lViB+1bs36kqfIuaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0128/2214] wifi: ath10k: trigger hardware recovery upon rx failures
Date: Wed, 18 Nov 2026 15:30:04 +0100
Message-ID: <20261118150015.348009804@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index adbaeb67eedf1..40d98cd43d8c0 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2223,10 +2223,8 @@ static int ath10k_htt_rx_handle_amsdu(struct ath10k_htt *htt)
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
 
@@ -3183,6 +3181,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 	if (ret < 0) {
 		ath10k_warn(ar, "failed to pop paddr list: %d\n", ret);
 		htt->rx_confused = true;
+		ath10k_core_start_recovery(ar);
 		return -EIO;
 	}
 
@@ -3216,6 +3215,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 			ath10k_warn(ar, "failed to extract amsdu: %d\n", ret);
 			htt->rx_confused = true;
 			__skb_queue_purge(&list);
+			ath10k_core_start_recovery(ar);
 			return -EIO;
 		}
 	}
-- 
2.53.0



