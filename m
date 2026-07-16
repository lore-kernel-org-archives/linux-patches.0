Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79ED128505E;
	Thu, 16 Jul 2026 14:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211523; cv=none; b=Zko3kfoSM0L2gyiCxxVaI9UzefS5uAQotM+nZO9m2l2RjVWbyDMz/+96h+P0cxo6EHXdhWALpdTbyWKKu/FFsrH8wyq/8isOCuPe581ylelTpazdpX+raU5/EyLBO+l+1A61uJurJhrhSWfwAenqOuL9/ZCqI8Oaw7YYFLBDaNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211523; c=relaxed/simple;
	bh=4iyuOYnQTMu7WDAjeH+6Fp7Mx0DgBpzutRyKHm+BwNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hjajcm9N0uut5dQIUK3PpnLslI/Ioh6DGni1XfmIzQL6/HIn1eyTh6DI+pix7HJAhgtjhq6kbLjwCZubzsHdHk4/M1gHgscnkX4tH7LYsAeK7xi48icthQb3iCKBOEDU/sJXhJFg9OtL653SM6tItyVVco0lKxQN13qmjOyy5R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iIp2i/Sn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iIp2i/Sn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11921F000E9;
	Thu, 16 Jul 2026 14:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211522;
	bh=gyoEKs4/5Cjm2t/94GA+rmdtxMa5ZHnVQIzk5vGNmig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iIp2i/Snpr55QHMj9X2ok8iR1I4BoEyaPLMVthsvFl/ovuTi7wPYqu9DLEmjA97yJ
	 Mb52Du/x2gZYt8Hj9r3FvGdNXYU0A6mfgbA7MRNRjMKXcBmR8e707H38p/z1RVM3vl
	 BHpi4/TEhOrdvx6mIHelFi3WHvbXlWmV1HuPjK/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 458/480] Input: maplecontrol - set driver data before registering input device
Date: Thu, 16 Jul 2026 15:33:25 +0200
Message-ID: <20260716133054.731862233@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
 


