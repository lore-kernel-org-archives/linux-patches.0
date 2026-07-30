Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C52B43F092;
	Thu, 30 Jul 2026 14:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421417; cv=none; b=g/4uiFfuY5Eqn28iFr1Kz+ITw2IJ7NYThLDXRVKUHw57VBQRbCIBhkuNxxv6cptYpvzGOnvNO/ljtITfvj+Jdfgv4w5TAbWkAgq3sXhSPX5uXen7etbJ/Qk1hllCVPSQ6NZXFTXGisXEU3OKxRv1jNZWh3ZTK9lEd+v97vorR4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421417; c=relaxed/simple;
	bh=Fm0mdogXPc2JvxluUp1EHdGuPlteAsVU2lZW6YJZRio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgZ+matpY66Xhd9kdLMrFKJ1rovSTp/Qytv3EFgfXyRrAmGQif4L78BHiD2OCehml6bz1APGHlZos8/jkFNyeOfv9vzQi5x4xrbU6ULn5qpoOYROcYoYuxcW2326lTJK4S43haGrvhsUTb80fs93DqsZo5PF8CpRAeZAgv+KAeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ldvxth3n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldvxth3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252BF1F000E9;
	Thu, 30 Jul 2026 14:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421415;
	bh=UAbvvsPTEBsjFQbNDdOPsWC/s5sSfRGmtSJiM1RkJ2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ldvxth3nEtHcxPDZ8jgMCy/svMllmZW0Yc/sWTDbxMGUyk0nNNFUoTPuaqiAwVLMS
	 wQ6imqcTHnjs+gBJl8PjNjUcszoewxEgft63tRsl7FrDxc2mYyq3TQ4diPtsc3aB3A
	 VCWj95895iwTYIhUPV22oeeRpAC9wl5hW03etq4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 079/744] ASoC: amd: ps: replace bitwise OR with logical OR in IRQ return check
Date: Thu, 30 Jul 2026 16:05:52 +0200
Message-ID: <20260730141445.951029360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit dec5aaa27603e1d7b426ce3504af6d1a62e4d444 ]

The condition 'irq_flag | wake_irq_flag' uses bitwise OR to combine two
integer flags that are used as booleans. Replace with logical OR '||' to
correctly express the intended boolean check.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Fixes: 7f91f012c1df0 ("ASoC: amd: ps: fix for irq handler return status")
Link: https://patch.msgid.link/20260707060130.2514138-4-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/ps/pci-ps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/ps/pci-ps.c b/sound/soc/amd/ps/pci-ps.c
index edff7f274a39d5..5e73fb20e152a0 100644
--- a/sound/soc/amd/ps/pci-ps.c
+++ b/sound/soc/amd/ps/pci-ps.c
@@ -248,7 +248,7 @@ static irqreturn_t acp63_irq_handler(int irq, void *dev_id)
 	if (sdw_dma_irq_flag)
 		return IRQ_WAKE_THREAD;
 
-	if (irq_flag | wake_irq_flag)
+	if (irq_flag || wake_irq_flag)
 		return IRQ_HANDLED;
 	else
 		return IRQ_NONE;
-- 
2.53.0



