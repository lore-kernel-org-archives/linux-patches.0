Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D6C816F84F;
	Wed,  2 Oct 2024 13:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875356; cv=none; b=O8Zh6ut05hQkGY1h+3tb4nBTKYRK9Gxx5rpPsqBLhVXZoYt5Y5T2m33a9URpwfbz1eFZXNYXXpSYh7G1FxO3oGGn+7BQjt5SQYH1L/Od6go4f0Q036ypeZpl5+VKDERFUkXeHAzgDzDTqxNx70DuKOOGTnRKxNJr3tTowKdbGpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875356; c=relaxed/simple;
	bh=3LaryD8YurfiZt08RHypmFr/DjdEoaSlchmL89o/0L4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOcW9RP64VUykCCT1w91SUc3lxOiSmvbHqefH5mLM5E2u444NYt3GAWgD+DjaDq7urDmBQXUdEmUyzgIQSDxYgr+UGYQGyKqnr7ZuYuBDdcKa+WdIhl+fn5zro0dBRa1Eu59C4wjkt6Gr21rBgTwW03+D8iw0E29yBr0suo4Z3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2EqNI19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2EqNI19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1880C4CEC5;
	Wed,  2 Oct 2024 13:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875356;
	bh=3LaryD8YurfiZt08RHypmFr/DjdEoaSlchmL89o/0L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2EqNI19zp79Sv3xGrHoI1/kbzdj34ARVMHm5+gWI+bq55SdMl0XFeMEySZI8PMJ1
	 Ofmow/3Ipl7osBdnc4i9HsgTtwNzOfIttZk9qsZa7di4Sel8CpnniAeoJB2dNLS3PE
	 aEuVmdawSP3sgu7sOggS22E8pv5xbGKqksUCDgsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 074/695] wifi: mt76: mt7921: fix wrong UNII-4 freq range check for the channel usage
Date: Wed,  2 Oct 2024 14:51:12 +0200
Message-ID: <20241002125825.436285835@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



