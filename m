Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3004C97;
	Tue, 11 Nov 2025 00:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822757; cv=none; b=h5oEIHY731p0/voj3EJ9U2YOFitRvB5yfS2S1v6GwRuhokhUeJUsFIbxRpaU7qiIP956ID9EGdB9/hRXUHJn93yFBDN3tJ7GJouVnjqsUECcnyoBv+iHvVkT4Tja/BFDd47Ww0STRsM3chURkpMvW1nUAGox1J/9lJpUNmtzIqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822757; c=relaxed/simple;
	bh=u6+iwWDTut//Vy+SxhiuU2xH752qowu/GIPcH7GufSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4k9+6q6mxyVul2r4uZzmgsFbARwipp+J3BirwhfgEUuAfzbf5V344/WcUZc17iI1s+JQ+MNSY2JeSjnpRt9c32b6oQHzyBBm+qiNJSMeGzfH2/AMke/7FQnthdbVJfRmqJ9cP3/x2FZtmjx4J6pqWaScKc9mIjJV3CZX+nQWDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2JD/MClY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2JD/MClY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31C07C19424;
	Tue, 11 Nov 2025 00:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822757;
	bh=u6+iwWDTut//Vy+SxhiuU2xH752qowu/GIPcH7GufSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2JD/MClYS57Sn+eDJ4a/iJXwMtF0/dCwIk6sgsYyy2Y0R2lGmNnuZBL+D+Dt4Pr/L
	 dVLWgtCPFX2/S+l8zLKqSD+kR51bbwtW96Qsl2LUubuaUelmPHhuLPggXjeUcOLtDt
	 qhX9Gi9xOT37vT35hWOHekc+IiTbQc5DB9arKd3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 162/849] hwmon: sy7636a: add alias
Date: Tue, 11 Nov 2025 09:35:32 +0900
Message-ID: <20251111004540.346859977@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 80038a758b7fc0cdb6987532cbbf3f75b13e0826 ]

Add module alias to have it autoloaded.

Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://lore.kernel.org/r/20250909080249.30656-1-andreas@kemnade.info
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sy7636a-hwmon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/sy7636a-hwmon.c b/drivers/hwmon/sy7636a-hwmon.c
index ed110884786b4..a12fc0ce70e76 100644
--- a/drivers/hwmon/sy7636a-hwmon.c
+++ b/drivers/hwmon/sy7636a-hwmon.c
@@ -104,3 +104,4 @@ module_platform_driver(sy7636a_sensor_driver);
 
 MODULE_DESCRIPTION("SY7636A sensor driver");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:sy7636a-temperature");
-- 
2.51.0



