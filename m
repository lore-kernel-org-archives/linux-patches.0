Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C785976905;
	Wed, 21 Feb 2024 13:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522767; cv=none; b=d/JwR0CukKluPZ+pGlqYcA+2TBcMyYep4HQfgudSckokKHauulp4W4NetADosvH1EORAy9BL8ZsjEzLqEt6XineJpT1ESJtVRXN6PLLRZKyBrOgmJ1+hnFYb1R4m5g5GnNAMqh2tOk2WQeu1N8XgGnIlQm005Ph41F0vY+EMyVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522767; c=relaxed/simple;
	bh=uexB/BOl9CZ45P2SdCF6trZt+pdvPW7SmvuzWPHY404=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+5ggNYtvSEoUDfvRAd1ea0SeafteUIQhmyxk9K8M8sdkT0c5FCvOhN7Q49+P6AMLJPms+xnJZc0w7LDOuk6XwdP4TXYieQ1KZH+61c53WzACbXioYti2qOzX4fOYTD6Sp9qSwN7lT9EVuVnvcozGIIft+3psRQddYFecBc0Qdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BrupfLk7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BrupfLk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547EAC433C7;
	Wed, 21 Feb 2024 13:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522767;
	bh=uexB/BOl9CZ45P2SdCF6trZt+pdvPW7SmvuzWPHY404=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BrupfLk7cm3m88febVVdX2IsVaY//VTXAg20ZoHEauFKCr5LsdQJTxUC9Bsbs/9ep
	 TBHbvPbIdfxSm+fZP5oAv+pmjJ1t5fqT6h8DvTXEInmxmmT1AOVPkFfRgKXw/gRzwb
	 sO0SdvdKlvlaUkXNoWPUv5Vt8B7iZWzUk1sBYhvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hardik Gajjar <hgajjar@de.adit-jv.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 252/476] usb: hub: Replace hardcoded quirk value with BIT() macro
Date: Wed, 21 Feb 2024 14:05:03 +0100
Message-ID: <20240221130017.165540223@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Hardik Gajjar <hgajjar@de.adit-jv.com>

[ Upstream commit 6666ea93d2c422ebeb8039d11e642552da682070 ]

This patch replaces the hardcoded quirk value in the macro with
BIT().

Signed-off-by: Hardik Gajjar <hgajjar@de.adit-jv.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20231205181829.127353-1-hgajjar@de.adit-jv.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/hub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 4bed41ca6b0f..46fdccd10c23 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -46,8 +46,8 @@
 #define USB_VENDOR_TEXAS_INSTRUMENTS		0x0451
 #define USB_PRODUCT_TUSB8041_USB3		0x8140
 #define USB_PRODUCT_TUSB8041_USB2		0x8142
-#define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	0x01
-#define HUB_QUIRK_DISABLE_AUTOSUSPEND		0x02
+#define HUB_QUIRK_CHECK_PORT_AUTOSUSPEND	BIT(0)
+#define HUB_QUIRK_DISABLE_AUTOSUSPEND		BIT(1)
 
 #define USB_TP_TRANSMISSION_DELAY	40	/* ns */
 #define USB_TP_TRANSMISSION_DELAY_MAX	65535	/* ns */
-- 
2.43.0



