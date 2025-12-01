Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF1F4308F0B;
	Mon,  1 Dec 2025 11:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588456; cv=none; b=igK/tX7c6/Q4+juC4WhyroGt/AroBYoXQax9iAHgZOzZa9byFn0UlS+J8NYJlMskGJgIZM5bo6pGWzJrSfiZLhjPAGr54BXHPyGZxMgVbHpa3HBVhrDIQTaufvY8U8sOK8R+qQfHSisQxlMd8FdrKKotWjxlsILrvZu5C+84cno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588456; c=relaxed/simple;
	bh=CMcKgTb2GWTdqFVJ3Q+6vjSkFsAiJY9Wl2xDiKIokBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxEAG5t66HLu6m5TKiCSbOITnTiaWB6LjML2jlMC4Ocj4bekarUJQLRZN+Hiqh1ATWT2eS3NIYnUDU0zn2823krarbFmJ7MxRfVSyJJ4RUx65H7PPu5d7FsET4A/iA+ZCQDpIeHDIFH5dTBGU1dt/j4slsReH8TS0aPtzhsl5L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i7256FVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i7256FVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7270DC4CEF1;
	Mon,  1 Dec 2025 11:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588455;
	bh=CMcKgTb2GWTdqFVJ3Q+6vjSkFsAiJY9Wl2xDiKIokBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i7256FVxNm8U9QklDXCmcHivzvCEjWgumsZwd1lPIqKuPcpMbswkZT5SFpnc88I9a
	 ILUFnklJGG0EWKq4EDKRMi/ND2ryeHHQxIzFaeKYXK7wOA+4vEv+AGUDBOUrcwiJCI
	 ofT1I4LRuTwC6CDnTXxyTaMuycsbr7XobDdIPz/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Wunner <lukas@wunner.de>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Mahesh Salgaonkar <mahesh@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 055/187] powerpc/eeh: Use result of error_detected() in uevent
Date: Mon,  1 Dec 2025 12:22:43 +0100
Message-ID: <20251201112243.230300052@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit 704e5dd1c02371dfc7d22e1520102b197a3b628b ]

Ever since uevent support was added for AER and EEH with commit
856e1eb9bdd4 ("PCI/AER: Add uevents in AER and EEH error/resume"), it
reported PCI_ERS_RESULT_NONE as uevent when recovery begins.

Commit 7b42d97e99d3 ("PCI/ERR: Always report current recovery status for
udev") subsequently amended AER to report the actual return value of
error_detected().

Make the same change to EEH to align it with AER and s390.

Suggested-by: Lukas Wunner <lukas@wunner.de>
Link: https://lore.kernel.org/linux-pci/aIp6LiKJor9KLVpv@wunner.de/
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Acked-by: Mahesh Salgaonkar <mahesh@linux.ibm.com>
Link: https://patch.msgid.link/20250807-add_err_uevents-v5-3-adf85b0620b0@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/eeh_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/eeh_driver.c b/arch/powerpc/kernel/eeh_driver.c
index 68decc2bf42bc..7ce80ad5e9d35 100644
--- a/arch/powerpc/kernel/eeh_driver.c
+++ b/arch/powerpc/kernel/eeh_driver.c
@@ -351,7 +351,7 @@ static enum pci_ers_result eeh_report_error(struct eeh_dev *edev,
 	rc = driver->err_handler->error_detected(pdev, pci_channel_io_frozen);
 
 	edev->in_error = true;
-	pci_uevent_ers(pdev, PCI_ERS_RESULT_NONE);
+	pci_uevent_ers(pdev, rc);
 	return rc;
 }
 
-- 
2.51.0



