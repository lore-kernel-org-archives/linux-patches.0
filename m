Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F6D136658;
	Tue, 23 Jan 2024 00:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969683; cv=none; b=jUbcpVoBi908a/COvApOvjPK+W+tgYvMVP+a9LdnO789iCBNHIxHJR2ta36QOUPjU5S2o6Wd1MQbYq3LtdshA5Evbrrs/+2hORQCF8NwM2k+KR8T501sPqVBpzQCeAUf42yZ54PmTer0YLPCsDCATyV62Sh+ZdX94GxCBYt8Jos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969683; c=relaxed/simple;
	bh=lqWCIPAQGFetTlmz9YWponWjk9yCQd2AB55AJOxVHFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqDidX65u9vg9UXVcr5XCyRyMe/Ji/LEETpwNePnq2RGYtswwqH9SHKvYBMykeBiN2ZS2CwD3s7NdMErzin7aM6u/Gyj7emAXLaES/gLVtiTG7MSMxgvqbgroUPRgbazTPyf9oQqXZKr0nDchCBJNgoA268E+ZcmzNr6uM3GepE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gr4sK6LJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gr4sK6LJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FDEC433C7;
	Tue, 23 Jan 2024 00:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969683;
	bh=lqWCIPAQGFetTlmz9YWponWjk9yCQd2AB55AJOxVHFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gr4sK6LJhZ7TPBpnD3XRmpjVnuDhlyzkg4ry0IeUPoN2eF/O6bxC0pFUHDMWyvmft
	 d8GRu6Hs2N+bn5TUl0S81if7kM9PNi27z3s0/1iXGr3FAPVi7/CcHx1uXhKB0Ox3fO
	 wN5OSQpCfdKQ5J10Ql9V9upJBsVUHFFbizqdCbQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.7 395/641] usb: phy: mxs: remove CONFIG_USB_OTG condition for mxs_phy_is_otg_host()
Date: Mon, 22 Jan 2024 15:54:59 -0800
Message-ID: <20240122235830.326815925@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit ff2b89de471da942a4d853443688113a44fd35ed upstream.

When CONFIG_USB_OTG is not set, mxs_phy_is_otg_host() will always return
false. This behaviour is wrong. Since phy.last_event will always be set
for either host or device mode. Therefore, CONFIG_USB_OTG condition
can be removed.

Fixes: 5eda42aebb76 ("usb: phy: mxs: fix getting wrong state with mxs_phy_is_otg_host()")
cc:  <stable@vger.kernel.org>
Acked-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20231228110753.1755756-3-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/phy/phy-mxs-usb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/phy/phy-mxs-usb.c
+++ b/drivers/usb/phy/phy-mxs-usb.c
@@ -388,8 +388,7 @@ static void __mxs_phy_disconnect_line(st
 
 static bool mxs_phy_is_otg_host(struct mxs_phy *mxs_phy)
 {
-	return IS_ENABLED(CONFIG_USB_OTG) &&
-		mxs_phy->phy.last_event == USB_EVENT_ID;
+	return mxs_phy->phy.last_event == USB_EVENT_ID;
 }
 
 static void mxs_phy_disconnect_line(struct mxs_phy *mxs_phy, bool on)


