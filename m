Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B6113C2D;
	Sat, 14 Feb 2026 21:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104307; cv=none; b=Bf5d4UAQHluB+YBI6XAVWzJ1ylTg/9DiytlwTU1T70Hz9EqxRPXGdqk743xTwDlcQMdIKxwjzIdkkbohN6JYBsfccAu5gb2OClcUnK7nzl6QRuWvHSYbjY91Qf8ADEsh2wRxqE4h2MNOLz9oRBQRNMp0INynsCuKR3z1pMehRf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104307; c=relaxed/simple;
	bh=hNwGvkqny+Y+Q0DIM8LQ5cWXdsv2HwFJCMRH4wUfE0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WjReLUEpjFejzL0oPELsfJAquI/rCVlM4xUJjTts+LSS8RD1rvxrHCH/MKfwpBIPCeWObtulbw1X0QOA2JTj450NRgzEc+UoV+RnVzp4OtUK9DdQ80Vhep9sQH2eYqW1efiPcbSAanI2okoSgdjsrLqS82R7S+qCaRwS0iinNMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KdXoIoil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KdXoIoil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC91C16AAE;
	Sat, 14 Feb 2026 21:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104307;
	bh=hNwGvkqny+Y+Q0DIM8LQ5cWXdsv2HwFJCMRH4wUfE0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KdXoIoilUJJGRLhm5hV8e0smHrwgwFzkq0GdRbOTmTEAteHRljSMkYfmY7Wi/PTfY
	 pOQF7qxPXmQ7pyjD2qRvZ0vEQJoqC/44qLtGw8l0zoAQrQ7ixkcoyNSDV+gkMm7kML
	 8e+yg54LjfaxGXYbkJMrj0U+Qd65sUwjrtQe9sXZlj7UDxyx7w7aabITE+ye4qTaVe
	 HGnDqkaIez8+ylYFACSIvgZT/+nTV8Mps3A+ATiaOEXWAkFmStR8joEabfQmIwa9wg
	 LcgyK3cKr2obNdxhRiR2Gtfrwtk6PEDRwkX+K5bZhRXHefaq2FFZinVHM+SaZyB0Iu
	 QD/Q9MTo4C0UA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	johannes.berg@intel.com,
	pagadala.yesu.anjaneyulu@intel.com,
	emmanuel.grumbach@intel.com,
	daniel.gabay@intel.com,
	yelangyan@huaqin.corp-partner.google.com
Subject: [PATCH AUTOSEL 6.19-6.18] wifi: iwlwifi: mld: Handle rate selection for NAN interface
Date: Sat, 14 Feb 2026 16:22:31 -0500
Message-ID: <20260214212452.782265-6-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit dbbeebece03050cd510073ce89fee83844e06b00 ]

Frames transmitted over a NAN interface might not have channel
information assigned to them. In such cases assign the lowest
OFDM to the frame.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20251110180612.72046f98f878.Ib784931fffd0747acd9d7bb22eabbbec5282733e@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### Commit Message Analysis

The commit addresses frames transmitted over a NAN (Neighbor Awareness
Networking) interface that might not have channel information assigned.
Without channel info, the `band` variable remains uninitialized or set
to an invalid value, which would lead to an out-of-bounds array access
when used as an index into `mld->hw->wiphy->bands[band]`.

### Code Change Analysis

The fix is a small, surgical addition of 4 lines (plus a blank line) in
`iwl_mld_get_lowest_rate()`:

```c
if (band >= NUM_NL80211_BANDS) {
    WARN_ON(vif->type != NL80211_IFTYPE_NAN);
    return IWL_FIRST_OFDM_RATE;
}
```

**What happens without this fix:**

1. `iwl_mld_get_basic_rates_and_band()` is called, which sets `band`
   based on `link_conf->chanreq.oper.chan->band`
2. For NAN interfaces, `link_conf->chanreq.oper.chan` may be NULL,
   meaning `band` is never properly set
3. Looking at the function, `band` is declared as `u8 band` with no
   initializer — so it could be any value
4. The code then does `sband = mld->hw->wiphy->bands[band]` — if `band`
   is out of range (>= `NUM_NL80211_BANDS`), this is an **out-of-bounds
   array access**
5. If `sband` happens to be NULL or garbage, subsequent access to
   `sband->bitrates[i].hw_value` would be a **NULL pointer dereference
   or memory corruption**

### Bug Classification

This is a **potential out-of-bounds access / NULL pointer dereference**
bug. The `bands[]` array is indexed by `band` which could be
uninitialized/invalid when NAN interfaces don't have channel
information. This could lead to:
- Kernel crash/oops
- Memory corruption

### Scope and Risk Assessment

- **Files changed:** 1 file
- **Lines added:** 5 (including blank line)
- **Lines removed:** 0
- **Subsystem:** iwlwifi wireless driver (Intel WiFi)
- **Risk:** Very low — the check is purely additive, validates bounds
  before array access, and returns a safe default value
- **The WARN_ON** provides debugging info if this path is hit
  unexpectedly for non-NAN interfaces

### Key Concern: Code Maturity

The file is `drivers/net/wireless/intel/iwlwifi/mld/tx.c`. The "mld"
directory is relatively new in iwlwifi — it was introduced as part of
the iwlwifi restructuring. Let me check when this code was introduced.

Looking at the path `drivers/net/wireless/intel/iwlwifi/mld/`, this is
the newer MLD (Multi-Link Device) code path for iwlwifi. This code is
quite new and may not exist in older stable trees. The commit is on top
of Linux 6.19, so it would only be relevant for very recent stable trees
(6.12.y at earliest, likely only 6.13.y+).

### Dependency Check

The fix is self-contained. It adds a bounds check before an existing
array access. It doesn't depend on other patches. However, the entire
`mld/` directory may not exist in older stable trees, limiting which
stable versions this applies to.

### User Impact

- **Who is affected:** Users of Intel WiFi hardware using NAN (Neighbor
  Awareness Networking) functionality
- **Severity:** Potential kernel crash (out-of-bounds array access) —
  moderate to high
- **Trigger:** Transmitting frames over a NAN interface without channel
  information

### Decision

The fix:
- Is small and surgical (5 lines)
- Fixes a real bug (out-of-bounds array access that could cause a crash)
- Is obviously correct (bounds check before array index)
- Has no risk of regression (adds a safety check with safe fallback)
- Meets stable kernel criteria

The only concern is whether the `mld/` code exists in the target stable
trees, but that's a backporting logistics issue, not a reason to reject.
If the code exists in stable, this fix should be there too.

**YES**

 drivers/net/wireless/intel/iwlwifi/mld/tx.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/tx.c b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
index 3b4b575aadaa5..e3fb4fc4f452e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/tx.c
@@ -345,6 +345,11 @@ u8 iwl_mld_get_lowest_rate(struct iwl_mld *mld,
 
 	iwl_mld_get_basic_rates_and_band(mld, vif, info, &basic_rates, &band);
 
+	if (band >= NUM_NL80211_BANDS) {
+		WARN_ON(vif->type != NL80211_IFTYPE_NAN);
+		return IWL_FIRST_OFDM_RATE;
+	}
+
 	sband = mld->hw->wiphy->bands[band];
 	for_each_set_bit(i, &basic_rates, BITS_PER_LONG) {
 		u16 hw = sband->bitrates[i].hw_value;
-- 
2.51.0

