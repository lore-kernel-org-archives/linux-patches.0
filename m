Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C2A432E94;
	Thu, 30 Jul 2026 14:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421771; cv=none; b=ITVuhfQ1eYjRpA5JhH7L34E90z+86IqHP9i5wvSsVU7ubmtSZuaYLrkXhM4zKYLZrfmo10Wdrx41+lBLvBaCZIA5lQDQDDErYBwKJX5zTDaxe8+ZG1tggLjM18LjY8rE9eBFg2xP88ofCvxAFsPVZiweBhprUYTD75Ww6PcXcaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421771; c=relaxed/simple;
	bh=tbDtRzuWMi5bGndr+VrjoExEkxAkRfFebbrF91O+Gj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a6gg/FV1shm/7aCR5oMQF0PaZT8c/AXj4ePuE0Ie8spIPPmxK9UNsE2RfsIRy3NwPqtzJgCwEKiRRvNsHjvxzUcfrdbuXAh05raZrM9pbIDnOooLLS8L87IAQ6jUctphWQuffozCsYNgWxlG0mu0dzcZFGfjcpO8wJoiSwL2zAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cboL7lys; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cboL7lys"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F0D1F000E9;
	Thu, 30 Jul 2026 14:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421769;
	bh=4IrIwrtd2ZAy7xRpM6TKYiQAyy0E0iy2vUheNSFqWjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cboL7lysKG4DhqKN6Fs0qNmztohGnN47mlKQnQ5DIwktTnIsxB8wmBNZZrRNPwOHx
	 muSVY9yNtl9N6E1spZlIlveB3fLYsDVtBJGF8XGvmj3nUYSv7jfZhTjkno4ndcPcyd
	 GH+GADoboVALeOQRhISTtX09BsGdXwbYOw0UYTnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig=20 ?= <u.kleine-koenig@baylibre.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>,
	Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: [PATCH 7.1 213/744] hwmon: Drop unused i2c driver_data
Date: Thu, 30 Jul 2026 16:08:06 +0200
Message-ID: <20260730141448.808639472@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>

[ Upstream commit b3de407ae66ffef6290a31363205e9751db0537a ]

The four drivers all don't make use of the value that was explicitly
assigned to the .driver_data member. Drop the assignment.

While touching these lines also make the assignments use named
initializers and drop a comma after the end-of-list marker.

Signed-off-by: Uwe Kleine-König (The Capable Hub) <u.kleine-koenig@baylibre.com>
Reviewed-by: Chris Packham <chris.packham@alliedtelesis.co.nz> # For
Link: https://lore.kernel.org/r/e8ceb3931975813545a8b478cc1a71b4ede9a6c0.1778688803.git.u.kleine-koenig@baylibre.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: af01dab0c39a ("hwmon: (pmbus/max34440) block unsupported VIN and IIN limit registers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm80.c          | 4 ++--
 drivers/hwmon/pmbus/aps-379.c | 4 ++--
 drivers/hwmon/pmbus/lt3074.c  | 4 ++--
 drivers/hwmon/tsc1641.c       | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/hwmon/lm80.c b/drivers/hwmon/lm80.c
index 63c7831bd3e11b..002c669182e153 100644
--- a/drivers/hwmon/lm80.c
+++ b/drivers/hwmon/lm80.c
@@ -622,8 +622,8 @@ static int lm80_probe(struct i2c_client *client)
  */
 
 static const struct i2c_device_id lm80_id[] = {
-	{ "lm80", 0 },
-	{ "lm96080", 1 },
+	{ "lm80" },
+	{ "lm96080" },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, lm80_id);
diff --git a/drivers/hwmon/pmbus/aps-379.c b/drivers/hwmon/pmbus/aps-379.c
index 7d46cd647e20aa..3ec0940ae56444 100644
--- a/drivers/hwmon/pmbus/aps-379.c
+++ b/drivers/hwmon/pmbus/aps-379.c
@@ -100,8 +100,8 @@ static struct pmbus_driver_info aps_379_info = {
 };
 
 static const struct i2c_device_id aps_379_id[] = {
-	{ "aps-379", 0 },
-	{},
+	{ .name = "aps-379" },
+	{ }
 };
 MODULE_DEVICE_TABLE(i2c, aps_379_id);
 
diff --git a/drivers/hwmon/pmbus/lt3074.c b/drivers/hwmon/pmbus/lt3074.c
index 3704dbe7b54ab8..ed932ddb4f77b6 100644
--- a/drivers/hwmon/pmbus/lt3074.c
+++ b/drivers/hwmon/pmbus/lt3074.c
@@ -95,8 +95,8 @@ static int lt3074_probe(struct i2c_client *client)
 }
 
 static const struct i2c_device_id lt3074_id[] = {
-	{ "lt3074", 0 },
-	{}
+	{ .name = "lt3074" },
+	{ }
 };
 MODULE_DEVICE_TABLE(i2c, lt3074_id);
 
diff --git a/drivers/hwmon/tsc1641.c b/drivers/hwmon/tsc1641.c
index 2b5d34bab146df..fc53cd5bb6e099 100644
--- a/drivers/hwmon/tsc1641.c
+++ b/drivers/hwmon/tsc1641.c
@@ -721,7 +721,7 @@ static int tsc1641_probe(struct i2c_client *client)
 }
 
 static const struct i2c_device_id tsc1641_id[] = {
-	{ "tsc1641", 0 },
+	{ .name = "tsc1641" },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, tsc1641_id);
-- 
2.53.0



