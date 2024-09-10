Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C041940B5;
	Tue, 10 Sep 2024 10:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964138; cv=none; b=lNECBfomYvGzvaZ3kc+MNed7it2Gj4qwnEVaC8l6vM6D5VKlfmQsg4y7N7t4Lyw5jIaAARQ5uM2bktdxdGMvtPSc4i3kEVgVWIFOqQWTm1wbDvot1HZQlrFf+Vz4SCMFPzH+5yjU4ZnQFK3Ap3vj7QatN5z6PTb7Ug5fsl18nxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964138; c=relaxed/simple;
	bh=S5SkFz4R1ynHMb+JCX416P9IYCEDi2hLUYRfS9udJjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItyrxwFY79+yvwt3D7RjGowT3IQot5+0Mv1zUo1qQkkUIsZE5YPEJfyKBzaCq7uFqlKX/C6srge4oZZ2kK+NaV7I3P88Tcx8YaJZ90jU69NggBYo1AUhgn6LD9/R9L43h+So1dMtNw4VxwLqVhg9q02VCn7uEIB2Q45S6sesk8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ydqAmSaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ydqAmSaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F945C4CEC3;
	Tue, 10 Sep 2024 10:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964138;
	bh=S5SkFz4R1ynHMb+JCX416P9IYCEDi2hLUYRfS9udJjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ydqAmSaY7qIeYAQs6iLkJvn6kvLmi7VF2fLs3UsFPVuejFFOkHjIC8Oz1KaXTRmo9
	 skHuwop0THbDzO8Bn5XwflE39elJ7Cn3duaNytvYDxIqHBpsR4anr5smb31dqonyNM
	 r9Oa6PchRbGKdp/9rB1/jPIyD4Itj2vAWPrv49zU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Reijer Boekhoff <reijerboekhoff@protonmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/269] wifi: brcmsmac: advertise MFP_CAPABLE to enable WPA3
Date: Tue, 10 Sep 2024 11:31:07 +0200
Message-ID: <20240910092611.046406761@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 543e93ec49d2..9ab669487de4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -1086,6 +1086,7 @@ static int ieee_hw_init(struct ieee80211_hw *hw)
 	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 	ieee80211_hw_set(hw, SIGNAL_DBM);
 	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(hw, MFP_CAPABLE);
 
 	hw->extra_tx_headroom = brcms_c_get_header_len();
 	hw->queues = N_TX_QUEUES;
-- 
2.43.0



