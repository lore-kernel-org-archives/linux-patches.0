Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD8BD3D1CA0;
	Wed, 20 May 2026 18:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302318; cv=none; b=WSu9RgFcrOVgGOQhig2zp6CCk8hMyMcMRyYoUt+9JBxXeQB1vEtBwkMR8ibVDq/wox3Hfa/bwrZQ+lM5y0z3NLEzc2eQDicuQkkXHJVnc7gd9IWuReYuvef2ZAOa7msWZ6vReb0YNjzeD/0vXMit6+K1Tq3sBIiDrTUDZYq847w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302318; c=relaxed/simple;
	bh=pHGg7B7bWI70UhByP8S32iZVCisvzHv0+15hmP5o5l4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QX2i9sOHNrc3+UpWtkQQjYDohZd3wUfYgu4w7VGmJi4aM+HV3GkkgeHzGeVmHA8bqlDUHkan0v4bDQmclJ6zUriaBudrTy2SnhLcB72CBUr4rzbcCkSvPGfT8Dbr+4kIlevpPHdP62u6Vzj5aG3CoB9y85RuGCLYhY+ys7caNks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1LcqVXNL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LcqVXNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA6B1F00893;
	Wed, 20 May 2026 18:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302316;
	bh=SGYqWc9N+ja8wZT+ZkNvaUV25zZB9ubhCdxUtdH5Zpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1LcqVXNLwLKZWd72bUz3So46cBVmNLFwVkdeKduRw3BA/5Nrsidz/RXhDX2vqnYuA
	 ziFu+5H3/gmZFogAH14YGDCrtGfLeKlrcMI4yV6WiTIjVy9kPQS5+WBAkA4DXLaMzn
	 +WiJXFkv7kfHMXA4dHpq2CbCAtuFKXzuSNnXB/fM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <denis.benato@linux.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 222/508] HID: asus: make asus_resume adhere to linux kernel coding standards
Date: Wed, 20 May 2026 18:20:45 +0200
Message-ID: <20260520162103.449463639@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 544b74eda284a..e4ea87cdb05fd 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -990,7 +990,8 @@ static int asus_start_multitouch(struct hid_device *hdev)
 	return 0;
 }
 
-static int __maybe_unused asus_resume(struct hid_device *hdev) {
+static int __maybe_unused asus_resume(struct hid_device *hdev)
+{
 	struct asus_drvdata *drvdata = hid_get_drvdata(hdev);
 	int ret = 0;
 
-- 
2.53.0



