Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335673232;
	Wed,  2 Oct 2024 14:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878838; cv=none; b=eujZElheJwa13/vdYa2FgnGY3mP6pcOYyCGfyV18Njmx9l0B78lppRJ/znq95+E6Es4jKF6DsHYOf3j6B93hE03xlnE7sd9U6Wnrv6ESS5hT01R1SRw/mCaKzSgVN8ND6kghn43IAQw1JcIg2uUTh+qVeM7R+bz/fsCyBWNWuRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878838; c=relaxed/simple;
	bh=smvh3AxK6Ml9D98/tLic3BJ1ftlSpYaTlGuzfLda8Ro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXFaZgDWjKfsGfm00P3SpfUcH6njC4uptfFXPLHMfH0d58wYn7FxdfeAs2Y3Vq4SS32zoTqtkOVSfDc0VzaFf7SbFb8ZwC3ergMgkp+GP+1Mf+p8Qt56frIxqP2Oa3nSDYz356SVEwQJTBDDfgg10AhytIgkGLLuat9UxhaW6Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCdjErx2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCdjErx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE11BC4CEC2;
	Wed,  2 Oct 2024 14:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878838;
	bh=smvh3AxK6Ml9D98/tLic3BJ1ftlSpYaTlGuzfLda8Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCdjErx2p2Gfo3zzRAruD2XU4udxY7KP9H0QiIuNV1RAT1H0pA79fNXqt9FpXxjBR
	 VznoEb9nlUmRWWR87LTuD/F4JirbNeplW3N57XRD0+GGhitEJWD2x1kCgeMwiv/L+2
	 P+0l8z7HeSiH4PbQYvY330GEKP/R53vS3QM0xLZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.10 550/634] wifi: mt76: mt7996: fix NULL pointer dereference in mt7996_mcu_sta_bfer_he
Date: Wed,  2 Oct 2024 15:00:50 +0200
Message-ID: <20241002125832.820127591@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


