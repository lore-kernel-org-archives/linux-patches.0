Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7733DFC7D;
	Tue, 31 Mar 2026 16:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974866; cv=none; b=bOrM3LwaIk515hSdrybUpJw1gsZ7xXF0TRwGBRzv1ZJTz05eqKtbErZj2gRA93m22GC2kU7ZXayuzPVK/LcYN3z5BaaoEATn28BZINzYnRv+IrNTVhtx5EcTBGhpvO7+aNvAj+oqt7uTDzaoZn7pQ6mHDDMqDb0BQJhr7XaWZK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974866; c=relaxed/simple;
	bh=Rc+1Gv/9gKZ7NO2aSFuUX8oQFrBvXF+SfHgNM+rvJdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CO0qvcVc3bpffJeCus3X+ITIsTSgMOODrnhDXTuTboWVuL8PhAH1LBpWM+M+0y2njTVa5enz2ualO4Jm16+qQbMZdqdnFd1bBjh2F1Pewy0S7L3twpGIiU1+zq8A+EvPLZzy82f1mbdCLK+9+2BcylNVZiM7wu7aGNdhcjHVdfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/l5M+sO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/l5M+sO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00308C19423;
	Tue, 31 Mar 2026 16:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974866;
	bh=Rc+1Gv/9gKZ7NO2aSFuUX8oQFrBvXF+SfHgNM+rvJdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/l5M+sO2B+bezCjKHHjc+9SGqHTnW/z6H5D5PUlnW7ZHdjN8T5ibHXgqerCVqH2l
	 lUsJkInpMMOSf53zPOVvuswU+mjznB6qsGIWpzWCmH+rsHniJPY5Q8Q6iCFg614nm2
	 bF+xnqjxFzjCL9pkDl9NW4RKN5AMMzDslunb8IzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 074/342] spi: intel-pci: Add support for Nova Lake mobile SPI flash
Date: Tue, 31 Mar 2026 18:18:27 +0200
Message-ID: <20260331161801.617250962@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>

[ Upstream commit 85b731ad4bbf6eb3fedf267ab00be3596f148432 ]

Add Intel Nova Lake PCD-H SPI serial flash PCI ID to the list of
supported devices.

Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://patch.msgid.link/20260309153703.74282-1-alan.borzeszkowski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-intel-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-intel-pci.c b/drivers/spi/spi-intel-pci.c
index bce3d149bea18..d8ef8f89330ac 100644
--- a/drivers/spi/spi-intel-pci.c
+++ b/drivers/spi/spi-intel-pci.c
@@ -96,6 +96,7 @@ static const struct pci_device_id intel_spi_pci_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0xa324), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0xa3a4), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0xa823), (unsigned long)&cnl_info },
+	{ PCI_VDEVICE(INTEL, 0xd323), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0xe323), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0xe423), (unsigned long)&cnl_info },
 	{ },
-- 
2.51.0



