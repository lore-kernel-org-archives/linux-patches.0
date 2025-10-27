Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9AC23D2A3;
	Mon, 27 Oct 2025 19:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592400; cv=none; b=EOpqbhRiioTR3BmpxmwNgJgYLk2y+zfByGHOOTEequ1gXkODqwQTkfsiGlj5llol0rRDoA9Bg5zUPtVehwpG1Aydt0f/d368mcxZvqEiao8vY3KX+LKVlPqIgBxb+qhvzMmFVDtoS/UBObr4AQ/MEkBOjEaGJOxpHFxmAGzZZ7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592400; c=relaxed/simple;
	bh=/DirF/mrB+DlRqJxMUmr4+hViC5JE+d7r1CPpCTFDDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPCIgYoyIe3W3kXh2vsJcb6yxb7T1tKep4m2H4cA+CXYA3jlpowK+tX7UDjz28xejrdPBkdPhnOGI4uF6PGns7d3cl7CW9n92QO/jnCOPmUhgXijgkFqGeIM9kQUAeYNnDbQQOVcAqrEWQm7L4/nv6FmR2/rwU2Wcr1vEj0tAW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kzJqAeRo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kzJqAeRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E464CC4CEF1;
	Mon, 27 Oct 2025 19:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592400;
	bh=/DirF/mrB+DlRqJxMUmr4+hViC5JE+d7r1CPpCTFDDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kzJqAeRoOIB3BM4ehzW+yuHAJMIbDG43v7bWWb0ijM6m6qiFaw6xXaUx76DV21SKu
	 l67XwdkJ6FfQmxmJ2sSiS0KG2Ulw4HNI3H3IIUzhP1bRrq1RZ8jM/LsgM6MQV9AbF9
	 XS18DZD7L7O5AwX5suwIJZQgZ7cd/OHttXEPs2yk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tim Guttzeit <t.guttzeit@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>
Subject: [PATCH 6.1 106/157] usb/core/quirks: Add Huawei ME906S to wakeup quirk
Date: Mon, 27 Oct 2025 19:36:07 +0100
Message-ID: <20251027183504.099267621@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
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

From: Tim Guttzeit <t.guttzeit@tuxedocomputers.com>

commit dfc2cf4dcaa03601cd4ca0f7def88b2630fca6ab upstream.

The list of Huawei LTE modules needing the quirk fixing spurious wakeups
was missing the IDs of the Huawei ME906S module, therefore suspend did not
work.

Cc: stable <stable@kernel.org>
Signed-off-by: Tim Guttzeit <t.guttzeit@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20251020134304.35079-1-wse@tuxedocomputers.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -464,6 +464,8 @@ static const struct usb_device_id usb_qu
 	/* Huawei 4G LTE module */
 	{ USB_DEVICE(0x12d1, 0x15bb), .driver_info =
 			USB_QUIRK_DISCONNECT_SUSPEND },
+	{ USB_DEVICE(0x12d1, 0x15c1), .driver_info =
+			USB_QUIRK_DISCONNECT_SUSPEND },
 	{ USB_DEVICE(0x12d1, 0x15c3), .driver_info =
 			USB_QUIRK_DISCONNECT_SUSPEND },
 


