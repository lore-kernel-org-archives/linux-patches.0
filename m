Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F2B5028C;
	Tue, 14 May 2024 11:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685992; cv=none; b=bW1tlCvTvoTR19XRQslS8WcqZlqZ+MfKJeQhAejRSuBSp5CxDneVOaEZ/iBS5yjR46f3AHS7YfME2e64ia39C2T7+vs5pdC+MreUeeWjzMgPkDErb5O+b//Cbd0uw+vTXI4BlxChX2lcMEu1LX6mD9yg1CGB64tCMAtRfthFeqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685992; c=relaxed/simple;
	bh=6dcI9PFRefySbstmAcgVyYA32n5wL0sYMJIVuudS/wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0oDW0vDU5DEf5pEmzbOuU2b13VtZ5X8OSBytj01Jzlukbd3oXP8684z/l2EqSWqVk6B2m5Vr9LKLlQuFyzKqy8DDc0QTjEjv77eQV9b17ki0ZWW7wdG5xiZaPI1pUlb2sof8l/At0GWPBklBMerVFlYIAgcKCt4tb4wDpgd+uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e/hBsBJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e/hBsBJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39575C2BD10;
	Tue, 14 May 2024 11:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685992;
	bh=6dcI9PFRefySbstmAcgVyYA32n5wL0sYMJIVuudS/wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e/hBsBJ8BRqZ3NHbZ0UPH+Ob80Ye2u6cBCMiGXjTw31DtEE9kSp2KdMbT/iW6oucs
	 i2upCbzbkCWSTBRboLq0rcchbzpaL4PVHAYr40cy8HWsKtpDiD/g6eMDN/iL2TpAHZ
	 uF3KoHMTOKPYEcyp4ug/xjyG/l/dt5ved6AmEUHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 6.6 265/301] mei: me: add lunar lake point M DID
Date: Tue, 14 May 2024 12:18:56 +0200
Message-ID: <20240514101042.261731267@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 4108a30f1097eead0f6bd5d885e6bf093b4d460f upstream.

Add Lunar (Point) Lake M device id.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20240421135631.223362-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    2 ++
 drivers/misc/mei/pci-me.c     |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -115,6 +115,8 @@
 #define MEI_DEV_ID_ARL_S      0x7F68  /* Arrow Lake Point S */
 #define MEI_DEV_ID_ARL_H      0x7770  /* Arrow Lake Point H */
 
+#define MEI_DEV_ID_LNL_M      0xA870  /* Lunar Lake Point M */
+
 /*
  * MEI HW Section
  */
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -122,6 +122,8 @@ static const struct pci_device_id mei_me
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ARL_S, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ARL_H, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_LNL_M, MEI_ME_PCH15_CFG)},
+
 	/* required last entry */
 	{0, }
 };


