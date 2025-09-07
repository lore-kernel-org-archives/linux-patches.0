Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1AC14BFA2;
	Sun,  7 Sep 2025 20:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276159; cv=none; b=n2G2LXtrnx9PONAlLmq+M/biP1BJmaiICwPdVI2X3StMz8Y+hnSeF49vGpvprJSPkA46NQ4J5OpGnZzQYix3doEMvtRUVRH0MVuC/rKX6LOF5uCgqOMy932GFA9Vt4S0rIHl7SYpVXc2PEDypMaa+eDr83zbas7E6Y1HOpMoedo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276159; c=relaxed/simple;
	bh=Jvr/QMrh03N2p3R5FOu7NYDAozbX6Dx2ntneFMG1AGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjeadfOXyVwhr2asytTtYez5RpgdzHNTEhBctiVDsV+1XsrKLhCw6e5DA7ma9lQ0fdMUOEccLYjOzWkYIU6C/6dzIAnWMdKcZmv1MzCY9+/0Caqnapqm9t2WzcZg/rKtiMGTa/AUeUtqtX0KXM7XZKTP5mvljv3VmuTJCt939Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bXWB4bz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bXWB4bz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A67EC4CEF0;
	Sun,  7 Sep 2025 20:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276159;
	bh=Jvr/QMrh03N2p3R5FOu7NYDAozbX6Dx2ntneFMG1AGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bXWB4bzcHE6zZDDm1JtOMhNDVGLb1X8buOvwQNVgkVIB6WANtLun4zTVNEi/t0/Z
	 u22JQWGwnC7GsIiq6Fr/oNmZKx610oTo+qwpLWgCRl88mwhAitsbtrLQhx/RBOx3cf
	 0bofHijDQ4YlNSOBHinYklcRpmKEfDzXvOUAUNHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lubomir Rintel <lkundrak@v3.sk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 008/104] cdc_ncm: Flag Intel OEM version of Fibocom L850-GL as WWAN
Date: Sun,  7 Sep 2025 21:57:25 +0200
Message-ID: <20250907195607.888965757@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lubomir Rintel <lkundrak@v3.sk>

[ Upstream commit 4a73a36cb704813f588af13d9842d0ba5a185758 ]

This lets NetworkManager/ModemManager know that this is a modem and
needs to be connected first.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Link: https://patch.msgid.link/20250814154214.250103-1-lkundrak@v3.sk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_ncm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 9eb3c6b66a38b..c3b1e9af922b1 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -2042,6 +2042,13 @@ static const struct usb_device_id cdc_devs[] = {
 	  .driver_info = (unsigned long)&wwan_info,
 	},
 
+	/* Intel modem (label from OEM reads Fibocom L850-GL) */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x8087, 0x095a,
+		USB_CLASS_COMM,
+		USB_CDC_SUBCLASS_NCM, USB_CDC_PROTO_NONE),
+	  .driver_info = (unsigned long)&wwan_info,
+	},
+
 	/* DisplayLink docking stations */
 	{ .match_flags = USB_DEVICE_ID_MATCH_INT_INFO
 		| USB_DEVICE_ID_MATCH_VENDOR,
-- 
2.50.1



