Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F859175555;
	Wed,  3 Jul 2024 10:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003689; cv=none; b=C8yYG8xDspPm2pRb0pbgyPueeVkPDR1uFQ/d/bkvrHOzwnjPhVc/okDzxXS90zyq3QDDAw3Ypu5eO6uXq4cYTZ3hhtsoN4DbXYb8d8b/c2SgoOzvCDKeN8szhRiWwkSZRmpDA9Jx7BoY9ov0dsDQ1desLOPVDy42bAEqQop3/A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003689; c=relaxed/simple;
	bh=8AHK4fUjZPjgkIb1xhomYMGZlkvQeE5eWXD4HYU9Kdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwmYzRD3/SneO8kyCUSzxa7iPnbhL/S0hxmIXp7Ql+mxLoSVER8ZsoUt9ube1+NAP4ZQu82n4on4pCFQ5Z0b7sRK1LLtMPXrbh/BzBDk0cBsYjMfH0YgAxnTRx3d4lN7x/R2QE2qOk/PORHK3zMrXNmbP9sJVo3cbfL4P1PY7GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y2o25XDy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y2o25XDy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8362C2BD10;
	Wed,  3 Jul 2024 10:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003689;
	bh=8AHK4fUjZPjgkIb1xhomYMGZlkvQeE5eWXD4HYU9Kdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y2o25XDybgkqrZJ7kZKel3e/neVNGoMt+GTrPlvuVqhksOR0q6EGOFpIy6A2wXSIO
	 G2kLhJxDy1CvCBMofSGpTebUcd1oX4eUHYRLABly2qBzCm0VD5W6C+4bYBkHLUxtII
	 aM7aGoCYce0tNz3ras4CIAV5ApuOgaGawvgTSjFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 4.19 124/139] usb: gadget: printer: SS+ support
Date: Wed,  3 Jul 2024 12:40:21 +0200
Message-ID: <20240703102835.118126183@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102830.432293640@linuxfoundation.org>
References: <20240703102830.432293640@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit fd80731e5e9d1402cb2f85022a6abf9b1982ec5f upstream.

We need to treat super speed plus as super speed, not the default,
which is full speed.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20240620093800.28901-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_printer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -208,6 +208,7 @@ static inline struct usb_endpoint_descri
 					struct usb_endpoint_descriptor *ss)
 {
 	switch (gadget->speed) {
+	case USB_SPEED_SUPER_PLUS:
 	case USB_SPEED_SUPER:
 		return ss;
 	case USB_SPEED_HIGH:


