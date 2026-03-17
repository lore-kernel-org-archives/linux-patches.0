Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271841ACEDE;
	Tue, 17 Mar 2026 17:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767633; cv=none; b=Mtr++3ZuZWC8cIxvf19Gu86V4XXSjHAYw94etckMigTYR+2p5/zmS7s+Ut3x+DK8Xua/3q9TwkLaFkYwjyz+Qh7yEma1SkzrXeUKzCfHmiutTl3DOvi7B9zrAVIobP8AROhIUE5Mx3+MabNssWBoVm9h9s+zPqjnlhadAvKmdzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767633; c=relaxed/simple;
	bh=M2W88/PYCFKcwtBmwO6hb3Yyia9olv5iw7AOAGeDYJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFPpi6lIBVgYTcAA555H30r1YvgXHlDB2KEQAeAA/IqLw+LKjahcACzYevlhLT8R/YQRMRVggDkEAcyi4NcthhHOUkEsLufTirixI5eDHAC+a3rOYPjdiCyX2yNBODlswZEUBwnaBEBGxlPWSNVpCsHQ/CGUtGcPpf6q2/rGpJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ioseGfkZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ioseGfkZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7CFC4CEF7;
	Tue, 17 Mar 2026 17:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767633;
	bh=M2W88/PYCFKcwtBmwO6hb3Yyia9olv5iw7AOAGeDYJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ioseGfkZ6gWRv3UCHOzMhugkY6JSVN0Lf5im7kglpxi/binkugenaT8KnjLZuQhhl
	 82MXYcvqqCGw86VERQis6LYX1mjF+11xu4iyc/nVfIGGuJVVhdozc7BzJyI+8LFPem
	 PIWQnTtg5Els+n4I1QxMzK10ny1AydkKt4z06R9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>
Subject: [PATCH 6.18 127/333] usb/core/quirks: Add Huawei ME906S-device to wakeup quirk
Date: Tue, 17 Mar 2026 17:32:36 +0100
Message-ID: <20260317163004.074641130@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Christoffer Sandberg <cs@tuxedo.de>

commit 0326ff28d56b4fa202de36ffc8462a354f383a64 upstream.

Similar to other Huawei LTE modules using this quirk, this version with
another vid/pid suffers from spurious wakeups.

Setting the quirk fixes the issue for this device as well.

Cc: stable <stable@kernel.org>
Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260306172817.2098898-1-wse@tuxedocomputers.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -208,6 +208,10 @@ static const struct usb_device_id usb_qu
 	/* HP v222w 16GB Mini USB Drive */
 	{ USB_DEVICE(0x03f0, 0x3f40), .driver_info = USB_QUIRK_DELAY_INIT },
 
+	/* Huawei 4G LTE module ME906S  */
+	{ USB_DEVICE(0x03f0, 0xa31d), .driver_info =
+			USB_QUIRK_DISCONNECT_SUSPEND },
+
 	/* Creative SB Audigy 2 NX */
 	{ USB_DEVICE(0x041e, 0x3020), .driver_info = USB_QUIRK_RESET_RESUME },
 


