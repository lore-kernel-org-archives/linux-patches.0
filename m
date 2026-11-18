Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022199;
	b=YbBJG2MLZbaJl5swgz+4qa3kNv1xNj73sbbwVLWczkaHMxuQvNQ8B7VtHGaWrS5KnGxQ
	 uaKscPdCnN4JGSfBOvPF9eyS1QRoFnq4nTJtlK+rPe4xdFNmoTFvdC3nI84r7eAvd5wop
	 cJLFwLvddjfIqEKjry39zHh9wCb/jZwea/UCMJNcBqRapUtm8j1AQ2jCEOex3vfYsz2Xb
	 EF6CmzLxmU74NGN6dS5dpKiRXyLI/zsVi1uAXFSdRsAuoUOYVl+WDEoAdqkHbWh6Xng/C
	 JwAVo/RDu9lnTLLgcY9vhgEUYU8E/l5T4wDzEv7m5cXHSB0Qo4Y7yjCYw5WujuKN57A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K4q9rqrGHSb+KFv7pNX6A0qlS5Jw73q1bmhlnUl8ulg=;
	b=pMetUfOLMD/9AtOYsYk35Yc4RtYwuEHJYimdamiYwqZAVKqlA70Tt/n0UWVCsaJUcnFY
	 CbXamKSTk1+n9eeRm7GtiWhf1Xt6TjRahE3PyLK5d/wTf8VjR/QngnVPy0ilkdAqIvire
	 4QCOQ5fIN1u43guUYn1jlbXEtnOpmQecsRyE2STmKF4aYXVX3Uqr4Z7PlMens3M+LZNKH
	 8InagrRskon+v+NbpqqWHfxHVm8RUDPYSRTLutFpQ8vcvPQOMvsxJC55VW/mFyP4NbnOQ
	 YkE2q1pcAXU0oQFlTWjBeWWX7In/eOX9su/gcOJDPFtKsksMj4sOaWETBNoqpIR63Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="bO1/cX3+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC7A606A325;
	Wed, 18 Nov 2026 17:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bO1/cX3+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B93C1F000C4;
	Wed, 18 Nov 2026 17:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022198;
	bh=K4q9rqrGHSb+KFv7pNX6A0qlS5Jw73q1bmhlnUl8ulg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bO1/cX3+McfPDW/vS+9qCvNRW1DCwBmuJwRafO/UQuQ+yXRD4zutqT3rljqASdTCM
	 tMRXwM/icqPhpSNN7OHuRtlMJN0qtowBgCtDDEdUJp8hDYgIq+YMAPw90VjAUCvNF1
	 rCmWWOs7VWgw3fUGQNhpiC/5/0hiqHBZsOTedbjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Li Yifan <yifan2.li@intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.3 2575/2651] ASoC: SOF: Intel: hda: Stop the controller before freeing its DMA buffers
Date: Wed, 18 Nov 2026 16:03:35 +0100
Message-ID: <20261118150417.056753176@linuxfoundation.org>
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

[ Upstream commit 11ae63bd9030349a0136fb2edd1622a4a029edc8 ]

hda_dsp_probe() starts the CORB/RIRB DMA engines through
hda_dsp_ctrl_init_chip(), but neither hda_dsp_remove() nor the error
path of hda_dsp_probe() stops them before hda_dsp_stream_free() frees
the CORB/RIRB ring buffer and the position buffer.  Unsolicited
responses also stay enabled, so the controller can keep writing RIRB
entries into the freed page.

Until commit 9e6966f70404 ("ASoC: SOF: Intel: hda: Keep non-alt mlinks
powered at probe on ACE2+"), hda_init_caps() dropped the initial
references to the non-alternate links, and dropping the last one
stopped the command DMA, so a probe that failed later, e.g. because
the firmware is missing, did not leave it running.  Now it does, and
as the probe runs from a work item, the device stays bound after the
failure, with bus mastering enabled and the DMA engines pointed at
freed memory.

Normal removal resumes the device first, which restarts the command
DMA, so there the ring buffer is freed while the DMA is running until
pci_disable_device() clears bus mastering.

Stop the controller with hda_dsp_ctrl_stop_chip() before freeing the
buffers, as is done on suspend, and export it for use from hda.c.

This was reproduced by binding SOF in DSPless mode to a QEMU
ich9-intel-hda: after the probe fails with "SOF firmware and/or
topology file not found", CORB and RIRB DMA are still running with
unsolicited responses and bus mastering enabled, and the page they use
is soon reused as a page table.

Fixes: 9e6966f70404 ("ASoC: SOF: Intel: hda: Keep non-alt mlinks powered at probe on ACE2+")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Acked-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Tested-by: Li Yifan <yifan2.li@intel.com>
Reported-by: Li Yifan <yifan2.li@intel.com>
Closes: https://github.com/thesofproject/linux/pull/5976
Link: https://patch.msgid.link/20261028144446.992948-1-sashal@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-ctrl.c | 1 +
 sound/soc/sof/intel/hda.c      | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/sound/soc/sof/intel/hda-ctrl.c b/sound/soc/sof/intel/hda-ctrl.c
index aeb34310eebd6..333f6bbea7539 100644
--- a/sound/soc/sof/intel/hda-ctrl.c
+++ b/sound/soc/sof/intel/hda-ctrl.c
@@ -349,6 +349,7 @@ void hda_dsp_ctrl_stop_chip(struct snd_sof_dev *sdev)
 
 	bus->chip_init = false;
 }
+EXPORT_SYMBOL_NS(hda_dsp_ctrl_stop_chip, "SND_SOC_SOF_INTEL_HDA_COMMON");
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_DESCRIPTION("SOF helpers for HDaudio platforms");
diff --git a/sound/soc/sof/intel/hda.c b/sound/soc/sof/intel/hda.c
index 4dbba9186b29d..2a40cb9bf24d9 100644
--- a/sound/soc/sof/intel/hda.c
+++ b/sound/soc/sof/intel/hda.c
@@ -939,6 +939,7 @@ int hda_dsp_probe(struct snd_sof_dev *sdev)
 		hda_dsp_ctrl_ppcap_enable(sdev, false);
 	}
 free_ipc_irq:
+	hda_dsp_ctrl_stop_chip(sdev);
 	free_irq(sdev->ipc_irq, sdev);
 free_irq_vector:
 	if (sdev->msi_enabled)
@@ -1006,6 +1007,9 @@ void hda_dsp_remove(struct snd_sof_dev *sdev)
 		snd_dma_free_pages(&hda->iccmax_dmab);
 
 skip_disable_dsp:
+	/* stop CORB/RIRB and position buffer DMA before the buffers are freed */
+	hda_dsp_ctrl_stop_chip(sdev);
+
 	free_irq(sdev->ipc_irq, sdev);
 	if (sdev->msi_enabled)
 		pci_free_irq_vectors(pci);
-- 
2.53.0



