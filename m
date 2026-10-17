Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82EA33D994;
	Sat, 17 Oct 2026 16:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253123; cv=none; b=m9ozsLvpyaSHJI4NKfWjNH/rQm23TuRujwLboUmGxq7Nvyp02+zryUuDyc9Vpqv0UXS1mVPY+Pm+8Y0qFOsoBPvoFaFt5+kLNadqsi4GmWjvoxiq7PwNcOII1AxyFXcuFfAaF/h4epjYaeuSjSUwVMRnmrVAWht8j9mrbRrYna0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253123; c=relaxed/simple;
	bh=y/45CGO1ZGyX1+vgaLYMmifQUdRH0rRDUdIXccu7vHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Li48z18oCy34mHJv8qcG0DdfD8lzoYKWOxTDX9iE5KiSd9HWZXVQ+o13V6v408ktSe6HtHs0p5dxwwO1RmYaRx5SV7MD0QKTXDaXJTrTGvH9kdFTCm5MMSF1G2wIEq6KHgKghStOI2tPf06s97LinWuSXJV+3iSAQmiSc14Apao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NNllVcwv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NNllVcwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0631F000C4;
	Sat, 17 Oct 2026 16:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253122;
	bh=ecHW/MUVm1+/9PWvqXuEXHPkvcRlF3ziPT2pgWgakmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NNllVcwvWTDzV/b75pWIX22UBWgDN76WYURJegYSNtaWsq7ih2xw8X/l3584y4GRe
	 Rz2VA18QSuLyUR1YLwlYx864DROMlcveaBZJXAG2l8pyEErA0Unf5DZpss/ZXm7C0d
	 BiOTgtalDA11BRi8/w3SMhrEuDMDkHtYqOsN088Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Peter Korsgaard <peter@korsgaard.com>,
	Michael Zimmermann <sigmaepsilon92@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 002/869] usb: gadget: f_hid: Add missing error code
Date: Sat, 17 Oct 2026 17:47:23 +0200
Message-ID: <20261017160037.053793057@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Tidmore <ethantidmore06@gmail.com>

[ Upstream commit 2c863dbbeac7b919d4634ad886978a6731916de3 ]

Currently in cdev_alloc() error path no error code is assigned.

Assign error code '-ENOMEM'.

Detected by Smatch:
drivers/usb/gadget/function/f_hid.c:1291 hidg_bind()
warn: missing error code 'status'

Fixes: 81ebd43cc0d6d ("usb: gadget: f_hid: don't call cdev_init while cdev in use")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Acked-by: Peter Korsgaard <peter@korsgaard.com>
Reviewed-by: Michael Zimmermann <sigmaepsilon92@gmail.com>
Link: https://patch.msgid.link/20260402180008.64233-1-ethantidmore06@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_hid.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index 2f4a5d22aca4c..b5702ccb7b2f2 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -1272,8 +1272,10 @@ static int hidg_bind(struct usb_configuration *c, struct usb_function *f)
 
 	/* create char device */
 	hidg->cdev = cdev_alloc();
-	if (!hidg->cdev)
+	if (!hidg->cdev) {
+		status = -ENOMEM;
 		goto fail_free_all;
+	}
 	hidg->cdev->ops = &f_hidg_fops;
 
 	status = cdev_device_add(hidg->cdev, &hidg->dev);
-- 
2.53.0



