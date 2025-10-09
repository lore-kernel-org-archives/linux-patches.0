Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F2E2F60A4;
	Thu,  9 Oct 2025 16:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025686; cv=none; b=Ajwgwgb/Y1w7qJKM6ukWK+rPk9h3/9cAtF4tE+wxpRDWRC6qCzMwH3J+pbkEdY+O9DzDJ1oPNxUvRlAU0BMAM1j5ZqGYchmGpbxqhAikYPt4hv4dGtzFAyy12yIuWUHhsbuIvK11R1XyLHBXYzaehZUZjZJ9jFW+aIrvlEcLzmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025686; c=relaxed/simple;
	bh=9g99qVtUafZRvAj+pTB+CkkG25MUODhBMH+L/Q/qHCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M0Qb0LkBQuswk4kESifA7Wjz7lx8ERN5Nb2ESSnikmK/NxNzkNhN/uE+DoQLYsrALCDbWxngY76Tmg/S/Qu7ubAeJAgj8ArkO4sYtczmdqgUnC50rbahlayiQjj9ho8J1f1OEf6BTyNxoqmkx3oGhD2PQNANx//u5Dp29ZEjSZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PkGycMQd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PkGycMQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8947C4CEE7;
	Thu,  9 Oct 2025 16:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025686;
	bh=9g99qVtUafZRvAj+pTB+CkkG25MUODhBMH+L/Q/qHCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PkGycMQdviLMoLIGGnZlE4H+GXGAH4Ez0ER7tdhs+GH+f/TnrB7CWdixwDwKbJZlm
	 1ve5+dVL+Do2vYUNn6MjT+AWiXO5wc0FxElD4HRduuIOSrHOJ3RVE3GQJB5Vpmt1i3
	 vXwh3hmW/VTKiwyOqjEUC8/e8VF6kLEDVE+5190P6t3wp7XZCOIvBx2F5xJneL2BES
	 JZOIWD4J7D5VcH3fYTfUAwzHAnvqTDNjpEc4Jso5OoC0KXFFqGntgM4axebgdB5gfG
	 c/dqZ1+qaQqiURhfYQq+3hHTlApPDvhMOTgE7JmlzozMeFBfzYv9HY1TSPU6pSYcIK
	 kry/Wvh4n3xcw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ioana Ciornei <ioana.ciornei@nxp.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.17-6.16] mfd: simple-mfd-i2c: Add compatible strings for Layerscape QIXIS FPGA
Date: Thu,  9 Oct 2025 11:56:23 -0400
Message-ID: <20251009155752.773732-117-sashal@kernel.org>
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

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 81a2c31257411296862487aaade98b7d9e25dc72 ]

The QIXIS FPGA found on Layerscape boards such as LX2160AQDS, LS1028AQDS
etc deals with power-on-reset timing, muxing etc. Use the simple-mfd-i2c
as its core driver by adding its compatible string (already found in
some dt files). By using the simple-mfd-i2c driver, any child device
will have access to the i2c regmap created by it.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20250707153120.1371719-1-ioana.ciornei@nxp.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed
  - Adds two OF match entries to `simple_mfd_i2c_of_match[]` so the
    `simple-mfd-i2c` driver binds to the QIXIS FPGA on Layerscape QDS
    boards:
    - `fsl,lx2160aqds-fpga`
    - `fsl,ls1028aqds-fpga`
  - Location: drivers/mfd/simple-mfd-i2c.c:96

- Why this is a bugfix (not a feature)
  - These compatibles already exist in mainline DTS and the binding
    schema, but there is no I2C driver matching them, so the node does
    not bind and its children aren’t instantiated.
    - DTS examples:
      - arch/arm64/boot/dts/freescale/fsl-lx2160a-qds.dts:263
      - arch/arm64/boot/dts/freescale/fsl-ls1028a-qds.dts:341
    - Binding: Documentation/devicetree/bindings/board/fsl,fpga-
      qixis-i2c.yaml:21
  - Without a bound parent driver, the child `reg-mux` node under the
    FPGA can’t get a regmap from its parent and won’t probe, leaving
    board muxing controls non-functional. This is a user-visible
    deficiency rather than new functionality.

- Code path and behavior after the change
  - Probe obtains match data and falls back safely when `.data` is NULL:
    - Default 8-bit register/8-bit value regmap is used when no custom
      config is provided: drivers/mfd/simple-mfd-i2c.c:41-45
    - If no MFD cells are supplied via `.data`, it populates children
      from DT: drivers/mfd/simple-mfd-i2c.c:51-53
  - The child `reg-mux` driver will successfully fetch the regmap from
    the parent if no MMIO/syscon region is present (fallback to
    `dev_get_regmap(dev->parent, NULL)`), enabling mux control:
    - drivers/mux/mmio.c:20

- Scope and risk assessment
  - Small, contained change: two ID table entries only; no logic
    changes; no ABI churn.
  - Conservative matching: only board-specific compatibles are added;
    the generic `fsl,fpga-qixis-i2c` is not matched, avoiding unintended
    binding on other QIXIS variants (e.g., PowerPC boards).
  - The default regmap path (8/8) aligns with how these DTs describe the
    QIXIS registers (e.g., `mux-reg-masks = <0x54 ...>` uses 8-bit
    offsets), so there is no width mismatch.
  - Touches MFD over I2C only; no architectural or cross-subsystem
    impact; minimal regression risk.

- Stable policy fit
  - Fixes a real, user-facing problem: existing DTs/bindings reference
    devices that currently don’t bind to any driver, leaving board-
    control functionality inoperative.
  - Change is trivial, low risk, and does not introduce features or
    architectural alterations.
  - No side effects beyond enabling the intended binding and population
    of DT-described child devices.

Given the above, this is a textbook stable backport candidate enabling
existing DT descriptions to function by adding missing compatible
strings in the driver’s match table.

 drivers/mfd/simple-mfd-i2c.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/simple-mfd-i2c.c b/drivers/mfd/simple-mfd-i2c.c
index 22159913bea03..f7798bd922224 100644
--- a/drivers/mfd/simple-mfd-i2c.c
+++ b/drivers/mfd/simple-mfd-i2c.c
@@ -99,6 +99,8 @@ static const struct of_device_id simple_mfd_i2c_of_match[] = {
 	{ .compatible = "maxim,max5970", .data = &maxim_max5970},
 	{ .compatible = "maxim,max5978", .data = &maxim_max5970},
 	{ .compatible = "maxim,max77705-battery", .data = &maxim_mon_max77705},
+	{ .compatible = "fsl,lx2160aqds-fpga" },
+	{ .compatible = "fsl,ls1028aqds-fpga" },
 	{}
 };
 MODULE_DEVICE_TABLE(of, simple_mfd_i2c_of_match);
-- 
2.51.0

