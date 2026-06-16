Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FED472798;
	Tue, 16 Jun 2026 18:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634566; cv=none; b=pGi9Tegwy6hizjKV7ZO8zNyDWsHfMnv2dnJvnYAhuZ72cyVIrdrRKqpVawaRBrlpflcLIAfiXFngb0Gp8zg2q0qJ1HeZ2+QgK7feOmb4NFtb0x30CBXRmSHxwHWPNrBTXQRUhA/R+87WuCi5R7mblx9QsDTNvZgdsBY7tLMAWhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634566; c=relaxed/simple;
	bh=gluFOxKHsgfM9iSOyqSpzxeLGc+6auKzgql6/9+IxzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjUmAezSPic4r5GzjzpluMr454lfwFNohcV6LLwTeUmkhTXgNqTZKXwJncfO5ifSck+bxqraBPJdWZk4Mkxtj6SoKhJ73WujFnsee+T5yRpXqL4GMnUnUKyWMP1tgjTvhvN9qSG/gusJJqKttUYRrTGy9UBiIuUOMXb20JhozRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dV2MxqCf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dV2MxqCf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061DE1F000E9;
	Tue, 16 Jun 2026 18:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634565;
	bh=VbINFwIA9arGYw8+3ETc7HsJXv7QT+MWKMVJfsV1OaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dV2MxqCfcDRAlgRIbaqsvvC5kIECPMJTBkFdcjKlTrP/MYat+tz0xafGfJd5T1sRC
	 ZF2+CrLEgr4zQpnntg+RdiOW8TYe0e3PKsU9e2oH9eVNzHb1CXIhvTxzj49rwOMxFI
	 h0auYjgvPAC8wun2rv2aXgEbav2H6hOOefv9mEiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julia Lawall <Julia.Lawall@inria.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 288/411] can: ucan: fix typos in comments
Date: Tue, 16 Jun 2026 20:28:46 +0530
Message-ID: <20260616145116.462920762@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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
@@ -1395,7 +1395,7 @@ static int ucan_probe(struct usb_interfa
 	 * Stage 3 for the final driver initialisation.
 	 */
 
-	/* Prepare Memory for control transferes */
+	/* Prepare Memory for control transfers */
 	ctl_msg_buffer = devm_kzalloc(&udev->dev,
 				      sizeof(union ucan_ctl_payload),
 				      GFP_KERNEL);
@@ -1529,7 +1529,7 @@ static int ucan_probe(struct usb_interfa
 	ret = ucan_device_request_in(up, UCAN_DEVICE_GET_FW_STRING, 0,
 				     sizeof(union ucan_ctl_payload));
 	if (ret > 0) {
-		/* copy string while ensuring zero terminiation */
+		/* copy string while ensuring zero termination */
 		strncpy(firmware_str, up->ctl_msg_buffer->raw,
 			sizeof(union ucan_ctl_payload));
 		firmware_str[sizeof(union ucan_ctl_payload)] = '\0';


