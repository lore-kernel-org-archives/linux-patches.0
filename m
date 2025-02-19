Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DF117A2FE;
	Wed, 19 Feb 2025 09:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956806; cv=none; b=oY/XT+xtGkHZEcAykOZvnjG8tr5xuTcDj62DLVCgQit8DnyTdB0n1rLdYFjHyYhJLlZgF/axPo1Q+yPi4CsyEvBl60nDqQsD45ezWoUMANyaUaiR2oU3lBm3r8G2MJh25ZGMrazvkbFGXTdVCf+hytY+/SpDlfiDJtz9KyVCq9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956806; c=relaxed/simple;
	bh=MUqx3Zozm/RSERDQpsrRjAj9FtSHhPe1j1SDKhUr1AE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ei4avEuzAgxv2W+u9LVeNRaR1TacOLsDjV2+ZPUmXrvIkbFc10kbGIVJY4yBooH0AZ0XTrWFtWtyiaBM7AavYuJKu8IWCJ/ouha2oJ10x7aQwoNGCQV/l5zhxV28CqRVqmQlFPxL83nUfhrrbZfwfhQXe481VJGLbILKJo4NV6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y/heRTdq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y/heRTdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F796C4CED1;
	Wed, 19 Feb 2025 09:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956806;
	bh=MUqx3Zozm/RSERDQpsrRjAj9FtSHhPe1j1SDKhUr1AE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/heRTdqzY+Hh3ZoriNglQM6EMBt7FGOJYlaVA3nZ/9vnNAG1WRr4jUNx2uz+vsoq
	 Aim2QU1309cRa9GWAAnSvPvovfjzNbn0zz54eXO6ZCSy8GTg5a6FqyzSa0lD+cAOJr
	 v5UxsW2zS1z19PgnFVjUGLXO4Bs4x+P8vfMTf49A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Yu-Chun Lin <eleanor15x@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 306/578] ASoC: amd: Add ACPI dependency to fix build error
Date: Wed, 19 Feb 2025 09:25:10 +0100
Message-ID: <20250219082705.053423901@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu-Chun Lin <eleanor15x@gmail.com>

[ Upstream commit 7e24ec93aecd12e33d31e38e5af4625553bbc727 ]

As reported by the kernel test robot, the following error occurs:

   sound/soc/amd/yc/acp6x-mach.c: In function 'acp6x_probe':
>> sound/soc/amd/yc/acp6x-mach.c:573:15: error: implicit declaration of function 'acpi_evaluate_integer'; did you mean 'acpi_evaluate_object'? [-Werror=implicit-function-declaration]
     573 |         ret = acpi_evaluate_integer(handle, "_WOV", NULL, &dmic_status);
         |               ^~~~~~~~~~~~~~~~~~~~~
         |               acpi_evaluate_object
   cc1: some warnings being treated as errors

The function 'acpi_evaluate_integer' and its prototype in 'acpi_bus.h'
are only available when 'CONFIG_ACPI' is enabled. Add a 'depends on ACPI'
directive in Kconfig to ensure proper compilation.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501090345.pBIDRTym-lkp@intel.com/
Signed-off-by: Yu-Chun Lin <eleanor15x@gmail.com>
Link: https://patch.msgid.link/20250109171547.362412-1-eleanor15x@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/Kconfig b/sound/soc/amd/Kconfig
index 44d4e6e51a358..6e358909bc5e3 100644
--- a/sound/soc/amd/Kconfig
+++ b/sound/soc/amd/Kconfig
@@ -103,7 +103,7 @@ config SND_SOC_AMD_ACP6x
 config SND_SOC_AMD_YC_MACH
 	tristate "AMD YC support for DMIC"
 	select SND_SOC_DMIC
-	depends on SND_SOC_AMD_ACP6x
+	depends on SND_SOC_AMD_ACP6x && ACPI
 	help
 	  This option enables machine driver for Yellow Carp platform
 	  using dmic. ACP IP has PDM Decoder block with DMA controller.
-- 
2.39.5



