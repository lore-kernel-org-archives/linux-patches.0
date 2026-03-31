Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F4E040710B;
	Tue, 31 Mar 2026 16:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976277; cv=none; b=OpAplBSzHE0GXzhUtQ209H2d7t4WY90tK1qOeu/5qhoJSIWVXqrBWhJreIN3fpGi+Xgwxhx0FJAWBI+9DW5V0mUN88hxH9A2VKTwp2BJaXFqBnIrYemRiujljPaDpe3yNzWdkztjO57MmGL5Q0w/jwtHI38tSw2WZDYiiNt1p60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976277; c=relaxed/simple;
	bh=tWl5dARxDDdRN2/vxsuOQnkt3sz0Vr8aQL5K/CzJo4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MT6VS0f7jTpIjNu98/d2aqSL7eAwRxyC0bYZkXq0xXMZcFRTPt43Kr3qaI4BD7eTf3bx4twYlB86pCYvsnkALoqTnXfKaSe/cYctDIq6uxmNUmrLdP7CrD12q/dvW7QByUKBk4FMxP7BRUiGgTPuS8Vc0TuUwfV7WOLAolMJi80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BdF3Kqld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BdF3Kqld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9219C19423;
	Tue, 31 Mar 2026 16:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976277;
	bh=tWl5dARxDDdRN2/vxsuOQnkt3sz0Vr8aQL5K/CzJo4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BdF3Kqlddavm4I9krXSTne8IiWcTUujjhLKDiV8viQqdRl5oWZL0QKYaC4w29+vwV
	 rMbnp5Uix31m2GFEN3rI2dsXpvY8iYPYyzbeZW7aM5PhDjQIdsRtQ/G0Viiy8tWT+T
	 jY7fJrBlP2wusIM2r/cBAi2za3xgHFTtNaVWTx7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 031/309] HID: apple: Add EPOMAKER TH87 to the non-apple keyboards list
Date: Tue, 31 Mar 2026 18:18:54 +0200
Message-ID: <20260331161754.627929456@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7c698de0dc5daa1e1a5fd1f0c6aa1b6bb2f5d867 ]

EPOMAKER TH87 has the very same ID as Apple Aluminum keyboard
(05ac:024f) although it doesn't work as expected in compatible way.

Put three entries to the non-apple keyboards list to exclude this
device: one for BT ("TH87"), one for USB ("HFD Epomaker TH87") and one
for dongle ("2.4G Wireless Receiver").

Link: https://bugzilla.suse.com/show_bug.cgi?id=1258455
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-apple.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 233e367cce1d1..2f9a2e07c4263 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -365,6 +365,9 @@ static const struct apple_non_apple_keyboard non_apple_keyboards[] = {
 	{ "A3R" },
 	{ "hfd.cn" },
 	{ "WKB603" },
+	{ "TH87" },			/* EPOMAKER TH87 BT mode */
+	{ "HFD Epomaker TH87" },	/* EPOMAKER TH87 USB mode */
+	{ "2.4G Wireless Receiver" },	/* EPOMAKER TH87 dongle */
 };
 
 static bool apple_is_non_apple_keyboard(struct hid_device *hdev)
-- 
2.51.0



