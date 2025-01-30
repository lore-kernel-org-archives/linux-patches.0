Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A04E1BD9D3;
	Thu, 30 Jan 2025 14:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247321; cv=none; b=NkH2mASud+t9w2dYGYm32jYGk8ivXPUXwj9VLUStrSskn11/oXdajK2nDylbXMEfitJXw3MQ0FYV3VpYZeFmuHFYkGvLosK0x95k6xIQ5FEJ5nrJam6aO9kA9LtKaVj9ORHUofdz9DM6Lc+0WrVjfzPU4jlEV893kTXmLByaSDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247321; c=relaxed/simple;
	bh=4dNFhGXueTJHoSXibmMXkBp+gf9ypQxuFRbFesC50ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbiY19T/My7hSKRMZHIOL8DKxOQftCIDhyO+30MvkPOSiq7WkvI346bE5tasxQSbPGjdSb5j/2BZT376pGNsqyaK3py28qwkjWC/NE8BVx/2k8vo1FDKaOheE4DbOj51ZzgqZmdLNu4ZwzCenu2LI4psyTbRQMxwlSn0xkNFdUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wfcI9WaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wfcI9WaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A3CC4CED2;
	Thu, 30 Jan 2025 14:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247320;
	bh=4dNFhGXueTJHoSXibmMXkBp+gf9ypQxuFRbFesC50ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wfcI9WaFNC1szzWLcMgiqr6rG+QkMdpHmEf12pArE0fuwvFEUMKHB9ZKgTGK95Vvl
	 IDomi1vkI96RGyle/ZFIDfgsExaSGZk67yPe6K2Hpe6jdkur/o2aWW/GFWELht2b7V
	 cEYyddvr62Pj+bkivntY4Bv2sTUth7aT+ks2ruOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Greiner <jack@emoss.org>,
	Pavel Rojtberg <rojtberg@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 24/24] Input: xpad - add support for wooting two he (arm)
Date: Thu, 30 Jan 2025 15:02:16 +0100
Message-ID: <20250130140128.256839687@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140127.295114276@linuxfoundation.org>
References: <20250130140127.295114276@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jack Greiner <jack@emoss.org>

commit 222f3390c15c4452a9f7e26f5b7d9138e75d00d5 upstream.

Add Wooting Two HE (ARM) to the list of supported devices.

Signed-off-by: Jack Greiner <jack@emoss.org>
Signed-off-by: Pavel Rojtberg <rojtberg@gmail.com>
Link: https://lore.kernel.org/r/20250107192830.414709-3-rojtberg@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -349,6 +349,7 @@ static const struct xpad_device {
 	{ 0x31e3, 0x1200, "Wooting Two", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1210, "Wooting Lekker", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1220, "Wooting Two HE", 0, XTYPE_XBOX360 },
+	{ 0x31e3, 0x1230, "Wooting Two HE (ARM)", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1300, "Wooting 60HE (AVR)", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1310, "Wooting 60HE (ARM)", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0607, "Nacon GC-100", 0, XTYPE_XBOX360 },


