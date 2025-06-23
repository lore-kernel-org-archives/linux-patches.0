Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2A016419;
	Mon, 23 Jun 2025 13:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686058; cv=none; b=FowG+EFA7Mx5jBiNZK/G2WtyraetsfIZ8c4BQ6zsvFrLmDFmymhHaLn0zYHfVQHAQfRmLZP35ntxoyoXxmmsOABBsm8sCBMmkuf42TGBgZEftwcJ2KrY3pP9P1v6bmZ89aBwBtvX4ab23bBM5/cajIW1Y2zrOF7y98mwbn0a2YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686058; c=relaxed/simple;
	bh=eBW6pC8FycgUSplev3FfGUNWr49lRd9Ba1SYBOrRLyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bz+E8kzo3KdJVJ5wHrmhAts2m6dt7Zf5i+qLrmmF3aFccneUwrV8m2xiTmwmf/CSyBS4qBG97mfLUVq5yWBtaBgs2lL0cTHWbbbIRL230x4XJWliXp0+eNR+pFjNRygNaHA9Lgs1HkoWuqywZO7a/fHYcHViKtwBHf0g0T8PRsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vetXUeKj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vetXUeKj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A13C4CEEA;
	Mon, 23 Jun 2025 13:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686057;
	bh=eBW6pC8FycgUSplev3FfGUNWr49lRd9Ba1SYBOrRLyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vetXUeKjTzc0hg1ZO+2nkL5nlPANoO3IRITSu4MhjmPu/ed1ZubXZbzD/owrq3NuY
	 5PMb5r943Oyd/TsOwaTEzuf1Z7bnInwrnMcJnhkgaIaDYjSrHiwkQyxo6URNWEyY+9
	 hAJtTEHib6K0UzSEYBlHSi6FaF9cY/5QX0tLLj/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 088/355] PCI/DPC: Initialize aer_err_info before using it
Date: Mon, 23 Jun 2025 15:04:49 +0200
Message-ID: <20250623130629.448729306@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit a424b598e6a6c1e69a2bb801d6fd16e805ab2c38 ]

Previously the struct aer_err_info "info" was allocated on the stack
without being initialized, so it contained junk except for the fields we
explicitly set later.

Initialize "info" at declaration so it starts as all zeros.

Fixes: 8aefa9b0d910 ("PCI/DPC: Print AER status in DPC event handling")
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://patch.msgid.link/20250522232339.1525671-2-helgaas@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/dpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
index ab83f78f3eb1d..cabbaacdb6e61 100644
--- a/drivers/pci/pcie/dpc.c
+++ b/drivers/pci/pcie/dpc.c
@@ -263,7 +263,7 @@ static int dpc_get_aer_uncorrect_severity(struct pci_dev *dev,
 void dpc_process_error(struct pci_dev *pdev)
 {
 	u16 cap = pdev->dpc_cap, status, source, reason, ext_reason;
-	struct aer_err_info info;
+	struct aer_err_info info = {};
 
 	pci_read_config_word(pdev, cap + PCI_EXP_DPC_STATUS, &status);
 	pci_read_config_word(pdev, cap + PCI_EXP_DPC_SOURCE_ID, &source);
-- 
2.39.5



