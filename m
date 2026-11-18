Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026297;
	b=5ZxSqL+z9qhiCxvQ4YjjT1eQjv+LiyzsT3UbTWzYOzDEij6CKbrbKmduarFqZpSjJPj6
	 BZLg9poAKmZh8EcUcMqG8IYj4wC0DRwZm1QVrP8+OdcebAjQZunhiLGVZqSubyMGxNHJ9
	 ARJtwPOxvd78U9fmA653z1Jjs6mQSyuLUjJIT/8b7zQXOkQ7Q27RDyHwrxGgI3YEebAls
	 Dvcc6TNuUROZLIrEeyM8XNhVZz2+pyNYtBaplGHg7jdrH6T6VLNRgs8ex443CMG6aAmEH
	 3NISz4ftutgmp8JpNjbTArk9p/Dn9xj7xlLtdRA51uMzL0mJHhSiezYBCq7R69l6CVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026297;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=IUVALCE+avJ8e3319dhm8ydQ1857Pu9PJjyrL8eIzJ4=;
	b=01wi2VFEyMrHqantSF4i7fFBnKXoLOOVJ1B0JLypSipCKq4PSVcuu2QWHdv3RiLnT3pj
	 FIvy6QKSVCvp/1Pm1AodqC0+M7Sg58ABW/wWMlLfoKBxucBIgJtcwOBfXLFiueQQ47lWQ
	 XAa08qftXO2lk7N/kqjqgsP8U6EiU3vfoBnD2RXbMpwHaE6l/i6X748zKBp41Ebe41q7F
	 /cYg8kh2RZ17sesxTPH0et+6Mp3gnM3u+jtoe/x3iFiDoBojQulBZr/XTDhcT6iO1nmsk
	 Qa9BUdtDNzGVO3L0Sb5q3S8zh0paCXXk2BrPSB7/yR2O9FYnN0eL5r+JXt6l3aUhiqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TCxxTKoB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C610606A31C;
	Wed, 18 Nov 2026 18:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TCxxTKoB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C072B1F000C4;
	Wed, 18 Nov 2026 18:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026297;
	bh=IUVALCE+avJ8e3319dhm8ydQ1857Pu9PJjyrL8eIzJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TCxxTKoBy9YOcca19pPUurP2eJ8W/jRCxJtiZ6UNlkIJeUZb5jef/ulJW5FzqCx/W
	 +pmr6wnM/Dfxfmf/AOURAr2Tmct59PEgjRo0Vd4STaJ0sVFpBE6OgpqOaSY74sOqU9
	 Nu7UuLANwv29eTeC0QUG8v7FAqopboQBSTC92KNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1386/2151] platform/x86/amd/pmc: clear devm-managed pointers on remove to prevent stale reuse
Date: Wed, 18 Nov 2026 15:52:01 +0100
Message-ID: <20261118150212.495645327@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 8abb80e1803f9..5c05db31c96b3 100644
--- a/drivers/platform/x86/amd/pmc/pmc.c
+++ b/drivers/platform/x86/amd/pmc/pmc.c
@@ -884,6 +884,10 @@ static void amd_pmc_remove(struct platform_device *pdev)
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



