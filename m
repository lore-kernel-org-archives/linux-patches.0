Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060488;
	b=D9lksp1a9z2c1k9SsPLIsn73ri0bCZQ6q4NKTK7Nl0/rUbgPLExSWUureyQhKqOCb25O
	 BnlJusXhZhnnnBgn/WmFf+wZ35qQONL3Ca3IMkrHM98LD1XF+VV54+YqZzU+xkLMjBzBD
	 ClTkp88JJMEEiK3+Uy/8TZESqcyOoAMbpzpHoekkQhZSS9E17eWS3QE5o0oliPIrr9bA+
	 wzG14D2l34l68FIci7qDqpuf8u6BcJPT0M6DjPzgGAUvVn8cd4xREHtTpWE1W+ia6d2Z0
	 Sp2l3Agry6/5qdc7J7goDjWJYU7iHbQCSxQVzOMyZXfYF7fEnUhNchwvSsQ6kyuPf0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FLVX4dt1R4chUfMbrZ7w//LH2MJBCtuhcnKusLG+syE=;
	b=0GKJ6xHEtN4pSCIijP7tRMISGRwWMKUfR9+WaePfwni4wqPaEoU7roRvntT1eZcn4RSi
	 CWFO1M63l7VR4MIRNWZrmhnbfawHm2W8PM4tFGsiEHVbum4IFTq56FiQRiTNB3U9/FfCl
	 Xv8k3/Gy1U7Za1W612zUjO89Qrw8/lAnGQHGG/SFcdKZp0KBXHKMqWysJYksOBurUB0Xl
	 z9GgIFHKJEELNM26NaWmnX0OuaRJKcvjpc/4sPIkOt5N4UQ3UaXfT5b08bhIhks9zwMnJ
	 KwlZuCLn97QblmJI/Y8YjYHX08+PdXghuejG9vD3cGRbLZWfVVDqI4i5FJ4McKQYD2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q0li9kWN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EB3606A320;
	Thu, 19 Nov 2026 03:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q0li9kWN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEBB1F000C4;
	Thu, 19 Nov 2026 03:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060488;
	bh=FLVX4dt1R4chUfMbrZ7w//LH2MJBCtuhcnKusLG+syE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q0li9kWNgr2zQs5kLp48117k302fX96LRjKEMnJAkDdrVFskpcFTF79VEsVBaisNQ
	 W4Ep2H96JQQyBX+Pr73ZNtfngbJJhnpSo9v04QQ/nY9WWjHZnNXDI+nbZoGVSHgTcx
	 GH5yJTolfAXbstrsu2TEGtKdkdnbghD/dDvPySos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d31109047baed8f3b590@syzkaller.appspotmail.com,
	Keisuke Tsukuda <tkdkei@outlook.jp>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1217/1848] usb: gadget: f_mass_storage: ignore class requests while inactive
Date: Wed, 18 Nov 2026 15:54:15 +0100
Message-ID: <20261118150010.918418479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4d47e5f25dc57..ec7b4f2b85770 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -493,7 +493,12 @@ static int fsg_setup(struct usb_function *f,
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



