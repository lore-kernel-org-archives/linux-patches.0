Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF552253FE;
	Mon, 10 Mar 2025 17:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628381; cv=none; b=FlI+QZSFuJoZ8TKJ4ku8iyOZ79SYufevH7OLq2nLRhvI9eX4zNrg+UIZyGZmzTwAuxyyWWwAU8fGEly9MO/k2rC0HvFlwZx1MINWIjh0FYd2u94efF6Vo6nSchy8zisQh96S+vBQM1Q7rBk6Mz1QRLmftsjn6V3FAm84GNp1yvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628381; c=relaxed/simple;
	bh=RKReGMJJ+W6/5Go+KGSwbyZG7ruSJ8Bx5fYuC8UJZ9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A67A5OkXQ8wAFPvw7rAtHzTv0uDhvSjI4zu1bYD9g4PTeE4R7v1SwY8ZtlAtE5faixJi8eNb0xfJ8GP+/WrEaNqQ1mArsPlKPc86iwR9umxqgdnZoa0o5MoeMua6JnX3oT6ISQzuk0TZhqsdbF+9ZUiuYAw1ysYT7G9oQeI6o50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xMGxeA2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xMGxeA2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572EBC4CEE5;
	Mon, 10 Mar 2025 17:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628380;
	bh=RKReGMJJ+W6/5Go+KGSwbyZG7ruSJ8Bx5fYuC8UJZ9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xMGxeA2yYndNbHxW1VJqmQt4grUip2lm621/m0TQGBbT5bBYcVsRnLzcZPM1AskIE
	 iWT8DPY9Hlp2+n9w5ki09QVrD4TDwiXqoK/aCzVy44WgpUdSCs6Ni+vRCtZkIUqa1n
	 I+uAzUex1yYOmD9Riwiw+JBbW5fA8X3PGkV/KY68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Yu-Chun Lin <eleanor15x@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/109] HID: google: fix unused variable warning under !CONFIG_ACPI
Date: Mon, 10 Mar 2025 18:06:22 +0100
Message-ID: <20250310170429.076312033@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yu-Chun Lin <eleanor15x@gmail.com>

[ Upstream commit 4bd0725c09f377ffaf22b834241f6c050742e4fc ]

As reported by the kernel test robot, the following warning occurs:

>> drivers/hid/hid-google-hammer.c:261:36: warning: 'cbas_ec_acpi_ids' defined but not used [-Wunused-const-variable=]
     261 | static const struct acpi_device_id cbas_ec_acpi_ids[] = {
         |                                    ^~~~~~~~~~~~~~~~

The 'cbas_ec_acpi_ids' array is only used when CONFIG_ACPI is enabled.
Wrapping its definition and 'MODULE_DEVICE_TABLE' in '#ifdef CONFIG_ACPI'
prevents a compiler warning when ACPI is disabled.

Fixes: eb1aac4c8744f75 ("HID: google: add support tablet mode switch for Whiskers")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501201141.jctFH5eB-lkp@intel.com/
Signed-off-by: Yu-Chun Lin <eleanor15x@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-google-hammer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-google-hammer.c b/drivers/hid/hid-google-hammer.c
index c6bdb9c4ef3e0..d25291ed900d0 100644
--- a/drivers/hid/hid-google-hammer.c
+++ b/drivers/hid/hid-google-hammer.c
@@ -269,11 +269,13 @@ static int cbas_ec_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_ACPI
 static const struct acpi_device_id cbas_ec_acpi_ids[] = {
 	{ "GOOG000B", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, cbas_ec_acpi_ids);
+#endif
 
 #ifdef CONFIG_OF
 static const struct of_device_id cbas_ec_of_match[] = {
-- 
2.39.5



