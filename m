Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C162E25E821;
	Tue, 11 Mar 2025 15:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705596; cv=none; b=nVqWGggqMGvgVEKHRqh4AUP+ZC12IAPqnikOWuGOnteeOfFZuRtj87XXumTxJhVwWmagL48lnUqzU0wXvmvvAEA0B9dU6p3wGxVRmHttvqRRnh6fDoJwp7iPWNhkyHO/2oM7rjwG3ihdr4Tix1v30ct4Vfy+Tum4+EnpyoqJdGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705596; c=relaxed/simple;
	bh=tgc1mQTPIjxnEOa3aYtK6OYmULeLSvh3Sv0XohHQDGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2kfUoM4djuMY2ooq6Iz6tc7B+AcDG2v1d6SV5bJN6H2m9dBslyuK+hAKo7Z4yOqdwDgB29hlTVRmx6bV9iO7O+jjpAdz15NpJ5mc9JXlExitIEpT+fYJOK7zQ/g6JRJDIJvk7doM1paEekOeduCgOi9QFrbF7viqSbv7/A0+zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHi2HUb3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHi2HUb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EFFC4CEEC;
	Tue, 11 Mar 2025 15:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705596;
	bh=tgc1mQTPIjxnEOa3aYtK6OYmULeLSvh3Sv0XohHQDGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHi2HUb3hjNQvIcfmTOIf/fPRqp7FRH8Ux1uVcOHNfaP2RS9kwr2e7QVKDRY2RtZ0
	 O+zXCe48jpAyR+sfMWyE0EtJIVmw1tMhWUGyCLqtWuIgEYLsISbVOxKURBusolmbxo
	 SgnE6vBhvXlnsatbyqXZlZ2Ed98IjHS6zRRZr/Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 090/328] wifi: brcmsmac: add gain range check to wlc_phy_iqcal_gainparams_nphy()
Date: Tue, 11 Mar 2025 15:57:40 +0100
Message-ID: <20250311145718.462774127@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index a3f094568cfb2..90ae800cbccd0 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
@@ -23445,6 +23445,9 @@ wlc_phy_iqcal_gainparams_nphy(struct brcms_phy *pi, u16 core_no,
 			}
 		}
 
+		if (WARN_ON(k == NPHY_IQCAL_NUMGAINS))
+			return;
+
 		params->txgm = tbl_iqcal_gainparams_nphy[band_idx][k][1];
 		params->pga = tbl_iqcal_gainparams_nphy[band_idx][k][2];
 		params->pad = tbl_iqcal_gainparams_nphy[band_idx][k][3];
-- 
2.39.5



