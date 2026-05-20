Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C1E23B61B;
	Wed, 20 May 2026 16:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295877; cv=none; b=RcaqeQKBYSBz7YOTC9zrtMOU55ZyCDqJuq74gQZ5LMxPz3Tj0RGWKYFSJ7NeNufke2Vm72o+yLD8Q2oOeSA0JclYrLH5zyS9HrEJpkwVVr5nEzgK7p0gCH9bRIWd/9aFDIqwerDDZzQjene5OyA241gVP2qOaS5Nx4LPL8il4aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295877; c=relaxed/simple;
	bh=SNnZ6vPUkCahUYh5fwZRo3QpygiuURkg9vN7GUvMao4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kg14Mb7FhrGENKOvE36X/9bpPmXqS7y7DRVhSxulbi5vx9zcdXibWBYMcpFTg5IMlsgDFqNdTzmo6WWB0peqOj1dGLphuWfaegAzx9h4I4eF07imLD4FcZClPyJ0Hi6/rtRzaKoIgZlkpOziu6evd+Ns7zYXhTaGGF7iCpNDoN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cyQnj8xD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cyQnj8xD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCB61F000E9;
	Wed, 20 May 2026 16:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295876;
	bh=uwTOAI6nelB3atHiLIa5QD+ooS7fN/xBThJim4mgbfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cyQnj8xDLN7sWDQ2nfDdNEJC4Z9j/518ssC2aGWG1kn3pmtbzABxuATzJSuInAWzu
	 LkhFemoVaUI6PAJpgVEkNt2v842dRDX7F9kiFapa0sauV49G605p7yCGZ44YFvblci
	 6g0ffNlkFTrhTCm5aSCtD+eQTybua0e+iczkoc+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <denis.benato@linux.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0586/1146] HID: asus: make asus_resume adhere to linux kernel coding standards
Date: Wed, 20 May 2026 18:13:56 +0200
Message-ID: <20260520162201.440827980@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index bc93b27f9b136..d29e002c3af17 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1163,7 +1163,8 @@ static int asus_start_multitouch(struct hid_device *hdev)
 	return 0;
 }
 
-static int __maybe_unused asus_resume(struct hid_device *hdev) {
+static int __maybe_unused asus_resume(struct hid_device *hdev)
+{
 	struct asus_drvdata *drvdata = hid_get_drvdata(hdev);
 	int ret = 0;
 
-- 
2.53.0



