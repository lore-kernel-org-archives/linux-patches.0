Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774455;
	b=XLaiyrlnV55CyqIAhHom/jomJfl4Q2mmHFNEU/fuWN3G0aiFnOoan6sKf/o/3pPhLrov
	 aECkrtBAORbk9E2hNX7aF62xqjjLOgpeAQXz8+lfjbBGahwmW36gndM/vFgyRSJg7rK6N
	 P8v6eFeI/heqrtaYDuVuWao6jdxQrUdh5YWKgxo1cPFLMOPEgVrBLX9ocUqZ0IfTgfzCB
	 MT//yN60WLF9NT/yu+fhDlnLno5jY9GVOOL6bhKtOqZA5n4XdUtOnhOpLA4FjL1/9Kmj5
	 MY9Z19NicULQsGqERZUcS/cvSgEb7M5uNgZjpkvbnow/jplPi3TuTckXTTLJ1F0JoNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=pbBlKkJQyL/2eKvZBw0ZrBBhHPzZkUCHWUJua6JejHQ=;
	b=FZZALyya9jH7T84JVKadW0SkzvqgaokEeS+hcM8+GB3o843sNvSyrg3czHCJAzmTwpCT
	 bw6sO75+QPjY3QV65A76ImTalS09k+Tizd5HshzkMV9WMtMbwEVJf8bAILsYFulTG+EOM
	 nmySeFKjtbS0g1Zx01oOM4dLu/2rHH/ugHxdGqPN3nbLUA0FLeX9Y55LBTPNRz5wmLOuH
	 RK+N0aPHvZLVV0Uy4NPrVAnevw/Hss+SrEFqXCHfQlIQUPgyLh7g4BSiT21gVAGvt+vYR
	 /YwcfzUobx40Qak7TzX7J6Bvqn/q0anCjDK0B40n9KLTu+lPqW8D/mPpH9R+yU4xBvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xA5prZa7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D57A606A31A;
	Fri, 23 Oct 2026 16:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xA5prZa7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A9B1F01825;
	Fri, 23 Oct 2026 16:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774455;
	bh=pbBlKkJQyL/2eKvZBw0ZrBBhHPzZkUCHWUJua6JejHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xA5prZa7i1mxyren1S5Ne/qQjihX92YM+COjSMaUjFsob7yHX1r5HEj7L3Oj+Ptxc
	 HhZMQV/lRUrVHk5L55N69wvxidERy8RMJbi+TrspUXUW+5CuLkgiAu+rgM8p8rQtab
	 C+yxmWFsZceLx5vPeEOUPeHi9xa1sF/HM5T7708c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Bor=C5=AFvka?= <boruvka.marek@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 044/242] ASoC: amd: yc: disable MSI on resume
Date: Fri, 23 Oct 2026 18:38:06 +0200
Message-ID: <20261023163714.819365258@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 2a31b5378c6db9c4a8d399e5d10d32cd4b732bef ]

BIOS/firmware may re-enable MSI in PCI config space during system
resume even though this driver only uses legacy INTx interrupts. If MSI
is left enabled with stale address and data registers, the device can
write interrupts to a bogus address and cause an IOMMU IO_PAGE_FAULT.

Clear the MSI Enable bit before reinitializing ACP hardware on system
resume. Keep runtime resume separate because firmware does not restore
PCI configuration on that path.

Fixes: c8212df7bc0f ("ASoC: amd: add acp6x pci driver pm ops")
Reported-by: Marek Borůvka <boruvka.marek@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=222119
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20261013125425.3541206-1-mario.limonciello@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/pci-acp6x.c | 38 ++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/sound/soc/amd/yc/pci-acp6x.c b/sound/soc/amd/yc/pci-acp6x.c
index 671443204e046..bacbfc55c598b 100644
--- a/sound/soc/amd/yc/pci-acp6x.c
+++ b/sound/soc/amd/yc/pci-acp6x.c
@@ -301,7 +301,7 @@ static int snd_acp6x_suspend(struct device *dev)
 	return ret;
 }
 
-static int snd_acp6x_resume(struct device *dev)
+static int snd_acp6x_runtime_resume(struct device *dev)
 {
 	struct acp6x_dev_data *adata;
 	int ret;
@@ -313,8 +313,42 @@ static int snd_acp6x_resume(struct device *dev)
 	return ret;
 }
 
+static void acp6x_disable_msi_on_resume(struct pci_dev *pdev)
+{
+	u16 control;
+
+	if (!pdev->msi_cap)
+		return;
+
+	pci_read_config_word(pdev, pdev->msi_cap + PCI_MSI_FLAGS, &control);
+	if (control & PCI_MSI_FLAGS_ENABLE) {
+		dev_warn(&pdev->dev,
+			 "ACP: MSI unexpectedly enabled after resume (flags=0x%04x), disabling\n",
+			 control);
+		control &= ~PCI_MSI_FLAGS_ENABLE;
+		pci_write_config_word(pdev, pdev->msi_cap + PCI_MSI_FLAGS, control);
+	}
+}
+
+static int snd_acp6x_resume(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	/*
+	 * BIOS/firmware may re-enable MSI in PCI config space during
+	 * system resume even though this driver only uses legacy INTx
+	 * interrupts. If MSI is left enabled with stale address/data
+	 * registers, the device will write interrupts to a bogus address
+	 * causing IOMMU IO_PAGE_FAULT and interrupt delivery failure.
+	 * Explicitly clear the MSI Enable bit before reinitializing
+	 * the ACP hardware.
+	 */
+	acp6x_disable_msi_on_resume(pdev);
+	return snd_acp6x_runtime_resume(dev);
+}
+
 static const struct dev_pm_ops acp6x_pm = {
-	RUNTIME_PM_OPS(snd_acp6x_suspend, snd_acp6x_resume, NULL)
+	RUNTIME_PM_OPS(snd_acp6x_suspend, snd_acp6x_runtime_resume, NULL)
 	SYSTEM_SLEEP_PM_OPS(snd_acp6x_suspend, snd_acp6x_resume)
 };
 
-- 
2.53.0



