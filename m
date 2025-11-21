Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3B43A291;
	Fri, 21 Nov 2025 13:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732390; cv=none; b=twq+Tp2MnntSxp/YMxkei02wr0vRHYUHQUyo/emJYT0L3GLNGskyXNtC0lDTf/v2HTbq7WbpeHZmjoSxEVImPhvW5KYh5Ij0OKtzxiO5jWcMmpaa/P0AnuyTgj97jGZfTqul1riRRtdXHCP4aKFMy4L2cPWbIt5+svIwsaC2bGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732390; c=relaxed/simple;
	bh=wL7RQPtdehHbUoHWzhqWCDFEOgHiev0oeZhdS/YCHik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmxtMwFAnYFyp2y0kVDLHms7tz9O1oM5Gd4b4N6/eXYpG4g7hZw3iFtf1rh0LVGuEjo3fg8Mm16G6w7XQjieqR70lapMnOmDtnQWYm+iLb564Ysp+H+PwWXzITUsxkUg65W7B4MC/nOaa3YsZCb21SJBhp77arawPFrRtmakqhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WdAIeV8B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WdAIeV8B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D13C4CEF1;
	Fri, 21 Nov 2025 13:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732390;
	bh=wL7RQPtdehHbUoHWzhqWCDFEOgHiev0oeZhdS/YCHik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WdAIeV8B7wSN2OTT8kDFYWzmaCjvB8ceARSqt3FnpNQVIPd4R0nm65Yuilr4brNI/
	 ISDsCQ/+nDKHs6yjgARfkbzx6eSMElSBZh3Lt4h9Sn002+TFX+IQOy9xx+7bpb2To+
	 HRw080UPbEw+UCCXj8FqQyz9i+p+uUSPG/OeW8js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Copeland <ben.copeland@linaro.org>,
	Eugene Shalygin <eugene.shalygin@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/529] hwmon: (asus-ec-sensors) increase timeout for locking ACPI mutex
Date: Fri, 21 Nov 2025 14:06:44 +0100
Message-ID: <20251121130234.760384523@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
index ce2f14a62754e..bc2197f1dfb7f 100644
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



