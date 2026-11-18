Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023390;
	b=jMn6YStpPQ4SO2cDARDr8nHHbHzNnHYLmSr4Yc+Io+fL1/PffZODYpO4oLLs1/ph71FM
	 XxdA/Q5ZtgYyzmST4qELG4QczOv9hkdRSnO8Ze9Lq31w5811kj5H1JdemyD5jYtlvrGRA
	 xeNThi55SW5gtXp3kFVx7FvNDeNHpqu80WagzCyl8iuJ3gBX/RIA0OTB5GQmIiom55wL2
	 X6FtkV5WTN8KvaI70Cgqzhz2ir00cXNqebGYabE1sjYj6uKklZBliCnTBMZOSGtyQg0dI
	 3Y1hP3vL83uIxnEr21BBR2FhPUvQJsB3JHRQPSHUIW52Mq/oEkVcfGZlerDMDAc2Ttg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f0sOsE8lbXWUVleOVLEmWK3TRJ8/mmkhyOwoY/Y04wE=;
	b=V/oDXPmtv+iTjw6GtB5mOrppXKt+tB+rtjAoYM3ddoXTfvuPbTLf3+5DlTPDes3YesSu
	 dznfjGZB1PxkcDANfebWvLOXZm3jl0Is9QGEXyi4JKLTo8+6x94dvOO4m5+G3/JkSUsSi
	 xZ/YfdhjDs54fCUMLCPhNc6CLupjiNrP8QiDk3K62ZlrMwf1OOfr7DAzleR+BOXYba8Bk
	 DzMsjWYkc+kpH4FJXDcmqfoJgLzK+5fY/e6UkPUOE+3MUuOg1Qd5gXqnG/9K0Y7q5myKF
	 9d4p/SAs7TsagY538CImlkT6R3zmQzOYUaCGi+Q8AJcOUpjxKtG8Idl/FG4HkQ7kF2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CFRL7vg4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6DE606A32C;
	Wed, 18 Nov 2026 17:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CFRL7vg4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 503E51F000C4;
	Wed, 18 Nov 2026 17:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023389;
	bh=f0sOsE8lbXWUVleOVLEmWK3TRJ8/mmkhyOwoY/Y04wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CFRL7vg4GmP0G/PDpwNcZVRUB+KxLyVApAF1pu/yjS+nDtorPl+6AkVuWVuY0xnTJ
	 eD6cHLJ+wzdzO1kzUR+Vh/3+qTxD0lPzj3i7NHcMS2f0JuEDoas+U1YotBPYlgh+QL
	 CpKA9Zxj1Qimimm8MiUyIkRE8lfagk+MfIFNHV98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5f4b29d9fe710a964482@syzkaller.appspotmail.com,
	"Jiangong.Han" <jiangong.han@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0353/2151] USB: usbmon: fix null-ptr-deref in mon_bus_remove() when mon_bus_init() fails
Date: Wed, 18 Nov 2026 15:34:48 +0100
Message-ID: <20261118150134.959248602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangong.Han <jiangong.han@windriver.com>

[ Upstream commit 0c6cae0f56239e3274b30dbe5b362cd297ccacc7 ]

When mon_bus_init() fails to allocate the mon_bus struct, it returns
without setting ubus->mon_bus, so mbus->mon_bus remains NULL.
mon_bus_add() intentionally ignores this failure because the USB core
does not require monitoring to be established for normal operation.
However, when the HCD is later removed, usb_remove_hcd() fires the
USB_BUS_REMOVE notifier which calls mon_bus_remove(), it dereferences
ubus->mon_bus without checking for NULL, causing a null-ptr deference.

Fix this by adding a NULL check for mbus at the top of mon_bus_remove().
If mon_bus_init() failed, ubus->mon_bus is NULL, meaning the bus was
never tracked by the monitor, so there is nothing to clean up and
returning early is correct.

Reported-by: syzbot+5f4b29d9fe710a964482@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5f4b29d9fe710a964482
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jiangong.Han <jiangong.han@windriver.com>
Link: https://patch.msgid.link/20260801095128.46322-1-jiangong.han@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/mon/mon_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/mon/mon_main.c b/drivers/usb/mon/mon_main.c
index af852d53aac69..4aaaa9d0748fc 100644
--- a/drivers/usb/mon/mon_main.c
+++ b/drivers/usb/mon/mon_main.c
@@ -199,6 +199,9 @@ static void mon_bus_remove(struct usb_bus *ubus)
 {
 	struct mon_bus *mbus = ubus->mon_bus;
 
+	if (mbus == NULL)
+		return;
+
 	mutex_lock(&mon_lock);
 	list_del(&mbus->bus_link);
 	if (mbus->text_inited)
-- 
2.53.0



