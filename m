Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015991;
	b=ARcWG6hOwUFUfHjHCoipZ1zXNRGcfOp1BJUxJ/MtCFfgJFqSOPREQKUqJlKX1wuasBt9
	 jzegS85EKB4xL0m5zP2otof0CUeMiG3YJ5SfK45WEAYCUmnNww3Bz8uFpFzNRl81zrLfz
	 meJyXDuxANbBwoXSysbWcDR/y3MG8xskBBU8JtUWdNRaMiSLmzCN6F7c2wyMHdbKv5t82
	 Zi6oa3TCd+hqELwRHyOf0KS6qEApryApUuz17ye/RcW6SG/M64SsiajsdeYKGnfuyLKnH
	 zXZjwiboV0Ma2Xbcal+bGTFuxhsg0b1zdAaOBIMsPFDv6x4rrlbetmwcFisff0t1f4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015991;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X8HS/MfO3JK0gl6EhnlsLnGhIQeCDq/7QaodL7Gk6XY=;
	b=YpJkijGGN1RwFl4dzTi89sAwgHKtPgkPIb24Bt/W9M5c3PIQ110uTRW/JNFy7CrCrwY2
	 AxlkWo/mxwPuSU1s8Cy1Gi0TSwG32JMTEK/OseyNcllrHyGo5bkTgHEWlW9Pb5NPTsyXN
	 dNUppMBJKhCGf3aNhuIcxZYC6oOw7GMyhSu3suWYBI/pMGoiWZwOyhObe+XWPms5lXbZE
	 Occee1bve32QNLABbfJG5X9tiydXQgGdwr/LUKff1PRLTYyfUiOKRVLTnoyKp2wg7nJVK
	 NGXNez5TmTOMsdx379nIwbzhkiUdFlmfLA2PIG3MI3vJNQW01KlNl9Nb2MuTwlSd5XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JlY6L2iB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD682606A31C;
	Wed, 18 Nov 2026 15:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JlY6L2iB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E389D1F000C4;
	Wed, 18 Nov 2026 15:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015991;
	bh=X8HS/MfO3JK0gl6EhnlsLnGhIQeCDq/7QaodL7Gk6XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JlY6L2iBxpQ1C/bWOUYRkV64aXcLuAio5C8ng8jz9QyAJ0t3pp6dkHxuuJqDRMVE8
	 JnmiYvcRlFfMPymjP6eWRZsnyYGMTytRk20N2V0AHuxlkzxkOM20ZyVfmLa2XmRxQg
	 TrDVlJdK5vpaMkYJzmjfS9tu/p3k6aqYXdn7/SV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d31109047baed8f3b590@syzkaller.appspotmail.com,
	Keisuke Tsukuda <tkdkei@outlook.jp>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0369/2651] usb: gadget: f_mass_storage: ignore class requests while inactive
Date: Wed, 18 Nov 2026 15:26:49 +0100
Message-ID: <20261118150301.118375498@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keisuke Tsukuda <catnyaaan@outlook.com>

[ Upstream commit e84caed6e7f58d96ea2e4aaa0b947ab05faa451b ]

SET_CONFIGURATION is handled asynchronously by the mass-storage thread.
A class request can arrive after the composite core selects the function
but before the thread installs common->fsg, or while the function is being
disabled.

fsg_setup() already rejects this state with -EOPNOTSUPP, but checking it
through fsg_is_set() also emits a warning. Check the active function
directly so normal requests during a configuration transition are rejected
without hiding fsg_is_set() warnings from other internal paths.

Fixes: 8876f5e7d3b2 ("USB: gadget: f_mass_storage: added eject callback")
Reported-by: syzbot+d31109047baed8f3b590@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d31109047baed8f3b590
Signed-off-by: Keisuke Tsukuda <tkdkei@outlook.jp>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260908203348.95825-3-tkdkei@outlook.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_mass_storage.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index fc4818fb2a8b8..42fd2d6ffd88b 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -463,7 +463,12 @@ static int fsg_setup(struct usb_function *f,
 	u16			w_value = le16_to_cpu(ctrl->wValue);
 	u16			w_length = le16_to_cpu(ctrl->wLength);
 
-	if (!fsg_is_set(fsg->common))
+	/*
+	 * fsg_is_set() warns when common->fsg is NULL, but that can happen
+	 * normally while a configuration change installs or removes the active
+	 * function.
+	 */
+	if (!fsg->common->fsg)
 		return -EOPNOTSUPP;
 
 	++fsg->common->ep0_req_tag;	/* Record arrival of a new request */
-- 
2.53.0



