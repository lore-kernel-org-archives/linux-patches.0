Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E524189BB0;
	Sun,  7 Sep 2025 20:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276604; cv=none; b=ass7TjG8pFCf/W7EKWXchCqkIt0cwx+zIxU+ObJM8H8I+B93OLz8QGtmO3SXRYsnTBKYl7g1bHjb1mv1cUYsCxZONk1FLYmeYxHS3v7y3ZoNYdjInQqjD1E3ejEWZTEMbAsJjz5V/E/EZL3cC0Pzq3Lb55NrYGRmQqYv79X7/NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276604; c=relaxed/simple;
	bh=mYwqtVtS4hYp2PvfFIUuKIsnfL9IVIST7HIXCnhcFSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b7AyM4EIYrNezybSVMMt3TaSM4t8CytJIzPMZ2EcZGmZ9IlhjUGG6GeC5yufmzzm7omGx7dyKVHEi+Rgdl8V4lAKfBWIMHQn6Ez4O7Ntlz2gzcLdkmbA18VPgjupKQw/tLCF7fOCv0qPtLWWXBofmDhxOTfVEmdBXCWiqenqVZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1ryuJuF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1ryuJuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA09FC4CEF0;
	Sun,  7 Sep 2025 20:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276604;
	bh=mYwqtVtS4hYp2PvfFIUuKIsnfL9IVIST7HIXCnhcFSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1ryuJuFvI7ii1k3PdEESn/wc3k9J709nOFxVWYe2N3Bw+Gh4CcUuaJPCrLiMu2MT
	 AOguEDj550/Tr3rumhtnl8Ns3XUBvFVuG4VqUOFirpo114nGU3X+y9jBF4/ptSFuYm
	 FIyUK4S3yM2vEJHUMqt1XkFmLx5YMkRBTgN5EL0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lubomir Rintel <lkundrak@v3.sk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/121] cdc_ncm: Flag Intel OEM version of Fibocom L850-GL as WWAN
Date: Sun,  7 Sep 2025 21:57:25 +0200
Message-ID: <20250907195610.055293580@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d9792fd515a90..22554daaf6ff1 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -2043,6 +2043,13 @@ static const struct usb_device_id cdc_devs[] = {
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



