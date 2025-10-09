Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FBB2F25FD;
	Thu,  9 Oct 2025 15:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025548; cv=none; b=jwcYHTS1qpDhdT5YFMtLloNvWgb8XiwLzAdawoI4JqpESf8e7aq7MjESN1JcL/z7NJpadlvq4BBJLpDXb8u2v/eiN5SHWtKUHeYnolt1ricGXQp9KJ4giDqXWDraDh7lk4bMRNe8MzvZ9mXXAXjrVStGekh9mvebQlc30aotzCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025548; c=relaxed/simple;
	bh=M0d/cnF+33Don3wW+JMwAO13Eu7zb/6Dnpq8fGlfMhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dGHUCs6Yb2Vg5S0YPQrOpXhEFBV1KJqB9Skbix3SpxJ/FDZKfvj6Nl6rMaO9+le264k6e6tO7BYxJv4oo8CJd/NgrO4rN4bpO2Oats3KMLAYD5DA6f8fGFSBDiRRJojR3vuptv6vyMTorMbA30IvTDOlqGx4YQ0K34hkYqCPN4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mcn/J2af; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mcn/J2af"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AE9C4CEE7;
	Thu,  9 Oct 2025 15:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025547;
	bh=M0d/cnF+33Don3wW+JMwAO13Eu7zb/6Dnpq8fGlfMhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mcn/J2afPcTrFDBMLgiS4CVpym3bncuukc7yvJ72sLU3SINS2CPr/x9bugDsGCTLl
	 y8gGyBu6cu2L3POzZJ6Zdjzi8H5bS8ilDsKlkbwoZOzzr9c+2JYhXHnU5i4JxhXG0t
	 bVZUoQ25yXBwNCCMAaKCtLvKvDQCQRf9rNw9NtRXJAc4e7fFYuRXIVY0E7D3saCWSl
	 AKnT20P8fcjBJzrcfXoqN4DuKyBcDWsPYEjdBcVxUfE5Xs+BdkrwruVHm7jKv4I9Xa
	 YY3QP+uQv7kS5elqBIFUPk7ByWYlRvMn0sBKeq/S62pJHSIsVZg4MDPD5khNXG7CJ5
	 OJjcAdsd2mcfg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Janne Grunau <j@jannau.net>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	sven@kernel.org,
	asahi@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.17] mfd: macsmc: Add "apple,t8103-smc" compatible
Date: Thu,  9 Oct 2025 11:55:06 -0400
Message-ID: <20251009155752.773732-40-sashal@kernel.org>
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

[ Upstream commit 9b959e525fa7e8518e57554b6e17849942938dfc ]

After discussion with the devicetree maintainers we agreed to not extend
lists with the generic compatible "apple,smc" anymore [1]. Use
"apple,t8103-smc" as base compatible as it is the SoC the driver and
bindings were written for.

[1]: https://lore.kernel.org/asahi/12ab93b7-1fc2-4ce0-926e-c8141cfe81bf@kernel.org/

Signed-off-by: Janne Grunau <j@jannau.net>
Link: https://lore.kernel.org/r/20250828-dt-apple-t6020-v1-18-507ba4c4b98e@jannau.net
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed
  - Adds a new OF match entry `{ .compatible = "apple,t8103-smc" }` to
    the driver’s match table in drivers/mfd/macsmc.c:481, leaving the
    existing generic match `{ .compatible = "apple,smc" }` intact.

- Why it matters
  - Devicetree policy is moving away from expanding generic compatibles
    like `"apple,smc"` and towards SoC‑specific base compatibles. The
    binding documents this pattern and uses SoC‑specific compatibles
    with explicit fallback chains
    (Documentation/devicetree/bindings/mfd/apple,smc.yaml:20).
  - Current DTs for Apple SoCs use these patterns:
    - t8103 (M1) nodes include `"apple,t8103-smc"`
      (arch/arm64/boot/dts/apple/t8103.dtsi:900).
    - t6020 (M2 Pro) nodes use `"apple,t6020-smc", "apple,t8103-smc"`
      (arch/arm64/boot/dts/apple/t602x-die0.dtsi:105), intentionally
      avoiding the generic `"apple,smc"`.
  - Before this change, the driver only matched `"apple,smc"`
    (v6.17:drivers/mfd/macsmc.c showed only the generic match), so
    kernels without the `"apple,t8103-smc"` entry would fail to bind on
    DTs that omit the generic fallback, causing the SMC MFD (and all
    dependent subdevices like GPIO and reboot) not to probe.

- Risk and scope
  - Minimal and contained: a one‑line addition to an OF match table
    (drivers/mfd/macsmc.c:481). No functional code paths change, no
    behavioral differences for already working systems, and no
    architectural changes.
  - Security-neutral: no new I/O or parsing paths are introduced; only
    device binding is enabled for an SoC‑specific compatible.
  - No negative side effects expected: the new match string is specific
    and does not overlap with other drivers.

- Stable suitability
  - This is a classic “device/compatible ID addition” that fixes a user-
    visible binding failure when DTs conform to updated bindings that
    avoid the generic `"apple,smc"`. Such ID additions are routinely
    accepted into stable to enable hardware that otherwise won’t probe.
  - Although the commit lacks an explicit Cc: stable, it meets stable
    rules: important fix (driver doesn’t bind on modern DTs), minimal
    risk, no features, and confined to the MFD subsystem.

Conclusion: Backporting ensures the macsmc driver binds on DTs using the
SoC-based compatible scheme (notably those that rely on
`"apple,t8103-smc"` fallback), with negligible regression risk.

 drivers/mfd/macsmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/macsmc.c b/drivers/mfd/macsmc.c
index 870c8b2028a8f..a5e0b99484830 100644
--- a/drivers/mfd/macsmc.c
+++ b/drivers/mfd/macsmc.c
@@ -478,6 +478,7 @@ static int apple_smc_probe(struct platform_device *pdev)
 }
 
 static const struct of_device_id apple_smc_of_match[] = {
+	{ .compatible = "apple,t8103-smc" },
 	{ .compatible = "apple,smc" },
 	{},
 };
-- 
2.51.0

