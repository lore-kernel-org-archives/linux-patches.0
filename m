Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2B119FA6A;
	Tue, 16 Jul 2024 15:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144579; cv=none; b=HabAj3xodRKkVAKlsMNaS6wEqbwqn5REVRejf6JW6f0f6RBTS0Zc/Onmzr2mNUMGfWRM4bAAaeaBb0uN5eTCx1s1fH9MzrbgAczVpZnbPmOFoKduWADleAKZLsbMAZ5+02OQw2M6IH/LytroSn4YSdwmOLrGVERLG2rRLuCWf8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144579; c=relaxed/simple;
	bh=jJzleNTJY38zCS6V9r+lKKex1WbyR5ZLkcVZENOW7yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZoDXy5cj0ciCeYA55ZCXT+FpiW+HOCaY2Hm+eh9llci8q+NWPzxjFHkm7Fu2qGDbZ05teY67aX6oc5iYu9/eFxNcwxwM9dfECB805pupRrRybgoOctGq+HqY1VF83HrD5Liq1GoEJnVj54ZEWmqBq/PH+vmZiDRlf0H6FNizB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wUY8p5db; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wUY8p5db"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37651C4AF0F;
	Tue, 16 Jul 2024 15:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144578;
	bh=jJzleNTJY38zCS6V9r+lKKex1WbyR5ZLkcVZENOW7yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wUY8p5db4DnXg3zcCW+/fWYn/G/4AB6gLpuUUiCevpINESt/kG5muByKtKHToyfwH
	 yGWmQW2OvuSyykAxaKj8Ll6ovn1mEQKu+9zOUUx6ubWujhl50/iWSuL0DSk+tOezLr
	 ApIcka7wzu/XXgHUNK2bwTC8PcL3FnjRUXI3Uwo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Assarsson <extja@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 039/108] can: kvaser_usb: Explicitly initialize family in leafimx driver_info struct
Date: Tue, 16 Jul 2024 17:30:54 +0200
Message-ID: <20240716152747.496869070@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jimmy Assarsson <extja@kvaser.com>

commit 19d5b2698c35b2132a355c67b4d429053804f8cc upstream.

Explicitly set the 'family' driver_info struct member for leafimx.
Previously, the correct operation relied on KVASER_LEAF being the first
defined value in enum kvaser_usb_leaf_family.

Fixes: e6c80e601053 ("can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression")
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Link: https://lore.kernel.org/all/20240628194529.312968-1-extja@kvaser.com
Cc: stable@vger.kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
+++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
@@ -114,6 +114,7 @@ static const struct kvaser_usb_driver_in
 
 static const struct kvaser_usb_driver_info kvaser_usb_driver_info_leafimx = {
 	.quirks = 0,
+	.family = KVASER_LEAF,
 	.ops = &kvaser_usb_leaf_dev_ops,
 };
 


