Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF48306498;
	Sat, 25 Oct 2025 16:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409078; cv=none; b=MuKRGyLSjdIY8lQGCptLbkDax6sf80TcsADkfQeWqT8I/7C9ZjMf6ZY6lEED3zZF/fqzxy/16drA7HNhzZcgrQEaG8nci2Rh1XeaBRc+genngQcCpCGuEwqA6qt4bDqJMrou+AD7jWWkPAccLbH8qWn2lLsozf5wf7SssnkWoY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409078; c=relaxed/simple;
	bh=SlFMHbG3IUa6AzlLmrtJS+LPhgeeFmQdhudk9AS2AsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ya1yxOij4G5ivyqPlFAm7TUR/ucLxVeKCRTx1MU3H2y2cjFjT1DwxlfIoh2dRJ3AGT/HUXTwD26Uw9qOUCxLK04AzkVDciKQpFSjwKmIc3igmMKgio+MTLKzWXJIJDz2aTEfCxme92005rMHzoTsUYT6rq0hkcF4sXIVrRjyf6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bdfZ5Ez8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bdfZ5Ez8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DEDC4CEF5;
	Sat, 25 Oct 2025 16:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409078;
	bh=SlFMHbG3IUa6AzlLmrtJS+LPhgeeFmQdhudk9AS2AsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdfZ5Ez839LsjqIO83ZpuWnonI7qy8CDdyMYh7e3n1kJCXCXzIKOP7q0O2DUWfbOq
	 m+Hy1kBKXk6TXDPjKnjO/UbpPAoD71WZ8Ro+vz44+CIK8oyiq/el4/p/GKI9F355WO
	 pj+ngmQymZ6thXj0QaaqHYal+FI2PyYGvjAf48Tdu7JgvRL5m6lSng8snkjFyYvFoI
	 gN/IyGVTiQDP+h7pkW1ejA5DfXqs4uiVCtLBZeqfDaKQpwRh33QCQQGHuFYrpl1X+f
	 ARyoLwCji5/19drTFg+3yjxXf9YjqTWprjQLjrAfkV93B5g11e5sp5aV8erLfDLlzw
	 cTdkff7E0Hsaw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: TungYu Lu <tungyu.lu@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	charlene.liu@amd.com,
	alex.hung@amd.com,
	aric.cyr@amd.com,
	christophe.jaillet@wanadoo.fr,
	Josip.Pavic@amd.com,
	alexandre.f.demers@gmail.com,
	dmytro.laktyushkin@amd.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amd/display: Wait until OTG enable state is cleared
Date: Sat, 25 Oct 2025 11:57:04 -0400
Message-ID: <20251025160905.3857885-193-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: TungYu Lu <tungyu.lu@amd.com>

[ Upstream commit e7496c15d830689cc4fc666b976c845ed2c5ed28 ]

[Why]
Customer reported an issue that OS starts and stops device multiple times
during driver installation. Frequently disabling and enabling OTG may
prevent OTG from being safely disabled and cause incorrect configuration
upon the next enablement.

[How]
Add a wait until OTG_CURRENT_MASTER_EN_STATE is cleared as a short term
solution.

Reviewed-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: TungYu Lu <tungyu.lu@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes: The change addresses a real, user-visible race during
  rapid start/stop sequences where disabling and then quickly re-
  enabling the OTG can leave the hardware in a partially enabled state,
  leading to incorrect configuration on the next enable. The commit
  explicitly frames this as a customer-reported problem during driver
  installation.

- What changes: A single wait is added to the DCN401 OTG disable path to
  ensure the hardware has actually cleared the enable state before
  proceeding.
  - In `drivers/gpu/drm/amd/display/dc/optc/dcn401/dcn401_optc.c:223`
    the code disables OTG via `REG_UPDATE(OTG_CONTROL, OTG_MASTER_EN,
    0);`.
  - In
    `drivers/gpu/drm/amd/display/dc/optc/dcn401/dcn401_optc.c:226-227`
    it disables VTG via `REG_UPDATE(CONTROL, VTG0_ENABLE, 0);`.
  - The patch adds immediately after those writes a poll for the status
    bit to clear:
    - `REG_WAIT(OTG_CONTROL, OTG_CURRENT_MASTER_EN_STATE, 0, 10,
      15000);` (inserted between the VTG disable and the existing
      clock/idle wait).
  - The existing wait for the OTG to go idle remains:
    - `REG_WAIT(OTG_CLOCK_CONTROL, OTG_BUSY, 0, 1, 150000);` at `drivers
      /gpu/drm/amd/display/dc/optc/dcn401/dcn401_optc.c:230-232`.

- Rationale and precedent: Waiting for `OTG_CURRENT_MASTER_EN_STATE` to
  assert/deassert is already a known-safe pattern in older DCN code
  paths:
  - See `drivers/gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c:274-279`
    (wait for 0 after disable) and
    `drivers/gpu/drm/amd/display/dc/optc/dcn20/dcn20_optc.c:351-353`
    (wait for 1 after enable). This demonstrates that using
    `OTG_CURRENT_MASTER_EN_STATE` for synchronization is standard
    practice in the display code.

- Scope and risk:
  - Small, contained change in one function of one file:
    `drivers/gpu/drm/amd/display/dc/optc/dcn401/dcn401_optc.c`.
  - No interfaces or architectural changes; purely a
    sequencing/synchronization fix.
  - The added wait is bounded (10 µs interval, 15000 tries ≈ 150 ms
    worst case), consistent with existing waits in the same path
    (`OTG_BUSY` wait is already up to ~150 ms). Given this occurs during
    CRTC disable, the latency impact is acceptable and low-risk.
  - Security impact: none.

- Dependencies to verify when backporting:
  - Ensure the register field mapping for `OTG_CURRENT_MASTER_EN_STATE`
    is wired for DCN401 so the wait checks the correct bit. The bit is
    defined for DCN 4.1 in
    `drivers/gpu/drm/amd/include/asic_reg/dcn/dcn_4_1_0_sh_mask.h:26946,
    26953`.
  - In this tree, the DCN common TG field set includes
    `OTG_CURRENT_MASTER_EN_STATE` (see
    `drivers/gpu/drm/amd/display/dc/optc/dcn10/dcn10_optc.h:242, 404`),
    but DCN401’s mask/shift list is curated in
    `drivers/gpu/drm/amd/display/dc/optc/dcn401/dcn401_optc.h`. If the
    target stable branch’s `OPTC_COMMON_MASK_SH_LIST_DCN401` does not
    include `SF(OTG0_OTG_CONTROL, OTG_CURRENT_MASTER_EN_STATE,
    mask_sh)`, add it; otherwise the new wait may degenerate into a no-
    op due to an unset mask/shift.

- Stable criteria:
  - Fixes a real, user-facing bug (incorrect OTG reconfiguration under
    rapid toggling).
  - Minimal and localized change (one added wait).
  - No new features or architectural rework.
  - Low regression risk; follows established synchronization patterns
    used in other DCN generations.

Conclusion: This is a good candidate for stable backporting. It’s a
narrowly scoped hardware sequencing fix with clear user impact,
implemented using a standard wait on an existing status bit. Ensure the
DCN401 mask/shift mapping includes `OTG_CURRENT_MASTER_EN_STATE` in the
target stable branch so the wait is effective.

 drivers/gpu/drm/amd/display/dc/optc/dcn401/dcn401_optc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/optc/dcn401/dcn401_optc.c b/drivers/gpu/drm/amd/display/dc/optc/dcn401/dcn401_optc.c
index ff79c38287df1..5af13706e6014 100644
--- a/drivers/gpu/drm/amd/display/dc/optc/dcn401/dcn401_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/optc/dcn401/dcn401_optc.c
@@ -226,6 +226,11 @@ bool optc401_disable_crtc(struct timing_generator *optc)
 	REG_UPDATE(CONTROL,
 			VTG0_ENABLE, 0);
 
+	// wait until CRTC_CURRENT_MASTER_EN_STATE == 0
+	REG_WAIT(OTG_CONTROL,
+			 OTG_CURRENT_MASTER_EN_STATE,
+			 0, 10, 15000);
+
 	/* CRTC disabled, so disable  clock. */
 	REG_WAIT(OTG_CLOCK_CONTROL,
 			OTG_BUSY, 0,
-- 
2.51.0

