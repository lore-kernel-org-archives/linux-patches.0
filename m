Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7F7348477;
	Wed,  8 Apr 2026 19:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674946; cv=none; b=Y0Hw/yS3dCI67ghDCu+l4GzT/dRWlO+Bmw4pSz4JbXxtUHt5HB7C4gdRL2n4NCt2MWtXbJ6eJTGYUo/V171k4iKM4KkK96dxhwkMymomFLpUBPLqSx4KScLJCwwm5ts9o7PRVff3GdFZ2SdQL/xBKNwQUakqt8EFlUNPVXlq+Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674946; c=relaxed/simple;
	bh=1QUusYiAuubIDkd40TcX3VFMf+lOfQJH4wgumGxDuEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0lFmTlDInLSnJt+kYz5pFghBnCfJ6wNwlFV3yLhME+nk7AUxkWxGAU1P55lS7a+YXRuziW11bKUO51G0D1e8OjvuqfMcj81IwWhFL2GEvinsvygF6SKaIfLCbiC4kp3OAciq0DV/MSIoaKZggAtLhlglnME2VhbA8W9s+UCNCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=klDuBFC2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klDuBFC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E81C19421;
	Wed,  8 Apr 2026 19:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674946;
	bh=1QUusYiAuubIDkd40TcX3VFMf+lOfQJH4wgumGxDuEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=klDuBFC2o7m1r0SPpT3hyxNRS6laTOG1HUtNfrNY4CrL7JrUHPQX4Z9wBtIitYPHQ
	 p3F0JDkbalNod3SaKQ9d61nifR/hBiupO/Q0TAdm7w2kw4NBQVbilbQVMxNdPBjreX
	 JRYbBgcUMfbpPNoECANszyoMT8Qrbbot+mnDpipU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 295/311] HID: appletb-kbd: add .resume method in PM
Date: Wed,  8 Apr 2026 20:04:55 +0200
Message-ID: <20260408175950.390635184@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Garg <gargaditya08@live.com>

commit 1965445e13c09b79932ca8154977b4408cb9610c upstream.

Upon resuming from suspend, the Touch Bar driver was missing a resume
method in order to restore the original mode the Touch Bar was on before
suspending. It is the same as the reset_resume method.

Cc: stable@vger.kernel.org
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-appletb-kbd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-appletb-kbd.c b/drivers/hid/hid-appletb-kbd.c
index b00687e67ce8e..0b10cff465e17 100644
--- a/drivers/hid/hid-appletb-kbd.c
+++ b/drivers/hid/hid-appletb-kbd.c
@@ -477,7 +477,7 @@ static int appletb_kbd_suspend(struct hid_device *hdev, pm_message_t msg)
 	return 0;
 }
 
-static int appletb_kbd_reset_resume(struct hid_device *hdev)
+static int appletb_kbd_resume(struct hid_device *hdev)
 {
 	struct appletb_kbd *kbd = hid_get_drvdata(hdev);
 
@@ -503,7 +503,8 @@ static struct hid_driver appletb_kbd_hid_driver = {
 	.input_configured = appletb_kbd_input_configured,
 #ifdef CONFIG_PM
 	.suspend = appletb_kbd_suspend,
-	.reset_resume = appletb_kbd_reset_resume,
+	.resume = appletb_kbd_resume,
+	.reset_resume = appletb_kbd_resume,
 #endif
 	.driver.dev_groups = appletb_kbd_groups,
 };
-- 
2.53.0



