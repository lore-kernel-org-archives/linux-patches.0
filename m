Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0102D24B7;
	Tue, 10 Mar 2026 11:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141109; cv=none; b=UU729/08k+pFkjPBU3/FSRBFj74/JZgVr8Ke8d5APwsbrHls8t52AvKcBZ2ipoKfyIIepsa07DS6j+hKJgOTlB4FCHz7jV9pBWpXtMxORrNg/SNIkGcT61w+NVmnEVT7qplMg6zs2L+HS4uaBu58OMOvI3S7Bg2hgOGKAccJEgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141109; c=relaxed/simple;
	bh=fZobdW6ca6HlHsMTxy0eUf6OvWn3ybf/2j79k46CG1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gf3UwnJspX9cvqo8llPyuOKleDggLItJmOHze2/YiMSuf1BzNU9VW0S7iBb5JtQa8MseVHouulCNFe84L/XsBRLjrKJpSdL0RnfLh2VIk1blAcgm8MjMX+PjW+SWY/oUUbsW8tVa9LL0hJchJlvwL1cGlHwQbd0GZ4oCedjM+1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jrHsVypz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jrHsVypz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEDF7C2BCAF;
	Tue, 10 Mar 2026 11:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141109;
	bh=fZobdW6ca6HlHsMTxy0eUf6OvWn3ybf/2j79k46CG1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jrHsVypzuyJ4izZeyV0k4bo+Q4+p/6bkjWe2/JrOc51vlXfC/KIosBdEwEm84HgwY
	 7z5H8Urr4lt4NnGLrRTiJ27l/utIt16EYUariFm2QdF7uxdmvmv9dZ2o4dGSHpPwQ1
	 2ZzKWEPa5cDUqx+Uwp7xUuTDYkq/NT5bWWmoQQqHoiW20sCGi4xgFLqurSGnjMb+8l
	 hxghMog9eS/Yl4QRcSw5XbJC86m6NFzS65QhSOnNMKt6K6EOGo1qHMuANKtuNY4MvQ
	 KQq30FzOH3Q4MIs8uILzWtnmU4LY+VWOUJ9J1JBi9ODjs4+R9+yQ/JL476qdygP87o
	 mH3dm3aDc9g9w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.19 111/311] can: usb: f81604: handle short interrupt urb messages properly
Date: Tue, 10 Mar 2026 07:02:38 -0400
Message-ID: <d65fe23366e317759296bff34a91b13b93f60f5d.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 7299b1b39a255f6092ce4ec0b65f66e9d6a357af upstream.

If an interrupt urb is received that is not the correct length, properly
detect it and don't attempt to treat the data as valid.

Cc: Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Vincent Mailhol <mailhol@kernel.org>
Cc: stable@kernel.org
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026022331-opal-evaluator-a928@gregkh
Fixes: 88da17436973 ("can: usb: f81604: add Fintek F81604 support")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/f81604.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/can/usb/f81604.c b/drivers/net/can/usb/f81604.c
index 28ac92d669faa..afd216949d03f 100644
--- a/drivers/net/can/usb/f81604.c
+++ b/drivers/net/can/usb/f81604.c
@@ -626,6 +626,12 @@ static void f81604_read_int_callback(struct urb *urb)
 		netdev_info(netdev, "%s: Int URB aborted: %pe\n", __func__,
 			    ERR_PTR(urb->status));
 
+	if (urb->actual_length < sizeof(*data)) {
+		netdev_warn(netdev, "%s: short int URB: %u < %zu\n",
+			    __func__, urb->actual_length, sizeof(*data));
+		goto resubmit_urb;
+	}
+
 	switch (urb->status) {
 	case 0: /* success */
 		break;
-- 
2.51.0

