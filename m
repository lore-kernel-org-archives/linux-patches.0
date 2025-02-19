Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195922AE74;
	Wed, 19 Feb 2025 09:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956506; cv=none; b=B7oLwYpB4VaUqav8GRHSqKdZ3JDlc1ZfgUf0n9e3/NMIu1f2ZczqB5Ccgp1VLXrON2LhWHcXgzk12c82mrHGhgTHYtctoh+ycsEf4x1LnFsOtl+olgzKfja5RvhwbJmB9NCNMZEbdKfOkdi5u6oNW+BaHtjeNPlHYjpVUn9Rzqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956506; c=relaxed/simple;
	bh=BwLxGp7WYbN2oB8xdi+OI0IVN1uWqpCbshXU7cw24IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ejmpe1UHB5DM078i14Sm6hhZgUDiNfXZCX7LFbmQWDt9eYUj+BBN11xXUejpJNe0Bu8mqx76uL7fadctYJvtySTfDszOCkk/qAdmhDyLOk4n5tc+qisV8kxRzqBqeD0BhGZJuDRggwpSVY7K6g+uZjC4zByyDFU7Q/M+9B8fZdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lqY+blUe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lqY+blUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90436C4CED1;
	Wed, 19 Feb 2025 09:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956506;
	bh=BwLxGp7WYbN2oB8xdi+OI0IVN1uWqpCbshXU7cw24IA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lqY+blUe/riTtIgTlsJqEqrHQJzH3ldi3P27yPOCtIOhog4O70B0wE7UND/0T2dqf
	 vaiQ3aT/tgj+tJTISNp+Ofy/WHkuteBcxWDv68P4qFIMy+gUCqBKh01Y4URS7++PhM
	 Pv6vRVNVLU2MvO9QbjrXFSHrUGk4CfFc9FDHEoPk=
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
Subject: [PATCH 6.1 201/578] PCI: endpoint: pci-epf-test: Set dma_chan_rx pointer to NULL on error
Date: Wed, 19 Feb 2025 09:23:25 +0100
Message-ID: <20250219082700.869998509@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2e8a4de2ababd..be10d7b976e94 100644
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



