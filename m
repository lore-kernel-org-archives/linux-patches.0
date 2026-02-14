Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2CF03C2D;
	Sat, 14 Feb 2026 21:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104386; cv=none; b=OCAK9qZ9P3XPuHra2KFbVpV3zvva76U4HYhrCCNwLUKK9Cs6ZRiodvLxub5aoqlmBjGHfJYzgGKXampAqxMzhR5BsxgmAtOIu8j5c6PJkpy61kbXIN0OtGcR2G/LSkd0Td6vrOd16Edw0sKlPTRIJHxs6SxnjqdilK9Hab99+1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104386; c=relaxed/simple;
	bh=V3TNPGN4kFnHVSzRqNxu1tepud4SuFsId5OwEr5/1Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gzLm7PmrLsiaPML6gl7BxdP9E7CpWYbB2YanLTNEoVM4QS/6rqQ2L2jdTd5PrWP5bedcdM4xuvprD9lPHG7uscG3eNq41FppfAOGqeTUzyM27Re+TlLcUunJOrQ+nGErXCS+P2jJgUuZehMGX3obpGkiab+sEmOHNHYRqQxdkCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h7Bzvlv4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h7Bzvlv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B69EFC16AAE;
	Sat, 14 Feb 2026 21:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104386;
	bh=V3TNPGN4kFnHVSzRqNxu1tepud4SuFsId5OwEr5/1Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7Bzvlv4PmJypCMNL1G7ojS3SbWAcv5qhL3NYEM1Ic29R9umTnMJicfz9Gv6ayRIh
	 7UyfiVa3Zvxf0BJ3p9Foi6Xov7wQe+ExifC4NRtjVmCo1U0WzyVofC49Yx95fgHIFc
	 9bmd49bAKU2Q6HrvfJEzSTWbTk0/YQMkgwysv/W9U4Z1mHZm88v/nun1CI/sdS2aOO
	 Jc2bJ6hSqBnE9muPVubx33tpXqoZ4g7smRod//jDO4ea2gC2cxGifgAa4ZNJieZEc9
	 xCbAjGNaSv/I1vNRLoP9brfdqX6AKINAfYYiRaC4t9yIWK5RiVPZWhM/uoeWj0Wdbt
	 Qq5agjqpz1oiA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ian Rogers <irogers@google.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	yelangyan@huaqin.corp-partner.google.com,
	mpillai@cadence.com,
	linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19] PCI: cadence: Avoid signed 64-bit truncation and invalid sort
Date: Sat, 14 Feb 2026 16:23:21 -0500
Message-ID: <20260214212452.782265-56-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Ian Rogers <irogers@google.com>

[ Upstream commit 0297dce758a021ccf2c0f4e164d5403ef722961c ]

The cdns_pcie_host_dma_ranges_cmp() element comparison function used by
list_sort() is of type list_cmp_func_t, so it returns a 32-bit int.

cdns_pcie_host_dma_ranges_cmp() computes a resource_size_t difference that
may be a 64-bit value, and truncating that difference to a 32-bit return
value may change the sign and result in an invalid sort order.

Avoid the truncation and invalid sort order by returning -1, 0, or 1.

Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
[bhelgaas: commit log]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20251209223756.2321578-1-irogers@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of PCI: cadence: Avoid signed 64-bit truncation and invalid
sort

### Commit Message Analysis

The commit message clearly describes a bug: the comparison function
`cdns_pcie_host_dma_ranges_cmp()` returns a 32-bit `int`, but it
computes a difference of `resource_size_t` values which can be 64-bit.
Truncating a 64-bit difference to 32 bits can change the sign, resulting
in an **invalid sort order**. This is a classic integer truncation bug
in comparison functions.

### Code Change Analysis

**Before (buggy):**
```c
return resource_size(entry2->res) - resource_size(entry1->res);
```

This subtracts two `resource_size_t` (which is `u64` on 64-bit systems)
values and returns the result as an `int` (32-bit). If the difference
exceeds `INT_MAX` or the subtraction wraps around (since
`resource_size_t` is unsigned), the truncated 32-bit value can have the
wrong sign.

**After (fixed):**
```c
size1 = resource_size(entry1->res);
size2 = resource_size(entry2->res);

if (size1 > size2)
    return -1;
if (size1 < size2)
    return 1;
return 0;
```

This is the canonical safe way to write a comparison function, returning
-1, 0, or 1 directly.

### Bug Impact

This function is used by `list_sort()` to sort DMA ranges by size
(descending order). An invalid sort order means:

1. **DMA ranges may not be sorted correctly**, which affects BAR
   configuration in `cdns_pcie_host_bar_config()`.
2. The Cadence PCIe host controller relies on this sorting to assign
   BARs to inbound memory regions. If large regions are not processed
   first (as intended by the descending sort), BAR assignment could fail
   or produce suboptimal/incorrect mappings.
3. This could lead to **PCIe enumeration failures** or **incorrect
   memory mappings** on systems using the Cadence PCIe controller
   (common in embedded/SoC platforms).

The bug is triggered when resource sizes differ by more than 2^31 bytes
(2 GiB), which is realistic for modern systems with large DMA regions.

### Stable Criteria Check

1. **Obviously correct and tested**: Yes - the fix is a textbook
   correction of an integer truncation bug in a comparator. Reviewed and
   merged by the PCI subsystem maintainer (Bjorn Helgaas).
2. **Fixes a real bug**: Yes - integer truncation causing invalid sort
   order is a real bug that can cause incorrect BAR configuration.
3. **Important issue**: Moderate - incorrect PCIe BAR configuration can
   cause device failures on affected platforms.
4. **Small and contained**: Yes - the change is minimal (about 10 lines
   changed in a single function), localized to one comparator function.
5. **No new features**: Correct - this is purely a bug fix.
6. **Applies cleanly**: The change is self-contained with no
   dependencies.

### Risk Assessment

- **Risk**: Very low. The change replaces an incorrect arithmetic
  comparison with the standard -1/0/1 pattern. There's no way this can
  introduce a regression.
- **Scope**: Single function in a single file, affecting only the
  Cadence PCIe host controller driver.
- **Benefit**: Correct DMA range sorting for systems with large memory
  regions using Cadence PCIe.

### Subsystem Relevance

The Cadence PCIe controller IP is used in several SoCs (TI, Renesas,
etc.), so this affects real embedded/industrial platforms that are
likely running stable kernels.

### Conclusion

This is a clear, small, obviously correct bug fix for an integer
truncation issue that can cause incorrect PCI BAR configuration. It
meets all stable kernel criteria with minimal risk.

**YES**

 .../controller/cadence/pcie-cadence-host-common.c    | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/cadence/pcie-cadence-host-common.c b/drivers/pci/controller/cadence/pcie-cadence-host-common.c
index 15415d7f35ee9..2b0211870f02a 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-host-common.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-host-common.c
@@ -173,11 +173,21 @@ int cdns_pcie_host_dma_ranges_cmp(void *priv, const struct list_head *a,
 				  const struct list_head *b)
 {
 	struct resource_entry *entry1, *entry2;
+	u64 size1, size2;
 
 	entry1 = container_of(a, struct resource_entry, node);
 	entry2 = container_of(b, struct resource_entry, node);
 
-	return resource_size(entry2->res) - resource_size(entry1->res);
+	size1 = resource_size(entry1->res);
+	size2 = resource_size(entry2->res);
+
+	if (size1 > size2)
+		return -1;
+
+	if (size1 < size2)
+		return 1;
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(cdns_pcie_host_dma_ranges_cmp);
 
-- 
2.51.0

