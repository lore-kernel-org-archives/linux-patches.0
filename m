Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067FC1E519;
	Mon, 10 Mar 2025 17:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626718; cv=none; b=V9fAMRxwKYtACQb8qgRDb+kqe2MixhhFRmmP7ncKZKP9PC3hxlBnUoCCjlTnht76cuaeA8m7GLfFyPteL4Nw2/+H27QiVOMbtvy54iJSkHWEa9ivDYXTnbxliHWjzfqtvIW61pj4tpvr7DT4PBUohu9PAHSEvuW/2FE6Zs8sCes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626718; c=relaxed/simple;
	bh=UPYWuaSx4CJecMOlOyEVJVv1eQQvQUU7kF4QHFi2Ix8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nnu66OWCm0CV2Zv5Roysy3M5dQNQVOl95mrVR/OM8idxYTd42AwYgtUo9FiCpkzlS/lde7Qc/TXjGASaBwUCXitE822k9988gs0GOSDHrRSlIcAAWUc3a0jJ96MJPqlbuHj+fzT+rEVvUeAF2kI4LGcLJqjDO1HmXKZdaLFASE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgrz/M1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgrz/M1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD0AC4CEE5;
	Mon, 10 Mar 2025 17:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626717;
	bh=UPYWuaSx4CJecMOlOyEVJVv1eQQvQUU7kF4QHFi2Ix8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgrz/M1ENnVmV84eaLoBGCXx/y5Z+I265bOFMxEcZwknkIK/zzPpVykJRbOMCmljT
	 +P9ga3/zvo6Cz/XGAH0aAQBawouSEn3WtAljtrGKqLCa7ec+/W2FGYPVkZ41BwkN11
	 Th6GO4ObaSMWyBOAskIxacw/b1eOMBiZotyoot6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Yu-Chun Lin <eleanor15x@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 089/207] HID: google: fix unused variable warning under !CONFIG_ACPI
Date: Mon, 10 Mar 2025 18:04:42 +0100
Message-ID: <20250310170451.296398727@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 0f292b5d3e26d..eb6fd2dc75d0a 100644
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



