Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039674;
	b=fZRzBw+wjJMGyXM29/bwBQo4v/hMLEbui6fk1MR0NkPatojRwCaRnqpfgF4+w/cfOQPx
	 r8MptRzAB/T4jUrTtfuY7zEeVm0JG9zntHIsFfTyVk9A5D8LA6PlDvg9vVEHA8opk+b3U
	 2IU1psIjEacn4ixnNHxedUoa9lFOZj06w0tjAXGyR2DskAOoZwxPDkQ6xOccHmLRGlr2K
	 wcTF/jTWYeToL3toaoCW6zIb2csHitoRvbKRqN5aYg74tzBZE6vPZK2Q9DxAMy9niyzCH
	 c6Vs0jCbChLZ5ekFv4c/R5s4TCUelJOMkh+7FobvX+kXIQAzBO1Lmp6Xzd/VmYkPC5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QT8xw7Ood6PMZZERmbkNNoWgmvq+FBJswY6kpt5IpXk=;
	b=qZXSiwpuHYtlFKTI3UFj21Z0J42XbWMzjYT6y3SK1rSk97wREnMFg5E3mqtEVZEyUl1P
	 XJzy6bT4M8voZbDQvhlvx/9C6PleCSXJZBGfs+Bu0WwTh3ng17ES50XiJljR0mhBE0kZ/
	 pfURlEakxAYA0f3QMbTzCjf56PTxgE5aRvGZjtt3MSn9S3M3qMzVapiD9TPEHpqp9B+AH
	 VNrdkSnqBQMDwUX8BSvpnCg/tZnM+hxQaS1d0jCUarO71mPp26Vx+EAH48suBp38aT2HH
	 rO4Tu7PgTdwlYMf9C4II0Fkou9D1UsN6eM36bQOG3SNko9c53uxvAlstSS9UODBmFYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X3EVE+Xn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A87606A32A;
	Wed, 18 Nov 2026 22:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X3EVE+Xn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19581F000CC;
	Wed, 18 Nov 2026 22:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039673;
	bh=QT8xw7Ood6PMZZERmbkNNoWgmvq+FBJswY6kpt5IpXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X3EVE+XnxqqKxhSVD0Hj/kDvnw1C30bIlsdp3Kc+ULIBXuYi2SLE6kuw0Os0MtSwJ
	 TC3Ven5QuIxbMxZI13BRW9OzQxSWgOyLLI3Q1Ozv+y6jbRDTBPg4Un721NbLDe5CbQ
	 vmKZ9VG1givp+TSYdHkdytEfgY4XHqM0DkqkyMa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5f4b29d9fe710a964482@syzkaller.appspotmail.com,
	"Jiangong.Han" <jiangong.han@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2143/3318] USB: usbmon: fix null-ptr-deref in mon_bus_remove() when mon_bus_init() fails
Date: Wed, 18 Nov 2026 15:46:05 +0100
Message-ID: <20261118150426.341951798@linuxfoundation.org>
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
index 9812d102a005f..6882d8938a546 100644
--- a/drivers/usb/mon/mon_main.c
+++ b/drivers/usb/mon/mon_main.c
@@ -210,6 +210,9 @@ static void mon_bus_remove(struct usb_bus *ubus)
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



