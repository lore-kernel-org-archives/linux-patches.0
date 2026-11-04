Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829714;
	b=BQ7a+DZOnjT3ivWf9U2m2OJVoPq1TeQql6yYcXaakWhvYLiiQ3G6SYppFRR++U1A2DeP
	 N/iBXkrTHjYb4shSiPmOfH68r+G950WutXZD+1pBGN3riP2JuuW9+luufUyzb5dUGIDLA
	 aejZ1YDKh7OZ3i5VqMHDSYis/EdEmony8px+y0hQhhItc3sOv6GH1Xv19ytbOhSAyEZXT
	 rxOVO6FZ4stbuc+SdFIYcqzPZ6pAOD4I0kCdnbz3vdE2xOQ5LXwdCbE8ABPeeKObjHntY
	 GrxEI+gEVYl8Xydy3t8on5kIQpnHBPjbPZ9z0r12Ih/eg0jLtZTAHVM1VyULHDqxdTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=117dhAe+Z7NNrmTESi+DBLy7oGyNF4DtHUzDdRsmxn8=;
	b=cxLMHpgmL05aMlDZRBIRrUqxbfLxjebHRCJaRrO3iOCxTpK6lFn+89zHUFg/GPHJYgVj
	 KYbifIVraFfqurbUAvM1Z28zMCRYcdnUEx8yRxQwp5DOFsk7BzqF5hdoxgGO0+zFIOOKS
	 RgxUmx8MTAihShhVrxDwVCW8OUmIu5XxGk8YIBGhd0Q1veUtb/00cyYgqn6lT3wEudRHb
	 pHcf1zOOajCh6hYk75xQhgDQgv+Tgnf1X6zmLsJyDIrqTqxEfAPDfwJXtQuQhBiDjosJO
	 Mhe2gr7Re+AWnRVkCQ36byVZ6vvMjmDG14Y1cdRic1O1JtRlAUDp1YE7NLcvab9+3Kg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xIIC3ouk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6703A606B2DE;
	Wed,  4 Nov 2026 22:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xIIC3ouk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D2A1F0093A;
	Wed,  4 Nov 2026 22:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829714;
	bh=117dhAe+Z7NNrmTESi+DBLy7oGyNF4DtHUzDdRsmxn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xIIC3oukUCrEZpn+pZQrhRp3Q00aNPPRfPUBO0kAse91gQR+Wt1lt5UDxg30sieaJ
	 +Hu4MT13QABeIpKy5tGhd/x2TVmPabH0sji0W7HP1ZWUhGJx+O6N/HxzrUaQymRLt3
	 yFHEmmuu+FYgst3XEHtTD1kcW53yzofBAqCALaZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	0072a70 <90307219+0072a70@users.noreply.github.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0296/1005] wifi: mt76: mt76x02: report rx FCS errors to mac80211
Date: Wed,  4 Nov 2026 16:00:29 -0500
Message-ID: <20261104211052.204260114@linuxfoundation.org>
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

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit ddae0bcb01e71c1184bb3f526f9622e31dc38f3b ]

When the fcsfail filter is enabled the hardware passes frames with a bad
FCS up to the driver, but mt76x02_mac_process_rx() never checks
MT_RXINFO_CRCERR and hands them to mac80211 without
RX_FLAG_FAILED_FCS_CRC. In monitor mode the radiotap flags byte then
never gets IEEE80211_RADIOTAP_F_BADFCS set and corrupted frames cannot be
told apart from clean ones.

Set RX_FLAG_FAILED_FCS_CRC from the descriptor CRC error bit, matching
mt7603, mt7615, mt7915, mt7921, mt7925 and mt7996.

Reported-by: 0072a70 <90307219+0072a70@users.noreply.github.com>
Closes: https://github.com/morrownr/mt76/issues/38
Tested-by: 0072a70 <90307219+0072a70@users.noreply.github.com>
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260613002544.27750-3-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 06f17da2c0106..17c9782915315 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -792,6 +792,9 @@ int mt76x02_mac_process_rx(struct mt76x02_dev *dev, struct sk_buff *skb,
 	if (rxinfo & MT_RXINFO_L2PAD)
 		pad_len += 2;
 
+	if (rxinfo & MT_RXINFO_CRCERR)
+		status->flag |= RX_FLAG_FAILED_FCS_CRC;
+
 	if (rxinfo & MT_RXINFO_DECRYPT) {
 		status->flag |= RX_FLAG_DECRYPTED;
 		status->flag |= RX_FLAG_MMIC_STRIPPED;
-- 
2.53.0



