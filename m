Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043788;
	b=eezMbgGEnd7N4+oy6oybTHeCj/uNIto/sFX9yvtV0oFyYFuFbKvidrVRib+Kn4os1nVq
	 BZLzJTFjmZld9gSwFbEUjLpfxNnkb5Yb/Pl6XZRn0OvUvFX0CjOLpTVhZgIjMetEx6BTy
	 VtVON5CJjanutFnBttVimuSQhD6vEn7SZhbUeg7CTmjWHLT26soEbYcUxCiDdhzDvrzdr
	 0QoQAWIV7qHXG/ePXQqoEG5JQT0cgT5DHSyOSPXq/ksQKZ5R3oOWmsW79xvLtUNJ+C54u
	 M64ekaMvvaKabooSNv7hz9f3SjmSZtHCf96JbtJfVHk4rp8D6RkArUQeRi7dgq1Wq3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dxMLD+TLg2lb4n4MpACTIOB3sg9dzW0nVfhZ3xx+Y98=;
	b=yZK231fKHWRyjfyqGr7jF9q5eZongzvPTQjKrNgzmVXW6xRaQJROIyNTbTHc89VXKwQy
	 qabhio0NkteOvu6OSSV3IVmpzqAOYVtv9qAWhWQ3/CX2KzaiYAcKYwcMHpDMbxw/VHLhT
	 smD1c+xkpYJrcxCFWAYa6LytRTvwlhoEgNuei4CNYAMHXz2G/lMx3BFnRdg6hTFySCt/x
	 +Nkiq4xMBYTNTC+PDQM2d8NqrHvduq1fFZVEsn04HPQbdTfoTajUTNGG4vYOxVt8W90Mc
	 OIUczq2CtQkxd7SOJwQvvpYnAj9kkMwKcQRK49a3xtUPvv32xQ+9KUzEKu/aZQscCdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ugQK/+V+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2263E606A320;
	Wed, 18 Nov 2026 23:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ugQK/+V+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748131F000C4;
	Wed, 18 Nov 2026 23:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043788;
	bh=dxMLD+TLg2lb4n4MpACTIOB3sg9dzW0nVfhZ3xx+Y98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ugQK/+V+B2tZsUnHMjpA55vly/TsP13OU1Y2aAKzciYP19jErBZQr317uZNHg9ZER
	 /HJBfNp39bwD78LuwUh/VK7LWNrIUZk6wLAvzsuFEjchyV4LvdBUvk9bwN7efQctyM
	 8wDl0stSb15c03xQBghWJaeAJIsUBJHItvTW/k64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0336/2857] PCI/AER: Emit TLP Log only for unmasked errors
Date: Wed, 18 Nov 2026 15:22:50 +0100
Message-ID: <20261118150213.536612912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Wunner <lukas@wunner.de>

[ Upstream commit a8bf2dd750de7d682fdaa2127f4e3217ce9c4a82 ]

Per PCIe r7.0 sec 6.2.5, the prefix and header of an offending TLP is only
recorded for unmasked Uncorrectable Errors.  Yet when the AER driver
determines whether a prefix and header has been logged, it does not take
the Uncorrectable Error Mask Register into account.  Fix it.

Fixes: 6c2b374d7485 ("PCI-Express AER implemetation: AER core and aerdriver")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org # v2.6.19+
Link: https://patch.msgid.link/2e712b96ba5bfc729d78bfc23f7fb7d285aa3d6d.1784905909.git.lukas@wunner.de
[ sashal: Inlined the TLP-log masking check (& ~mask) in cper_print_aer() and aer_get_device_error_info() because the tlp_header_logged() helper and the pci_print_aer() hunk don't exist here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 37832d4168cfb..08e7f918f71b5 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -779,7 +779,7 @@ void cper_print_aer(struct pci_dev *dev, int aer_severity,
 	} else {
 		status = aer->uncor_status;
 		mask = aer->uncor_mask;
-		tlp_header_valid = status & AER_LOG_TLP_MASKS;
+		tlp_header_valid = status & ~mask & AER_LOG_TLP_MASKS;
 	}
 
 	layer = AER_GET_LAYER_ERROR(aer_severity, status);
@@ -1087,7 +1087,7 @@ int aer_get_device_error_info(struct pci_dev *dev, struct aer_err_info *info)
 		pci_read_config_dword(dev, aer + PCI_ERR_CAP, &temp);
 		info->first_error = PCI_ERR_CAP_FEP(temp);
 
-		if (info->status & AER_LOG_TLP_MASKS) {
+		if (info->status & ~info->mask & AER_LOG_TLP_MASKS) {
 			info->tlp_header_valid = 1;
 			pci_read_config_dword(dev,
 				aer + PCI_ERR_HEADER_LOG, &info->tlp.dw0);
-- 
2.53.0



