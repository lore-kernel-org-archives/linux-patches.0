Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438B11D61B9;
	Wed, 19 Mar 2025 14:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394909; cv=none; b=tGA4Z1Fzogm5Runxr9DFIkwTpBk0d0wuXdqyYgHK0sSlSMIqDGsdPGduzi3IhRi0qKxD2i24ALQ87zLj8yiXbC43pFFAkfUfw8/NKHQmO6SGZkGEKhhjSbECftg3XQW/R/42iq5CPQmzDt88SiGXPvuuB63AuIoNvsEc+6PVn9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394909; c=relaxed/simple;
	bh=h3O9gwR1o6DBuaB0uzR4IPEKW1zITiCofi9VXz1/O5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ffsXpDKlHIUxaGy6yE1PNMrVdaavc8uKtJal1DFJx42ECNIsTWQ9fuBRfKnhPyJdJGHh24RFJWC8JEMr7p0bJKhO5XMRmpK9rQMUobLYOLBeRE+8HKv7LZgumqC4E49KfVjO1ywOBl5npxqau1NwIIYLfkOXaVnffThpItOUz8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7V/Rghf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7V/Rghf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FBEC4CEE4;
	Wed, 19 Mar 2025 14:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394909;
	bh=h3O9gwR1o6DBuaB0uzR4IPEKW1zITiCofi9VXz1/O5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7V/Rghf3nSB1vcKzT8iW3Ez5xecVf6/8k2SVPyHeo1gDSweFSQ4PEpdUKAp4XBgQ
	 CAKP9s5y67Ri1ozLApvnFMy+RgEDgjAE0sLdkO6M4xw9rahTLwH6Oa+bcxmwM+XlAb
	 PB7s3BKB24gzWnKjnZclErSBc5jG6Au+yuh1JPtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Kai Vehmanen <kai.vehmanen@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 120/241] ALSA: hda: hda-intel: add Panther Lake-H support
Date: Wed, 19 Mar 2025 07:29:50 -0700
Message-ID: <20250319143030.687709156@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit d7e2447a4d51de5c3c03e3b7892898e98ddd9769 ]

Add Intel PTL-H audio Device ID.

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Kai Vehmanen <kai.vehmanen@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20250210081730.22916-5-peter.ujfalusi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 188b64c0ed75f..c050539d6057b 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2498,6 +2498,8 @@ static const struct pci_device_id azx_ids[] = {
 	{ PCI_DEVICE_DATA(INTEL, HDA_ARL, AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE) },
 	/* Panther Lake */
 	{ PCI_DEVICE_DATA(INTEL, HDA_PTL, AZX_DRIVER_SKL | AZX_DCAPS_INTEL_LNL) },
+	/* Panther Lake-H */
+	{ PCI_DEVICE_DATA(INTEL, HDA_PTL_H, AZX_DRIVER_SKL | AZX_DCAPS_INTEL_LNL) },
 	/* Apollolake (Broxton-P) */
 	{ PCI_DEVICE_DATA(INTEL, HDA_APL, AZX_DRIVER_SKL | AZX_DCAPS_INTEL_BROXTON) },
 	/* Gemini-Lake */
-- 
2.39.5



