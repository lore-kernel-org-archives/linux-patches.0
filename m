Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052582773CC;
	Thu, 19 Feb 2026 02:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466675; cv=none; b=a7IYWcdcZMczduhSzaDgFdJ6w6QXv0HLTNYmY7VupjmGi8tnfFHlrpq1BrilCC5I7oFhbQMKn1uV3BECrYTuyf5LizH5Gxb7qXeuh8I3f+pld3SIXL3jPprtqi3HT9QVXh5JIVAy0FXjSAFzbH8s5GRBMnZmpNl7zUb7OS2p9kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466675; c=relaxed/simple;
	bh=wpwxBcSx5rdYKGjPP86ePca9rUKc9CnxthjQXfTmgOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAEGgxaiEsb0W0ZYU/TdJd/3f03K92zwEpsxzR3ndlZeAgizwgedao14pe7UIHhNqHCHqstbP3OXjzJ2dEKtOVsTxsVhVLCwb0pSfQokDpapFbBedYenf0EpH8zi8mScjZW3W+5XToNorMy9WxXHCc9PZdabbSiEGWWthw63pYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h6gBpzYi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h6gBpzYi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2DFFC19424;
	Thu, 19 Feb 2026 02:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466674;
	bh=wpwxBcSx5rdYKGjPP86ePca9rUKc9CnxthjQXfTmgOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h6gBpzYi6+cfwq/PEHDbxUVPAkrNSTzY5ZX3Q+F2dObbLA1HGJk5cBoTvPpLKjb+k
	 Eit9Wctrl4t4wv8vQClKaJ8Azl7n2og5QH3nYYqh96T3QyaN8mvJ5KFWS5ES88qW16
	 P9riaFC+tWsoBH9uDx9uG1f5j8ldtYlUhaLT5Gdw4zfcVPitFQJt/wlYPhNRtzZJP3
	 ILYh/z4znFSPqNIIHUGTGjiXRoTUSa1VRHHssgbloyYsC6TAzgS0BGm2oqIzz5olLh
	 QHTmhCs5enNmau+M9TPtur3rKqCO5gR1Hl0BxW17V7lNH4wZvmgW0NhQdLZwE0/0vN
	 0KiEIX+hkWCMA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-sound@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] soundwire: intel_auxdevice: add cs42l45 codec to wake_capable_list
Date: Wed, 18 Feb 2026 21:03:45 -0500
Message-ID: <20260219020422.1539798-9-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Maciej Strozek <mstrozek@opensource.cirrus.com>

[ Upstream commit f87e5575a6bd1925cd55f500b61b661724372e5f ]

Add cs42l45 to the wake_capable_list because it can generate jack events
whilst the bus is stopped.

Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20251215151729.3911077-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis

### What the commit does
This commit adds the CS42L45 codec (manufacturer ID 0x01fa / Cirrus
Logic, part ID 0x4245) to the `wake_capable_list` in the SoundWire Intel
auxiliary device driver. This is a **device ID addition** to an existing
driver mechanism.

### Why it matters
Without this entry, the CS42L45 codec won't be recognized as wake-
capable by the Intel SoundWire bus driver. The `is_wake_capable()`
function is used in three places:
1. `generic_new_peripheral_assigned()` (line 128) - determines device
   number assignment range
2. `intel_get_device_num_ida()` (line 262) - allocates IDA-based device
   numbers
3. `intel_put_device_num_ida()` (line 276) - frees IDA-based device
   numbers

When a codec can generate jack events (headphone plug/unplug) while the
bus is stopped, it needs to be marked as wake-capable so the system
properly handles wake events. Without this, users would not get proper
jack detection on systems using the CS42L45.

### Key concern: CS42L45 is NEW hardware
The CS42L45 codec support was only added in **v6.19** (the
`soc_sdw_cs42l45.c` file and the SDCA class driver entry
`SDW_SLAVE_ENTRY(0x01FA, 0x4245, 0)`). This means:

- The CS42L45 as a whole is only supported starting from v6.19
- The `wake_capable_list` entry is only useful if the cs42l45 codec is
  actually present and functioning in the kernel
- Stable trees older than 6.19.y would not have cs42l45 support at all,
  making this entry meaningless there
- Even for 6.19.y stable, this is adding support for brand-new hardware
  that just landed in 6.19

### Classification
This falls into the "device ID / hardware quirk addition" category.
However, unlike typical device ID additions that enable already-
supported hardware, this is for a very newly added codec. The
wake_capable_list is technically a quirk/workaround list (the code
comments and commit message indicate these codecs generate events while
the bus is stopped), but the underlying codec support itself is brand
new.

### Risk assessment
- **Risk**: Extremely low. Single-line addition to a data array. Cannot
  cause regressions for existing hardware.
- **Benefit**: Proper jack detection for CS42L45 users. But only
  relevant for 6.19.y.
- **Scope**: Single line in one file.

### Stable tree applicability
The cs42l45 codec support was only introduced in v6.19. Current stable
trees at 6.6.y, 6.1.y, 5.15.y, etc. don't have cs42l45 support at all.
Even the 6.19.y tree would need to have the prerequisite cs42l45 codec
support commits first. This commit only makes sense for 6.19.y stable at
the earliest.

While the change itself is trivially safe and falls into the "hardware
quirk" exception category, its practical value for stable backporting is
limited since:
1. It only applies to 6.19.y (the only stable tree with cs42l45 support)
2. The CS42L45 is brand-new hardware, so the user base on 6.19.y stable
   is minimal
3. It's more of a "complete the new hardware support" addition than a
   fix for broken existing functionality

That said, the commit IS a trivial, safe addition that fixes a real
functional issue (missing jack events) for systems with this codec. For
6.19.y stable users with cs42l45 hardware, this is needed.

## Verification

- Verified `is_wake_capable()` function at line 72-81 of
  `intel_auxdevice.c` - iterates `wake_capable_list` matching mfg_id and
  part_id
- Verified `is_wake_capable()` is called in 3 places (lines 128, 262,
  276) - all related to device numbering based on wake capability
- Verified cs42l43 was added to wake_capable_list in commit
  `fe600c8e2dc5d`, which is in v6.12
- Verified cs42l45 SDW support (`soc_sdw_cs42l45.c`) was added in commit
  `3f6b562f2107a`, which is in v6.19 but NOT in v6.14, v6.15, v6.13
- Verified cs42l45 SDCA class entry (0x01FA, 0x4245) exists in
  `sound/soc/sdca/sdca_class.c:285`
- Verified cs42l45 SDW utils entry (part_id 0x4245) exists in
  `sound/soc/sdw_utils/soc_sdw_utils.c:711`
- Confirmed via `git merge-base` that cs42l45 support first appeared in
  v6.19

## Conclusion

While this is a trivially safe, single-line device ID addition (a
category normally YES for stable), the practical case for backporting is
weak. The CS42L45 codec itself is only supported starting in v6.19,
making this relevant only for 6.19.y stable. For such new hardware, the
fix would naturally flow into 6.19.y as part of regular stable updates.
The commit is a reasonable candidate for 6.19.y stable, but it's
essentially completing new hardware enablement rather than fixing a
regression or long-standing bug. Given the narrow applicability and the
fact that it's completing brand-new feature support, this is a
borderline case that leans YES due to its trivially safe nature and
clear functional fix for affected hardware.

**YES**

 drivers/soundwire/intel_auxdevice.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soundwire/intel_auxdevice.c b/drivers/soundwire/intel_auxdevice.c
index 6df2601fff909..8752b0e3ce74c 100644
--- a/drivers/soundwire/intel_auxdevice.c
+++ b/drivers/soundwire/intel_auxdevice.c
@@ -52,6 +52,7 @@ struct wake_capable_part {
 
 static struct wake_capable_part wake_capable_list[] = {
 	{0x01fa, 0x4243},
+	{0x01fa, 0x4245},
 	{0x025d, 0x5682},
 	{0x025d, 0x700},
 	{0x025d, 0x711},
-- 
2.51.0

