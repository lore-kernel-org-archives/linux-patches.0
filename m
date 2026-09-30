Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AD94F7CC3;
	Wed, 30 Sep 2026 16:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784044; cv=none; b=qe+maOvu7lPUu8xhkVnQ7haU9ldLrjn7LJg/dQzcMsNMVDFtDr2At+Di6BTOW4pj1lm/fPkfrcBdc2MWoEGyvrzu+lYAwDmPROIAD5Ljqc4EwSK7bBXrX2G1q5xtsG//5cOgmv8uctT26QHfnb4fPUy0IJvDqOxsVDfHP7UbnbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784044; c=relaxed/simple;
	bh=vw5tYqm4/MXGj3S2o+Ef5aWWHHMFfphREcQGc3jePjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUvhY02+qdBKdbbHK4IkI5kYejhWZ/sSyvGGsmbGCkADLEioymu5+VHxKZi+s/RVYtHc2EDLI9PrCkVPKaZA/0JAdXQvPV1K4v/Jx6ywXiLqbjtXdx497Sve61zi96Pioy81dTIXQeNsUK9SXbn61TX/uLMthIK3t/Z0U9tqDc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bp5IM779; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bp5IM779"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511F71F000FF;
	Wed, 30 Sep 2026 16:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784039;
	bh=dL4bjmstPn4VKvMbdvQkS69QnATzLAcmjg3t/kHOCQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bp5IM779C9PtxSL9ntgWvw0ZV4Coe49LeRLBXqZLbXMkf57eHg25OOGHEDrXGdSei
	 ovcUf5VVmVRPqeRjfho7kVrinlxRGwsESkW8DmJ+7TlSvc9i78zIKqSwLYTAAyIX+s
	 2WKXtuhcapxz8lJOwLlNp4z2BxLfvuErMaXpzCNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Riccardo Boninsegna <rboninsegna2@gmail.com>,
	Sean Young <sean@mess.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/982] media: rc: mceusb: Add support for 04eb:e033
Date: Wed, 30 Sep 2026 17:12:32 +0200
Message-ID: <20260930152417.136719728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c76ba24c1f559..e74ca24a149b8 100644
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



