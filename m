Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454CB1EABAB;
	Tue, 15 Oct 2024 12:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994113; cv=none; b=Dwh33p4H6i98hHkFNmnDt+YRD8P0rB7HPeeXYf/yZwoXFN1mzRTj9MbkVdocV+r/eMEmxlrXlfnua8Nu9XX/pGqLd+iP/C9FXpvZd0R5G77YFn6Vp3r8u9jxeumgJVGP4R8TPbGXRNPjl1E5XcXELWKs2e2Ex1mzvotmAgVCg6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994113; c=relaxed/simple;
	bh=kpGXNYw9eJ/Rl2GNptGA6Poz4gxDtdubuTXULG20BPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rwvuvXl1VwKUOpt9KEPywY36XWKePA/lKNL/M8Ji0EG2eXpka1WnNymTSsgj4oWZxYjg0CBmI4opgDodQ08KxB/m3omwSQKuPHaVnlaW0yBo9mqhZyn3iAC86vmEoiYJpXdDdivTHXGP4Tak+9mLsuzShj/0jJlYTFun2ouhBx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EqxubaHY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EqxubaHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB632C4CED0;
	Tue, 15 Oct 2024 12:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994113;
	bh=kpGXNYw9eJ/Rl2GNptGA6Poz4gxDtdubuTXULG20BPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EqxubaHYa904M8CzyrM6X3AhsU6iQ+gqEvswI7f5EOavmhV+pSmIAAAj4HP5GEC/y
	 DSRmUR75RNHJgdMy6K5Ao72A7251/9gvdeL8VwEbO3CHleV1SM4NQx7jeaY8k+RrKd
	 BTeeYHxAqwRILG1DIqeck7FkPdwzfGCu3lzw9QbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdravko delineshev <delineshev@outlook.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 610/691] PCI: Mark Creative Labs EMU20k2 INTx masking as broken
Date: Tue, 15 Oct 2024 13:29:18 +0200
Message-ID: <20241015112504.549529784@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

[ Upstream commit 2910306655a7072640021563ec9501bfa67f0cb1 ]

Per user reports, the Creative Labs EMU20k2 (Sound Blaster X-Fi
Titanium Series) generates spurious interrupts when used with
vfio-pci unless DisINTx masking support is disabled.

Thus, quirk the device to mark INTx masking as broken.

Closes: https://lore.kernel.org/all/VI1PR10MB8207C507DB5420AB4C7281E0DB9A2@VI1PR10MB8207.EURPRD10.PROD.OUTLOOK.COM
Link: https://lore.kernel.org/linux-pci/20240912215331.839220-1-alex.williamson@redhat.com
Reported-by: zdravko delineshev <delineshev@outlook.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 965e2c9406dbd..4ce4ca3df7432 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3482,6 +3482,8 @@ DECLARE_PCI_FIXUP_FINAL(0x1814, 0x0601, /* Ralink RT2800 802.11n PCI */
 			quirk_broken_intx_masking);
 DECLARE_PCI_FIXUP_FINAL(0x1b7c, 0x0004, /* Ceton InfiniTV4 */
 			quirk_broken_intx_masking);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CREATIVE, PCI_DEVICE_ID_CREATIVE_20K2,
+			quirk_broken_intx_masking);
 
 /*
  * Realtek RTL8169 PCI Gigabit Ethernet Controller (rev 10)
-- 
2.43.0



