Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016309;
	b=zraPBTxlSkAcxxOpMJ/7GEqR7nWFKF4KX9QtwHocyQwbC/efaroFMMRC2sFnMtb9hKky
	 wtnG2/E98otxQiz67rGRmh0cT+qD2vXb7h8Wc6XOcq90faVEj0/t95cbdnpzGJfESTclp
	 Ioytg6Rz71Lh93EJpCa798z0jtzKoCKzv892t1vvpTADZrAJ863ekZXxxVCZIAQaw3x1/
	 5b4XjCAEb+TPy2Do37h9CZ3LsVS7uvay/tnWJGmKtxe+t1zfH6UX7CFij2COL4v7JzSwN
	 PCbNv8s+BB4Oqvcu51YcdrzzD7nY24BK8npJ8Mk4+XN0Ou2V8DyMjThibSfO1eSqM4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016309;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HN9Ms+Hdt7GFxVdUUDsBYlpia4blQ66Ny2UpH3ygYPU=;
	b=NpfYqM29fbzDwaUcXUa5u4YMU7gQX0G52UB8+gfX3WwH2c+ATzJBNEfZuYM335cbkP05
	 s3nNd6d/3gpdNwUro2q1ivncOgvneKL3eWSnAhze8PlHRX58XQXhieAyZE5CBZizChwKV
	 8XLLJR4O9hlbxjd9t2IfKQ4prQUMgZ/beBSu52fiHxOPleGfaFchDQuRrOQx4y76GmNap
	 xBaOXSWm67c7iCxz71e7ga0qtyhjb7ffxe4CY81pXinfjggYOofmdSZ2m2uHNt2cSBE0S
	 Ws0AUWZmy2M9MJOI5Rzenlw83fvS2FXRELoKlvJdoXwSaRZjiJdxgzwXq4dvRgBW/7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PDLYt3kX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5CC60A2616;
	Wed, 18 Nov 2026 15:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PDLYt3kX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6181F000C4;
	Wed, 18 Nov 2026 15:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016309;
	bh=HN9Ms+Hdt7GFxVdUUDsBYlpia4blQ66Ny2UpH3ygYPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PDLYt3kXj3eYw/Yq2AsICJqL/GFdckX/RX3sQ9BjrMmn41jlOgNv0QVFwDgkdiS2s
	 u0UXkpEJWRk/fwNV5Li0ZNnOrR2oIJ8PsUI1+BUzlomowEWaf9P6rzy2qiHWVqEPbw
	 Kxt+oyUpVgSrBP1Wl8mG34dB32qs73jgXScLsmLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0484/2651] platform/x86/intel/vsec: reset state before re-enumerating
Date: Wed, 18 Nov 2026 15:28:44 +0100
Message-ID: <20261118150305.204688292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit ee26050614d02397eb743854d718689dcaf1889b ]

The change referenced by the Fixes tag split the VSEC enumeration logic
out of intel_vsec_pci_probe() and made PCIe error recovery call
intel_vsec_pci_init() directly. This avoids another pcim_enable_device()
devm action and another devm allocation during slot reset, but it also
means that error recovery reuses the priv structure allocated by probe.

On the initial probe, priv is zeroed by devm_kzalloc(), so state[],
suppliers[] and found_caps start from their initial values. During slot
reset, the existing aux devices are removed before re-enumerating, but
the reused priv still records the old devices as registered and the old
capabilities as found.

The next intel_vsec_pci_init() call can therefore short-circuit in
intel_vsec_register_device() with -EEXIST, or stop early because
found_caps already matches info->caps. The aux devices removed during
slot reset are then not recreated, leaving VSEC functionality missing
after PCIe error recovery.

Reset the VSEC registration state after removing the old aux devices and
before re-enumerating them.

Fixes: 348ccc754d89 ("platform/x86/intel/vsec: Fix enable_cnt imbalance on PCIe error recovery")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260708032647.712412-1-lgs201920130244@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/vsec.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/platform/x86/intel/vsec.c b/drivers/platform/x86/intel/vsec.c
index 7d51f27f09bc9..eea63c170ac43 100644
--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -51,6 +51,13 @@ struct vsec_priv {
 	unsigned long found_caps;
 };
 
+static void intel_vsec_reset_state(struct vsec_priv *priv)
+{
+	memset(priv->suppliers, 0, sizeof(priv->suppliers));
+	memset(priv->state, 0, sizeof(priv->state));
+	priv->found_caps = 0;
+}
+
 static const char *intel_vsec_name(enum intel_vsec_id id)
 {
 	switch (id) {
@@ -857,6 +864,7 @@ static pci_ers_result_t intel_vsec_pci_slot_reset(struct pci_dev *pdev)
 {
 	struct intel_vsec_device *intel_vsec_dev;
 	pci_ers_result_t status = PCI_ERS_RESULT_DISCONNECT;
+	struct vsec_priv *priv = pci_get_drvdata(pdev);
 	unsigned long index;
 
 	dev_info(&pdev->dev, "Resetting PCI slot\n");
@@ -877,6 +885,13 @@ static pci_ers_result_t intel_vsec_pci_slot_reset(struct pci_dev *pdev)
 		devm_release_action(&pdev->dev, intel_vsec_remove_aux,
 				    &intel_vsec_dev->auxdev);
 	}
+
+	/*
+	 * intel_vsec_pci_init() reuses priv. Reset the registration state
+	 * after tearing down old aux devices or the rewalk will skip them as
+	 * already registered.
+	 */
+	intel_vsec_reset_state(priv);
 	pci_restore_state(pdev);
 	intel_vsec_pci_init(pdev);
 
-- 
2.53.0



