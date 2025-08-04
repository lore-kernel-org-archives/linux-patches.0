Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8DB76026;
	Mon,  4 Aug 2025 00:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754267091; cv=none; b=ir649NZz9V0O/cDh2EmUNnt57RIzpu8VK4Lp6vyBZ40dUdCfvJbYEDi6Xe9PudICF0KAFI+d0TTYJrXpH+6Xc1yK7+Wo1L3LBMaiVodBdOMtSObro3LsLqks8rOthU405RxEOERBrYVx1yImiOKrohUG94ZwY9on0X+1TSi2wxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754267091; c=relaxed/simple;
	bh=3HHaeLBK49tBcY9lCECJOjwEAEESTf5rVhQqzAT56yY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YRSmkiUWQqdMnKw9HWTvW7j96p9hrjwYrRR8nhDttmrUCXIINxU50tghUKgT5vJq5gyF4dOsT657wbiSMVeCqFXcUkSEPHwlIRkKjxq5n+B3c6Mw+VViyCqh8W6eG/3o/k/kkGF5KaMuGUDeRHc+0RsVDWxvyLfsm0v9smfGAu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g1IxakpR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g1IxakpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB21C4CEEB;
	Mon,  4 Aug 2025 00:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754267091;
	bh=3HHaeLBK49tBcY9lCECJOjwEAEESTf5rVhQqzAT56yY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1IxakpRBo5Hxxg4FPw6Sfi1zIMNJpbd6MDwuexnOQn/0+8gvNgE2BoS/9mdMR9Jl
	 0T1T9c/WZxOGY7PxEj2nQYZcC9lpmH7Ng1K+6Me+c3+1/3Vq2SJJ1m0TrrSFteQZsu
	 hfiDDE+hBbxqEi2sxE9+9ZpmYPHPVJJZBHCj2s6ZAKqibTT+N4nimQGkWvAL5Me3S0
	 TwhK72/Smtf9AHhaXPFViTI5m6EYXT4Jk+PJk+OAwFplnGMfm6tij/2RA6II70T+AL
	 2CWHSwbNqofeKXK0ESszb1k66SIRGiJ96h0B4lSVC46ZKKDyZvJ+fKUS0OAlkwvrkI
	 qSNr3O+kRvw5g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Guillaume La Roque <glaroque@baylibre.com>,
	Nishanth Menon <nm@ti.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.16 22/85] pmdomain: ti: Select PM_GENERIC_DOMAINS
Date: Sun,  3 Aug 2025 20:22:31 -0400
Message-Id: <20250804002335.3613254-22-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250804002335.3613254-1-sashal@kernel.org>
References: <20250804002335.3613254-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Guillaume La Roque <glaroque@baylibre.com>

[ Upstream commit fcddcb7e8f38a40db99f87a962c5d0a153a76566 ]

Select PM_GENERIC_DOMAINS instead of depending on it to ensure
it is always enabled when TI_SCI_PM_DOMAINS is selected.
Since PM_GENERIC_DOMAINS is an implicit symbol, it can only be enabled
through 'select' and cannot be explicitly enabled in configuration.
This simplifies the dependency chain and prevents build issues

Signed-off-by: Guillaume La Roque <glaroque@baylibre.com>
Reviewed-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20250715-depspmdomain-v2-1-6f0eda3ce824@baylibre.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Let me analyze based on what I can see from the provided diff:

**Backport Status: YES**

This commit should be backported to stable kernel trees for the
following reasons:

1. **Fixes a build configuration issue**: The commit message explicitly
   states this change "prevents build issues". The problem is that
   PM_GENERIC_DOMAINS is an implicit symbol that cannot be explicitly
   enabled by users in configuration menus. Using "depends on" creates a
   circular dependency problem where users cannot enable
   TI_SCI_PM_DOMAINS because they cannot manually enable
   PM_GENERIC_DOMAINS.

2. **Small and contained fix**: The change is minimal - it only modifies
   one line in a Kconfig file, changing from `depends on
   PM_GENERIC_DOMAINS` to `select PM_GENERIC_DOMAINS if PM`. This is a
   low-risk change that only affects the configuration system.

3. **Follows established patterns**: The code shows that other
   subsystems handle PM_GENERIC_DOMAINS the same way. From my search
   results, I can see that drivers like QCOM_GDSC, AMD GPU drivers, and
   others use `select PM_GENERIC_DOMAINS if PM` rather than `depends on
   PM_GENERIC_DOMAINS`.

4. **Prevents user-facing issues**: Without this fix, users trying to
   enable TI_SCI_PM_DOMAINS would face a confusing situation where the
   option might not be available in menuconfig because they cannot
   satisfy the dependency on PM_GENERIC_DOMAINS (since it's an implicit
   symbol).

5. **No architectural changes**: This is purely a Kconfig dependency fix
   that doesn't change any runtime behavior or introduce new features.
   It only fixes the configuration logic.

6. **Platform-specific fix**: This only affects TI SoC configurations
   and has no impact on other architectures or subsystems, minimizing
   the risk of regression.

The commit follows stable tree rules by fixing an important
configuration/build issue with minimal risk and no new features or
architectural changes.

 drivers/pmdomain/ti/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pmdomain/ti/Kconfig b/drivers/pmdomain/ti/Kconfig
index 67c608bf7ed0..5386b362a7ab 100644
--- a/drivers/pmdomain/ti/Kconfig
+++ b/drivers/pmdomain/ti/Kconfig
@@ -10,7 +10,7 @@ if SOC_TI
 config TI_SCI_PM_DOMAINS
 	tristate "TI SCI PM Domains Driver"
 	depends on TI_SCI_PROTOCOL
-	depends on PM_GENERIC_DOMAINS
+	select PM_GENERIC_DOMAINS if PM
 	help
 	  Generic power domain implementation for TI device implementing
 	  the TI SCI protocol.
-- 
2.39.5

