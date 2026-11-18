Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034180;
	b=eyl7MJbbsIaRhtp6Z7cyHxcnpuIW1ASo5VyCo3GriFaWstD9RavvsWgUWlu/9RDt3HOi
	 8m8ST4bbdQu+XkUEM1WAdWGTULW0ra5LHOroiZzA7De16JyGlvnrSZEVuXxbFxLYQomee
	 ifnQanbTuGGKOopdeOYVkPdxoTYhtm7CnCe8Fmndqflz49q3R+yS1U8cqLdbEliWzZhg9
	 lI/syhzUM66zr85pBPAOjyEsznoFoTS39gpUPOw753npQpsMeCohw+zDNJ5Xd6i55dl6A
	 ZT8FNNxI1m1FFWCkjgtIi/HfW42zUZB/p+K3Ki4oTbXqksSymca/huPgo0U66VvjZtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c0timLJs66uC95i+dv/Fqt/EFHoJou+wb+mAUiOo6Ks=;
	b=AKGdZptc4kaM7cK+cCt10zjCWDqXo67Tiwth9V+nQiJ0FOnTxGxqX2tUq+Lao7AvRCEM
	 yYi1k/DZMZ5EppbSEIQL9cEsfGmnNLBPrRxEumloh+qa8eaGUMZzO6C4Cx2OApPMK8HyP
	 G0L04fs3sbBvyhWbrEJ3zqraXPRLdMLh0cJn14hwnBjoNNgfXSH2QTAcSJwKXCv471MJ3
	 BT1OhG+CD2OzeFzwdDA/xmy0E5O/ngpj3IKBggnxHS9XkU/GUGCGFEdQ5Hd/93SOoGpM9
	 m2Q4r3H4uYgtCmTWTgHO23Zc0XNlfG7kwa8j3PuJaDmOEeIdUmkzG4Yd1du8mNdAkhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w6SlUz9S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6AB3606A331;
	Wed, 18 Nov 2026 20:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w6SlUz9S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444051F000C5;
	Wed, 18 Nov 2026 20:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034179;
	bh=c0timLJs66uC95i+dv/Fqt/EFHoJou+wb+mAUiOo6Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w6SlUz9SR5Gp+NPOPnEpsGPAheaP086iG4y3JXiFuEHHybu9mNTb0rSBlowfV8nqz
	 97MPe3qf3EJ4OaOCjhT1Xtbz9Fqym9qsS4w0/HPhF5F1gDAxFpuEDyT6RrNiatsVac
	 /RRoQCoJm5EFgbs+qfBTrrnh/yWofNPnhpFX/cJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+10cd2d1efe8eeb604bee@syzkaller.appspotmail.com,
	syzbot+5ebe7cd17e48b4293660@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0277/3318] ALSA: hda/intel: Add sanity check for BAR0 size
Date: Wed, 18 Nov 2026 15:14:59 +0100
Message-ID: <20261118150323.805459279@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9895573b0185f922be4cf500a0f2e5b9560ab1c3 ]

The recent reports from syzkaller showed that we can bind any wild PCI
device to HD-audio controller, and if PCI BAR of the device is too
small, it may lead to a crash, as the driver believes as if the full
register range were accessible.

For avoiding such a problem, add a safeguard before the actual probe
to check the available BAR0 size.

Note that the threshold (0x200) is chosen to cover all needed
registers at probing.  But this doesn't mean that it would cover fully
for all features including the extended ones.

Reported-by: syzbot+10cd2d1efe8eeb604bee@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=10cd2d1efe8eeb604bee
Reported-by: syzbot+5ebe7cd17e48b4293660@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=5ebe7cd17e48b4293660
Link: https://patch.msgid.link/20260813150354.763502-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 059693e03fd96..c96253e591f21 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2164,6 +2164,15 @@ static int azx_probe(struct pci_dev *pci,
 		dev_warn(&pci->dev, "dmic_detect option is deprecated, pass snd-intel-dspcfg.dsp_driver=1 option instead\n");
 	}
 
+	/* A sanity check against wild device binding;
+	 * here the range 0x200 is enough for the registers used at probe,
+	 * but it doesn't mean covering all HD-audio registers
+	 */
+	if (pci_resource_len(pci, 0) < 0x200) {
+		dev_err(&pci->dev, "Too small PCI BAR0\n");
+		return -EINVAL;
+	}
+
 	err = snd_card_new(&pci->dev, index[dev], id[dev], THIS_MODULE,
 			   0, &card);
 	if (err < 0) {
-- 
2.53.0



