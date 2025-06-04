Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0801D5161;
	Wed,  4 Jun 2025 00:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998773; cv=none; b=GSw3m4iqidHtUuvbaeMNaVjPyMUtFHR8C9IFAcxdsoE4D673is8jJERKYM/qZcQD0ZWLpci7qmGyeoQqbF4ARmB+2qnjlGuRWAB+b4OJLWu2aSGd0t3q+nbKGMoodycr699uuWnuvNDcHsghH4I6VcIuR1c8m0U43bE+wc3fj/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998773; c=relaxed/simple;
	bh=n6Zi4sargVPSMxeJH7B7w42EtWi71LDTQ8InIHqTwr0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G4VpXD/36adIUACXf2gMCidHa3zli60XmsRFZsqMKwVGsnUpP7Ody7lcX0Bn+X2H6gMQJTiHeBEQwbjbntE2/DiymOwQbRT+TGRSpdVDDfE46qK2sIaTJ3AmLNNd1wLkKRbsKDlXa2iqMu6dB/lDAGWZZZAxR5hhEZEfTnR3r94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LB8zjQH9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LB8zjQH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79501C4CEED;
	Wed,  4 Jun 2025 00:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998773;
	bh=n6Zi4sargVPSMxeJH7B7w42EtWi71LDTQ8InIHqTwr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LB8zjQH9Gr56wDwh82ilFZF2C8EiZsjHq39B2qQcKf1MuW4cciDeqQK73fD1NRqsg
	 bXIW9SuuSsF70O+JmAqG8rJ151grS81VnePirPkafb6ueSlkdt0juj+6OHBztMuoMN
	 Jg5sC8FAOcjrb25vA/emNF++osLIf5Wcm7VsbSEiGTzOIhh0/LnQvT7ViLd0TgKgFG
	 ovMme6s4pzytxgV+U9bheGclbUDCsaThgC4MLcMLfyY5UgiLXdBYNSiOFrVoqJWKHH
	 /M+h0kS5jpwYPSrBJnf2+zsq00z4TrFbGe/VZ2C8GZiRRHv8VGmDuDxxh7S4TOYEqK
	 ytIr0wqedbZjg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Benjamin Lin <benjamin-jw.lin@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	lorenzo@kernel.org,
	chui-hao.chiu@mediatek.com,
	Bo.Jiao@mediatek.com,
	StanleyYP.Wang@mediatek.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH AUTOSEL 6.12 08/93] wifi: mt76: mt7996: drop fragments with multicast or broadcast RA
Date: Tue,  3 Jun 2025 20:57:54 -0400
Message-Id: <20250604005919.4191884-8-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005919.4191884-1-sashal@kernel.org>
References: <20250604005919.4191884-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.31
Content-Transfer-Encoding: 8bit

From: Benjamin Lin <benjamin-jw.lin@mediatek.com>

[ Upstream commit 80fda1cd7b0a1edd0849dc71403a070d0922118d ]

IEEE 802.11 fragmentation can only be applied to unicast frames.
Therefore, drop fragments with multicast or broadcast RA. This patch
addresses vulnerabilities such as CVE-2020-26145.

Signed-off-by: Benjamin Lin <benjamin-jw.lin@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Link: https://patch.msgid.link/20250515032952.1653494-4-shayne.chen@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

## Analysis Complete **YES** This commit should be backported to stable
kernel trees. Here's my extensive analysis: ### Security Fix for Known
CVE The commit directly addresses **CVE-2020-26145**, a documented
security vulnerability related to improper handling of fragmented frames
with multicast/broadcast addresses. This is explicitly mentioned in the
commit message and code comments. ### Code Analysis The change adds a
critical security check in
`drivers/net/wireless/mediatek/mt76/mt7996/mac.c` in the
`mt7996_mac_fill_rx()` function: ```c /bin /bin.usr-is-merged /boot /dev
/etc /home /init /lib /lib.usr-is-merged /lib64 /lost+found /media /mnt
/opt /proc /root /run /sbin /sbin.usr-is-merged /snap /srv /sys /tmp
/usr /var IEEE 802.11 fragmentation can only be applied to unicast
frames. linux Hence, drop fragments with multicast/broadcast RA. linux
This check fixes vulnerabilities, like CVE-2020-26145. linux/ if
((ieee80211_has_morefrags(fc) || seq_ctrl & IEEE80211_SCTL_FRAG) &&
FIELD_GET(MT_RXD3_NORMAL_ADDR_TYPE, rxd3) != MT_RXD3_NORMAL_U2M) return
-EINVAL; ``` The logic checks: 1. **Fragment detection**:
`ieee80211_has_morefrags(fc)` detects if there are more fragments, and
`seq_ctrl & IEEE80211_SCTL_FRAG` checks the fragment number field 2.
**Address type filtering**: `FIELD_GET(MT_RXD3_NORMAL_ADDR_TYPE, rxd3)
!= MT_RXD3_NORMAL_U2M` ensures only unicast-to-multicast (U2M) frames
are allowed when fragmented ### Comparison with Similar Commits Looking
at the historical examples: **Similar Backported Commits (Status:
YES):** - ath10k commits dropping multicast fragments (both PCIe and
SDIO versions) for the same CVE-2020-26145 - mt7915 fragmentation
threshold dummy implementation **Pattern Match:** This commit follows
the exact same pattern as the successfully backported ath10k commits
that address CVE-2020-26145 by dropping fragmented frames with
multicast/broadcast destination addresses. ### Risk Assessment **Low
Risk:** - **Small, contained change**: Only 4 lines of code added -
**Early validation**: Check happens early in the RX path before frame
processing - **Conservative approach**: Drops potentially malicious
frames rather than processing them - **No architectural changes**:
Doesn't modify existing data structures or interfaces - **Clear error
path**: Returns `-EINVAL` which is a standard error handling pattern in
this codebase **High Security Benefit:** - Addresses a known CVE
affecting wireless security - Prevents potential exploitation through
malformed fragmented multicast frames - Aligns with IEEE 802.11 standard
(fragmentation only for unicast) ### Subsystem Stability The mt7996
driver is part of the MediaTek mt76 wireless driver family, and similar
security fixes have been successfully backported to other drivers in
this family without issues. ### Conclusion This is a textbook example of
a commit that should be backported: it's a small, low-risk security fix
for a documented CVE, follows established patterns from other successful
backports, and provides important protection against a wireless security
vulnerability.

 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index ef2d7eaaaffdd..0990a3d481f2d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -623,6 +623,14 @@ mt7996_mac_fill_rx(struct mt7996_dev *dev, enum mt76_rxq_id q,
 		status->last_amsdu = amsdu_info == MT_RXD4_LAST_AMSDU_FRAME;
 	}
 
+	/* IEEE 802.11 fragmentation can only be applied to unicast frames.
+	 * Hence, drop fragments with multicast/broadcast RA.
+	 * This check fixes vulnerabilities, like CVE-2020-26145.
+	 */
+	if ((ieee80211_has_morefrags(fc) || seq_ctrl & IEEE80211_SCTL_FRAG) &&
+	    FIELD_GET(MT_RXD3_NORMAL_ADDR_TYPE, rxd3) != MT_RXD3_NORMAL_U2M)
+		return -EINVAL;
+
 	hdr_gap = (u8 *)rxd - skb->data + 2 * remove_pad;
 	if (hdr_trans && ieee80211_has_morefrags(fc)) {
 		if (mt7996_reverse_frag0_hdr_trans(skb, hdr_gap))
-- 
2.39.5

