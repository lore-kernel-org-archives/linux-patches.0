Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AC7188CC1;
	Tue, 10 Sep 2024 10:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962860; cv=none; b=bBKZUQgEGyu+rgPdFNpZcsYt+FwA2r6m+v3X+bV4eIz9YgdyAEOTgib07wDL42mGYrXwADj58SV2xj/GXgCudpJdHc7VpA7ncUV/46aTx29hNjiVTfWHNIKD2J+AUm8h/HHAk41JiNwNDxk9o7OVjGWB7Zz/NutkhZ1eqyQmxsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962860; c=relaxed/simple;
	bh=FoCWUZPMU8wbpWcOvW5tjY7yPDZirI6IUPmq7oxo8Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aeHLDx+4FOboXMX3ufhQY45oHaH/ayDhg/Sl876ir7m8+14VUmhDR8mvZwZatj3S38tvTnTOUj5UpLL1DYJQSyL47B55bqrjdWDpBJOT5lR6EiDmElwLcSPnUUkRUO4PCC8zlbcIH0TqRDZENpOZIxSLXS7cQO0EUR3Jcx4LRo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rG3ftGU+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rG3ftGU+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B625C4CEC3;
	Tue, 10 Sep 2024 10:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962860;
	bh=FoCWUZPMU8wbpWcOvW5tjY7yPDZirI6IUPmq7oxo8Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rG3ftGU+jHVQoBjUa1yO3JaWTmVNre40HkHMPTLT0FpH7jTjclxaU6XvqZUBlIBiF
	 m5yCTESMmQQ8h2cCTJmJ20O67IO2EoYSqxC2P/SEMTKP8tE4HVAt7ZYHsTyYgpYKCQ
	 HvD8lc3vuXm7dIfeuzhSeF3tUCYWHwS4lsHCfEX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Reijer Boekhoff <reijerboekhoff@protonmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/192] wifi: brcmsmac: advertise MFP_CAPABLE to enable WPA3
Date: Tue, 10 Sep 2024 11:31:19 +0200
Message-ID: <20240910092600.245193181@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arend van Spriel <arend.vanspriel@broadcom.com>

[ Upstream commit dbb5265a5d7cca1cdba7736dba313ab7d07bc19d ]

After being asked about support for WPA3 for BCM43224 chipset it
was found that all it takes is setting the MFP_CAPABLE flag and
mac80211 will take care of all that is needed [1].

Link: https://lore.kernel.org/linux-wireless/20200526155909.5807-2-Larry.Finger@lwfinger.net/ [1]
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Tested-by: Reijer Boekhoff <reijerboekhoff@protonmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20240617122609.349582-1-arend.vanspriel@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
index a4034d44609b..94b1e4f15b41 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -1089,6 +1089,7 @@ static int ieee_hw_init(struct ieee80211_hw *hw)
 	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 	ieee80211_hw_set(hw, SIGNAL_DBM);
 	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(hw, MFP_CAPABLE);
 
 	hw->extra_tx_headroom = brcms_c_get_header_len();
 	hw->queues = N_TX_QUEUES;
-- 
2.43.0



