Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8987049D590;
	Thu, 17 Sep 2026 17:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667929; cv=none; b=Xx6At/IerVnHUWT7jnx0b2/JxxQByvAJD3yLcMrg1vdOiJp/w4Z7z1btDo25bbgRLxeepbyXCLI5r5WSVslcQ2xZscbFNdcL1gpKXQ3XWkW+5WOo60ktza+dlomVh2fqOaob6C4uD3HKXwcVzPRDD2UvwZFf9RZn/leON+alBKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667929; c=relaxed/simple;
	bh=FpEGBss6wWUtEOyJvN6Y7lqy8/nFAENc8uQfiTzyWIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHdw1KTMtmyT+y/RBrOIY7UBNBZUa/Ex5NSA6Ao3szeTsknQ6L26bQZVFMbU41Zzf8SZ+DJ2hcIfJ5d/jZ5Vkt8rEKDKEKU2F4imqrktJiQLQ0nMvsHboBdRWLBRG1MFdINVzcpcaMcgl8yLdxv6lkoBZWluX4g3AjevyPYzzZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ugT2gfSZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ugT2gfSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D7B1F000FF;
	Thu, 17 Sep 2026 17:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667928;
	bh=C8BER0uUpkhQ614PwmfQzLtNfx5K0TG1JXdAtC7AX88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ugT2gfSZ4wLHosREMeQObGOmaYcPJDK4dXQ+7PaFV3KeFmzaLNgodEdUnJbTMvY1V
	 qcAnlQ4P7F/tR3UfFz7XKroK06J9xCozeUTK+HjczPDqupratCb+xviUo4g2zuNi91
	 3jXxdSyyVJq9FF54FU19QY7O7PxNHOrGiLB5wdVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0257/1102] wifi: mt76: mt7925: add Netgear A8500 USB device ID
Date: Thu, 17 Sep 2026 16:03:20 +0100
Message-ID: <20260917151546.049258210@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit 291b067a02b9c1fd272057ebf47c365260955fd2 ]

Add USB device ID for the Netgear A8500 (0846:9050) which uses
the mt7925 chipset.

Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260527144735.10254-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/usb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
index bf040f34e4b9f..995a7fcc419fd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/usb.c
@@ -12,6 +12,9 @@
 static const struct usb_device_id mt7925u_device_table[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0e8d, 0x7925, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)MT7925_FIRMWARE_WM },
+	/* Netgear, Inc. A8500 */
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x0846, 0x9050, 0xff, 0xff, 0xff),
+		.driver_info = (kernel_ulong_t)MT7925_FIRMWARE_WM },
 	/* Netgear, Inc. A9000 */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0846, 0x9072, 0xff, 0xff, 0xff),
 		.driver_info = (kernel_ulong_t)MT7925_FIRMWARE_WM },
-- 
2.53.0



