Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CE0176AA1;
	Thu, 12 Dec 2024 17:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023312; cv=none; b=bM6QgA0VSiItfO4rQtI52Atc4crWp5O/ePg0WyKsrxJMWgOesmvGpd+5tC0E3nelluegvQchN52T5FdG5vxGd61WEIqUe950AxTGyzYBdQ+MO3kGGlCWuSUkqwPMCBPErYMd+p7SXI5Sgimt0kiHBOznN9S3cpFvTAMVR1RjA0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023312; c=relaxed/simple;
	bh=Cg0qWgoTnVtJzeUTIV3SdFJo78Gk4EWcSFNmrWllooQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kA++xDkNFUNfEvqkRu73xNlVk32dSp1weMyBrAzKWBbCLdbYLY5ghgZRp/3x8IlEjB0CSI6bwNmA5pDW1HQpdtGpkIIsT7yBcrUWyIjUJCRe9n6+x58Gvdfl1AX6PvysAviejTSM/PdsxGkjfoCY5egV210/6po4reGDJvfew3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMSBFBMO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMSBFBMO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8295EC4CED0;
	Thu, 12 Dec 2024 17:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023310;
	bh=Cg0qWgoTnVtJzeUTIV3SdFJo78Gk4EWcSFNmrWllooQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nMSBFBMOOqfs7+jG//zoxxotaLohcO+RlMe2pvvisuABOy4dn70o7zrSUKWQeGvix
	 bQiBtVhRfdly2aYHqTQRBPHMrectuMFRfsjPIbwUNVffoxoT7IaKSivnrzT2yxF9FY
	 m99yhKY9z4+jwN3YRSv/lAhb2SvySfva63XYdmgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 493/565] wifi: ath5k: add PCI ID for Arcadyan devices
Date: Thu, 12 Dec 2024 16:01:28 +0100
Message-ID: <20241212144331.258716523@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit f3ced9bb90b0a287a1fa6184d16b0f104a78fa90 ]

Arcadyan made routers with this PCI ID containing an AR2417.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20240930180716.139894-3-rosenp@gmail.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath5k/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath5k/pci.c b/drivers/net/wireless/ath/ath5k/pci.c
index 35a6a7b1047a3..f583e0f3932b8 100644
--- a/drivers/net/wireless/ath/ath5k/pci.c
+++ b/drivers/net/wireless/ath/ath5k/pci.c
@@ -47,6 +47,7 @@ static const struct pci_device_id ath5k_pci_id_table[] = {
 	{ PCI_VDEVICE(ATHEROS, 0x001c) }, /* PCI-E cards */
 	{ PCI_VDEVICE(ATHEROS, 0x001d) }, /* 2417 Nala */
 	{ PCI_VDEVICE(ATHEROS, 0xff16) }, /* Gigaset SX76[23] AR241[34]A */
+	{ PCI_VDEVICE(ATHEROS, 0xff1a) }, /* Arcadyan ARV45XX AR2417 */
 	{ PCI_VDEVICE(ATHEROS, 0xff1b) }, /* AR5BXB63 */
 	{ 0 }
 };
-- 
2.43.0



