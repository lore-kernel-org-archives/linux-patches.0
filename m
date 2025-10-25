Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26EF2FBE03;
	Sat, 25 Oct 2025 16:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408905; cv=none; b=lS7rSbHmcPaGrfLkvQYK2QxXJnw7TNzuJsYBrhAtzzD8USkUahgGX6Wl7DPNuA12xwTK6yATrZ7U1L15NV9QJsRQggzfEUXpEaCv4WzNKV1sTTL0BQLhPxtar1MjFew44sCL66TKNa6ffkeDl9zuOiKyQ0O9vi7B6wYi9CpqeBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408905; c=relaxed/simple;
	bh=5hAGcM9YPHs4sfHtcG2tXpU8bTWsuspuhliaIWPE444=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H1WjVTiVXWaPHV+T35dG2u+ytPGszGM4wzELLmeDZDSYY5BVWbFzibKNR4N3yn7pp6Z1Tfaz810+h+dYKQLtrXN88OsVptLnh5hpYRnQKUdXLgObflBAO2ldGECxKwIGCs5Su1qAi/Fyk2Vz/uTq/sJVoWJY8zLTj6rdDh06Xuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bf6/Nfyk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bf6/Nfyk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3D0C4CEF5;
	Sat, 25 Oct 2025 16:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408905;
	bh=5hAGcM9YPHs4sfHtcG2tXpU8bTWsuspuhliaIWPE444=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bf6/Nfyk4nuplhuvGWUst50YEA/iBFTZp724BwO7vdNhHb26B4DhYo9aqMOqVzdji
	 nieC2vkDLZmoLGLunwcaZrhomGatXfSvz5DLthntG/GufJ+INcvcsp6lAxmxtCRoaU
	 68xk+bp4HEsRGanXi4spBvrYdUh9ujWGEX6l9qMVFCNhWg37Z7d/FjYEobeG4VAh0I
	 C2E3eY2vz2KjcjLyLqDecumJQbcIivQ+v333Nj5lXH7gzkZmUoM1EGouUBYhUTotbm
	 MwzIEzLmfE1OTXeMTmR86Ndq7oJXQbwbiqk7vjKXql9XXl8uvEf3es+X/GO9Wrwhec
	 LfE31GfXnYSVw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ovidiu Bunea <ovidiu.bunea@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Syed.Hassan@amd.com,
	wayne.lin@amd.com,
	chiahsuan.chung@amd.com,
	Austin.Zheng@amd.com,
	alexandre.f.demers@gmail.com,
	gabe.teeger@amd.com,
	aurabindo.pillai@amd.com
Subject: [PATCH AUTOSEL 6.17] drm/amd/display: Fix dmub_cmd header alignment
Date: Sat, 25 Oct 2025 11:55:54 -0400
Message-ID: <20251025160905.3857885-123-sashal@kernel.org>
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

From: Ovidiu Bunea <ovidiu.bunea@amd.com>

[ Upstream commit 327aba7f558187e451636c77a1662a2858438dc9 ]

[why & how]
Header misalignment in struct dmub_cmd_replay_copy_settings_data and
struct dmub_alpm_auxless_data causes incorrect data read between driver
and dmub.
Fix the misalignment and ensure that everything is aligned to 4-byte
boundaries.

Reviewed-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Ovidiu Bunea <ovidiu.bunea@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes and why it matters
  - The patch corrects structure layout so the driver and DMUB firmware
    agree on field offsets. The commit message explicitly states that
    header misalignment in the DMUB command payloads caused “incorrect
    data read between driver and dmub,” which can lead to wrong
    parameter values being consumed by firmware for Replay/ALPM
    sequences — a real user-visible reliability/power bug.
  - AMD’s DMUB command ABI uses strict 4‑byte alignment across command
    headers and payloads; this patch brings the new Replay/ALPM-related
    payloads back into conformance.

- Specific code changes that address the bug
  - drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
    - struct dmub_alpm_auxless_data: add an explicit 1‑byte padding
      field to enforce 4‑byte alignment.
      - Added: `uint8_t pad[1];`
      - Rationale: prior layout had a total size not divisible by 4
        (several 16‑bit fields + an 8‑bit field), so the next field in
        the containing payload could be misaligned.
    - struct dmub_cmd_replay_copy_settings_data: reorder and align
      fields and ensure 4‑byte boundary padding at the end.
      - The two 8‑bit HPO instance fields were moved to follow the
        `auxless_alpm_data` sub‑structure:
        - Added here: `uint8_t hpo_stream_enc_inst;` and `uint8_t
          hpo_link_enc_inst;`
        - Removed from their earlier position near other `*_inst`
          fields.
      - The struct retains explicit padding at the end to maintain
        4‑byte alignment: `uint8_t pad[2];`
      - Net effect: the nested `auxless_alpm_data` is now 4‑byte aligned
        itself, and the subsequent 8‑bit instance fields and final pad
        keep the overall payload size and alignment consistent with the
        DMUB ABI expectations.
    - struct dmub_rb_cmd_replay_copy_settings remains the same, but now
      wraps a correctly aligned payload.

- Scope, risk, and stable suitability
  - Scope is tightly confined to a single header (`dmub_cmd.h`) and to
    DMUB command payload definitions for Replay/ALPM — no functional
    logic changes and no architectural churn.
  - The change follows existing patterns in `dmub_cmd.h`, which already
    uses explicit “pad” members to guarantee 4‑byte alignment in many
    payloads.
  - Regression risk is low: it fixes a clear ABI/layout defect. The only
    compatibility consideration is driver–firmware agreement; given the
    commit message states the misalignment caused DMUB to read incorrect
    data, the fix aligns the driver to firmware’s expected layout rather
    than introducing a new protocol.
  - No new features are introduced; this is a correctness fix with
    minimal code delta.

- Backport guidance
  - Good candidate for stable backporting to branches that already
    contain:
    - `struct dmub_alpm_auxless_data` and
    - the `hpo_stream_enc_inst`/`hpo_link_enc_inst` fields in `struct
      dmub_cmd_replay_copy_settings_data`.
  - Branches that predate these fields (i.e., older DMUB interfaces
    without AUX‑less ALPM/HPO support) don’t need this patch.
  - As with all DMUB ABI fixes, ensure the target stable branch’s
    expected DMUB firmware matches this layout (the fix exists precisely
    because mismatch caused bad reads).

Given it fixes real misreads at the driver–firmware boundary with a
minimal, alignment-only change confined to
`drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h`, it meets stable
backport criteria.

 drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h b/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
index 6a69a788abe80..6fa25b0375858 100644
--- a/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
+++ b/drivers/gpu/drm/amd/display/dmub/inc/dmub_cmd.h
@@ -4015,6 +4015,10 @@ struct dmub_alpm_auxless_data {
 	uint16_t lfps_t1_t2_override_us;
 	short lfps_t1_t2_offset_us;
 	uint8_t lttpr_count;
+	/*
+	 * Padding to align structure to 4 byte boundary.
+	 */
+	uint8_t pad[1];
 };
 
 /**
@@ -4092,6 +4096,14 @@ struct dmub_cmd_replay_copy_settings_data {
 	 */
 	struct dmub_alpm_auxless_data auxless_alpm_data;
 
+	/**
+	 * @hpo_stream_enc_inst: HPO stream encoder instance
+	 */
+	uint8_t hpo_stream_enc_inst;
+	/**
+	 * @hpo_link_enc_inst: HPO link encoder instance
+	 */
+	uint8_t hpo_link_enc_inst;
 	/**
 	 * @pad: Align structure to 4 byte boundary.
 	 */
-- 
2.51.0

