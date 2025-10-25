Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D43130276A;
	Sat, 25 Oct 2025 16:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408996; cv=none; b=LnQABPdGnRlL2HNOUHobsgFpZkZsBe9bEC4zILfkT3pY09g7mthtgtyDlauKuE55w0bDIF/obL8SbdWAk0Fy0WA2L4yp7uZ8wFnzcB2GZ+cocL9OkXOKCXII7H6JBTM1CZ2kg94Sh6axA+8ff3GhYc9Gh3aqB5GRNbx9NAFjb3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408996; c=relaxed/simple;
	bh=umXtaanC07W+/f1xMp/3t+DD06xxZYzZ425K8Hl9Z1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=INFLO16Qv+fcsAc0dMUYvHDZjbicOx69Kp2md5P+YaS+YKUWAWpsBiKycxSzyiRjJRAgySItRHygEZCLobso7qz1MOenqmuA6CV69ywXG3CkMGjA+AWsAHgrJC6rIAfdSL6d4N0B4Te9fLUE7pbABagjK0RenfXFc92R8EwXez8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wr8ru0me; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wr8ru0me"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DAC5C4CEFB;
	Sat, 25 Oct 2025 16:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408995;
	bh=umXtaanC07W+/f1xMp/3t+DD06xxZYzZ425K8Hl9Z1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wr8ru0meiNQ9ZF36z7gNSNsmFhRQeYQVgXFTSqodsEVYqqJtDFeUwMIVp5zEFJMde
	 ipPsw+SInEpDM9+liZqdpjmjgtj2bgjU7mcT2Zn0DOkd/ulpenr8hJFcd4OtJEH/6U
	 ggbTQxPm4DREKgBEN/8YOqq18DMoYZSU11vz3cGQM2HR8xSL5RbPzkBXbNnzyr41Pu
	 CTebd4Po1ZOM+E64H9d9pw/P5GObPgexPCwaSsoVDWj8y5gWoCEjn/OdBNZM1lbCQt
	 69CyG337Dz2gl32oUCL3XZZkgmF/YEfqElmVex0e9X46mM51GVUKma1lKwZUdD6nrl
	 TU313FibI7aaw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Seyediman Seyedarab <imandevel@gmail.com>,
	Seyediman Seyedarab <ImanDevel@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	alexandre.f.demers@gmail.com,
	alexander.deucher@amd.com
Subject: [PATCH AUTOSEL 6.17-5.4] drm/nouveau: replace snprintf() with scnprintf() in nvkm_snprintbf()
Date: Sat, 25 Oct 2025 11:56:37 -0400
Message-ID: <20251025160905.3857885-166-sashal@kernel.org>
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

From: Seyediman Seyedarab <imandevel@gmail.com>

[ Upstream commit 6510b62fe9303aaf48ff136ff69186bcfc32172d ]

snprintf() returns the number of characters that *would* have been
written, which can overestimate how much you actually wrote to the
buffer in case of truncation. That leads to 'data += this' advancing
the pointer past the end of the buffer and size going negative.

Switching to scnprintf() prevents potential buffer overflows and ensures
consistent behavior when building the output string.

Signed-off-by: Seyediman Seyedarab <ImanDevel@gmail.com>
Link: https://lore.kernel.org/r/20250724195913.60742-1-ImanDevel@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Summary
- Replaces snprintf with scnprintf in nvkm_snprintbf to prevent pointer
  over-advancement and out-of-bounds NUL writes on truncation.
- Small, contained, behavior-preserving fix across widely used
  debug/interrupt logging paths in Nouveau.

Technical Analysis
- Problematic code path:
  - In nvkm_snprintbf, the loop builds a space-separated list of bit
    names: drivers/gpu/drm/nouveau/nvkm/core/enum.c:45–55.
  - It uses snprintf to append:
    drivers/gpu/drm/nouveau/nvkm/core/enum.c:47–50.
  - After each append, it advances the pointer by the return value and
    reduces size: drivers/gpu/drm/nouveau/nvkm/core/enum.c:49–50.
  - On exit, it writes a trailing NUL at the current pointer:
    drivers/gpu/drm/nouveau/nvkm/core/enum.c:55.
- Bug mechanism:
  - snprintf returns the number of characters that would have been
    written (excluding NUL) even when truncated.
  - If the buffer is near full (e.g., size == 1), snprintf returns a
    value > 0, causing size to go negative and data to advance past the
    end of the buffer, so the final data[0] = '\0' writes out-of-bounds
    (drivers/gpu/drm/nouveau/nvkm/core/enum.c:55).
- Fix rationale:
  - scnprintf returns the number of characters actually written into the
    buffer, bounded by size-1 and always consistent with the
    pointer/data movement.
  - Replacing snprintf with scnprintf at
    drivers/gpu/drm/nouveau/nvkm/core/enum.c:47 guarantees that size
    tracking and pointer advancement remain in-bounds and that the final
    NUL write is safe.
- API availability:
  - scnprintf is a long-standing kernel helper declared in
    include/linux/sprintf.h:15, so it exists across stable series.

Impact and Usage Context
- nvkm_snprintbf is used widely to format error/interrupt bitfields into
  human-readable strings (numerous call sites):
  - Example: drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c:1239 (char
    error[128];) and subsequent use of nvkm_snprintbf(error,
    sizeof(error), ...) to log errors.
  - Other examples include:
    drivers/gpu/drm/nouveau/nvkm/engine/gr/nv50.c:272,
    drivers/gpu/drm/nouveau/nvkm/engine/gr/nv40.c:271–273,
    drivers/gpu/drm/nouveau/nvkm/subdev/ltc/gf100.c:103,
    drivers/gpu/drm/nouveau/nvkm/subdev/ltc/gm107.c:82.
- While buffers are typically 64–128 bytes, concatenating multiple bit
  names can still reach truncation boundaries. The current code can then
  over-advance and perform an OOB NUL write. This is memory corruption
  (albeit a single byte) on the kernel stack and should be fixed.

Risk/Regression Assessment
- Change scope is a one-line replacement local to the function; no
  API/ABI change.
- scnprintf semantics match the intended logic of “advance by what we
  wrote,” preventing negative size and pointer overflow.
- Behavior under truncation improves: instead of corrupting memory, the
  function simply yields a properly NUL-terminated string with as much
  content as fits.
- No architectural changes; only string formatting mechanics inside a
  helper used for logging and diagnostics.

Stable Backport Criteria
- Fixes a real bug that can corrupt memory (stack OOB write) in common
  code paths.
- Minimal, self-contained, and low-risk change.
- Not a feature addition; purely correctness/safety.
- Touches only the Nouveau driver helper; broad benefit across many call
  sites without side effects.
- No special dependencies; scnprintf is present across stable kernels.

Backport Notes
- Function prototype remains unchanged:
  drivers/gpu/drm/nouveau/include/nvkm/core/enum.h:21.
- Ensure include paths bring in scnprintf (declared in
  include/linux/sprintf.h:15). Nouveau’s headers already include
  standard Linux headers via drivers/gpu/drm/nouveau/include/nvif/os.h
  which pulls core kernel headers, so no additional includes are needed.

Conclusion
- This is a classic correctness/safety fix that prevents a subtle but
  real OOB write. It is small, contained, and aligns with stable policy.
  Backporting is recommended.

 drivers/gpu/drm/nouveau/nvkm/core/enum.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/core/enum.c b/drivers/gpu/drm/nouveau/nvkm/core/enum.c
index b9581feb24ccb..a23b40b27b81b 100644
--- a/drivers/gpu/drm/nouveau/nvkm/core/enum.c
+++ b/drivers/gpu/drm/nouveau/nvkm/core/enum.c
@@ -44,7 +44,7 @@ nvkm_snprintbf(char *data, int size, const struct nvkm_bitfield *bf, u32 value)
 	bool space = false;
 	while (size >= 1 && bf->name) {
 		if (value & bf->mask) {
-			int this = snprintf(data, size, "%s%s",
+			int this = scnprintf(data, size, "%s%s",
 					    space ? " " : "", bf->name);
 			size -= this;
 			data += this;
-- 
2.51.0

