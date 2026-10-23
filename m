Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792773878;
	b=akjM66hp4xdZBgVmdq4CAndM9FrZ9+PlFcEa1zQF20qKH9/+KGschCXlxfFOqEfCUvZq
	 eKrEQYETq9K4K+TGoYVkVqHJo/HWQV0rkaiDOf1sL1/wj5+tpYA/dmoF0XT/Xj1EbiPyI
	 ug13rDWm7ZDsCn+97QTeHzlosvvjimeGhxKMhQ/Jc589set+vuuZwoKA9EN3Dp0/rATAw
	 JI6EwqKVu/2FGOjvsyjOWIECqd21ynLwhlf6JILsR7baI9OiKT5pNWqADidNQygzX9C5H
	 0JkqErweouUjldExHnkXZ0ykjFVdbzxTKwRGYVLF0XAS42ci31uhmES+vrGJmL2dcSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792773878;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bc+Hvb6ExZn7/bwQ3oc1bxytZQVNNrInVHWOjUuZvTY=;
	b=aiRfEgP5Mw8O7sQ/Y6rnB52+ClUj3Ga+2AzqEueL5tXN7+P1WLyjkhxGW2AAI72D8jtW
	 L+FWqUUQ0QjtZsdpcvyz64khfUqMDzVKNkUd5aayUc/fQDFiq2Z39BlaJzTTWhy+CNAZo
	 4rMTWYBWDosIJKbCXh8KgXARz/C0STVG6J0nIeTIOVU4pafaPcIA8827f4XEazo9r9x9J
	 Y63DGWjAUOIk6d18J/p9iFJV4Qp5dZq0YMlnKyiVpSlLxjVbDpwNzU8mLxIS8l74HAc/c
	 mdkcdyFDYf75TC1fD2DlvZ1Ru0NIB+JSN47+cgXEVCdBxf5jSXEC1rfsNTEv0ZjTFuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G8Zt145f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E91606A31A;
	Fri, 23 Oct 2026 16:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G8Zt145f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A3E1F01825;
	Fri, 23 Oct 2026 16:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792773877;
	bh=bc+Hvb6ExZn7/bwQ3oc1bxytZQVNNrInVHWOjUuZvTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G8Zt145fMRhtlzMtKuuRtB7bkLHGh426dTD1n6fkvVwTzX4FspdfXbqc3wwK/X694
	 q/XPb50hlduzWzwmku+UWMYpZ2/oYYFNrIiNDM5oFyxQ8oME4RUXAlnuhS06ROKMAz
	 MpcWesffrp7+E9jo+mpWmhUgZVnSxzlw5nQyR8Yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Bor=C5=AFvka?= <boruvka.marek@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 045/193] ASoC: amd: yc: disable MSI on resume
Date: Fri, 23 Oct 2026 18:35:22 +0200
Message-ID: <20261023163715.272306481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 1140ed1cbb3d1..b72b7ae1a2563 100644
--- a/sound/soc/amd/yc/pci-acp6x.c
+++ b/sound/soc/amd/yc/pci-acp6x.c
@@ -289,7 +289,7 @@ static int snd_acp6x_suspend(struct device *dev)
 	return ret;
 }
 
-static int snd_acp6x_resume(struct device *dev)
+static int snd_acp6x_runtime_resume(struct device *dev)
 {
 	struct acp6x_dev_data *adata;
 	int ret;
@@ -301,8 +301,42 @@ static int snd_acp6x_resume(struct device *dev)
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



