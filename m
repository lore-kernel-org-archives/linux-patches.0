Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1096359A6F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302389; cv=none; b=gXHwoII+NscXgNgHwWQf5fzmPH8k10pFtD0JTC6oQ9eCOnLMqHKro074sg9KJ8BIf4zH480CqGPUJgTd9oXFqaz1uKxVbu8AxIgRTDC7YGwGSqE2bvFNkN5kn5yXtBQvugMT03PJsl1LqmPw5J2Y5CP6RA6lAV2r38HLosVz5Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302389; c=relaxed/simple;
	bh=ar0KX1HpC3gXP+/RarL/8TW8MOCD9XATFVaoAI7t/zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mlz2+AZEbpTPwbR1yFcLyJ256WyqyW93a3ecigK3pVmy3YnV8FDl24AVwk4Ob7jLuyt6cfFB/V6DG6AYDqEFceUsuw7WQQZfL3ni+uqY3JJuHubvuPnajnyWR9a5P+Lc8YXfKWzhcxiHR8MQ1cQ2JpXPN74JdZ20ZjL3hRk10l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RF0xN7Xa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RF0xN7Xa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D368C19423;
	Sat, 28 Feb 2026 18:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302389;
	bh=ar0KX1HpC3gXP+/RarL/8TW8MOCD9XATFVaoAI7t/zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RF0xN7XaFmzgY7M+EY2R41CYC/dUREHneWQ/eWGuNQn2SmdbvTYgvX/WUFYknKwPC
	 nKA6vPG6HMWh6H4CcoPzK7VgxRraOUgXJOt9NSPu3apNznMXJMSevnv0FW6+kHYfYZ
	 Cl201OB9UwmL2wJkyNBzsUjR0qbQ3KeQ8Xsi3VoQ1MW/5g6j+tjTCkMfB3ALRysmk+
	 J4xmsuXI5YmSBsQlZlwGdTjOkYotmWODclRoMoR6cVY/zUxQBbGhf0Iwue8tdkCagM
	 8c4kxy3HN1Q67mxD/QKhjDvDkPRA74OYG6pfXH9ttf062KQAPfCuXoTQNivw8XYOah
	 WC+2bQIbqx1uA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 119/232] PCI: Add ACS quirk for Pericom PI7C9X2G404 switches [12d8:b404]
Date: Sat, 28 Feb 2026 13:09:32 -0500
Message-ID: <20260228181127.1592657-119-sashal@kernel.org>
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

From: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>

[ Upstream commit 5907a90551e9f7968781f3a6ab8684458959beb3 ]

12d8:b404 is apparently another PCI ID for Pericom PI7C9X2G404 (as
identified by the chip silkscreen and lspci).

It is also affected by the PI7C9X2G errata (e.g. a network card attached
to it fails under load when P2P Redirect Request is enabled), so apply
the same quirk to this PCI ID too.

PCI bridge [0604]: Pericom Semiconductor PI7C9X2G404 EV/SV PCIe2 4-Port/4-Lane Packet Switch [12d8:b404] (rev 01)

Fixes: acd61ffb2f16 ("PCI: Add ACS quirk for Pericom PI7C9X2G switches")
Closes: https://lore.kernel.org/all/a1d926f0-4cb5-4877-a4df-617902648d80@green-communications.fr/
Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260119160915.26456-1-nicolas.cavallari@green-communications.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index fc793635a3d81..9a2076ddfe4e1 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -6073,6 +6073,10 @@ DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_PERICOM, 0x2303,
 			 pci_fixup_pericom_acs_store_forward);
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_PERICOM, 0x2303,
 			 pci_fixup_pericom_acs_store_forward);
+DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_PERICOM, 0xb404,
+			 pci_fixup_pericom_acs_store_forward);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_PERICOM, 0xb404,
+			 pci_fixup_pericom_acs_store_forward);
 
 static void nvidia_ion_ahci_fixup(struct pci_dev *pdev)
 {
-- 
2.51.0

