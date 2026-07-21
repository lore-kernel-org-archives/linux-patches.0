Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C2F46AA80;
	Tue, 21 Jul 2026 15:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648361; cv=none; b=cIiU01L0AphgN1wzs9mIDwkPsIcuXNHWIgXJv1FuV0Ur63rAi5huom0BqYSy7WM5aqAnS1xVC/2vNyL8YNCYyacRbDjQ3rQwYGH/SfM8rd/yWaG0Sb2p1GzbJrgk5F0Vn274HvlATaPbcSqcmtJMCl+nD7A7KbvuNDz1JeBjIBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648361; c=relaxed/simple;
	bh=1r5AvaHis7twZZwRxDAORWDHX33UqBzYZtu9p+KRn+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6PJNt59o01iWRrPsvA3KMU1gc3a+nCzyYdW4bcYeUEJ/5XvyIMtO2EVZJjIxw6mefLjY+jUpPbG2t22yda7YyOHCkmTBnTcAsgT2Cth57ZkgLuIPw9ey3lxNBvPIsvxmAPxkMQkrFnjFnfsmFnQ5CWhZ+phaXCehvQtpMExUy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFC1gJ+E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFC1gJ+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00C01F000E9;
	Tue, 21 Jul 2026 15:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648360;
	bh=PzcaLbaW7Tz8jrilCCwzr01iwnxbJZZrMbWwi9lclwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UFC1gJ+Ede2UwMaHfa9B6eY9bNdiyFsTwGeGhbwpP5vU64MsT6QJKJdrPw8yehzlk
	 rb5qs5aVdIKuT1sEDLOzWZvkkurXeHZBPeqdO9d2FY1kbMjTm1MicnM3FWdfjDM4em
	 yXhtd0gvCTvZHNUU1SVOAYSDoNI2VxVWev9Dy2ME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0168/2077] ARM: multi_v7_defconfig: Correct QCOM_RPMH and QCOM_RPMHPD
Date: Tue, 21 Jul 2026 16:57:21 +0200
Message-ID: <20260721152556.653679263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index bcc9aabc120283..aad12026b20d28 100644
--- a/arch/arm/configs/multi_v7_defconfig
+++ b/arch/arm/configs/multi_v7_defconfig
@@ -1155,7 +1155,7 @@ CONFIG_QCOM_COMMAND_DB=m
 CONFIG_QCOM_GSBI=y
 CONFIG_QCOM_OCMEM=m
 CONFIG_QCOM_RMTFS_MEM=m
-CONFIG_QCOM_RPMH=y
+CONFIG_QCOM_RPMH=m
 CONFIG_QCOM_SMEM=y
 CONFIG_QCOM_SMD_RPM=y
 CONFIG_QCOM_SMP2P=y
@@ -1170,7 +1170,7 @@ CONFIG_KEYSTONE_NAVIGATOR_DMA=y
 CONFIG_TI_PRUSS=m
 CONFIG_RASPBERRYPI_POWER=y
 CONFIG_QCOM_CPR=y
-CONFIG_QCOM_RPMHPD=y
+CONFIG_QCOM_RPMHPD=m
 CONFIG_QCOM_RPMPD=y
 CONFIG_ROCKCHIP_PM_DOMAINS=y
 CONFIG_TI_SCI_PM_DOMAINS=y
-- 
2.53.0



