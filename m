Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9757E1BFE00;
	Wed,  4 Jun 2025 00:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998719; cv=none; b=Vx/IfvUra+4czoE4FxBO8Edw+horbsCg9Wc1Hc8IQb6lp0lx5mEURlI9HMviCRPxJU6QFMwS3qP+hwGpuz4iRyng3Qk8fJi+het7j2jsP+jQ9Kw3YdLOJSJ1/iOI9Ae8oAGr/7zKo3E2O8a3kOFxUiOhyxeFEiwW58a5zfp8CzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998719; c=relaxed/simple;
	bh=eKMQyV1C91DAC7hK8qLEUulNHkD5CAVhLyhXYXFIokA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Aw2g1m/ujb4gurGFozefyrz9JvBE12z8nW0jWy6OzkgR6kSKQHcg5wQHXh4j5qFe+Gwqm9LHR7Hb/NqFOm7Ffs2zZX71UxxNbFD3pH46NM21BN0dbL3tWz44DUBZalO5DOyblLASjwzgs0C6/dT/AF7mqBWLLPbOqtgIdUn/zbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M9K2cBNx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M9K2cBNx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6088BC4CEED;
	Wed,  4 Jun 2025 00:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998719;
	bh=eKMQyV1C91DAC7hK8qLEUulNHkD5CAVhLyhXYXFIokA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9K2cBNx9LQ75NYO+WXmARWkdNcq7Zbhbc+hPDfV9v0s9mEsidBJ7YeaQVe5QGlF2
	 ELW0Kr5V2YvlBUWjlAaI8Ao4FR1Owo9IuIgYZR1dUzjEcWqQpPIq5EMVGZUamoBYsb
	 ftEDkRC1c+LWa3TJGbkr7E9lmpcG8u/Z4FvaxZJyRADXSizPp2A7iOjtyHPYgArk5a
	 BzOJjQk0Z7dmiHy5l0a0+NX/mwdPeeJ8j3fdAsJhyoiwyXn+nqhrrUcGTG/eSR1V8D
	 wSahoP/EqeI7vj12OZxkMe48qBGnyxmykDEYekjBCS0j9WkB9uCapRt7iMj3Et5CbB
	 gZgH13cQqOPsA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kyungwook Boo <bookyungwook@gmail.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Simon Horman <horms@kernel.org>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Rinitha S <sx.rinitha@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	intel-wired-lan@lists.osuosl.org
Subject: [PATCH AUTOSEL 6.14 092/108] i40e: fix MMIO write access to an invalid page in i40e_clear_hw
Date: Tue,  3 Jun 2025 20:55:15 -0400
Message-Id: <20250604005531.4178547-92-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005531.4178547-1-sashal@kernel.org>
References: <20250604005531.4178547-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kyungwook Boo <bookyungwook@gmail.com>

[ Upstream commit 015bac5daca978448f2671478c553ce1f300c21e ]

When the device sends a specific input, an integer underflow can occur, leading
to MMIO write access to an invalid page.

Prevent the integer underflow by changing the type of related variables.

Signed-off-by: Kyungwook Boo <bookyungwook@gmail.com>
Link: https://lore.kernel.org/lkml/ffc91764-1142-4ba2-91b6-8c773f6f7095@gmail.com/T/
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my extensive analysis: ## Analysis of Code Changes The commit changes
variable types in `i40e_clear_hw()` from unsigned (`u32`) to signed
(`s32`) for: 1. `num_pf_int` - number of PF interrupts 2. `num_vf_int` -
number of VF interrupts 3. `i` - loop counter variable **Critical
Security Issue**: The problem occurs when hardware registers contain
malicious values where `num_pf_int` or `num_vf_int` could be 0 or 1. In
the loops at lines 852-853 and 858-859: ```c for (i = 0; i < num_pf_int
- 2; i++) wr32(hw, I40E_PFINT_DYN_CTLN(i), val); ``` If `num_pf_int` is
0 or 1, then `num_pf_int - 2` becomes a large positive number due to
unsigned integer underflow (0xFFFFFFFE or 0xFFFFFFFF), causing the loop
to iterate billions of times and write to invalid MMIO addresses,
leading to system crashes or potential security vulnerabilities. ##
Comparison with Similar Commits This fix follows the **exact same
pattern** as Similar Commit #2 (fc6f716a5069), which was marked **YES**
for backporting. That commit addressed the same class of vulnerability
in the same function: - **Similar Commit #2**: Added bounds checking (`j
>= base_queue`, `j >= i`) to prevent underflow in queue/VF calculations
- **Current Commit**: Changes variable types to signed to prevent
underflow in interrupt calculations Both fixes address **integer
underflow vulnerabilities in `i40e_clear_hw()`** that can lead to **MMIO
writes to invalid memory pages**. ## Backport Suitability Criteria ✅
**Fixes important security bug**: Prevents system crashes and potential
memory corruption ✅ **Small, contained change**: Only changes variable
types, no logic changes ✅ **Minimal side effects**: Type changes are
safe and don't affect functionality ✅ **No architectural changes**:
Simple type fix ✅ **Critical subsystem**: Network driver, but change is
isolated ✅ **Clear commit message**: Explicitly describes the security
issue ✅ **Follows stable rules**: Important security bugfix with minimal
risk ## Historical Context The vulnerability was introduced in commit
838d41d92a90 ("i40e: clear all queues and interrupts") from 2014. A
related fix (fc6f716a5069) was already applied for similar underflow
issues in the same function and was backported. This commit completes
the fix by addressing the remaining underflow vectors. ## Risk
Assessment **Risk: MINIMAL** - This is a simple type change that: -
Makes signed arithmetic behave correctly - Prevents undefined behavior
from unsigned underflow - Has no functional impact on normal operation -
Only affects error conditions with malformed hardware registers The fix
is **essential for security** and has **virtually zero regression
risk**, making it an ideal candidate for stable backporting.

 drivers/net/ethernet/intel/i40e/i40e_common.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_common.c b/drivers/net/ethernet/intel/i40e/i40e_common.c
index 370b4bddee441..b11c35e307ca9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_common.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_common.c
@@ -817,10 +817,11 @@ int i40e_pf_reset(struct i40e_hw *hw)
 void i40e_clear_hw(struct i40e_hw *hw)
 {
 	u32 num_queues, base_queue;
-	u32 num_pf_int;
-	u32 num_vf_int;
+	s32 num_pf_int;
+	s32 num_vf_int;
 	u32 num_vfs;
-	u32 i, j;
+	s32 i;
+	u32 j;
 	u32 val;
 	u32 eol = 0x7ff;
 
-- 
2.39.5

