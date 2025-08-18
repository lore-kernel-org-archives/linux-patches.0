Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E08335BC3;
	Mon, 18 Aug 2025 13:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524691; cv=none; b=dcjFV6fGei6D/R2I7/3m0RJuMVjPl+BYT8T/rkC1hIQ20yMCauyOnB98c07YBV36NBuGfTlOYZ6i+CuKTwRXZVg7Wj34qIt842oPq03H8Pep+7s1G0XqRePwMu5voWFd8ikO27ANwQyCEi2F4WWcnsVlthvfAEKsMHZ6w5Hmq4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524691; c=relaxed/simple;
	bh=/9eMFU/JhUNxlaFnHLROjZhx8UQUPqbtzIPnSNVr0PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ELdc1xWvc8x+iYreqxyHKRvZfUmT3Ya+E4Y4O7yFls+lgrSlHyJl/OiVPiLSRaXlKveBCZwFLX9V9OFNCzZEJt4ep4fMHyD4GTgaR5lSKn9X2MrEfEScz1EiaY/8nIFPUTW2M3Zaum5iW+7pllnkKmJ17F1E4gxlcxl3CjCcpKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U9b9WjTs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U9b9WjTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD54C4CEEB;
	Mon, 18 Aug 2025 13:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524690;
	bh=/9eMFU/JhUNxlaFnHLROjZhx8UQUPqbtzIPnSNVr0PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U9b9WjTsjqaUnntpAb3tajqG7viuSiotNRUJsqbB47Zw40E6WNXwepnYyF4RHkILB
	 213k6YnK7DGVk1WFHB49cDYV1hUDp2T5NScq42TBp98pMgSqFErdJjH4MI+DvYNprs
	 v4r1m7srR6CgtNzDSaPaZzoBe4KHbU+98jhmLVhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Eby <kreed@kreed.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.16 009/570] ALSA: hda/realtek: Add Framework Laptop 13 (AMD Ryzen AI 300) to quirks
Date: Mon, 18 Aug 2025 14:39:56 +0200
Message-ID: <20250818124506.144383636@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher Eby <kreed@kreed.org>

commit 0db77eccd964b11ab2b757031d1354fcc5a025ea upstream.

Framework Laptop 13 (AMD Ryzen AI 300) requires the same quirk for
headset detection as other Framework 13 models.

Signed-off-by: Christopher Eby <kreed@kreed.org>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250810030006.9060-1-kreed@kreed.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11449,6 +11449,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0xf111, 0x0001, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0006, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x0009, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0xf111, 0x000b, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0xf111, 0x000c, "Framework Laptop", ALC295_FIXUP_FRAMEWORK_LAPTOP_MIC_NO_PRESENCE),
 
 #if 0


