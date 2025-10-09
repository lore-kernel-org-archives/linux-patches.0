Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0409E2FBE09;
	Thu,  9 Oct 2025 16:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025638; cv=none; b=nDHwh9vklQ/7XbBQXClaetMFs0KdyR5R7Yguh4HPpmqZRENqVuahfuyUcxexDjlJIqoTKaUVkXckImAjHeEGa3iTR4tSBSFG1TikQ6456XO7eF3L2f9R4goZbXfKIBoGR/G0xoFd/NCokCb4p4KOHBjb3Y+Hkpjpz1mJAQ7Wj8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025638; c=relaxed/simple;
	bh=ALThAbtUaT72qVaCD2dRMI9yWcRKFS93pvx7JXbR47M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QDBk6wC1khdinIO1wwZdM+gd2+T0zcpqGtHu4qz11poX10EcOnc6XO4hrIWUuZgr4MSDUF5GwVSJyu6w6N5AmtF75Hzi/nYn3r8vm4eV+IYdVCdVvVmuFYO2qJwelTR8ChPlRSXLUP34F8BPGGVFcKadUQXFB0LMspJiDa+eWN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IhXRQidw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IhXRQidw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6178C4CEE7;
	Thu,  9 Oct 2025 16:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025637;
	bh=ALThAbtUaT72qVaCD2dRMI9yWcRKFS93pvx7JXbR47M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IhXRQidww2WXw5y5l5wJAu+aLeXMytEbRgl7OR8Uuzm7/sU+HiyVjWtrbGWc/kbwG
	 uH7wQrd5K0jGL7MXnLQc8LrWXdKIMCse5S++sW9UxxFvzwrk6v7vScl2sdVxwBX4G+
	 iRUfk/iXxrptgEHQEsyBZIc44k/U6H9HU8cxS81F3GJnMOV9F4CGk71iDnueWO9RA8
	 nC6pf73As63lhcLjaDOAEYnBMVKplCueIhwtpP36sxXpMEES3phH7l2jFtmrVVFFwo
	 NGVyaG8F56L8NZHq35wN+V9OeE27sIIu/TG7hZgbyBiOnu2viRsg+WXoR9xi36tqnJ
	 ZA+rJtjiUCnOQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Neal Gompa <neal@gompa.dev>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sven Peter <sven@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	asahi@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17-6.6] pmdomain: apple: Add "apple,t8103-pmgr-pwrstate"
Date: Thu,  9 Oct 2025 11:55:55 -0400
Message-ID: <20251009155752.773732-89-sashal@kernel.org>
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

From: Janne Grunau <j@jannau.net>

[ Upstream commit 442816f97a4f84cb321d3359177a3b9b0ce48a60 ]

After discussion with the devicetree maintainers we agreed to not extend
lists with the generic compatible "apple,pmgr-pwrstate" anymore [1]. Use
"apple,t8103-pmgr-pwrstate" as base compatible as it is the SoC the
driver and bindings were written for.

[1]: https://lore.kernel.org/asahi/12ab93b7-1fc2-4ce0-926e-c8141cfe81bf@kernel.org/

Signed-off-by: Janne Grunau <j@jannau.net>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sven Peter <sven@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed: The patch adds a single OF compatible to the driver
  match table to explicitly support the Apple M1 (t8103) PMGR power-
  state nodes. Concretely, it inserts `{ .compatible =
  "apple,t8103-pmgr-pwrstate" }` in `drivers/pmdomain/apple/pmgr-
  pwrstate.c:309`, keeping the existing generic fallback `{ .compatible
  = "apple,pmgr-pwrstate" }` just below it (drivers/pmdomain/apple/pmgr-
  pwrstate.c:310).
- Rationale from commit message: DT maintainers agreed to stop extending
  nodes with the generic `"apple,pmgr-pwrstate"` and instead use the
  SoC-specific string as the base compatible. Without this addition, a
  DT using only `"apple,t8103-pmgr-pwrstate"` would fail to bind the
  driver.
- Scope and risk: The change is a single-line device-ID addition to the
  OF match table. It does not touch runtime logic, data structures,
  Kconfig, or probe/remove paths. There are no architectural changes.
  This kind of “add a new compatible ID” patch is routinely accepted for
  stable because it’s low-risk and purely affects device binding.
- User impact fixed: On systems providing a DTB that omits the generic
  fallback (aligned with the new binding guidance), the driver would not
  probe, leaving PM domains and reset control unmanaged. Adding the
  t8103 compatible restores functionality. This is a real, user-visible
  failure mode when booting older kernels with newer DTBs or bootloader-
  provided DTBs following updated conventions.
- Alignment with bindings: The bindings already enumerate SoC-specific
  compatibles, including `"apple,t8103-pmgr-pwrstate"`
  (Documentation/devicetree/bindings/power/apple,pmgr-pwrstate.yaml:41).
  The driver now matches that SoC-specific string directly, which aligns
  the implementation with binding expectations going forward.
- No regressions expected: Existing DTs that list both
  `"apple,t8103-pmgr-pwrstate", "apple,pmgr-pwrstate"` continue to bind
  identically, only preferring the SoC-specific match. DTs that still
  only have the generic string continue to work via the unchanged `{
  .compatible = "apple,pmgr-pwrstate" }` entry
  (drivers/pmdomain/apple/pmgr-pwrstate.c:310).
- Stable policy fit: This is a minimal, contained, non-feature change
  that enables correct binding for an existing driver on an existing SoC
  and prevents regressions with evolving DTs. There’s no security
  implication and no interaction with critical core subsystems beyond OF
  matching.
- Backport note: On older stable series, the file may reside under a
  different path (pre-“pmdomain” rename). The change remains a trivial
  OF-ID addition to the same match table in that file.

Given the above, this is a textbook low-risk backport that prevents real
breakage with newer DTBs and should be backported to stable trees that
already contain the Apple PMGR power-state driver.

 drivers/pmdomain/apple/pmgr-pwrstate.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pmdomain/apple/pmgr-pwrstate.c b/drivers/pmdomain/apple/pmgr-pwrstate.c
index 9467235110f46..82c33cf727a82 100644
--- a/drivers/pmdomain/apple/pmgr-pwrstate.c
+++ b/drivers/pmdomain/apple/pmgr-pwrstate.c
@@ -306,6 +306,7 @@ static int apple_pmgr_ps_probe(struct platform_device *pdev)
 }
 
 static const struct of_device_id apple_pmgr_ps_of_match[] = {
+	{ .compatible = "apple,t8103-pmgr-pwrstate" },
 	{ .compatible = "apple,pmgr-pwrstate" },
 	{}
 };
-- 
2.51.0

