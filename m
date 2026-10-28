Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213742;
	b=EsINfSMmkaATvaqTGfEsPXMzJUuAQ81Sy3MJNPq9RBIdZE3FgsOxouOMbfiugQlePTV7
	 C770J9YX06fn6is2Yvjs+R7Qv331taMOiYQXk89X+qkH0zFR7wy2rqyJeGGM5XrAfMfPx
	 /XawOR4ut79mU2kOss2jxSnUqsvAT1mizRER7CN3oTiCl6OTbnHXILAqYQEVjamz/6Uws
	 5vo7BNJVg+d6r7UrG02Gwx92YPadNqUNAoUgbNXDJ3fx90bPDAlNVePpHmsVBtmmZi21i
	 KPLQeBiWpWo97MfpxPWk5JjnSqm6JlhyQXj/15r07o1DG4kQdueO+c6k1Lw7+DaRbrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TIgjZtSMdBx8C1Rx6Ao1RlI1IhIOAmXGBPcsHVs912E=;
	b=Ve4aNdzEbPFOLETqg9su+uvCarCWLzMHb+2Wetjbfzedt90/AerVnaykD5J4ja9duYPI
	 rq9IxyD5nbbtNnK5HuoryfMrfDvw29IAJlwiTI1lK6rdEP4B/bQ9rMjW3w7I4Txuj/G2B
	 rsAYKtwsWj9XsuDItB8GcFBxpchr7XCtc4oaIGnOJMDbqm9vHvOaso8rQRx8iYQukzskh
	 19cdG4AbrLd9NSZDyWe0KbXXrtWR358xslDCdxWXC+HFO7DqKdThumuxCXO+1SfADEBjt
	 bMz5ZqWRR5oZTTmrAarK35vGsskMFoLTCmXwp8XuErn6pj/iPx5Fwfdrl/SraUuLx/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="p/Q/7Mvr";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69629606A31A;
	Wed, 28 Oct 2026 18:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p/Q/7Mvr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816B61F01825;
	Wed, 28 Oct 2026 18:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213742;
	bh=TIgjZtSMdBx8C1Rx6Ao1RlI1IhIOAmXGBPcsHVs912E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p/Q/7Mvrg+n+Ln/7y3dGfSQpq0/FRabF41j8+UIIKJTGsnTIM6wy+zKwj7lMHIf0s
	 hzfXxZdunl3jcFBVelhHnti0ZPctP7EwjIi4MkbYajBcvYyXskO2PE6OySIXH5Fto6
	 knobGLJQIVCusckxC81dNfj/hWNOmTqmLb1KOsco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Po-Hao Huang <phhuang@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0612/1887] wifi: rtw89: fix null pointer access when abort scan
Date: Wed, 28 Oct 2026 17:45:08 +0100
Message-ID: <20261028170513.338237546@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Po-Hao Huang <phhuang@realtek.com>

[ Upstream commit 7e11a2966f51695c0af0b1f976a32d64dee243b2 ]

During cancel scan we might use vif that weren't scanning.
Fix this by using the actual scanning vif.

Signed-off-by: Po-Hao Huang <phhuang@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://msgid.link/20240119081501.25223-6-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/mac80211.c b/drivers/net/wireless/realtek/rtw89/mac80211.c
index f7880499aeb09..2c3a72900b9fb 100644
--- a/drivers/net/wireless/realtek/rtw89/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw89/mac80211.c
@@ -383,7 +383,7 @@ static void rtw89_ops_bss_info_changed(struct ieee80211_hw *hw,
 			 * when disconnected by peer
 			 */
 			if (rtwdev->scanning)
-				rtw89_hw_scan_abort(rtwdev, vif);
+				rtw89_hw_scan_abort(rtwdev, rtwdev->scan_info.scanning_vif);
 		}
 	}
 
-- 
2.53.0



