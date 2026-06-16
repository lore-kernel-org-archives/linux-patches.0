Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3423191BA;
	Tue, 16 Jun 2026 19:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636474; cv=none; b=ZKYMnu3Tzkx9xy+sMc7Vp9NJm37ZUYnlOhlNuLKXDxRm9R4jd0aiD0IIriTISCjx1fUNcSL2qf5TVENgxC9jF9hN7WPMHJvexIEjNzMsiDQHFwapK3Hi8gnrXWsDUUldq+rL15XplS21pxgXpXKMg/xuFwlmPPynyXs2pBYuEPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636474; c=relaxed/simple;
	bh=ltGNaADxQkNgy9KYakM+dXSfFdghMWbvQ8HOZ8j1EV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYzl3u8O+8Os6vBvHa8i9x5i7vwaSzQmGzPDe45HX3OO3o6xgbHq7JPsS2umQDpP3uSXY/WOyjThKkOOPpUNiW58KBKBjfkCPAvZiQA2JngYicCOlK/iBRmtnUWOkfVDDhUYSksVZmUzu1zboyxG3ND5a2l3jCGsc/ii5bERzsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lMDQX8rY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lMDQX8rY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC401F000E9;
	Tue, 16 Jun 2026 19:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636472;
	bh=uoSbW6mB2D+lrDkgGNGmlKPOdl2WXbdCQdtFYTPZy9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lMDQX8rY9eT08KkYx6PK3mtk6bLPfbSd0lQq0fQj/apBKAuE2W3jp7nmsBANMJysJ
	 /kfsQ+08W1Geu51vEcKOEoARiztHNMFF8+GEahLIk1/mGpJkrI+XGGO+7nNrI6hQVd
	 iRJJDIG4Wj5SG/2lp1ONhIp1CYHadO0w9bJfl+x0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 244/342] can: ucan: fix typos in comments
Date: Tue, 16 Jun 2026 20:29:00 +0530
Message-ID: <20260616145059.581152271@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julia Lawall <Julia.Lawall@inria.fr>

[ Upstream commit c34983c94166689358372d4af8d5def57752860c ]

Various spelling mistakes in comments.
Detected with the help of Coccinelle.

Link: https://lore.kernel.org/all/20220314115354.144023-28-Julia.Lawall@inria.fr
Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: fed4626501c8 ("can: ucan: fix devres lifetime")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/ucan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/usb/ucan.c
+++ b/drivers/net/can/usb/ucan.c
@@ -1393,7 +1393,7 @@ static int ucan_probe(struct usb_interfa
 	 * Stage 3 for the final driver initialisation.
 	 */
 
-	/* Prepare Memory for control transferes */
+	/* Prepare Memory for control transfers */
 	ctl_msg_buffer = devm_kzalloc(&udev->dev,
 				      sizeof(union ucan_ctl_payload),
 				      GFP_KERNEL);
@@ -1527,7 +1527,7 @@ static int ucan_probe(struct usb_interfa
 	ret = ucan_device_request_in(up, UCAN_DEVICE_GET_FW_STRING, 0,
 				     sizeof(union ucan_ctl_payload));
 	if (ret > 0) {
-		/* copy string while ensuring zero terminiation */
+		/* copy string while ensuring zero termination */
 		strncpy(firmware_str, up->ctl_msg_buffer->raw,
 			sizeof(union ucan_ctl_payload));
 		firmware_str[sizeof(union ucan_ctl_payload)] = '\0';


