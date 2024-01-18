Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D67D41774B;
	Thu, 18 Jan 2024 10:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575357; cv=none; b=QhX1xemhak87xk8e6hUVQ7DpygohsmXlwmzk11D58xVh4VOsN/TQsNLXYbmnjWp5uDneE4PGbodSxtJGlPRX0ZyhFFcJnXW2krSHiYkZ7qCTEJVI68oaibSvTj0MgE4i1EAN6Ltd2khiMj14TEBzSJjSvoBkZ/79S1x+NnsJ0Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575357; c=relaxed/simple;
	bh=UTvOIYlG305LorknjCX84HniwDVYdfliigTvCS81uyY=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Type:
	 Content-Transfer-Encoding; b=uT5frW/KCM2E/fDXLOBCbIxGtZ9GZ5l+yxNnyUJscMOwrT+0mDVXbv2utaGgbpKmiPNIgx0ckYQxxSpaW9+D1j+BZ1+zg9udoVIWt68d5ajeeSBf8W45xV9PUsgTNdm470LPIEDb2gzyFsMJKdfDhrsnCUeEQIzryUNFiaW/YX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bUQ3HBqG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bUQ3HBqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADFDC433C7;
	Thu, 18 Jan 2024 10:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575357;
	bh=UTvOIYlG305LorknjCX84HniwDVYdfliigTvCS81uyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUQ3HBqGY34AhRLz3ac1ISwPdTmyLRk7omm8cL3B4RdNgdurH/bfZHvmXEAeSbxfx
	 q5fs/Bg6LF7mye8PEjdFtnXHjDNaN9EEMAIey8TFsMFvlkkv1FldmUF2Q2BykHE/Fp
	 V62CkXf8sXuEc9B7koh1nc4tqdrtUmUF9wyRGk6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/150] platform/x86/amd/pmc: Move keyboard wakeup disablement detection to pmc-quirks
Date: Thu, 18 Jan 2024 11:48:46 +0100
Message-ID: <20240118104324.869171863@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit b614a4bd73efeddc2b20d9e6deb6c2710373802b ]

Other platforms may need to disable keyboard wakeup besides Cezanne,
so move the detection into amd_pmc_quirks_init() where it may be applied
to multiple platforms.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20231212045006.97581-4-mario.limonciello@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc-quirks.c | 3 +++
 drivers/platform/x86/amd/pmc/pmc.c        | 2 +-
 drivers/platform/x86/amd/pmc/pmc.h        | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/amd/pmc/pmc-quirks.c b/drivers/platform/x86/amd/pmc/pmc-quirks.c
index 6bbffb081053..c32046dfa960 100644
--- a/drivers/platform/x86/amd/pmc/pmc-quirks.c
+++ b/drivers/platform/x86/amd/pmc/pmc-quirks.c
@@ -235,6 +235,9 @@ void amd_pmc_quirks_init(struct amd_pmc_dev *dev)
 {
 	const struct dmi_system_id *dmi_id;
 
+	if (dev->cpu_id == AMD_CPU_ID_CZN)
+		dev->disable_8042_wakeup = true;
+
 	dmi_id = dmi_first_match(fwbug_list);
 	if (!dmi_id)
 		return;
diff --git a/drivers/platform/x86/amd/pmc/pmc.c b/drivers/platform/x86/amd/pmc/pmc.c
index f28bee6854f4..96caf2221d87 100644
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -878,7 +878,7 @@ static int amd_pmc_suspend_handler(struct device *dev)
 {
 	struct amd_pmc_dev *pdev = dev_get_drvdata(dev);
 
-	if (pdev->cpu_id == AMD_CPU_ID_CZN && !disable_workarounds) {
+	if (pdev->disable_8042_wakeup && !disable_workarounds) {
 		int rc = amd_pmc_wa_irq1(pdev);
 
 		if (rc) {
diff --git a/drivers/platform/x86/amd/pmc/pmc.h b/drivers/platform/x86/amd/pmc/pmc.h
index a85c235247d3..b4794f118739 100644
--- a/drivers/platform/x86/amd/pmc/pmc.h
+++ b/drivers/platform/x86/amd/pmc/pmc.h
@@ -36,6 +36,7 @@ struct amd_pmc_dev {
 	struct mutex lock; /* generic mutex lock */
 	struct dentry *dbgfs_dir;
 	struct quirk_entry *quirks;
+	bool disable_8042_wakeup;
 };
 
 void amd_pmc_process_restore_quirks(struct amd_pmc_dev *dev);
-- 
2.43.0



