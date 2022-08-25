Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DBF4C74
	for <patches@lists.linux.dev>; Thu, 25 Aug 2022 21:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E608FC433D7
	for <patches@lists.linux.dev>; Thu, 25 Aug 2022 21:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1661461790;
	bh=xEy0lhvT/JsoeoGDqCa6fcEHD4POUJt+30MkSnqbhmc=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=1xNm6XBwrFE1FpjXUrhlXOFsOMFr6KCwCojYBr0UszDdWI9bAZIWdwXJdGXvtGmm/
	 Fcjz7EzR/nCbB2u/WpMb0fhPvbfQWg6G5ZNOIrcThW2d15JF50yPqbPun1uL7zHyQh
	 3vEX2zlFN19TSflPxEeRTvxlJcnJ6S9wtcEOeHqA=
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB1DECAAA6
	for <patches@lists.linux.dev>; Thu, 25 Aug 2022 21:09:50 +0000 (UTC)
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Thu, 25 Aug 2022 17:09:17 -0400
Subject: [PATCH v1 1/4] arm64: defconfig: Enable devfreq cooling device
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <20220825-test-endpoint-send-2-v1-1-e732ebcaa48a@linuxfoundation.org>
References: <20220825-test-endpoint-send-2-v1-0-e732ebcaa48a@linuxfoundation.org>
In-Reply-To: <20220825-test-endpoint-send-2-v1-0-e732ebcaa48a@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.10.0-dev-65ba7
X-Developer-Signature: v=1; a=openpgp-sha256; l=785;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=R5JeIyhEIAP6a72Z0Jts2SebK0ldE35uk/7rt6IzKJ0=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGJLZn8qyhAYemXA27ezMkFPyG2bar3Y7NW1h4Mn/XNtl38ge
 i/t/r6OUhUGMi0FWTJGlbF/spqDChx5y6T2mMHNYmUCGMHBxCsBEcusZGS58fbbr2oS/OxKkVrpdur
 Nb/IZJialGz7UJlpwRxld7l89gZJh5ac/JtsTPXc+jC8PbVjD3V4jJN8eqLVm0Xu5EHOOBVjYA
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E
X-Endpoint-Received: by B4 Submission Endpoint with auth_id=1

From: Clément Péron <peron.clem@gmail.com>

Devfreq cooling device framework is used in Panfrost
to throttle GPU in order to regulate its temperature.

Enable this driver for ARM64 SoC.

Signed-off-by: Clément Péron <peron.clem@gmail.com>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index d5b2d2dd4904..109004e44d21 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -584,6 +584,7 @@ CONFIG_SENSORS_INA2XX=m
 CONFIG_SENSORS_INA3221=m
 CONFIG_THERMAL_GOV_POWER_ALLOCATOR=y
 CONFIG_CPU_THERMAL=y
+CONFIG_DEVFREQ_THERMAL=y
 CONFIG_THERMAL_EMULATION=y
 CONFIG_IMX_SC_THERMAL=m
 CONFIG_IMX8MM_THERMAL=m

-- 
b4 0.10.0-dev-65ba7

