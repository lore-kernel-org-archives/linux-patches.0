Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE12635DA41;
	Sat, 17 Oct 2026 17:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259892; cv=none; b=UKq6lEE5PPe65VI2RfjtpPLxXifIe3b4V4ifMNpxO2PuxMErh7mYQ3uYyeGJTz4EjWsYM5BA6SESkBzzCytX2K/EaQsVeC9pv4a3IFX7mUo51uVsOowpC06d9guX+FiVPXrLAVbh0mHeCpUbnsYIMt9z09Do8HiDPAggvuqLORo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259892; c=relaxed/simple;
	bh=0rZ5CCXKDES5MfEC1rXI6jTa0AUEv/H9LlBPZKhROnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTbFeyWIjuopI2NClv7CnUiBFqXdwkcMeCFp7YST/QOPxu7Fp0vmS4XPgA5nC8L0xvAknS94dL1MPLNu7tYpU5n1Cvd0zcckCOR/1pv61tH0dlTUYqWBTmdCHkRWvLKJ+4HoKyrGdzoRwy30nooXKwXJGT862Q+bh5wXaMFpJBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffiTyoFJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffiTyoFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251941F000C4;
	Sat, 17 Oct 2026 17:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259890;
	bh=T7kbVBzgAgCgBlUnKlLh1xsJ6xOx8X3/Sb7vEFGuR/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ffiTyoFJapv1N4cwO3CNfEgTWd4HXmK/EV+S7mi9j2I3SzxeYGnaGy814bcBX/fRB
	 SK6gn/mRsSeUpbtTgh175gfF+asyCjXJqJxO/2Cm+GC2VQgXzgoZLakxLZmiTWu0Bf
	 jU4hRmHkd8UhWxjrAyBVhyBv9OGj9BeYYtaj88iw=
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
Subject: [PATCH 6.6 1362/1674] usb: gadget: f_midi: Annotate struct f_midi with __counted_by
Date: Sat, 17 Oct 2026 18:00:34 +0200
Message-ID: <20261017160506.116598138@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 680651e91a523..48c87f5b1a4e1 100644
--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -99,7 +99,7 @@ struct f_midi {
 	unsigned int in_last_port;
 	unsigned char free_ref;
 
-	struct gmidi_in_port	in_ports_array[/* in_ports */];
+	struct gmidi_in_port	in_ports_array[] __counted_by(in_ports);
 };
 
 static inline struct f_midi *func_to_midi(struct usb_function *f)
@@ -1359,6 +1359,7 @@ static struct usb_function *f_midi_alloc(struct usb_function_instance *fi)
 		status = -ENOMEM;
 		goto setup_fail;
 	}
+	midi->in_ports = opts->in_ports;
 
 	for (i = 0; i < opts->in_ports; i++)
 		midi->in_ports_array[i].cable = i;
@@ -1369,7 +1370,6 @@ static struct usb_function *f_midi_alloc(struct usb_function_instance *fi)
 		status = -ENOMEM;
 		goto midi_free;
 	}
-	midi->in_ports = opts->in_ports;
 	midi->out_ports = opts->out_ports;
 	midi->index = opts->index;
 	midi->buflen = opts->buflen;
-- 
2.53.0



