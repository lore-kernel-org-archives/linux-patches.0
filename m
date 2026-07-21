Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107463EEAC7;
	Tue, 21 Jul 2026 19:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661525; cv=none; b=sTq2zY+3ZD2nA4lUdYyRNyKxl80d4NjiY6y1fKyJ+twSVuE56ghgk3Ou07Sc9XOQIyyVk6haClG1TJerWZ0ldSlF/inDuBPxOigGIoeKCc6vNzB9xT90aam0EOvo+f7e3XoRmZCbXw1tTlRBr9vLgkip1Ym1EOKdO1gXfPM6oKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661525; c=relaxed/simple;
	bh=UGxbfiuSQnV2YiWQhdoYpkosl3R213oWSCbBGwtJSZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rgfa2SAitgb+85xsCZ9SXzkMcjnTnZNdPt924dQFWxGKcSpcKQiVU1fHthVv66SvP6tyQ469ne3eAn0InrjHiHabNt35BsG824G9YIbGL70uDSr2SuYy989xDHlCW00Wi210kMTxFuxWv7xvLafXUIcZIFaWNl+aTE+UBekbPDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PfRkE53Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PfRkE53Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B901F000E9;
	Tue, 21 Jul 2026 19:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661524;
	bh=P00ZQzbjGuJiP4Tl7a6nlPaIx4RpRAG46ZRp0HkBgrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PfRkE53Z93FKGCZ1sFY03YrCHnLAZwLFy6Ek5AxzANROPnnmkma5wquJ8ahPdghaK
	 k/lO3V7yeON/1zSuJVvxVb3cMMTYSoX6FPgXvbN9UxmyDmHWC9Yo16KS9tFYH91KM9
	 ELSH1yQCGE1d9ZcnaqL5QvznZ71tDX9/FMiXfHmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0100/1276] ARM: multi_v7_defconfig: Correct QCOM_RPMH and QCOM_RPMHPD
Date: Tue, 21 Jul 2026 17:09:03 +0200
Message-ID: <20260721152448.333360037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 02802b40c31d2f2cfc94716189cfaf610930c589 ]

QCOM_RPMH and QCOM_RPMHPD can be build only as modules when
QCOM_COMMAND_DB is module itself.

Fixes: 1c25ca9bb5c5 ("ARM: multi_v7_defconfig: enable more Qualcomm drivers")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/configs/multi_v7_defconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/configs/multi_v7_defconfig b/arch/arm/configs/multi_v7_defconfig
index 9a5f5c439b8791..61b652cb522e06 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -1112,7 +1112,7 @@ CONFIG_QCOM_COMMAND_DB=m
 CONFIG_QCOM_GSBI=y
 CONFIG_QCOM_OCMEM=m
 CONFIG_QCOM_RMTFS_MEM=m
-CONFIG_QCOM_RPMH=y
+CONFIG_QCOM_RPMH=m
 CONFIG_QCOM_SMEM=y
 CONFIG_QCOM_SMD_RPM=y
 CONFIG_QCOM_SMP2P=y
@@ -1149,7 +1149,7 @@ CONFIG_KEYSTONE_NAVIGATOR_QMSS=y
 CONFIG_KEYSTONE_NAVIGATOR_DMA=y
 CONFIG_RASPBERRYPI_POWER=y
 CONFIG_QCOM_CPR=y
-CONFIG_QCOM_RPMHPD=y
+CONFIG_QCOM_RPMHPD=m
 CONFIG_QCOM_RPMPD=y
 CONFIG_ROCKCHIP_PM_DOMAINS=y
 CONFIG_TI_SCI_PM_DOMAINS=y
-- 
2.53.0



