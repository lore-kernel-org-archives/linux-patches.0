Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4331119E;
	Sat,  3 Feb 2024 04:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933854; cv=none; b=XY4+Oj7YX8PDtAs2RP8ssQBGDvzaJIXkdD5bNQuvaHLBTmj1llWP2zK4NulAAgASMltdA2zKnFhhAa6eIpbGeSnX8SpLoAllX3gaocEE3e9cr+yAFhVI/PbIHyEkW/hxJeE+mleGYgqsbz/t5CTE/ycL7tjLCMNzVQHnJrdVJJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933854; c=relaxed/simple;
	bh=T5yVV9cLGLfZ28zr+U8IpcN22gYDMgJXhGSbq/IZmy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IqPnnAyYd3HkiNe2LJBe8JXoFzkNkg2h2VasTx+hTpCUke+kiIPy3oyxDzDKfoBdyXp8w1BkQpS9+suGIqeBJHT8Mi/sOd7kUeHbSNdGMQrW6+JWFAK+JO7gxwSPfbBVEl4HyXCEDo/jZqS84M+O63PILKRH2RjGxFn7YOFHKB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GJvwnhp/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GJvwnhp/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136DEC43390;
	Sat,  3 Feb 2024 04:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933854;
	bh=T5yVV9cLGLfZ28zr+U8IpcN22gYDMgJXhGSbq/IZmy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GJvwnhp/2MsgBqaZeGSLodiRxVtvbSmGOmO1WzJRNHdxZL7vHznso+4ki1tHUERKR
	 +U0M1VAVXmL+lHCmMSLNg5xJqgi3mmO6hEDYM3ysjE+raGmsj1vYyB6ypIiBk30G/5
	 Fga7TLmmY99ETwuVdoZK7cHxmOdsI6r4J7UFgjkU=
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
Subject: [PATCH 6.7 185/353] ALSA: hda: Intel: add HDA_ARL PCI ID support
Date: Fri,  2 Feb 2024 20:05:03 -0800
Message-ID: <20240203035409.498494173@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 2d1df3654424..2276adc84478 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2504,6 +2504,8 @@ static const struct pci_device_id azx_ids[] = {
 	{ PCI_DEVICE_DATA(INTEL, HDA_LNL_P, AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE) },
 	/* Arrow Lake-S */
 	{ PCI_DEVICE_DATA(INTEL, HDA_ARL_S, AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE) },
+	/* Arrow Lake */
+	{ PCI_DEVICE_DATA(INTEL, HDA_ARL, AZX_DRIVER_SKL | AZX_DCAPS_INTEL_SKYLAKE) },
 	/* Apollolake (Broxton-P) */
 	{ PCI_DEVICE_DATA(INTEL, HDA_APL, AZX_DRIVER_SKL | AZX_DCAPS_INTEL_BROXTON) },
 	/* Gemini-Lake */
-- 
2.43.0



