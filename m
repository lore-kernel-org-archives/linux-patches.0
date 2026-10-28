Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212263;
	b=Rw8Pgx7i7SqKPpIk2KOUVYFOz8Sqgfu90p2GZNlyEMTzNiG8O+rZKc2ua/rg+NSzK3A3
	 KXWxdIX0RZtNt1vQFe0HV6AOcWt1t1XKhmkDzcUKHLLpDIplxdiWY9lhPQ5nDv6hSdsG6
	 dTQhserQrbzfWimCyPyuW4QdHG/uTACrcQ/S6oZ647SKJ6eOlhUk5tBK4Y1yxo73Ilexg
	 wCCpTbB9St/AjVIuX8nb52mXoTULl2XA50d38UA2YGLs2Ynk/kCEFy1xS1kMYxNZUVhzA
	 DKbdjxrEG7bNhmOMesHDSNe3hhpIgEylkrCzV2gBeZzGoXo/srBPpzjQWb4OvN7vVWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=jyASk5yktbcHSMiHtYEpjeo9Zozw3HPSg4wHAcf2Dmo=;
	b=sLdDzJoT532iUq4m3WbiO94H4BUNkXFzOVOSI/tOS8Lm3YYknG5lIQZ8ZE+MXFVA+ZGD
	 Hm+Jb3V8pFIPz8FrgyZaaqNKXH5E8q4a2HjzU6O0PnuwQBNrIaaalEdbPr8990MSkm6DV
	 rHFCfP+Kk66Oh+zHSi2P4Zqz0zMB37Q2n3V0tsWQXyVbgvFcW9oi036qOV3UjkMb3ZUP8
	 yrnUdwUbg+TErkXnwGOQLwZ+pBjqV1iYO2iK5y2BV8JWMouOb715YwIOaV+6C6Ts/su4x
	 C54MmG0cb+feAlt8WL/L+iRTTBNebG7kCA+4BeTKauDTjkCis1OffUnVIIptvOCRZWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Wg9Pi/Ok";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490FB606A31E;
	Wed, 28 Oct 2026 18:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wg9Pi/Ok
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A6A51F01825;
	Wed, 28 Oct 2026 18:31:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212263;
	bh=jyASk5yktbcHSMiHtYEpjeo9Zozw3HPSg4wHAcf2Dmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wg9Pi/OkodxRxQCJEgfwxCWXPxwUyZvTUnd7tGP/8dQBE4mtlehpKSo7d1+a2SSC7
	 wIzFzj8I0ynuYE1ES8YTywDyIP3ob9OWpd5zwTleymm16u89I2pq8TTosj/oO7mBWH
	 E7DmSbc77W3Oqi28hLvkIDK8QAT55pcczsoZR/qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+791be35f1fbcc85d06d7@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0094/1887] usb: gadget: f_mass_storage: fix null pointer dereference in fsg_common_set_num_buffers()
Date: Wed, 28 Oct 2026 17:36:30 +0100
Message-ID: <20261028170501.372269441@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a40be63aca291..5618ca904f5d0 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -2747,6 +2747,9 @@ int fsg_common_set_num_buffers(struct fsg_common *common, unsigned int n)
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



