Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC9430E828;
	Tue, 10 Feb 2026 23:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770766285; cv=none; b=oZIlbvPD0SKv3PvSVsqW3ftJOzh24gbzohnXtdfYdEQuqhTQ0Aj6RoKTwnaqL6p8qXGN5Vq5/7V/pYFyNDcyKE7m6CcxycZxEKFvtvZ9D6EM7PfBwWWl+Z4YMXJbSCySFgJs8ywWGPDEe4I2PBMTHOriwbpZrEi301ykblI4Csc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770766285; c=relaxed/simple;
	bh=zSCuS2u4TQrw/WqZyuyHqfuDpwrh5SrnFAIQSO3xV9k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=G6z4MMT3B7t7tGf96v/gU4p9w59W4v22j3cQq836K3PfFG7QJZpJNei2n5Bd9Y26pjYWWKlBvxTXtpmbJqL21As3xe5MKQtMCNKJRDTNMxJV3NxQHQGWILW6gHiE75wO74RDG6e2jCS7/v1UWtklW7LfWJ+gNSLOwAzRi54W8Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N4ACgGF9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N4ACgGF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7601C116C6;
	Tue, 10 Feb 2026 23:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770766285;
	bh=zSCuS2u4TQrw/WqZyuyHqfuDpwrh5SrnFAIQSO3xV9k=;
	h=From:To:Cc:Subject:Date:From;
	b=N4ACgGF9O46EgGMOw+Ae1UXV/QbEoDr44O0bR1flXNFbrLDnhgd6hwkTGGPTbq9Zy
	 ByCGutpdnVZ9BjEdm81PB8DrXG6iJCgHpH9uu/tqa6Z/kR8zuA7HslyZgBHpv0/Zla
	 uHzwnrns9y145KZKAj5CRVMEi+VrZqAOCln15OBh3jH5g2/2sBQrpgKn8vwTmOa2sh
	 J2/ev+3xWUz7lw/o6zV7fNnJIqvaGFgzNvCw5iRKgXL7bQS7Yc2ypgyD2nvEV+HAsp
	 Lj/RRsy0KGPVyT43R63OoacQdGnuS/1bheFdPh9fTJxhtzKNww+er8eAEHR2liu8Db
	 JgesolqkH0DZw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Adrian Hunter <adrian.hunter@intel.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	jarkko.nikula@linux.intel.com
Subject: [PATCH AUTOSEL 6.19-6.12] i3c: mipi-i3c-hci: Reset RING_OPERATION1 fields during init
Date: Tue, 10 Feb 2026 18:30:46 -0500
Message-ID: <20260210233123.2905307-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
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

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 78f63ae4a82db173f93adca462e63d11ba06b126 ]

The MIPI I3C HCI specification does not define reset values for
RING_OPERATION1 fields, and some controllers (e.g., Intel) do not clear
them during a software reset.  Ensure the ring pointers are explicitly
set to zero during bus initialization to avoid inconsistent state.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260113072702.16268-2-adrian.hunter@intel.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

`RING_OPERATION1` has been defined and used since the very first version
of the driver. The fix is self-contained and has no dependencies.

## Detailed Analysis

### 1. COMMIT MESSAGE ANALYSIS

The commit message is clear and precise: the MIPI I3C HCI specification
does not define reset values for `RING_OPERATION1` fields, and some
controllers (specifically Intel) do not clear these fields during
software reset. The fix ensures the ring pointers are set to zero during
initialization.

- Author: **Adrian Hunter** (Intel) - one of the most experienced kernel
  contributors, working directly on the hardware
- Reviewed-by: **Frank Li** (NXP) - another vendor confirmed the fix is
  correct
- Accepted by: **Alexandre Belloni** - subsystem maintainer

### 2. CODE CHANGE ANALYSIS

The change is a single hardware register write
(`rh_reg_write(RING_OPERATION1, 0)`) inserted at the `ring_ready:`
label, before the ring is enabled via `RING_CONTROL`.

**The register `RING_OPERATION1`** (offset 0x28) contains three critical
ring buffer pointer fields:
- `RING_OP1_CR_ENQ_PTR` (bits 7:0) — Command/Response enqueue pointer
- `RING_OP1_CR_SW_DEQ_PTR` (bits 15:8) — Command/Response software
  dequeue pointer
- `RING_OP1_IBI_DEQ_PTR` (bits 23:16) — IBI dequeue pointer

**The bug mechanism**: The `hci_rh_data` structure is allocated with
`kzalloc`, so all software-side pointers (`done_ptr`, `ibi_chunk_ptr`)
start at 0. But if the hardware RING_OPERATION1 register retains stale
nonzero values (because the spec doesn't mandate reset values, and Intel
controllers don't clear them), there's a **hardware/software pointer
mismatch** from the moment the ring is enabled.

**Impact of the mismatch** — critical operations that rely on consistent
pointers:

1. **`hci_dma_queue_xfer()`** (line 382-383): Reads
   `RING_OP1_CR_ENQ_PTR` to determine where to place the next command. A
   stale nonzero value means commands go to wrong ring offsets, while
   responses are read from offset 0 (`done_ptr = 0`).

2. **`hci_dma_xfer_done()`** (line 552-555): Updates
   `RING_OP1_CR_SW_DEQ_PTR`. Stale values in other fields are masked
   out, but the initial read from `hci_dma_queue_xfer` would already
   have gone wrong.

3. **`hci_dma_process_ibi()`** (line 614-615): Reads
   `RING_OP1_IBI_DEQ_PTR`. A stale nonzero value means IBI processing
   starts from the wrong position in the status ring.

**Consequences**: This can cause complete DMA ring malfunction on
affected controllers:
- Commands placed at incorrect ring entry positions
- Response processing reading uninitialized entries
- IBI processing starting at wrong positions
- Potential DMA data corruption (ring_data = `rh->xfer +
  rh->xfer_struct_sz * stale_ptr`)

### 3. CLASSIFICATION

This is a **hardware initialization bug fix**. It falls into the
"hardware quirk/workaround" category — the MIPI spec has an ambiguity
(no defined reset values), and Intel hardware takes advantage of that
ambiguity in a way the driver didn't account for.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: 1 line of code + 6 lines of comment = 8 lines
  total, 1 file
- **Risk**: Extremely low. Writing 0 to ring pointers before enabling
  the ring is always correct during initialization (software pointers
  are zero, hardware pointers should match). This cannot break any
  working configuration.
- **Placement**: The write is at `ring_ready:` label, which is reached
  for all rings (both IBI and non-IBI), and occurs just before the ring
  is enabled with `RING_CTRL_ENABLE | RING_CTRL_RUN_STOP`. This is the
  correct place — after setup, before enable.

### 5. USER IMPACT

This affects anyone using the MIPI I3C HCI driver on Intel controllers.
I3C is increasingly used in modern platforms for sensor hubs, power
management ICs, and other peripherals. Without this fix, the controller
can enter inconsistent state leading to I3C bus communication failures.

### 6. STABILITY INDICATORS

- Reviewed-by from NXP vendor (Frank Li)
- Author is from Intel and knows the hardware intimately
- Accepted by subsystem maintainer

### 7. DEPENDENCY CHECK

- The `ring_ready:` label and `RING_OPERATION1` register definition
  exist in all versions of this driver since its introduction in v5.11
- The `rh_reg_write` macro has been unchanged since the original driver
- **No dependencies** on other commits — this is fully self-contained
- The only context difference across stable trees is whether
  `RING_CONTROL` is written with `RING_CTRL_ENABLE` alone (pre-v6.6) or
  `RING_CTRL_ENABLE | RING_CTRL_RUN_STOP` (v6.7+), but the new
  `RING_OPERATION1` write goes before it and is independent
- Minor backport adjustment may be needed for trivial context
  differences in the surrounding `ring_ready:` label area, but the patch
  should apply cleanly or with minimal fuzz

### Summary

This is a small, surgical, obviously correct hardware initialization
fix. It prevents inconsistent DMA ring pointer state on Intel I3C HCI
controllers where the hardware doesn't reset `RING_OPERATION1` during
software reset. The mismatch between hardware pointer values
(stale/random) and software pointer values (zero from kzalloc) can cause
command/response ring processing failures, IBI processing from wrong
positions, and potential DMA corruption. The fix is one register write,
has zero risk of regression, requires no dependencies, and applies to
all stable trees back to v5.15 where this driver exists.

**YES**

 drivers/i3c/master/mipi-i3c-hci/dma.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/i3c/master/mipi-i3c-hci/dma.c b/drivers/i3c/master/mipi-i3c-hci/dma.c
index c401a9425cdc5..951abfea5a6fd 100644
--- a/drivers/i3c/master/mipi-i3c-hci/dma.c
+++ b/drivers/i3c/master/mipi-i3c-hci/dma.c
@@ -342,6 +342,14 @@ static int hci_dma_init(struct i3c_hci *hci)
 		rh_reg_write(INTR_SIGNAL_ENABLE, regval);
 
 ring_ready:
+		/*
+		 * The MIPI I3C HCI specification does not document reset values for
+		 * RING_OPERATION1 fields and some controllers (e.g. Intel controllers)
+		 * do not reset the values, so ensure the ring pointers are set to zero
+		 * here.
+		 */
+		rh_reg_write(RING_OPERATION1, 0);
+
 		rh_reg_write(RING_CONTROL, RING_CTRL_ENABLE |
 					   RING_CTRL_RUN_STOP);
 	}
-- 
2.51.0

