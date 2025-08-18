Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418FC27B334;
	Mon, 18 Aug 2025 13:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523306; cv=none; b=hHwdwo6CsyplcM4gTu/Al2IXHsY0GXrpcs1uWEveK5Fc9wyUBURFuu6IEkRBaG5AGpNoQflNiGe9MWBvFTv/xXLM6LuRbMdmbsyCTkMVtO9/4LveoNRK1suzS9ZxKhKnLKBNeETs5ZDJpdvRLb3yXacxsyk3delkPE4X7bbjuEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523306; c=relaxed/simple;
	bh=Jl8CCMuh6cFCNMVR3w7jwwGR3LmPIIm019X3LgoZJZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLR2An8Pe4k4ebow0H2ml+/N0hKd8Qhf/LVaigKal2exWK2nc46yHjlc/WOXwcMGzvHQYNtgYpM+I6DXFGuDJQD9+atw2K5tiaV9nWzyLrIJ1cVYZ7CCaA3f4O+uDWqv4C0bbKOYWax9ve0ssbmezmbzH7lxstCAnVd6ETNPvDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iC4GeKzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iC4GeKzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C79C4CEEB;
	Mon, 18 Aug 2025 13:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523306;
	bh=Jl8CCMuh6cFCNMVR3w7jwwGR3LmPIIm019X3LgoZJZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iC4GeKzXm2cSDd/EILISnos4LMeVIs3tDOsha/vO02Krzz+eyp5RG3fGhV+jwGMuQ
	 FPldZ+TJQc2KbHAcniBZZ/t6NeB0Um0myaM7/3aEBsD8iCPMyPdCdnv/Zo48NE+nFu
	 1wBQDThNl86cu3DHfnflyn+CC/rmisu/9DWes5kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume La Roque <glaroque@baylibre.com>,
	Nishanth Menon <nm@ti.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 131/515] pmdomain: ti: Select PM_GENERIC_DOMAINS
Date: Mon, 18 Aug 2025 14:41:57 +0200
Message-ID: <20250818124503.444398817@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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



