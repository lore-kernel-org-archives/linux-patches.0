Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7D335BDB4;
	Wed,  3 Dec 2025 16:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778995; cv=none; b=YOcEoqgNR57yOJx4HW62OASmrVG8ERvedKX5O9FZg9TmbGT6sj7fGYiMNjw0UKswvHXMOHeRw+Tl8k4gyoR3c6kQpM6q5hJAMfdkU9Gu7VnZyYBj84zuIa3tJw0dkV4fbkzoaxjfLR791y/gkJEnwfMJE3a3x1RjxxSX4T1C+K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778995; c=relaxed/simple;
	bh=H/TDJVUMfpKr2oT+2aTcpAn5QEo7ahQVyZ4Fx+lSRUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEFPpXOXgJlqgQOImiPpznP6Ii3oYl4WmXs9LrST1K2CSs5yqtY+/c0y85OWFHuD46+07EKPe9LUQlzNZamqwbcmHNIcb1lAV4EJtggbyjR4wsnYxFKPaQ4WQC9REkHSJrkv7PIhX4ja3oQi8ghAS4wzKXTxP+BxhJTevYhx//o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycYbrprJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycYbrprJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0104C4CEF5;
	Wed,  3 Dec 2025 16:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778995;
	bh=H/TDJVUMfpKr2oT+2aTcpAn5QEo7ahQVyZ4Fx+lSRUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ycYbrprJFaEav8mMw9coSEdPhiV0+pfyB/JMQCtwxoeW68+HUVp06emNEsd1XZ60W
	 YZqV/lo1Unj9PYhK0e0qtNR09k0nFkRG7tgZC73CsMQ/2bOXJWRrtKU6szN92myILu
	 4XGr8TwTVt3PXJYJV7mAJFndKF6ilryXS9CKgO0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Copeland <ben.copeland@linaro.org>,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 123/568] hwmon: (asus-ec-sensors) increase timeout for locking ACPI mutex
Date: Wed,  3 Dec 2025 16:22:05 +0100
Message-ID: <20251203152445.235908008@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Copeland <ben.copeland@linaro.org>

[ Upstream commit 584d55be66ef151e6ef9ccb3dcbc0a2155559be1 ]

Some motherboards require more time to acquire the ACPI mutex,
causing "Failed to acquire mutex" messages to appear in the kernel log.
Increase the timeout from 500ms to 800ms to accommodate these cases.

Signed-off-by: Ben Copeland <ben.copeland@linaro.org>
Signed-off-by: Eugene Shalygin <eugene.shalygin@gmail.com>
Link: https://lore.kernel.org/r/20250923192935.11339-3-eugene.shalygin@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus-ec-sensors.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index 6f20b55f41f2e..c9222c83ba240 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -49,7 +49,7 @@ static char *mutex_path_override;
  */
 #define ASUS_EC_MAX_BANK	3
 
-#define ACPI_LOCK_DELAY_MS	500
+#define ACPI_LOCK_DELAY_MS	800
 
 /* ACPI mutex for locking access to the EC for the firmware */
 #define ASUS_HW_ACCESS_MUTEX_ASMX	"\\AMW0.ASMX"
-- 
2.51.0



