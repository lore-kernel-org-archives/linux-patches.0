Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070282505C5;
	Mon, 12 May 2025 17:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072797; cv=none; b=PBs074LcjlY9a6IP9c5DVg9Q7Tp20IBpz5pk2a2gSfZLZQ8TSqyeX4b/g6IBPOYdLZi97jG2uEYspoXcMkqRiobPr6CKh1agf7M1axX9luj8t6/xaHRRAzG7SUUv8xQmnBxXRNsU7kr0YCKebN5Dc2KlQ+VwdDvCdzpbLjz1zp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072797; c=relaxed/simple;
	bh=OulrA3gXjJE6WN67lgtVgGOpnrfzCHY24dQpKp6l51Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXMl1fmCbe3WZ7dwnOWdyK/Yeu5FE+m8qhLL9AhL+Pv4zUwMwh7BO7trPiiPAJ3wAQzW5jZuQdGxHJXakZMWVcMNuJYk8bnE9YXFwmtxbKDJdGHP5IZ25luRxBAJ7TekKcOUfYTMlkPQVPy87r7xJ/B0pPG+aHqHwSxcDcKHIHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cyag2N+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cyag2N+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE94C4CEE7;
	Mon, 12 May 2025 17:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072796;
	bh=OulrA3gXjJE6WN67lgtVgGOpnrfzCHY24dQpKp6l51Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cyag2N+cukIKE++paQ5VG4K/IuIgL6ZJBM9dBYPJY8+MTY8jbRwaSvgnd0W8Bu1Jz
	 j0UX7P5ksQH9sjkOpSoOQ+SKO5iqwRg2tPZfZXyp2g4VhPLI2S5q5EPkR5LTWc2Hwn
	 NyCTo0P86J/KRZZZTTDtsXFiOdECA3oY1H2rvraU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lode Willems <me@lodewillems.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 058/184] Input: xpad - add support for 8BitDo Ultimate 2 Wireless Controller
Date: Mon, 12 May 2025 19:44:19 +0200
Message-ID: <20250512172044.099098390@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

From: Lode Willems <me@lodewillems.com>

commit 22cd66a5db56a07d9e621367cb4d16ff0f6baf56 upstream.

This patch adds support for the 8BitDo Ultimate 2 Wireless Controller.
Tested using the wireless dongle and plugged in.

Signed-off-by: Lode Willems <me@lodewillems.com>
Link: https://lore.kernel.org/r/20250422112457.6728-1-me@lodewillems.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -388,6 +388,7 @@ static const struct xpad_device {
 	{ 0x2dc8, 0x3106, "8BitDo Ultimate Wireless / Pro 2 Wired Controller", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x3109, "8BitDo Ultimate Wireless Bluetooth", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x310a, "8BitDo Ultimate 2C Wireless Controller", 0, XTYPE_XBOX360 },
+	{ 0x2dc8, 0x310b, "8BitDo Ultimate 2 Wireless Controller", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x6001, "8BitDo SN30 Pro", 0, XTYPE_XBOX360 },
 	{ 0x2e24, 0x0652, "Hyperkin Duke X-Box One pad", 0, XTYPE_XBOXONE },
 	{ 0x2e24, 0x1688, "Hyperkin X91 X-Box One pad", 0, XTYPE_XBOXONE },


