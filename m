Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9C9423A63;
	Tue, 31 Mar 2026 16:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975676; cv=none; b=dbz/sJiGhL/2sdgRSGe1rrK2osTYd7+MW9VIkrM9w1dxQi9/Drz0hZTs/zHnK5AXam2XydXfiUCvN4SJduGVtk/MFbuX8EAjuPRP5wEXMu7iU3IUtEgc5ct+d6BCSk6tTMJ6og9wBBllaqP4OH1erSOTcCEsXbWtOLUpxSVQO5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975676; c=relaxed/simple;
	bh=Q+g7uG2YYW6DkBuhql5b5w8RNp4hmhNHQn7I+gGdY/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XB6b8W0hqEfgijLpPpYdudFTchV+QmcNcPMtePJ/pHF9sRxhe5ONoXrPhlfoF79dK7fpUaOYL9NdlvmmNC02Tyz+9aKCwuVHKMFwEMeN1QMq7AMbgdSsb+9uUgPfqzXGEV7r6rk48UKCnKqGVIJWnzc6+/CbVW7dPrLGwAknmM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVBoOgNx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVBoOgNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5CEEC19424;
	Tue, 31 Mar 2026 16:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975676;
	bh=Q+g7uG2YYW6DkBuhql5b5w8RNp4hmhNHQn7I+gGdY/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GVBoOgNxOlYiDY4tzqUXDPCJx0cqUncMRTCDuwWpnRqmWtr5BzYUR8fgLA9+mvCmn
	 eri2xPURSt/oj7mqeMnOP3U2266I0MOLxJ/Ac3XrOHzJyfQtPu1K1qm6e+scdrmqoE
	 rJiA1Bg8NhDzI2Tkm7zmZ/CIjtzdqCHhNrGydU9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/244] spi: intel-pci: Add support for Nova Lake mobile SPI flash
Date: Tue, 31 Mar 2026 18:19:54 +0200
Message-ID: <20260331161743.325293411@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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
index 5c0dec90eec1d..43692315ea305 100644
--- a/drivers/spi/spi-intel-pci.c
+++ b/drivers/spi/spi-intel-pci.c
@@ -86,6 +86,7 @@ static const struct pci_device_id intel_spi_pci_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0xa324), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0xa3a4), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0xa823), (unsigned long)&cnl_info },
+	{ PCI_VDEVICE(INTEL, 0xd323), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0xe323), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0xe423), (unsigned long)&cnl_info },
 	{ },
-- 
2.51.0



