Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001E551DDE9;
	Wed, 30 Sep 2026 18:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793901; cv=none; b=KKk91cQh6cUFn1zhc9pbrsSX3Aq21r4LhXFGcgCDrfVb0w8azSjoGDZUJNIa51WXUydkxbqXj4TXZvURCIYZ42DhNJkf60l6Zgbv1B0Cj4RajAsRxjPAIScNETzMmlRr7ZGs7YkffgCW+2IwKnsXV/p9LU+yD75W0YZU1oZjxuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793901; c=relaxed/simple;
	bh=l2h0w1v5bpvwQFivKYrqmaKnz4l+YjgP1ZaMAdKNXfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s6is9QYrCUJHyas48wjwknAJloo2SQ54VyrnsSEMaTRTXsFme2rVuC35M84g5Mp3IHk1vnvd+bWGAax1uqwDFMvQAx2XAdvp+EwUlhvpOM8N4rZNpPdW1VKfTCoGGCz6sSqQzZRbLcxF0r9mFUUGlKl36B2o+EByUlmg7+AoxQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lo300k6D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lo300k6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0288E1F000FF;
	Wed, 30 Sep 2026 18:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793898;
	bh=7S+6BVhIdfMwOQfeoP5ORZN9FDY4qoWW04IZhIfFgww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lo300k6DSArJHH92CQJ4mgD+dzDtq/E44gSIdcw6IOchIPxoF0vh6yW4WcwE+H6O3
	 4jD40zRPIJ73RLIBcaQ+jQX3yli1Gerulg6XkUty3YZSU0q0b5bYuDFXm6/F35KkPh
	 6fQz8AHYAIyhqT9u6KQdvjZjelz7yKu5bx8Y/Cms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Riccardo Boninsegna <rboninsegna2@gmail.com>,
	Sean Young <sean@mess.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0022/1193] media: rc: mceusb: Add support for 04eb:e033
Date: Wed, 30 Sep 2026 17:11:46 +0200
Message-ID: <20260930152434.789362633@linuxfoundation.org>
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
index 4115a46929c47..3e5c2aa582cff 100644
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



