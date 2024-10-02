Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D764F16F84F;
	Wed,  2 Oct 2024 13:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875666; cv=none; b=WpnTh6S6IiBAoDYCe+hDADTwRQt4D+c3HEK6i/Z2Ay2gBxXtPwrIHSLaZUeyQfn5ywuuh/SSohSI1/e5lIbSnJWEcUrBnHdracI0D6Gwe4ICqL9V6WYcNiogyKjtBz4TXnOd7A5xET5WiOFb4nWEtFi26HZGJlzZ+yneC69QfdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875666; c=relaxed/simple;
	bh=rl1FpMc82aE5+ta6BColVsgtkn5qHo+WPNSbAPkgU3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cHFMOnMgbjoFMk6H3SpxTO3LPfLP9IZ3re1ljbXA9bDCJjk1Ryz3GwmVCZyMiEemwE3vP++CFMi8pWQr6k9bMrV/EjbHOfmCdYzoQJs7bke52DP7d4nBrlO3Xnju8nm99qn4neeAQPLJNyDJqtPG815+SAqRVjgkZnBPxHP/C98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iztk50Rz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iztk50Rz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60DFEC4CEC5;
	Wed,  2 Oct 2024 13:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875666;
	bh=rl1FpMc82aE5+ta6BColVsgtkn5qHo+WPNSbAPkgU3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iztk50RzQiUUEGvgWwbH0IrPegCx7HvkGiBacePjNj44CQY2KlZkxGhtXtTzwBL0l
	 FVB8LXsCZcMEudV6JPWeiG47h+UTZ9QDYsG6PfCKNnaRm2E3xZByGj3fzdJRUqhltC
	 rk2WOwmEB8Dd85r2UYwlrU6rJgxh8+jGDiP7u+kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Liu <liuyuntao12@huawei.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 179/695] hwmon: (ntc_thermistor) fix module autoloading
Date: Wed,  2 Oct 2024 14:52:57 +0200
Message-ID: <20241002125829.616758184@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



