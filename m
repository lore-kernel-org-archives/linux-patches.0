Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F481474AF;
	Fri,  6 Dec 2024 14:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496557; cv=none; b=MZ+pGCAAhiJH0ErZNtGWfCnmrG3nO0kP88bMATuVbogpzzCAwDTuGQ6nwI6932MDSqbcRSQDZ04LPvCM8pNHHgJwjpZQ75r3lIzpPDMTMBvtm7fQWuRMWKq82quc6jeNlk6SMPc7iLQvGvW73Hiv3yQOWRYN8qK5HnvRHRDU1o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496557; c=relaxed/simple;
	bh=XJgN0lBTJt8CIrPD8Us+UC8PqrCBMS8/6cweZsH31tk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tpy3W/lAfg5RqGU887/QbxkbDpKnAw1LgCdY0J1sXEmAn3Rjdo7eZpH3J3Bnu2Pqjb2/fWd4z9dkpk1W7Nw+psqPinlbA+yUjZmX25fJwUppLcJxF4XnSAOXk4TvqRLHFjO9yH4nacVwDOGhpvJjJ5T1FhksDdtpwcS1snGdb3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IJ7A8um1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IJ7A8um1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61121C4CED1;
	Fri,  6 Dec 2024 14:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496556;
	bh=XJgN0lBTJt8CIrPD8Us+UC8PqrCBMS8/6cweZsH31tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IJ7A8um1iRucGld9Yo4ri1fFCKW3klslWppMDRmnmtIe7ATtjP0F7NVuhXbISehA7
	 V2zlNElb2afhn9WIde0ftPe0bnnZY9/z8BYwn6ZQqAuIRMpCd3Xp2edrPIaOwjDNsk
	 lVdYDf6fweSASdAG79ZYb202B1csYFDyOSEEA4ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Benjamin=20Gro=C3=9Fe?= <ste3ls@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/676] usb: add support for new USB device ID 0x17EF:0x3098 for the r8152 driver
Date: Fri,  6 Dec 2024 15:27:07 +0100
Message-ID: <20241206143653.682306528@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Große <ste3ls@gmail.com>

[ Upstream commit 94c11e852955b2eef5c4f0b36cfeae7dcf11a759 ]

This patch adds support for another Lenovo Mini dock 0x17EF:0x3098 to the
r8152 driver. The device has been tested on NixOS, hotplugging and sleep
included.

Signed-off-by: Benjamin Große <ste3ls@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241020174128.160898-1-ste3ls@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index ce19ebd180f12..3e5998555f981 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -10016,6 +10016,7 @@ static const struct usb_device_id rtl8152_table[] = {
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3062) },
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3069) },
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3082) },
+	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x3098) },
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x7205) },
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x720c) },
 	{ USB_DEVICE(VENDOR_ID_LENOVO,  0x7214) },
-- 
2.43.0



