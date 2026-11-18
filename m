Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015988;
	b=m3TJOAEQVJDm1UootFrrGqaw0mCPmzG9W3qzfCYzCds7HzbFMge5Ky8GBiZAoSI79qnx
	 9PMpwqn5PqfuQh0IS83KScua5waijJCUa/dC/tcign/A8nEaIGuIJmfBwnne+CoxKJ0Id
	 uNozRNDzRT7ir0iVHeBO0tiJxNzOHdX+sgLNVPf1ZgE+TtrzTyoKv6b/ZT0o1qaiBDQDK
	 UiJPYuA0dDYX3yKo2XlpYfYGL4+u0PvLEIm7iugY+UeXKtyTn50L1l5foUzMUpFGdo1X1
	 Zgvbpv/w3FJc4zZVqTONrQHoIQMzRz9b3XG74/FUaK+24lq2O0byhPpE/L84RHCjLoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015988;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/E59Wfgi6jhyxP9dHQIurkMxZxDf8DteNn6DMAQrd68=;
	b=lykhwnpyeh9dEu4mm52nafeWMwBNEuLFdT81h3/NjkjilTUYsxbZowDKkrkWMYLYdV+Z
	 QevdItHkjA6apY9QEw/wr8sRlpFbAypb8rfX71/1OKbl1WY1TuIlp1NFNwDDFgmViN+g3
	 6EhDmbsnqvyPwebYSQyxAVLcoyqNoN6GrFY6MyK3zdbi1MAHR/N8uT37tCLQS3uJFQbPK
	 r/2Nwrn2DXwsVQoYIoD/rZEk5vhAkpSNwhHztJUFpOMrM8ZijBiVdtjQE8W/WkMXxqBUt
	 vAHxVjfhPhe2Y/u85Zor9/hyxiNGdmosaqYtseYhgVBJG8HvvqH3RPvvIKZYmiZlBXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k79tkrkX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C09606A31C;
	Wed, 18 Nov 2026 15:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k79tkrkX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193011F000C4;
	Wed, 18 Nov 2026 15:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015988;
	bh=/E59Wfgi6jhyxP9dHQIurkMxZxDf8DteNn6DMAQrd68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k79tkrkX46e7LP4GuD6Y7OcL/Q01DSsTYHfQWlbJBThOJvboES9uAe4rgb/hQIhHw
	 d9lLDpqBBksOr+vdvF5z1SGiFmuVFAcC43r4RQmZILEgPninnGy+pCdCQGZ6NJCg04
	 gzZqbvAJs0hOhF2v9nhWwBJE2USznOn/65svKfJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a83a5a1ba9ff57935171@syzkaller.appspotmail.com,
	Keisuke Tsukuda <tkdkei@outlook.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0368/2651] usb: gadget: composite: avoid warning on aborted delayed status
Date: Wed, 18 Nov 2026 15:26:48 +0100
Message-ID: <20261118150301.082525247@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index df39e3487c1f3..1b2238147cfe3 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -2740,7 +2740,7 @@ void usb_composite_setup_continue(struct usb_composite_dev *cdev)
 	spin_lock_irqsave(&cdev->lock, flags);
 
 	if (cdev->delayed_status == 0) {
-		WARN(cdev, "%s: Unexpected call\n", __func__);
+		DBG(cdev, "%s: Ignoring obsolete call\n", __func__);
 
 	} else if (--cdev->delayed_status == 0) {
 		DBG(cdev, "%s: Completing delayed status\n", __func__);
-- 
2.53.0



