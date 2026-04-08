Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C24F35B653;
	Wed,  8 Apr 2026 18:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673197; cv=none; b=Ij/YXSiv5JFwwC8o1Ykt3OlzovSPpXPJXVFS/m6vtcYn3wsqYhr0Vm9O8WfnvFVEXwLj7ndIJu3h1r3ACMrcsbOHrq7TOTJx9txZ05+vkP+DvJmoZQDwrXAmMlzdnk6/PX9r26Er6GGBOPwhoEjdWUcPHnA7IG6CTs6VcgbPvew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673197; c=relaxed/simple;
	bh=p09tsTnsl1MpVSDaybH/PMtdsogbvKPHTRDuIM2By44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3jM+YsAY8zjFtwGcuJ5Ze75uMW4tYDpYyKmLVAowxJfLFuIpdPH59Dxq31un5J9Uzb8mCwvWUHb+MTIBU2L2yQQqZUD3N1FJUBlhvmfaOYBz1QLCDOA3+9j7JoMuLrOGYFVmWiElEwZ2Pxiv+0mgTC3nAaEqWe1NFIWoIu7ApA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXQZlm8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXQZlm8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D86C19421;
	Wed,  8 Apr 2026 18:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673197;
	bh=p09tsTnsl1MpVSDaybH/PMtdsogbvKPHTRDuIM2By44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QXQZlm8Z5QJ+jbE1SNxvUSuQyrxIo4cerMbII+O+I8CcE8kSFRYisSWeqSHz1+mVD
	 znR/2Ai9XCBOJ+YwIK/2Go6LPqjWg766hgnP43jCPRjgYAWo9G+43SGFF2RVokxOuM
	 5YbZpUaqvpK8NY5oqz8L9zuQqySg6lYX2E+AYcCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 111/277] hwmon: (ltc4286) Add missing MODULE_IMPORT_NS("PMBUS")
Date: Wed,  8 Apr 2026 20:01:36 +0200
Message-ID: <20260408175938.018329722@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Sanman Pradhan <psanman@juniper.net>

[ Upstream commit a9d2fbd3ad0e6ac588386e699beeccfe7516755f ]

ltc4286.c uses PMBus core symbols exported in the PMBUS namespace,
such as pmbus_do_probe(), but does not declare MODULE_IMPORT_NS("PMBUS").

Add the missing namespace import to avoid modpost warnings.

Fixes: 0c459759ca97 ("hwmon: (pmbus) Add ltc4286 driver")
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260329170925.34581-5-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/ltc4286.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/pmbus/ltc4286.c b/drivers/hwmon/pmbus/ltc4286.c
index aabd0bcdfeee3..8715d380784a0 100644
--- a/drivers/hwmon/pmbus/ltc4286.c
+++ b/drivers/hwmon/pmbus/ltc4286.c
@@ -173,3 +173,4 @@ module_i2c_driver(ltc4286_driver);
 MODULE_AUTHOR("Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>");
 MODULE_DESCRIPTION("PMBUS driver for LTC4286 and compatibles");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS("PMBUS");
-- 
2.53.0



