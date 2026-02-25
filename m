Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67A92C3254;
	Wed, 25 Feb 2026 01:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983956; cv=none; b=EmYVUd2+34vfVia3fsj7DgWgXVBSCbfWNkY+2aMICZeZnGfq8F0Vw3cUgkd+Em7FtPCFzLzOdL/lGSBdkGVkAb/soq61IxhafWKruMEQlEw5+wCru/o7ed+P1JPcRuUAuLXR6vCve9pduS8htATKmBcDSIq2WWMoYUXtCtPEFiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983956; c=relaxed/simple;
	bh=0IvimZMHDeHZH8BnnQvrrU9AEKvElt/qTFlEufIjh2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pYXKnRLk/uS2f/lu2tKHvHFY79v7/Gim31FuSRqPGpdrLNdQh5x0xfDAqPYRWcnH+znMUcXrW1xAMvW4rLDXYGV2jtILT7caGB926Ere6SlgbQ03QwDxJSi6somfWEb5JxkUThTmYpxlj9ZtJ2tRVhEDjl8zhrZJGLb1rlGgDtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ulbs7oeC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ulbs7oeC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89456C19423;
	Wed, 25 Feb 2026 01:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983955;
	bh=0IvimZMHDeHZH8BnnQvrrU9AEKvElt/qTFlEufIjh2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ulbs7oeCgqC+ecPDkz8EnJzXzYX4GxmSotoJqT3fq758kzsYqOlCeIoB4lMI1J9ZV
	 Ga4YSMgHteFAr/ySRwXM4ia63ONaYqb+PWwoghjG1S4mDD3es95ZVR5YqorWPE/vmG
	 Y283gS3tDmrow20gkFdWytfK8HS2NFyNGdhO9h7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 214/641] platform/chrome: cros_typec_switch: Dont touch struct fwnode_handle::dev
Date: Tue, 24 Feb 2026 17:19:00 -0800
Message-ID: <20260225012354.124661522@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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



