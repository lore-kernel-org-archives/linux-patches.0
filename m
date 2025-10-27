Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F07532D0D5;
	Mon, 27 Oct 2025 18:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590930; cv=none; b=MgDnJdYQjgRikE3rVmaIzrW1ezvXB5V+34/uAQPsQGs/qmDChw6QY6EzV1DdBnPhfzmvToA1rHX7We87803Qhcw0OLAOuzQORJf8BQunZpE1uqIo3QiUy041D0Dk47FnFTXHCcOdOtMg1tx19SwwbpQpE9lhWZRZqoMaAlkPD70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590930; c=relaxed/simple;
	bh=Tf5SOQt1+Hl4JjKJqfTJteceIxPAV06xju6Tybl305I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KO5vzAYDrmNyNSWLhxaqEPMUWlwWiQaBNM3yMtjEfISISngHpKU1pjK06lTjnczULBSp+yPQ7ppCuviDU6VDJy78+h6qSQYS8rsV7nOTjjIXnh2UqdSLdC/1g6apFMrAPBef9kN/HqmiSaRLgeKamiSut9SQ0s/Tag/GcDS3lHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jz/kGMf9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jz/kGMf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BDACC4CEF1;
	Mon, 27 Oct 2025 18:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590930;
	bh=Tf5SOQt1+Hl4JjKJqfTJteceIxPAV06xju6Tybl305I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jz/kGMf9AGk3vVccPQxIv9mcr595L6EgtlAQwUNQPrtCa4Eri1hl7hiBJeBfusiXu
	 A6hqY+8Tdoi7VUuYeNiYZF6QZlk2a8dSegmQqEtDLSZkjJWX3ZpaH/QJutX7qQh6X1
	 CKoyYiAK9jZHRx10rqcd9NL4fWhieh/wSkwbYy4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tim Guttzeit <t.guttzeit@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>
Subject: [PATCH 5.4 203/224] usb/core/quirks: Add Huawei ME906S to wakeup quirk
Date: Mon, 27 Oct 2025 19:35:49 +0100
Message-ID: <20251027183514.222241342@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -462,6 +462,8 @@ static const struct usb_device_id usb_qu
 	/* Huawei 4G LTE module */
 	{ USB_DEVICE(0x12d1, 0x15bb), .driver_info =
 			USB_QUIRK_DISCONNECT_SUSPEND },
+	{ USB_DEVICE(0x12d1, 0x15c1), .driver_info =
+			USB_QUIRK_DISCONNECT_SUSPEND },
 	{ USB_DEVICE(0x12d1, 0x15c3), .driver_info =
 			USB_QUIRK_DISCONNECT_SUSPEND },
 


