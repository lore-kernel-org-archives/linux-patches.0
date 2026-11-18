Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055982;
	b=P7oRrBPHln46Hd6Yh9j16prn1ERMEWZ2llrEt7Jl7PiOCdLaiBkW29eSvOKrZKVEUMKs
	 Mqxu6L1SBjj8b6VyrKweogCVshX5r4oBgV5j4up/o9L8/sSIQ0Olk91izxuaSoV4WOkLb
	 /bzyNxe33MXwTcchRnwatmx7L5VvBov7CvLZWlopACf9nxwPMKBklWL1OKh+5hksIyHF7
	 ZsWQQgKgAzqZpX+ttCQIJjXvG6fcjmm6WEy2cYD24J6YO+4CLSW9ex6ivlAdPlSJpLjO5
	 NWu3PlB5jaRV+CrrkzRkGhioeCeLHyaAquZ3fzaVutdJg7ymM2l8WhZFMxeSBKzWASg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y7VK+ajBGEkQB0IyBWNWoHSWnHASQX8LgpYIDrtdncI=;
	b=YBZWdRpxKuiyt3BbdXBc/2upPI3qVZzcz+IuRUaHSI24Uvs8XOve5AhDwDUcSK+hC5uM
	 5GcOWqIWXcnb7hS2e1s0A9ADO5YYfNVuHfi1r+Zy9jWFkedHZir7i0l9USIyuZRvS5laF
	 r1ZTWjapsK5+Nvjv6gcEe74vN3GPVk0w0wCv+zRSt0GK874St439XquNYLR258phie3sK
	 8S9pc4fOAuBleX2Bs/uQRlZYDOjV6Rlt88RVnAGQlwjCSdh4WuELXGRqXGOv6fZlhxWMr
	 6JTB3GD4ihwgeeLIMt1DHMBstrt3LOuNkx0xUjewPSVWCvTs5PFjRGQTdTujQTeRQSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UupEKugO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10784606A320;
	Thu, 19 Nov 2026 02:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UupEKugO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EC91F000C4;
	Thu, 19 Nov 2026 02:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055981;
	bh=y7VK+ajBGEkQB0IyBWNWoHSWnHASQX8LgpYIDrtdncI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UupEKugOEUsN+BBZpPjcQZ1dbl18wq7Vwe8z/WRcsfqUqEyQlgqvFeESEmUbDDKLZ
	 6HWd5jB5v1D6kQ0PTrpQQ6VMu0ltSjQywpaZvXrin+Qy6JlcQp6JVEmSwcU1rzrUel
	 QtWQfD7Jdr7YiGVohvjT4t5rDW5c7NDw7lEYxh4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1826/2214] wifi: ath6kl: dont take RTNL in del_virtual_intf
Date: Wed, 18 Nov 2026 15:58:22 +0100
Message-ID: <20261118150124.493215733@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ef69ce11921b3..8208e6604b8f1 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1551,9 +1551,7 @@ static int ath6kl_cfg80211_del_iface(struct wiphy *wiphy,
 
 	ath6kl_cfg80211_vif_stop(vif, test_bit(WMI_READY, &ar->flag));
 
-	rtnl_lock();
 	ath6kl_cfg80211_vif_cleanup(vif);
-	rtnl_unlock();
 
 	return 0;
 }
-- 
2.53.0



