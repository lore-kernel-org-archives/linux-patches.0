Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0C062D8DD1;
	Mon,  2 Feb 2026 21:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770068823; cv=none; b=tpglGsnvEV0QhE8O943lLMQksC7xIWCvSrwQOTpN4jvzat2DzeOi4QmQvz4jafib6N3icdk6dgSNYvhebcMXLYPFWXY7vN8wEp4L/5IRP0YwNJC/GX3u4BWIi6nlYDWRAUeCUmOiu55e6d6tGoPJf6VAJUFSqVtC8wwdV7Al01k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770068823; c=relaxed/simple;
	bh=yMmc+gE/TeEIykfimutfHJ9UuR39OimXvChOlxkMweM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uCCMeYq9B9nRlvPMAqKgVstAlrhrBKcw5pgZJw9E7Q3wntp80Mdbdll+jpXb4ET+inuWdsCUTV4RxioJd5oZRUM2AxNpJrjh/XLgiL4NK4IK7IV/5f4D7mcxwp/kfHBKF5dcrcch6+s5WmgyQFjrhvHtErvH/7ajYCDdf/O5m14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p5w/LoB1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p5w/LoB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5565C19421;
	Mon,  2 Feb 2026 21:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770068822;
	bh=yMmc+gE/TeEIykfimutfHJ9UuR39OimXvChOlxkMweM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5w/LoB1rQ5xrffwr8k1ObXK2oeFKK28VJ5FMXY88XD6+8mjG+wqub7/K98M46BCX
	 tyPcQOlFWA92S1K6ljFMvNxGQMZdDyZXzRkr/WCPgwXf8tSMjxxdTpXz6zv0rvD5h9
	 92HQbNIPM9WVmlkVl+HZJRFm9dE1qOjekEwhapGZ6PtXNcNGGX/yXGAUJoTFTWu6W5
	 O39KN0I7hm+/kkq08SJ45R8wJQ7AVbjxN8KR+2HiN2puu6PSzsxb5XKBkmCZoCWtv6
	 QGg80vXdTmDO5Ofz3Ghm4JODTA7sE/IjH/Ffcv2C43Z9wM8QGrX6xVzsXefYCMV1BP
	 9IfCeMsBhelhg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Devyn Liu <liudingyuan@h-partners.com>,
	Yang Shen <shenyang39@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-spi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.6] spi: hisi-kunpeng: Fixed the wrong debugfs node name in hisi_spi debugfs initialization
Date: Mon,  2 Feb 2026 16:46:03 -0500
Message-ID: <20260202214643.212290-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260202214643.212290-1-sashal@kernel.org>
References: <20260202214643.212290-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Devyn Liu <liudingyuan@h-partners.com>

[ Upstream commit b062a899c997df7b9ce29c62164888baa7a85833 ]

In hisi_spi_debugfs_init, spi controller pointer is calculated
by container_of macro, and the member is hs->dev. But the host
cannot be calculated offset directly by this. (hs->dev) points
to (pdev->dev), and it is the (host->dev.parent) rather than
(host->dev) points to the (pdev->dev), which is set in
__spi_alloc_controller.

In this patch, this issues is fixed by getting the spi_controller
data from pdev->dev by dev_get_drvdata() directly. (dev->driver_data)
points to the spi controller data in the probe stage.

Signed-off-by: Devyn Liu <liudingyuan@h-partners.com>
Reviewed-by: Yang Shen <shenyang39@huawei.com>
Link: https://patch.msgid.link/20260108075323.3831574-1-liudingyuan@h-partners.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

In `struct spi_controller`, `dev` is at offset 0. So when `container_of`
is used with an incorrect pointer, it will calculate the "base" of the
spi_controller by subtracting 0 from the address - meaning it will use
`hs->dev` (pdev->dev) directly as if it were an spi_controller!

This would cause the access to `host->bus_num` (used in the snprintf for
creating debugfs directory name) to read from the wrong memory location.
Looking at struct spi_controller, `bus_num` is at around offset 72-80
bytes (after `dev` and `list`), so it would be reading random data from
the platform_device structure.

Let me analyze the severity:

1. **Best case**: Random garbage `bus_num` value → debugfs directory
   created with garbage name like "hisi_spi-1234567" or some nonsense
2. **Worst case**: Could potentially read out of bounds if pdev->dev is
   at the end of an allocation

The fix is simple, correct, and uses the proper method to retrieve the
spi_controller pointer.

## Summary Analysis

### 1. COMMIT MESSAGE ANALYSIS
The commit message clearly explains:
- The bug: `container_of` is incorrectly used - `hs->dev` points to
  `pdev->dev`, not `host->dev`
- The fix: Use `dev_get_drvdata()` to correctly get the spi_controller
  pointer

### 2. CODE CHANGE ANALYSIS
**The Bug:**
- `hs->dev = dev` where `dev = &pdev->dev` (platform device's device)
- `host = container_of(hs->dev, struct spi_controller, dev)` computes
  wrong offset
- Since `dev` is at offset 0 in spi_controller, this treats `pdev->dev`
  as if it were the spi_controller
- Accessing `host->bus_num` reads garbage from wrong memory location

**The Fix:**
- Uses `dev_get_drvdata(hs->dev)` to correctly retrieve the
  spi_controller pointer
- This works because `platform_set_drvdata(pdev, host)` was called in
  probe

**The fix is obviously correct:** It mirrors how other parts of the
driver (e.g., interrupt handler) retrieve the spi_controller.

### 3. CLASSIFICATION
- **Bug fix**: Yes, this fixes a real bug where incorrect memory is
  accessed
- **Category**: Bug fix for incorrect pointer calculation

### 4. SCOPE AND RISK ASSESSMENT
- **Lines changed**: Net -4 lines, very small change
- **Files touched**: 1 driver file
- **Risk**: Very low - changes a local variable initialization in a
  debugfs init function
- **Could break something else?**: No, this is a purely local fix

### 5. USER IMPACT
- **Who is affected**: Users of HiSilicon Kunpeng SoC SPI controllers
  with debugfs enabled
- **Severity**: The bug causes incorrect debugfs directory naming and
  potentially reads garbage memory
- **Hardware support**: This driver is for specific Kunpeng server SoCs

### 6. STABILITY INDICATORS
- Has "Reviewed-by:" tag from another Huawei engineer
- The fix is straightforward and mirrors existing patterns in the driver

### 7. DEPENDENCY CHECK
- The driver exists since v5.13, so this is relevant for 5.15.y, 6.1.y,
  6.6.y, etc.
- No dependencies on other commits - standalone fix

## Conclusion

This commit fixes a real bug in pointer calculation that causes
incorrect memory access. The fix is:
- Small and surgical (changes one variable initialization)
- Obviously correct (uses the same pattern as other code in the driver)
- Fixes a real bug (incorrect container_of usage)
- Low risk (only affects debugfs, but still fixes incorrect memory
  access)

The bug could cause reading garbage values or potentially undefined
behavior. While debugfs is primarily a debugging interface, the
incorrect memory access is still a real bug that should be fixed in
stable trees.

**YES**

 drivers/spi/spi-hisi-kunpeng.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/spi/spi-hisi-kunpeng.c b/drivers/spi/spi-hisi-kunpeng.c
index dadf558dd9c0c..80a1a15de0bc3 100644
--- a/drivers/spi/spi-hisi-kunpeng.c
+++ b/drivers/spi/spi-hisi-kunpeng.c
@@ -161,10 +161,8 @@ static const struct debugfs_reg32 hisi_spi_regs[] = {
 static int hisi_spi_debugfs_init(struct hisi_spi *hs)
 {
 	char name[32];
+	struct spi_controller *host = dev_get_drvdata(hs->dev);
 
-	struct spi_controller *host;
-
-	host = container_of(hs->dev, struct spi_controller, dev);
 	snprintf(name, 32, "hisi_spi%d", host->bus_num);
 	hs->debugfs = debugfs_create_dir(name, NULL);
 	if (IS_ERR(hs->debugfs))
-- 
2.51.0

