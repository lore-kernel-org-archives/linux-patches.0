Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EB51E520A;
	Thu,  9 Oct 2025 15:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025554; cv=none; b=eo5u+/K76qv5JGrjavotIbTCpGoBczjaHhxfxNKi2p5Qi5YOEqU1Jx1RQAEb6481mJMq3Shgk6U2guSQUeirxPao4hG3raX5NYIJWYuV2u4n/XKoZCc2sFwObRe0uTv2ARUzOmj+nJ9KF8s9rpMPZFxXcHd/aB44NPWfRDnnPlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025554; c=relaxed/simple;
	bh=j82kfh2YLV2QBdtDTdeyfaMwzuM+yyfO6wU1shxDTB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RItZkOVH2NZqhiX/m421NKm5aZW45t/PRMXq5tKL6mfmLp8LdmJ5P4nHhrtdbuD+7MPrlQR0udHdp5BktOvryjqQQJOzO5rOblVxj75jj//M+8O2tdvjgElKJVO0km9/vZuFMV532j+iNmTUf/WgnafApZNiOkFo8aVtziyWu3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fBf2d5Uv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fBf2d5Uv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5D2C4CEE7;
	Thu,  9 Oct 2025 15:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025554;
	bh=j82kfh2YLV2QBdtDTdeyfaMwzuM+yyfO6wU1shxDTB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fBf2d5UvGJ45t/0eRnEeHEe4XYz2MqKEaDGDxVXe55et2RTaHhu9D0SBeCyzZBfuV
	 k9P8O4RybUcCvwcdVNSF2pLWETMHORTIm7pG+f8ed8DXN1rrbR9F1FyFsEJA9y84fM
	 hjpPr4SzZpuSdpU25yp3UZbrN/mC/QbKdTC8ns+R6NUV4gCyMtz3jmfOWXlcqSypJy
	 SHTdaOcc3KcpcP6tiErIqo0Os8GjjjjBo/7Q9fg8DzMnvpixAoTsRAnF5TrpkCDgrH
	 LV9tuBshpXLyCDUEQrXmnA10cHAB43wO04RDwx6OQU8vBtyDnzMk5otBgHpXXs2BFY
	 nkzVGcU/7aUAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-5.10] tools/power x86_energy_perf_policy: Fix incorrect fopen mode usage
Date: Thu,  9 Oct 2025 11:55:10 -0400
Message-ID: <20251009155752.773732-44-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit 62127655b7ab7b8c2997041aca48a81bf5c6da0c ]

The fopen_or_die() function was previously hardcoded
to open files in read-only mode ("r"), ignoring the
mode parameter passed to it. This patch corrects
fopen_or_die() to use the provided mode argument,
allowing for flexible file access as intended.

Additionally, the call to fopen_or_die() in
err_on_hypervisor() incorrectly used the mode
"ro", which is not a valid fopen mode. This is
fixed to use the correct "r" mode.

Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What it fixes
  - Corrects `fopen_or_die()` to honor the caller-provided mode instead
    of hardcoding read-only. This restores intended API semantics and
    prevents subtle bugs if any future or out-of-tree code uses it for
    write/append.
    - Fixed line: tools/power/x86/x86_energy_perf_policy/x86_energy_perf
      _policy.c:634
  - Replaces an invalid fopen mode string `"ro"` with the valid `"r"` in
    `err_on_hypervisor()`. While previously masked by the hardcoded
    `"r"` inside `fopen_or_die()`, this was a latent bug and is now
    properly fixed.
    - Fixed line: tools/power/x86/x86_energy_perf_policy/x86_energy_perf
      _policy.c:648

- Scope and risk
  - Small, contained, two-line behavioral fixes in a userspace tool. No
    API or architectural changes; no kernel subsystems touched.
  - Call sites in this tool currently pass `"r"` (e.g., reading sysfs or
    `/proc`) and writes use plain `fopen("w")`, not `fopen_or_die()`. So
    runtime behavior for existing paths remains unchanged and risk of
    regression is effectively zero.
    - Read uses: tools/power/x86/x86_energy_perf_policy/x86_energy_perf_
      policy.c:1254, tools/power/x86/x86_energy_perf_policy/x86_energy_p
      erf_policy.c:1300
    - Direct write uses (not via `fopen_or_die()`): tools/power/x86/x86_
      energy_perf_policy/x86_energy_perf_policy.c:972
  - Harmonizes behavior with the sibling tool `turbostat`, whose
    `fopen_or_die()` already uses the provided mode argument.
    - Reference: tools/power/x86/turbostat/turbostat.c:4353

- User impact and history
  - This is a real bug: the function’s signature promised a mode, but it
    was ignored. That could cause confusing failures if any code
    attempted to open with `"w"`/`"a"` through `fopen_or_die()`. The
    invalid `"ro"` string is also a correctness issue (would fail if the
    mode were ever honored).
  - The bug has been present since the VM error-handling addition in
    2020, and persists in released stable tags (e.g., v5.10, v5.15,
    v6.1, v6.6, v6.8, v6.10) where `err_on_hypervisor()` still passes
    `"ro"` and `fopen_or_die()` hardcodes `"r"`. This patch addresses
    both together, eliminating the latent defect in those series.

- Stable criteria
  - Important bugfix (correctness, latent functional bug, removes
    invalid mode usage).
  - Minimal, localized change with negligible regression risk.
  - No new features or architectural shifts; limited to
    `tools/power/x86`.
  - Improves consistency and future-proofing of the tool.

Given these points, this change is a strong candidate for stable
backport.

 .../power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
index ebda9c366b2ba..c883f211dbcc9 100644
--- a/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
+++ b/tools/power/x86/x86_energy_perf_policy/x86_energy_perf_policy.c
@@ -630,7 +630,7 @@ void cmdline(int argc, char **argv)
  */
 FILE *fopen_or_die(const char *path, const char *mode)
 {
-	FILE *filep = fopen(path, "r");
+	FILE *filep = fopen(path, mode);
 
 	if (!filep)
 		err(1, "%s: open failed", path);
@@ -644,7 +644,7 @@ void err_on_hypervisor(void)
 	char *buffer;
 
 	/* On VMs /proc/cpuinfo contains a "flags" entry for hypervisor */
-	cpuinfo = fopen_or_die("/proc/cpuinfo", "ro");
+	cpuinfo = fopen_or_die("/proc/cpuinfo", "r");
 
 	buffer = malloc(4096);
 	if (!buffer) {
-- 
2.51.0

