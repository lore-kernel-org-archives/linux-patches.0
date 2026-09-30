Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE06C3C10BF;
	Wed, 30 Sep 2026 19:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794896; cv=none; b=fPAdjOuAbfAM356yhgzIeFLwulMnT+B45qGFCfm9EM22IFAMuqtMeV4VzozTCtF5CYrOSKndorXofy0L8KsbAUYBOqJW/qLKcUv0p0xJ/FLNRmxroqQj4ZPmw1Kx4HcXPBirn9C+BwY3dejdQW1kD2fKlfEff8gGLLWpSoRtfmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794896; c=relaxed/simple;
	bh=PSFrj+W+JbE+uoqz09A1VBQJ5Ve8wpeU7q8qJK2e/Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cUGsP0mL095gD4OzEMRgIENoDrKlzt2dKaOcK72E5P1HkH6GxIyG7OVs9r3lM5+3eWDMu15gxGqcDGTyLS6K7J2VavxsEvL3v2e9aokZ4gus57RKQZYzg5qLwvImGsfkzD5uaXw+k4W+YU6PQTtv27Yk4b08OmhhttdSAh6fZAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IYo1i35Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IYo1i35Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028551F00898;
	Wed, 30 Sep 2026 19:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794895;
	bh=UG2Q5rT1BuA+j6K3MjsgRJ7VnkcwYAKXisIIA5mZkBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IYo1i35QQjq+l9uRQo9i9sM6DKxIYSd7zrfOgpSwiBohQRuf6oYi5nCDAoO8Yo8A3
	 NuHCjAeAazH1C4bTc3MnJJ7GjWlz9gCJRpeBP5aXR9OUITVe1i1AQgdq5RuxQrVqsI
	 BP3ZjIR95S/cX4kliqRFUDgCN8EbaZlNaAfe0W14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0369/1193] Revert "Bluetooth: btusb: Add ASUS USB-BT600 for Realtek 8761CU"
Date: Wed, 30 Sep 2026 17:17:33 +0200
Message-ID: <20260930152442.376982798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

This reverts commit 0725f93b395f731a9d014235816f5312c21ba4ea.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index d1f3306172df0..872c3b473f039 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -756,8 +756,6 @@ static const struct usb_device_id quirks_table[] = {
 	/* Additional Realtek 8761CU Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x1bef), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
-	{ USB_DEVICE(0x0b05, 0x1d70), .driver_info = BTUSB_REALTEK |
-						     BTUSB_WIDEBAND_SPEECH },
 
 	/* Additional Realtek 8821AE Bluetooth devices */
 	{ USB_DEVICE(0x0b05, 0x17dc), .driver_info = BTUSB_REALTEK },
-- 
2.53.0



