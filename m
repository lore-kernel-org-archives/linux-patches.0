Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031557;
	b=RE8E2brlGspN3UOkf2uAMjxeWvBHJRPP88Uek0xtaKkiN5fs5mvUjV2IEluy5T6ppaOd
	 oMBtyotW+t5+B5Qb7EL85nu7HmrdLyD+JzlWINt1wwjvgtZirYwhpAJKAx/MbxhjRkhwD
	 m7QTeTfPx2xdab70NxusTtRP7hOqnBrFq9VwnBoWp8DkFNnsdZTEjmfOUf6sat6+edktQ
	 PbuX3CIsYYKjdXViikXelYgt8rN7D9w5OcDsi/E5Rrn3Z5+Pf6veFdHMSsbTVs8IjKFFF
	 D6OZiA+dQUeS6xb2CWEh3fSuTpOMWeUByMA339RSA1MPbFXUdd3K05lbvWxeEVkqACA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031557;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9Z8kQ22obWqzjVOR6P5M1HIh+b6SwLXH5083eGC9a9w=;
	b=RHVyP7L6/CKzwd5mQiC6GphAtndPDoODAavkJYL0E9eIF8rSMNDU0kZs6xSvYfhiSiQy
	 9jcnQxcdiBW+xlxvSlgbCejDynaRkthKvkFRrmoCU042MsjW90y6KaDytjxRhgrWZKt+5
	 pyK/+u2VVqEsQPe+mVt1penViu3iye1MYERcbshakfatSR1s7MUg62simoWMudVwoX4TT
	 3jVD4a3aDZ1NvJ+MkmCfFOA6+l+OVfmYsE6n9JZo9bKiBDLPs/tTQsnmHI+wefQG1eFN1
	 xelL78yT4DlsMblrfevGXI72eWd9iO6nlBqtc/eqmF0ZxWfc9G0pGP5C3yVjXNKTBbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rr30Ev4M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA70606A320;
	Wed, 18 Nov 2026 19:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rr30Ev4M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D1F1F000C4;
	Wed, 18 Nov 2026 19:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031557;
	bh=9Z8kQ22obWqzjVOR6P5M1HIh+b6SwLXH5083eGC9a9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rr30Ev4MB3vmkmYRtDCYbOCwl7qvnRX9qqNEq3lRzY2idXsE1JgWd25oX12v8/Yad
	 mJ6BgHsUQS9db4E7GjwFPRsnLZkzz3nE0VpSiTOQBpyS4GU4I/IbymiXb1nsEthCRE
	 vyUNt5YZ9KpW5SCstWc2cxexqdiJ6U4ovocBSFGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1098/1756] platform/x86/amd/pmc: clear devm-managed pointers on remove to prevent stale reuse
Date: Wed, 18 Nov 2026 15:53:45 +0100
Message-ID: <20261118150053.916387387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit c9ba86f5411730ebd333d94b9e1aa8f652dc743f ]

The driver stores its state in a single file-scope static struct
amd_pmc_dev, which is reused on every bind. Its regbase, smu_virt_addr,
stb_virt_addr and fch_virt_addr members are MMIO mappings created with
devm_ioremap().

On unbind the driver core unmaps these mappings, but it does not clear
the pointers in the static struct. Since the struct is not freed, the
members keep pointing at the now-unmapped addresses.

On the next bind, the probe path re-maps a region only when its pointer
is still NULL, so the stale pointer is reused and the following
memcpy_fromio()/ioread32() touches freed MMIO, causing use-after-unmap
crash. Clear these pointers in amd_pmc_remove() so the next probe re-maps
them instead of reusing stale ones.

Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Fixes: 156ec4731cb22b ("platform/x86: amd-pmc: Add AMD platform support for S2Idle")
Link: https://patch.msgid.link/20260929155609.1712638-1-Shyam-sundar.S-k@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc/pmc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/amd/pmc/pmc.c b/drivers/platform/x86/amd/pmc/pmc.c
index a442d37ad828c..80dcb469d9f2b 100644
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -962,6 +962,10 @@ static void amd_pmc_remove(struct platform_device *pdev)
 	pci_dev_put(dev->rdev);
 	if (IS_ENABLED(CONFIG_AMD_MP2_STB))
 		amd_mp2_stb_deinit(dev);
+	dev->regbase = NULL;
+	dev->smu_virt_addr = NULL;
+	dev->stb_virt_addr = NULL;
+	dev->fch_virt_addr = NULL;
 }
 
 static const struct acpi_device_id amd_pmc_acpi_ids[] = {
-- 
2.53.0



