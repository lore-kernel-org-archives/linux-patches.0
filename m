Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950E919D092;
	Thu, 13 Feb 2025 15:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460214; cv=none; b=BQD7ju+lmk7/jFZr2LbrxmD61VtRNaEfFgTnKqvA9V4NGD7LB4UllrsJqmiXA4EusHh85bgV5XIVaYuIONUFPkWlWfqC7jU5q7JiRi1Nl0vFRcmjXIzJWwSPMuK/zuLb+y2i3gzYx7Ara3yt7QGndNs4H9ZUHXe+FHNgOErjkC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460214; c=relaxed/simple;
	bh=LeohtLtnnq8eYsqwIcTaI1Q/NRtnpFYV/OZVdF12HY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXk0WJU8hW4a8D6BeZlq8/YyPqKq+WqLMaErTkVt9Svr0HgiBFcbl9l1Ku2nDvB0eq9W6L22IrAQ32Ii8iqDmhq4ilhP0ueBnfFrxt7ALQRSlIK7KoGKB6hL8YBeLwRwFtUxHgVrgC5quSuh2uPpIthxN7YxXt/qBpawgo6wqfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TuU+GgRH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TuU+GgRH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0032EC4CED1;
	Thu, 13 Feb 2025 15:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460214;
	bh=LeohtLtnnq8eYsqwIcTaI1Q/NRtnpFYV/OZVdF12HY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TuU+GgRHu7ij+YAJ5uso9jPzp6O/Y249AMwnxa47Bm5np/hvtNRQ6dC9kq6kWnz0J
	 bO6NB5jt2NQ41/odjIWsk+DYCcims0yFJ3hKO0Jh/vU9nNd+eA+xOq/OSfThQzFvQK
	 ev2ZiPWquKob0S7Kr+csConhnrv6EFNxW5a1FP9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/273] wifi: brcmsmac: add gain range check to wlc_phy_iqcal_gainparams_nphy()
Date: Thu, 13 Feb 2025 15:26:43 +0100
Message-ID: <20250213142408.586787518@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



