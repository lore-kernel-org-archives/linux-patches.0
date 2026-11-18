Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026600;
	b=JHt+yOr9UMwxsqfYYOz4gfGVPHqirZsFqlKgHZLGjgerLkZSpMjo6oEmL2QXcfvgZqBe
	 vuempIE8397Q4DHtIAo1/WCYC1UfD+PgqWu0g/byneMNMxQGX47FH+x3yYLCfp+Rcs/mN
	 byWBrJCRoSOSO+2NFAHdOSGue0FUgHErszFp3tMANzpa5BMe111J0ZKK4a1Gpacx6TW3f
	 GcC4jnBMPMD2q8TBkGLz+0HiklsdGWrpDS8+GYuYzRryizzp3dO6IsPbnofEkOYdhLPnp
	 v9gv/w003RMWCCt5kv51Z0J3XnlfZ12dUBSGGHgk5PHEMTYqoKwLSyt7On7D1LPl9gA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=en0UV0sPCXNI01df+65K/Jw1rbBapkwydHEdvIJ+pX0=;
	b=jEzEa0Es4dBbmNpoyhK/2QMa0Z07MFAfBg7/xEp4RrpdvY6MM1bh/D2GxZRAmSTPdC5m
	 ovn+Iq2T6boJ3kkX/P2Z2TLipLls1+na55tSkFKUuRWP4uHru3ZZdTS9keTrqVU4YdHsf
	 L6iHKnmflUyP5VU+tmlxXI64tMzSA/QnBXz2VOQK57d/yK2orG5QzyWC/0MYbSU2X9jBQ
	 KQmFk3w8pj4jxEXB9J+Y54dWd/IdJACCH+iEZZtOMEEhv7sYDG5UM4eqYPO1ulhuCZkpZ
	 VtA2X5iXRg0/dCHhTh5SLW3QIIRaZ8tfyBhBMR81mdsTggGbzuHSelmzIGZJn7hPAXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AxNMxgeD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED874606A31C;
	Wed, 18 Nov 2026 18:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AxNMxgeD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1A51F000C4;
	Wed, 18 Nov 2026 18:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026599;
	bh=en0UV0sPCXNI01df+65K/Jw1rbBapkwydHEdvIJ+pX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AxNMxgeDeBGPPdveQH9VeHlY7bbAMPAtZOGqAx6jZISVjTTdnjymsNPWjd8cYNynp
	 AgqSq5CFzRgM9crvwtOLlXWKX24rYaK/SnjNu4Y0piIwyYsfk6nrYTZED8nqkrpHQG
	 ZLBfpVN0FoLD/Od8xdKyaN4QI13UaR0HzVZovBng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Endrik Einberg <git@endrik.dev>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1493/2151] wifi: iwlwifi: mld: include VI packets in low latency detection
Date: Wed, 18 Nov 2026 15:53:48 +0100
Message-ID: <20261118150216.261808504@linuxfoundation.org>
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

From: Endrik Einberg <git@endrik.dev>

[ Upstream commit 3627924ed81fd7783394fb2555ea179c6606a231 ]

iwl_mld_is_vo_vi_pkt() checks whether the mapped access category
is less than IEEE80211_AC_VI.
Since mac80211 defines IEEE80211_AC_VO as 0 and IEEE80211_AC_VI as 1,
this only matches voice traffic and excludes video traffic.

Synthetic video-priority UDP traffic does not automatically
activate low-latency mode, whereas voice-priority traffic does

Include IEEE80211_AC_VI as intended.

Fixes: d1e879ec600f ("wifi: iwlwifi: add iwlmld sub-driver")
Signed-off-by: Endrik Einberg <git@endrik.dev>
Link: https://patch.msgid.link/20261005144225.170280-1-git@endrik.dev
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mld/low_latency.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/low_latency.c b/drivers/net/wireless/intel/iwlwifi/mld/low_latency.c
index 23362867b4006..780ca5a8bcc82 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/low_latency.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/low_latency.c
@@ -254,7 +254,8 @@ static bool iwl_mld_is_vo_vi_pkt(struct ieee80211_hdr *hdr)
 	if (tid >= IWL_MAX_TID_COUNT)
 		return false;
 
-	return tid_to_mac80211_ac[tid] < IEEE80211_AC_VI;
+	return tid_to_mac80211_ac[tid] == IEEE80211_AC_VI ||
+	       tid_to_mac80211_ac[tid] == IEEE80211_AC_VO;
 }
 
 void iwl_mld_low_latency_update_counters(struct iwl_mld *mld,
-- 
2.53.0



