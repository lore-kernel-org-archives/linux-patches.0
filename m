Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29932FF144;
	Tue,  9 Dec 2025 00:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239506; cv=none; b=FQTMowrobBP95lhRcyCYB4v99r7PNaUDbrfG7Su+1MSdYbsfYuamt7tBFVpwGPQGhkVlD9DJqNivoUxJcaDmpdH8XcheSE1z3vplKyymiamluut8aa2+6jTo/sOsnMZ4tQNTKzmZS18RvbxgCMTdW374SCimTlZ4Gj5utvK2J4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239506; c=relaxed/simple;
	bh=EufPrSd66MHCfd1hrq0mehvzOsgd2H5VurLuDRQXTLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZRYBn8nplQhrpqAtiJ3STkHiJ4tgnInIjj7nUTJSxBzdvnaNVrkJYlY0nQk2QSc7e92QRRdlwwhvnivVN/fi/pJlhhhPkYJ4nnKiV8/A0bPkC4Bv7ujtZiQSycBbmv2VUCpzeCkBP36TeRuNJENJBjby1o8OtgQWmkswceDmSTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dfog2eeo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dfog2eeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6781C113D0;
	Tue,  9 Dec 2025 00:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765239506;
	bh=EufPrSd66MHCfd1hrq0mehvzOsgd2H5VurLuDRQXTLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dfog2eeozK2WKRx6xXtfXhffR8wdhEiSAYeT2NmI5qL/ZnRtnt7NCjx+2zT3mHjil
	 Iwh/8eet2RJvj6LtkonSIhvETzr8E23Q57/y9UL9Of5jc6Iov4WlOC0ert1oGFEbto
	 x6tcOJgM+kBWpoZqQFX7QjnibqeBS/Ba+rqcyK1LZKK4lXr6leKSI0uMg7GSbDDTlk
	 qjn+D5K31p6WenRS5YA4cby+sajl89o9r67/54V/MlTlljI9gmQqCOeguJMizZOd7H
	 jBZISK5WVmYNL8uVMogAjIzAp2bBpjH03sLvEDiN8oetNdbuQBtzwYCp8E7pTxBh6J
	 4yKlKhLyRDa2Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Simon Horman <horms@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	przemyslaw.kitszel@intel.com,
	intel-wired-lan@lists.osuosl.org
Subject: [PATCH AUTOSEL 6.18-6.12] ice: Allow 100M speed for E825C SGMII device
Date: Mon,  8 Dec 2025 19:15:37 -0500
Message-ID: <20251209001610.611575-45-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251209001610.611575-1-sashal@kernel.org>
References: <20251209001610.611575-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Grzegorz Nitka <grzegorz.nitka@intel.com>

[ Upstream commit ba2807b869a16d36b8bc76efa774fe433b3c45de ]

Add E825C 10GbE SGMII device to the list of devices supporting 100Mbit
link mode. Without that change, 100Mbit link mode is ignored in ethtool
interface. This change was missed while adding the support for E825C
devices family.

Testing hints (please note, for previous version, 100baseT/Full entry
was missing):
[root@localhost]# ethtool eth3
Settings for eth3:
        Supported ports: [ TP ]
        Supported link modes:   100baseT/Full
                                1000baseT/Full
                                10000baseT/Full
        Supported pause frame use: Symmetric
        Supports auto-negotiation: Yes
        Supported FEC modes: None
        Advertised link modes:  100baseT/Full
                                1000baseT/Full
                                10000baseT/Full
	...

Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete understanding. Let me summarize my analysis:

## DETAILED ANALYSIS

### 1. COMMIT MESSAGE ANALYSIS

**Subject:** `ice: Allow 100M speed for E825C SGMII device`

**Key phrases in commit message:**
- "This change was missed while adding the support for E825C devices
  family" - This explicitly acknowledges this is a bug fix for a missed
  case when E825C was introduced
- "Without that change, 100Mbit link mode is ignored in ethtool
  interface" - Describes the user-visible symptom

**Missing tags:**
- No `Fixes:` tag (should logically point to `f64e189442332` - "ice:
  introduce new E825C devices family")
- No `Cc: stable@vger.kernel.org` tag

**Tags present:**
- Multiple `Reviewed-by:` tags (3 reviewers including Simon Horman)
- `Tested-by:` tag from Intel QA

### 2. CODE CHANGE ANALYSIS

The change is extremely minimal - adding a single line to a switch
statement:

```c
bool ice_is_100m_speed_supported(struct ice_hw *hw)
{
    switch (hw->device_id) {
    case ICE_DEV_ID_E822C_SGMII:
    case ICE_DEV_ID_E822L_SGMII:
    case ICE_DEV_ID_E823L_1GBE:
    case ICE_DEV_ID_E823C_SGMII:
+   case ICE_DEV_ID_E825C_SGMII:       // <-- NEW LINE ADDED
        return true;
    default:
        return false;
    }
}
```

**Technical mechanism:**
- The `ice_is_100m_speed_supported()` function is called by
  `ice_mask_min_supported_speeds()` in `ice_ethtool.c`
- This function is used to determine which link speeds to report to
  ethtool as supported
- When `ice_is_100m_speed_supported()` returns `false`, the code masks
  off 100Mbit phy types (`ICE_PHY_TYPE_LOW_100BASE_TX` and
  `ICE_PHY_TYPE_LOW_100M_SGMII`)
- Without this fix, E825C SGMII devices (PCI ID 0x579F) cannot advertise
  or use 100Mbit mode via ethtool, even though the hardware supports it

**Root cause:** When E825C support was added in commit `f64e189442332`,
the developer forgot to also add `ICE_DEV_ID_E825C_SGMII` to the
`ice_is_100m_speed_supported()` function. All other E8xx SGMII devices
were already included.

### 3. CLASSIFICATION

**Type:** Bug fix - Missing device ID in a capability function

**Category analysis:**
- ✅ **Device ID addition to existing driver** - This is adding a device
  ID to an existing whitelist function
- ❌ Not a new feature - The 100M speed support exists, just missing one
  device
- ❌ Not a security fix
- ✅ Hardware capability fix - Enables correct hardware capability
  reporting

### 4. SCOPE AND RISK ASSESSMENT

**Size:** 1 line added to 1 file

**Risk level:** EXTREMELY LOW
- The change adds a single `case` label to a switch statement
- The function returns a boolean indicating device capability
- No logic changes, no side effects, no behavior changes for any other
  device
- The E825C_SGMII device ID (0x579F) already exists and is used in other
  places in the driver
- Multiple reviewers including Simon Horman

**Subsystem:** Intel ice network driver (mature, widely used, well-
tested)

### 5. USER IMPACT

**Who is affected:**
- Users with Intel E825-C SGMII network devices (PCI ID 0x579F)
- These are specific embedded/enterprise networking devices

**Symptom without fix:**
- `ethtool` shows 100Mbit as NOT supported when it should be
- Users cannot force 100Mbit link mode even if needed
- Misleading capability reporting in network management tools

**Severity:** Medium-Low
- Not a crash, security issue, or data corruption
- Affects device functionality/usability
- Users with this specific hardware are affected

### 6. STABILITY INDICATORS

**Positive signals:**
- `Reviewed-by: Simon Horman <horms@kernel.org>` (well-known networking
  reviewer)
- `Reviewed-by: Aleksandr Loktionov` (Intel)
- `Reviewed-by: Paul Menzel`
- `Tested-by: Rinitha S` (Intel QA)
- Commit signed off by Intel maintainer Tony Nguyen

### 7. DEPENDENCY CHECK

**Dependencies:**
- Requires E825C device support (introduced in v6.9-rc1 via
  `f64e189442332`)
- Requires `ice_is_100m_speed_supported()` function (introduced in
  v6.1-rc1 via `39ed02a4ba527`)

**Stable tree applicability:**
- v6.6.y: ❌ No E825C support, commit NOT applicable
- v6.10.y: ✅ Has E825C support and `ice_is_100m_speed_supported()`,
  commit APPLICABLE
- v6.11.y: ✅ APPLICABLE
- v6.12.y: ✅ APPLICABLE

### 8. STABLE KERNEL RULES ASSESSMENT

| Rule | Assessment |
|------|------------|
| Obviously correct and tested | ✅ Yes - trivial addition, well-
reviewed, tested |
| Fixes real bug that affects users | ✅ Yes - 100Mbit mode not available
on E825C SGMII |
| Important issue | ⚠️ Moderate - not critical but affects device
usability |
| Small and contained | ✅ Yes - 1 line change |
| No new features | ✅ Yes - enables existing functionality |
| No new APIs | ✅ Yes |
| Applies cleanly | ✅ Should apply cleanly to v6.10+ |

### CONCERNS

1. **No explicit stable markers:** The commit lacks `Cc:
   stable@vger.kernel.org` and `Fixes:` tags, suggesting the
   developer/maintainer didn't explicitly request backport

2. **Only applies to kernels with E825C support:** This fix is ONLY
   meaningful for kernels v6.10+ that have E825C device support.
   Backporting to v6.6.y would be pointless since those kernels don't
   have E825C at all.

3. **Not a critical fix:** While it's a real bug, it's not a crash,
   security issue, or data corruption - it's a feature parity/usability
   issue.

### RECOMMENDATION

This commit **SHOULD be backported** to stable kernels that have E825C
support (v6.10+, v6.11+, v6.12+) for the following reasons:

1. **Clearly a bug fix:** The commit message explicitly states "This
   change was missed while adding the support for E825C devices family"
2. **Trivial and safe:** Single line addition to a capability whitelist
   - minimal risk
3. **Well-reviewed and tested:** Multiple reviewers and explicit testing
4. **Follows the device ID exception:** Adding device IDs to existing
   functions is a well-accepted stable practice
5. **Fixes real user issue:** Users with E825C SGMII hardware cannot
   configure 100Mbit mode

The lack of explicit stable tags appears to be an oversight rather than
a deliberate decision to not backport. The change is clearly in the
category of "hardware quirks/device ID additions that enable proper
hardware support."

**YES**

 drivers/net/ethernet/intel/ice/ice_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 2532b6f82e971..449418cf06c20 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -3389,6 +3389,7 @@ bool ice_is_100m_speed_supported(struct ice_hw *hw)
 	case ICE_DEV_ID_E822L_SGMII:
 	case ICE_DEV_ID_E823L_1GBE:
 	case ICE_DEV_ID_E823C_SGMII:
+	case ICE_DEV_ID_E825C_SGMII:
 		return true;
 	default:
 		return false;
-- 
2.51.0

