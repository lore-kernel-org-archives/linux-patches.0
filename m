Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABA336C9E0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302357; cv=none; b=H1gXrbsZugBmoXCIkNLrtnlLQOhDNxteEUCZYfD7RO3NV/kjzUtQ81rEkMR3x+TbDog8F95RJ6iDr9l+64OfTCeB10dHnplz+soGf44R8pZd4ln/8iNIc1x+qxXzlKq9eY42XOIKse9mtCQmTKC5J6+6OBanwrvG+78TbdjqwtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302357; c=relaxed/simple;
	bh=Xrsiq06DEMlmvxkoV79HsB8JppYa4yHA1n+6NeHaiD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJiA8rSQocaRUFpdHDYli/gLqnw928owiqDe4jvyws/UQrC/BmvxCXjSJ82fOhWva4At6wx7NYl++kuC0I7/Gg87iu5tO+mvZwxXln0tFjljzRn3muRJtNHl0kankpf/dy8iYpGNNBsSTPzXBuuhJ6lIC36Bwo7uYcl++pGgFQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tVMY2yte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tVMY2yte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE19BC116D0;
	Sat, 28 Feb 2026 18:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302357;
	bh=Xrsiq06DEMlmvxkoV79HsB8JppYa4yHA1n+6NeHaiD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tVMY2yteF35HoTECQOk1xGUxQ3F+T6ttM8+cj0GJ3lXlAatAmXiPeKd+pLID4RTE1
	 aTMRaIWIkglWYzNSF9N6yJUF6ad+j9kUpbcSJaJ0oVvxtaIgFvt/FhyyZ3utVvsS5g
	 IOgfCxsD0BKtlbtILu/syDmuUy4BUT0RVkBEYDHwaXgKsSxJtuZiAx7vjGMWxX0ZPf
	 wnXRRnD1Feyp5wHm4auaDQleek/cZMDBSCCMSVnlOXTEN5Ipfx/xoG8VaHcDRdGE8i
	 aame58b42PzurajJWknUYNwcI8RtEwzWnNJFhq9kryxreB08+NG2cTEsdR9RNzVfCD
	 CStcu4yngiayw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/232] platform/chrome: cros_typec_switch: Don't touch struct fwnode_handle::dev
Date: Sat, 28 Feb 2026 13:08:56 -0500
Message-ID: <20260228181127.1592657-83-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 26af51952f7f1..2b37e1b30aca0 100644
--- a/drivers/platform/chrome/cros_typec_switch.c
+++ b/drivers/platform/chrome/cros_typec_switch.c
@@ -225,20 +225,20 @@ static int cros_typec_register_switches(struct cros_typec_switch_data *sdata)
 
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

