Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2554175A80;
	Mon, 23 Mar 2026 14:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275479; cv=none; b=RG6KWozETLFN+Sk2VBJmSEvVZyD0lDw3NO4TKtkkxiF7awNmQX6zLUJx6bffb218I0l57hCVv5B2iaPOBMS1Ti3glmuZ1boQqhLKYvDmdl369frngeEDUO5rMRp9a5Yc+LndN4IdmMeEHt7OYnqy3WFM1hXOTiKYWznE2cKpCwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275479; c=relaxed/simple;
	bh=gfcMtDrJCraB5GEL1f93iQaj8uFlbaSnirgnbSCQBGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b++eGJ6Z3IHo2mZlhZ7KbHm+n3BRklYb/UQevVahJeCRt81TQgGkxv5UmdhYl5hxSMMvDcAH92ecRaupT4onDJpBMyCPtnmyRUzuj2HsEx0SptZTaa9C913wJuIjt4v9RRUt4bZnsAxeEDliR6dEBW0kkRp53yaQM0JkKtXLjDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BjlXCifD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BjlXCifD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BE5C2BC9E;
	Mon, 23 Mar 2026 14:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275479;
	bh=gfcMtDrJCraB5GEL1f93iQaj8uFlbaSnirgnbSCQBGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BjlXCifD4aupMJGmtcRPXVTuvJCZkrY6r5/LqZwxD2hvAFFCUZ0Jd8WekEXW3mbTL
	 kMLkJ7D3l4lyraRVjlTPkh84A4ezD6FL11QQ8m4Px2OoG4QiPCjZdw8oW/ZnW5fpgg
	 sd5rk3Rbdps/24mWOXCadx/oEUW03ezcwu7cKk4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>
Subject: [PATCH 6.12 099/460] usb/core/quirks: Add Huawei ME906S-device to wakeup quirk
Date: Mon, 23 Mar 2026 14:41:35 +0100
Message-ID: <20260323134529.087176091@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Sandberg <cs@tuxedo.de>

commit 0326ff28d56b4fa202de36ffc8462a354f383a64 upstream.

Similar to other Huawei LTE modules using this quirk, this version with
another vid/pid suffers from spurious wakeups.

Setting the quirk fixes the issue for this device as well.

Cc: stable <stable@kernel.org>
Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260306172817.2098898-1-wse@tuxedocomputers.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -208,6 +208,10 @@ static const struct usb_device_id usb_qu
 	/* HP v222w 16GB Mini USB Drive */
 	{ USB_DEVICE(0x03f0, 0x3f40), .driver_info = USB_QUIRK_DELAY_INIT },
 
+	/* Huawei 4G LTE module ME906S  */
+	{ USB_DEVICE(0x03f0, 0xa31d), .driver_info =
+			USB_QUIRK_DISCONNECT_SUSPEND },
+
 	/* Creative SB Audigy 2 NX */
 	{ USB_DEVICE(0x041e, 0x3020), .driver_info = USB_QUIRK_RESET_RESUME },
 


