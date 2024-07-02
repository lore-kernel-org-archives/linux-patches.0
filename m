Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9972815B0FE;
	Tue,  2 Jul 2024 17:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940407; cv=none; b=EciLQ7DDJMVd/HziKEbnZbAYHjiZVu0kYHM5gAet6x52DMwXwnW+XKJEUDqw7QbukFlPiDQ7uAnmCN8HCs78qxbZmhRgc2TEgnlRMac4/emvDC3run0+Ni2V1/KAgSKsvNpaKxVcTY4yFS2UZ9AcboJhcGsWfI28S9ISRbDqpYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940407; c=relaxed/simple;
	bh=VtXlEKHHegu8+IoWo0KRnCmTZhtP9/rD/p2UOKIyzGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FV3Vllenp6JGyIv8fMZ/J5TuNr6SuAUtlUJbNaCimrvOdrXx9IhLzxlp/qyWFC3k02LV5BrxayRAdYvtmyLcNlv4m5le0J+6SwRzIfJBNipS0On+tvIvTpLXvmJ8ZeBRYF/keFQfEUYkklC/iOjtAEDR0+SrGcAnzlIdnJVnbvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CjYiqfXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjYiqfXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FCEAC116B1;
	Tue,  2 Jul 2024 17:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940407;
	bh=VtXlEKHHegu8+IoWo0KRnCmTZhtP9/rD/p2UOKIyzGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CjYiqfXQWI4MqN1eKpnq5oNyCcX1AMWXhB/qyKCkLkdjQUFpAIjr6Y2deYUC8Szzv
	 92ZoPN5pIlR+eIjyHdERoBvkI4ObeGAR6WL/X1fCZqETndZfsTSoZmOrNkbZIoOeEH
	 QNhmNNcPXz2opz1NfAgkBxyziRlKejpFMo5krKuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.9 144/222] usb: gadget: printer: SS+ support
Date: Tue,  2 Jul 2024 19:03:02 +0200
Message-ID: <20240702170249.482870805@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit fd80731e5e9d1402cb2f85022a6abf9b1982ec5f upstream.

We need to treat super speed plus as super speed, not the default,
which is full speed.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20240620093800.28901-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_printer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -213,6 +213,7 @@ static inline struct usb_endpoint_descri
 					struct usb_endpoint_descriptor *ss)
 {
 	switch (gadget->speed) {
+	case USB_SPEED_SUPER_PLUS:
 	case USB_SPEED_SUPER:
 		return ss;
 	case USB_SPEED_HIGH:


