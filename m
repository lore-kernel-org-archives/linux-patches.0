Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9874086A;
	Tue, 11 Nov 2025 01:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822953; cv=none; b=cxWJ7nll1iasEfO32XPxZioBC7FFdcuF075p5AtunCbl3iI0ckokhrqKwJlJcId7vdZLgqWcQRAB6lMbOOBHCUCpPOkPb8IOgMyZHYmeWGqJk9VO+zdppCTT4VqOW9H+30BItt0kNDl0oiLQwPyghMG9fS7IiaT560MNiBVLkpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822953; c=relaxed/simple;
	bh=4mnhxd5aKvjfrZzQGnabQXHYKUcwQoJ5TEKXRnCiyw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTqp7xmkHtuAa0vKgYAXrvg2oVdUgZ5GoTinKtJezdLkj8PExSPLi9sbuKGrlguXSZViQPdwK4Qsig//BLLchXfsrBHDaJ3hCm5gR5WBc1C9+F8Jep4ZRhLKcYNQOkbASU3N0ru75A7/ERURsUO5gUTielG67FXZG51Xt8UECKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1waj5UCu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1waj5UCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EA4C19422;
	Tue, 11 Nov 2025 01:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822953;
	bh=4mnhxd5aKvjfrZzQGnabQXHYKUcwQoJ5TEKXRnCiyw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1waj5UCu34J5wktNt/WlOEqzkN7AiS3HSwhl5BM+bigHuDUU70wpdhtMVv45XBAlX
	 yJa4QEGKTAOD+pwjouBQm+4zEOQu+G2/U0+Rdykb13d3oB7RBY9mBaC/IdQ0cFP8X7
	 zPE9OlqEEJ0FrML5iVDX06hBp1QPWJaRD9AAufRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 140/565] i3c: mipi-i3c-hci-pci: Add support for Intel Wildcat Lake-U I3C
Date: Tue, 11 Nov 2025 09:39:56 +0900
Message-ID: <20251111004530.092662092@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit d515503f3c8a8475b2f78782534aad09722904e1 ]

Add I3C controller PCI IDs on Intel Wildcat Lake-U.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250808131732.1213227-1-jarkko.nikula@linux.intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c b/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
index c6c3a3ec11eae..08e6cbdf89cea 100644
--- a/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
+++ b/drivers/i3c/master/mipi-i3c-hci/mipi-i3c-hci-pci.c
@@ -124,6 +124,9 @@ static void mipi_i3c_hci_pci_remove(struct pci_dev *pci)
 }
 
 static const struct pci_device_id mipi_i3c_hci_pci_devices[] = {
+	/* Wildcat Lake-U */
+	{ PCI_VDEVICE(INTEL, 0x4d7c), (kernel_ulong_t)&intel_info},
+	{ PCI_VDEVICE(INTEL, 0x4d6f), (kernel_ulong_t)&intel_info},
 	/* Panther Lake-H */
 	{ PCI_VDEVICE(INTEL, 0xe37c), (kernel_ulong_t)&intel_info},
 	{ PCI_VDEVICE(INTEL, 0xe36f), (kernel_ulong_t)&intel_info},
-- 
2.51.0



