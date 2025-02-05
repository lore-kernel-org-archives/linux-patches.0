Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B156155A30;
	Wed,  5 Feb 2025 15:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768081; cv=none; b=AtToj82NOowppC/CshCnW11AoIYi4cqCu/0bKPunWRyx+y8qJffUz3q+RRXHyvXBxI5xvRRs1eJUN00LBcgg6jVDEKnhytrdyCRF1SrSAcCL/BTdtk6QKJDUk80scL8l0jbB6NZSA5/t68AFR1Au8ESZpS83Q4CfQSLdgV99WXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768081; c=relaxed/simple;
	bh=ZiKnqdTKehZWf45o1MaNVYRBX3qki088OYO7lfBa+3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LiooDLXro17idfupG0xxG9a8KJNPhGlfgGNqJlrb1EJpJYYDu+2zjUDqwfls6jXgKHJM4xoqUVl3iPeH3aK/lDke3qIBIx01JN9WKSwqFmm/PeIG5mVNTz7AKdgl9QetmKACLIr2D3yCL9CcouyQkBXTjjkClWS0riVdAra0MMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hR5BePmK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hR5BePmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8091BC4CED1;
	Wed,  5 Feb 2025 15:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768081;
	bh=ZiKnqdTKehZWf45o1MaNVYRBX3qki088OYO7lfBa+3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hR5BePmKSfpu2ps6dAfKDWfcAqbpQ8pUy2hRJ6vcS7A8AUBQbMEMSOpkURJu/S3mt
	 /9WMkbWgSEVlSOrOV6J+kLZpcBuGe/hAWT31FaOEHCuMB3MiCm+rKcuKfd19NUNKjf
	 ZiJm0VIkqpAylCLjEFdz6YJtHwHPKasD/b/K2SuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Khalfella <khalfella@gmail.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 470/623] PCI: endpoint: pci-epf-test: Set dma_chan_rx pointer to NULL on error
Date: Wed,  5 Feb 2025 14:43:32 +0100
Message-ID: <20250205134514.198993327@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohamed Khalfella <khalfella@gmail.com>

[ Upstream commit b1b1f4b12969130c0a6ec0cf0299460cb01e799c ]

If dma_chan_tx allocation fails, set dma_chan_rx to NULL after it is
freed.

Link: https://lore.kernel.org/r/20241227160841.92382-1-khalfella@gmail.com
Fixes: 8353813c88ef ("PCI: endpoint: Enable DMA tests for endpoints with DMA capabilities")
Signed-off-by: Mohamed Khalfella <khalfella@gmail.com>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index ef6677f34116e..d90c8be7371e0 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -251,7 +251,7 @@ static int pci_epf_test_init_dma_chan(struct pci_epf_test *epf_test)
 
 fail_back_rx:
 	dma_release_channel(epf_test->dma_chan_rx);
-	epf_test->dma_chan_tx = NULL;
+	epf_test->dma_chan_rx = NULL;
 
 fail_back_tx:
 	dma_cap_zero(mask);
-- 
2.39.5



