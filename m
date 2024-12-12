Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF5E2153EC;
	Thu, 12 Dec 2024 17:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024754; cv=none; b=o1iCc4B7y+K/VLFheKHKOR0SttOHaILZX0Jmf3r3uRmTPOKS/WeileQW9XTcLIcvJ4XIFhaiaIJfsUzngU6zvEgR+kMMjmbJ0yltTHaYX/ifTQRkM+7xf3BFQX07PzwaeqsyeOVw2MgYRFVGfk7K0hxzk1dy4LxapCZ3mvDCqa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024754; c=relaxed/simple;
	bh=x0khU2xL/eQoFk3ovJQzWopzT9nKqdqUHdk0X97K1vo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XM2GXN0wVqX7woqe09l3eJbVvcw4voKtofMl75h4YjUkKYB9OuCSZA4Fsls3mIrIw61xA/0y/HR1YGIqcK57tbFOqL6Dk5TvE8Qa0l5x4YtQwxYq5RvqTD9/II8vD2OwLtukYVOeJoPRFNl+Ix7FzURUb/HH6Xa0KD4WhvAHy4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TaFzFui5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaFzFui5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE4F4C4CECE;
	Thu, 12 Dec 2024 17:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024754;
	bh=x0khU2xL/eQoFk3ovJQzWopzT9nKqdqUHdk0X97K1vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TaFzFui5lvSDCk7PDm9P+cftDJnJXn4I3b/QIQ8He8kEyJsjU4K1MPb+xb2VBR98t
	 Ph2UA/5DG2JFgrBEnlkFNqc/SZ/lyne1E+NUQPqONarqzHJivcQqeLNYV2MLgtRvoi
	 xXUbotzdjg9wZuPcEJ2hLVv3tMHjMaie7ZC2HCKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 400/459] wifi: ath5k: add PCI ID for SX76X
Date: Thu, 12 Dec 2024 16:02:18 +0100
Message-ID: <20241212144309.567441968@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit da0474012402d4729b98799d71a54c35dc5c5de3 ]

This is in two devices made by Gigaset, SX762 and SX763.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20240930180716.139894-2-rosenp@gmail.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath5k/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath5k/pci.c b/drivers/net/wireless/ath/ath5k/pci.c
index 43b4ae86e5fb2..0892970a99637 100644
--- a/drivers/net/wireless/ath/ath5k/pci.c
+++ b/drivers/net/wireless/ath/ath5k/pci.c
@@ -46,6 +46,7 @@ static const struct pci_device_id ath5k_pci_id_table[] = {
 	{ PCI_VDEVICE(ATHEROS, 0x001b) }, /* 5413 Eagle */
 	{ PCI_VDEVICE(ATHEROS, 0x001c) }, /* PCI-E cards */
 	{ PCI_VDEVICE(ATHEROS, 0x001d) }, /* 2417 Nala */
+	{ PCI_VDEVICE(ATHEROS, 0xff16) }, /* Gigaset SX76[23] AR241[34]A */
 	{ PCI_VDEVICE(ATHEROS, 0xff1b) }, /* AR5BXB63 */
 	{ 0 }
 };
-- 
2.43.0



