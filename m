Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019318;
	b=beKwunwUXyhnGLmqWOVJf0DraXbA9+N4/pPyMIPDxH893UR9Ve44qC78kaUdDHmkCJkO
	 bbW4IsqpNRgwrnBGbwktlKxtzIvGeDFZlD4f0qtO7tho6gLUCe+T3LRnUhiDDxZ4i6Rxh
	 SA13blYmH+OuDHmA53KvYtS9tbfIbFXiYZwZkIX5Ms+tuNfd65T5O4dNXHLaAB2BvHZcw
	 WIbD/WFt9LYJm6AyO/G/WLNbnY8P+r7tgYiqYpTRRvDx3NfcEkpor+ogZ+iMYn2zJDIuN
	 SeBAn+EdF0JGKf6K7YNbWHBBYs5TH1VihRVDnchmNX0GSxpDwD9UpB2h9RiRYUVRGJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hC/EoDzkJceiaF7Tof9FT+N7jlfzyH9KJuE8QjANNeo=;
	b=4yBabpn59E8KeM3fSXVvj9V/FQXuIqhIhBBVZM2RGoCDGzTVSNloHqtb5OQQMnQaoPAw
	 GWkr24r7sxVQNAo8GYiVIrKjW9rwvyhTGBSj4BcP550ng26fdTUxRm6jvqZKECNXlGUyL
	 haKcRi8TZyTlLrZicFC58HWz2SAN64TWhYz6k1p1GgZEtNiw/O6tSb7jb/skQgOBK1EGI
	 Bkj2TAY0037nOQ0+0Z2ggQzIKdCaZTRZinTgMO9QGosTj9H4hif7gVo2GMj+vifGC8uXA
	 nvGPnuu3GyYIi0A3VrJGRpgo34lHsiYtxzV2Pfl/ZLEh3+pWIF8yuH4mZj6E/uB/ODQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n7eCQ5zn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA1660A2603;
	Wed, 18 Nov 2026 16:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n7eCQ5zn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8531F000C4;
	Wed, 18 Nov 2026 16:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019318;
	bh=hC/EoDzkJceiaF7Tof9FT+N7jlfzyH9KJuE8QjANNeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n7eCQ5zn61a8QNFNRDV4zAJNn/jPq+Zv/GXd8HSorkISw3UIDoKrHJhLQbT9ZmYS4
	 emf5oWKyS5G+D6W1Gn8cIaP7rkCdGGrx6gWdrf+YXTpiftqlsNz7fawf2pg7HvFOJK
	 UWKYGrSSpvgY4LWX6/6hC7FhYX9/g0lmXfjnzPSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1553/2651] wifi: ath6kl: dont take RTNL in del_virtual_intf
Date: Wed, 18 Nov 2026 15:46:33 +0100
Message-ID: <20261118150343.865921031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 97aab70a03df478ffefcf890ed4be258c0240bcb ]

cfg80211 already holds the RTNL here, so this will
just deadlock. Remove the extra RTNL acquisition.

Oddly enough this was all true even back when the
locking here was added, so this is just a revert
of a broken ~13 year old commit.

Fixes: bc52aab380c7 ("ath6kl: Protect ath6kl_cfg80211_vif_cleanup using rtnl_locks")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Link: https://patch.msgid.link/20261008165646.48866f0521af.I1c166be830384473f67677eeb187afa7e54106ea@changeid
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 8bbe554a9b364..626b3908d6b3e 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1556,9 +1556,7 @@ static int ath6kl_cfg80211_del_iface(struct wiphy *wiphy,
 
 	ath6kl_cfg80211_vif_stop(vif, test_bit(WMI_READY, &ar->flag));
 
-	rtnl_lock();
 	ath6kl_cfg80211_vif_cleanup(vif);
-	rtnl_unlock();
 
 	return 0;
 }
-- 
2.53.0



