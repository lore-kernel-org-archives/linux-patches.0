Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0A62DB794;
	Thu, 19 Feb 2026 02:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466687; cv=none; b=AEZJ8mSK6t7wt05m5PvTmZD8tVfRTiQdxKpaJf/3z2nthGCYzZmJ8GNAPu3nNBgc2YJcPLQWL0XNuKzl51MfzBlldJwqhbwsDWoht4Qc7SGGv7ypNrDyjt/65ZwZRlieCosLXDI4TOqwcuMzbu+Sye3WfYZOTAr5W1vaqf6cryk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466687; c=relaxed/simple;
	bh=GKoHcnbEYD55ZwnR/rf/QDevmnIm0EXgtWNdvhuZ7Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qw8XhKcetqcrVqNsXEycsFGfmTo4rI9ULJF+2ayiBcQyDTHaKoAR0FtAfDj/2Knh0bgrjK1iW4xr/PacRhEPnlzqpVzgbdA0oeY+h4U4bGY4T9Wimlu29czHxvIcOy6LK124XwxITFf+cStDJzNIwqvTHiCBSdI2rYBm+wNDDjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kTm940YQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kTm940YQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA36C19425;
	Thu, 19 Feb 2026 02:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466687;
	bh=GKoHcnbEYD55ZwnR/rf/QDevmnIm0EXgtWNdvhuZ7Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kTm940YQNq+5lZDm7QNv8VCBMwLnqghJHDW35RrMqGoOciisJgluNj7w3+K59Nbai
	 52Xs9yewCetKpB5PKROELN3jXvYhkhHA74TVBDsciHPo2ejsUlbYXyGnME9HjxpDKc
	 eeancmlDxJXs784BCV6H7Wlagfxamzra8ZrgoVsSTLGo8iTSumH7RrzMV177q3lT09
	 w+7YFc+rwturQCipBT8DTI7l9C6KJAStisnPcTINGyAcyfKATpbDMY6bTu+NuVSsNZ
	 rbHKjh297xbIm9u3ltfSiVubUqVX8HP9yG6IOmy8LxSt7KCBX/rQUHrZNuIQeeKVOV
	 gPinixM0HuU6Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Marcus Folkesson <marcus.folkesson@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	support.opensource@diasemi.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] Revert "mfd: da9052-spi: Change read-mask to write-mask"
Date: Wed, 18 Feb 2026 21:03:55 -0500
Message-ID: <20260219020422.1539798-19-sashal@kernel.org>
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

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit 12daa9c1954542bf98bb942fb2dadf19de79a44b ]

This reverts commit 2e3378f6c79a1b3f7855ded1ef306ea4406352ed.

Almost every register in this chip can be customized via OTP
memory. Somehow the value for R19, which decide if the flag is set
on read or write operation, seems to have been overwritten for the chip
the original patch were written for.

Revert the change to follow the default behavior.

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Link: https://patch.msgid.link/20251124-da9052-revert-v1-1-fbeb2c894002@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is very significant. The broken commit `2e3378f6c79a` ("Change
read-mask to write-mask") was backported to **multiple stable trees**:
v6.12.x, v6.6.x, v6.1.x, and even v5.15.x. This means the revert is
critically needed in all those stable trees.

## Analysis Summary

### What the commit does
This reverts commit `2e3378f6c79a` which incorrectly changed
`config.read_flag_mask = 1` to `config.write_flag_mask = 1` in the
DA9052 SPI PMIC driver. The original author (Marcus Folkesson - who is
also the author of the broken commit) realized that the chip he tested
with had its OTP memory customized, causing register R19 to behave
differently than the default. The default chip behavior requires the
flag on **read** operations, not write.

### Why this matters
The `read_flag_mask`/`write_flag_mask` in regmap controls the SPI
protocol signaling for the DA9052 PMIC. Setting the wrong flag means:
- **Read operations** won't have the correct flag bit set, so the chip
  may misinterpret reads
- **Write operations** will have an unexpected flag bit set, potentially
  corrupting registers
- This can cause the PMIC (Power Management IC) to malfunction -
  affecting power rails, voltage regulation, battery charging, and other
  critical functions
- A broken PMIC driver can lead to hardware damage, data loss, or system
  instability

### Stable tree analysis
- The broken commit `2e3378f6c79a` landed in **v6.13** mainline
- It was backported to stable trees: **v6.12.x, v6.6.x, v6.1.x,
  v5.15.x**
- All of these stable trees are now broken for DA9052 SPI users
- The revert **must** follow to all stable trees that received the
  broken commit

### Risk assessment
- **Change size**: Single line change (`write_flag_mask` →
  `read_flag_mask`)
- **Risk**: Extremely low - it restores the behavior that existed for
  over a decade before the broken commit
- **Scope**: Only affects the DA9052 SPI PMIC driver
- **Testing**: The same author who made the original mistake authored
  the revert, understanding the root cause (OTP-customized chip)

### Stable criteria evaluation
1. **Obviously correct**: YES - restores long-standing default behavior,
   explained by same author
2. **Fixes a real bug**: YES - the broken commit introduced incorrect
   SPI communication with the PMIC
3. **Important issue**: YES - broken PMIC communication can cause power
   management failures
4. **Small and contained**: YES - single line change in one file
5. **No new features**: Correct - pure bug fix (revert of broken change)

## Verification

- **git log confirmed** commit `2e3378f6c79a` landed in v6.12..v6.13
  range (mainline v6.13)
- **git log confirmed** the broken commit was backported to stable:
  v6.12.x (as `691333e2987dd`), v6.6.x (as `d80635d7ebefd`), v6.1.x (as
  `50952a6ff5fa3`), and v5.15.x (as `a82dbec6e882e`)
- **git show confirmed** the original commit `2e3378f6c79a` had a
  `Fixes:` tag referencing `e9e9d3973594`, which is why it was auto-
  selected for stable
- **git show confirmed** `e9e9d3973594` was the commit that introduced
  the local `config` variable and set `read_flag_mask = 1` — the
  behavior that existed correctly for years
- **lore.kernel.org** confirmed Marcus Folkesson submitted the revert on
  2024-11-24 and Lee Jones (MFD maintainer) processed it
- The revert commit appears to be in linux-next (tags `next-20251219`,
  `p-6.15`, etc.) but not yet in a mainline release — this is expected
  for a commit being evaluated for backport
- **Could NOT verify** if the revert has landed in mainline yet (not
  found on master in this tree), but it is signed off by the subsystem
  maintainer Lee Jones

## Conclusion

This is a textbook case for stable backporting: a single-line revert of
a broken commit that was already backported to multiple stable trees.
The broken commit corrupts SPI communication with a PMIC chip by using
the wrong flag mask. All stable trees that received the broken commit
need this revert. The fix is trivial, well-understood, and authored by
the same person who made the original mistake.

**YES**

 drivers/mfd/da9052-spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/da9052-spi.c b/drivers/mfd/da9052-spi.c
index 80fc5c0cac2fb..be5f2b34e18ae 100644
--- a/drivers/mfd/da9052-spi.c
+++ b/drivers/mfd/da9052-spi.c
@@ -37,7 +37,7 @@ static int da9052_spi_probe(struct spi_device *spi)
 	spi_set_drvdata(spi, da9052);
 
 	config = da9052_regmap_config;
-	config.write_flag_mask = 1;
+	config.read_flag_mask = 1;
 	config.reg_bits = 7;
 	config.pad_bits = 1;
 	config.val_bits = 8;
-- 
2.51.0

