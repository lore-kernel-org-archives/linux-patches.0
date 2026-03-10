Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12BE389471;
	Tue, 10 Mar 2026 11:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142128; cv=none; b=OSQUGjTnJRt+4QwuaG+a3QbY9GTrAYVRvof21HDC6Z81Mj5E56kr3RCvDpGSbgO9J9e0VeodHM1LuEv0Emki412wOT92b7UTiGzgBwvjHi/e7Be5njtZ3HbWlg0sCaEoNCv956DduomVaVoOpUn7mdKAw+rJ4lrvd+hYRG8qgu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142128; c=relaxed/simple;
	bh=ZAuG8IKAu45hV2mMVEd4KoN4NMaMHWFK5R0z0/qDGpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeTPkZ3C0odeaRseqLS1bnz0ZTZYxhWWaHhCNP8Ul0kCFnJYfEScwHwFec1vBgv/7x3XuDnbD0DASmgJFoIZOo0iA9spG5retjreGGPYCWMKIMzCcnwVSJRxb0kQJ4+tZr/ybBLnEIyBpzFO1fQlQ4mGgWuNqy982zbPIDkR5sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sFIlRNPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sFIlRNPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADF4C2BC9E;
	Tue, 10 Mar 2026 11:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142128;
	bh=ZAuG8IKAu45hV2mMVEd4KoN4NMaMHWFK5R0z0/qDGpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFIlRNPdWg6bMFUEEGpCRWojkJMGsY76/cBl7EX22GrQ1B0tVD5OxsTlqus1uKheg
	 zAZtKybOldUaKy4aa/lFxSFJq7fZ3MTYx2+/JaUMvnrnQieGQO5O/iLdnCQgiDLPo7
	 2oeTJgtIgCrLro3lWWQx85mm8aZD9pBOp4beXxl816vie+qGciHeb/L8Gy4Ey33aJE
	 6vVKxEQR4S3OuNqJj8XrtU7LmbfiQc98BE8+XHviMVEF9HEg1ZGfbyLkKD/vwwEcg5
	 WiJQNVMHxmQl7R1xUytJMJtk9uIHJM8qpTq9eqW19ILjvL7qJqr5socKFEPF9mC/Iy
	 5YXWZ/5b8PPwA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>,
	Frank Crawford <frank@crawford.emu.id.au>,
	Guenter Roeck <linux@roeck-us.net>,
	Jean Delvare <jdelvare@suse.com>,
	linux-hwmon@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 217/314] hwmon: (it87) Check the it87_lock() return value
Date: Tue, 10 Mar 2026 07:17:56 -0400
Message-ID: <9fa18b2a83be7aae70a73880a36086931f347296.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 07ed4f05bbfd2bc014974dcc4297fd3aa1cb88c0 ]

Return early in it87_resume() if it87_lock() fails instead of ignoring the
return value of that function. This patch suppresses a Clang thread-safety
warning.

Cc: Frank Crawford <frank@crawford.emu.id.au>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: linux-hwmon@vger.kernel.org
Fixes: 376e1a937b30 ("hwmon: (it87) Add calls to smbus_enable/smbus_disable as required")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20260223220102.2158611-15-bart.vanassche@linux.dev
[groeck: Declare 'ret' at the beginning of it87_resume()]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/it87.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index e233aafa8856c..5cfb98a0512f0 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -3590,10 +3590,13 @@ static int it87_resume(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct it87_data *data = dev_get_drvdata(dev);
+	int err;
 
 	it87_resume_sio(pdev);
 
-	it87_lock(data);
+	err = it87_lock(data);
+	if (err)
+		return err;
 
 	it87_check_pwm(dev);
 	it87_check_limit_regs(data);
-- 
2.51.0

