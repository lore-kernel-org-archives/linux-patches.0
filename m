Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2131144AB6A;
	Tue, 21 Jul 2026 21:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668730; cv=none; b=E32iqMnnVeTwtdYoD8LOYj4u1w3Ze3fdnNqn99QIjafo7rPmH8ltecaetb7Dh5ivyVPUWIojAsomZhBS7CMrkUxuklfZ42mBy2jc5rAUjFnG+tlwn+ODyqhqGtaeQ1WlRzBmTUb9F3QC7NWakRNT/dZGmzTRRo5VVQfBFoeUj14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668730; c=relaxed/simple;
	bh=FwVAk6vAYFH8JKQH87gmWPKpwTmZwqHd2AcpImBiMcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzlYkl0rDQDb2o0nQ4BpErroq77vAAST+z+2qeMhf6okMSUAfsbGpjBASFZ/V0fgXqadF1N3ct7M8byzhlAWj2P7U0/LA/IHm6lN7rEjbO7vTRff9N2HC+2plquqIXnMM8L08m6Moprf7Y4E6/9P0e8XFjHJQX7sB+TuEeOyIKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLQkpzft; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLQkpzft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BED1F000E9;
	Tue, 21 Jul 2026 21:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668729;
	bh=x8gwDuJ+GQfgqQHNxnwqvZ6c6ZmwICKTzyU5W8WhdOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZLQkpzftWWJTmvOC5a5wIrcq5t5ctC2Q6as8sSbu1/PvEEHp7gnh9ZC7xJGCXW6AV
	 vKDRj8NCfse1KBDzQ0YE4fxOroQXZcro7pMsW3Ha2kTuvu/S7g1EBc3DrfcTds/WsS
	 9f8ztarpLKG0VZXIUyhSvPdNKzQrzEG0M5/RmKsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 0243/1067] Input: maple_keyb - set driver data before registering input device
Date: Tue, 21 Jul 2026 17:14:04 +0200
Message-ID: <20260721152430.037001506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 536394ec81419b67d9f4f0028812c4372397be1b upstream.

Set maple driver data before calling input_register_device() to
ensure that it is available if the device is opened immediately and
the callback is triggered.

Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/maple_keyb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/input/keyboard/maple_keyb.c
+++ b/drivers/input/keyboard/maple_keyb.c
@@ -169,6 +169,8 @@ static int probe_maple_kbd(struct device
 	kbd->dev = idev;
 	memcpy(kbd->keycode, dc_kbd_keycode, sizeof(kbd->keycode));
 
+	maple_set_drvdata(mdev, kbd);
+
 	idev->name = mdev->product_name;
 	idev->evbit[0] = BIT(EV_KEY) | BIT(EV_REP);
 	idev->keycode = kbd->keycode;
@@ -193,8 +195,6 @@ static int probe_maple_kbd(struct device
 
 	mdev->driver = mdrv;
 
-	maple_set_drvdata(mdev, kbd);
-
 	return error;
 
 fail_register:


