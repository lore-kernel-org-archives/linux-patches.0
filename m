Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BAD1A6195;
	Tue, 30 Jul 2024 16:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358501; cv=none; b=YRXMJf2FH+X2GHK0HqbiUVGd9QXOQLbGQDjdwdsyx9OktzN7VClF56IUlK1GrXY1Rf2oW/iO2A1EaIUOFJ8CEwUx9HiYk+5Erhd0Cz4yZZYkbRyc1xRI3UGWgN2YB3RM3mbte5SA1Y7eT6N7Ta+9ogI5gU+n8DSnFzyvuC/Fo34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358501; c=relaxed/simple;
	bh=stGjzTgz82dGtrAbk8ULELLeduRzIADW3GAXxh/ahcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYaVSrHGztBCb9bbFbEtQlNuPGXzCh5MZf9tdB+5jmSFVpVm5ol2KXTmHKJ9YzgdBgF9xUOshYGKi2PJCzME5L54qJwVgxWudc6opoUQOpI+08tTUqIyRF7L932jUkRWM/oQF9boIHXqe17jHmvwyWTR+h8cZWK7Qhiog+nxUNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQ0WS6Xf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQ0WS6Xf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A93C4AF0A;
	Tue, 30 Jul 2024 16:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358501;
	bh=stGjzTgz82dGtrAbk8ULELLeduRzIADW3GAXxh/ahcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQ0WS6XfUauGK8QoKHGS8Z/1vcdH4EGZ7DtL0Cqxv5MJsyQ5q2Pu9qwcQPj0b5g21
	 yusQ6iWDWg9IfUEGAosJIlU6t373xTazRKTAqUmFX+751fGkClB3vALPubj3QpBAiU
	 oGmMf8yNZ3cflUhxEIcCcnRq6aX4EZ82RWC0yTYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Jai Luthra <j-luthra@ti.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 396/440] dmaengine: ti: k3-udma: Fix BCHAN count with UHC and HC channels
Date: Tue, 30 Jul 2024 17:50:29 +0200
Message-ID: <20240730151631.271053980@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vignesh Raghavendra <vigneshr@ti.com>

[ Upstream commit 372f8b3621294173f539b32976e41e6e12f5decf ]

Unlike other channel counts in CAPx registers, BCDMA BCHAN CNT doesn't
include UHC and HC BC channels. So include them explicitly to arrive at
total BC channel in the instance.

Fixes: 8844898028d4 ("dmaengine: ti: k3-udma: Add support for BCDMA channel TPL handling")
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Jai Luthra <j-luthra@ti.com>
Tested-by: Jayesh Choudhary <j-choudhary@ti.com>
Link: https://lore.kernel.org/r/20240607-bcdma_chan_cnt-v2-1-bf1a55529d91@ti.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ti/k3-udma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/ti/k3-udma.c b/drivers/dma/ti/k3-udma.c
index 82e7acfda6ed0..e323e1a5f20f3 100644
--- a/drivers/dma/ti/k3-udma.c
+++ b/drivers/dma/ti/k3-udma.c
@@ -4423,7 +4423,9 @@ static int udma_get_mmrs(struct platform_device *pdev, struct udma_dev *ud)
 		ud->rchan_cnt = UDMA_CAP2_RCHAN_CNT(cap2);
 		break;
 	case DMA_TYPE_BCDMA:
-		ud->bchan_cnt = BCDMA_CAP2_BCHAN_CNT(cap2);
+		ud->bchan_cnt = BCDMA_CAP2_BCHAN_CNT(cap2) +
+				BCDMA_CAP3_HBCHAN_CNT(cap3) +
+				BCDMA_CAP3_UBCHAN_CNT(cap3);
 		ud->tchan_cnt = BCDMA_CAP2_TCHAN_CNT(cap2);
 		ud->rchan_cnt = BCDMA_CAP2_RCHAN_CNT(cap2);
 		ud->rflow_cnt = ud->rchan_cnt;
-- 
2.43.0



