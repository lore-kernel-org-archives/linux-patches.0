Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060460;
	b=e1zfS+GCaCkwwak7VGzQ7mx8+JA7c/7z0wFMFPTDXRkrec1JTcZZKdWl8fGwzhw/KzwL
	 zEDCLR6Y3uKW3Zm/teGteNue4hwxYV4mEmqNv4ltPcrbY/TG+1K3dGk1/Qk83y9xTfTKr
	 bxwdzVK29zZNFGeFj63zyIq+gDlmehAb0PXTqxaw0MDEP0mRmbGYQOfSMvw3X65FRxJnP
	 Kc/bwQF3Nl/iFFnGnIKgqq60mXUZ18Oz6HbqKAOgbPdywWSd1brEtKbDcQWi8wmskE2FR
	 MDp/9z79uKhm9p5NxS2dB0lJ64W2bw+Hv5/JBJ38X81zu8sV+aqHuVOZLixuflMzLpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dxCEtux3UYcORbzQMSFzpPiOFEEr4OqDMBzXx1nqzaA=;
	b=NzfAmZcCQKzWgSiWiNjrJhm/f7fhMXxa40w3nL7fkaepmYhdy1DKLz2Zpwlvh2jFW9vf
	 nfE5LtdDGjnqTb2+lPMHFVkHatfu7/T+UeSdiWLVlxkaHTKqa0G4lmf7/sO/jx5sCyuBJ
	 3hh7iVha4nVOWH5Z7+hz9DBWSDQlNBbGL6SZEXc4ezIzGkxQb0cEzCe7Mep6dm1bRORMJ
	 ALl9Ik15VBOAmPMTJaE/CWfY0ON6Uvo2p0IL9QbLZRpMGba7O2VsLx3Yh1oIO39OJaeFc
	 BI97QAbc+QtkfY8dkd9pGgl8wypGAVP5RBO8QclDqRbJbuI1+F8s6CkDGQpHqt7dTpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=synOenaW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A190A606A325;
	Thu, 19 Nov 2026 03:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=synOenaW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06CB11F000C4;
	Thu, 19 Nov 2026 03:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060460;
	bh=dxCEtux3UYcORbzQMSFzpPiOFEEr4OqDMBzXx1nqzaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=synOenaWz7N+LdOOqtbBglcO2GNtJ12LQ00Ea31wRw1lDe+Z73mUHyWCHuQq7Lbkf
	 r+UcvfuiXPptojiPtngzD7TiqkcEJgilZ24EypvNTYV5+MKSd2vHnjlV8IL3DFCJJW
	 +d7Af4653yeyrt5760H0O70xjTqTutVH0JMPCroA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5f4b29d9fe710a964482@syzkaller.appspotmail.com,
	"Jiangong.Han" <jiangong.han@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1208/1848] USB: usbmon: fix null-ptr-deref in mon_bus_remove() when mon_bus_init() fails
Date: Wed, 18 Nov 2026 15:54:06 +0100
Message-ID: <20261118150010.575218643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



