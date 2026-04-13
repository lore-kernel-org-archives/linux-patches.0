Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B6A2F8BC3;
	Mon, 13 Apr 2026 16:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097430; cv=none; b=dCE0VlbRcb3+/1/3fv6cxiZ8IylodXDUvOb1GLjwMoOOKZNLY/WaKaYLnb/khiCNQtnZIxzLkigWyACo22kfQXpyuzG6aRIGm7kNa0AY/HdEkuOjk1a9tgq3EzGZu0lC8gTnLOpPLNk3U6EL66IybFp7/dmBl29GQxbZGlw/4Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097430; c=relaxed/simple;
	bh=Vc9KChwtCqiwLTxH6/O41xRFos9nqr9A5Iej+KistZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ID8/nfNdmjTQkUHbU5sulip0M0sTWQypmPbzKZFGQA8w3vWv46pjk+hSwLaz9GXw80QxN3T3NrIaaVfDisWCX10XulMuqvPh04oJxm20scqFGSwsAi9+UNpn0J6O/CsU8bm3TCU8fqa2OHBQForMJkHBv6XgHFKDOsjoHPNQpME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZGERWDoO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZGERWDoO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0956C2BCB0;
	Mon, 13 Apr 2026 16:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097430;
	bh=Vc9KChwtCqiwLTxH6/O41xRFos9nqr9A5Iej+KistZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZGERWDoOsxk9H1iNPcE0Tn8Ual+86empwaoNFDKpjrMKtTh99aQ0vp8wNQyWCtu33
	 gCpUlPys1vstIPZHgc3DKz3FIUtdIdejpCeMHN6VaeTxwAt4qH2U1Jxt7epFUu/TmK
	 LtXXDvr/KHrzyhvFOztEdcvN2wTa1VpROfw8qJrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>
Subject: [PATCH 5.15 134/570] usb/core/quirks: Add Huawei ME906S-device to wakeup quirk
Date: Mon, 13 Apr 2026 17:54:25 +0200
Message-ID: <20260413155835.463483855@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
@@ -205,6 +205,10 @@ static const struct usb_device_id usb_qu
 	/* HP v222w 16GB Mini USB Drive */
 	{ USB_DEVICE(0x03f0, 0x3f40), .driver_info = USB_QUIRK_DELAY_INIT },
 
+	/* Huawei 4G LTE module ME906S  */
+	{ USB_DEVICE(0x03f0, 0xa31d), .driver_info =
+			USB_QUIRK_DISCONNECT_SUSPEND },
+
 	/* Creative SB Audigy 2 NX */
 	{ USB_DEVICE(0x041e, 0x3020), .driver_info = USB_QUIRK_RESET_RESUME },
 


