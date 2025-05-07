Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B151A00E7;
	Wed,  7 May 2025 18:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644386; cv=none; b=Gulk8WaPORX92+VIXDeHee7sb8a3+WHVqwOWgi/wlBjdCnxThgXAH7KyqaNggXwHgLq7AITyeuvpoxpO2Ed9yDi8QoDUoSXIXe7v0a8xiVw47UkwkSjAsqocrwqyJpU7emKh/j85W9c2mO4tcaptVv98sJ/HG6xyQj563JtVDL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644386; c=relaxed/simple;
	bh=Jj0pgvVvBP2/kYumAkXf3iSy8EIEm1hDwrd79jt5Qq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=krStlJkLT65KuKchGK00hklovj7zEjWx81O+ricFvLOSS8on47MVnXwgkIkySL1ZCk36COjVJPimYyMXG00fKNPRghrgcPMncAPfE5iaLdwH/VJT54/WGohFzFR475pTudu+T/I7dakk+KGp23GaAPZU30EiKJEJEy0llUmGiqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qw8I+ulc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qw8I+ulc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D21C4CEE2;
	Wed,  7 May 2025 18:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644386;
	bh=Jj0pgvVvBP2/kYumAkXf3iSy8EIEm1hDwrd79jt5Qq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qw8I+ulcHFN530vZ3NXBUS5HihhqMNJk6BVFOCS4AvN7nYIflAnYoHe9oQ4zan+MT
	 9R9oKn3TeY3I4PepUdh4rbnHN+ugoZCBXd1s+Hm86XrcxgSoR8UcNejWDYhOyf4noU
	 vs1s7tbUdXfINgr+G34oZXkV92EKvtAYqZDiU9l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lubomir Rintel <lkundrak@v3.sk>,
	Christian Heusel <christian@heusel.eu>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 007/164] Revert "rndis_host: Flag RNDIS modems as WWAN devices"
Date: Wed,  7 May 2025 20:38:12 +0200
Message-ID: <20250507183821.118775910@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


