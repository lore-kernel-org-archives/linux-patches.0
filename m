Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054946;
	b=E8m7KTdtY2pecwYlBd2gymhgx3RHWwJbGqZxptH1G3zyiF5DD45JKq1BYTCLpqzBIz+k
	 NCd/weWTqTQou/N+uouhSFMyG8B142BG2lma5MEVsao+62qGe0OV2S/D/+OJ+Kxd7uAfr
	 3hxEX9R9Maj4e+GrY5Nhl2OGtlXU0BEyjDgX1JJ8ySKmFmrTgkhH4P9OIkhulGposw1zA
	 BMDyqHS2PQqN8w3ZxDg4AnG/7Zq5QOcGSB0igdHf/LnCqkHO+uAHEe7RwGx0McRrWjaoH
	 BT1UKTAleM5rTcNXGcrB7iX6AfsgQdiGTEqRss6g2t7qsOJ0BpkCVwsxklfHL1Omf6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SIsAMt5fxaLZlsn7/z+8g8Sz8gFYx2pyFWeaXvyddKo=;
	b=1Oto0vSrY8JKNXIZ6emLYDPOZtgMePF3i1sgPdttWeV46vVilLM4LPBhDDRytbU/XYNl
	 XgGWrpu50dMHOqeWd/uP0sDZEaqwxkKHGES2b4gvmPwVP+uVHkugcqN7UehqZV1CggLXa
	 cLVPpZbob/HX7/0VTNiKkSDtHqIhKuIGD0SsMf08x5PPVYndj92No6Uy3+W8n89Mh19hD
	 RQtwvBOYFAtYA2ZUXjlDgAFIahDU6A8KpjDqJc1a7/ca7z1g/1tKJv1Adpg8z3Qkj8wW2
	 p2rIPA3jYtKSRalzNSHzqxM3RsXWjYd3FkDTkB9B4Q0oK+EpVOELnQx7uftIczsfKdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pd2xyWZS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C39606A335;
	Thu, 19 Nov 2026 02:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pd2xyWZS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4B71F000C4;
	Thu, 19 Nov 2026 02:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054946;
	bh=SIsAMt5fxaLZlsn7/z+8g8Sz8gFYx2pyFWeaXvyddKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pd2xyWZSl7SBFN2YN+fTJYjlp2voDLi3y07jJ8w6FFoY9OqYKLbJxehwMd/9TOJSH
	 VEzq2374MEYjhmvn/CfOnO7BmDKGWsKcPvnRsVcOBA9/dVfeu2j9VAuK/XcLRSCYuw
	 +xLuVaiYeB972gvE0PEdjnqqaZvH5VLC1MP5jJTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a83a5a1ba9ff57935171@syzkaller.appspotmail.com,
	Keisuke Tsukuda <tkdkei@outlook.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1455/2214] usb: gadget: composite: avoid warning on aborted delayed status
Date: Wed, 18 Nov 2026 15:52:11 +0100
Message-ID: <20261118150109.280543337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index afacaeb95fa5b..2c6b4c068c059 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -2614,7 +2614,7 @@ void usb_composite_setup_continue(struct usb_composite_dev *cdev)
 	spin_lock_irqsave(&cdev->lock, flags);
 
 	if (cdev->delayed_status == 0) {
-		WARN(cdev, "%s: Unexpected call\n", __func__);
+		DBG(cdev, "%s: Ignoring obsolete call\n", __func__);
 
 	} else if (--cdev->delayed_status == 0) {
 		DBG(cdev, "%s: Completing delayed status\n", __func__);
-- 
2.53.0



