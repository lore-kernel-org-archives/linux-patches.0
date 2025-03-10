Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A311C5F1B;
	Mon, 10 Mar 2025 17:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627538; cv=none; b=FaiLPhE3VRgBIYY0d0s0sj0vJWNuUbYJh0/UfyAiZ97F8nVthIUUlxozX4EgqaG/1BspEr/6WrY0QBv3MAXYYd7T89Y4wqTgZ0FmQGQtewwiMgcZHU9wRO4Y1uVTxFOSHQtyGvtDhuVIYOj3o4WSn6IAdLHoltrUPO86LY1PbwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627538; c=relaxed/simple;
	bh=WrKPHqA2O1no9e5PYAHmymPBAONXJfOPf1IeqUdIluw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHXQIQTOXyipwtD3VPzjKTX31RqWQxSKfllfTlZQeUNuBQe4fNFNCUDFOSt8zpPkmfUXoPEUAtcPY2LZcMurtbww4LgFi8po0FASbgqLES3hgffqUn5hx8evgY6RzOHm37jUlzGcxVj+FN1zJUL5FD9AkjYUtXPy9lhkeXJu4xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XS8KKoUX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XS8KKoUX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98420C4CEE5;
	Mon, 10 Mar 2025 17:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627538;
	bh=WrKPHqA2O1no9e5PYAHmymPBAONXJfOPf1IeqUdIluw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XS8KKoUXcEmkbaivJVXTSlW69LeIqUs+Qkp99riL7ulYTB1cFlAd0hpeGVYAQxuXO
	 hyuNbwzITCWumxGIQnB/cpDIjrrdA9pi/8qFMu8dGoI19sIQElwhETyJOStMwh+L9W
	 PJR/zS9dm79SVm10StDhvJ+ypTxEOky05rLF6J78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Yu-Chun Lin <eleanor15x@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 146/269] HID: google: fix unused variable warning under !CONFIG_ACPI
Date: Mon, 10 Mar 2025 18:04:59 +0100
Message-ID: <20250310170503.536553520@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 22683ec819aac..646ba5b92e0b2 100644
--- a/drivers/hid/hid-google-hammer.c
+++ b/drivers/hid/hid-google-hammer.c
@@ -268,11 +268,13 @@ static void cbas_ec_remove(struct platform_device *pdev)
 	mutex_unlock(&cbas_ec_reglock);
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



