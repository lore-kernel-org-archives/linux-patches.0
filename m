Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537AA3FB060;
	Wed, 20 May 2026 18:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300841; cv=none; b=dnirJuB0iTbnf3fUPmJYwuOCAdCAHwyaKxy/S//qGMZ5FUO5tmnQNZTI3Esr/uhzSNniH8Cq9oAe48SgEF7iFOU7i/X+tVvK1uR6qSLsZXl0MfH+T+vRLrZEghiJwl8csUf6hYI3Xl9AS+Qbnib2gizx41AwpGA/67TtqcZ8mN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300841; c=relaxed/simple;
	bh=BiztyTxfZJgzl0SXH8nY5ZrOt+hbyeHyGVbebca5Oks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKSV8V3X0WYf8if1qN3b2YVdl+X5vJQYadrOqsTAFuQuoj91yHmj7m0uig/Jx3ye3owMliWDrAdS2ji/5YIab08xyqT16F/4P2sL38089RyIiaJvACyEblS0Td+UqsNge/OhC1pUZfA8XLfiMZTSLHdeAYfzqYluMmZP9Mf1cTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fthHDjy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fthHDjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D571F000E9;
	Wed, 20 May 2026 18:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300840;
	bh=TaPVugcrLUDe1RZC62sL2qCTl3g2tB0drTfBcJPZb24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0fthHDjysfxUEMGYnhrEsPSby9oqlPJvT2dVyoKV6I9WoLw77gx+HcS6v4QHFRf/V
	 5p+Bzr1mn9e5dhqGrHM7DidIsadJoeg5P+JugVYbFpWangCDtwEmjHTCTduIHjhC55
	 MjbCTsis+68g3/rvyverSCtNuoz4uB4gDnIMuYQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <denis.benato@linux.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 327/666] HID: asus: make asus_resume adhere to linux kernel coding standards
Date: Wed, 20 May 2026 18:18:58 +0200
Message-ID: <20260520162118.315483893@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index b2788bb0477f0..cba383ccfc74c 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1092,7 +1092,8 @@ static int asus_start_multitouch(struct hid_device *hdev)
 	return 0;
 }
 
-static int __maybe_unused asus_resume(struct hid_device *hdev) {
+static int __maybe_unused asus_resume(struct hid_device *hdev)
+{
 	struct asus_drvdata *drvdata = hid_get_drvdata(hdev);
 	int ret = 0;
 
-- 
2.53.0



