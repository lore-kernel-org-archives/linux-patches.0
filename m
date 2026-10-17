Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD5338330E;
	Sat, 17 Oct 2026 15:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252553; cv=none; b=p2kFJ4bA7V5AoCCerZVSxaPOROYN8fBgAs7wIU3DIJLdcr3mJXMlc/+2rK07+ruoFxbjjHHEBQRP5+Wd1L9GNuDiYAcoofcujTWRmvP2htdxIRaoBOL3cNaJ5tvfldPL59GQL2mBwsowfdVRkt2SU2jZ9Bzdb3YLhYgigE7F/tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252553; c=relaxed/simple;
	bh=LZF0x1VGZR/D1SgC92+S//jahPyEoRXtcRVFWQArqVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRPe0WFv8ZOlaHQYUVxqHYAP1NgkKxMMKwTXOlN5it3ZMU1O3teg5fqs+4fC2KS00XYlBEhvQlP9tAsv24zqYDAycNrhIEio3GrtYSY6CJ4hr4qMNG2b+de0nZQHtMbVWqDV8H1fB2exMX7v1V34t5jFYaUpRj7+x6XjG+JYY0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g06vlrka; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g06vlrka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB4311F000C5;
	Sat, 17 Oct 2026 15:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252550;
	bh=bTo91Q30fXrGgJcguK9tZ8dgnRmbxvApDO3em8ILuZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g06vlrkaRSUzWyZVnKyEHv6Zjau/7r2DXa2SAmnzOXOek3MxFgK6CeXjyURTimsBr
	 1K5MzgNDdDlgGPM4SjeivZq2YMMqJOKiHLFpN2ySPKktdWKpy2zbdJ0E14pMFPPyHP
	 dztJ382Vjg7Fa5esIdzAr/jK58AKj60s7Uu+tb9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Peter Korsgaard <peter@korsgaard.com>,
	Michael Zimmermann <sigmaepsilon92@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 02/52] usb: gadget: f_hid: Add missing error code
Date: Sat, 17 Oct 2026 17:54:03 +0200
Message-ID: <20261017155104.920101962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ee59e6516187c..4fe9c38dd2cab 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -1279,8 +1279,10 @@ static int hidg_bind(struct usb_configuration *c, struct usb_function *f)
 
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



