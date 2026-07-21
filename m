Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54B3B3E121A;
	Tue, 21 Jul 2026 22:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673416; cv=none; b=tL4996xUeLbeAKh5B6WxxvUy21RAt/6yoIa21CT9ndbwx+NkM5dkiYovkaxSx+VsZ2Ro0PE4oOeQfvoPSXkfUTmDpoHasckQdqXX6UB0+2t3/tEVcnSRgH2xHIlBZQaLxRF5BhWzgx+yh6SympaaSuBdhR9ITMAineBQjqMJ9jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673416; c=relaxed/simple;
	bh=VJD4x9tHAnTxck3VHun/TmNCPEeoOG6QRdKtkODddhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEFybgG6JEAl+AWT+hH0kCBh2qH4V5rjfbUwcz896uUi0N3LlTocBx+ojcFEbldBY/qb90/st9zaK9x7PNnHMNiG0PfJQEyLGtYVTriheXCmwZ1RzBB7fLJeEhRXVR42pknVraYG1hnmLd9VW+Jqk15xatkLLMBKlyvbau1djg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXANnsDG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXANnsDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB57A1F000E9;
	Tue, 21 Jul 2026 22:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673415;
	bh=JlN0ESEwr03cE161D/mnt0DkqzZjxvz2jzPLGfmy01I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AXANnsDGw4lX2HgG1dx+4eK8Qzm1x+u+gEbKGGzZiReuiRH7OqCqtifi2FdoaldW5
	 cgJz2kiKoq5ex2kLLhawmgWhcWwWZUcKVnCtcQPks/UbQlW0DeOdVVHwz4V7ajBl4X
	 3szCeLSNDMv63H/Mf/iM8pPaejsXnDwycji+xN4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 154/699] Input: maplecontrol - set driver data before registering input device
Date: Tue, 21 Jul 2026 17:18:33 +0200
Message-ID: <20260721152359.175581594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


