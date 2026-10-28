Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212792;
	b=UR3m07m1XvmHfjHELnSjICgWoguVUmeBhiwq4/enAJYYNE+gmmaJ9BUeHBXD8JiAP9r8
	 Ad0acn2UDJQdkU/4aTYtECeUexfo6OQ8dNpPiZMF5qjGBpE2k69w919oR2C6nuFyCNAHZ
	 Eq0y/7CCey3uj4c9J6SimR/MHW1dAgiG/hol35IJ2er/E3vZK6xMBcnWoRER69MAhv5Gx
	 DSiczhdjGTPHq/mLyXFTcU0Ww73vOkCJPFFImtZKtD2IDUU4OKEedRj+MDPl528EAerl9
	 iEwr5EtExGWOwDL8Y4cd+0PKv/aWy5a8nN+PIf7TeTpT9oRAWqh5ph4yfpPn14E6SyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212792;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=wsR7bjoIN9/IJpMOkKwOpjCQe9tItRM2ru2uzkHMLsI=;
	b=rv1h8LTqHX0RQNSia9RbHF55UlccI33ui6C5E26mMklR5U3O8xLsKnRvQRQrDMY+S2eB
	 gIJ1yW3rtvOF2xo62ljpzqn/z+NLerPHqR52Vzb1CJ7NbpRklynWER+nOTiVIFhWF8aK7
	 VnusOVrYPYh4NJcMJ8mH3GR0V+0GU1yisZVDvC4Gk7eZZYPe2bJSueMKXvEhoPq24eMVT
	 IxVoZFkZJet6dOgT/USDAfOA/7VlrB7fsRJaiJBnMZ/QPijzaZo0e/Q5JMMJ6caaD4f92
	 lpU0C1iVMosrVOaJJz+xcRtz8s7feW/8TWVPFXO1gnMb8eR5cu+Ex+REwVWh1SFC/QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F2TB5R2H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4648606A31D;
	Wed, 28 Oct 2026 18:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F2TB5R2H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 434C31F01825;
	Wed, 28 Oct 2026 18:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212791;
	bh=wsR7bjoIN9/IJpMOkKwOpjCQe9tItRM2ru2uzkHMLsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F2TB5R2Hftiq7Gqgf+CRHZ6x4zh8PyBTWS8Pxp8xSVc3OTjQSIfIBA8K5V6nxMNtM
	 5Cyu7+Igm+IE7sQ3G8ve/A4L9nYLStn2UXAuhnPg0o/wCoVMg4m+1tRPVLUU5sqn02
	 bxOaR9htDA6y3kl1a4QzqJDO54pTLY/Sa3biIEj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 0251/1887] drm/amd/pm/si: Check AMD_IS_MOBILITY flag for PPSMC_SYSTEMFLAG_GPIO_DC
Date: Wed, 28 Oct 2026 17:39:07 +0100
Message-ID: <20261028170504.944500437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

commit cd883d0a3937df82a5ea03709ba8ba623b868419 upstream.

Unfortunately, some desktop boards eg. the FirePro D500
have the HARDWAREDC platform flag set and also have
a battery power state configured in their VBIOS.
This makes no sense for a desktop GPU and results in
incorrect behaviour: the clocks are stuck at lowest.

We observed that the kernel driver can work around
the issue in two possible ways:
1. Set PPSMC_SWSTATE_FLAG_DC on all power states
2. Clear PPSMC_SYSTEMFLAG_GPIO_DC

We think that the PPSMC_SYSTEMFLAG_GPIO_DC flag
makes the SMC assume it's running on battery even
though this is a desktop machine with no battery,
and that's why it doesn't do DPM on power states
without PPSMC_SYSTEMFLAG_GPIO_DC.

Issue was uncovered by "Fix updating clock limits from
power states" because previously the limits for the
battery state were not tracked separately. However,
battery power state has lower frequencies and voltages,
so the kernel doesn't set the DC flag on the current
power state anymore. That causes the SMC to be stuck
on the lowest clocks.

Let's clear PPSMC_SYSTEMFLAG_GPIO_DC on desktop GPUs.
We can use the AMD_IS_MOBILITY flag to determine that.

Fixes: e6c5d36756e7 ("drm/amd/pm/si: Fix updating clock limits from power states")
Closes: https://gitlab.freedesktop.org/mesa/mesa/-/work_items/16352
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20260923120354.1027996-1-timur.kristof@gmail.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 58473c7c49ce9f5f5a4a1c24ffb9aa1d3c8771f4)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
+++ b/drivers/gpu/drm/amd/pm/legacy-dpm/si_dpm.c
@@ -5239,7 +5239,8 @@ static int si_init_smc_table(struct amdg
 		break;
 	}
 
-	if (adev->pm.dpm.platform_caps & ATOM_PP_PLATFORM_CAP_HARDWAREDC)
+	if ((adev->flags & AMD_IS_MOBILITY) &&
+	    (adev->pm.dpm.platform_caps & ATOM_PP_PLATFORM_CAP_HARDWAREDC))
 		table->systemFlags |= PPSMC_SYSTEMFLAG_GPIO_DC;
 
 	if (adev->pm.dpm.platform_caps & ATOM_PP_PLATFORM_CAP_REGULATOR_HOT) {


