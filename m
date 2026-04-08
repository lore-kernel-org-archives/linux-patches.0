Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C67F27979A;
	Wed,  8 Apr 2026 18:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673503; cv=none; b=tMl9qbrCOLBM2kEWib7Y85w0CMU9Gbjn5I7cCmi59NR7fgJNxRIOWCedRkiG893PpSC/UpL7uHFzbgo9+AutJlw+2paGu1djBkE5N2zi6QPhhKAy0fXoOJYcqh7K1RpLZuylZwX7jitSvwiKIzLg7M6UArsAFCDFfIZ2yBo30GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673503; c=relaxed/simple;
	bh=AcvoDkkTgV3PMwjQrYNJbV0O/vqhw5U08gmJKTf0U/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9fAKwcqx1ytAOjzxYFZEQZ1awwDGcKGrS61nLazSeCJrUdirPnpK5gMdKmAEPE1HKyxr/OrPlFepMJ9RauAzgB0uQIj1BO0klrzNSq0DA0J5kCoUPVDAvIP+aDoSGMIYMSfWasQ4a1UvA2koPOKDrXZyFCx+9GMizfp1NgNfvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3OVcffs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3OVcffs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12B27C19421;
	Wed,  8 Apr 2026 18:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673503;
	bh=AcvoDkkTgV3PMwjQrYNJbV0O/vqhw5U08gmJKTf0U/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3OVcffs0Tter06HlaMyQzuxiVaw/b4fSgs4T25vQmOvKz94H0hYgcRPuTscnnxW6
	 0TTgL+/QG15qvdH0l8RL9GhJBOgBdx/Ed6nuZLL3i2jnLo9rGDFI7mQ5moWQQJ7Wn4
	 jS+9ramretQQj4Zpxpna/Chc6ajFIt9zpdzilznM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Garg <gargaditya08@live.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 250/277] HID: appletb-kbd: add .resume method in PM
Date: Wed,  8 Apr 2026 20:03:55 +0200
Message-ID: <20260408175943.193077945@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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



