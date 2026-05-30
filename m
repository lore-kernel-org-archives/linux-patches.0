Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AF8263F44;
	Sat, 30 May 2026 17:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161454; cv=none; b=OeTaeScn1m97QW1AS5RRu6hIZLuX/fjadc1f8fv7JZuoQbkmvhPUlhYfKNwTuwXYhfRnY4y1cbQRXTRoJzbpM4KzGRLwahSj0z24m3JJCqOXpfwp2FtS1xIdnDtqeqO0IhBQzjDWiv5/K7WuAbUxYyQJXSbmK3wfMAUGuQtSpSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161454; c=relaxed/simple;
	bh=mRTrbKqzGiwRLXH3yNcm9BLh03/P5VO28Pyx+LCUukQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqjTgPxVQ2u96wl6r06weVZz0yT9rwKM96Ha6BpmkxrfsiEapJspDSxe4/JbQPiGr7jTfv3CG9NUpNQzY0VnHtYpiPVscJzhYULox8Ts4aOPzMwBSZTS/9UvhP+C0qKtYCa+OONFydBF4KEDIwsT/0YbBqnxqxfaDmq9kOf33zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F31yoRnD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F31yoRnD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A0B1F00893;
	Sat, 30 May 2026 17:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161453;
	bh=MC6DU6PsATfHjHlXfwHf9XDkv2/+r4rUMf1UEiAQiK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F31yoRnDAcnPWL8VikezwpszN8eOIGxeSoARsxzTDnmRU2rGB/QqS6YjYu1CSA+U9
	 +fgIKldSYisw7jUvGcx/FmB5nRcLwtmh36m3cINDp52l30L4AeJSLplVwt7OoYMlcv
	 fnRoTQiD3PSHfcsvK7sJyddHgW5Hz5bQYbnpBSTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <denis.benato@linux.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 601/969] HID: asus: make asus_resume adhere to linux kernel coding standards
Date: Sat, 30 May 2026 18:02:05 +0200
Message-ID: <20260530160317.021048850@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Denis Benato <denis.benato@linux.dev>

[ Upstream commit 51d33b42b8ae23da92819d28439fdd5636c45186 ]

Linux kernel coding standars requires functions opening brackets to be in
a newline: move the opening bracket of asus_resume in its own line.

Fixes: 546edbd26cff ("HID: hid-asus: reset the backlight brightness level on resume")
Signed-off-by: Denis Benato <denis.benato@linux.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index a95e47ce6d1e5..b51988e478e59 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -996,7 +996,8 @@ static int asus_start_multitouch(struct hid_device *hdev)
 	return 0;
 }
 
-static int __maybe_unused asus_resume(struct hid_device *hdev) {
+static int __maybe_unused asus_resume(struct hid_device *hdev)
+{
 	struct asus_drvdata *drvdata = hid_get_drvdata(hdev);
 	int ret = 0;
 
-- 
2.53.0



