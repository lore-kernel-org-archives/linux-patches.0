Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E093F4DE72D;
	Thu, 17 Sep 2026 16:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661002; cv=none; b=SycBtwSiT550W+lUYq3C8s7OzhYjblmvxjoCTnV2StHVzDBK1Gjk57ybwo8hLnzmLDdSLvxsOKbME3IdUSuy5cZX2q8FAEMZIPnrbUg1mp/eGnOS5CJ3V443IW3gF5fwYTeLfsHU7unI1LOFIr+z1vgGAkobJlW6RqSUz21VoFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661002; c=relaxed/simple;
	bh=QyEk33O27+TubYDDZIicAxLKmCDL24/7EpxdA8z6Bx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIsatIqMmzcmmFds0Q28qQ+uqqxrdwf+7ePuAzoFKtpneAIMbxeqPB2ztJ7DZ9/0UsujTzOp/jRZNJUslESjxS8xUhpcCsHw9WAmaDr4agCYXcHxO1bljEALbQTQilZfUGeHyXqnMEAaYhc3I0sF0XBRGG6AFnQYzJq/2pOk9qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SzpEbKMi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SzpEbKMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C6D1F000FF;
	Thu, 17 Sep 2026 16:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661000;
	bh=b/ueXLN14pJbzkQYDBET/yTzM5hz1+GyfN/mqBqhvcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SzpEbKMic+ODe4WSVDnqHMhTjqeZtMJdqu/0QuxygWHJc5XGRkENuEfmuZSgMWY13
	 K0JE6M7pu8UVPvLWWEYXIruBa69OBxxhXrHp+/AFHx5NY0MDSJc4aVVAadxhH2cTiw
	 2+f3R6IL35JMrQ5OOgztnFKV5hQTyF4ZVDULmdZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Riccardo Boninsegna <rboninsegna2@gmail.com>,
	Sean Young <sean@mess.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0050/1250] media: rc: mceusb: Add support for 04eb:e033
Date: Thu, 17 Sep 2026 15:57:25 +0100
Message-ID: <20260917151553.296185428@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Riccardo Boninsegna <rboninsegna2@gmail.com>

[ Upstream commit 0692c2602e4cd410aa045f8991bd1c142b2e56f9 ]

This is a Sonix SN8P2202XG microcontroller with firmware compatible with
the already supported Northstar 04eb:e004, implementing an MCE IR receiver
(PCB seems to be tracked for a transmitter too but missing related parts).

Found in a Skintek SK-CR-IN+IR ( http://www.skintek.it/SK-CR-IN+IR.php )
internal 3.5 inch USB card reader and MCE receiver combo
(implemented by, and wired as, separate USB devices)
PCB marking: AU6475 966816 STIR REV:A02 MCE

Signed-off-by: Riccardo Boninsegna <rboninsegna2@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/mceusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index a4c94fdf767ca..bee5cd15796fb 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -397,6 +397,8 @@ static const struct usb_device_id mceusb_dev_table[] = {
 	{ USB_DEVICE(VENDOR_COMPRO, 0x3082) },
 	/* Northstar Systems, Inc. eHome Infrared Transceiver */
 	{ USB_DEVICE(VENDOR_NORTHSTAR, 0xe004) },
+	/* Northstar Systems, Inc. eHome Infrared Transceiver - variant */
+	{ USB_DEVICE(VENDOR_NORTHSTAR, 0xe033) },
 	/* TiVo PC IR Receiver */
 	{ USB_DEVICE(VENDOR_TIVO, 0x2000),
 	  .driver_info = TIVO_KIT },
-- 
2.53.0



