Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7E91FF5E3;
	Sat, 14 Feb 2026 00:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771030724; cv=none; b=G7Xzs1Pvun4TH8E3N/8mm+kjcEdjhIWYB6h/8PaIiPEpdL6EA7642lqR6yy8+M7LuKrHla8uHLBC35cYEPJ3cb6vPu3lDceclFsb1viDstd8cPjQQOXqKvm5hADiU3v47nM0JTjet54K9Twrn+HA1iOKinBbMsEOQMMPUMTYsuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771030724; c=relaxed/simple;
	bh=rM84Vu3aZRI3MGaYNq8NQGpcoNuGw7GEZzVwqJyg4RA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kC8HBt1KhQjZOqKKiSTwJRQFHdJho0983GJhCt3PgSUxkK6VBgt6O3GZihqpYjBsRsZhXgODw/Y8TlfKrzo4Au0m+gZOisN1ZmEthXkZHiU9WXVIdHSuNfTrSIpbiLdci9QhuoWrkEKsJvwGpfTDgoTfFwix/3J6OQFnv8cqLfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eG/vwvGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eG/vwvGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3AEFC116C6;
	Sat, 14 Feb 2026 00:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771030724;
	bh=rM84Vu3aZRI3MGaYNq8NQGpcoNuGw7GEZzVwqJyg4RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eG/vwvGVlFFBdy6Rq6n19EKRLEKbzUYYghKKS0dtLnS9SKjGas2B0t6pp6X/dXGo2
	 JDGkiBPzCK2u2G9UijJSxg/Xef9WO55W1btJAW2tvRbH8kh3Z23MMs8r+z6/wUZasg
	 5Qv/24TEbWK/v8J0iS49ICBa+ysuZk3ywGbf8filTTxigU3kS5kS9+3+SSZtp3T4Nt
	 KwGEPVUdEdK55QKVaRAKuzvKNo6f4TJ6t+vV92af1e6NdJIa26OSo7jwZMVBb7IR6s
	 2MnhHpPgKM2jzTgggpF6a5my9oesgs0Cl67DDFElVfJd2RZY2DQ2t8X0TOd6VjZbpd
	 Z3TsArguC/FZA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tomas Melin <tomas.melin@vaisala.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	neal.frager@amd.com,
	conor.dooley@microchip.com,
	yelangyan@huaqin.corp-partner.google.com,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.19-6.12] Revert "arm64: zynqmp: Add an OP-TEE node to the device tree"
Date: Fri, 13 Feb 2026 19:58:15 -0500
Message-ID: <20260214005825.3665084-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214005825.3665084-1-sashal@kernel.org>
References: <20260214005825.3665084-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tomas Melin <tomas.melin@vaisala.com>

[ Upstream commit c197179990124f991fca220d97fac56779a02c6d ]

This reverts commit 06d22ed6b6635b17551f386b50bb5aaff9b75fbe.

OP-TEE logic in U-Boot automatically injects a reserved-memory
node along with optee firmware node to kernel device tree.
The injection logic is dependent on that there is no manually
defined optee node. Having the node in zynqmp.dtsi effectively
breaks OP-TEE's insertion of the reserved-memory node, causing
memory access violations during runtime.

Signed-off-by: Tomas Melin <tomas.melin@vaisala.com>
Signed-off-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/20251125-revert-zynqmp-optee-v1-1-d2ce4c0fcaf6@vaisala.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a comprehensive understanding. Let me compile the full
analysis.

---

## Detailed Analysis

### 1. COMMIT MESSAGE ANALYSIS

This is a **revert** commit. It reverts
`06d22ed6b6635b17551f386b50bb5aaff9b75fbe` ("arm64: zynqmp: Add an OP-
TEE node to the device tree"), which was merged for v6.9-rc1 (January
2024).

The revert message explains a concrete, real-world problem:
- U-Boot's OP-TEE logic automatically injects a `reserved-memory` node
  and `optee` firmware node into the kernel device tree at boot time
- This U-Boot injection logic checks for the **absence** of a manually-
  defined optee node — if one already exists, it skips injection
  entirely
- The original commit added a static optee node to `zynqmp.dtsi`, which
  prevents U-Boot from injecting the `reserved-memory` node
- Without the reserved-memory node, **memory access violations occur
  during runtime**

This is not speculative — the commit describes actual runtime memory
access violations.

### 2. CODE CHANGE ANALYSIS

The change is extremely small and surgical — it removes exactly 5 lines
(4 lines of DT node content + 1 blank line):

```195:198:arch/arm64/boot/dts/xilinx/zynqmp.dtsi
                optee: optee  {
                        compatible = "linaro,optee-tz";
                        method = "smc";
                };
```

This removes a statically-defined OP-TEE node from the ZynqMP base
device tree include file (`zynqmp.dtsi`). The `optee` label is not
referenced by any other DTS file in the xilinx directory tree, so there
are no broken cross-references.

### 3. BUG MECHANISM

The bug mechanism is an interaction between the Linux kernel device tree
and U-Boot bootloader:

1. **U-Boot's OP-TEE initialization**: U-Boot contains logic that
   detects if OP-TEE is running and, if so, dynamically modifies the FDT
   (Flattened Device Tree) before passing it to Linux. It adds:
   - A `reserved-memory` node describing memory regions reserved for OP-
     TEE
   - The `optee` firmware node pointing to the TEE

2. **Conditional injection**: U-Boot's injection is conditioned on there
   being **no existing optee node** in the DT. If one is found, U-Boot
   assumes the DT is already properly configured and skips injection.

3. **The problem**: The static optee node in `zynqmp.dtsi` has
   `compatible = "linaro,optee-tz"` and `method = "smc"`, but it does
   NOT include the critical `reserved-memory` region. When U-Boot sees
   this node, it skips its injection. The kernel then boots with:
   - An optee node (so the OP-TEE driver probes and starts communicating
     with the secure world)
   - **No reserved-memory** for OP-TEE (so the kernel may allocate and
     use memory that OP-TEE also uses)

4. **Result**: Memory access violations at runtime. The kernel and OP-
   TEE stomp on each other's memory. This is a data corruption and crash
   bug.

### 4. CLASSIFICATION

This is a **device tree fix** that addresses a **runtime memory
corruption/access violation** bug. It falls squarely in the "DT updates
for existing hardware" exception category. The severity is high:
- Memory access violations = potential crashes, data corruption,
  security boundary violations (TEE compromise)
- Affects all ZynqMP boards running OP-TEE with U-Boot

### 5. ORIGINAL COMMIT ANALYSIS

The original commit (06d22ed6b6635) claimed "having the DT node present
doesn't cause any side effects." This turned out to be **wrong** — it
has a significant side effect with U-Boot's standard OP-TEE injection
flow. The original commit was a feature addition ("add it in case
someone tries to load OP-TEE") that turned out to cause a real bug.

### 6. SCOPE AND RISK ASSESSMENT

- **Lines changed**: 5 lines removed (1 file)
- **Risk**: Extremely low — removing a DT node that shouldn't have been
  there
- **Side effects**: None negative. If someone was using the static optee
  node WITHOUT U-Boot injection, they would need to add it back in their
  board-specific DT overlay. However, the standard OP-TEE workflow on
  ZynqMP uses U-Boot injection, and the original commit was explicitly
  designed as a convenience, not a necessity.
- **Regression potential**: Near zero — the only "regression" is
  returning to the pre-6.9 behavior, which worked correctly

### 7. AFFECTED STABLE TREES

The original commit (06d22ed6b6635) is present in:
- v6.9 through v6.19 (all current stable trees from 6.9 onward)
- Critically, it's in **6.12.y** (current LTS tree)

The fix is relevant to 6.12.y, 6.13.y, and any other maintained stable
tree based on 6.9+.

### 8. DEPENDENCY CHECK

The revert has **zero dependencies**. It simply removes 5 lines from a
DTS file. No other code or DT changes are needed. The `optee` label is
not referenced by any other file. The revert will apply cleanly to any
stable tree that has the original commit.

### 9. USER IMPACT

- **Who is affected**: All ZynqMP users running OP-TEE with standard
  U-Boot boot flow
- **Severity**: HIGH — runtime memory access violations can cause:
  - Kernel crashes/panics
  - OP-TEE secure world corruption
  - Silent data corruption
  - Potential security boundary violation (TEE memory exposed to normal
    world)
- **Platform**: Xilinx ZynqMP (common in embedded, industrial,
  automotive applications)

### 10. TRUST INDICATORS

- Submitted by Tomas Melin (Vaisala), indicating real-world usage and
  testing
- Accepted by Michal Simek (AMD/Xilinx SoC maintainer), indicating
  subsystem maintainer approval
- The commit message clearly explains the mechanism and consequences
- Clean revert of a well-identified problematic commit

### CONCLUSION

This is a textbook stable backport candidate:
1. **Fixes a real bug**: Runtime memory access violations on ZynqMP with
   OP-TEE
2. **Obviously correct**: Clean revert of a commit that introduced the
   problem
3. **Small and contained**: 5-line removal from a single DTS file
4. **No new features**: Removes a broken feature addition
5. **Zero risk**: Returns to the pre-6.9 behavior that worked correctly
6. **No dependencies**: Self-contained change
7. **Real-world impact**: Affects ZynqMP users with OP-TEE
   (embedded/industrial platforms)
8. **Applies to active stable trees**: The buggy commit is in 6.12.y LTS
   and other maintained stables

The fix is small, surgical, and meets all stable kernel criteria.

**YES**

 arch/arm64/boot/dts/xilinx/zynqmp.dtsi | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
index 938b014ca9231..b55c6b2e8e0e1 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
+++ b/arch/arm64/boot/dts/xilinx/zynqmp.dtsi
@@ -192,11 +192,6 @@ psci {
 	};
 
 	firmware {
-		optee: optee  {
-			compatible = "linaro,optee-tz";
-			method = "smc";
-		};
-
 		zynqmp_firmware: zynqmp-firmware {
 			compatible = "xlnx,zynqmp-firmware";
 			#power-domain-cells = <1>;
-- 
2.51.0

