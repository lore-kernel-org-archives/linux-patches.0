Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB51E4F218;
	Thu, 12 Dec 2024 16:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021205; cv=none; b=m7HCqTVMa403n28rv2D7ir5TDl3Pbm38uSQm+znVZAyHvPohhlKp+Ge4fkT6a9Z45+mopLm6LeX7HXEnChVhIMzkvfy+c5CXF1nyNNTAK47ZyO4pXAorsz+h6lCe/XwGtMtlqc/jSULP2SJ1GYl0rcoz/Qzpucktwm7q8wTQGpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021205; c=relaxed/simple;
	bh=EWXD5Un2AiPuYqbeUpdvJQ5A6O4LSqEZc+cOxmBakTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F60tCGFOwY9Oi6BLIbcWIW1SrMn0ZYuqzW8ZxOeD5DgL13eUfGEIsW+96bITMmhd6KX6VVbYbdsMLEg7SY95jgcpb6JSjHBgjBd75fa02u3JyVfnHKVngzc9d4BHFTnQjYmSGeD7E/HtfxvcZaK+yvDIUh/XznSElqPnmvtyrTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ooUpQxCp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ooUpQxCp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C928C4CECE;
	Thu, 12 Dec 2024 16:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021204;
	bh=EWXD5Un2AiPuYqbeUpdvJQ5A6O4LSqEZc+cOxmBakTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ooUpQxCpHwSepx9f1pHFLg3kahpDDT3LNR2I92DaWQPako5hDfmfZefij7XMpZrzV
	 Ao5rgy1fJaXyxpfOpsV0Kc+WC4O9H6mVFJ+FN26+cGwjakCLWwTqvznrh99OjXdzru
	 3nPtZN7hOasVAsuyWaD9s4rZyjaNFe+W549U7Agg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 674/772] wifi: ath5k: add PCI ID for SX76X
Date: Thu, 12 Dec 2024 16:00:19 +0100
Message-ID: <20241212144417.768768979@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 86b8cb975b1ac..35a6a7b1047a3 100644
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



