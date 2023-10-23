Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD06171C3
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/REk5yl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EA1C433C9;
	Mon, 23 Oct 2023 11:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061817;
	bh=DN+m5Td9aXnqBU26SlBbzU0HZy6sMk9V9bbI0rr57Gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/REk5yl+vrKORSzj9EZNsH7BQU5OZ/UR8msAIABwjZa7+ngKYneWT5Dn9Lyf84+N
	 OKAItTheNKuEsnzGgf+jxh1q8QwXwt5SKV+SrM9vHFOY1dWl8uJWbtkkpoB7YQzz2K
	 0ejBQyvo8BdOIS4mJgfJBQEwzwXGnbOxu3AWKiwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bibek Kumar Patro <quic_bibekkum@quicinc.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 174/202] mtd: rawnand: qcom: Unmap the right resource upon probe failure
Date: Mon, 23 Oct 2023 12:58:01 +0200
Message-ID: <20231023104831.562937635@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibek Kumar Patro <quic_bibekkum@quicinc.com>

commit 5279f4a9eed3ee7d222b76511ea7a22c89e7eefd upstream.

We currently provide the physical address of the DMA region
rather than the output of dma_map_resource() which is obviously wrong.

Fixes: 7330fc505af4 ("mtd: rawnand: qcom: stop using phys_to_dma()")
Cc: stable@vger.kernel.org
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bibek Kumar Patro <quic_bibekkum@quicinc.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230913070702.12707-1-quic_bibekkum@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/qcom_nandc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/qcom_nandc.c
+++ b/drivers/mtd/nand/raw/qcom_nandc.c
@@ -2996,7 +2996,7 @@ err_nandc_alloc:
 err_aon_clk:
 	clk_disable_unprepare(nandc->core_clk);
 err_core_clk:
-	dma_unmap_resource(dev, res->start, resource_size(res),
+	dma_unmap_resource(dev, nandc->base_dma, resource_size(res),
 			   DMA_BIDIRECTIONAL, 0);
 	return ret;
 }


