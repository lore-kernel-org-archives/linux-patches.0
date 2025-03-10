Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C123617A2E8;
	Mon, 10 Mar 2025 18:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629620; cv=none; b=hmlzhKxALONJ79NYAzqC6jsogaNZ2+5a0sdpOTUHkeycCll3lcPOR/AbtnPoUEtf7Gki1mzQzfQ0qtuNOHiWNGc9uCg71ZRK8HO6FOAmx4BLARxR1PXwuWHX+69PUWy/vXIriOahe9NHY7VQnDokcBCWVeM4TYKup/3IPx01kKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629620; c=relaxed/simple;
	bh=8220W9wNebeLPclVCZx/aNZk4Om0MS3pDA7Bv9hr23c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=imsiFPy+hi5vi80+gjp2Ltd8ShoDAq+97gTAFFxu0Eqgrc4bAPWEZPCiAKHMIdr+4t5SsLnRCpECa2ljFGo27iLW+BCQSo9NI/KgRrlIgGAQ1JrDrI7v+aktq4hi59KH0o380eSN7ce4T6GVnBiSP62hqHm8iqHm1xY8fH+NoUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igpRsaVL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igpRsaVL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F556C4CEE5;
	Mon, 10 Mar 2025 18:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629620;
	bh=8220W9wNebeLPclVCZx/aNZk4Om0MS3pDA7Bv9hr23c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igpRsaVLkh9QmhliKnIGc42ckHjdmOHAuDe53LERZQ5RdNXy6qEvW4bkgUVXXYfKo
	 Qjj01dXSgT8Ff+AgOuV4Y6FcFlmpfGFZPQoU0v5bWNM5e48kD7ZJheSYrhCnnfeAdJ
	 jzFVdGJY5bEK6AKLqHz1CScK0KzcmybN4/9jYQmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 350/620] PCI/DPC: Quirk PIO log size for Intel Raptor Lake-P
Date: Mon, 10 Mar 2025 18:03:16 +0100
Message-ID: <20250310170559.425549105@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit b198499c7d2508a76243b98e7cca992f6fd2b7f7 ]

Apparently the Raptor Lake-P reference firmware configures the PIO log size
correctly, but some vendor BIOSes, including at least ASUSTeK COMPUTER INC.
Zenbook UX3402VA_UX3402VA, do not.

Apply the quirk for Raptor Lake-P.  This prevents kernel complaints like:

  DPC: RP PIO log size 0 is invalid

and also enables the DPC driver to dump the RP PIO Log registers when DPC
is triggered.

Note that the bug report also mentions 8086:a76e, which has been already
added by 627c6db20703 ("PCI/DPC: Quirk PIO log size for Intel Raptor Lake
Root Ports").

Link: https://lore.kernel.org/r/20250102164315.7562-1-tiwai@suse.de
Link: https://bugzilla.suse.com/show_bug.cgi?id=1234623
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 24fde99c11a70..a1f85120f97e6 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -6005,6 +6005,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2b, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2d, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a2f, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x9a31, dpc_log_size);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0xa72f, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0xa73f, dpc_log_size);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0xa76e, dpc_log_size);
 #endif
-- 
2.39.5



