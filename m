Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F410F6EB67;
	Tue, 23 Jan 2024 02:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975417; cv=none; b=jce047JFigUoKMZOwK9Om3cHZPSK6AN+l4Caozmu6vI9abJFPGXshAUbtC+9VSPaRedlAlKNLZCLlkienRdZygcS2yUD60Z1MbMGv3JlRSS/EfuPNoMxysj6LXPSEdI4PALy9/ZSRwjsoqDLD+eW04eDh2QEfDCQtcQTstexslY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975417; c=relaxed/simple;
	bh=XdWy96IerQWHofbVXQIJpdkjCFB3FgSTUGo0vQ3fLoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DO/EfvPgA+jxPEhETnNtzaggdRn0454wnaxIebXsoM1GxUAqj5El9n6ByE9f5k8mX+4V546roMwvNUyYxkjHKmUBGgthFB4v61eZi+bZj8ipf7SGmoSqFUNTLhS58SRxGXvGK9JTYM5JL4lwlSvOsqG90FWhgcJ6U9zKFYhCxXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CAczcSj8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CAczcSj8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B904FC43390;
	Tue, 23 Jan 2024 02:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975416;
	bh=XdWy96IerQWHofbVXQIJpdkjCFB3FgSTUGo0vQ3fLoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CAczcSj8zD0pSES9vutFd6ZlC0VDR75tjGs6d0dPtVIV7SxU9xbJIrQ4Xl+c0YoFw
	 2nqbdA/vIhZ5NZS9nltPqq4CJ9Rz0Q/4Ck+CKKPQJhMZIcZa4pV/ykIvItmpw4GQKD
	 IU9jFhLtv2SvU1rialgEJpwociO2Ysof8TzHGzLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.6 358/583] usb: phy: mxs: remove CONFIG_USB_OTG condition for mxs_phy_is_otg_host()
Date: Mon, 22 Jan 2024 15:56:49 -0800
Message-ID: <20240122235822.980893127@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


