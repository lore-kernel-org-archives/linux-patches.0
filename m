Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C906330BF68;
	Wed, 20 May 2026 17:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298568; cv=none; b=hEJ1mD9aIw3RDpmTyjzr5Jv8f6EiSjtoXbMXW9XkWPDrlB+zim4WcPfN+AoVcd6NmTpZMzeCEVF6ct5eIg8wOjX9LQvK1POqzAxC/2rJH9zEUmgkVNl/DHEdXpkfiqTHwQDuuIKUyAt1gB2DGvxfuk7R9p3/w8Wrgu7dBvGEjqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298568; c=relaxed/simple;
	bh=MGMijEROD0c661F0NOT70OOQ1g9ggT4/bU+TbjYxDDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xr/deAfBlZOl/KbtbMIkB8exQtkh0yhwD8CiGkR04Yfy2jQ9x5e0oDntXXxPgvd/yhBtMc/VraGZWO22NQCIEc/W4GLhvN8LCH1TDImuUdajtYjSYUX3wrPDGXz3mCDa98tXMPkryftHGkTbymXlPE6+ptNHXNNV2dLxd2wGowg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kv7GvdnF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kv7GvdnF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7CCE1F000E9;
	Wed, 20 May 2026 17:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298567;
	bh=MFMpDyJZLVQXFTLUhAWVolTif3Yw4vdXVYYXxGrMYsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kv7GvdnFlVqRDx3uebOgembRWbi/uJMJG+CkEihlayfJjV/X2McL3gVMYsQ6lgp/K
	 qfKJ9Fsh+E0E4xmLEnqsjYpSfY0X/9uU2in/VzDMGi1ua68PGnutpBdcde4h/l//RX
	 m3QmOzTeJ8M75wUT8RyQslsIefsF+S3lulQt80dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <denis.benato@linux.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 460/957] HID: asus: make asus_resume adhere to linux kernel coding standards
Date: Wed, 20 May 2026 18:15:43 +0200
Message-ID: <20260520162144.498405124@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 5a068f6fd2ce5..b9dfb38b0df4f 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1095,7 +1095,8 @@ static int asus_start_multitouch(struct hid_device *hdev)
 	return 0;
 }
 
-static int __maybe_unused asus_resume(struct hid_device *hdev) {
+static int __maybe_unused asus_resume(struct hid_device *hdev)
+{
 	struct asus_drvdata *drvdata = hid_get_drvdata(hdev);
 	int ret = 0;
 
-- 
2.53.0



