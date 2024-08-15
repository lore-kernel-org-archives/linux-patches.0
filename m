Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACA91714A1;
	Thu, 15 Aug 2024 13:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730139; cv=none; b=r6BXExvZMNziCzKhYcrYvmzYmCN9wir46hxuFV8oWBLvB5DFFaR2ArdDsIrKh6yOfB+TZ68ARZjwUbCIoJ9as3xKFzvd4Z2FYv6zzfaqU+ZDQH/8rad/kZWM9xQkrUFDaMm8GNP44+lvLbPXPHKrzlJGG4r4tbGGPcqBZGl4e2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730139; c=relaxed/simple;
	bh=k96xVBS7OOIImLjh+YN3GL1jjuAdrUlyx0BOeYP01PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqlcnf2fSq4MRf5a4wBxQ4LHvcpqRNauNPJIIZ0cUXbbwxnUSkB2hsd8vtOvZCTigOhnCfcuX01/17CKRHmCTVnFrHY2O9HlPCwj4D3GUScIvzZM4q1hImGJF2U5jdnk6HRCUwSj9t0XYtIqBSwX7e7OmObCA/VZ1UlyPlq3qTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x26Pyczk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x26Pyczk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BC9C32786;
	Thu, 15 Aug 2024 13:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730139;
	bh=k96xVBS7OOIImLjh+YN3GL1jjuAdrUlyx0BOeYP01PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x26PyczkgFjwmBcI9M2P/WoskKxzk8IqSfWNKLnO+Tq72NUawCoaECZwIWOObW734
	 mNCkvWcE2U/7fZDhsysWa9DqJLU4RJmgKmVgJ+djAwdG5ot00BW7B3Mlf2GafgY35k
	 fUC27ZAEQ/eMYCNzRQJx28j4zf1dRxPaBV5U2JWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Esben Haabendal <esben@geanix.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 298/484] powerpc/configs: Update defconfig with now user-visible CONFIG_FSL_IFC
Date: Thu, 15 Aug 2024 15:22:36 +0200
Message-ID: <20240815131952.914124484@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Esben Haabendal <esben@geanix.com>

commit 45547a0a93d85f704b49788cde2e1d9ab9cd363b upstream.

With CONFIG_FSL_IFC now being user-visible, and thus changed from a select
to depends in CONFIG_MTD_NAND_FSL_IFC, the dependencies needs to be
selected in defconfigs.

Depends-on: 9ba0cae3cac0 ("memory: fsl_ifc: Make FSL_IFC config visible and selectable")
Signed-off-by: Esben Haabendal <esben@geanix.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240530-fsl-ifc-config-v3-2-1fd2c3d233dd@geanix.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/configs/85xx-hw.config |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/configs/85xx-hw.config
+++ b/arch/powerpc/configs/85xx-hw.config
@@ -24,6 +24,7 @@ CONFIG_FS_ENET=y
 CONFIG_FSL_CORENET_CF=y
 CONFIG_FSL_DMA=y
 CONFIG_FSL_HV_MANAGER=y
+CONFIG_FSL_IFC=y
 CONFIG_FSL_PQ_MDIO=y
 CONFIG_FSL_RIO=y
 CONFIG_FSL_XGMAC_MDIO=y
@@ -58,6 +59,7 @@ CONFIG_INPUT_FF_MEMLESS=m
 CONFIG_MARVELL_PHY=y
 CONFIG_MDIO_BUS_MUX_GPIO=y
 CONFIG_MDIO_BUS_MUX_MMIOREG=y
+CONFIG_MEMORY=y
 CONFIG_MMC_SDHCI_OF_ESDHC=y
 CONFIG_MMC_SDHCI_PLTFM=y
 CONFIG_MMC_SDHCI=y


