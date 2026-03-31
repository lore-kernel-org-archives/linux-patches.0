Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2AE42D1F40;
	Tue, 31 Mar 2026 16:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975618; cv=none; b=pc4m4v9dbmKFH7BPgi0ejImFxdfmbCYImEI3pvnHGGK40+QJMO9z3PKYtlmXVqsju98UEBQIcGNzQ6P1aF+TOGpyHD7MCxu2JJiliqJt/nbvySn3M5xmHMoUJ/SzKKHnuA9P2stBy+WgiW3Es/f5Zww4XE5elT2ZJROJNKbOOYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975618; c=relaxed/simple;
	bh=bT9wOhQi7P3JuPomY/xIeMOINkfEZ0fcYvUdCwK1km0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TS9X9p1sCOF4BbvIs99dsHbMHUnxHE+s0FRErtwkxWXVaiT8psIppMSDWkmrnpsMoD3hQ4eXhFR+NfriRCa7yw8/+OY+2KVGnpbd9I4a8PqhK9OWBLeOLKBAAEbMzNCVCTXK4N5vZmlbxgkCDMK6+s1x4Cn3ygk6+2DObpR8OIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YKqovXJL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YKqovXJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68FD6C19423;
	Tue, 31 Mar 2026 16:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975618;
	bh=bT9wOhQi7P3JuPomY/xIeMOINkfEZ0fcYvUdCwK1km0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YKqovXJL2xLSihpTAyrq4Eb5A8Br+G1A8SmKvS3strlFJrfM8xpO9b0Ay2bJ/zEsQ
	 gu53eNOT+VlBxQNkbAm7FcZ4TBgIFdHQOJ6Wm8yvk9LQZOrckQ735BWyJZqdk7EYa5
	 OI8d9pSG7Qp0UKQZNTVlsIjGmdp94DmfA5vE0sqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/244] HID: apple: Add EPOMAKER TH87 to the non-apple keyboards list
Date: Tue, 31 Mar 2026 18:19:31 +0200
Message-ID: <20260331161742.486904714@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b0cf13cd292bd..16540546a210c 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -364,6 +364,9 @@ static const struct apple_non_apple_keyboard non_apple_keyboards[] = {
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



