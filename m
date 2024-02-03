Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F5812B9E;
	Sat,  3 Feb 2024 04:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933446; cv=none; b=qAt9xtzQirC/yVUn6eryphFRYnoNbKfY7JLAwuelGj9WgYVsKslmx/sXGuRjj0zUosbwsl1BRJP35T8jyEpSbbxHzyYaIK6wQvOjF4cVBMYolr12ew1uCljGkcWA2ayAg4WX9qwbahOPk0KG1H/NXwoMeOZDyRLZZof1jrwJAog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933446; c=relaxed/simple;
	bh=HhbeVmbjV0FhZ+5A1p7oFlpNnKwv90Pwv39c38Cuf40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mt3EryfghQHCPvKNQSGuoOM57YWGAFAIHUMoNogKgiyxWUkdJvCtfJE8IabcVnaJUhwrn3UrZHhT0cfjSeQlv8wZCnY+O45xjhdxF4DqwnW9iby15aAdgIXGsPsG/i0nPvsRtxcm8WqlniVcEicgkV/Tfp13ip5V9Xud6G+Onz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfyPh9EP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfyPh9EP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E540CC43390;
	Sat,  3 Feb 2024 04:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933446;
	bh=HhbeVmbjV0FhZ+5A1p7oFlpNnKwv90Pwv39c38Cuf40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfyPh9EP1ndwZjVHlq0096dmmzVc472y0GhDlYcU5zp7mpXFzOP1gc0hC+L0jeNIj
	 1MB6We9KF6N8oU7R+b5NTZMWWNmt0oV2on3JgJfWYIHUDiY/zVnfvJKihtlETTWp/r
	 DpywEuCbVRYM6VBQKQLPU5aX00UNpQHhzPDrsbrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Robinson <pbrobinson@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/219] mfd: ti_am335x_tscadc: Fix TI SoC dependencies
Date: Fri,  2 Feb 2024 20:05:27 -0800
Message-ID: <20240203035338.403327698@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Robinson <pbrobinson@gmail.com>

[ Upstream commit 284d16c456e5d4b143f375b8ccc4038ab3f4ee0f ]

The ti_am335x_tscadc is specific to some TI SoCs, update
the dependencies for those SoCs and compile testing.

Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
Link: https://lore.kernel.org/r/20231220155643.445849-1-pbrobinson@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 9da8235cb690..43cb511fd8ba 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -1440,6 +1440,7 @@ config MFD_DAVINCI_VOICECODEC
 
 config MFD_TI_AM335X_TSCADC
 	tristate "TI ADC / Touch Screen chip support"
+	depends on ARCH_OMAP2PLUS || ARCH_K3 || COMPILE_TEST
 	select MFD_CORE
 	select REGMAP
 	select REGMAP_MMIO
-- 
2.43.0



