Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063185;
	b=k6z4DWmV1c6O+393yJyNFVMD0IRXzIJZXImknFZ6prgHNWryF0twxd9DM17/R6AXMBti
	 k1dVrevvc5WISJMseiJnAm99bLqW648iKYkj04X4ZUUTikDQYFPytCXg1+CHdvZYkIqFJ
	 k6le/awuxPh9RPlQI1MoGQa3OUnDMWi52YI+afSKyK5VLPQvL3ozNPQbOCLGkpnFrhEMT
	 j6E1+DZinX7JG0InBZETYQEeoqWn/EiJM8OZxn1m7FZmi+B+rv5mCs3ebJsmH+BpHm2yZ
	 BvrU7qmBEhjba8+0RUZF3FjY/J10A3VEvPD9HK9SwzkGZf1LygsojXl4gQOShXsyKPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nGUVZIPUITDi5NpjOfdjUJc9M+S5upSUXejadCu9FXw=;
	b=T8c+RPwVGyTpJhF48oW48uKrIK1z3/cPfeoh3pH0BItOLvgjzih4BzVuiINKR691RgXv
	 E+cCeUxFyRsRiIsVWVNyhMKH8CpRQ2paEzRP0GcKmbmcvRt07d67g7M5V5Ov6pP2yy2D/
	 L1mMH29OwPp2e4MMVc1w50oVUMK6c5DV+lWjyQ8XFZLZPyvYWkx+8wJXRi1vumBaUvUkj
	 B0V1I8zEb6I30ikCQaNBxsBk5gk/6TuVKaxONybXrvo5t2zNgeFyUO7vSeCX/mxF27JFp
	 glErTXZ3Kp8Ql7skBU2/TszRtl3e+WJUf4qb3tMhEMoR3K1FOfP3uMVGTNyCe57jJAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1+F6U7Fi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB95606A330;
	Sat,  7 Nov 2026 14:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1+F6U7Fi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3BE1F0089F;
	Sat,  7 Nov 2026 14:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063185;
	bh=nGUVZIPUITDi5NpjOfdjUJc9M+S5upSUXejadCu9FXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1+F6U7Fifv2YC1kHWL/4BmY9UgiLcwI81gQDshE1erO6vr5YZa5J/GzriidnF8DOF
	 ncuzDiUzfnWkGUgvnvDdX/4vx+VSyE0GP3ndSp+1CPuljKDUELndGFk5odCgSvCmy7
	 NDI0O6tWLA7r7U3Ds+lHpRLm5ul2URjnx5GmajAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 402/869] wifi: mt76: mt7925: cancel mlo_pm_work on the USB stop path
Date: Sat,  7 Nov 2026 08:51:24 -0500
Message-ID: <20261107134907.014797899@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit 9f299215d1d835aeeee8b269dad09e1be06f856e ]

Every other teardown path cancels this work, PCIe unbind included. USB
unbind does not: PCIe has its own unregister hook for it, while USB
shares a generic one and the stop callback that would have covered it is
replaced in probe.

That cancel came in commit 81faf578320d ("wifi: mt76: mt7925: cancel
mlo_pm_work on stop"), whose last line says it covers both buses. That's
mine and it's a boo-boo.

Give the USB path its own stop that cancels the work first.

Two-link MLO on a Netgear A9000, work armed then the interface down:

                   stock    patched
    stop ran        3/3      3/3
    work still ran  3/3      0/3

Skipping the stop entirely leaves both builds running it, so the zero is
the cancel.

Fixes: 276a56883257 ("wifi: mt76: mt7925: update the power-saving flow")
Cc: stable@vger.kernel.org
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20261003234944.96066-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/usb.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
index 95047ee48a425..0ad86526dddc8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
@@ -132,6 +132,15 @@ static int mt7925u_mac_reset(struct mt792x_dev *dev)
 	return err;
 }
 
+static void mt7925u_stop(struct ieee80211_hw *hw, bool suspend)
+{
+	struct mt792x_dev *dev = mt792x_hw_dev(hw);
+
+	cancel_delayed_work_sync(&dev->mlo_pm_work);
+
+	mt792xu_stop(hw, suspend);
+}
+
 static int mt7925u_probe(struct usb_interface *usb_intf,
 			 const struct usb_device_id *id)
 {
@@ -178,7 +187,7 @@ static int mt7925u_probe(struct usb_interface *usb_intf,
 	if (!ops)
 		return -ENOMEM;
 
-	ops->stop = mt792xu_stop;
+	ops->stop = mt7925u_stop;
 
 	mdev = mt76_alloc_device(&usb_intf->dev, sizeof(*dev), ops, &drv_ops);
 	if (!mdev)
-- 
2.53.0



