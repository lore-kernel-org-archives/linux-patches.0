Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B3C1D07A3;
	Wed,  2 Oct 2024 13:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877413; cv=none; b=qSmx53Rj9KVug0OvOSMNAkK+2lCYHRDlCL44L9XC6pOv40La5ZwcjvM2VrLENbTEnYtFXpxiPuHbWW2YdANAGpfOvXHnrj6mGWBDi3FswqV6pOksCncXeNMsodfQg0gNPd7w1kSqzqjqW2OYJqXrcDZRv9cCRyUBjjqdgfbVOlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877413; c=relaxed/simple;
	bh=hhrqC1e3JZOSbaNdD2iIwK0t6uFc6RvbH6v0spOByr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgjDI6/Cw4DEs3oEBPb6Av/4RZBQH8KhTvm/Uaa7w9Gh3zOfcyE7kKxOxD/0YpcY89d4sGGse/CwGbEHDBUer1+HQgFkJhLg+z8Gp48qHeWtcyX1oAHR2fuIO5/d+BNyWjj7BeTIl56YMKsVrLK6y8pYUMyoAFoyPM5C2NwVaqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WgUOVULT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WgUOVULT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C6EC4CEC2;
	Wed,  2 Oct 2024 13:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877413;
	bh=hhrqC1e3JZOSbaNdD2iIwK0t6uFc6RvbH6v0spOByr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WgUOVULTSbpKJh+ErXYIx01F8oJzSpUHTZMV8zH446YTChQLf7Vac4ONDQVh6jzkd
	 Frx7hktllMMKi9y824GGjGSS/278Uv6H03Y9PitNvKR2P2z0CZ3NCvAjY+qkMUi6kI
	 qhg6k4AHq6MpeAsGk6Zf/vQXSJMmyzPgt5sGR2y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 064/634] wifi: mt76: mt7921: fix wrong UNII-4 freq range check for the channel usage
Date: Wed,  2 Oct 2024 14:52:44 +0200
Message-ID: <20241002125813.635078461@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

[ Upstream commit 723762a7a7e6fdb3cc6953f127a3fe9c5162beb7 ]

The check should start from 5845 to 5925, which includes
channels 169, 173, and 177.

Fixes: 09382d8f8641 ("wifi: mt76: mt7921: update the channel usage when the regd domain changed")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20240806013408.17874-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/init.c b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
index ef0c721d26e33..57672c69150e4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/init.c
@@ -83,7 +83,7 @@ mt7921_regd_channel_update(struct wiphy *wiphy, struct mt792x_dev *dev)
 		}
 
 		/* UNII-4 */
-		if (IS_UNII_INVALID(0, 5850, 5925))
+		if (IS_UNII_INVALID(0, 5845, 5925))
 			ch->flags |= IEEE80211_CHAN_DISABLED;
 	}
 
-- 
2.43.0



