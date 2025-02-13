Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D52628136D;
	Thu, 13 Feb 2025 14:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457233; cv=none; b=BvIY7gkfIz9s5pPz7sFiumQAinAX+TrEH3nrkdjIor7aAKsvR6ybsKUsVVl7NWaaZzi5CIlnfAtirgV+THhFfzmDSZyTBaIHA6d8QSBWceYTeQTmaMg1f1vVcr7LeN1uz/rQ8/tIec3qv8VvCgCQb1U1ZcIwNpWdqqwE7p2FGgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457233; c=relaxed/simple;
	bh=3N+u9I7wazCFIDEPV+sAUPrw2W+2OP0rwMki8EUGWNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JhcdeOwDQ7sSLoGzJV+2LNY2c8lHHS/McjD4I/aIstC5O/PuBZsJxbzAarQpe+nZlhr4OskNmsXdqYemnyRiEtVbTjKZUad568a2XKeXR4x9cCq2/UxgOW9F4DR9iTIf7hEHE5ghbDX/DXmyE549CnQVKsjLiy/MfPF61Is8/F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gL96VxEV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gL96VxEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9062C4CED1;
	Thu, 13 Feb 2025 14:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457233;
	bh=3N+u9I7wazCFIDEPV+sAUPrw2W+2OP0rwMki8EUGWNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gL96VxEV+yAKkaUyck6ke8Q0Kij6QOfwsS4bx1idvWJBn3NvrxycCwv2OZQs8hR0X
	 IJcM+xMU6YQM0YD51K615S9KyCrdxs6sr/Zy52t1ZJzl0Kw7E8M1NfUo5EpQFER8JE
	 q3O2A83xS5nu02MdiaaUblQppvuyXbkMhYUK6BSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/422] wifi: brcmsmac: add gain range check to wlc_phy_iqcal_gainparams_nphy()
Date: Thu, 13 Feb 2025 15:23:21 +0100
Message-ID: <20250213142438.570602094@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



