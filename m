Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208317;
	b=21XrB+BaJg1f8ptOgTNqGMSmPh2WGwZX1d85v2mlviA7EvX2ALNKDqVa5Ef4uz8U4oMG
	 b6pzTDm4nO0MuDcuW6n+kJV1VmuvS3TY5th09dnpzKsakzHoV+hAuyfbZPQCzbl9jyMcP
	 TPye7A1dhpUpaQ+fDHYOcWxnbWUlumlM4wRdn71f3KAmrUguyNZzWEujhS5GxOr4TrWLe
	 dE2cYdGv5j1/oRvhk6yXzzMe/I3wPfJdIGqCsk5NWHzlWf2A24IZUcxzD094FXBrcZBLP
	 n7ANS9FFjDA4/hpNRHqxTOgfzA9xU+3b7UsZ53FjWyvanRvaxbatvOHu/cjnGiSrtIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NNp7uLiz3RlTlr/Ctnwg4lB6QOulVszF1Rd3o/Oup9M=;
	b=b6UqcsgwOkI9be2aysoJxq0XI8K+fx049J4dDc4wlSVrNM7+rg8uKbSK7R1x+9jM3k+m
	 5f4Xt7vAIjBoJfmcwpOtKhzh3OK3pTkF3KqCpQ5ADVIaoniJkKDRt3yw5KoInPgxNRgOn
	 rpBc3geps/qNvQEVmqiV82f6/DPkarSPSfT92zA+OSAoqWqm3OiHzAZ/RDSiWwrcIoL0A
	 LwahwzK4gGykNf32jocMmIOqN9Uq6+TjR9Hm/0eJ943Acab/zn5EygV/WgiITBONE/79v
	 KlHA0sJf6acmGtsSXo0gv7/o5KSx3CxnKsBHA6wmz7Wpgu83ZxS2b73c9kg+41gFXRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FQNjGNVK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F7C606A31A;
	Wed, 28 Oct 2026 17:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FQNjGNVK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24EA1F01825;
	Wed, 28 Oct 2026 17:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208317;
	bh=NNp7uLiz3RlTlr/Ctnwg4lB6QOulVszF1Rd3o/Oup9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQNjGNVKJAtJ5pWiPR0HUbtnUga+/HQ/30yHR/ffnbS6ENnxLFGsFQ+i3l6iRWVSJ
	 gA85/+J9BQxh/txp8/y0ORXnl8AxC0g/C05jjnCi+GMZWG6PUE7100Jeqagc15jotN
	 DA9h3xqJOCJr1ul/zrW2W1gcC6sZvPSWe6auwUQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+791be35f1fbcc85d06d7@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/516] usb: gadget: f_mass_storage: fix null pointer dereference in fsg_common_set_num_buffers()
Date: Wed, 28 Oct 2026 17:53:49 +0100
Message-ID: <20261028170005.346526858@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeffin Philip <jeffinphilip14@gmail.com>

[ Upstream commit 2c0f5ca48674a5b5f9fa4a9c3325aa48053af0bc ]

Previously fsg_num_buffers_validate() was removed as it was not
necessary due to Kconfig setting the limits for n from 2 to 256 with
default as 2. However, setting the page content in such a way that
kstrtou8() reflects n value as either 0 or 1 bypasses these
restrictions leading to a null pointer dereference if n is 0. Fix
this by adding a check for n < 2 and returning -EINVAL if n is
either 0 or 1 consistent with Kconfig logic.

Reported-by: syzbot+791be35f1fbcc85d06d7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=791be35f1fbcc85d06d7
Fixes: fe5a6c48fd95 ("usb: gadget: storage: get rid of fsg_num_buffers_validate()")
Cc: stable <stable@kernel.org>
Signed-off-by: Jeffin Philip <jeffinphilip14@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260818035904.10324-1-jeffinphilip14@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ adjusted context to retain the branch’s existing kcalloc() call instead of kzalloc_objs(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_mass_storage.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index a9159a95707bd..4d47e5f25dc57 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -2624,6 +2624,9 @@ int fsg_common_set_num_buffers(struct fsg_common *common, unsigned int n)
 	struct fsg_buffhd *bh, *buffhds;
 	int i;
 
+	if (n < 2)
+		return -EINVAL;
+
 	buffhds = kcalloc(n, sizeof(*buffhds), GFP_KERNEL);
 	if (!buffhds)
 		return -ENOMEM;
-- 
2.53.0



