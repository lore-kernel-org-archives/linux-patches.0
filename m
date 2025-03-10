Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8AA22D7A6;
	Mon, 10 Mar 2025 17:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629201; cv=none; b=lFEScgT6cFgaxeG6g6SyHut/Y1j9GK65QAyhFq4Pa700320O/ZM+FzfiAEqIKW7NjFVG6RDEbO9CQlhlNwwjl3VXqISHXQvovMSOTnTJ46SgH9W/va/x+9qbtKOHlT2uK/Gxm3Qa8pYwhPNW+N50pd+Y7Aa85OSnXDgrdKxiI/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629201; c=relaxed/simple;
	bh=Wvrc0XvhPhe2PUw3+x9DNbo/RhKlMsWwjj+MN9fOJKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBoQNvkpl6tc/HG+wcPxlJlgBfB8XBCRKtvxSIaJiP380pG/Kx1HrqVwxQrOAA9vBraPlHOWzzZ82CFKhu1s9O/XKSFOlTEjzVOoWbVIwoCosJOq9mHi8kExvXrd7WPl6v6MwWzdKofXMihceSgTrZqeAAzWx0bavEzEVyr4QK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WkFU3jmB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WkFU3jmB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6703C4CEE5;
	Mon, 10 Mar 2025 17:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629201;
	bh=Wvrc0XvhPhe2PUw3+x9DNbo/RhKlMsWwjj+MN9fOJKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WkFU3jmBOYJVLSPwHEBujFpb3VFmJcbQbSjqXuKaT+8AbMrrw9gELn+l6yeHddBaN
	 drsqtesL5INnBYHJtUImM6YOOv4ndLUE8+OR0/HLfcz+rHPY+fTDprpDGQjKyPWM9a
	 bKNPeGJgfXS7ZSzUYe2edbqcVmND4Bq4jS2lTzSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 211/620] wifi: brcmsmac: add gain range check to wlc_phy_iqcal_gainparams_nphy()
Date: Mon, 10 Mar 2025 18:00:57 +0100
Message-ID: <20250310170553.953619502@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 3f4a0948c3524ae50f166dbc6572a3296b014e62 ]

In 'wlc_phy_iqcal_gainparams_nphy()', add gain range check to WARN()
instead of possible out-of-bounds 'tbl_iqcal_gainparams_nphy' access.
Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20241210070441.836362-1-dmantipov@yandex.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
index 8580a27547891..42e7bc67e9143 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
@@ -23427,6 +23427,9 @@ wlc_phy_iqcal_gainparams_nphy(struct brcms_phy *pi, u16 core_no,
 				break;
 		}
 
+		if (WARN_ON(k == NPHY_IQCAL_NUMGAINS))
+			return;
+
 		params->txgm = tbl_iqcal_gainparams_nphy[band_idx][k][1];
 		params->pga = tbl_iqcal_gainparams_nphy[band_idx][k][2];
 		params->pad = tbl_iqcal_gainparams_nphy[band_idx][k][3];
-- 
2.39.5



