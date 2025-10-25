Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195363074A4;
	Sat, 25 Oct 2025 16:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409403; cv=none; b=Y8qCDo7bmI1N/772bxcQ3C5gr+NLdfAPcRrYRCzXUs+YH7eX1YJFsNUuTTsqKbbxJ3WyTrQIaGL3Ipq908pJeANst+d/keFnG6jSX0oYnE6xg4KwZSliDxON5g66UVNY1II0qpFUDkoSKl0/pUZUucm2zXLU9UV2CMVpWsvqJoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409403; c=relaxed/simple;
	bh=5I9qk3gBTLLnPcYT8Lh1cfTu7Bsse6b7DIeDzWni5yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sZ7rsfNGo3TPMxnsh5HWkwxYV3eHVhOSryrmCYTznPGe2zx1E1slxZv6ml6FEp/Jra4Mgkh5voOqJKuBFfw5vI6tVp/CwmEMIgOItFlji66LqxzPZvXMJOofBi8eU3p5T4CgLL/n/COF/7yd+RBG6yDjAtb1uImUB8HYzANGwPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HNxAC9HQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HNxAC9HQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDBDC4CEF5;
	Sat, 25 Oct 2025 16:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409402;
	bh=5I9qk3gBTLLnPcYT8Lh1cfTu7Bsse6b7DIeDzWni5yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNxAC9HQ5qTXu+xh2XLpNJqKOyybZ4uHkeG6pbEsfX/fLpv72dRV3JoaEx0ZRQlfl
	 zKJm3MR7gLwMBDFP1o2j6ebsiTskMhOOOmVtb+eqDaEaZt/qAYe+kx3E3yujQRd/dB
	 G2RxuehLnnNYSdZLRTxiuho+/lGP2EzRktogQvSoTiQDOjb/dAfI0BNYHcL/Ss9vCH
	 wCbw/m9gWXQpvGlVOgpIGSLF0p+DGp/EE2osr5Va1KugP8kdimIXv6+ISjqMeIBFKB
	 /G+9mp09FQqbA8hmbySMGuZwzgHluoKkqHn8bcpAwFQJdOXX/+CSkGLDj1NNBTgpEF
	 LzMuk8dob4w9A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>,
	kuba@kernel.org,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-6.1] mips: lantiq: danube: rename stp node on EASY50712 reference board
Date: Sat, 25 Oct 2025 11:58:58 -0400
Message-ID: <20251025160905.3857885-307-sashal@kernel.org>
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

From: Aleksander Jan Bajkowski <olek2@wp.pl>

[ Upstream commit 2b9706ce84be9cb26be03e1ad2e43ec8bc3986be ]

This fixes the following warning:
arch/mips/boot/dts/lantiq/danube_easy50712.dtb: stp@e100bb0 (lantiq,gpio-stp-xway): $nodename:0: 'stp@e100bb0' does not match '^gpio@[0-9a-f]+$'
	from schema $id: http://devicetree.org/schemas/gpio/gpio-stp-xway.yaml#

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- What changed: The node name was renamed from `stp@e100bb0` to
  `gpio@e100bb0` under the `stp0` label in the EASY50712 DTS, aligning
  the node name with the binding while keeping all properties intact
  (arch/mips/boot/dts/lantiq/danube_easy50712.dts:99; compatible remains
  lantiq,gpio-stp-xway at
  arch/mips/boot/dts/lantiq/danube_easy50712.dts:101).
- Binding compliance: The binding explicitly requires the nodename to
  match `^gpio@[0-9a-f]+$` (Documentation/devicetree/bindings/gpio/gpio-
  stp-xway.yaml:20), and its example shows `gpio@e100bb0`
  (Documentation/devicetree/bindings/gpio/gpio-stp-xway.yaml:84). This
  change removes the schema warning cited in the commit message.
- Functional fix beyond a warning: On Lantiq/XWAY SoCs the PMU-based
  clock lookup for STP is registered against device-id `1e100bb0.gpio`
  (arch/mips/lantiq/xway/sysctrl.c:488). Platform device names for OF
  nodes are derived from the translated address and the node name
  (`of_device_make_bus_id`), yielding `1e100bb0.<node-name>`
  (drivers/of/device.c:284). With the old name, the device-id would be
  `1e100bb0.stp`, which does not match the PMU registration, causing
  `devm_clk_get_enabled(&pdev->dev, NULL)` to fail and the driver to
  abort probe (drivers/gpio/gpio-stp-xway.c:299). Renaming the node to
  `gpio@…` makes the dev_name `1e100bb0.gpio`, matching the PMU
  registration and allowing the driver to get and enable its clock.
- Impact: Without this rename, the STP GPIO controller on this board is
  very likely non-functional due to clock lookup failure, not just
  “noisy” during `dtbs_check`. The change is a one-line DTS fix that
  restores driver probe on the EASY50712 reference board.
- Risk assessment:
  - Scope: Single DTS node rename for one board; no code or
    architectural changes; no changes to `compatible`, `reg`, or gpio
    properties (arch/mips/boot/dts/lantiq/danube_easy50712.dts:99).
  - ABI considerations: While node path strings change, the phandle
    label `stp0` remains stable for intra-DT references. There are no
    in-tree references to the old path, and this is a reference board.
    The practical risk of breaking external overlays is low, and the fix
    enables the hardware to function.
- Stable criteria fit:
  - Fixes a user-visible functional bug (driver failing to get its
    clock, thus failing probe).
  - Minimal, contained change in a non-critical subsystem (board DTS).
  - No new features or architectural churn.
  - Commit message targets a schema warning; however, code analysis
    shows it also resolves a real runtime issue due to `clkdev` dev_id
    mismatch.

Given the functional mismatch between the old node name-derived
`dev_name` and the clock lookup key, this is an important, low-risk fix
appropriate for stable backporting.

 arch/mips/boot/dts/lantiq/danube_easy50712.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/boot/dts/lantiq/danube_easy50712.dts b/arch/mips/boot/dts/lantiq/danube_easy50712.dts
index ab70028dbefcf..c9f7886f57b8c 100644
--- a/arch/mips/boot/dts/lantiq/danube_easy50712.dts
+++ b/arch/mips/boot/dts/lantiq/danube_easy50712.dts
@@ -96,7 +96,7 @@ ethernet@e180000 {
 			lantiq,tx-burst-length = <4>;
 		};
 
-		stp0: stp@e100bb0 {
+		stp0: gpio@e100bb0 {
 			#gpio-cells = <2>;
 			compatible = "lantiq,gpio-stp-xway";
 			gpio-controller;
-- 
2.51.0

