Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6F91A5BA3;
	Sun,  8 Jun 2025 12:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749387362; cv=none; b=pckNjh6BdJiavel6DOtqcI+T4QU0C2cXr1DA1O1nQecVdtE9BeiW2868Zroptr5T6FcXdUFVRGKre8NjP3NN5bhcHFzFwr6itoNGE/4qP4t220XTODcxiPt0bAENfWrwoZLtz/HFQFNdEhmjliyqHBQYZtJJaCmgrTmbuVBpUVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749387362; c=relaxed/simple;
	bh=0dpD4wPtp2yxPm6zasr3KeQyM/OJvAcKBJavJYd7pRc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y8EPrpp59iW1SkJvG0R15lRG+QlrLqRuuvfTBgKuk+OgNmTHc89LI36egLzKsGKNxXWJx9sc6fxzTlYzKwRT/XcZE9+SAqGTjmZ0c3CFyWHP4LQ1XPhbasLh4052R1lmBn4BvqKryT1erR+p/ymJRjKf/IZUoIl4d66BfuxOzdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j3Ero/PJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j3Ero/PJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12AF5C4CEEF;
	Sun,  8 Jun 2025 12:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749387362;
	bh=0dpD4wPtp2yxPm6zasr3KeQyM/OJvAcKBJavJYd7pRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3Ero/PJxVIcLPH1L1FWRcXnxmmVULX97PVbJ4xWisbKbI9yoN2lSb+WZqbCyPmhw
	 hMcE7S7L0HS5f3XNH75rnefbSr9/G8QoBzJ+kmzK/ufQGYZgF7nzei67N5xnhdDEo4
	 ufhGuCLOyFtFrJ2PhsZNo81KmITxdZEiCQDfL5qYbKvtZvCLbOxRCJtKJQ413kdMRG
	 bykw7/dfVuJY9Gqt1658p0XW23lLsD/wxndU9oRWiD+JlUYbCxPgG4MIvK/lMk3Rb3
	 32Rp/obzTrwUH1WdT8JHAevv7VCVVMyN5J6foiReyIArLOJok7Kz2U9TuhXujrNoSs
	 iOmtXVqHVP+zA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thomas Gessler <thomas.gessler@brueckmann-gmbh.de>,
	Suraj Gupta <suraj.gupta2@amd.com>,
	Folker Schwesinger <dev@folker-schwesinger.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	michal.simek@amd.com,
	jernej.skrabec@gmail.com,
	marex@denx.de,
	mani@kernel.org,
	u.kleine-koenig@baylibre.com,
	krzysztof.kozlowski@linaro.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 3/3] dmaengine: xilinx_dma: Set dma_device directions
Date: Sun,  8 Jun 2025 08:55:55 -0400
Message-Id: <20250608125556.934550-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250608125556.934550-1-sashal@kernel.org>
References: <20250608125556.934550-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.185
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
index edc2bb8f0523c..48ac51447baee 100644
--- a/drivers/dma/xilinx/xilinx_dma.c
+++ b/drivers/dma/xilinx/xilinx_dma.c
@@ -2861,6 +2861,8 @@ static int xilinx_dma_chan_probe(struct xilinx_dma_device *xdev,
 		return -EINVAL;
 	}
 
+	xdev->common.directions |= chan->direction;
+
 	/* Request the interrupt */
 	chan->irq = irq_of_parse_and_map(node, chan->tdest);
 	err = request_irq(chan->irq, xdev->dma_config->irq_handler,
-- 
2.39.5

