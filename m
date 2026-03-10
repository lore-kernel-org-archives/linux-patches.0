Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F7A352C4F;
	Tue, 10 Mar 2026 11:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141189; cv=none; b=Rz5MastjMZK4zRFvnqLndrdC+t+pLX1GRugC+QFHmftQw9GBMfQnGfWdU73Em/Y2L9s8Hb59MuRS5TRKCz1UbT9clgbvqqQDvKODDR61UcerdBAcTxhmDxx3eIcYKVAGRNlWDCyu/0ViJMtOJSd+7lKDZQX1PZA8d+Zjdi7SGzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141189; c=relaxed/simple;
	bh=ZAuG8IKAu45hV2mMVEd4KoN4NMaMHWFK5R0z0/qDGpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKny9aS08mJVVvREpTRz+bq0yzd7lO9PPAy6UXvxYmt/QcMW4C7r+IQGvzHX3jFxDduiwfwXOtUlzIU//b+5ls7wYNoy+Y5tnhCr+rCD0hDMl2Y6fPuNvCai/B19PqT1imeVwEtQAyMEgZbi6ZLYjqwWJt/1HiudK2Ue1BqmliQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jG137keq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jG137keq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D84C19423;
	Tue, 10 Mar 2026 11:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141189;
	bh=ZAuG8IKAu45hV2mMVEd4KoN4NMaMHWFK5R0z0/qDGpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jG137keqWyoZjxerhUjJY2Z8M1KOZjshUrviEwUC/Kv1Xtf5ttyGRpOYIgBKdlzoc
	 jxDpxQiUwNkCPu3fAE/llFWM1HLzv74Pxs/gWGUSwS2T/yByIZ6cjv40RIHVIa1F8R
	 ZNmkAJJwzBIl9wKqfUQ6XP9WFkNl+tqPM5UBVUrDnfvHLPlFosHeD69P3U9/lu/sXI
	 JPbPTDq2OrsJV4Mi+DtuahzvkBWnaMopFz8AtIUY+OyG5Tky78wbaCY6BsdI7V6+Md
	 AhnokrkxZPIMjv5gv3xacPcgeOyXl9zC0a1BLpyCapWcikgau/8J7Yzmrqi0Aa0S19
	 Adw/jNZBGPmfA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>,
	Frank Crawford <frank@crawford.emu.id.au>,
	Guenter Roeck <linux@roeck-us.net>,
	Jean Delvare <jdelvare@suse.com>,
	linux-hwmon@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 191/311] hwmon: (it87) Check the it87_lock() return value
Date: Tue, 10 Mar 2026 07:03:58 -0400
Message-ID: <7d981cf6f5f0b15b6683f709c343d9bfae468994.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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

