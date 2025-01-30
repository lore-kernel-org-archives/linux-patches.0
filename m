Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B041BBBEB;
	Thu, 30 Jan 2025 14:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245711; cv=none; b=JGBH+eI0egspknUpG6NMlc7na4E84NUuR4uVQvjSvrEUKi6vc160GX52+Sd7/+FocYl92kJCJstEBVS2NvlxaYt845Yp/zThyV9xRgliBUh5yY1gxvZ2C/nCSdsuMdqIiqj4J5/UdrodSrAFekmfmOVL1ox0GO6OM85GSW26XEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245711; c=relaxed/simple;
	bh=QNEfF+oQ6C4bFTHm4K16IL/7Qvt7M193sNBWUKT/CQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCxEkF6XN3VTni/bdVGI88oj7uqbNaNjdyDPaR9SqWAAw56avL46KkS3OyHMfchW/LBPEIv6HUmALbcPPlCWuY9ImgOHUvdhHLsJuoXIrkVw9UDvUxzO9uBgz0YB/LZ5Fg84CC7CNIuLF1NWtCDpcfC8lEWcvMc+VW6G4vCsbPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jsXwvQlm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jsXwvQlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB699C4CED2;
	Thu, 30 Jan 2025 14:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245711;
	bh=QNEfF+oQ6C4bFTHm4K16IL/7Qvt7M193sNBWUKT/CQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jsXwvQlm1U9/FVgMt25KloOnv279bHEqqK2jiy5MAWhMOitA11uDZRwp57+Y9G/yj
	 jEL46kKKFM36Pm0Zdssyo1LzUca/arQ4EmR3RWU0EYTJWkO1XNizx0ASPQqycAMEvX
	 H1ZKnxPq3Zi48P7xU9ihlt3C6nAGFv2b8/jKamEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 35/40] Input: atkbd - map F23 key to support default copilot shortcut
Date: Thu, 30 Jan 2025 14:59:35 +0100
Message-ID: <20250130133501.114785908@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Mark Pearson <mpearson-lenovo@squebb.ca>

commit 907bc9268a5a9f823ffa751957a5c1dd59f83f42 upstream.

Microsoft defined Meta+Shift+F23 as the Copilot shortcut instead of a
dedicated keycode, and multiple vendors have their keyboards emit this
sequence in response to users pressing a dedicated "Copilot" key.
Unfortunately the default keymap table in atkbd does not map scancode
0x6e (F23) and so the key combination does not work even if userspace
is ready to handle it.

Because this behavior is common between multiple vendors and the
scancode is currently unused map 0x6e to keycode 193 (KEY_F23) so that
key sequence is generated properly.

MS documentation for the scan code:
https://learn.microsoft.com/en-us/windows/win32/inputdev/about-keyboard-input#scan-codes
Confirmed on Lenovo, HP and Dell machines by Canonical.
Tested on Lenovo T14s G6 AMD.

Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20250107034554.25843-1-mpearson-lenovo@squebb.ca
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/atkbd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -89,7 +89,7 @@ static const unsigned short atkbd_set2_k
 	  0, 46, 45, 32, 18,  5,  4, 95,  0, 57, 47, 33, 20, 19,  6,183,
 	  0, 49, 48, 35, 34, 21,  7,184,  0,  0, 50, 36, 22,  8,  9,185,
 	  0, 51, 37, 23, 24, 11, 10,  0,  0, 52, 53, 38, 39, 25, 12,  0,
-	  0, 89, 40,  0, 26, 13,  0,  0, 58, 54, 28, 27,  0, 43,  0, 85,
+	  0, 89, 40,  0, 26, 13,  0,193, 58, 54, 28, 27,  0, 43,  0, 85,
 	  0, 86, 91, 90, 92,  0, 14, 94,  0, 79,124, 75, 71,121,  0,  0,
 	 82, 83, 80, 76, 77, 72,  1, 69, 87, 78, 81, 74, 55, 73, 70, 99,
 


