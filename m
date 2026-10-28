Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216371;
	b=WGuYonX9G2BxEO+LtPPJHandisFkhLBggHD/zTC0ICX/Y4rWKnac5pLcNPSgQKyTPBtK
	 Zez8RCAqk3X+bhS3x86rCFF6eHkki0uDZT4SAoR0GGzFyf5zA35/+kqucpZyqRtDwS/jM
	 dGJw2bJv3djVNusGhJopt0+XmYhnal5uuezWw+mQa3XVHEHNrvwQHhxpS3Fr8z0XLK0rD
	 mXP8QRjo4jJe+0L8npmHnLe0T+0xj58RncSQuQIJwmKNO1RgcvZeTz1WUlFT7uSgJ1LJQ
	 ofwyDFlyOQq1G7VeWSLuEgqur6reK/xg13GFhCc+zbB5tY/Cmjrjkg3AJkIgaM19krg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216371;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mHuCE8vuNnnr1D114vTCZQijCl93yh191EhmaMW/R8g=;
	b=CP/cYGDws0fvuMWA6nxLbkJc5CqXUcqBNLcBAKa6QLm6XBXLk+WTr5YAvPWxo1jfCoxi
	 7oXc5wQM65o26rMb/21HTthkz7NsPn74oiW80URiBbS+XJv6cqrEJLFe4hQrTK2QbrqJy
	 ZeIKnjNwnB9AE3e9fwfvYUAXdATWwVpac9Fp/8rUSz5ibM/qNjxDxwJYO2eBbFD8nfyOu
	 tX+vDr0dWlR1CH4DIJ4thvYw8ZzY+evm2AOMC8gB8fig3UIzpfW16DlfEFVOfUQNyau85
	 hIHbQj5RzvHvMUfRI/bIYk+M8U6Sji1GEUVjOsmgfjUmox4X8yZ5xvjMlAtDToiyLaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fLJG14xs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 238F2606A31E;
	Wed, 28 Oct 2026 19:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fLJG14xs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611C01F01825;
	Wed, 28 Oct 2026 19:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216371;
	bh=mHuCE8vuNnnr1D114vTCZQijCl93yh191EhmaMW/R8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fLJG14xskKct/UC4DC5EzfLrQzlMfXlMzGmtR9vQ9+nFsx1JmZX7rFof7rqoaq7GA
	 HVQfgWhEgBMy/nwWNyYSKHQiHeZmRyky+5wGiXD0weN9A+ijgb+qmkvhK47F1rMpVC
	 epMPkn7l857omo/tCiahNuZwLBhVb36fK6RIUovI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Keeping <john@keeping.me.uk>,
	Peter Chen <peter.chen@nxp.com>,
	Hulk Robot <hulkci@huawei.com>,
	Allen Pais <allen.lkml@gmail.com>,
	Will McVicker <willmcvicker@google.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Zhang Qilong <zhangqilong3@huawei.com>,
	linux-usb@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1507/1887] usb: gadget: f_midi: Annotate struct f_midi with __counted_by
Date: Wed, 28 Oct 2026 18:00:03 +0100
Message-ID: <20261028170533.754830730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 182717026e2c8e6cc3b5757f601c3fee15f64ecb ]

Prepare for the coming implementation by GCC and Clang of the __counted_by
attribute. Flexible array members annotated with __counted_by can have
their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
(for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
functions).

As found with Coccinelle[1], add __counted_by for struct f_midi.
Additionally, since the element count member must be set before accessing
the annotated flexible array member, move its initialization earlier.

[1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: John Keeping <john@keeping.me.uk>
Cc: Peter Chen <peter.chen@nxp.com>
Cc: Hulk Robot <hulkci@huawei.com>
Cc: Allen Pais <allen.lkml@gmail.com>
Cc: Will McVicker <willmcvicker@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Zhang Qilong <zhangqilong3@huawei.com>
Cc: linux-usb@vger.kernel.org
Reviewed-by: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20230915195938.never.611-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: 7e07d3e4c389 ("usb: gadget: f_midi: initialize work in f_midi_alloc()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_midi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/function/f_midi.c b/drivers/usb/gadget/function/f_midi.c
index 3b4ec6c0a39b3..c060e797de6f4 100644
--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -99,7 +99,7 @@ struct f_midi {
 	unsigned int in_last_port;
 	unsigned char free_ref;
 
-	struct gmidi_in_port	in_ports_array[/* in_ports */];
+	struct gmidi_in_port	in_ports_array[] __counted_by(in_ports);
 };
 
 static inline struct f_midi *func_to_midi(struct usb_function *f)
@@ -1360,6 +1360,7 @@ static struct usb_function *f_midi_alloc(struct usb_function_instance *fi)
 		status = -ENOMEM;
 		goto setup_fail;
 	}
+	midi->in_ports = opts->in_ports;
 
 	for (i = 0; i < opts->in_ports; i++)
 		midi->in_ports_array[i].cable = i;
@@ -1370,7 +1371,6 @@ static struct usb_function *f_midi_alloc(struct usb_function_instance *fi)
 		status = -ENOMEM;
 		goto midi_free;
 	}
-	midi->in_ports = opts->in_ports;
 	midi->out_ports = opts->out_ports;
 	midi->index = opts->index;
 	midi->buflen = opts->buflen;
-- 
2.53.0



