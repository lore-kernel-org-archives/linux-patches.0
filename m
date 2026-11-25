Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622341;
	b=TZHMHn11murl9bDsyww6uv8FjrfzL1w8eOjybWfYyp5P5u3yIj93h7qBUYllegMXXpLg
	 tCI7aEEK4EkxklSsaCmrj5K7cwZXScFOWS/8KOCuPvINL9CynBVEtVE1F26/xjHu1umGP
	 YfYVN8jeVHDoS7LAqmQ9XzK3JWIfvYxRvNjXf/oNhaWNcleNn2U5rvmjShkra7eHgdndM
	 IEa8XgZKRzM0OXKJMpBQsumpcDDYqcnNFFMXXliIrk8FQSr8uNZGPqkSS8O+9f/cMHX3R
	 CtbKN6V9ezdg2RCjakReBXXfcwW5Rv99GQos0IAdSt5PQTOWIfuLRtzWNlhEKBcyXWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=THk/GBMsz2MKJmuoJNMKK9qO6j29hP/R1b2s2ag0Qno=;
	b=O6MIuZ1ZFpQvFnZXWT2HZjN/znJa0gkoUOUMYbhi4kxFpspVwC+5/GF1tOcgzp6KkCOF
	 eD1lJimgKcNLmDwZofSyUaOIuFKp3wj6VOvlAhLTiYi/s7tIzPV76CXfDvh+LXgyqZJdk
	 u/DQyzo7tJnZFhuypdlwSL3GLonuzH5pk9knD9s7ALfePEK3Fwf3UDiEkq2NYeTgfCCl4
	 fF4jJVm3Ko1/Y78/xpzfDav3lJMFBcwmFmbUMKjFqXULHZyQ3PDxLRJzJtbsu/kPa1j+t
	 wxc7yMInWvJ7wwjYHgrbplJE1JBE+Z+CKM4G5cN91QXH50Wz+/Sft+ZSLuAIAe5AD8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hOOYJ068;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7F4606A336;
	Wed, 25 Nov 2026 15:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hOOYJ068
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEFB61F000E0;
	Wed, 25 Nov 2026 15:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622341;
	bh=THk/GBMsz2MKJmuoJNMKK9qO6j29hP/R1b2s2ag0Qno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hOOYJ0685D00X1Rx3Rxp+MawVdW3RS4pk0l3hqaOvx7Hcmto+mONoI7Ix4/aVOgso
	 4Z+DP/kb6Fp3/NQHuZjJ9TfvZX2bLkO7As80MgojU3M5IOQ7tyEhWeNohXkZ4FrDH4
	 S89+PIfiNsH9TxuKdwYbbKGv6/PQ0cikOPcqBZR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Golla Nagendra <nagendra.golla@amd.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 508/990] dmaengine: zynqmp_dma: Fix PM rollback on sw_desc_pool alloc failure
Date: Wed, 25 Nov 2026 15:31:15 +0100
Message-ID: <20261125143833.999026424@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Golla Nagendra <nagendra.golla@amd.com>

[ Upstream commit f2f44b952ea6e0c600e92ea21fcaa83cafeedf6e ]

If sw_desc_pool allocation fails after pm_runtime_resume_and_get()
succeeds in zynqmp_dma_alloc_chan_resources(), the error path returns
without dropping the runtime PM reference.

Route that failure path through err_pm so the runtime PM reference is
balanced before returning the error.

Fixes: 8982d48af36d ("dmaengine: zynqmp_dma: Fix PM reference leak in zynqmp_dma_alloc_chan_resourc()")
Signed-off-by: Golla Nagendra <nagendra.golla@amd.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260814045616.1661199-2-nagendra.golla@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
[ sashal: Kept the older kcalloc() allocation line in the context instead of upstream's kzalloc_objs(), since that helper doesn't exist here; the fix is otherwise identical. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/zynqmp_dma.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/xilinx/zynqmp_dma.c b/drivers/dma/xilinx/zynqmp_dma.c
index 1f6bb492be6af..7cc5079511188 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -484,8 +484,10 @@ static int zynqmp_dma_alloc_chan_resources(struct dma_chan *dchan)
 
 	chan->sw_desc_pool = kcalloc(ZYNQMP_DMA_NUM_DESCS, sizeof(*desc),
 				     GFP_KERNEL);
-	if (!chan->sw_desc_pool)
-		return -ENOMEM;
+	if (!chan->sw_desc_pool) {
+		ret = -ENOMEM;
+		goto err_pm;
+	}
 
 	chan->idle = true;
 	chan->desc_free_cnt = ZYNQMP_DMA_NUM_DESCS;
@@ -517,6 +519,10 @@ static int zynqmp_dma_alloc_chan_resources(struct dma_chan *dchan)
 	}
 
 	return ZYNQMP_DMA_NUM_DESCS;
+
+err_pm:
+	pm_runtime_put_autosuspend(chan->dev);
+	return ret;
 }
 
 /**
-- 
2.53.0



