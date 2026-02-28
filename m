Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE65359A70
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302399; cv=none; b=ls8AzOTu/DhUhpFfRO2lwdJm5I3kFEIK+nz4kXPGDLC+b/W3xKBX9TI4TJz+HwYTLtPnz10m5NIrWazREhaLlGI/rco/23CPvMBj5S+/laAdiOjpjTOHHcq5H5lcYnP1nMS/TbZbnXOYTxjkmowATCjwSIbLWJjiMdZ8DYhytg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302399; c=relaxed/simple;
	bh=ZeOAt1b4qKBQCvbUZW1ULGPQZdxulLEP56gXZhNIy6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gbe6Tw8jDnPoAY4iI90tfxmJkkJuhIBXUiWyFXuIKYzN7B2JWgpO8WGhZ/+h7A7HDI5HaRWWR7TICyimktvuxnzDrcv19dwJA70xSKNe/HPI2Gt71pRnmlAyjRGNIAaM3WFKpXvjN0VhNyViTcadrbMmuURRgWBgghh0dxXEoOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aFN7yd2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aFN7yd2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9D3C19423;
	Sat, 28 Feb 2026 18:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302399;
	bh=ZeOAt1b4qKBQCvbUZW1ULGPQZdxulLEP56gXZhNIy6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aFN7yd2fSnAg2VZGJcqRigmPCtHBtnnDFydcNpbjDLY2tbtsAStNwCAE2xUQEaUWQ
	 JMZAZUsvTv7DqKE6e9lutGclTzee24O8xKx9sEsO7Nn7gzNnSSwytYlQEjCOKfiBPd
	 LEFSswMCaO8wbKxcXz0AjdN+IxeGn1IdYh7O2oOf96U8P2j6a9CTOwxXWgf0F1kvNW
	 Y3FTAcx0OTuv6ntltmkl1S5MX/U9673q/3DoY0VsUdUl5GLzvkcCJb0oUW0o+dufGc
	 cTUfJFp5Bvl9RlYEiO/r+Cd2cBt/cg69jtiLfMCvk6LodiAPGMQ16a07fywL+loHb4
	 iUF4Xm6GBpXAw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hariprasad Kelam <hkelam@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/232] octeontx2-pf: Unregister devlink on probe failure
Date: Sat, 28 Feb 2026 13:09:42 -0500
Message-ID: <20260228181127.1592657-129-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit 943f3b8bfbf297cf74392b50a7108ce1fe4cbd8c ]

When probe fails after devlink registration, the missing devlink unregister
call causing a memory leak.

Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Link: https://patch.msgid.link/20260206182645.4032737-1-hkelam@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index c29cb56caf083..6f1da4296ad5e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -3027,6 +3027,7 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 err_pf_sriov_init:
+	otx2_unregister_dl(pf);
 	otx2_shutdown_tc(pf);
 err_mcam_flow_del:
 	otx2_mcam_flow_del(pf);
-- 
2.51.0

