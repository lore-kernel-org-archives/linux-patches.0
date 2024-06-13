Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDDF145338;
	Thu, 13 Jun 2024 12:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281307; cv=none; b=RWVWNYHE/Ic61L5idwM3zbH4zpD4JEBje88Qo7+GYegMv1Kiv/pHxJnUjEizRm+4PiTyyc/ioQk5HaHvKDEaL+HUdEjSNehPr5eS4ZBSnhs5RGy6Vt6ON2svxQnipuJfK6NZ0zlukT+6WzMx/hfGQmKyWdXNTTRwpSON9ZJV8Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281307; c=relaxed/simple;
	bh=so518BUJ7zWtusfgdCYYqfnMaZVGru3iJhJMrd89bEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esq2mLt/cihtBZEb5El8g7oev6EQDgBnkgTSE3U4PcA/wVl0+h4S5oY5xZGAIhXTfzoZK6+WbkaeVZd0hV5nebjvxrHyKwDoX2nk0puYGVhBFEUWLppBp3U8DFf/1kkEMk9lBVLBOtIdx99RLll/6N16SzjzFL0wCGzwZhLP4Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9ubU9ee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9ubU9ee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81BCC2BBFC;
	Thu, 13 Jun 2024 12:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281307;
	bh=so518BUJ7zWtusfgdCYYqfnMaZVGru3iJhJMrd89bEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j9ubU9eeb616qI5mwgWjtGZlT1QNioFXNGMDd8PvqP3Oe3qx0SdgUTDKBXaTmfDWC
	 tcDZ0cxYt9Yjs0/8GJrCsvWRbI7MMqXVbwjX5KFG51DK9/XyvOb7dfgd0ETlg/TtDm
	 mAm+fiAJbVMkcx+mN9sVyvo4ti0/KNHsY8wIbKi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongliang Mu <mudongliangabcd@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 211/317] media: flexcop-usb: fix sanity check of bNumEndpoints
Date: Thu, 13 Jun 2024 13:33:49 +0200
Message-ID: <20240613113255.718693810@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6d199b32e3170..6ded5a6181aa2 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -514,7 +514,7 @@ static int flexcop_usb_init(struct flexcop_usb *fc_usb)
 
 	alt = fc_usb->uintf->cur_altsetting;
 
-	if (alt->desc.bNumEndpoints < 1)
+	if (alt->desc.bNumEndpoints < 2)
 		return -ENODEV;
 	if (!usb_endpoint_is_isoc_in(&alt->endpoint[0].desc))
 		return -ENODEV;
-- 
2.43.0



