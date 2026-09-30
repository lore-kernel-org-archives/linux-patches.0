Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519D53264C2;
	Wed, 30 Sep 2026 17:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790606; cv=none; b=iMuA/rKUeHlQdrjNj7WsW8E/Z1GeCt/YE7pDYLLSRYcyrIlOX/sQTLxBf7WtUn1CQBsmnyIPtYLs8LXZmv7rF2V1DQgIBqAXxIZ3nzpKFAWTBcVb8xkP++kxCjdMeypgZ0KA5pvinWXeNI4g7PH9C84YjHbwWSTHQktrAldw75A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790606; c=relaxed/simple;
	bh=OohPtmHIiL7yz4w/nZPnSPTDIs4Ztk95z2ul6e8dQqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIb1UyJeenQ7oHb7ShjA0MAQ2Ws4BOyqyZjEAeyXcczgS0Wq1m0kRL2fJDFE43sdwtLIb9ZpUZi1714tXa9fMa3LK21JLtjFurx6UiFV7Vz60GNfr6kG7XWIqMOyRGvTb/oSWggfNTDFI/ssScFLDrBiwIk7IzY4YaQmoBZtKqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YyW/hWrR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YyW/hWrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5B01F000FF;
	Wed, 30 Sep 2026 17:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790605;
	bh=cKdt6S5HHYYwlx+VE68hLWtb//zuDPRS7lBh8QwQ+94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YyW/hWrRead3MuG/5du2vGhDfjrL1kb7iIac1HTBztzw5U1o+Gs7fARoJ/TL9I1NQ
	 nrlFURli1KruSs3YIrR8WeOyjz+5VlRZv0/EwtHIIk+BjSWhFsqo2LhHdXsyFfOcdC
	 o51pMhvK54EB1DFQAU4d0U4LQU6UwRVjkNAY27KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Riccardo Boninsegna <rboninsegna2@gmail.com>,
	Sean Young <sean@mess.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/752] media: rc: mceusb: Add support for 04eb:e033
Date: Wed, 30 Sep 2026 17:18:01 +0200
Message-ID: <20260930152358.392256739@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 391de68365f67..6b42cefa7b3e7 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -398,6 +398,8 @@ static const struct usb_device_id mceusb_dev_table[] = {
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



