Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029397;
	b=lBtnxTOa5Ofv/dvLCn3uoV52uiX98MO6V7CNuGXZIOR81L9Citb/UjjoHybanQhkz0xn
	 8YQRbO/hic9swsiuynxrISlMIalDjargq/fgC9S3/rtOU/0ZUn3sZSvGSwD6wcjT/rW38
	 NzEF1bnqzxw75X2WVHm4aKnNr1IDFQQYP05ReREFfCEIN/jPxI73uDk9hbp6iLtZbjZ5B
	 VA1orSVSrwQXFaPHgPRUKDpyjgYqvHippy9rn/Rw8GIzkgk7UPHEm0U58cPL7CDdY2aS1
	 KBgIIrRGth/NYtEAue8NkPjBih/u3RUy5NcwZgbhAYg3s/dr2z2G0yxTrw82TBms3Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qxDFW4aYG5uP2i918UUn2Q30cMm1XmsesdEKUC5Sn/M=;
	b=bmUynYQYrVgQaeQIe3iExVQOGZech+lvoEop0YL2TZ68AI2ZoASJDbtHeSqWl9lWhi7E
	 rlZp0iIuwpS2DJ6vY/U525qBsOncNEsTV8hbA2XcOWBT5c23eyZ/gGWe+luQ9KlbMphC6
	 DLfXij4/CLH15B/nbQAD01ihyfJ+i/cYk7IBvviLD/wKQ29aP17X03sBbox8g/FaV50Fe
	 ua8H9vkq88KZqo2zyPlQ6GpHTTeggwZ09q41kcypQ/rrE9DOrpY1A+FRuARDlIJKHWDBu
	 bSIBRiIieuvtPmUUJS4QcS+nI5k9L2JZIqBZRKDl0z1SmgUSsKrwoykI3rAz0DPTqvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ec9mF3Fz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1D12606A32C;
	Wed, 18 Nov 2026 19:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ec9mF3Fz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1DBD1F000C4;
	Wed, 18 Nov 2026 19:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029397;
	bh=qxDFW4aYG5uP2i918UUn2Q30cMm1XmsesdEKUC5Sn/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ec9mF3FzEJ5yioSr9yFIUKh+87hmJCN8bp7q25VGmLUvQt3ejxubUN3uR65N4RUC2
	 cp3uZ0hkrzuPKHi0iwLzJ8TZqxVInXuUb8rKSb3DiUl+7kuGp9aTBk71rOV10N0arr
	 QTZbkESE/CJgbzbzDnezv/Apcg24LSSskKGSpR8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a83a5a1ba9ff57935171@syzkaller.appspotmail.com,
	Keisuke Tsukuda <tkdkei@outlook.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0336/1756] usb: gadget: composite: avoid warning on aborted delayed status
Date: Wed, 18 Nov 2026 15:41:03 +0100
Message-ID: <20261118150021.623480605@linuxfoundation.org>
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

From: Keisuke Tsukuda <catnyaaan@outlook.com>

[ Upstream commit 048884b782b137229399b9f727b6437d9b4f1071 ]

A SET_CONFIGURATION request that disables the current configuration, or a
disconnect, can abort a control transfer whose status stage was delayed by
a function driver. The asynchronous function work can nevertheless finish
later and call usb_composite_setup_continue() after reset_config() has
cleared delayed_status.

This is an expected consequence of aborting the old control transfer, and
does not require a kernel warning. Keep the diagnostic available under
dynamic debug and ignore the obsolete completion as before.

Fixes: 2bac51a1827a ("usb: gadget: composite: reset delayed_status on reset_config")
Reported-by: syzbot+a83a5a1ba9ff57935171@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a83a5a1ba9ff57935171
Signed-off-by: Keisuke Tsukuda <tkdkei@outlook.jp>
Link: https://patch.msgid.link/20260908203348.95825-2-tkdkei@outlook.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/composite.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 81ff6977a1feb..27fe75fb9568e 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -2764,7 +2764,7 @@ void usb_composite_setup_continue(struct usb_composite_dev *cdev)
 	spin_lock_irqsave(&cdev->lock, flags);
 
 	if (cdev->delayed_status == 0) {
-		WARN(cdev, "%s: Unexpected call\n", __func__);
+		DBG(cdev, "%s: Ignoring obsolete call\n", __func__);
 
 	} else if (--cdev->delayed_status == 0) {
 		DBG(cdev, "%s: Completing delayed status\n", __func__);
-- 
2.53.0



