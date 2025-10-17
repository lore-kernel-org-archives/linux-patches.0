Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DDF32C92D;
	Fri, 17 Oct 2025 15:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713928; cv=none; b=CcA0rZ1ynWLHqpjQJSs01hJBLBa8w29w+9UAOA+fHO94VdjRHNPsuea21TixFbVdy5OM+d3kzVeohg4EKvktzdYpHzsAxAlDljza7hra9j/qxm2sQPI1mUlGAInx/rzzTFSXNBBCDhp/7gQC3u2df40b7rrGgA+67pLm1n3+tUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713928; c=relaxed/simple;
	bh=aA1gD+eUIZuQGfShKMoVYXE2rzV59d892hfGXJN0ET0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W/1BmGmRtj/70qdVHlv8NJpA5UzrcPsKJZ2W0X1Kq/tu/cIq+Whd4ys76BD9Z+0VnNh7sAK1SrWEQC4UccC53uPhFhJ7ChWIOUTqfvqe2BD7O9bepV6/+Clphzu1+LQsVtsgD7w5V3WoLoiWxUcB+7aw3vek7Q5qrWdnAXDR8tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BFku7WN1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BFku7WN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882A2C4CEE7;
	Fri, 17 Oct 2025 15:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713927;
	bh=aA1gD+eUIZuQGfShKMoVYXE2rzV59d892hfGXJN0ET0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BFku7WN1W9VVubOSR0/5lsAFqcOQ2dSarZ7+GtYf2XKOLNcYElSgnc6G9XvHN1QT6
	 qrrJkNc2bY8falZTlUWb2BjZOZ41hoiWAZmxOXUs+YXlkun7/8dr99NzYBhyLwHgnc
	 nIKUTWzGUHW4ZvldbHEkVfLJdJ5wY4kD1F1Fd6I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jiang <jiangwang@kylinos.cn>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 169/201] PCI: endpoint: Remove surplus return statement from pci_epf_test_clean_dma_chan()
Date: Fri, 17 Oct 2025 16:53:50 +0200
Message-ID: <20251017145140.948222358@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Jiang <jiangwang@kylinos.cn>

[ Upstream commit 9b80bdb10aee04ce7289896e6bdad13e33972636 ]

Remove a surplus return statement from the void function that has been
added in the commit commit 8353813c88ef ("PCI: endpoint: Enable DMA
tests for endpoints with DMA capabilities").

Especially, as an empty return statements at the end of a void functions
serve little purpose.

This fixes the following checkpatch.pl script warning:

  WARNING: void function return statements are not generally useful
  #296: FILE: drivers/pci/endpoint/functions/pci-epf-test.c:296:
  +     return;
  +}

Link: https://lore.kernel.org/r/tencent_F250BEE2A65745A524E2EFE70CF615CA8F06@qq.com
Signed-off-by: Wang Jiang <jiangwang@kylinos.cn>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Stable-dep-of: 85afa9ea122d ("PCI: endpoint: pci-epf-test: Add NULL check for DMA channels before release")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -291,8 +291,6 @@ static void pci_epf_test_clean_dma_chan(
 
 	dma_release_channel(epf_test->dma_chan_rx);
 	epf_test->dma_chan_rx = NULL;
-
-	return;
 }
 
 static void pci_epf_test_print_rate(struct pci_epf_test *epf_test,


