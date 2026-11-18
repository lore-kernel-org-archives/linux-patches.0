Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039582;
	b=Ghm49UsKd0co1KKhhdLp1mqYD23eGpljFGHy5zxfI0XGLJgj5PNnIIdDlVcnaleJPk3H
	 GplP2egnfZrEnTpvrPSHu7lcP5ie4bAphH2c/SRQO5DFETpEpb52CRn9e9jcJDG3F02Nk
	 LMD5QL/AIct7DBqampw5XGVVM9TtCmvSEQrT6TzAmI6ks3HFsIIx2KNgaBXva2lG6tbgM
	 rDQ7Lqhf3Sc5Fgwe8kLO6+DNLuBFq93tfTqNB+kGoWFvNWr1fxKgYRiOmySs4zifWgurD
	 txUm91ajvcWYHUMUKLjR2hKFhgNNPtW1T5g5ZoagQdfCFb0EqxCSOR4SIXJpKZ50flA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AyAKU3iXcB0gPzB9CW6xejAAZV6UExILwcC3NmO1uP8=;
	b=xLbHF0yBHlCL/5BuvzjZH9a5pDm5qm2niMhq5iFdaClWjImD/04vxZfd2B280HdeVKh0
	 W2jTO+OsB3n4hcYEAgRpLv+UaWUOgG+bo1AHuTD0yho4SNgk7YHGGGgSdUiTvu0fKsjw7
	 Lfhq1FKznBFlKZxyugB86iX+SHiib1jfPMM7k/svMPweN/xz5cBzMABScpmDHsHAWjjqy
	 YEvLuUiv6izVF9dQKtjHvEwP1gKxVykofL8rvrXA5QnBmicPKRltCV2e2if61il6/7EcK
	 8nxZrmKHwaHg1Db0z4GYwuKhhy9m0oYcJbfrhc9sHNHpmfxJcRMGhpZarJsOLvTeBuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zGOM+AmQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5520D606A31C;
	Wed, 18 Nov 2026 22:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zGOM+AmQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67421F000C4;
	Wed, 18 Nov 2026 22:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039582;
	bh=AyAKU3iXcB0gPzB9CW6xejAAZV6UExILwcC3NmO1uP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zGOM+AmQESkAEtGVtta74uj1Txy/gK4y+5DQxAG0cUzwbvUBm2kWbDrQFqLAbzx7e
	 Iof43VFKDdn2l90tl9HnDlfL9gye/8tvp9B39wuiuM57W5nbCJLHvmae6q5F7wIc13
	 xy1om1f/zDr4Y5WMuAvDZuIdxNFL6be89gL2qxfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a83a5a1ba9ff57935171@syzkaller.appspotmail.com,
	Keisuke Tsukuda <tkdkei@outlook.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2153/3318] usb: gadget: composite: avoid warning on aborted delayed status
Date: Wed, 18 Nov 2026 15:46:15 +0100
Message-ID: <20261118150426.622943320@linuxfoundation.org>
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
index 1caea2292b69b..ec4035deb18ae 100644
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



