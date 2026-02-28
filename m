Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00444325714
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301568; cv=none; b=RJ3AFpJmejtN36WFrbdyfk1oGswzk3lYPrfAI7PMzbMwQJQ5GbDfOAVwxzG/6z/1p+2/Txgg2hw9DYb04iXXlWcZ17e98dMaSLEb1CBxcu9lvSYgLQjrSzIoTALGm7WkiOOflCfzFM5tQNiC81zfxCuroQM+Xah0ai/Jx8GyEHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301568; c=relaxed/simple;
	bh=kjYl48MKzqGpME0ktYz7rGI9bYGvuvntwezuXTvt6mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a89tIUBZs7FmUhVBxGuFXtPTDpeGLntRVVUf+fU42YZwAWDxg1ZKnnRoEYNPbwrV24Zf2OGXK9YHPFsK383HuUzCzaLWv0Dv7hQX0jgJKHdUNvAOjCYhU9bnrKl6NPPvWNEb71nN0IpPaDrPMfGw/nb0NrlPBit0d4W0nZyiOOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=guSQhQa9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="guSQhQa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7CAC116D0;
	Sat, 28 Feb 2026 17:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301567;
	bh=kjYl48MKzqGpME0ktYz7rGI9bYGvuvntwezuXTvt6mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=guSQhQa9mZmCl+rdWMiaKNV3BDQm7vLpdsa3BrOLIn/Um7X+F3OjW+r9QlMdbnWif
	 qFqjQxfXJbFxsmi7BbYpr9IGytH+0ez5NXyIKD5FXv0QiLJ/UysCp321R6XLxfkaAi
	 nWfZiGS8Ui4mo1I0G8ZCB1m6NnW7a/6Vjkr1wcPIltLrtrmbWBa8WNyknGrEXUo27H
	 dhmHWWPi6lQgun8LLOUGGrHnYmnoYi4Ejp8eFEnHTF9ExDmKdlvE6/g89leulKq1Fl
	 2JnqhMXE2y2m4I6OIa4gnlszNSj3mscz/22c1JTtvvtCHwxnxNwVjEbtTNudPP5PE/
	 RwXt59zG29UdQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sasha Levin <sashal@kernel.org>,
	Athul Krishna <athul.krishna.kr@protonmail.com>
Subject: [PATCH 6.18 751/752] Revert "ACPI: processor: Update cpuidle driver check in __acpi_processor_start()"
Date: Sat, 28 Feb 2026 12:47:42 -0500
Message-ID: <20260228174750.1542406-751-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

This reverts commit 0089ce1c056aee547115bdc25c223f8f88c08498 which is
upstream commit 6cfed39c2ce64ac024bbde458a9727105e0b8c66.

This commit is causing a suspend regression on systems such as the Asus
Zephyrus G14 (GA402RJ) with Ryzen 7 6700H: when suspending, the display
turns off but the device fails to fully power down. This is not seen
with v7.0-rc1 which indicates that there are changes missing. Therefore,
revert this change.

Link: https://lore.kernel.org/all/lA7Dz_m7_nCF8KkRyEOcSCLg799Mm9_DN2r9hx7ISjw32OoKiB1r_YjGHIFX8vgqxpOkVJ8d_yHb-VsGAvIWC942D4-zdWxAIP4_k6ZIQi8=@protonmail.com/
Fixes: 0089ce1c056a ("ACPI: processor: Update cpuidle driver check in __acpi_processor_start()")
Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index 7644de24d2faa..65e779be64ffc 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -166,7 +166,7 @@ static int __acpi_processor_start(struct acpi_device *device)
 	if (result && !IS_ENABLED(CONFIG_ACPI_CPU_FREQ_PSS))
 		dev_dbg(&device->dev, "CPPC data invalid or not present\n");
 
-	if (cpuidle_get_driver() == &acpi_idle_driver)
+	if (!cpuidle_get_driver() || cpuidle_get_driver() == &acpi_idle_driver)
 		acpi_processor_power_init(pr);
 
 	acpi_pss_perf_init(pr);
-- 
2.51.0

