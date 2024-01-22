Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54A7666B52;
	Tue, 23 Jan 2024 01:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971705; cv=none; b=oQteXCwpWA/Sw5EoL9kGcs0bKelNkq8B82rlFlaS1HYPM4MVjr6t6kuBuqN5m5xbVV0W0fBo0QZBiPddAJl+BUKG7m1076FW5awtxgDbOJy6Lkv64CrsqqGdJ5oUAjIK/wcm3/Dsu6VXHI7Qrj1rgLggilvF6un+vDV7GfhMSS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971705; c=relaxed/simple;
	bh=oBDFM97pDb1iKjFbTSe27sVDWrmcoiAgJcVv4YY4dJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W42O8FZryMcvMbVZ7saRuFdp7qc+Dn959lPMv3TiBbUh8POS4E6eCDBtWxq2e2m/sNPDshjvT64AkS8yTEkrW/EC0bZiiar0e9H0qVxJ4iLs4FJIeZ3pfyJtgSmopLN+d+8SNOtkygwmveQ9zTcteWx2PgD6WstI200M6q1QTB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVENTV+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVENTV+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B565BC433F1;
	Tue, 23 Jan 2024 01:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971704;
	bh=oBDFM97pDb1iKjFbTSe27sVDWrmcoiAgJcVv4YY4dJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVENTV+0/lDYSm7IYoW3whG3G29DaLuSVrc7xoqfLvNxIVsiVJXiZ+kTzcejaM4+l
	 3AtE1VBs/Ary+0CC3skJOQGJ1JdS3lsbFu2gyDxmXZxVAoy68U3LsvuT0hOE/40EPM
	 UK0wzSatkw62bJcgqkwKC+YeA16ukKf95i6gBmfk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 5.10 211/286] usb: phy: mxs: remove CONFIG_USB_OTG condition for mxs_phy_is_otg_host()
Date: Mon, 22 Jan 2024 15:58:37 -0800
Message-ID: <20240122235740.211082148@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


