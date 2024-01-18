Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C34122323;
	Thu, 18 Jan 2024 10:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575354; cv=none; b=dNUI6UU13UIDBzXGUX2kloBaf9xiv/PzoaQ6yRj5MLG2RBsn3/13PoNx0lTa6wb+ckCfBAZ93AdfvTcKfA0G/SGDncSIl+Lr3z4ZNSKIgiJgw+kCX3PRhffvXDKHQsXNV+SW/R8qHxNoX8dkUHa1yWebOoQt6R7t/gXvdz2ABBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575354; c=relaxed/simple;
	bh=ft1u/8iaaphD6WpB62i8i2HIFry+EoLlyKDOmGz6NFg=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Type:
	 Content-Transfer-Encoding; b=GWcHGjhSnW6ZSNUQcijjOFjEMQ5TDTgjfDLxEYInpiLDBQG7IJPeHelm6SAcWnEaiCeUzrrhL2aGHIqYkRKainodnRGf15q34fyAFkA6jKAVQH3PrzexoQ58r+pCC01IBUit4UfujCAIAt/2NfpO8RnIV+pZZw6LK3bwcFSzuAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQHBO8GH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQHBO8GH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01904C433C7;
	Thu, 18 Jan 2024 10:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575354;
	bh=ft1u/8iaaphD6WpB62i8i2HIFry+EoLlyKDOmGz6NFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQHBO8GHmTr8rSsJqUy1PRVkmMGOHX3QwBGvn8HxcQ2raeU8quS5DazkGIXLMfFwY
	 UlzKpaFxYmS/a5woSgjBjItSaR7f0sDfjA5FQrv/7j/+02OBXfk/QzKm0XRJ+H6RDm
	 sIXWDd3iseVXPw48DJXiM84jKZVEfvhEJVb/MVfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/150] platform/x86/amd/pmc: Only run IRQ1 firmware version check on Cezanne
Date: Thu, 18 Jan 2024 11:48:45 +0100
Message-ID: <20240118104324.828218759@linuxfoundation.org>
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

[ Upstream commit 2d53c0ab61e62302d7b62d660fe76de2bff6bf45 ]

amd_pmc_wa_czn_irq1() only runs on Cezanne platforms currently but
may be extended to other platforms in the future.  Rename the function
and only check platform firmware version when it's called for a Cezanne
based platform.

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20231212045006.97581-3-mario.limonciello@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/amd/pmc/pmc.c b/drivers/platform/x86/amd/pmc/pmc.c
index 3fea32880ac8..f28bee6854f4 100644
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -704,19 +704,22 @@ static int amd_pmc_get_os_hint(struct amd_pmc_dev *dev)
 	return -EINVAL;
 }
 
-static int amd_pmc_czn_wa_irq1(struct amd_pmc_dev *pdev)
+static int amd_pmc_wa_irq1(struct amd_pmc_dev *pdev)
 {
 	struct device *d;
 	int rc;
 
-	if (!pdev->major) {
-		rc = amd_pmc_get_smu_version(pdev);
-		if (rc)
-			return rc;
-	}
+	/* cezanne platform firmware has a fix in 64.66.0 */
+	if (pdev->cpu_id == AMD_CPU_ID_CZN) {
+		if (!pdev->major) {
+			rc = amd_pmc_get_smu_version(pdev);
+			if (rc)
+				return rc;
+		}
 
-	if (pdev->major > 64 || (pdev->major == 64 && pdev->minor > 65))
-		return 0;
+		if (pdev->major > 64 || (pdev->major == 64 && pdev->minor > 65))
+			return 0;
+	}
 
 	d = bus_find_device_by_name(&serio_bus, NULL, "serio0");
 	if (!d)
@@ -876,7 +879,7 @@ static int amd_pmc_suspend_handler(struct device *dev)
 	struct amd_pmc_dev *pdev = dev_get_drvdata(dev);
 
 	if (pdev->cpu_id == AMD_CPU_ID_CZN && !disable_workarounds) {
-		int rc = amd_pmc_czn_wa_irq1(pdev);
+		int rc = amd_pmc_wa_irq1(pdev);
 
 		if (rc) {
 			dev_err(pdev->dev, "failed to adjust keyboard wakeup: %d\n", rc);
-- 
2.43.0



