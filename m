Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67D4187560;
	Tue, 10 Sep 2024 09:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961148; cv=none; b=C6vExvLGNMGxwyJZ/3esTZaeEPHgKpZwNYOjBm4k4DZ7rQNvSmNh0qhq3c+1Cxs8L44HHRhjoEt6y2TjDxlC5XTamIyAiO/1fWqasRixeztlwwWUCEN7lV9S39UExeB57v/4yuBMxfRje4YdTo6WjgPuhRbI/tqiOA5cOkKEVgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961148; c=relaxed/simple;
	bh=w17ntVGz14HRrY+1Cs/npkzqbSnTrZqsN2Rz9tzb9lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6YSag/ELEzQN9shvGGeUvRkWdK4eM5pPXj1Q7xPN7PP3E/IfUNy9tOVFLhCYR/FuqsBB1hg3Aej8n1m8pDbPmXM05/YCNZqTU6iDmTRP/576eqfCAgqdXCEtRK6V5xnP4w9yl86ABViugylXiAqrVbt/fDvLntZnYNvEq/Ju1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+rSCQNG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+rSCQNG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA30C4CEC3;
	Tue, 10 Sep 2024 09:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961148;
	bh=w17ntVGz14HRrY+1Cs/npkzqbSnTrZqsN2Rz9tzb9lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+rSCQNGF2uGuIhH6IDIlnf7RUplTc2zPxw59Y0v3Q64eC2Ey9iHfMQvP8dBF28Bf
	 N33WwFoV0sZ+OZam3BaCAJ47jozpwtRmoQ/gdyV0/X0sS51rWDvzoGn4U7tb+6mAMX
	 w+nUeI8u4W+Fgz4j1WbTrtuUuGyLkzrNVunT6LXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Reijer Boekhoff <reijerboekhoff@protonmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 32/96] wifi: brcmsmac: advertise MFP_CAPABLE to enable WPA3
Date: Tue, 10 Sep 2024 11:31:34 +0200
Message-ID: <20240910092542.918594069@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 288d4d4d4454..eb735b054790 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c
@@ -1091,6 +1091,7 @@ static int ieee_hw_init(struct ieee80211_hw *hw)
 	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
 	ieee80211_hw_set(hw, SIGNAL_DBM);
 	ieee80211_hw_set(hw, REPORTS_TX_ACK_STATUS);
+	ieee80211_hw_set(hw, MFP_CAPABLE);
 
 	hw->extra_tx_headroom = brcms_c_get_header_len();
 	hw->queues = N_TX_QUEUES;
-- 
2.43.0



