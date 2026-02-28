Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A89338939
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301757; cv=none; b=VC2/ZlZ9J1JlEHnZnaOMTVTbHqOsYeuViReiD+x5PwjYMCdQo2UzRg0ZgdjvrM9dZ0s7zWVunbmu3zNI0JKHoxPBzZAA1eTddECyN7Ngdmz0ueuE0JCvhpYNHADnJOHx/Vy1hRIDDice1u3uDmHLc7ALSNk3jytRU1MFueEMbsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301757; c=relaxed/simple;
	bh=Sbf8o6sxdGgr3Lg0e7m4Iaix68OwH5KXkbzj7l3H+ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMk798/pZ/XVOtXW0eyCUi5XDUxD2bh3yCIq5p0UlffYDqzYMHV8Y1o0/IHyhL/o64870W0UD4ke+254+64fftcljG8mbJfLlF2d1XM9tu+47N8ub8q6yWfPXEu8/JQ8GEMVeD4Tr9Gk6FocQQy3tNVSkze3hrGt9I7vBGX7oHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IOAdav3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IOAdav3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F39AC19425;
	Sat, 28 Feb 2026 18:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301757;
	bh=Sbf8o6sxdGgr3Lg0e7m4Iaix68OwH5KXkbzj7l3H+ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IOAdav3LM1aeAm7a68rONuiCtx+B3AU3VYqWJEI1Znhu9GbJ5CVG+Slc5cvy1YD2w
	 akuJVU/a4A/J0VEgN/LCOkwUimtRpMwDla1nGn/r3X5VhGqFuAk7wdY5fHG4iKmYiv
	 vE8ZmaEA+pRQd9ScweJTZDgY4e1tdFY57JYI9Ayx+0+Z2S/dZBEs52JL+PD5A3u3VK
	 Hem5IfX2NxV5/UAHFZIVeu4vjNv3sniAPUMR9BIlaVTnqR8B8ypXuXqCdN+vweWrLM
	 74elY0Mzeab96H9GPZD+m3V1j2Mm6Ibs8fVjAfvbAGvcnvad7O5jG4RG3LT4RfB0qD
	 F8yP7vOWLSh6g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 161/385] platform/chrome: cros_typec_switch: Don't touch struct fwnode_handle::dev
Date: Sat, 28 Feb 2026 12:56:23 -0500
Message-ID: <20260228180011.1568201-161-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 07a19386dc4ee..b50e4651c6470 100644
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

