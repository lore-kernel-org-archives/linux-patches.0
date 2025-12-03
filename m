Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFFC30F552;
	Wed,  3 Dec 2025 15:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776094; cv=none; b=Svt+D7P+JKlzfNBiWbm4Z/JU+nRKasU5v0v5pkPW1/iiazBcnlvK7lg8lyLCOwcHzLUkoje5C4tRhPxtsujL+uh5kNOkP2wNn6ggHrSfO6dvyKFESSHxHM04v5Md/eW3OM6r9nBI6hAE0c6zrCgaM3RMCjcMmjEGLSAC8h8jR3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776094; c=relaxed/simple;
	bh=uX2aklqOQcjZVhgadnRO6jvaVpXZL48KeI46mlYnNbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ufh0xlD+c5zjJn5KiVZZ8QcYqBSW/jOaJNz/x/8KOk9Jq0vht7ZXo+WdOgmCd4EEpBVfpbV046JYJk81eJwEP8WcIpTRrpjDPUNGZbs1XaBPlACWRT24itgGM58Dkxy7J/hO5Msxuo34Jz4mAM6cirQ3p7Ht5BiVRkHJmsuPYbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zOtJP59/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zOtJP59/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3952BC116B1;
	Wed,  3 Dec 2025 15:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776093;
	bh=uX2aklqOQcjZVhgadnRO6jvaVpXZL48KeI46mlYnNbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zOtJP59/mxyrlvhNWU3jkHmjZW5kddheMhYQDsOneFHQDkwUyQWJrUrNDc99CaKq3
	 Qshpum0QJ9Bvs7M+d4P5ofVVhKhQuui8KNDBAreCS1TVUYq3Z94S5HfqLK3Mqqua2Q
	 PaEq/852czqHeSDxz1tXbgrPeKVna2P8kDr/5+tk=
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
Subject: [PATCH 5.10 079/300] powerpc/eeh: Use result of error_detected() in uevent
Date: Wed,  3 Dec 2025 16:24:43 +0100
Message-ID: <20251203152403.551579462@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ed5be1bff60ca..2f13d906e1fcb 100644
--- a/arch/powerpc/kernel/eeh_driver.c
+++ b/arch/powerpc/kernel/eeh_driver.c
@@ -335,7 +335,7 @@ static enum pci_ers_result eeh_report_error(struct eeh_dev *edev,
 	rc = driver->err_handler->error_detected(pdev, pci_channel_io_frozen);
 
 	edev->in_error = true;
-	pci_uevent_ers(pdev, PCI_ERS_RESULT_NONE);
+	pci_uevent_ers(pdev, rc);
 	return rc;
 }
 
-- 
2.51.0



