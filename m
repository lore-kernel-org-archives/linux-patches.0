Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C742D5A19;
	Mon, 13 Apr 2026 16:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098359; cv=none; b=sLvFgql4AK/x3wXXNafH5/pTTtE5EwQnRTLV1L88Nv/TE9GfELv6RxvQUVtswE+95Pkk0sQO6/R690QaKX8xoovi7N82Iuf1hN5BQHySx0DRdkRVNl5PUuVhWKiEUXW71ga5rpJ7z+NKxRarsk7RRB7MCjIcykNEyElBXHpi8cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098359; c=relaxed/simple;
	bh=OayfgcM9SB62XSIQVHk5ZSs9ix652Jbu8XhoCbOVdZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PsVCnhBheMfogdoK5ZSqN72MVKZwNxq9edDt6nZ9U43UQnuN046m/nnSSaWaTg3/REKLPHusAL05onTyrbYYzxCPz06RJg3oU73iy7NJciCIBwphRjdf3XsFkasVro6DKDy6Uc+txWd71gj2rCXgctPXF/xXSKIhQV80iWUSwxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D0SHWXCD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D0SHWXCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E99C2BCAF;
	Mon, 13 Apr 2026 16:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098359;
	bh=OayfgcM9SB62XSIQVHk5ZSs9ix652Jbu8XhoCbOVdZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0SHWXCDnu/tZPRwT7BuaqsWpeJq+X6DX0LwSi5xiEiBXE+QO6938F3JOjilIOoPF
	 54ebpFYo2Np2Kv5wJBA3qXaLn/vQIdOk5zDkXA5duBTG5RqwENnEDgkyu/UClwiCWA
	 AHcurqXLYRnaJ5ro7fOjPj4Ghye3fD+Mjqjp3zD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Ruohan Lan <ruohanlan@aliyun.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 494/570] can: gs_usb: gs_usb_receive_bulk_callback(): fix error message
Date: Mon, 13 Apr 2026 18:00:25 +0200
Message-ID: <20260413155848.963539455@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ruohan Lan <ruohanlan@aliyun.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/gs_usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/gs_usb.c b/drivers/net/can/usb/gs_usb.c
index 134f830508d9f..fd9a06850c950 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -297,7 +297,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 {
 	struct gs_usb *usbcan = urb->context;
 	struct gs_can *dev;
-	struct net_device *netdev;
+	struct net_device *netdev = NULL;
 	int rc;
 	struct net_device_stats *stats;
 	struct gs_host_frame *hf = urb->transfer_buffer;
@@ -419,7 +419,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 		}
 	} else if (rc != -ESHUTDOWN && net_ratelimit()) {
 		netdev_info(netdev, "failed to re-submit IN URB: %pe\n",
-			    ERR_PTR(urb->status));
+			    ERR_PTR(rc));
 	}
 }
 
-- 
2.53.0



