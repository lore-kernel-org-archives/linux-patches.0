Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017344;
	b=Ok6MiithYCPva5CDoBh7ZrtW8B5B0RrRewEPDSvw7665/KSJbCT/UPo2nPI3qFBkFKXD
	 YC5P4+9jCLI616JreW0wAOE4y2MUlGkFjig9QqvDwtZD59/S6pJ0cY5rXNWAFeiK75IkC
	 Fi9PSsj3LW0CSFLh8nXfe3WQgpQ5YHqfHHwj4KqvS8xKahOQDHAIKAoZvqxktKyRmI5C4
	 h7frTjCp++WvbOe1nJ3hgy+evBIW7OYfJjTLJcyEw7wA84tUAbNqPc3I7PxDyFHT2Hais
	 tJ9kb8WzmjmzytifvpjWyU8BMCFWwtkWxp8yBsyO2Sr08dgkTqfSfdkeqFRyn3TBrQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x8m4Lq2f1xDWte5y1lS1jAYCubPc5YLWyf6bX6/QnNw=;
	b=v/OoQ5Pqmf+cV4bOGs2r3YYmx+Uw8nj30UM9vPn777VURTO7QPQi11X81DUqEJcFbmlD
	 beBH+M5C5EP/97kXlXuIF1gP5vp8+FDBtgljQ20Jq7G+imO5EM8yD/lChVPI9OTKkgmud
	 4OF5ouo236ifhpb35Xmeabod2iArEqrdvAoxyRLRuDGlm+/Nw2/1DL5pDcOygzAVpcSti
	 WXWweFoRbNZxRQRHDPgVeXSf/xK58hIMlJibWnrfiwEwXaFGqvuDZdlKMb7n5BQizS/pd
	 a4swB+E1DoYYwsUQ1zbP870ozyfZyQtlM6E4CEbHWNJgsiOkUbfYBdqKI/NPVC8S1Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1TMzappc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B88606A31C;
	Wed, 18 Nov 2026 15:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1TMzappc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03A81F000C4;
	Wed, 18 Nov 2026 15:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017344;
	bh=x8m4Lq2f1xDWte5y1lS1jAYCubPc5YLWyf6bX6/QnNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1TMzappcDF4GTVsMYwQH4/KTNhp9igfp76N2Obozj17NUJ2V2I5wqi79gdefyGqcH
	 U9GdxwKjK/aP4jJ4pVKJytd++GewsNFeJCy0xnIYOiW7wJulYVpCivdr7aRNAUAtsv
	 hE4R6wOh4pelZfIYWSe37ARV+UH+UmR7RRgDy+E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0851/2651] ASoC: amd: acp: add EFI dependency for selecting TAS2783
Date: Wed, 18 Nov 2026 15:34:51 +0100
Message-ID: <20261118150318.509600609@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 4d2b92b82ee82f0008179cd795b02256144064e1 ]

The TAS2783 codec requires EFI support, so it cannot be selected
unless that is also enabled:

WARNING: unmet direct dependencies detected for SND_SOC_TAS2783_SDW
  Depends on [n]: SOUND [=m] && SND [=m] && SND_SOC [=m] && SOUNDWIRE [=m] && SND_SOC_SDCA [=m] && EFI [=n]
  Selected by [m]:
  - SND_SOC_AMD_LEGACY_SDW_MACH [=m] && SOUND [=m] && SND [=m] && SND_SOC [=m] && SND_SOC_AMD_ACP_COMMON [=m] && X86 [=y] && PCI [=y] && ACPI [=y] && SOUNDWIRE [=m]

Add this as a dependency for SND_SOC_AMD_LEGACY_SDW_MACH, assuming
that this is only needed on modern x86 machines that require EFI
support already. It would likely be possible to do something more
complex to still allow SND_SOC_AMD_LEGACY_SDW_MACH to be used without
TAS2783 when EFI is disabled, but I cannot see a usecase for that.

Fixes: 28114992dd2f ("ASoC: amd: acp: enable TAS2783 and add RT712-VB SoundWire machine")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260925131137.146638-1-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp/Kconfig b/sound/soc/amd/acp/Kconfig
index 6433876430f04..b7b7b4f4a55ca 100644
--- a/sound/soc/amd/acp/Kconfig
+++ b/sound/soc/amd/acp/Kconfig
@@ -167,7 +167,7 @@ config SND_SOC_AMD_SOF_SDW_MACH
 
 config SND_SOC_AMD_LEGACY_SDW_MACH
 	tristate "AMD Legacy(No DSP) Soundwire Machine Driver Support"
-	depends on X86 && PCI && ACPI
+	depends on X86 && PCI && ACPI && EFI
 	depends on SOUNDWIRE
 	select SND_SOC_AMD_SDW_MACH_COMMON
 	select SND_SOC_SDW_UTILS
-- 
2.53.0



