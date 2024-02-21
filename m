Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E0F7BAFB;
	Wed, 21 Feb 2024 13:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522649; cv=none; b=nn/EOJNM9szyWbRlzQEILJdljpducAdXfCU+V6ZKIzTJLBc3khxanWOzlwuCMECaieejGi9qeK7TQduM5S1vNS863YJzCtqUablfnTr0wkqItFEXhQg9/tF/ChyUs3ZCB4GEY8z/OvCaFV28c3srYZh7R9XO5ZQR4LyvmJ5dAtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522649; c=relaxed/simple;
	bh=9uFA/vP0R7KkGvQn9+DHp2yP0EwcUiZAzf92KZmSNow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k6B1jrUIdGv1ukfr1se5KJA+cGoad/A2L6FaGPZY9nFhJHvI5UXitsPCcQRi6l0N2W6TIOX3kKKZPrNFwOeNu9ZJJn7X1B4Bkg7g0u80RLc9IZrNpkanj7OpzTv3hqb7DIAYcbefPBND/I4VQK0uDV2TZtUfDsobSqAT08+mSZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQs2FcXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQs2FcXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07734C433C7;
	Wed, 21 Feb 2024 13:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522649;
	bh=9uFA/vP0R7KkGvQn9+DHp2yP0EwcUiZAzf92KZmSNow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQs2FcXhUmFrNzhi0deKe5HXOW4f8mIn5uwZR3GwRicLQihj+Us2n86uEoJXAL5OC
	 ur8KPQA47dpFvtcoZcgAo9LustBnlsXG0jlHwrE83IoO2LUGqvjNw6pfxqeGLPfp3M
	 I6Cv5XfMv2XwaDkxHoIQ4mWNWiskrHDKJKs3g4Ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 221/476] ALSA: hda: Intel: add HDA_ARL PCI ID support
Date: Wed, 21 Feb 2024 14:04:32 +0100
Message-ID: <20240221130016.054108899@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit a31014ebad617868c246d3985ff80d891f03711e ]

Yet another PCI ID.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Acked-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20231204212710.185976-3-pierre-louis.bossart@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 65f7e3dc4602..dd4d802c9e71 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2516,6 +2516,8 @@ static const struct pci_device_id azx_ids[] = {
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
 	{ PCI_DEVICE(0x8086, 0x4b58),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
+	/* Arrow Lake */
+	{ PCI_DEVICE_DATA(INTEL, HDA_ARL, AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE) },
 	/* Broxton-P(Apollolake) */
 	{ PCI_DEVICE(0x8086, 0x5a98),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_BROXTON },
-- 
2.43.0



