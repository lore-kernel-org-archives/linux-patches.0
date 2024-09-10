Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79AD18DF69;
	Tue, 10 Sep 2024 09:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961579; cv=none; b=QsxbDtRYJ5eKFIDrsnsZIN+TdB3CVPI1an3G0BtLTraC5ZqpI159raiPLAlc0AiuyCd0S41teaHJ9uPhk7Ab82/VVseAVCbAqcDxfu2VIsyO3kiOz7ohLXniJOSt4GQ9nrkoVeFL1HeBYd+fRNoHQCobm+PqW3A6L3UV7amQXlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961579; c=relaxed/simple;
	bh=DD5/GlSDOUfSgJM3EN902BlLAxn+ZX3wDMUk2D1ADlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzUqIDnksoeFjBl5JIjaOFZ3MUwP/8nTBiobCeVmKu7Hd7r2LMg7ZOu7Jt/RM1K9zDX33F9M1YI5dRyrUS5cU5Vi2ruoYaCtU6na7Bn7O15qJY+VjcrGQsKyRQyN1Pe3LUYajh0tVcP0qOAeGB7wfcL4YzHNUL7AuhWKtdW82r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zw0NC2PV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zw0NC2PV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D307BC4CEC3;
	Tue, 10 Sep 2024 09:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961579;
	bh=DD5/GlSDOUfSgJM3EN902BlLAxn+ZX3wDMUk2D1ADlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zw0NC2PVhDUOQUHlIQouVPaxKnfxwXooCRboQw4u1/nJW5vJcfqFDrPpAx00RHBWU
	 8ewFwmPKO/GoPp0dDC2Wvkj3EEwtFKD26Z58EM8I02wVxxvovn9kbS2WIDeQpiwsrN
	 QDuJvyQ9JudAyCNJu6BItE+d9MUBLQKd2TXUVK28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Reijer Boekhoff <reijerboekhoff@protonmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 118/375] wifi: brcmsmac: advertise MFP_CAPABLE to enable WPA3
Date: Tue, 10 Sep 2024 11:28:35 +0200
Message-ID: <20240910092626.389778512@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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
index 92860dc0a92e..676604cb5a22 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -1090,6 +1090,7 @@ static int ieee_hw_init(struct ieee80211_hw *hw)
 	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 	ieee80211_hw_set(hw, SIGNAL_DBM);
 	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(hw, MFP_CAPABLE);
 
 	hw->extra_tx_headroom = brcms_c_get_header_len();
 	hw->queues = N_TX_QUEUES;
-- 
2.43.0



