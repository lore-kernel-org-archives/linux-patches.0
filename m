Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755B521B191;
	Sat, 30 May 2026 18:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166445; cv=none; b=VH6sttY8lwP46gC0JOfk9aefcrw2X+JdolGBWMHl+I58pqhpuT2eu2IF2KaJ47KfQHR8WDv+srx7FS2c362OKRPrgQ7KRxPPqEpBj0PyVmRTvf1gB8zdhwvcDgRRTAsb1nFREwmpmShNdIfygom7HLqhBekHXP6SFW70fGfYeB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166445; c=relaxed/simple;
	bh=IcMh10cyGmUfHfW1Vq0uLSa1TJEyuHByew7JLCbCkPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r506hrLQfZ7yfm852n2zrmi92S+SNMLMNhuSVJocs5o2ChTBI7V0I0WKXrmevcLB7lqIKM+ePW578SuXOCcbQvcg3ps7ZoZHhIBFVwb9oGeQn+gqg+yfEqwx1DV2prjTKlKFtw98ggbI09umr8hJrf7K+pfpw9YkPFibfLdPxSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kvJ1wf0m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kvJ1wf0m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DA71F00893;
	Sat, 30 May 2026 18:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166444;
	bh=OQ4Tn5IEhk5EhSkLH6LfS57bcc9PWfqBqMiQEST8Wps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kvJ1wf0mRZwVteS0mkF9amYe5Jd0SyPLyUzVQJaNGlKjxD88ukAtTuei/7ksX48H+
	 d36t00a33g0+yJ5mt6KR1fR4/x2z9x+znagz4YxpgvsgvVX7luVlu8Mn2JgYqfv57X
	 0qaOGkP1KhuDhm1SUcMkt84bAdDiUONnrVpluuZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <denis.benato@linux.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 375/589] HID: asus: make asus_resume adhere to linux kernel coding standards
Date: Sat, 30 May 2026 18:04:16 +0200
Message-ID: <20260530160234.669896638@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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
index 9d425f81d6224..31d76cef4b73f 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -901,7 +901,8 @@ static int asus_start_multitouch(struct hid_device *hdev)
 	return 0;
 }
 
-static int __maybe_unused asus_resume(struct hid_device *hdev) {
+static int __maybe_unused asus_resume(struct hid_device *hdev)
+{
 	struct asus_drvdata *drvdata = hid_get_drvdata(hdev);
 	int ret = 0;
 
-- 
2.53.0



