Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054843;
	b=5b1+Lu7ymcHzCxD18qiIK4w0LEpwp+t8OvwRB4qYc+fxxE2vM9f15XdLL806vMFTmQ7q
	 5ApMZ+vehGus3oujHZ7u+gRKDSsARB/IusbbGmApHldYoDXjzAHi6tmRrZFu+VSNWIprT
	 zsDq7umjkFMjMKJcfZp2W0JsWPiNNj2IK/aYrJrIZ/ZZd7b/rOop3k26Meuz2R2xx1/Uo
	 o0DPGILQY7qRM7iHgfJjELM5ZcoB3HAUrv0p+FuV1BKOHt2vNrwJRfQM3948ydpMGVKqk
	 u6ApzKQa2PKA+UTvankQtAr4hUN6jL/nMIcKRa1Y14Pb9TX0Mwf3beVlEdPl+vUL4Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054843;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ykOGaU0nbfdUT3j1EzYiyvPfPdsCQUyRWUHZ7zJxino=;
	b=GOo0hTT390/chvKbKoxGflBHXwyGAKBl6CRnAA1nBM91I5aJCUcoK60iUwRNNq7U/PZo
	 ashTNo4varngHHPOBVv/itWFjo69a7HAbQQvw+omoWZL1s2LZji7IXr3VBe2udtMaLQaN
	 F5XNtrMoBR/VHVuqHSDVFS5tsmC1C3wkwqUCyjC5t/i1ESeW4AHxKLUtl0fqfrOr188YE
	 tiDTKzJtWBkZ8Z7B91UwzokoJVmGJOMBqme/DLhqgHDMYC6NmwNEzIsnj3c2EoXMMtPsM
	 8Lk8sKOXSzDXE1GwDZtsDanLDoXgbY77zuIVcuzXltQVuXkdMFRdhgFRJEw5SWVXgJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uGl3RD1z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAFF606A325;
	Thu, 19 Nov 2026 02:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uGl3RD1z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 957F91F000C4;
	Thu, 19 Nov 2026 02:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054843;
	bh=ykOGaU0nbfdUT3j1EzYiyvPfPdsCQUyRWUHZ7zJxino=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uGl3RD1zQC2wnB9VHlhllePss4Az/6Lhv7O6cWn5ijsmf/39nfHiw8BuObiaPlgaW
	 MXCB4hyeiUtuB5ze51fyY5BRpEUVzvVA63u3UwChkeZv3foGPk3A+cUKSovnpBGyqE
	 p6biHoFH760lqFyOYmhYm0pdkS64Ei+n0ZfXVVpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1417/2214] dmaengine: zynqmp_dma: drop redundant label
Date: Wed, 18 Nov 2026 15:51:33 +0100
Message-ID: <20261118150107.911995759@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit 08f04d5ab868bc28d3115f7406499e8e5d1d1765 ]

Commit 3f30db282c28 ("dmaengine: zynqmp_dma: Fix chan probe/remove error
handling") dropped the use of err_disable_pm label causing warning:

drivers/dma/xilinx/zynqmp_dma.c: In function ‘zynqmp_dma_probe’:
drivers/dma/xilinx/zynqmp_dma.c:1171:1: error: label ‘err_disable_pm’ defined but not used [-Werror=unused-label]
 1171 | err_disable_pm:

Drop it

Fixes: 3f30db282c28 ("dmaengine: zynqmp_dma: Fix chan probe/remove error handling")
Reviewed-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260903170357.1711462-1-vkoul@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/zynqmp_dma.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma/xilinx/zynqmp_dma.c b/drivers/dma/xilinx/zynqmp_dma.c
index efaef1d7e37dc..91cded336257a 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -1134,7 +1134,6 @@ static int zynqmp_dma_probe(struct platform_device *pdev)
 
 free_chan_resources:
 	zynqmp_dma_chan_remove(zdev->chan);
-err_disable_pm:
 	if (!pm_runtime_enabled(zdev->dev))
 		zynqmp_dma_runtime_suspend(zdev->dev);
 	pm_runtime_disable(zdev->dev);
-- 
2.53.0



