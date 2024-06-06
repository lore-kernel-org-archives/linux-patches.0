Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6439E19AD5A;
	Thu,  6 Jun 2024 14:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683690; cv=none; b=Gi8WncxLhyf5wMRNJEU8wckChm4MLE8Os1X+nmHEckXPTbZgn2rNP4DRwVNk6usXYw1AO/fPawrQfLH/vlwz+VYycCnESxq72lEDaKO6ZRnRixtYCuhA/9CD+l4S2CzXYEh3BftWAgScbWMfP9yHbhXCBJ84ALG3Kv3PdXa82JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683690; c=relaxed/simple;
	bh=aV9etgWPi5D4r2Eboy9DgpMW91VsZI41hxWFm55njNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4ZIGgMXAGQ11nPYJdo5rFQtvXKScn0Unc1XKxWhdL/bXalk/tMr1Vtb/+YZEb/7zDWqm+RqZjkEmyaDXyUaAX2mCjhhkZt9d/8EWWsBm/kfyrnLNOy8Yt16uqeAJcEKZO8WBfxo+TvbHL5WchPgGBR0wwqGqpXkmma4PAAz9vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4wYQjHB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4wYQjHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07D13C2BD10;
	Thu,  6 Jun 2024 14:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683690;
	bh=aV9etgWPi5D4r2Eboy9DgpMW91VsZI41hxWFm55njNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4wYQjHB7Ev9L9Ku41GBcKwq3MjR0oK+MfXNa2fLUyxhL88n8wdLRUxJDJniA6f1j
	 6uppYUVnJ0iWK9cqWfiLAQYqUlAtZ8Rs10w24znqs4bkyjNgNiyR/qDMTb+SAkZSJW
	 Lu3bAHmi1NJ2IwPac1dyxYbuCI36N0clE7PK/mTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongliang Mu <mudongliangabcd@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 599/744] media: flexcop-usb: fix sanity check of bNumEndpoints
Date: Thu,  6 Jun 2024 16:04:31 +0200
Message-ID: <20240606131751.683576553@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit f62dc8f6bf82d1b307fc37d8d22cc79f67856c2f ]

Commit d725d20e81c2 ("media: flexcop-usb: sanity checking of endpoint type
") adds a sanity check for endpoint[1], but fails to modify the sanity
check of bNumEndpoints.

Fix this by modifying the sanity check of bNumEndpoints to 2.

Link: https://lore.kernel.org/linux-media/20220602055027.849014-1-dzm91@hust.edu.cn
Fixes: d725d20e81c2 ("media: flexcop-usb: sanity checking of endpoint type")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/b2c2/flexcop-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
index 790787f0eba84..bcb24d8964981 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -515,7 +515,7 @@ static int flexcop_usb_init(struct flexcop_usb *fc_usb)
 
 	alt = fc_usb->uintf->cur_altsetting;
 
-	if (alt->desc.bNumEndpoints < 1)
+	if (alt->desc.bNumEndpoints < 2)
 		return -ENODEV;
 	if (!usb_endpoint_is_isoc_in(&alt->endpoint[0].desc))
 		return -ENODEV;
-- 
2.43.0



