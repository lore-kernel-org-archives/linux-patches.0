Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901E8383C66
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302108; cv=none; b=GKDXbgXN/SQZWEAP83tcsWZJLGSnz0C+aHFm8l6/hVy3HB1tsyxtMnfs7+rMfVVMe4Sx/ii+MGNmyeVEjonidlnUtodKY8HlBQqfLxGTGzNc/5wlpC6I+edhBv61kB2145gtZfUxB1pv/aZcRqrOdWYOhAtgWjwlNYimEiM1yN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302108; c=relaxed/simple;
	bh=xJ3E2p3R66x/vmggAk8kZPX2t/iLPocEqolBtaFnLAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYx+PLrXPk6tjQjhOW9cXv5VwVzwubphyCK7kcxgFomGzExAoVOTdb/kvO56VN5F0YWBs+fJpnKFx71D9YGIK96DJJf43KD8cFosfwIcUlHA4Vo2ZXsxpCh3Nzsx8wiHH6sH/NlrFQ1yeo30b0ySp8PhC4UATO6wLdSEL9Jhr5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l+3AK36q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l+3AK36q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFAAFC19423;
	Sat, 28 Feb 2026 18:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302108;
	bh=xJ3E2p3R66x/vmggAk8kZPX2t/iLPocEqolBtaFnLAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+3AK36qfcYsN7nIZT8Wh68+Xw96HwsaUmbDTDIDxRE/kugdoENotIHOES9aEJr4Z
	 5PsgAShDnf23GvIz1cOIuxtvVw7hZKz85XJV6NPQ5p9m6GzaqP86McchbFAPtoJG3X
	 sGLHpAawIGJm0ixf0c3a8Qqy6DROP6XAz2PG8RWyp8TEiON3GEY13uJO9GUehSDA5C
	 w76UynlhCHtc49Jx402nwAN52a/RQvWzTUlKAGE4qo43snm5jwOcOXhZk/asnQeP4U
	 oYG9uAflC3uftC6CaGegwuiVOzQW83RlZyMrY98VeksLhOObH3AcBM/VxFM+3BKgpw
	 r/h820MGPsLhQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/283] platform/chrome: cros_typec_switch: Don't touch struct fwnode_handle::dev
Date: Sat, 28 Feb 2026 13:03:58 -0500
Message-ID: <20260228180709.1583486-96-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit e1adf48853bc715f4deea074932aa1c44eb7abea ]

The 'dev' field in struct fwnode is special and related to device links,
There no driver should use it for printing messages. Fix incorrect use
of private field.

Fixes: affc804c44c8 ("platform/chrome: cros_typec_switch: Add switch driver")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20260120131413.1697891-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_typec_switch.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/chrome/cros_typec_switch.c b/drivers/platform/chrome/cros_typec_switch.c
index 0eefdcf14d63f..28080f48315dc 100644
--- a/drivers/platform/chrome/cros_typec_switch.c
+++ b/drivers/platform/chrome/cros_typec_switch.c
@@ -230,20 +230,20 @@ static int cros_typec_register_switches(struct cros_typec_switch_data *sdata)
 
 		adev = to_acpi_device_node(fwnode);
 		if (!adev) {
-			dev_err(fwnode->dev, "Couldn't get ACPI device handle\n");
+			dev_err(dev, "Couldn't get ACPI device handle for %pfwP\n", fwnode);
 			ret = -ENODEV;
 			goto err_switch;
 		}
 
 		ret = acpi_evaluate_integer(adev->handle, "_ADR", NULL, &index);
 		if (ACPI_FAILURE(ret)) {
-			dev_err(fwnode->dev, "_ADR wasn't evaluated\n");
+			dev_err(dev, "_ADR wasn't evaluated for %pfwP\n", fwnode);
 			ret = -ENODATA;
 			goto err_switch;
 		}
 
 		if (index >= EC_USB_PD_MAX_PORTS) {
-			dev_err(fwnode->dev, "Invalid port index number: %llu\n", index);
+			dev_err(dev, "%pfwP: Invalid port index number: %llu\n", fwnode, index);
 			ret = -EINVAL;
 			goto err_switch;
 		}
-- 
2.51.0

