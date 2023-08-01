Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FEFB1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C72F2C433C8;
	Tue,  1 Aug 2023 09:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883185;
	bh=nvaf1Aau+umQaioTIzUMApzZOxtaOdEeuODxgLDwNTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=buziWvCiHvqFw+EX1OvyAL/ui277ovBRJ/jlpi6UTjH8jwClQvzCXRh8N/jIgXhn1
	 UnQhUegi0xFoAkkqhK2qrMGUIT+D64vygVMLbFz0vEsdLVXmfSEZkbwnWBlJw2jUwD
	 oUF7uwzVPR0n7ZksWQKnbROBFVX1Hg8yHvT616pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.4 145/239] usb: gadget: core: remove unbalanced mutex_unlock in usb_gadget_activate
Date: Tue,  1 Aug 2023 11:20:09 +0200
Message-ID: <20230801091930.890547290@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit 6237390644fb92b81f5262877fe545d0d2c7b5d7 upstream.

Commit 286d9975a838 ("usb: gadget: udc: core: Prevent soft_connect_store() race")
introduced one extra mutex_unlock of connect_lock in the usb_gadget_active function.

Fixes: 286d9975a838 ("usb: gadget: udc: core: Prevent soft_connect_store() race")
Cc: stable <stable@kernel.org>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20230721222256.1743645-1-m.grzeschik@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -878,7 +878,6 @@ int usb_gadget_activate(struct usb_gadge
 	 */
 	if (gadget->connected)
 		ret = usb_gadget_connect_locked(gadget);
-	mutex_unlock(&gadget->udc->connect_lock);
 
 unlock:
 	mutex_unlock(&gadget->udc->connect_lock);


