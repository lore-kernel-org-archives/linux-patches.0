Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A4D25C6F9;
	Tue, 11 Mar 2025 15:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707489; cv=none; b=es8+txT99ezO7RbKBTj95SP7+cNMDkErKi560X+Lk4NuIuvpmOMaNGZSXA1JWw6jRzMR4aPMYC9esBkiSgxMFisv9q8mHpk7GjR0wiwUhVEX4uhqMQ7lCGBZj4QSDcJUoUnduJsVcgJ9baAtH+D+3IXPfHpFbibvhlYqLx0vG4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707489; c=relaxed/simple;
	bh=BbaLI/Wdzda8dR+AhNiFHrGMWyBvJI7HdvxxgXx/8So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agh7SVvzHttwvHNiKZvchmCf9XplvjrUcUbHRx0fswHnjB875z0e5AuAsUgpz7rjjAJrj3RTjRkx3A2K265IAJR9YopSbmtDgiXmdN/5jGBmaziusQOUH4VFfhpqXWI98o2mFhgtVGwmnQdjfkl+ZAQCDcAjPhsDAk4dJr1pU4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJhNH5ok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJhNH5ok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B0CC4CEE9;
	Tue, 11 Mar 2025 15:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707489;
	bh=BbaLI/Wdzda8dR+AhNiFHrGMWyBvJI7HdvxxgXx/8So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJhNH5ok7NGVm4/GX4ZgaFUBxwwKrMnXTfe5lZNJzfpF8b2D6vQfZsqsX6Y9RzIUx
	 WFAhFdsOmfHn2aalDVrfeYbw6AlkuotIK86nmtmWXeaINLJZbTd2oxhOND/9c83Hie
	 2qhz4x4KT7q4xZVaFpDfAVosu3k1Nmo/BypKAIoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Yu-Chun Lin <eleanor15x@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 406/462] HID: google: fix unused variable warning under !CONFIG_ACPI
Date: Tue, 11 Mar 2025 16:01:12 +0100
Message-ID: <20250311145814.371786690@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2f4c5b45d4096..b0df025c6abaf 100644
--- a/drivers/hid/hid-google-hammer.c
+++ b/drivers/hid/hid-google-hammer.c
@@ -266,11 +266,13 @@ static int cbas_ec_remove(struct platform_device *pdev)
 	return 0;
 }
 
+#ifdef CONFIG_ACPI
 static const struct acpi_device_id cbas_ec_acpi_ids[] = {
 	{ "GOOG000B", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(acpi, cbas_ec_acpi_ids);
+#endif
 
 static struct platform_driver cbas_ec_driver = {
 	.probe = cbas_ec_probe,
-- 
2.39.5



