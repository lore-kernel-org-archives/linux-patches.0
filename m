Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141542EBB8D;
	Tue, 21 Jul 2026 20:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666020; cv=none; b=h3U2XVXcr5fLyvqgtt5/bgrTXYvpuyIVPP1aWTKBfbbpznifh0b3b5X+oyOF+2w0pYrGs2qvH2+/4L+/GJTnhpdpalzper740EO42HNBnp5HqhRISSo0waRdjXs7p/tnTD2H2htOBZVc3rgnrvOodZNUvqwkKwJZJesV58t+thk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666020; c=relaxed/simple;
	bh=OpghRHRRalz8Dx65TuSC8lha7cUKYxj5RkGgafHh++E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQuojopNh1BY3wuf8nmFH5Mpe4ON1JQiY44fUKvUsJnhe/k+4Og/InY1WZF97PRkOfaIykE7pOcNwN0cMmr0fniWFeiMpuBHeKmMSnYEHi0GTAUkwmCd8HUX6t3BeysSbiVLORWfz+9hx57eAJ6UZLMYXc0Tp20OLRhoR0cmp/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpO1XTwe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpO1XTwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2681F000E9;
	Tue, 21 Jul 2026 20:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666019;
	bh=5qFSvAa/HjO3/nIQTg0Z84R+cog+skOkgBBWLpXq9ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wpO1XTweGWJB+QJywThKk3Wu7obmxWSWETV8bc0TdLb9RA3BSTuh020Hs5lVPCtHD
	 4FYTQtPuHn/RJHxtav+biyuKVRy4g0qFxr+mFHZpeVLkupfTrSnrdZR2Eo1XVMJL9+
	 1aiCBn9q/NX1SuOZQZen50H3rkUstXpQRfERkxJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bjoern A. Zeeb" <bz@FreeBSD.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0524/1266] wifi: mt76: fix argument to ieee80211_is_first_frag()
Date: Tue, 21 Jul 2026 17:16:01 +0200
Message-ID: <20260721152453.578791441@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjoern A. Zeeb <bz@FreeBSD.org>

[ Upstream commit 5832743279da8c6ae72f715bad2f7141eca6f4b8 ]

ieee80211_is_first_frag() operates on the seq_ctrl not the frame_control
header field. Pass the correct one in; otherwise the results may vary.

Sponsored by: The FreeBSD Foundation
Fixes: 30ce7f4456ae4 ("mt76: validate rx CCMP PN")
Link: https://cgit.freebsd.org/src/commit/sys/contrib/dev/mediatek/mt76/mac80211.c?id=c67fd35e58c6ee1e19877a7fe5998885683abedc
Signed-off-by: Bjoern A. Zeeb <bz@FreeBSD.org>
Link: https://patch.msgid.link/83s4psnr-popo-8789-757o-npr2n9n7rs2o@SerrOFQ.bet
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index bf4541e76ba228..61543ab7c2560f 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1137,7 +1137,7 @@ mt76_check_ccmp_pn(struct sk_buff *skb)
 		 * All further fragments will be validated by mac80211 only.
 		 */
 		if (ieee80211_is_frag(hdr) &&
-		    !ieee80211_is_first_frag(hdr->frame_control))
+		    !ieee80211_is_first_frag(hdr->seq_ctrl))
 			return;
 	}
 
-- 
2.53.0



