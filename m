Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E6611187;
	Tue, 26 Aug 2025 13:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215236; cv=none; b=T2EZWUTLxfnlg+T2WkJuKNFwT0rfFapK8Bw0cHJ2XGoGtMQgOPRJ2sVwgKjHK4cXJv6Z8U0XmFtbcnvC+Z/bAff+rZBmuQrk9IKcZ7an5zz9ocuIGSlF46Lb/U7wrqeIsg5TPgycAEAkXE6lXeuSGFxm1/i+4oFeitLc3x4mnYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215236; c=relaxed/simple;
	bh=Tuwrt7BRJP7iSF8WzUp25jq7s1uYXZARM3unCb5W3aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cB5f+tm/jKdZzM1n+24mYHs/HRG+8xsCwYlX+JQrPMbH3ukF5gMD3SyiJoUTqrHvmztI2yIUNLBrN0o2HrDirB3wUA8tOImWFSSFCIJC8b0RGY7pXQ6EXqSiRWI5cNS1HbDa78PA0gqpjMUgiTq9o8DRXIS1tzbq+MHi45/yBZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ip+WN9Zp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ip+WN9Zp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B424C4CEF1;
	Tue, 26 Aug 2025 13:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215236;
	bh=Tuwrt7BRJP7iSF8WzUp25jq7s1uYXZARM3unCb5W3aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ip+WN9Zp4BnlzMpUBepfsg9koQWYDe/jp2qPK7awA39wQx5KdfnuxuYlyo9r9Gen4
	 ZVEABsHuZse+czgebdFZ2PDFd3FDdN9Pyj5am1yfewvQWCO15E4k05JgYW6j3lzIzU
	 7i2bkaOYbg2St8VIx15NQU+jZrjYCquNPOfBBSN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Victor Shih <victor.shih@genesyslogic.com.tw>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 438/482] mmc: sdhci-pci-gli: Add a new function to simplify the code
Date: Tue, 26 Aug 2025 13:11:31 +0200
Message-ID: <20250826110941.651582592@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Victor Shih <victor.shih@genesyslogic.com.tw>

[ Upstream commit dec8b38be4b35cae5f7fa086daf2631e2cfa09c1 ]

In preparation to fix replay timer timeout, add
sdhci_gli_mask_replay_timer_timeout() function
to simplify some of the code, allowing it to be re-used.

Signed-off-by: Victor Shih <victor.shih@genesyslogic.com.tw>
Fixes: 1ae1d2d6e555 ("mmc: sdhci-pci-gli: Add Genesys Logic GL9763E support")
Cc: stable@vger.kernel.org
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20250731065752.450231-2-victorshihgli@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Stable-dep-of: 340be332e420 ("mmc: sdhci-pci-gli: GL9763e: Mask the replay timer timeout of AER")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-gli.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/mmc/host/sdhci-pci-gli.c
+++ b/drivers/mmc/host/sdhci-pci-gli.c
@@ -156,6 +156,20 @@
 #define GLI_MAX_TUNING_LOOP 40
 
 /* Genesys Logic chipset */
+static void sdhci_gli_mask_replay_timer_timeout(struct pci_dev *pdev)
+{
+	int aer;
+	u32 value;
+
+	/* mask the replay timer timeout of AER */
+	aer = pci_find_ext_capability(pdev, PCI_EXT_CAP_ID_ERR);
+	if (aer) {
+		pci_read_config_dword(pdev, aer + PCI_ERR_COR_MASK, &value);
+		value |= PCI_ERR_COR_REP_TIMER;
+		pci_write_config_dword(pdev, aer + PCI_ERR_COR_MASK, value);
+	}
+}
+
 static inline void gl9750_wt_on(struct sdhci_host *host)
 {
 	u32 wt_value;


