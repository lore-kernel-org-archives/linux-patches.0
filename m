Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DBB629
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C292C433D6;
	Wed,  2 Nov 2022 03:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667359475;
	bh=3To5j5enuhG1lOVJ7Z8kTMk0Kw7z3PjmXhUbIrsSzz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zFsy9a7RQAg/bpuJEVQoeubJ2teZMM2yfdNUKTGAxnI5G721svKzj/h+PBK7PGx12
	 DKZ+06+X6MBqB4MfY6hPuIuCtmB/YOOil4pDww80NZFfPkmKbiFsMqn2hBpj0t9M1Q
	 FcDnpR58oPOLueXNXxRy3gAe2SGTnXNCswPyu79M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justinpopo6@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.4 08/64] usb: bdc: change state when port disconnected
Date: Wed,  2 Nov 2022 03:33:34 +0100
Message-Id: <20221102022052.091282992@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
References: <20221102022051.821538553@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Justin Chen <justinpopo6@gmail.com>

commit fb8f60dd1b67520e0e0d7978ef17d015690acfc1 upstream.

When port is connected and then disconnected, the state stays as
configured. Which is incorrect as the port is no longer configured,
but in a not attached state.

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Fixes: efed421a94e6 ("usb: gadget: Add UDC driver for Broadcom USB3.0 device controller IP BDC")
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/1664997235-18198-1-git-send-email-justinpopo6@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/bdc/bdc_udc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/udc/bdc/bdc_udc.c
+++ b/drivers/usb/gadget/udc/bdc/bdc_udc.c
@@ -151,6 +151,7 @@ static void bdc_uspc_disconnected(struct
 	bdc->delayed_status = false;
 	bdc->reinit = reinit;
 	bdc->test_mode = false;
+	usb_gadget_set_state(&bdc->gadget, USB_STATE_NOTATTACHED);
 }
 
 /* TNotify wkaeup timer */


