Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B992C21F2;
	Wed,  4 Feb 2026 15:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218031; cv=none; b=Lg2t9h5qYC9PQ+jf4INdL6Y/wr1MDkAfFxKr5FqrMPp3oOCYQ90RcmNj/iTC7lCOZROsGEj1F5UoN7kqsGhVz3DfuEUgWnpdnNmchTPSs412zrZBaZHMcfmLJqvi7P0xlrUI5h78VFyCiqDiHKZzgihNwdithO92wfTrj2tJB4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218031; c=relaxed/simple;
	bh=lobbj8opxg2VLHpJxz2Hw56DjkToYu2K0wmOvRuGrMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZbhJJ1+DHmsG2QnY/zX3TDu/4/fGsCTLEYxvq36F5TBrzA8lbGfJzXfJqbZdSG42++/4f9B4fvFWhrk4Wwf6ptmA4rDAz8LCNfN4C3ATi2iAJxa/mtaN/nPb+K2lXQ9ADsM+Pbsa7/Ae9D23XuqaRNpmQ7/3sGF8qOHZv7eW3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mr8O3XHh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mr8O3XHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252F9C4CEF7;
	Wed,  4 Feb 2026 15:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218031;
	bh=lobbj8opxg2VLHpJxz2Hw56DjkToYu2K0wmOvRuGrMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mr8O3XHhw288kZT+MPVts1AiP6auCTI/gUGIHyDrqnjVdTLSJPftO5XVnfJ8HqH92
	 8l04C0+ZJNhqII5ojK1EHOiHGA/Ll7Q1rYBa4472F07TXmVcvJyn4YdOGI7qE8XB0o
	 Xr/c4Mwr9DGuZqcjPnC2Vl7Jd0kzbzrU1ncUPOow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 190/280] can: gs_usb: gs_usb_receive_bulk_callback(): fix error message
Date: Wed,  4 Feb 2026 15:39:24 +0100
Message-ID: <20260204143916.446705937@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f782c3aa179e0..8859e65d4470b 100644
--- a/drivers/net/can/usb/gs_usb.c
+++ b/drivers/net/can/usb/gs_usb.c
@@ -526,7 +526,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 {
 	struct gs_usb *parent = urb->context;
 	struct gs_can *dev;
-	struct net_device *netdev;
+	struct net_device *netdev = NULL;
 	int rc;
 	struct net_device_stats *stats;
 	struct gs_host_frame *hf = urb->transfer_buffer;
@@ -674,7 +674,7 @@ static void gs_usb_receive_bulk_callback(struct urb *urb)
 		}
 	} else if (rc != -ESHUTDOWN && net_ratelimit()) {
 		netdev_info(netdev, "failed to re-submit IN URB: %pe\n",
-			    ERR_PTR(urb->status));
+			    ERR_PTR(rc));
 	}
 }
 
-- 
2.51.0



