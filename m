Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3984F1D0164;
	Wed,  2 Oct 2024 13:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876955; cv=none; b=ALySnVR92tZYJQ8HlZLRIpwceh84zAmgHyZYn7iiB4w+1uiXmjDHljSOuqFq4MrRFYamVa6MpHt4h2QSHoaERiF587qrChJMnrrUBZDPL2nSw+yfIdDRjU20KJK7e1mpYRpNMzyHZnxcz4C7GIpJkd0ualsoK0epCObNR9wyntE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876955; c=relaxed/simple;
	bh=VqeC0s6m6VFSI+BTcRNja4gpU93JWLwWjLLzUOrDR8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3+n2S1tRgZSwCmNBc1tKoNhZxitMaYrpPuvjbXVdCNYi3JPaBrUOR1jIDA1ZZyohjrymofRDZYIjdgl1O5NYQA7qebqpBIUbnTe3tN78KgnPjMmsI9LYOqagzZ2KMHmcq1ss4m+kfcLeMpoOulX27ZDKB9Kd6gsEhWgGMe3H1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcs/tY6g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcs/tY6g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61204C4CEC2;
	Wed,  2 Oct 2024 13:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876954;
	bh=VqeC0s6m6VFSI+BTcRNja4gpU93JWLwWjLLzUOrDR8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xcs/tY6gqzsPNXY0GGWpPQovOVZzlvHBV/wAOycS1YPesl2kN6El/6T9sDYsNwTXm
	 MaxNRNxbq/A9JlSaA1tKU1LXOGx9Wk70eDer4uEqEEUGrelkJaFPIbwSPYaIF+e3gA
	 5SFh68zodj7IyB7/UlfoVLwBrmkFEUgTx0PHeN/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.11 616/695] wifi: mt76: mt7996: fix NULL pointer dereference in mt7996_mcu_sta_bfer_he
Date: Wed,  2 Oct 2024 15:00:14 +0200
Message-ID: <20241002125847.101831849@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit f503ae90c7355e8506e68498fe84c1357894cd5b upstream.

Fix the NULL pointer dereference in mt7996_mcu_sta_bfer_he
routine adding an sta interface to the mt7996 driver.

Found by code review.

Cc: stable@vger.kernel.org
Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://patch.msgid.link/20240813081242.3991814-1-make24@iscas.ac.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -1544,6 +1544,9 @@ mt7996_mcu_sta_bfer_he(struct ieee80211_
 	u8 nss_mcs = mt7996_mcu_get_sta_nss(mcs_map);
 	u8 snd_dim, sts;
 
+	if (!vc)
+		return;
+
 	bf->tx_mode = MT_PHY_TYPE_HE_SU;
 
 	mt7996_mcu_sta_sounding_rate(bf);


