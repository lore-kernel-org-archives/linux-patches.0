Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3511A0BF1;
	Wed,  4 Feb 2026 15:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218961; cv=none; b=WDGm3ZbDcWxPz8RxQGd+aWiqQER/YwsC/Wz2oyXn76Zz+AxG2bmU6YPtR92LAFP1qOLUmS5pQD/3H0pDcJzKNqFxLW7ABPD/SJr9U+SsLQQVJvF8ggOPQ5ZboBAzxxhavpdZBb/cvIuNSR64vaNU3nqNbgkHEnlBQ/qj4TAjhn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218961; c=relaxed/simple;
	bh=63B0EZoq/qvJ70S/Xx+ASuphhatpvn5pHSBePAk2Iv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGHDD4fui9jdCpctGCxjux8Fcg3NrY+z5xLCim2K67Y+13EnY/LbUzE+KDFQbSzicxc6Yz4yFZaWVKptsAuR2GXIEPf8LmvdHVSBYtB91CMEZ44sywZ0mbeaaPvTyMlwarkZWCvN4078+4RYMguWG/EBZd0HMiz+KRv/4iv9H2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4hAc+bM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4hAc+bM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF77C4CEF7;
	Wed,  4 Feb 2026 15:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218961;
	bh=63B0EZoq/qvJ70S/Xx+ASuphhatpvn5pHSBePAk2Iv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y4hAc+bMbG2jbpiivWYv5HsktehZGOh+CeDXNUL/rRK6OGi78sKSiph7qxUejJCES
	 kBSrDXTehJzxZmJIrB2+BeR5GfdnSFM3SPx96Ctj7WzrO1p7uztnC2x7/zFPvvLm3N
	 r+NUaT0aZnd3/oSTLPBZbV+zfIblfbfcRCt9k7Cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 007/122] can: gs_usb: gs_usb_receive_bulk_callback(): fix error message
Date: Wed,  4 Feb 2026 15:39:49 +0100
Message-ID: <20260204143852.128899297@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 494fc029f662c331e06b7c2031deff3c64200eed ]

Sinc commit 79a6d1bfe114 ("can: gs_usb: gs_usb_receive_bulk_callback():
unanchor URL on usb_submit_urb() error") a failing resubmit URB will print
an info message.

In the case of a short read where netdev has not yet been assigned,
initialize as NULL to avoid dereferencing an undefined value. Also report
the error value of the failed resubmit.

Fixes: 79a6d1bfe114 ("can: gs_usb: gs_usb_receive_bulk_callback(): unanchor URL on usb_submit_urb() error")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/all/20260119181904.1209979-1-kuba@kernel.org/
Link: https://patch.msgid.link/20260120-gs_usb-fix-error-message-v1-1-6be04de572bc@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/gs_usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index fd7fb21b10989..861b583935225 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -610,7 +610,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 {
 	struct gs_usb *parent = urb->context;
 	struct gs_can *dev;
-	struct net_device *netdev;
+	struct net_device *netdev = NULL;
 	int rc;
 	struct net_device_stats *stats;
 	struct gs_host_frame *hf = urb->transfer_buffer;
@@ -768,7 +768,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 		}
 	} else if (rc != -ESHUTDOWN && net_ratelimit()) {
 		netdev_info(netdev, "failed to re-submit IN URB: %pe\n",
-			    ERR_PTR(urb->status));
+			    ERR_PTR(rc));
 	}
 }
 
-- 
2.51.0



