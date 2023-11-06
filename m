Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A103822EED
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ed1cchQy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D4F5C433C8;
	Mon,  6 Nov 2023 13:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277433;
	bh=hsqzr/bvrRh/fWtq5Wy+WbwT3VS4WeWPZMkFjWfHuR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ed1cchQyA57JCSm2JCSP3nFRB3hkS3k2INHtmiCrCo+l5hfkjAVw8cN3RGA1H3ZJd
	 ZiMlkpfAg6USv/qWD2kcnsSKv6ON63VNi+vbIVjolLs5mRd3kg6VnwPxaOqxDjYLok
	 JqPDx4N5hDAgppcq4DYXEzShw+8+ncIRkSIiyEqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Grant Grundler <grundler@chromium.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 20/95] r8152: Release firmware if we have an error in probe
Date: Mon,  6 Nov 2023 14:03:48 +0100
Message-ID: <20231106130305.460178974@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130304.678610325@linuxfoundation.org>
References: <20231106130304.678610325@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit b8d35024d4059ca550cba11ac9ab23a6c238d929 ]

The error handling in rtl8152_probe() is missing a call to release
firmware. Add it in to match what's in the cleanup code in
rtl8152_disconnect().

Fixes: 9370f2d05a2a ("r8152: support request_firmware for RTL8153")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Grant Grundler <grundler@chromium.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index beb1fb6f72735..0d6f10c9bb139 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6828,6 +6828,7 @@ static int rtl8152_probe(struct usb_interface *intf,
 	cancel_delayed_work_sync(&tp->hw_phy_work);
 	if (tp->rtl_ops.unload)
 		tp->rtl_ops.unload(tp);
+	rtl8152_release_firmware(tp);
 	usb_set_intfdata(intf, NULL);
 out:
 	free_netdev(netdev);
-- 
2.42.0



