Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619026;
	b=vffg/IMmHk1QgZWonTV/CscBPHDeUwFpbxF0+k/UVkRhh7e7fhXlOT7PShLuDQ3pYr1D
	 OrTy2L9iFQZWv9FHdM+fcXQiUwIkWfJ7rvfkTmE3iM8UuS478qVdR5suVFjUB72F7z0BI
	 L2nPI4UAsqqi62rNJsF3mCclNM7RsPje6vSSQTwhnuEhG9rqr21W2x5zKzkmgEKauOrr4
	 pM3Qrkt/e0gtm69uVvwRkKVxaYG1yGMx+qthwqIkvcyXaTQpGHBv9QWeGgfszNL3JMxbB
	 xeAmk7m30X08/3hCp8qcCHJSWskVh7DRRYO0G3Yl6eJGu2N9eZVu/2649ZK+4n3amTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oomVpvrlWnm4dkzdBiFMEYXJnuOenFYvY5+HypIBZUo=;
	b=xRxw4NQcUURKCOAC0nmdFfVW/gmXknRwRNQ9qgqFpvMO2nc9VBnPZiopBkld034ctNch
	 1HHVhQPfVOeMCaxF9EHpJA10TLd6qxVhW86jH0SrjiWKZNeCvMkmHQB4/o9V8HMEeuayd
	 DRvo+WKl+nedJTnF3EnAJQqO9DiREoH0jIYzpugoo/5VG35xgLJNWfpVbTecDzmj1iknA
	 XaEbrSrQwXGy3gB5W4DE4HT5/Y67qWep4trkEVZuwqX6Zd1MCi28AMzXcSDZS+pWe1RjW
	 pjyT254BeN1bAfzLf6Om2KFOKzLZ+nLBAenhj7Vff3SVW0F0tHxvgyKaIBm35dNjGXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h22LAGUz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94765606A31E;
	Wed, 25 Nov 2026 15:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h22LAGUz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20AF1F000C0;
	Wed, 25 Nov 2026 15:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619026;
	bh=oomVpvrlWnm4dkzdBiFMEYXJnuOenFYvY5+HypIBZUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h22LAGUzcsxxE5FlXNQGXFR7p0DHXUeibW6CFdqtx+dmTlisQ7jOr4kWpGYIy9Q9U
	 oxqtcSn5CYaGPCRtQYgnvr/4jzklz70lN2XhQ4S8OpVIkjK5KoAfrY9rHh1RNJLdA0
	 IRd8OH9gjro6XTtgul+HRIAVwoqyTchuuGlcwVpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Gejak <luka.gejak@linux.dev>,
	Mehmet Fide <mehmet.fide@screeningeagle.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0466/1005] wifi: mac80211: abort chanswitch when leaving an IBSS
Date: Wed, 25 Nov 2026 15:30:04 +0100
Message-ID: <20261125143832.660711015@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

[ Upstream commit 12f97c692dcbce088554a5530c79c55174ccee1a ]

ieee80211_ibss_disconnect() leaves CSA active, as ieee80211_stop_mesh()
did until commit ac7472a24bd4 ("wifi: mac80211: abort chanswitch when
leaving a mesh"). An IBSS left during its countdown and joined again
refuses every new channel switch with -EBUSY.

Abort the channel switch the same way.

Fixes: cd7760e62c2a ("mac80211: add support for CSA in IBSS mode")
Reported-by: Luka Gejak <luka.gejak@linux.dev>
Closes: https://lore.kernel.org/linux-wireless/796598480d47c5bf474d11828769e864b8209558@linux.dev/
Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
Reviewed-by: Luka Gejak <luka.gejak@linux.dev>
Link: https://patch.msgid.link/20261025193615.1123718-1-mehmet.fide@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ibss.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index d74b66426349a..b9ab4ceb03325 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -669,6 +669,10 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 	ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
 
 	netif_carrier_off(sdata->dev);
+
+	sdata->vif.bss_conf.csa_active = false;
+	ieee80211_vif_unblock_queues_csa(sdata);
+
 	if (!sta_info_flush(sdata, -1))
 		synchronize_net();
 
-- 
2.53.0



