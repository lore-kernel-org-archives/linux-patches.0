Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0042D18DB2A;
	Wed, 25 Feb 2026 01:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983126; cv=none; b=XcxNo4fkk2xIHti8RPfMk33mFAZ6uaOqAALnViFCWMS7h8RrdxO1GkMhSPFKOImY3HahdmMA9+l+0vwZ/awyW9PXXKWca+4jJhalKwIVTNdg9qMwGHnhZh/HZG6D04lfgsSz6g3z0n1aJm1NtUGq9Lbt9g0CvtEoGqC+awh9kU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983126; c=relaxed/simple;
	bh=/c2rcONMPEWCwEEEOj+Z/oZkW3osiLsvbfnsUAJ7GJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhH0OIFwla7gcUPJa1RLEyBJBi5zmt2Ze1LI9TY0OIE4VHaSpY8k3zFg0zJ9YsTQZ2IfEoORkvmBjsCSy8XUIOF7kim0s/9QAmIK8SDckBh9+y3kUeq3I64N/dpHlraBvXKraXjLf0BhvaL7rS8Dpdd7/KfJ5kBasNl+649lQ+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6Z27AXn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6Z27AXn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CCDC116D0;
	Wed, 25 Feb 2026 01:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983125;
	bh=/c2rcONMPEWCwEEEOj+Z/oZkW3osiLsvbfnsUAJ7GJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6Z27AXnT7xf+S1MP79A+wiG7fyov1jXwhn/O+7J82yaOZD2/ArxHhynfWXi840vo
	 WJgmRSRGN0xjCvzw8WtF/lu5Tf8vLxVmyGr7EDbOddrbluSPgRAQZIjq40wzSJeTg7
	 RNwxgyWvXYKiXglGk+LRdVEgNq32kSHtRaiPcsps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 283/781] platform/chrome: cros_typec_switch: Dont touch struct fwnode_handle::dev
Date: Tue, 24 Feb 2026 17:16:32 -0800
Message-ID: <20260225012406.643347641@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 8d7c34abb0a12..d8a28d4e51a85 100644
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



