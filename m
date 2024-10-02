Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD551EB21;
	Wed,  2 Oct 2024 14:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879457; cv=none; b=KwnT8R6aBUFREKTUf9tQwA5bs1VxxxNfRRfszDbBi49tMn3mNSALesZivxzJh78/WV00TWOkYAhLsLhOlU41g3+DvOkhgH1BhdyBS+8RYjuCDWlNP9mylzmgpLQVPHhhccHDOHrN46i7wYaHqqpK3qqe0f1ACpyvZ9aU49NEiDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879457; c=relaxed/simple;
	bh=ZM4hTvcR7EZn8AcBswNXt6IxM2X5e/w4wDkgDVrzjB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=idhVCn+6Dlmn6DNgatvZb8jCnATJu9XMBjjmcWiEVEac9ccRrd/fjpHm0G+w9bxh8+KA0F8fdPYS+V3YoHZ7h1XtjierI69UOvLW83sYInP7Y0T2lh+x48Zk/6llj2Y2oEt8WBPf6JL2KsjQS/1H13n0wOuiG3FebpMOnq8RHtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNuZ0saR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNuZ0saR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A329BC4CECD;
	Wed,  2 Oct 2024 14:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879457;
	bh=ZM4hTvcR7EZn8AcBswNXt6IxM2X5e/w4wDkgDVrzjB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNuZ0saRTfgWQN1JKY+8gi5NY1hcq8JgB5GoSWQwrjc+4q7LWM7YmXP9Sm/cje5Ot
	 W5VJA3XcV3XJAZckI2sFMuAMpZV0ntIpB8uofLC9ADMwnF7rf1W4MHzIr7PKGrOniC
	 lBY3nzgSHIBb/JtAPcidkaW6N9G24HvzQHXxEF40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Liu <liuyuntao12@huawei.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/538] hwmon: (ntc_thermistor) fix module autoloading
Date: Wed,  2 Oct 2024 14:56:03 +0200
Message-ID: <20241002125757.139568912@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Yuntao Liu <liuyuntao12@huawei.com>

[ Upstream commit b6964d66a07a9003868e428a956949e17ab44d7e ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded
based on the alias from of_device_id table.

Fixes: 9e8269de100d ("hwmon: (ntc_thermistor) Add DT with IIO support to NTC thermistor driver")
Signed-off-by: Yuntao Liu <liuyuntao12@huawei.com>
Message-ID: <20240815083021.756134-1-liuyuntao12@huawei.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ntc_thermistor.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/ntc_thermistor.c b/drivers/hwmon/ntc_thermistor.c
index ef75b63f5894e..b5352900463fb 100644
--- a/drivers/hwmon/ntc_thermistor.c
+++ b/drivers/hwmon/ntc_thermistor.c
@@ -62,6 +62,7 @@ static const struct platform_device_id ntc_thermistor_id[] = {
 	[NTC_SSG1404001221]   = { "ssg1404_001221",  TYPE_NCPXXWB473 },
 	[NTC_LAST]            = { },
 };
+MODULE_DEVICE_TABLE(platform, ntc_thermistor_id);
 
 /*
  * A compensation table should be sorted by the values of .ohm
-- 
2.43.0



