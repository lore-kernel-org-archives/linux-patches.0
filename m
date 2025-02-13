Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FD713D8A4;
	Thu, 13 Feb 2025 15:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459006; cv=none; b=sAKNaY4bCwpfKh5ndDy8xyHdu1t1c8ZRava1awJ0Eq20S+hqKUvyRoLwq6TzA9pLgAV4zidYOS9HIkkFqTk+7mwYbIGwMf+bea6eGbtXHhycY6vjMlol2OgzjH3qmdGNNuWsnefmFfR+Hs7uoVz1bIygeu24CO60mtox4gwBod8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459006; c=relaxed/simple;
	bh=GkZ405AnMDooZPBc/cZ6ELurNxkISiXNgVMutKeLfkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/Ai0gJBXdORc2pt0mjNe9hzQsMpAqN3IR9snFYgat2atLRX3WJwRKyP7FCHRolfYY0ZdLuEI61I90uJFpSwBPR+3vsEZTlmaCHAs4GrBXZZkm16PcEJiuhIc1SVgG3LeMlUi6kvNQjdB0rYYY9MeQDnFZOQlmxck1ZFbYuz56Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IvywgE1l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IvywgE1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A87C4CED1;
	Thu, 13 Feb 2025 15:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459005;
	bh=GkZ405AnMDooZPBc/cZ6ELurNxkISiXNgVMutKeLfkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IvywgE1llO5vdZA6DHhjPZVL/MI0ZpMUC9bZ/+8FHD2H/1MPXNVMUstQZ774cfs9j
	 crgoV6QYJSlfy1bRnqYjWgggoH+oVaS0uY1027aOteROL+40BaOdsqroJorUdobkVK
	 r21K79wHOBvSO61xIKk0I9PZipWtx79TIzqXHTqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Yu-Chun Lin <eleanor15x@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 098/443] ASoC: amd: Add ACPI dependency to fix build error
Date: Thu, 13 Feb 2025 15:24:23 +0100
Message-ID: <20250213142444.392117395@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index c7590d4989bba..8035211782791 100644
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



