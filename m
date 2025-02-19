Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5437F1805B;
	Wed, 19 Feb 2025 09:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956846; cv=none; b=N68WtLEzPc5t2beC812f+mnbX25fpyc85h/kyTkTXoxI0PIYJjbmFUCbbUue4g8e02lOwCqW7gdqQj6fQpnuxAIsqYpe7oSheod/x77JpTKf4XQaHpTS/4F5tgEnTAf5j7mILoN3anmpS+FqOJFqteHaJu732WjpRT1izZ5/USw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956846; c=relaxed/simple;
	bh=8/gxTR/z9e+HXVvajLERWbGF8aIoDYb+ijs8vwpGocM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPcZ5T+C1kNWwasGgY0g4FV7bsvksfxEZ5N3lfuoaXaokdmeHlQyx84txDr0/rlWyR4rXRma9V0INQt7SC9o+2OrPBxpSsJ1zqEqONBKIHlggmLA2jjtXKtNizwCFu73yspbT+6IpsK8Ra+4/StwOX0WYzNkt8OiU3bwd91anNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIhfvFRr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIhfvFRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13A0C4CED1;
	Wed, 19 Feb 2025 09:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956846;
	bh=8/gxTR/z9e+HXVvajLERWbGF8aIoDYb+ijs8vwpGocM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wIhfvFRrD55t83S0L05sUUL+wI9eIIwJ1fJK0glNnjK1hSH2aZL+BrjLu52Rw9baw
	 MKtR4e5rdCoxaZfUnlSRNIBdb+xP6h9JSzLrcf/3h1Ga+2ZpsxKw1Gcx5UY2qZazgN
	 RnRpFW4Cz6bgnGhp6kJYBF+LpyP2hTII5faDDDh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 288/578] wifi: brcmsmac: add gain range check to wlc_phy_iqcal_gainparams_nphy()
Date: Wed, 19 Feb 2025 09:24:52 +0100
Message-ID: <20250219082704.341451887@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



