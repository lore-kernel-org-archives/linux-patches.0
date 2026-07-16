Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D6D3D7D74;
	Thu, 16 Jul 2026 13:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210320; cv=none; b=FTazRQGuk5qW7sEGmvGz/9XnMuGe6h2G5lUnshkayaH9KyElCl9blsaIZ3iCphx+YWIhT0LiWJLRnLEujicdLVNK8nKF5v2D6VVrIVLLRP0knqP6o9zhWykCFcVIJzLBtGR+imFZmxKHALuZGbXEpbmtAJ4T1mLWoOPITH2jFGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210320; c=relaxed/simple;
	bh=nm0nw/VX8IFTWsViReWFzll2+Rtmk+ZOhuqRgsCHzY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ubHCv+JdhqS+kyYC1Zk3r5Z00syLz62lifIgTjx/kTUSs17M+uyEN9PuNKFC97D8k50GYNayGrIepqpo41T79yLQiaGMF2MGqPlNT/ZkDUnCgZnRJ0qpDtpbFFVeZex/2qX4n5Jp2cgY5UTjFWSltH01wh9wj5XyGaIU3ZG+qJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LYeTpjvL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LYeTpjvL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C40B1F000E9;
	Thu, 16 Jul 2026 13:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210319;
	bh=XG5rDJ06GBL/U62ElrQbHi/FGyJnOqSIBuJ/Vsp8xJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LYeTpjvLCsYQ9TJKsaypcRrR5cy7N4263h4M1DhgIsECl9/oQHcr+xI10akOhbD7J
	 nCVbpPBnrpl8J2ELyI0dsWdvLLXMxrG2cNwIIXUzcMssEce1C2SZgOwmh+Hx2ozp6D
	 x7XszWplUb9TKRwAN80PzqYkWDecp/jt9eVUUJLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fuchs <fuchsfl@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 495/518] Input: maplecontrol - set driver data before registering input device
Date: Thu, 16 Jul 2026 15:32:43 +0200
Message-ID: <20260716133058.674393920@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 


