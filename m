Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048481F5F6;
	Tue, 11 Nov 2025 01:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822987; cv=none; b=GiVk0OoNde6xGHleC2VL+rbClbtwzlAW4NgwFfG/z01pZJ0shy2+lEEkNIpxwATfSV5vY8z5XQ23EDCnfUCp/9+KdW1VFDP6zKB/rxupl998ffgmRDubYPfreu5+sqB7+yLYy43OhsC45Puf1HNwsu3lH29mLXmeFeVE+dVdEU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822987; c=relaxed/simple;
	bh=44u5x/2slogwcGhgfvKcsDSQYMlkJ5BsScGT8CoOj8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t506Qmafjrd/iaudPWmIYjprENOSf4qRYr614spRRPgbyGn1hC5Z0DpKkd5hDR8NdngkKIj4M9XLyJ4gYpC2L0kkHsV6TeccmCZhUu+MGqluM+q520vjLS28Uyjvuu3OuilND4dT+K4e1czwLcp+MmoJ+4kjOMN0kldj4H/qd6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9vqZTuI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9vqZTuI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847D3C2BC86;
	Tue, 11 Nov 2025 01:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822986;
	bh=44u5x/2slogwcGhgfvKcsDSQYMlkJ5BsScGT8CoOj8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K9vqZTuI1yBwaB17MM5TgiQ2FFbVNPG7mBMj58UwUDbRPZtkc7LTJk4CUchH4iq+R
	 krAj7rQ4TXet8EvtBUEG/QB/NZ9gpD3rmsUw6tP78XTLkVqwlz4Ndx8re1VhZF4rip
	 KFhQkLHlgCVu7r7QqLv4lzSHmTAKK6WcK2uH3RGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Copeland <ben.copeland@linaro.org>,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 209/849] hwmon: (asus-ec-sensors) increase timeout for locking ACPI mutex
Date: Tue, 11 Nov 2025 09:36:19 +0900
Message-ID: <20251111004541.495739086@linuxfoundation.org>
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
index f43efb80aabf3..94eb02e6be326 100644
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



