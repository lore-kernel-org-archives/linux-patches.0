Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025765;
	b=xVvJgWTOS2KoxNKDLRZoDFbfaq39BzDtUctn4+mje6I7X7fmeMy67ucpDz8kJ4WoEx0/
	 rCz/D5kvVL0IqnN3kcwDgmbyPkJu6wUQYsOaeMrUEhf8WivTDyZTz0cJB3CSSLku+Z+MF
	 iFyK8dkAXxsIamQG66KERhzRdKUSHvV7hY+PmyRC4WuRjELJOsqiDIjVHmMkNaYgBv+dh
	 EPKNhrEz6ctvq8C0d8hjeIDo2lVX55j66eMKIcsWqbF1VPdFsqfM5IwnSAH5pUPNIQNhr
	 JYbn3CKuXc83BQZvkImjS8ucX7DUrpi9FAXqVVttipukz3BvlKSEaCZ2u0RBEmIBBKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025765;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kp8TM+Ic/oOkT0V4qS/un76oHoCrkqB+wlnuAzeaFqs=;
	b=Yi1u77IKE652add9JdUuNk97W77Xa4nc/23WR2KxaG9yqjnAqiCxufPteQKy3IOvNht8
	 Vy1yi5CHnCEiozFCRy9axfOmzQNof8uwOa81hIo1yCGAhwQyrEDEyqXJ8eL2stNCUIB8u
	 JrrttJn+1w52oolfq+abuL2Uz7yyjWQ1TL7hCZ/ODkewJILggRYXlXH0hLBogGvvC7LKx
	 rG4nxXToLG9E4/Krzpd8MZlKm24bXQvHqc2AwPQlkC+IobqQJXJotS+y/sRAZohG9Pzch
	 u3KF/dEuvpYclCt0aJ/t1kMKbYu142yccv4HbVY2iZ3G54TZXyTJ8//ArSqdOsvpt1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="e/XB7FYs";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53926606A31C;
	Wed, 18 Nov 2026 18:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e/XB7FYs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4BC01F000C7;
	Wed, 18 Nov 2026 18:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025765;
	bh=Kp8TM+Ic/oOkT0V4qS/un76oHoCrkqB+wlnuAzeaFqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e/XB7FYsHBCpBFzTeBvQOhoIqRS8lBadI67hAzjuskJ2Kas2r/DZdf2C/AqhTBIUV
	 RxhS6purvGsFEZQygxZwxk74u2mc1/WJyzU68MzsMeyqyFEYN4D1KdQf1FRd5HaOFM
	 DdMxmNtV9XflRzo9cQ1cXdtOwj1cXD0itsKp6yms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1193/2151] wifi: mt76: set MT76_SCANNING when starting a hw scan
Date: Wed, 18 Nov 2026 15:48:48 +0100
Message-ID: <20261118150205.675672698@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 6ff1c217a00335c92aa6a9b35b3ff3b128efbfea ]

The scan state bit is cleared by mt76_scan_complete(), but nothing ever
sets it: mt76_sw_scan() is only called for drivers without hw scan
support. As a result, all MT76_SCANNING checks are inert for drivers
using mt76_hw_scan(), including the DFS state handling in
mt76_phy_dfs_state() and the guard against manually triggered radar
detection while scanning.

Set the bit when the scan request is accepted. Since every channel
programmed while scanning now evaluates the DFS state as disabled and
stops the radar detector, re-program the operating channel at scan
completion regardless of the off-channel state, after the scanning bit
has been cleared. Otherwise a scan whose last visited channel was the
operating channel, or one that returned to it early because of
associated stations, would leave radar detection stopped until the
next channel switch.

Fixes: 31083e38548f ("wifi: mt76: add code for emulating hardware scanning")
Link: https://patch.msgid.link/20260724124813.3961474-27-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 3aaa4871006d ("wifi: mt76: clear offchannel state if a scan has no channel to restore")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/scan.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/scan.c b/drivers/net/wireless/mediatek/mt76/scan.c
index a8a038737de7a..8b6dcbd3f1d5b 100644
--- a/drivers/net/wireless/mediatek/mt76/scan.c
+++ b/drivers/net/wireless/mediatek/mt76/scan.c
@@ -16,10 +16,17 @@ static void mt76_scan_complete(struct mt76_dev *dev, bool abort)
 
 	clear_bit(MT76_SCANNING, &phy->state);
 
-	if (dev->scan.chan && phy->main_chandef.chan && phy->offchannel &&
+	/* Re-program the operating channel even when the scan never left it:
+	 * any channel set during the scan ran with MT76_SCANNING held, which
+	 * left DFS radar detection disabled
+	 */
+	if (phy->main_chandef.chan &&
 	    !test_bit(MT76_MCU_RESET, &dev->phy.state)) {
+		bool offchannel = phy->offchannel;
+
 		mt76_set_channel(phy, &phy->main_chandef, false);
-		mt76_offchannel_notify(phy, false);
+		if (offchannel)
+			mt76_offchannel_notify(phy, false);
 	}
 	mt76_put_vif_phy_link(phy, dev->scan.vif, dev->scan.mlink);
 	memset(&dev->scan, 0, sizeof(dev->scan));
@@ -212,6 +219,7 @@ int mt76_hw_scan(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	dev->scan.vif = vif;
 	dev->scan.phy = phy;
 	dev->scan.mlink = mlink;
+	set_bit(MT76_SCANNING, &phy->state);
 	ieee80211_queue_delayed_work(dev->phy.hw, &dev->scan_work, 0);
 
 out:
-- 
2.53.0



