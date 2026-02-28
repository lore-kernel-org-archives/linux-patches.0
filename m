Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE0C33F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301134; cv=none; b=HjAVXkxyTWPbckTUA5GYApwAqOSa+u3nDrzHr5TPM4FqEeozw5ebWt3nUmGQyGvAnVgW0i0OhLHhoQtJxPfwkmKJbHEFxbYwfbiNLh9p79GkGJz8elqhseEZXi9rc+xqvWmneODrVu36MAiKjQUNnDoqJjtBhID1PW/QE8zGCH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301134; c=relaxed/simple;
	bh=QRS6Rs6+lLxepIb0lh4wgtV2FMSpSZwzA8zcT0BNjR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prTGTLp2dBgzkLCXEKBRiQO/f67+q5iLtIbgvrCSNEUgkamxSkZq1caxdiVtDsYNL1CJnqgfhinjOXBtnRiHVSkFnk+xl7jrV7qbNTKJC6ZHH9dWJ7yHX/LOhvnYHe196sHpazDkd+XLlYJqEhNdg34E7y7k34wS26NmOtIwguM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JLbuUYeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JLbuUYeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118F8C19423;
	Sat, 28 Feb 2026 17:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301134;
	bh=QRS6Rs6+lLxepIb0lh4wgtV2FMSpSZwzA8zcT0BNjR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JLbuUYeRTEbLsL2Vd2aRL9JklWJw25OgRX81xtlQ9dVNuDNI/0EKL9HUlrvaz5aW/
	 Txs1kszCQi/Ij2QB2uTKJnkbBmRyBnHPMQiLTBmWjI9ItGl11YJj9uYPu03C+wNtwF
	 z2KaZ7SBUwrxwBG3KKCRbSVyZAyLNLRhX3m/IjD7Mr7FJ4+X0LHvSDng/hQyrTtQpO
	 asJvkelJ9x3mlUj3mQ1njK7mNVcd50i+KzP0VU2i/eYCRJUOmiXUXBFfL/TW2SsIyR
	 3dqSgasxk/QDVDg+WzyioTfO9J57vvLo9DJdtBRRo4J9vJpGjD0nnoCPNOlCB8pQIq
	 bB2+TaRfnN69A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Johnny-CC Chang <Johnny-CC.Chang@mediatek.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 294/752] PCI: Mark Nvidia GB10 to avoid bus reset
Date: Sat, 28 Feb 2026 12:40:05 -0500
Message-ID: <20260228174750.1542406-294-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Johnny-CC Chang <Johnny-CC.Chang@mediatek.com>

[ Upstream commit c81a2ce6b6a844d1a57d2a69833a9d0f00403f00 ]

After asserting Secondary Bus Reset to downstream devices via a GB10 Root
Port, the link may not retrain correctly, e.g., the link may retrain with a
lower lane count or config accesses to downstream devices may fail.

Prevent use of Secondary Bus Reset for devices below GB10.

Signed-off-by: Johnny-CC Chang <Johnny-CC.Chang@mediatek.com>
[bhelgaas: drop pci_ids.h update (only used once), update commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20251113084441.2124737-1-Johnny-CC.Chang@mediatek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 62554152caf37..3c7aebf3d238a 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3748,6 +3748,14 @@ static void quirk_no_bus_reset(struct pci_dev *dev)
 	dev->dev_flags |= PCI_DEV_FLAGS_NO_BUS_RESET;
 }
 
+/*
+ * After asserting Secondary Bus Reset to downstream devices via a GB10
+ * Root Port, the link may not retrain correctly.
+ * https://lore.kernel.org/r/20251113084441.2124737-1-Johnny-CC.Chang@mediatek.com
+ */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x22CE, quirk_no_bus_reset);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_NVIDIA, 0x22D0, quirk_no_bus_reset);
+
 /*
  * Some NVIDIA GPU devices do not work with bus reset, SBR needs to be
  * prevented for those affected devices.
-- 
2.51.0

