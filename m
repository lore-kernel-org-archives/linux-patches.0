Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6534B44AB6A;
	Tue, 21 Jul 2026 21:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668735; cv=none; b=uj6q6H3JSsoqMyl4qgqaJZ/2Zahc3LNThRzfKfKg8apPc6/cgYgxRKjrXrMuIl66qdDydGn1I8Ff+tqEbIHQaUQfltMnCFpJ7IR9NkAfuS3R9lquk+vbqC2aNp2sLNYsBZQILBHpGaeIJAeaw78UxGj3erqJInzulv7uc6wICyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668735; c=relaxed/simple;
	bh=0oXAynAb9pEmafBKOHLaqaSiRUo7I9kcCgnkHAHnxvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSmJvzS7URuaFRgPnuHD/24OyK3hTZmeTS6kBgqFTUCcBb8BaLfDJtIGC5rmNQO93EvcmjnGGjxmMCUWeBRixN8RWHrD5XOoxb85zJcbO4T+nLw3opsVU9BHDz4EZeORqaGKHF1d9W+G87fGzeiq1m+UduaCKELptI2Wv30V27k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NRed9nXW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NRed9nXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9E4F1F000E9;
	Tue, 21 Jul 2026 21:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668734;
	bh=VhGoPMVnhQfRdSaGUrvk/EaBe3bew1sNw3g4BZ2ohu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NRed9nXWEZ1F2aViLi5f/zkl4WionzKKryYfk5cgaB8vNr+h7ncJ0hvmeGWAG6kIN
	 sSHNxqroIhhwT8ZlBraSV7p5ihuPkLxhU8H9nC4nqf4wh+8FyOkpxTwKSRWXBDCoJX
	 XNhkHW5DJfAyQHg6lIkdD0kQ9ozqDiNJtXRYtShI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 0245/1067] Input: maplecontrol - set driver data before registering input device
Date: Tue, 21 Jul 2026 17:14:06 +0200
Message-ID: <20260721152430.080871641@linuxfoundation.org>
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

commit fe938ee497d58c644f6910cfe6ae155f6fb3e523 upstream.

Set maple driver data before calling input_register_device() to
ensure that it is available if the device is opened immediately and
the callback is triggered.

Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Tested-by: Florian Fuchs <fuchsfl@gmail.com>
Link: https://patch.msgid.link/akNYib9hQFNN1fA9@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/maplecontrol.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/input/joystick/maplecontrol.c
+++ b/drivers/input/joystick/maplecontrol.c
@@ -112,6 +112,8 @@ static int probe_maple_controller(struct
 	pad->dev = idev;
 	pad->mdev = mdev;
 
+	maple_set_drvdata(mdev, pad);
+
 	idev->open = dc_pad_open;
 	idev->close = dc_pad_close;
 
@@ -146,7 +148,6 @@ static int probe_maple_controller(struct
 		goto fail;
 
 	mdev->driver = mdrv;
-	maple_set_drvdata(mdev, pad);
 
 	return 0;
 


