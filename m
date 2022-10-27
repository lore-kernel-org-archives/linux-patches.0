Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B40AD23
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA26C433C1;
	Thu, 27 Oct 2022 17:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890196;
	bh=ei+uedMaTOIPuxjpu6diHqgY1TRnnG9bfnjO2qXCiQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWP/ErOs3CptMwN7dF7ElweMfM0MfoNy/LePsbUbE/3g1R2hAc7opE4KLCy8Ynl4d
	 csB1osrTNNRwB52y82Hvx0I+hvy4tkgMZ+CAbeO9+Z2jOZdBAmOmyDGGfL8Iwvj+g2
	 uQTbxpmzFzh1NO7Yt92CrFOVycIoSXl0CL63G8H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.15 28/79] media: mceusb: set timeout to at least timeout provided
Date: Thu, 27 Oct 2022 18:55:26 +0200
Message-Id: <20221027165055.881880670@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.917467648@linuxfoundation.org>
References: <20221027165054.917467648@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Young <sean@mess.org>

commit 20b794ddce475ed012deb365000527c17b3e93e6 upstream.

By rounding down, the actual timeout can be lower than requested. As a
result, long spaces just below the requested timeout can be incorrectly
reported as timeout and truncated.

Fixes: 877f1a7cee3f ("media: rc: mceusb: allow the timeout to be configurable")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/mceusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1077,7 +1077,7 @@ static int mceusb_set_timeout(struct rc_
 	struct mceusb_dev *ir = dev->priv;
 	unsigned int units;
 
-	units = DIV_ROUND_CLOSEST(timeout, MCE_TIME_UNIT);
+	units = DIV_ROUND_UP(timeout, MCE_TIME_UNIT);
 
 	cmdbuf[2] = units >> 8;
 	cmdbuf[3] = units;


