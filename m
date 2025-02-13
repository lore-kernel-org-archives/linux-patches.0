Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD82F26B09D;
	Thu, 13 Feb 2025 14:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458725; cv=none; b=UZtpnI8EX7RgwaseGWWiX7NVXWn62OO65I69w67eRPsfsNlwkb+zeUUUHeLSwPg1LH7F0bt7frztMPv1P9zSJCAXiHzh+A1QRrmWQ3wVUG8y0I6lxX+s2ZmvE20USIW9DAhxq2q58IbEYq5vf5CJwtaANqQOMTYXDLcINx3CA5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458725; c=relaxed/simple;
	bh=eyMDLp3HkVaBQKr94seGMnnXd6MmIyyiAs7ajg69Epk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GaHSfzRHh/Xn0OxO0v70GKC51+Kg6Ofiaj9YFgsloMkDwLCb29/h+T93v/TQ42VBYyhh30BTZ4jaNvpZ5KChz2W70rKrCNoPEqbvIMZVVzDe1E7+tYzMduaxtgEWGaB8gVQ8uztegclNJtnSzVIGZ4SZ5dktdanDtUP3lwue5QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTb6ZjmZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTb6ZjmZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C501DC4CED1;
	Thu, 13 Feb 2025 14:58:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458725;
	bh=eyMDLp3HkVaBQKr94seGMnnXd6MmIyyiAs7ajg69Epk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTb6ZjmZPOneM3mu+KUJu6vA4PP99WSTL9bIaOckWtmFqY9N9a1yjtbwf/eLJd/uD
	 TRlAR5mQMSkc5ZHC3B1Gj9s6eqT0VT+Rr55xDiYsnsAJft+rR6OnaHe3hhWmwJDg89
	 NCEvoL8u9ib+ERkuEegV97tqrNoq4k2t8173e2FQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 059/443] wifi: brcmsmac: add gain range check to wlc_phy_iqcal_gainparams_nphy()
Date: Thu, 13 Feb 2025 15:23:44 +0100
Message-ID: <20250213142442.899113563@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index d69879e1bd870..d362c4337616b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
@@ -23423,6 +23423,9 @@ wlc_phy_iqcal_gainparams_nphy(struct brcms_phy *pi, u16 core_no,
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



