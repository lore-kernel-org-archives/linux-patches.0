Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D021413DB92;
	Tue, 27 Feb 2024 13:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041618; cv=none; b=EcW/EYBXGIotNYUbzMccROkndq9+dtRwiptyixGw80GN5/PJIxtl0sd04oJ75ByfHRYeMIo9Ca6HQLOX5u30VTXaBCGX0WZTJ/BpUCE3uRRjaX61ovtj3rdciRK6G8zXWcXLlpU/97f/YjL2ENerZNkWEihVCHtnivT0uYzTvSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041618; c=relaxed/simple;
	bh=Nx1sSlX0N6v1As0y1KW5REaIqr5rmOk9973/wXfWm5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OeDcRYTp65qGJTZGfRZtDECw+DUu2mmkp5Z4clIP7SDSoUxdbaYUUQFlsaesRKIqsbNP3TKXJ7rWBLRMB5RZn7ZgbBbKj2mTajzbcyS/seVFjgEX6d6C+KTDT/t7B2tBDF+HePTPkPY8WNCUVwHJE5f3fggsdKyJG+F5BNHgXeg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g3DXsqaI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g3DXsqaI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61069C433F1;
	Tue, 27 Feb 2024 13:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041618;
	bh=Nx1sSlX0N6v1As0y1KW5REaIqr5rmOk9973/wXfWm5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3DXsqaIapHloRshuoEero1EnskltcwfL6g/GeOgnTCSXC7H9v1ubw22pv1nrYvos
	 1mfjeFp8zPaRjUJzn+4++Yy4sKI4oUvN8nKz8+3htb/0FG9jxuOImIcouZSHz5j0bc
	 a19cnPa26YP/JLbcAipJcaydSInOoSeTEkFG3U90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/299] dmaengine: fsl-qdma: increase size of irq_name
Date: Tue, 27 Feb 2024 14:22:03 +0100
Message-ID: <20240227131626.232799033@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit 6386f6c995b3ab91c72cfb76e4465553c555a8da ]

We seem to have hit warnings of 'output may be truncated' which is fixed
by increasing the size of 'irq_name'

drivers/dma/fsl-qdma.c: In function ‘fsl_qdma_irq_init’:
drivers/dma/fsl-qdma.c:824:46: error: ‘%d’ directive writing between 1 and 11 bytes into a region of size 10 [-Werror=format-overflow=]
  824 |                 sprintf(irq_name, "qdma-queue%d", i);
      |                                              ^~
drivers/dma/fsl-qdma.c:824:35: note: directive argument in the range [-2147483641, 2147483646]
  824 |                 sprintf(irq_name, "qdma-queue%d", i);
      |                                   ^~~~~~~~~~~~~~
drivers/dma/fsl-qdma.c:824:17: note: ‘sprintf’ output between 12 and 22 bytes into a destination of size 20
  824 |                 sprintf(irq_name, "qdma-queue%d", i);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/fsl-qdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/fsl-qdma.c b/drivers/dma/fsl-qdma.c
index e4c293b76e050..781a3180baf2a 100644
--- a/drivers/dma/fsl-qdma.c
+++ b/drivers/dma/fsl-qdma.c
@@ -805,7 +805,7 @@ fsl_qdma_irq_init(struct platform_device *pdev,
 	int i;
 	int cpu;
 	int ret;
-	char irq_name[20];
+	char irq_name[32];
 
 	fsl_qdma->error_irq =
 		platform_get_irq_byname(pdev, "qdma-error");
-- 
2.43.0



