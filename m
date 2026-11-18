Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035708;
	b=Cxmxk4YH4049IzqpFdwWRHr9wlONN4BNWmKTXLTexvKH1tW0CgdHT0KZdUVAQfTRGCBR
	 tP+fSZEmFfiH/QJh4j4D6Ky3PakLL956WcR6xaJX0ktrgZwjyJePaHL+PAJb9q3cK4hdx
	 JtG6CIgcW8WLrjGwtDV+pnKVMolPsmcBniuJLCk/ZtXTLK6SImWjE0K4XOgUXk8+lYT9F
	 BJHuH0RUUrDrnXfKWl6O/zpISo75NLnJfyvDBc50QsT8D1aPnIHJ6p9kwkh4pSFYFg3Im
	 3xjtbXedARZN2+yKVtS2VZsTdyvI4ydHnZcRzckZHi73eC2B5yOIa0HBM8ZEGIR//fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KXEJIrnRFEaeVi4YankqMVIBKr9xEEiAUnHQdrXeXAA=;
	b=f6gIYoqD5uQ/t2SIKdtpzG6k30pM/3J37x9gexeOJ9EXrTO0dLcwsD9XtoBR8AsVCpCn
	 fMLgMysLd+CULCPtoG36WurybZDr3Zj+l+v03iYOcDw9k40mpW7i/O79RKDYg7eGYrSjb
	 U9y80d48Ql3yt5wbCgTupsKo/HYEJzoJKCm8h/LxrCKEavLiz3nRkWOZos4pYXP9l/hqk
	 gC08Wtg5oGCGgcGhl0+iV1iAU5+nzZ07cLA/80gwRJMOdKnjJU1cZiVZjOCrT01LlXmH8
	 jSvHkwY+ut3hnIbfYr6RVC4BS+MRYi9Uffh3jKJs+b4fmjVcc6Hd8zFhH42a6utfvYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zserKuex;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37457606A336;
	Wed, 18 Nov 2026 21:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zserKuex
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5521F000C4;
	Wed, 18 Nov 2026 21:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035708;
	bh=KXEJIrnRFEaeVi4YankqMVIBKr9xEEiAUnHQdrXeXAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zserKuex9DI0qh57qOchGPSppcEmp7vvOcbGfqmW6zshcaeh9gf8d+Idb/OVVEJTq
	 OmGG0W1wAr9WDmPCv3NneCHw0X7ipg4skIAbtq1E5OFV8uMCmrqNlv5YtkCj21ybsF
	 orWUoFmTpxWy7ji2hszhmmruJX1F3ainvxe4zCAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0800/3318] media: redrat3: Ensure all urbs are suspended
Date: Wed, 18 Nov 2026 15:23:42 +0100
Message-ID: <20261118150342.930918159@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 1582f545273f2aa4eb4ee6f3a89b433f5c85c68f ]

Ensure that the learn urb is stopped before suspend.

Fixes: c49fcdde38cb ("[media] redrat3: enable carrier reports using wideband receiver")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/redrat3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index b99279ae24bfd..aa9242bc604b0 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -1170,6 +1170,7 @@ static int redrat3_dev_suspend(struct usb_interface *intf, pm_message_t message)
 	usb_kill_urb(rr3->narrow_urb);
 	usb_kill_urb(rr3->wide_urb);
 	usb_kill_urb(rr3->flash_urb);
+	usb_kill_urb(rr3->learn_urb);
 	return 0;
 }
 
-- 
2.53.0



