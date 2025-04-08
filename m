Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26142267B89;
	Tue,  8 Apr 2025 12:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116932; cv=none; b=jBpJYj+52CRtNx4mE2W1cGNUeGsrd0CpHE4VevH7sx/pAcaWN+qq0ZpUdRLz/PUWisG4iHifHlPnEJOsE/cozeF8xxql73dy+REE+yp/jbMwRdPptWldpR7IMf99mmmFBRaj9dH2IDVUWIh/MPJl9B09D/PClqyBnQfTxCDKobQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116932; c=relaxed/simple;
	bh=FyrqQSlHoDvsfZQF3kkntF75vhWDaazc/V4r04i74aY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFSJQs1BiXH4aMuvMES8932yBm1eJn0hkmAwHlQKy2dLLB1DfVx20IL2bMqhBKazNvGlIyawAbmxeJSV+iuWkahkbH4KMv+NLkWB8QUvzIYXyXjIjhRaLGH6g64Zg3B/FnIlfeN4obTJfcuTvK0pAyfdmUEPlTZh/xETTsnuqwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k6NEdIkJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k6NEdIkJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A67C9C4CEE5;
	Tue,  8 Apr 2025 12:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116932;
	bh=FyrqQSlHoDvsfZQF3kkntF75vhWDaazc/V4r04i74aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k6NEdIkJi9wkIRvpwyOQcFe8D0Dc+Qo16rvdgroo70ezz1IwYR3YIvgl2LjUKtE5J
	 WzBJHjyJzm+GbJ4A6QG4bJsSvGeYaKW67uf9NC5U/yCermfi7qEhJzDPSw+OY7IF2j
	 hsvfiNImQVYg8Yqc5w8p5mVXpQICDZIDtAeVyJg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 322/423] ALSA: hda/realtek: Fix built-in mic on another ASUS VivoBook model
Date: Tue,  8 Apr 2025 12:50:48 +0200
Message-ID: <20250408104853.315139585@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 8983dc1b66c0e1928a263b8af0bb06f6cb9229c4 ]

There is another VivoBook model which built-in mic got broken recently
by the fix of the pin sort.  Apply the correct quirk
ALC256_FIXUP_ASUS_MIC_NO_PRESENCE to this model for addressing the
regression, too.

Fixes: 3b4309546b48 ("ALSA: hda: Fix headset detection failure due to unstable sort")
Closes: https://lore.kernel.org/Z95s5T6OXFPjRnKf@eldamar.lan
Link: https://patch.msgid.link/20250402074208.7347-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 1e2059035d5b1..59e59fdc38f2c 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10716,6 +10716,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1c43, "ASUS UX8406MA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1c62, "ASUS GU603", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1c63, "ASUS GU605M", ALC285_FIXUP_ASUS_GU605_SPI_SPEAKER2_TO_DAC1),
+	SND_PCI_QUIRK(0x1043, 0x1c80, "ASUS VivoBook TP401", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1c92, "ASUS ROG Strix G15", ALC285_FIXUP_ASUS_G533Z_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1c9f, "ASUS G614JU/JV/JI", ALC285_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1caf, "ASUS G634JY/JZ/JI/JG", ALC285_FIXUP_ASUS_SPI_REAR_SPEAKERS),
-- 
2.39.5



