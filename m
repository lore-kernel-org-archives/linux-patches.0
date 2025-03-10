Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F371BBBFD;
	Mon, 10 Mar 2025 18:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630845; cv=none; b=VR/YiZbGYpO4w+E7Fh4YCMw/+yNIB6alWe7l3JgiiRQchE4w01Ns0yigj/1s48hjkTXJWBwCfHbyOfIhl1B/q7DjA6YQ4zEvgFQ2X90xcFNvhnS/dOpPbt+sIzfrDf8r2otvp1lfiv1ew1b9sxhG5DvygPieF14jza+CCcq7tRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630845; c=relaxed/simple;
	bh=QOudwY9eaw2R3WAr8181oqSYMJDb6QSy8T3ykxNqlf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUlT+6uJAUeqLsDVXC4cDdHiYyHO4SJdF1+CoIzT92dp2rQP19Wu+D+01VB78rjJqMqH1/JENddR2DKUx0rTUgherP26JWvGdro53BaUl3zOofrdEFKTWOzSB2v4RL+lr+uiwIkBT27TIAv8wPPLXDg5mmYaU2CHngTjbpYnKRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/mNPnO8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/mNPnO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAEFC4CEE5;
	Mon, 10 Mar 2025 18:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630844;
	bh=QOudwY9eaw2R3WAr8181oqSYMJDb6QSy8T3ykxNqlf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/mNPnO8DcP5YYiKoO4DMhDoe4wu/tuAe72CaYuQoH+DglGobmg6QNNiLM9RUTPik
	 jAW0eKI4a7mIpckCcgG+YP+ChIIEOkpN4Yhy5T6e1/qE0lzZyQ/adCf6rG7sN8yxdD
	 u0+OznDNxZBe16rS2z25ifib1tOUlak063Eyftw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Yu-Chun Lin <eleanor15x@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 553/620] HID: google: fix unused variable warning under !CONFIG_ACPI
Date: Mon, 10 Mar 2025 18:06:39 +0100
Message-ID: <20250310170607.372711575@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6a227e07f8943..5f20925bdc21f 100644
--- a/drivers/hid/hid-google-hammer.c
+++ b/drivers/hid/hid-google-hammer.c
@@ -267,11 +267,13 @@ static int cbas_ec_remove(struct platform_device *pdev)
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



