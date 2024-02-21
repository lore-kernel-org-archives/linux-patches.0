Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DBC3CF42;
	Wed, 21 Feb 2024 14:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525411; cv=none; b=Bpn93UHHO8KSDuNgak/lVcj00HcJEFghtZ0tod2UpWndahdagwRc7I+ZfVQAMGUtuMPVhZ7ANeqoDs24v/849vwyr1CJkNKu4bFtBGQsa2hbf2pYY6HkKtJzdJW2YgT9amUERLhVdSDs8/RrdQkgumK17QscgnJmIkaLlC0N/Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525411; c=relaxed/simple;
	bh=nEf9B/U5ez7kcTtWz954Q2pSw9NcAXRCunCi/oXctl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tDi1w7gY/KE23WRwxm46l5HKjESMCUrj4tOnfqZJeiDhKuwzCi+Amo2m+kwt3Mb8AYAwmERpcJtss9rJN6qOkpSNVByMa+oV+R6pPFVsQbBh6f61dDNWY04cJ9btVCbjlv2DvMwo7YTFoPlSnhkUSrPFG4gRHgrNaL+aYbEY+iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GNyBBwof; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNyBBwof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC75C433F1;
	Wed, 21 Feb 2024 14:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525411;
	bh=nEf9B/U5ez7kcTtWz954Q2pSw9NcAXRCunCi/oXctl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GNyBBwofNwIFZYBI2UxqEcsyYt5OYnY+w8gqybTz021H8yuFXW5PNeoDmezOdCe4U
	 rb1w3TgJwWsL4d3GTRKdfYKPBAC50mdbvjJManynI53lt5jxpnsxxMD8CAwH0uTIln
	 J6mWFNpXiCdGLYZmLRjTEWgZzEPhKq/tGh8oaRAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hardik Gajjar <hgajjar@de.adit-jv.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 148/267] usb: hub: Replace hardcoded quirk value with BIT() macro
Date: Wed, 21 Feb 2024 14:08:09 +0100
Message-ID: <20240221125944.709664955@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9a1954e9f6f1..8e55eadb8feb 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -44,8 +44,8 @@
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



