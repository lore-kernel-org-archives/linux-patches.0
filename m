Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC338F58;
	Mon,  4 Mar 2024 21:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588638; cv=none; b=dxcW4h3Is4e0IKbWBQO+/jIWnjuBhPprjr81xpgBxFxu6cygNK3tTxkcDHwdrbzS0xDdC2+5AuoD50TFY7cbYC0x8R76End0LLmLKqNeJU+zyxJb3tMG/uzuLG1CpsG4LC0JeGrhW6unxMyw+Vftbg8TfkddG9Ai656aFbyeTLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588638; c=relaxed/simple;
	bh=KQpem/O09fP8BZlCjnvA1Qk23mhXg7oYUUS8mS5d1NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TrSidsFAEXxDbjNKGdbDmjKBqsaO822V+xz5Vje4DyzxbFMtCzaac0IX3WFzXOW6XcxQJ21fziQAPzt1If9LzFxqu6zPpwGN+B8/nQfGD61w4y2a84YIzEgT3x03AsvN7UcRrkaZjirAtuJgKi5XQHLpgawFAQTKZGmL1uWzjYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tyjU1w01; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tyjU1w01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50441C433F1;
	Mon,  4 Mar 2024 21:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588638;
	bh=KQpem/O09fP8BZlCjnvA1Qk23mhXg7oYUUS8mS5d1NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tyjU1w01nEVAAqmOg0tMAGDuoR/9dloeNMJZX90BEYzMX8LaSTsoidkp4PrkJHlue
	 ddpsF237gYDmN0g4vtipCxkQox4fch1mo/MDodNJF/5O0S+8SHIBnWbuLrtnxfzTOp
	 2bC8DCV/q8gWu03pAghTq/ugwoqZHbLg1H7uDjNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/215] Input: xpad - add constants for GIP interface numbers
Date: Mon,  4 Mar 2024 21:21:19 +0000
Message-ID: <20240304211557.526537850@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit f9b2e603c6216824e34dc9a67205d98ccc9a41ca ]

Wired GIP devices present multiple interfaces with the same USB identification
other than the interface number. This adds constants for differentiating two of
them and uses them where appropriate

Signed-off-by: Vicki Pfau <vi@endrift.com>
Link: https://lore.kernel.org/r/20230411031650.960322-2-vi@endrift.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 02f3bc4e4895e..13c36f51b9353 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -564,6 +564,9 @@ struct xboxone_init_packet {
 #define GIP_MOTOR_LT BIT(3)
 #define GIP_MOTOR_ALL (GIP_MOTOR_R | GIP_MOTOR_L | GIP_MOTOR_RT | GIP_MOTOR_LT)
 
+#define GIP_WIRED_INTF_DATA 0
+#define GIP_WIRED_INTF_AUDIO 1
+
 /*
  * This packet is required for all Xbox One pads with 2015
  * or later firmware installed (or present from the factory).
@@ -2008,7 +2011,7 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 	}
 
 	if (xpad->xtype == XTYPE_XBOXONE &&
-	    intf->cur_altsetting->desc.bInterfaceNumber != 0) {
+	    intf->cur_altsetting->desc.bInterfaceNumber != GIP_WIRED_INTF_DATA) {
 		/*
 		 * The Xbox One controller lists three interfaces all with the
 		 * same interface class, subclass and protocol. Differentiate by
-- 
2.43.0



