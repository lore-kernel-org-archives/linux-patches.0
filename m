Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CDB611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:13:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2510C433D2;
	Sun, 28 May 2023 19:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301233;
	bh=3n+SNcNMcP7hfTQJNvXdLvIKxdODuYOCP6fDOZ6oYRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYPCccfyYfUtxnBsBUcpC1uU8ZT80LVlx7Yfnwp8bvgUqM8GoabUOH96s9kUJKqO9
	 ngon5FKMVE7dWtJsibYTILjtja6NI2B5+Tu1N9YX4hgDz7oduWHZNMpqTyjxMGOj4a
	 xHqDpjOW7Qc65+icHR0HDYrc4ijny5nLd7p4ZGaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 35/86] Input: xpad - add constants for GIP interface numbers
Date: Sun, 28 May 2023 20:10:09 +0100
Message-Id: <20230528190829.885786347@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.564682883@linuxfoundation.org>
References: <20230528190828.564682883@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
index 1a12f95227301..f1c2bc108fd76 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -506,6 +506,9 @@ struct xboxone_init_packet {
 	}
 
 
+#define GIP_WIRED_INTF_DATA 0
+#define GIP_WIRED_INTF_AUDIO 1
+
 /*
  * This packet is required for all Xbox One pads with 2015
  * or later firmware installed (or present from the factory).
@@ -1830,7 +1833,7 @@ static int xpad_probe(struct usb_interface *intf, const struct usb_device_id *id
 	}
 
 	if (xpad->xtype == XTYPE_XBOXONE &&
-	    intf->cur_altsetting->desc.bInterfaceNumber != 0) {
+	    intf->cur_altsetting->desc.bInterfaceNumber != GIP_WIRED_INTF_DATA) {
 		/*
 		 * The Xbox One controller lists three interfaces all with the
 		 * same interface class, subclass and protocol. Differentiate by
-- 
2.39.2



