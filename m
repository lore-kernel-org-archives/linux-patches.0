Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D222C2C0F8E;
	Thu, 19 Feb 2026 02:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466673; cv=none; b=H62mRJvVuWhzOJC+08wA+ff1EgmH2tFvryQ4BL7I+LJQzZRhctUCTl5dFNHpWpuohJ77EbUeCsLm9Jtqy8q6vgZYLvCkFN99AdkBGCQ/Ag+IAVXC3QCsAf1G7UW17mL/brPamK+KMBJk1nIHis+lDOcE3FBvGjIxtqiiUZMJ/8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466673; c=relaxed/simple;
	bh=otP0+uOp9VFL6AME+3Z+1o09irTWa/J1aD/0/uL/ABE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EyfF+5zdwZNke6PyZukYuWFjPLZ9I3DND0ze+OUVP425CeaDXM0qSrlW7FzWlQeYdwetiTr1RuntVNhWx0zNsjxdmNBeVgLtKAPOtJRnLZdWfpRLe6ttUYGVcTSpF36A6Bs31BY/JwQqhf1gtd/jC4YfwU2FSXsZX8FnxEixMks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t2rBdHcV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t2rBdHcV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87272C19422;
	Thu, 19 Feb 2026 02:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466673;
	bh=otP0+uOp9VFL6AME+3Z+1o09irTWa/J1aD/0/uL/ABE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t2rBdHcV/fTCnW0/JBckGWC5kJjVwoDtuEY/gRkS1t4skQPQetKxwxcIlsU8d1pMM
	 8jQqoyJa09AB0u/NLmc1aUVR/r0LRYeS6R+E4Vpmkm6p0/Ag/RZQZsN6AddJrBCBNu
	 IYrpvi2veKfVnzByhgpV+cj1UycYYnBIwPBtu1vJL4NFeiQ8+xreAphfei6+8ukKDs
	 RFj08gUG/8zNKE19KgIVJytdfEWRnSqLSGOLmXmwp3rxScmtVM+RSiL8UHynOBeWza
	 WLpmhbsRx46HSSTjrxGnl2p+jLCAYeeU1VLqXa4Cz0k1KNYW12n3LySle/PSCwHuNr
	 t9UD9AVdu+J6A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Romain Gantois <romain.gantois@bootlin.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	mdf@kernel.org,
	linux-fpga@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] fpga: of-fpga-region: Fail if any bridge is missing
Date: Wed, 18 Feb 2026 21:03:44 -0500
Message-ID: <20260219020422.1539798-8-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Romain Gantois <romain.gantois@bootlin.com>

[ Upstream commit c141c8221bc5089de915d9f26044df892c343c7e ]

When parsing the region bridge list from the "fpga-bridges" device tree
property, the of-fpga-region driver will silently ignore bridges which fail
to be obtained, for example due to a missing bridge driver or invalid
phandle.

This can lead to hardware issues if a region bridge stays coupled when
partial programming is performed.

Fail if any of the bridges specified in "fpga-bridges" cannot be obtained.

Signed-off-by: Romain Gantois <romain.gantois@bootlin.com>
Link: https://lore.kernel.org/r/20251127-of-fpga-region-fail-if-bridges-not-found-v1-1-ca674f8d07eb@bootlin.com
Reviewed-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms the calling pattern: `fpga_region_program_fpga()` calls
`get_bridges()` which is `of_fpga_region_get_bridges()`. If bridges fail
to be obtained, the function proceeds to **disable bridges** (line 127)
and then **load FPGA image** (line 133). If a bridge was supposed to
decouple a region but was silently skipped, the FPGA programming
proceeds with the bridge still coupled - which can cause hardware
issues.

## Summary of Analysis

### What the bug is

The `of_fpga_region_get_bridges()` function iterates over bridges
specified in the device tree's "fpga-bridges" property. For each bridge,
it calls `of_fpga_bridge_get_to_list()` which can return:
- `0` = success
- `-EBUSY` = bridge in use
- `-ENODEV` = bridge not found (missing driver, invalid phandle)

The **old code** only checked for `-EBUSY` and silently ignored
`-ENODEV` and other errors. This means if a bridge driver is missing or
a phandle is invalid, the bridge is silently skipped and FPGA partial
reconfiguration proceeds without decoupling that bridge.

### Why it matters

FPGA bridges are isolation mechanisms. During partial reconfiguration,
bridges must be decoupled to prevent bus contention and hardware
corruption. If a bridge is silently skipped (not decoupled), partial
programming proceeds with the region still coupled, potentially causing
**hardware issues** - this is a data corruption / hardware damage
scenario.

### The fix

The change is minimal and surgical:
- `if (ret == -EBUSY)` → `if (ret)` (catches all errors, not just EBUSY)
- `return -EBUSY` → `return ret` (propagates the actual error code)
- Comment updates to match

This is a **2-line functional change** with comment updates. Very low
risk.

### Risk assessment

- **Scope**: Very small (2 functional lines changed)
- **Risk**: Low - the change makes the function stricter (fail on error
  instead of silently continue), which is the safe direction. The only
  risk is that some setups that previously "worked" (with silently
  missing bridges) would now fail to program the FPGA. But this is the
  correct behavior - programming without proper bridge decoupling is
  dangerous.
- **Dependencies**: None - this is a self-contained change
- **Code exists in stable**: The file has been present since v4.16
  (2017), so it exists in all active stable trees

### Stable criteria check

1. Obviously correct: Yes - checking all errors instead of just one
   specific error code
2. Fixes a real bug: Yes - silent bridge skip can lead to hardware
   issues during partial reconfiguration
3. Important issue: Yes - potential hardware damage/corruption
4. Small and contained: Yes - 2 functional lines changed in a single
   file
5. No new features: Correct - no new features added
6. Reviewed: Yes - "Reviewed-by: Xu Yilun <yilun.xu@intel.com>" (FPGA
   subsystem maintainer)

## Verification

- Read `of-fpga-region.c` (pre-patch version at lines 88-141): Confirmed
  old code only checks `ret == -EBUSY` at line 134
- Found `of_fpga_bridge_get_to_list` in `drivers/fpga/fpga-bridge.c`:
  Confirmed it can return `-ENODEV` (from `of_fpga_bridge_get`) or
  `-EBUSY`, not just `-EBUSY`
- Traced the call chain: `fpga_region_program_fpga()` →
  `region->get_bridges()` → `of_fpga_region_get_bridges()`. Confirmed at
  `fpga-region.c:119-120` that the callback is invoked before
  `fpga_bridges_disable()` at line 127 and `fpga_mgr_load()` at line 133
- Confirmed the file has existed since commit `ef3acdd820752` (v4.16,
  2017) - the bug has been present since file creation
- Confirmed the patch has `Reviewed-by: Xu Yilun` (FPGA subsystem
  maintainer)
- Confirmed the change is self-contained - no dependencies on other
  commits

**YES**

 drivers/fpga/of-fpga-region.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/fpga/of-fpga-region.c b/drivers/fpga/of-fpga-region.c
index 43db4bb77138a..caa091224dc54 100644
--- a/drivers/fpga/of-fpga-region.c
+++ b/drivers/fpga/of-fpga-region.c
@@ -83,7 +83,7 @@ static struct fpga_manager *of_fpga_region_get_mgr(struct device_node *np)
  * done with the bridges.
  *
  * Return: 0 for success (even if there are no bridges specified)
- * or -EBUSY if any of the bridges are in use.
+ * or an error code if any of the bridges are not available.
  */
 static int of_fpga_region_get_bridges(struct fpga_region *region)
 {
@@ -130,10 +130,10 @@ static int of_fpga_region_get_bridges(struct fpga_region *region)
 						 &region->bridge_list);
 		of_node_put(br);
 
-		/* If any of the bridges are in use, give up */
-		if (ret == -EBUSY) {
+		/* If any of the bridges are not available, give up */
+		if (ret) {
 			fpga_bridges_put(&region->bridge_list);
-			return -EBUSY;
+			return ret;
 		}
 	}
 
-- 
2.51.0

