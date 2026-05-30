Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEB923392B;
	Sat, 30 May 2026 18:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164268; cv=none; b=IumcNA+FCgmbQY2EH0Rr4qcTQbh89hYBEtYOsITIwb6c7ZyOZq4ABUhHafPWeicqUYdJdhY2hcho3qh8vBgmiObwddusMEloRxkEfjCD/DM1Q5gPZr/8oLLJgnq+NRRKdCh8LWn+B8cjqA21hLG73Su81buYzgKe/OQYy5pA5r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164268; c=relaxed/simple;
	bh=OHHc4X6LqYiO2DXv4wFOBxsh+bE8rnONovKXAHmyJWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsDgcLtcheHUd/8Vfa5YE/pEMbZo6gf5/9ElV8v6YKmzKISkAtN4Cbn829ATQbWIRId99dFwr5yzBX1RcYIHm2DK5dBcFiFbWzaFW4wxVBEEiDvczE4OkuIsWCmPYLepw9/SSunpnYRLs4aX/R1BgRyUr40YIZ3bOWe6hwn7EJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qi6AxDIt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qi6AxDIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23131F00893;
	Sat, 30 May 2026 18:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164267;
	bh=tpw01CaaHG2qZrW9EGZ+c6dI2wfpXdIbiM0O/E/SQzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qi6AxDItcv1ZhOs0xgQZWJxuaYXUlufy0Y0Jsb9BB166HwzQQ6EinWn1ucIz1my9e
	 jiiX/rcEAueUc2npGkV84PnNcBhBBYvfCuFsHgFp27LfKSP+3aPykLXqQZS/DB+RjS
	 HU4p9l6Om3J+8NGkbayKpuDvRWuHiHWBol75KUnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <denis.benato@linux.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 504/776] HID: asus: make asus_resume adhere to linux kernel coding standards
Date: Sat, 30 May 2026 18:03:38 +0200
Message-ID: <20260530160253.310297140@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3be17a8b7a293..5c7306fb57b1d 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1014,7 +1014,8 @@ static int asus_start_multitouch(struct hid_device *hdev)
 	return 0;
 }
 
-static int __maybe_unused asus_resume(struct hid_device *hdev) {
+static int __maybe_unused asus_resume(struct hid_device *hdev)
+{
 	struct asus_drvdata *drvdata = hid_get_drvdata(hdev);
 	int ret = 0;
 
-- 
2.53.0



