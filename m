Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5E33FB3B;
	Thu, 13 Feb 2025 15:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460225; cv=none; b=gZW39az3vYksXBCwP62/k5tjmoAI5hghASnrc7qv030+TQs8U9cH8Gv30mVoKFjbaPBJeBUFUWk2Vfarnc+9h66vZzwfLbVMo3XbeH7eP12EQhRC3x6CuYZje9wLG6zYfidFNCU6yvOxbxZOeKrNnz5kqh301HM4yD8RzHPNz8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460225; c=relaxed/simple;
	bh=4jUPFnbXEc0rfsPWMks2s/Jff8Ld3VbVOnSdtN3324k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUsjpFeqRf3mMLK/0FBhumvKKwU6F8wMN/TOLISKodGL24K8U8Bguxv3SUXiNZT4lxIYNeflpgTrRA0wr8GTMot2NrekQ2SBWTRR3h2sO+EUzOiVFkVhdN8bhwZecCf91oJSFNPHmvsZDuLmm/CoqNwZZXLiqe2QqkuCHntupbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5DXDrQp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5DXDrQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6D0C4CEE5;
	Thu, 13 Feb 2025 15:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460225;
	bh=4jUPFnbXEc0rfsPWMks2s/Jff8Ld3VbVOnSdtN3324k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W5DXDrQpVvBjr9XljQ8MlAadJKRrUW/QzFzqJyvU4XA6Qp5BlrYNnuwo6ctSkrlrD
	 JMi08QxuDNrMcKFbaKz+p+4+jp+nu6NB+nMX59aFUWOj6rGJCl0tewAjr4fd2OyNAv
	 CzzrZUDQPtMnUzDqAismx8T+mC/gYMm1D/0TXBwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Yu-Chun Lin <eleanor15x@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 051/273] ASoC: amd: Add ACPI dependency to fix build error
Date: Thu, 13 Feb 2025 15:27:03 +0100
Message-ID: <20250213142409.367660222@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 273688c053172..0b6a01c6bbb1b 100644
--- a/sound/soc/amd/Kconfig
+++ b/sound/soc/amd/Kconfig
@@ -105,7 +105,7 @@ config SND_SOC_AMD_ACP6x
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



