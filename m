Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7327F11CBE;
	Sat,  3 Feb 2024 04:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933427; cv=none; b=XZRfH5wpyRXRK+dJ61CHGa+bGMRhI3zjj3fJsBM3u10toSMLaDpxfCbedCVEgyl40+zGRT+1/uoDemH/Et/fKWQRxNGUJUT/kentPyUJIBad34Uq9U3KRVUIwXxL+hH5aAP6Ff9pIuyhr4rzCu8NJOrqduzCjqqRLiSFr9GtCXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933427; c=relaxed/simple;
	bh=8hUlnYrzgDTZMTB6gvkR02gkpjBuBcmZKxxH2YkoBU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c4lpyTrUaxnkaEHM3I6g9hFOjGnmzqXgwUdeN4eaOSNaNQf7HgolW+NY9s1NwMdzcuuYD0xeHwg8tH1vdyrM57rczwRRNFZKgF4uhDHmict2OqV1ECO5hidFx80KgW6NAtO3qFkqLrD2JcwnpYZFaJPMjFI3wuVmGQK/qx1q20I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qwLkCOyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qwLkCOyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B9FC43394;
	Sat,  3 Feb 2024 04:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933427;
	bh=8hUlnYrzgDTZMTB6gvkR02gkpjBuBcmZKxxH2YkoBU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qwLkCOyFBZqE+QAQMsDHe+umQbalj8L4E8M5UkPErfBv/6AzAROZz4xm8nXgma1o7
	 GJ9HWMP/RZLU0aSKTHhWV7tC+L8J3gc8Fgvlwu0yNFmWS75LOGeV8OMgME9l/b0geO
	 2KcKu+Um1I6hLMEwltkudIfwivf3LG9mJyfoyCP4=
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
Subject: [PATCH 6.1 120/219] ALSA: hda: Intel: add HDA_ARL PCI ID support
Date: Fri,  2 Feb 2024 20:04:53 -0800
Message-ID: <20240203035334.380609507@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5aaf3dcecf27..a26f2a2d44cf 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2549,6 +2549,8 @@ static const struct pci_device_id azx_ids[] = {
 	/* Lunarlake-P */
 	{ PCI_DEVICE(0x8086, 0xa828),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE},
+	/* Arrow Lake */
+	{ PCI_DEVICE_DATA(INTEL, HDA_ARL, AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE) },
 	/* Broxton-P(Apollolake) */
 	{ PCI_DEVICE(0x8086, 0x5a98),
 	  .driver_data = AZX_DRIVER_SKL | AZX_DCAPS_INTEL_BROXTON },
-- 
2.43.0



