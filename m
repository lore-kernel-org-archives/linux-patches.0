Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216406;
	b=MDT68PYtwSXPEgq1JYFPUiAYH4mb+Jt/dMYr7kNINGrru7UJdFQcEt8owb5QNsYufFQ/
	 vrpKNgUE55FddhqNSpysxaDgRpG4Ag6+dFOcq/F7+4CWar7LS2naoqqUAqzH9kKdgK4vx
	 jQyOnACDV5APReVRsQHVd0mRO+ZGSC2owf9esADC6LPEXAeFVJn99KNLBE11KAzp1cSsK
	 86l4XnhcnOHxLj2mKQ6I7P5aV8ATcv+RwQd22ssxgr0te9k2m8D/Kw9T/quqQLPE+dG20
	 +TTSFlKIaMWn3IJ8BqsqpKvxVcGpfNsAQh/dEoN/bu/p7mKQAFCnCA7BhVGrhVa/rVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IIEjDcI6b6iH3mjprLA+rx/rKLunTfnyMKPDy0e9qE4=;
	b=y7kgYV9GqGOV+TfrRL/g2aKFtjT+CUFCiRI36RJ6t3LJt3GpuSey9wC5dFvq6X6rytQ6
	 UGMZoxrUimgEJ6afpUorFBi89TfMfOIU7YcdZKflOcZixvfjBEuKjnm/wyeyU1iaxVVSl
	 PvHHSc3GSrwR9dt8SXzHJY6ptgFJVdnMQKMt8QyaoHsgy/c5GQIDD1UXlWs9vUBFntvjH
	 aJV2akUDX95FWbEeo0Hw7C0yQ2pHhLDmk7V/tqo6UqZK5CGBtIQdXOSTRCoE0NmEbCegj
	 x1+Fl5z/lqvAAPgFhSmrVXhihdPWu0LFhFx1g6f5/xSc/hGPE3WFjCSu64nabju2C4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RLCksp3w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C73606A325;
	Wed, 28 Oct 2026 19:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RLCksp3w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E84B71F01825;
	Wed, 28 Oct 2026 19:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216406;
	bh=IIEjDcI6b6iH3mjprLA+rx/rKLunTfnyMKPDy0e9qE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLCksp3wnDtbgfcQXfAavQTXlEz5mQLmCwVnDi5R1/+BPabnPuFcu4pyzubdu6unv
	 w6HKpyeqzj9IxNahV5XFEamOh6vj5N6lKdgxNd4eQd0f2eVHzjBsdFHmqnVl6eRYp6
	 Zv9kMp80tCjrG/Ku1kIoOb1oTnsDVf6WnIbjUhDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d5fa3d224505c8610702@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1508/1887] usb: gadget: f_midi: initialize work in f_midi_alloc()
Date: Wed, 28 Oct 2026 18:00:04 +0100
Message-ID: <20261028170533.778741987@linuxfoundation.org>
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

From: Jeffin Philip <jeffinphilip14@gmail.com>

[ Upstream commit 7e07d3e4c389217d7d7171d80edf2e23ac70f1ea ]

f_midi_alloc initializes free_ref to 1 and it can only be incremented
when a sound card is registered via f_midi_register_card().
f_midi_register_card() is only called in f_midi_bind() which actually
performs INIT_WORK. If f_midi_bind() is never run, work is not
initialized and the if condition in f_midi_free becomes true,
this results in a warning later in __flush_work as work->func = 0.
Fix this by moving INIT_WORK from f_midi_bind() to f_midi_alloc().

Reported-by: syzbot+d5fa3d224505c8610702@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d5fa3d224505c8610702
Fixes: 8653d71ce376 ("usb/gadget: f_midi: Replace tasklet with work")
Cc: stable <stable@kernel.org>
Signed-off-by: Jeffin Philip <jeffinphilip14@gmail.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260815054006.102325-1-jeffinphilip14@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_midi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_midi.c b/drivers/usb/gadget/function/f_midi.c
index c060e797de6f4..f556fe7163c00 100644
--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -877,7 +877,6 @@ static int f_midi_bind(struct usb_configuration *c, struct usb_function *f)
 	int status, n, jack = 1, i = 0, endpoint_descriptor_index = 0;
 
 	midi->gadget = cdev->gadget;
-	INIT_WORK(&midi->work, f_midi_in_work);
 	status = f_midi_register_card(midi);
 	if (status < 0)
 		goto fail_register;
@@ -1371,6 +1370,7 @@ static struct usb_function *f_midi_alloc(struct usb_function_instance *fi)
 		status = -ENOMEM;
 		goto midi_free;
 	}
+	INIT_WORK(&midi->work, f_midi_in_work);
 	midi->out_ports = opts->out_ports;
 	midi->index = opts->index;
 	midi->buflen = opts->buflen;
-- 
2.53.0



