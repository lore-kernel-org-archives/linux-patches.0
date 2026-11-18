Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029514;
	b=WYMb2O4Lrs/I05eTm22XQqVHk3xImOUCjXTUYuYM6W6LNKm66mG+CI4LoYOw/qXdSMpp
	 14BE0lBdjUpMFl5uGR07pvR+LHWEyy4Shs1N3Lt5Gyh7ZdjPnVBKUhj/hD24cpKhs+xkU
	 RxNZW9qyMq04Tdyb7ce7G5pU5FFJuPUtZV7ae4TB5XVavYkzFTj/ZkKJADpFctfT4GNfc
	 Vx55S7CQ01CVhLv/ZRjTu3F5YoL0qg6GK4w/d10t4y4pmcsfmGxROIbhKRd6Mmv7+ETNH
	 kf5F6vVoHaqkOFEpzRBjqvi2et5wjk6XNX9GEDRGximhboA/MLV26l6V9390m6QFd1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DyuSbHG5yjIcVhLWr+UcdMnrlAGBIfWhKAaioje+Xh0=;
	b=wv+3W0Q3Zs24w+S37WfhOVfKldT5OjGplN5tat09d9e3bAx/ujnOJxXMOulZ7z3oKrRQ
	 FbZwfaWrxMM8sMRbtNr50Xnpp48qIzIwwwtq/TtHVeJ3rm9xJlJVIKWiDtb8LdKBQ7WUH
	 QJObVieFWtaWtehAiWuxy+3GGcNrpiEQMnJXU5EVmrhaY6n/C3LEQ2pvx3r4ta9TdIb+Z
	 gJCpUUwrcVz/scNAVDxpta+JQ0XrR4Bf8qnmn0zg5NWGn/aHNFnosbCLlYy2N6qFVBnj+
	 XA1ojcKe1h8by/XqGgSCirt+xauoWdRmJ0AUXmdChOoImnfzdFuMSqFf7U6rpHfW1vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0LQpzeaG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EBE606A31C;
	Wed, 18 Nov 2026 19:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0LQpzeaG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46151F000C4;
	Wed, 18 Nov 2026 19:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029514;
	bh=DyuSbHG5yjIcVhLWr+UcdMnrlAGBIfWhKAaioje+Xh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0LQpzeaG7jGhKinKbWrOyaqgSelkdkEU1PkcUEFY0olfXrn21FiY8iJFooJ3ebdze
	 J27iiAaiBU8+JhnHIpFXCYD2xBE+ffrmcjEjnOYxp+Jl2uEWh7L4u3CSIVjEhunwaX
	 NovvDMz+Tg3th9mY7o//NxhNctBnXqegTh3V9mpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5f4b29d9fe710a964482@syzkaller.appspotmail.com,
	"Jiangong.Han" <jiangong.han@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0326/1756] USB: usbmon: fix null-ptr-deref in mon_bus_remove() when mon_bus_init() fails
Date: Wed, 18 Nov 2026 15:40:53 +0100
Message-ID: <20261118150021.254969829@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



