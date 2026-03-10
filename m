Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D77389DEA;
	Tue, 10 Mar 2026 11:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142012; cv=none; b=NQCZ+vZU+U/H6jAsI4sRqdkGak2A3mxylZulHz370aoWTLSvAc17B5KpLgExct8YFP6IfsE+qzDX/YDx/4TyOK+fMCf2Jt3+dIeXPaCmkD4rj2qQMOH2y52xHPWCvXZmbj76XVxm52Ijw7vfG3IWCFsgXTXkjIo/m+KKtEOZHsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142012; c=relaxed/simple;
	bh=yLexsLCIlYa70psfDuQ6kRbIDj+/ZR7DX0c96DftPmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUbjPit7/PsZkQkuMT6GJx4sBHplWpq/p58w0SfwLPMLOIOOv5aifwrMuA2Fba51AxaAc+bHKOsepWwqefWs2kZYKz4/83WldM3KU23R7j0auxPsa/HOXctL4x1Qmr8jcKmMnYFwAgdX+n76nGQ9GR/glC4eS0aKZIxrg7o9NYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HxkSrwpk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HxkSrwpk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178C2C19423;
	Tue, 10 Mar 2026 11:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142011;
	bh=yLexsLCIlYa70psfDuQ6kRbIDj+/ZR7DX0c96DftPmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HxkSrwpkEiMqKTkLqhPx33OqvTYatQuP39H3XIFR9T9w96whZVIFc1zqch20wdPPP
	 CTwrM5bvOuzEC0loG9DkneR3p/K4KhE76PFfKOCw5qixoypKPr00N6sv0+JPHXK15r
	 YG33enO9KnupELnfW69L1l57vvSq4F19pHWBZ8POTNlVZEu8TuD08im848eqjrA/8z
	 EDvIGNON7km5uOEjGeGw+XqlispKEKGGIsUnlj+k3rP+deNssCZgO3RNuPO3yKvd9v
	 SvPJeDoGuHF+hVypBxfHTbHsAcYTPWst0M5ziC8WogiaVcSdrvfzc2BlHko+GYA2/B
	 w++MLXF55ZTsg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Ji-Ze Hong (Peter Hong)" <peter_hong@fintek.com.tw>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Vincent Mailhol <mailhol@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.18 138/314] can: usb: f81604: correctly anchor the urb in the read bulk callback
Date: Tue, 10 Mar 2026 07:16:37 -0400
Message-ID: <c208c5444ecbf08a8c3346e47cab406987900b9d.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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

commit 952caa5da10bed22be09612433964f6877ba0dde upstream.

When submitting an urb, that is using the anchor pattern, it needs to be
anchored before submitting it otherwise it could be leaked if
usb_kill_anchored_urbs() is called.  This logic is correctly done
elsewhere in the driver, except in the read bulk callback so do that
here also.

Cc: Ji-Ze Hong (Peter Hong) <peter_hong@fintek.com.tw>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Vincent Mailhol <mailhol@kernel.org>
Cc: stable@kernel.org
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026022334-starlight-scaling-2cea@gregkh
Fixes: 88da17436973 ("can: usb: f81604: add Fintek F81604 support")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/f81604.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/f81604.c b/drivers/net/can/usb/f81604.c
index e0cfa1460b0b8..9e416cb642dcf 100644
--- a/drivers/net/can/usb/f81604.c
+++ b/drivers/net/can/usb/f81604.c
@@ -413,6 +413,7 @@ static void f81604_read_bulk_callback(struct urb *urb)
 {
 	struct f81604_can_frame *frame = urb->transfer_buffer;
 	struct net_device *netdev = urb->context;
+	struct f81604_port_priv *priv = netdev_priv(netdev);
 	int ret;
 
 	if (!netif_device_present(netdev))
@@ -445,10 +446,15 @@ static void f81604_read_bulk_callback(struct urb *urb)
 	f81604_process_rx_packet(netdev, frame);
 
 resubmit_urb:
+	usb_anchor_urb(urb, &priv->urbs_anchor);
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
+	if (!ret)
+		return;
+	usb_unanchor_urb(urb);
+
 	if (ret == -ENODEV)
 		netif_device_detach(netdev);
-	else if (ret)
+	else
 		netdev_err(netdev,
 			   "%s: failed to resubmit read bulk urb: %pe\n",
 			   __func__, ERR_PTR(ret));
@@ -646,10 +652,15 @@ static void f81604_read_int_callback(struct urb *urb)
 		f81604_handle_tx(priv, data);
 
 resubmit_urb:
+	usb_anchor_urb(urb, &priv->urbs_anchor);
 	ret = usb_submit_urb(urb, GFP_ATOMIC);
+	if (!ret)
+		return;
+	usb_unanchor_urb(urb);
+
 	if (ret == -ENODEV)
 		netif_device_detach(netdev);
-	else if (ret)
+	else
 		netdev_err(netdev, "%s: failed to resubmit int urb: %pe\n",
 			   __func__, ERR_PTR(ret));
 }
-- 
2.51.0

