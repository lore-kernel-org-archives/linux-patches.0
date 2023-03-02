Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECB68F40
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 17:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C87C4339B
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 17:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677778007;
	bh=6d8ppsntDnaswU5U7Le7ZIYguUxZ/ORE4527Ug2f/wE=;
	h=From:Date:Subject:References:In-Reply-To:To:From;
	b=kYizmr8AvjzWe+f950PL5jfotJTXQoVMrFySzNDFTdmLa6FA0oK5Xyzpw2fMM63AE
	 0d4LC7xQmHBbiNCQ3em06RQuz/UyVbdAvKjCvZl3wvEyikOPyBIYHyHcqhmuWseju4
	 FZ41r7EBIjgOnOv+IWNYTZ1UF/sjdfkQbd6xF0Ew=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Thu, 02 Mar 2023 12:26:32 -0500
Subject: [PATCH v12 1/3] arm64: defconfig: Enable devfreq cooling device
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20220825-test-endpoint-send-2-v12-1-9eb08a678d67@linuxfoundation.org>
References: <20220825-test-endpoint-send-2-v12-0-9eb08a678d67@linuxfoundation.org>
In-Reply-To: <20220825-test-endpoint-send-2-v12-0-9eb08a678d67@linuxfoundation.org>
To: patches@lists.linux.dev
X-Mailer: b4 0.13-dev-14a61
X-Developer-Signature: v=1; a=openpgp-sha256; l=847;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=V1Ux6qOrYS0E4kR2yYvR4zCAfK8V7akAlNi3+jNyuRw=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGFIY7oS9r/rEU7wl2tnv+vM7+Q15sjO//hX1uHn0vFkLy
 /N186T0OkpZGMS4GGTFFFnK9sVuCip86CGX3mMKM4eVCWQIAxenAEzkQTPD/wSXuKPWUqqvVUMk
 ChPLv63K2O8tot1+2EX2tF3cDwvBeYwMK26Lbebe4NWmMP1a8PGag5N27toY5Pys+i4LJ8/3tXq
 ruAA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

From: Clément Péron <peron.clem@gmail.com>

Devfreq cooling device framework is used in Panfrost
to throttle GPU in order to regulate its temperature.

Enable this driver for ARM64 SoC.

Signed-off-by: Clément Péron <peron.clem@gmail.com>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
---
 arch/arm64/configs/defconfig | 1 +
 1 file changed, 1 insertion(+)

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
2.39.2

