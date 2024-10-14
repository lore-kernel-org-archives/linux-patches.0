Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E094119E802;
	Mon, 14 Oct 2024 14:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728915915; cv=none; b=GTLlntWE6QRy6BLrcRJC5Ty1ssiftmriMWUjVSojk0pHow+VWMwJ7YVS/fzmZ4TN13ZVmVcGV7LH3q6/+Zk+VnCU9YTMh9quHfJ1hmciUVu+4V+bFZl4/lhbahXiLLGGn5aydJtakklBIbTTjt+M58tOZUvnNDLT9wgUlEYWT88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728915915; c=relaxed/simple;
	bh=W8gQ142pFSnpMCuFjizy35b8zTgqvJ4bUwFRs3h3z0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mu3vNreeR3qinnw5111F9XbMpZYlHPn6sdHLPXcBPC7YzYsstzVtjBiEMkm7HsvSnVjwGW2GnalhPYg/QRZE+cRear46CNFwxU87HD6xamEUkLCXBXzkWvx4WkFLUKOCJNCBrxKHRztWIkT15oIvUIq8DZiP+Obl6QcQyUrJzG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxpUKeUf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxpUKeUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEC6C4CEC3;
	Mon, 14 Oct 2024 14:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728915914;
	bh=W8gQ142pFSnpMCuFjizy35b8zTgqvJ4bUwFRs3h3z0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxpUKeUfCX9vT7G4mKKRt/2vnpxAvZBIQEM+SpLFM6vTe3OoqSbVdcFv1UrKHemuc
	 LmMz9quko79JJ6CRC3XograZfOkgl0q6PB9bIrJg2Rud8E1QACIkwWiEDDFiLtvLip
	 WXtP9AeJW3rI/zXx/n/COjIsFIS0MuZaRSezee7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdravko delineshev <delineshev@outlook.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 036/214] PCI: Mark Creative Labs EMU20k2 INTx masking as broken
Date: Mon, 14 Oct 2024 16:18:19 +0200
Message-ID: <20241014141046.400557485@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 85666ee2d8691..dccb60c1d9cc3 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3621,6 +3621,8 @@ DECLARE_PCI_FIXUP_FINAL(0x1814, 0x0601, /* Ralink RT2800 802.11n PCI */
 			quirk_broken_intx_masking);
 DECLARE_PCI_FIXUP_FINAL(0x1b7c, 0x0004, /* Ceton InfiniTV4 */
 			quirk_broken_intx_masking);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_CREATIVE, PCI_DEVICE_ID_CREATIVE_20K2,
+			quirk_broken_intx_masking);
 
 /*
  * Realtek RTL8169 PCI Gigabit Ethernet Controller (rev 10)
-- 
2.43.0



