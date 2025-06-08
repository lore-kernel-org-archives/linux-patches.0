Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB18205E3E;
	Sun,  8 Jun 2025 12:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749387339; cv=none; b=RFhyHo7Zu1nEPI5Sz13bt4GyiT5tnQGQohs9tFB1BCbp2kidk2ikGVgXnwr3ZR54U+uxtUI7EYGG6NKh8d4/Rc7mk3xAwJ09hWNsEtDbtuX78DJhQt50jxWMNGD1LgGrldnJaVSopHNo+Spi4rb8Z8FVJBR2lda7M4gjr+vt0Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749387339; c=relaxed/simple;
	bh=wi2FFkgVUWO5DXZMRdnfBRdsYEzBU63e/t7pIxETZBE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hwMKy4sbKIEXP1NSZ94PUXW3qbZKody71Q1desrDYHppVkJs2Rb3EQQdCrU12Av7yrgkRRJdG358HN31WnyCdTIO/fseOdGLfZGVHc0v0iCADuUsDEyPvh6+M+4KeOgm/+SEugtf7uEdKkRI6qQOky/3tFsP2Psdp9yFdo0ohY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dAA52QEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dAA52QEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0349AC4CEEE;
	Sun,  8 Jun 2025 12:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749387339;
	bh=wi2FFkgVUWO5DXZMRdnfBRdsYEzBU63e/t7pIxETZBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAA52QEM75bJ/Z0+3UH+E2HlkDelxYo4ftKVCPrBxTaTlUXHU/SrexQgaiCyA0U7O
	 y5N1pRUieeC3fbXl7zA+USh/qHZuvQSm102MUATVGfQFIiQTRMwhDCf2k720ZocL8z
	 ZYPUKlkqPBGzvkrGgepbScls2LvawQpF/+LGtDtNlUKzcP0VmeeO/YWrCh0jDm5myJ
	 Bwfuw8bQVMJ8EyD3IeIS646LrJMhSpTQiZcI0FOf7LWRmT6IqK3OrOu/4HJGeAiZC5
	 NiQyNlM9zM3ESwf+ekZrUXFtFobjzLUGPTmaOSJHzRiEphSlaM6901zP/yRR1FvNZ7
	 GDTIF/BTT2WcA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thomas Gessler <thomas.gessler@brueckmann-gmbh.de>,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Folker Schwesinger <dev@folker-schwesinger.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	michal.simek@amd.com,
	mani@kernel.org,
	u.kleine-koenig@baylibre.com,
	jernej.skrabec@gmail.com,
	krzysztof.kozlowski@linaro.org,
	marex@denx.de,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.6 6/8] dmaengine: xilinx_dma: Set dma_device directions
Date: Sun,  8 Jun 2025 08:55:25 -0400
Message-Id: <20250608125527.934264-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250608125527.934264-1-sashal@kernel.org>
References: <20250608125527.934264-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.93
Content-Transfer-Encoding: 8bit

From: Thomas Gessler <thomas.gessler@brueckmann-gmbh.de>

[ Upstream commit 7e01511443c30a55a5ae78d3debd46d4d872517e ]

Coalesce the direction bits from the enabled TX and/or RX channels into
the directions bit mask of dma_device. Without this mask set,
dma_get_slave_caps() in the DMAEngine fails, which prevents the driver
from being used with an IIO DMAEngine buffer.

Signed-off-by: Thomas Gessler <thomas.gessler@brueckmann-gmbh.de>
Reviewed-by: Suraj Gupta <suraj.gupta2@amd.com>
Tested-by: Folker Schwesinger <dev@folker-schwesinger.de>
Link: https://lore.kernel.org/r/20250507182101.909010-1-thomas.gessler@brueckmann-gmbh.de
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

## Analysis

This commit should be backported to stable kernel trees because it fixes
a critical functionality bug that prevents the Xilinx DMA driver from
working with important subsystems.

### The Problem
The commit addresses a fundamental issue where `dma_get_slave_caps()`
fails when called on Xilinx DMA channels. The code change shows that the
driver was not setting the `directions` field in the `dma_device`
structure:

```c
+       xdev->common.directions |= chan->direction;
```

This single line fix accumulates the direction capabilities from
individual channels (either `DMA_MEM_TO_DEV` or `DMA_DEV_TO_MEM`) into
the device-level `directions` bitmask.

### Why This Qualifies for Backporting

1. **Fixes Important User-Facing Bug**: The commit message explicitly
   states this prevents the driver from being used with IIO DMAEngine
   buffers, which is a significant functional regression affecting real
   users.

2. **Small and Contained Fix**: The change is minimal - just one line of
   code that sets a required field during channel probe. This has
   extremely low risk of introducing regressions.

3. **Critical Subsystem Integration**: Without this fix,
   `dma_get_slave_caps()` calls fail with `-ENXIO`, breaking integration
   with any subsystem that queries DMA capabilities (like IIO).

4. **Clear Root Cause**: The fix directly addresses the root cause - the
   missing `directions` field that the DMAEngine core requires to be
   set.

5. **No Architectural Changes**: This doesn't introduce new features or
   change driver architecture; it simply provides required capability
   information that was missing.

### Comparison to Reference Commits
This closely matches **Similar Commit #1** (marked YES) which also fixed
a missing capability flag (`DMA_CYCLIC cap_mask bit`) that prevented
proper DMA channel allocation. Both commits:
- Fix missing capability declarations
- Are small, single-line changes
- Address integration failures with other subsystems
- Have minimal regression risk

The commit also mirrors **Similar Commit #2** (marked YES) which fixed
incorrect struct usage in the same driver - both address functional
correctness issues in the Xilinx DMA driver.

### Risk Assessment
The risk is minimal because:
- The change only affects the capability reporting mechanism
- It doesn't modify any data paths or transfer logic
- The direction values being OR'd together are already correctly set
  per-channel
- Failure mode is obvious (capability queries will work instead of
  failing)

This is a textbook example of a stable tree candidate: it fixes an
important bug affecting real users with a minimal, low-risk change that
doesn't introduce new functionality.

 drivers/dma/xilinx/xilinx_dma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dma/xilinx/xilinx_dma.c b/drivers/dma/xilinx/xilinx_dma.c
index 0a3b2e22f23db..14c4c5031b556 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2900,6 +2900,8 @@ static int xilinx_dma_chan_probe(struct xilinx_dma_device *xdev,
 		return -EINVAL;
 	}
 
+	xdev->common.directions |= chan->direction;
+
 	/* Request the interrupt */
 	chan->irq = of_irq_get(node, chan->tdest);
 	if (chan->irq < 0)
-- 
2.39.5

