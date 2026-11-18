Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036227;
	b=nWdOF8CRJFai/MYa02RMIUZ4twyLxqdOuEc/N7AfJTCyh+kxkrqPAdT5ynEpNItfZLmd
	 6W78TK70/UljAk+k6NXoUj3RB2WnqIdx3GsqcmzY7WYfr86VowR0yUhIj9CNNsYkuiWdU
	 GhETxm1uXWUz1ZdORTaXczDCBGjjXHUSPEzCosYivCk9G+n+/ANoVzthDL+rLeRwb+u8L
	 1853a1bsG/V6cxdx4IvE4zfnasV0Ay964py/nQGdXL1jP9KtTkxjREXFxlf7gl+qPK+kV
	 7+dEO/GLWvAucUkEykjHIwRefFg4Yw7MbAqgJfMWPotYJr2G0RALje5/DUVtOm4INGQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rt6BJjJ8wuKDHQXkNC+SVZWN3wpkFophw5ad/8aa/SU=;
	b=Ea9Tw5nvMxMNzn9xCnVtYaGJNZJtKlLQsYjMF1VzgMUQYlFF3+C/vH4/GJGUWIkvQROb
	 7RNrfUpDDHoa7gf2WKIQ+z1yF84oTUPFt+57t2r3MLwH+VrCnFYJ2JN+Rx7DoCS7IrP60
	 kIhDCZBIJbbahba8k6BGDuBDdCM8+Bk3eUk6PSosQwOWe3rbRnc5aYCZgY9wHIXgyUo+y
	 J36JYLR94r1tuMpwRzgWxoePdKbcwK2c/DKBj9w9hASDVq1300TTmQVlyW1sA9IUYalhF
	 ulAoVABmC4eAyWWXLKReeEn24Sqb6piR/hAmm2/oBPOVIOmGfemqDtr64H4XHGiKsLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ap48yCQA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13921606A32A;
	Wed, 18 Nov 2026 21:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ap48yCQA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F1011F000C5;
	Wed, 18 Nov 2026 21:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036226;
	bh=Rt6BJjJ8wuKDHQXkNC+SVZWN3wpkFophw5ad/8aa/SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ap48yCQAnuHy2XV1grotdffJGWeY5tUYKRV/9xSvRdPrwDibgMkFd0d4C2BUCk5B9
	 wbUSEhxyT3EuH22BojrKnw4gZXFI7KNfYjObG0RNebo2Fx57JTPTB72tqm8zFnypse
	 rEsJdaDfsDB3F5qa6/diZD9DPJwm/tVl7b7Y/htM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Jie Law <98lawweijie@gmail.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0985/3318] media: uvcvideo: Fix NULL deref on events for uninitialized controls
Date: Wed, 18 Nov 2026 15:26:47 +0100
Message-ID: <20261118150349.319541195@linuxfoundation.org>
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

From: Wei Jie Law <98lawweijie@gmail.com>

[ Upstream commit daa379e2b74d6c10ba4e3b56eeca5aa8c8704fca ]

A null-ptr-deref exists in v6.12.105 and upstream. KASAN crash log:

  KASAN: null-ptr-deref in range [0x0000000000000080-0x0000000000000087]
  Workqueue: events uvc_ctrl_status_event_work
  RIP: 0010:uvc_ctrl_status_event+0x105/0x280
   uvc_ctrl_status_event_work+0x82/0x240
   process_one_work+0x66f/0x10b0

XU controls are initialized lazily, on the first UVCIOC_CTRL_MAP or
UVCIOC_CTRL_QUERY.  Until then ctrl->info is all zeroes, so
info.mappings is not a valid list head, list_empty() returns false, and
uvc_ctrl_status_event() walks it from a NULL next pointer.

Fixes: e5225c820c05 ("media: uvcvideo: Send a control event when a Control Change interrupt arrives")
Cc: stable@vger.kernel.org
Signed-off-by: Wei Jie Law <98lawweijie@gmail.com>
Assisted-by: LLM
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://patch.msgid.link/20260907121844.2592492-1-98lawweijie@gmail.com
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index bd90d8bacd5ef..20702609003e7 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1615,7 +1615,7 @@ bool uvc_ctrl_status_event_async(struct urb *urb, struct uvc_video_chain *chain,
 	struct uvc_device *dev = chain->dev;
 	struct uvc_ctrl_work *w = &dev->async_ctrl;
 
-	if (list_empty(&ctrl->info.mappings))
+	if (!ctrl->initialized || list_empty(&ctrl->info.mappings))
 		return false;
 
 	w->data = data;
-- 
2.53.0



