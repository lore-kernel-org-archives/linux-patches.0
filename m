Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F661CF5C6;
	Wed,  7 May 2025 19:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644838; cv=none; b=dnuQMgkloSJDioUxSsil8zY6yu25ac4KQliAYHA7r/dC1Vai+q5+NwC3ogchrbyStBc1EN/penINdnVVrgQkvqDqlb+mw8Fl4RsCAsqHgx02Me9fE+pTsmD+xp14GdbKKz0Ksda8WJ6h+KozRuV9e2HJhSwfQNqWtyD6gILgNsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644838; c=relaxed/simple;
	bh=VhBuYYqq3Y/x5kBInUQ2rkVyni+jqdZt7PJbPT9/Yi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSQD/MJBAFBQReyQgnCVjqEZUwmgygStaFxNn7OIXX/t08/ZBRcYdEI9XcFgLkbTReFEkE9icXuljqVaqcDAdVSrGOuXUQAsDtIM3q/VxHWllSHm/KNG09XDTFzBdHl7lV+kyfDw+yPN+87nqhMfpbGtKzpUQSzQulWrECLdCkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8qXMudg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8qXMudg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7465AC4CEE2;
	Wed,  7 May 2025 19:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644837;
	bh=VhBuYYqq3Y/x5kBInUQ2rkVyni+jqdZt7PJbPT9/Yi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8qXMudgj2tMKBBtq4aeS9Jksn473Rtk2jWfxWDIxbW8qjbkk+39vR8XsTMVfEWHR
	 KbvmS0wg1HwRf4Anz9wwCmbsmF6MK7yWPRKyefFAsp9LrMpHDYXKr8HeU30UrRaXwR
	 4UPwNiX6SmCfnGeAUAN52wJKlLA9ybBhgxo+JQpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lubomir Rintel <lkundrak@v3.sk>,
	Christian Heusel <christian@heusel.eu>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 001/129] Revert "rndis_host: Flag RNDIS modems as WWAN devices"
Date: Wed,  7 May 2025 20:38:57 +0200
Message-ID: <20250507183813.562915442@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

From: Christian Heusel <christian@heusel.eu>

commit 765f253e28909f161b0211f85cf0431cfee7d6df upstream.

This reverts commit 67d1a8956d2d62fe6b4c13ebabb57806098511d8. Since this
commit has been proven to be problematic for the setup of USB-tethered
ethernet connections and the related breakage is very noticeable for
users it should be reverted until a fixed version of the change can be
rolled out.

Closes: https://lore.kernel.org/all/e0df2d85-1296-4317-b717-bd757e3ab928@heusel.eu/
Link: https://chaos.social/@gromit/114377862699921553
Link: https://bugzilla.kernel.org/show_bug.cgi?id=220002
Link: https://bugs.gentoo.org/953555
Link: https://bbs.archlinux.org/viewtopic.php?id=304892
Cc: stable@vger.kernel.org
Acked-by: Lubomir Rintel <lkundrak@v3.sk>
Signed-off-by: Christian Heusel <christian@heusel.eu>
Link: https://patch.msgid.link/20250424-usb-tethering-fix-v1-1-b65cf97c740e@heusel.eu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/rndis_host.c |   16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -630,16 +630,6 @@ static const struct driver_info	zte_rndi
 	.tx_fixup =	rndis_tx_fixup,
 };
 
-static const struct driver_info	wwan_rndis_info = {
-	.description =	"Mobile Broadband RNDIS device",
-	.flags =	FLAG_WWAN | FLAG_POINTTOPOINT | FLAG_FRAMING_RN | FLAG_NO_SETINT,
-	.bind =		rndis_bind,
-	.unbind =	rndis_unbind,
-	.status =	rndis_status,
-	.rx_fixup =	rndis_rx_fixup,
-	.tx_fixup =	rndis_tx_fixup,
-};
-
 /*-------------------------------------------------------------------------*/
 
 static const struct usb_device_id	products [] = {
@@ -676,11 +666,9 @@ static const struct usb_device_id	produc
 	USB_INTERFACE_INFO(USB_CLASS_WIRELESS_CONTROLLER, 1, 3),
 	.driver_info = (unsigned long) &rndis_info,
 }, {
-	/* Mobile Broadband Modem, seen in Novatel Verizon USB730L and
-	 * Telit FN990A (RNDIS)
-	 */
+	/* Novatel Verizon USB730L */
 	USB_INTERFACE_INFO(USB_CLASS_MISC, 4, 1),
-	.driver_info = (unsigned long)&wwan_rndis_info,
+	.driver_info = (unsigned long) &rndis_info,
 },
 	{ },		// END
 };


