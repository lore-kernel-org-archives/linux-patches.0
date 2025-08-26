Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64C3350D7B;
	Tue, 26 Aug 2025 14:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218525; cv=none; b=iABeYZVzxFqHfek/8wqw8W72QhSIBEIm5V/kdEtLuxV8rTtf0XHJXNE+wTTC23fhXXwawdxnX9ZvmW1rcchHi/og7BjkNjq0o//3IH7HduLRPieCgKAKrKNFI7vWYZaMN1wbd5lGiCUCSJuxu4gnKBkY4thnEuVlpYiOtNL2/s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218525; c=relaxed/simple;
	bh=bNBb3/FCzoasehtV7FWsVrtde68gjNm6sbYoVGsaLFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uh0XXRE+OY8Xhdih9WgMAfmcUUFIX3x+bXp7dPMDjHv3r1MFgxRwvA5491eRbHpPp7mlbubds99OGEVc8/4PUEfpYKf77YnM2uj572YAjGjALkRIsfIMz7XaV0rclhy/VtJopBOyTEmHPEmTc/UXKpA4pg3/S0iQF2nVTAGL52U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FbTQiXn6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FbTQiXn6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6F3C4CEF1;
	Tue, 26 Aug 2025 14:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218525;
	bh=bNBb3/FCzoasehtV7FWsVrtde68gjNm6sbYoVGsaLFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FbTQiXn6bqnUfmSPuPD2e7grDqnUC45BC7h1sXDtk3dgE60n9nLLA37rC12zJlcnC
	 6VdMylMV/aAq13JceuiCGnyShJ7vlJ+fDrTKcBPt8OnvwPR984WXybtd20U4+7ynaz
	 BV80YII8LBJ+1CZAqCzzExr9JvZuIFMlnydRDl4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3f89ec3d1d0842e95d50@syzkaller.appspotmail.com,
	Oliver Neukum <oneukum@suse.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 033/403] usb: net: sierra: check for no status endpoint
Date: Tue, 26 Aug 2025 13:05:59 +0200
Message-ID: <20250826110906.728944622@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 4c4ca3c46167518f8534ed70f6e3b4bf86c4d158 ]

The driver checks for having three endpoints and
having bulk in and out endpoints, but not that
the third endpoint is interrupt input.
Rectify the omission.

Reported-by: syzbot+3f89ec3d1d0842e95d50@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-usb/686d5a9f.050a0220.1ffab7.0017.GAE@google.com/
Tested-by: syzbot+3f89ec3d1d0842e95d50@syzkaller.appspotmail.com
Fixes: eb4fd8cd355c8 ("net/usb: add sierra_net.c driver")
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20250714111326.258378-1-oneukum@suse.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/sierra_net.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
index 6f9ec5ce61dcc..a8f8134fab36c 100644
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -694,6 +694,10 @@ static int sierra_net_bind(struct usbnet *dev, struct usb_interface *intf)
 			status);
 		return -ENODEV;
 	}
+	if (!dev->status) {
+		dev_err(&dev->udev->dev, "No status endpoint found");
+		return -ENODEV;
+	}
 	/* Initialize sierra private data */
 	priv = kzalloc(sizeof *priv, GFP_KERNEL);
 	if (!priv)
-- 
2.39.5



