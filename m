Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 710524E77FD;
	Wed, 30 Sep 2026 15:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782346; cv=none; b=PnOlgz05ZgKwgvxB6n/Mnh08wZCc5eX9r8lcRzXB7yUNr5XHm49hEpUs2zqYttOThGGmuUOjK5yJux/EAiO2fYLKuKSDv3wqombgf3XsNwedgwyH/dfB5P0eHInON30HKSmJCUBTg1rNPIL1KfUPKCTJLGjlN2cpLHtD38+HpBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782346; c=relaxed/simple;
	bh=eDP03rqJzf7eBC3Yt1GHKzEkmSxV5yV0baFz/2hCX28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnpVN54Y3HhLrRiiEjVKKDEir3MewzKYo5tz/A8Sa3kMxuNJhy2hJeEyaJ14AdBP5JLO3gCJtZgE2CcTvGt1XOQ+4BL8eJDbHX+Xfzm5QiOfslqHBH/7+l7lvWM+XlWAZOEvPu6GP9sX9XRwqB9/KVaBBpcT8lcxYxR0XP78/eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cbq1qRbr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cbq1qRbr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14CD1F00898;
	Wed, 30 Sep 2026 15:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782334;
	bh=i5Q93Sk/S/6ZBWRNJyP+N6EC9ffu5vJ4FJgL5w9GKPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cbq1qRbrF++4q/H+yWkpV7+9+kmknQpHjGnZSsJoGVR8NMpQApErFUedA6wTP/pvz
	 pW/OO8sOgdbMVS1ujqe4TajgXRKgm/Z7oKwcNfBmn5oqN7bHLl11VdRcgXWyGwugVP
	 SqKIjemBana6sCCMVeCacwz27RCvS+E5v9i/HjFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Riccardo Boninsegna <rboninsegna2@gmail.com>,
	Sean Young <sean@mess.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/595] media: rc: mceusb: Add support for 04eb:e033
Date: Wed, 30 Sep 2026 17:18:24 +0200
Message-ID: <20260930152347.961747300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 142319c48405d..ec7794b4f5514 100644
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



