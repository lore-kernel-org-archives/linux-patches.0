Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC29164CF2;
	Tue, 23 Jan 2024 00:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971532; cv=none; b=D60XYY4e5DMXugAm3XrKKgjPIRF96WTVBEs73lPan2u3lmes/kbkH1wH3HwnT6LkIoat3AjAF5vrfOnSOJxGBevlw/CUpmdwYPP9cXjj4BCeCOPu36cBQUNKFUWt+kbehdaMqtqHeoN+ILMLXIp8M5TkMLX6oh++TEEt2Mvqzuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971532; c=relaxed/simple;
	bh=sFRf00EGCTlSiCmKpi5YYDRkTkundZuV79ljF7TTRQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLEmWqyQVxh6dFIgHOyPtrqAHccRYylM1FHZmn2gWGwXNnRooY5GaYPLiiUcAw5yY34ZhYTGJMvKdW0chO76m/EGp4ZaQjXiYZbSz88q2rtv0i+vF53WCq4LW3Eh5s+/oVsThIhK79g7e4P/MtSfbrieS3ig/BX3Mbc1SlUUmow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUgZkg6v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUgZkg6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61665C433C7;
	Tue, 23 Jan 2024 00:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971532;
	bh=sFRf00EGCTlSiCmKpi5YYDRkTkundZuV79ljF7TTRQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUgZkg6vHFc61M34k8cqV86zDSlQ6aLWmE3+IOzwci88LorcVGsf5r8vRr0/6Ds77
	 XluZb/nEdCysrjtWrgkxjvDl1SJcJcQonV7v7WUILtxB/d5mYp/q3BbnpWDfLpUiCd
	 C1JiEsHgv2eDOHsWLgaB34M4jOe6bZSWyixNLSvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.1 259/417] usb: phy: mxs: remove CONFIG_USB_OTG condition for mxs_phy_is_otg_host()
Date: Mon, 22 Jan 2024 15:57:07 -0800
Message-ID: <20240122235800.840282442@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


