Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026074;
	b=Q+rvxoNbYI59ticVvrjQH7qzBjbQ6O2lNW2T12HG1Nv3DkjaHK4NSukd89TgLEvvl4wb
	 eL6iZGip+baF6/DIEmAQOcClNVjHgSjvnjjDwR7XNqrR1mfZB4AoccCwq5rnmCUu2hd0L
	 Uvxv4iYzxEVoqPKxyX3r95IxLi7qVd3mHlgAUOfBwo3VH6OJuZOdP1/WLCXrFSzn/ujYZ
	 V8STM/AIZdAhf60ZFnxbrDkVt+7tjALbR9/bZLUtjaH1t5pIH4DwZ7iymVyB9A1LuX5Mc
	 KoK3hfOnvJ2IEE1mp7BbJDJ5l0U+g7RuF0xqG8ALLCfcC5QQHqB7SXU6M4ClNBb+ufA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EWTryLP5Bo4ry0z328M6uQ5jPCd1o92QNoabyHWCFCU=;
	b=0kPrCALa7cpxIeSA96U7cfVQJJqJCa6qrMRTpjsN3AKX6E8a7K9nsH0FQNY+1NYM21bb
	 G16trdSYpUgcHvhVtRUHxvQY1OpbQb2ATr7/6O/zXCHf6DEsTfd2g90AhOI47ywj3jKBw
	 +uuCSm1DAbj5xsigdlCEo+PBdbcJlXPDqs4h33zTyspsJ5d1lSNKujgP12VyTU4Ys6DVs
	 T0EWKHwGxzXYBFqRL3VzyuOYgkrdqgxPQS8Um6Ug9Sxd4JniZA/ns0wjC8lFi/PV6oCu8
	 w0YU1TuvfEdvec5ZZXMW32FvCmNCciAQ0W9XSitCrb53SvkoD/FdzkdnpoCt5BwO9zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="cuMuRA/B";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C863606A32A;
	Wed, 18 Nov 2026 18:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cuMuRA/B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B6641F000C8;
	Wed, 18 Nov 2026 18:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026074;
	bh=EWTryLP5Bo4ry0z328M6uQ5jPCd1o92QNoabyHWCFCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cuMuRA/B1j4LrDsbPsKisQAXo0/tf0H7aSmTa2t8Jjn3yfle2G/Of5EjLq0UfS3+R
	 Ay6Sl7XWvQATWfaaHfL50ENfwaHchYdcfl2wtTTIw2rItyANpWkvDLxXAh7u2qgYwE
	 FcOd6/3s18fBdSLUvyyKYj3eEKQEGa70i4MAigHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1288/2151] wifi: ath6kl: dont take RTNL in del_virtual_intf
Date: Wed, 18 Nov 2026 15:50:23 +0100
Message-ID: <20261118150209.051006917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e4f87018f1642..bc36c609e7e7e 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1555,9 +1555,7 @@ static int ath6kl_cfg80211_del_iface(struct wiphy *wiphy,
 
 	ath6kl_cfg80211_vif_stop(vif, test_bit(WMI_READY, &ar->flag));
 
-	rtnl_lock();
 	ath6kl_cfg80211_vif_cleanup(vif);
-	rtnl_unlock();
 
 	return 0;
 }
-- 
2.53.0



