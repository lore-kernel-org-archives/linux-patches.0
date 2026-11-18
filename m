Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061484;
	b=LQbFAhzWF4rSHHD3cW6CXiYtSRR6+TqXT2HeV15ODeuGxomZ2T8F4fjZOX2c3GhtklyS
	 rxkM02Pi0Qr/dlYZG/PrlOGBVr9JvRyupqIRLV/6+xUzC0+mkHyyNtzfFKZ68a92WeUfy
	 5ONDc72xsgGPoFeoOxxc15LYx+jz6ktejzmEvw6Qz8ypkYEOOgLnscipYk3vTQ9O8vFep
	 rMHRZEBsvDOR8M6T1oFmpZ/ZdOEUNrKdPq+7x8D5HIzjaU90h1xtVX5XRgYkyh6fVV/vZ
	 VU/7oPNZGncNadURqKbD72iE2n5TvxyuG9MdHcJBJUatXnPApozFf2EcBCATQRRnQDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061484;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N/RnRSb3oZA26NRA+jpGcCfqfudhCfsvMeAHiy2xVnk=;
	b=ZsmSdNM8KkRoFGizlAJs4KwTOB/HODp4xGw5RmoKEAqyXnVtbGuFX8e/2dGjsrd8Tux1
	 vTghcKSfxu23xBy/6YSov0X/0vON4q6eWnfNwKM54utP1qOvtzznuipSvyjfAd3sg6oHW
	 OSXtC2NkgN+igL09WAJXriCLMom8KplWkwHINLj/LS1VPY81pgMGouwNwxhgv9DYB4QHy
	 MyEwr+TkVzh4EKRlxaOpO1l9PvaJe1E25on366dne/iJFdRvGijj3VuD1Eb9QJwyie3Eu
	 mSwvNN19Jdc/CAroN9AdNO1k1F5R0dL3cClmNowTj58IZ71eRVdbQ6+SUY9QbOMBVgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=16TwN1Vw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E4960A2604;
	Thu, 19 Nov 2026 04:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=16TwN1Vw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1C71F000C4;
	Thu, 19 Nov 2026 04:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061484;
	bh=N/RnRSb3oZA26NRA+jpGcCfqfudhCfsvMeAHiy2xVnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=16TwN1VwHdqmUcX2ePVkylOSFK9ZtFE5RW3dPdY3zLsOwA26/bOf0Yhq/g1/cd3UZ
	 EVBGMmZpnQPmgzjpHFkCue3jvmu9AKOBYcFk3BIULA9ZN8/8/DhSrV18kMVsIkLJFp
	 3mqI3XHuNghnv16uwtrLSsEPCr+xLBSBweg4y7MI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1552/1848] wifi: ath6kl: dont take RTNL in del_virtual_intf
Date: Wed, 18 Nov 2026 15:59:50 +0100
Message-ID: <20261118150024.590971793@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f25b90427d360..8e80b66d4e480 100644
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



