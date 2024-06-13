Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A1A12C47D;
	Thu, 13 Jun 2024 12:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282244; cv=none; b=eUzCqvVLlVXtVhRx8T4rlHwTe5s3ccdIHoCSFV1/O0retqrBE9n1hZ0WjJO2B4ENYd/z7SvQdAbDEitaA9bUS5oMa9Gx2IA+hpklbx5G0BQDZ2tdzmXUCPQOWOklP3RaRMK9TN0dyEhP6yv4HK7Dx1aSxIm/w+XjNUrx3COGtwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282244; c=relaxed/simple;
	bh=91bgWSnv3qCUucN6FIIIIWcfu3shJ6QvvEl9gZ3q8ak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBfu4vrg15FgE2olvlYEEG2iSzO5t/kVVNwoi2uGvAR/kYNn9PYT/dQBv48AZxIx023gO4xEPZ6PqiLootoDjeUExH3VY49hO+fiVGGhbras4utvRibDutRdqyCQh8lYtbpyy2P5LFnH8mQn65VzFPCqCnL6QyRWS/yxQjARLm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6G4kdf4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6G4kdf4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC75C32786;
	Thu, 13 Jun 2024 12:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282243;
	bh=91bgWSnv3qCUucN6FIIIIWcfu3shJ6QvvEl9gZ3q8ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6G4kdf4SN8ONCDlxzm7MjGH1aE/QsHoL34Fj10T4dbIA1gy8jAQL8HR+zBpJb31e
	 IWu4eW3nhDIKt4j92qK3KgQaOtFJM4r4Cu7QHiA/v/MVsHVBs7LUmHa+AeONGngKaB
	 z4SE3sp5cOAL5TXIWKQmVZohrYcE7/kSyYOL3rHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 184/402] dmaengine: idma64: Add check for dma_set_max_seg_size
Date: Thu, 13 Jun 2024 13:32:21 +0200
Message-ID: <20240613113309.326818205@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 2b1c1cf08a0addb6df42f16b37133dc7a351de29 ]

As the possible failure of the dma_set_max_seg_size(), it should be
better to check the return value of the dma_set_max_seg_size().

Fixes: e3fdb1894cfa ("dmaengine: idma64: set maximum allowed segment size for DMA")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240403024932.3342606-1-nichen@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idma64.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idma64.c b/drivers/dma/idma64.c
index af8777a1ec2e3..89e4a3e1d5198 100644
--- a/drivers/dma/idma64.c
+++ b/drivers/dma/idma64.c
@@ -594,7 +594,9 @@ static int idma64_probe(struct idma64_chip *chip)
 
 	idma64->dma.dev = chip->sysdev;
 
-	dma_set_max_seg_size(idma64->dma.dev, IDMA64C_CTLH_BLOCK_TS_MASK);
+	ret = dma_set_max_seg_size(idma64->dma.dev, IDMA64C_CTLH_BLOCK_TS_MASK);
+	if (ret)
+		return ret;
 
 	ret = dma_async_device_register(&idma64->dma);
 	if (ret)
-- 
2.43.0



