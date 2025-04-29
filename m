Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B066B21883E;
	Tue, 29 Apr 2025 17:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947944; cv=none; b=AI7bKt6SZcLsBzq+zNxUilUCqRXPadbwU7VKqKo7kqo7DMpEZ4GVW7AjNEFNZ9cB2MxHs8G8dlIRE+1U0HBwekLBtQHS33ypuba88JRps3mzDyW53dXCQeyHL3ME6ilxAka2yfAItTw6FpUGMauGEt+7+pLgwDJv4WN/ekz/C3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947944; c=relaxed/simple;
	bh=BR8B/YQDhRHkD9hEityDdqrn6zSVJQwJziEvq83ETHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GluerpG/MtgjUx1sgkQm4fkDC+9Ce8D8ibMsuCLhZzaFzAXiRdjKgttANTHfdB2HZaGPsgp3CEkRRzOdcSp9FGcPvsm++UT6WfCjJdBTKs5Xqp+dJJprRYpxERfXeJghl4djGYdZCT3pUraUnhztr3l3iaVFhOgEfYFxcqiFgjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlquNlHh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlquNlHh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC5BC4CEE3;
	Tue, 29 Apr 2025 17:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947944;
	bh=BR8B/YQDhRHkD9hEityDdqrn6zSVJQwJziEvq83ETHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlquNlHhUa9OLjrvsbrsq9+Pzv8f4QLctmIGHc2nboscHB1fki+0dsPwbYzN8BWEm
	 OUZDMDMksU0cPGC/wlHnJND6fhFT7yqRiF/vfD6sMR/xM3urxeRFxMqw66JiI2zyM6
	 3FZKElUuN3Cz0gH3fly7LqlWh3ZcJ2PA1MZ1lRqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.12 151/280] USB: wdm: add annotation
Date: Tue, 29 Apr 2025 18:41:32 +0200
Message-ID: <20250429161121.298775289@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 73e9cc1ffd3650b12c4eb059dfdafd56e725ceda upstream.

This is not understandable without a comment on endianness

Fixes: afba937e540c9 ("USB: CDC WDM driver")
Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20250401084749.175246-5-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-wdm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -909,7 +909,7 @@ static int wdm_wwan_port_tx(struct wwan_
 	req->bRequestType = (USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE);
 	req->bRequest = USB_CDC_SEND_ENCAPSULATED_COMMAND;
 	req->wValue = 0;
-	req->wIndex = desc->inum;
+	req->wIndex = desc->inum; /* already converted */
 	req->wLength = cpu_to_le16(skb->len);
 
 	skb_shinfo(skb)->destructor_arg = desc;


