Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819365381A;
	Tue, 10 Sep 2024 10:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965007; cv=none; b=WLzhHG5SoWzB0rNmL/z6YjcxWD81jjt/6fxwcZ9hODwrX4s2OFXz+VlPsFC55f8Mdr3TrI7BukDtCgPk6E+Ra+ftJERzbZTd/HqIgg+vDyTvOxSY3BMrO2KwOtaNc6YxPNlAyPDAN4EZFxU/zN9raiD3y57WJnNiP45gFsAb4Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965007; c=relaxed/simple;
	bh=y6h8+IChJyJ3X2G3+kKHDpCj+nPwh+2zzqi+vl1i+5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNoTW6P8pyJYCmUmMO79h6z++Tn1MTrylDpT4iqHqHyiSHkNodCdinodguNW0ihHEBc1plPQmf1YgaY6qRjW9lrebmE/s5UOY17HkpzgqTmOzV8K/6f7/Cd22wU2dfaU0y0SpFV1BVqr1ry5t9OYv1O2UF/ATL6E4e088Jv1mr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bGIKd+cA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bGIKd+cA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CDAC4CEC3;
	Tue, 10 Sep 2024 10:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965007;
	bh=y6h8+IChJyJ3X2G3+kKHDpCj+nPwh+2zzqi+vl1i+5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bGIKd+cA1p/EbLSngCT2GGujxrFMUe/b8QtR12glEcFFA5cY6SvFV7PVDFVMa6n7c
	 jg3pChfoNyGiw7Mws/zw+pUGz9EAc5On7wN1WW6uZ/7zIiXrE2XA6udX1GywJ1GOKx
	 aOyPvaVsG5+7Er2srWFIvPha9b/JxzZCSPS00jRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Reijer Boekhoff <reijerboekhoff@protonmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/186] wifi: brcmsmac: advertise MFP_CAPABLE to enable WPA3
Date: Tue, 10 Sep 2024 11:33:21 +0200
Message-ID: <20240910092558.899835788@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fb76b4a69a05..ad3893d45058 100644
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



