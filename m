Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C773D30E0F1;
	Thu, 19 Feb 2026 02:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466703; cv=none; b=ocqP5vYu+t3bBLAvHSwruW61V3OeW+jh8oO1RxvcSe6k2YCAoxioISHVfBReo20lmYUurcCnNDk21LkTn2Ldz/RAzRFe96IXBjXnTAOTJaBFC7ZEl8+olq1r4dLw6bwdQiSKmOLxeb8RKSoS8JriwgER14Bw/FapUZNalBB+6uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466703; c=relaxed/simple;
	bh=lOZidEmx5vk20ZO0QrhgAGaGcoFEhk4bJAlW3AJLUOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlfqR4+2BALZ+KCCO/3b10E+zchA+6NqcalNe/za0C6IJh+3GKCC+lm6DfjR6o1PjhBhmJ/uEVWBUNYe/Nj8JY1gqvhLf6VrOVElNrxhlij0wccVze6SKaWwNegwIAKQHQTAs6PLN9w76dG+jzL0grbAkzmNoIjOMBhLdZ6Ee1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bDrkdjbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bDrkdjbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8320DC19422;
	Thu, 19 Feb 2026 02:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466703;
	bh=lOZidEmx5vk20ZO0QrhgAGaGcoFEhk4bJAlW3AJLUOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bDrkdjbvtDnkfPHNkqW2l+/iLzj7A9E2KZ5LDUUqsThA71UtRLrKT8/GtBrU0hKtX
	 0QnBkfBkl2+pfGFAMeyaCytwZPKIy1l4WRJ+egUX/UK6y9D5/kk40EwITuUJ1d/RfH
	 oTBBs+eo0JJm+X8QnjVGeFCgbY1ZyVxKCeDDc+076WdGwRDJ/7NjaXUNq3j0fsedaQ
	 k9JqfvSP3k4QMvEidLcgJlvVkF2bKn/IwM8JKuJzjMJSy4pL4OhCBgZ3H3uACFXgiN
	 U8uqCKfAnKj72b8ab2N2uBMg2aT4Z4/p/WnPtA4iNZqPlRbjL5LUl7EgfUznrLL6YM
	 hO2vOUtxbCp5g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-phy@lists.infradead.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] phy: fsl-imx8mq-usb: disable bind/unbind platform driver feature
Date: Wed, 18 Feb 2026 21:04:07 -0500
Message-ID: <20260219020422.1539798-31-sashal@kernel.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit 27ee0869d77b2cb404770ac49bdceae3aedf658b ]

Disabling PHYs in runtime usually causes the client with external abort
exception or similar issue due to lack of API to notify clients about PHY
removal. This patch removes the possibility to unbind i.MX PHY drivers in
runtime.

Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260120111712.3159782-1-xu.yang_2@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis Summary

### What the commit does
This commit adds `.suppress_bind_attrs = true` to the i.MX8MQ USB PHY
platform driver. This single line prevents the kernel from creating
`/sys/bus/platform/drivers/imx8mq-usb-phy/bind` and
`/sys/bus/platform/drivers/imx8mq-usb-phy/unbind` sysfs files, thereby
preventing runtime unbinding of the PHY driver.

### Problem being fixed
The commit message states that unbinding PHYs at runtime causes
"external abort exception or similar issue" because there is no API to
notify PHY clients about PHY removal. An external abort is a serious ARM
exception that typically results in a kernel crash/oops. If a user or
management tool writes to the `unbind` sysfs file for this PHY driver,
the USB controller client would try to access the now-missing PHY
resources, resulting in a crash.

### Stable kernel rules assessment
1. **Obviously correct and tested**: Yes - this is a well-established
   one-line pattern used in 385+ files in the kernel. It's reviewed by
   the PHY maintainer (Vinod Koul) and reviewed by Frank Li.
2. **Fixes a real bug**: Yes - runtime unbinding causes a crash
   (external abort exception). This is a real, triggerable issue.
3. **Important issue**: Moderate - it prevents a crash, but only
   triggered by explicit sysfs manipulation (not normal operation).
   However, system management tools or user error could trigger this.
4. **Small and contained**: Yes - single one-line addition to a driver
   struct.
5. **No new features**: Correct - this removes functionality (ability to
   unbind), it doesn't add any.

### Risk assessment
- **Risk**: Extremely low. This is literally a single boolean field
  being set in the driver struct. It only affects sysfs attributes. The
  same pattern exists in 385+ other drivers.
- **Benefit**: Prevents a crash scenario when the PHY is unbound at
  runtime.
- **Dependencies**: None - this is entirely self-contained.

### Concerns
- The bug is only triggerable by explicit sysfs manipulation (writing to
  `/sys/bus/platform/drivers/imx8mq-usb-phy/unbind`), not by normal
  system operation.
- The fix is a defensive measure rather than fixing a root cause in the
  PHY framework. However, this is the standard kernel approach - the PHY
  framework doesn't have removal notification, so drivers that can't
  handle unbinding should suppress it.
- The change is straightforward and would apply cleanly to any stable
  tree that has this driver.

### Classification
This falls into the **hardware quirk/workaround** category. It's a
defensive fix that prevents a crash scenario. While the trigger requires
explicit user action (sysfs unbind), this is a well-established pattern
in the kernel for exactly this purpose.

## Verification
- Verified `suppress_bind_attrs = true` is used in 385+ files across the
  drivers/ directory via Grep search
- Verified 7 other PHY drivers (Samsung, HiSilicon) already use this
  pattern
- Verified no other Freescale PHY drivers currently have this attribute
  (this is the first)
- Verified via git log that similar commits exist for other subsystems
  (gpio, perf)
- Verified via lore.kernel.org that the patch was reviewed by Frank Li
  and accepted by PHY maintainer Vinod Koul
- Verified the commit message describes a real crash scenario (external
  abort exception)
- Could NOT verify the specific crash reproduction steps (unverified,
  but the mechanism is well-understood in the kernel community)

The fix is minimal (one line), extremely low risk, prevents a crash
scenario, uses a well-established kernel pattern, and was properly
reviewed. It meets all stable kernel criteria.

**YES**

 drivers/phy/freescale/phy-fsl-imx8mq-usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/phy/freescale/phy-fsl-imx8mq-usb.c b/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
index 91b3e62743d3a..b30d01f345d20 100644
--- a/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
+++ b/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
@@ -730,6 +730,7 @@ static struct platform_driver imx8mq_usb_phy_driver = {
 	.driver = {
 		.name	= "imx8mq-usb-phy",
 		.of_match_table	= imx8mq_usb_phy_of_match,
+		.suppress_bind_attrs = true,
 	}
 };
 module_platform_driver(imx8mq_usb_phy_driver);
-- 
2.51.0

