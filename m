Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061044;
	b=E98Q37mZL4KnNPZ3fq2mUV07TkwdzvRACBymmReorYLCs93O5XMG87Xj6DE1Vq2Rr831
	 Pk6U7Fms7ikW+mw+RKsaj9x6VEuiY4ZIBvl03r1ryaTBFzumLjVgS10PmI2gKbZ3sQNXY
	 u6+veKJ2mNzbBWReG9gIrTt4WX808QVWG/dPu6PvYwTqIvUJHJYUFdVDUdCb/g5clJNCk
	 WgxRN/rjzf8ZVmHAhKSbxrPd15nFpvQFZajD8OC8g/Z2Z2keAiaroa1doKnG8kO1E8qG4
	 w77H5BO70PyaTltyEglyrZK3TdQjLIkMDbDlwUhE6Ny00bzcjtvjiLJFx7j4/+pSu9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061044;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1jMtN0g5iz6wJRHEOp6pI2W/os2WM71WO2ZLkfO9BoM=;
	b=eXTThfHzhgq3UrgeJfK+1J9eBSYztXEjDAXdI8YxLm6JqfdeU1XY0WJb5TVlinZMZTsR
	 SW1AeddQDUlrvHsqW/LCTUud0VOha7/QQXK182bcRznJLnB0fdFot6vgq/BiSrXx9vIAa
	 T1S+l3kyhES4+KjYE8/e1uLrponULW+h1vMUYzi82Q1GPXvIp24KsZR3g9z3Yv20iT4ML
	 vl4vGYw6T6tgf5k9OBOJMH4k9MrP0vqaSDEr1n77jgs+XswwwWL73vCDehJ6m8C4PY60V
	 yX6Fh1+AmbXNgEw1jEDXdAwmNNzUYm64IIdrVC7a4fWd8pROQKZBzsa6/4yPnEpr7/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Fq4zn/i+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6586606D80B;
	Sat,  7 Nov 2026 14:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fq4zn/i+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725E51F0089F;
	Sat,  7 Nov 2026 14:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061043;
	bh=1jMtN0g5iz6wJRHEOp6pI2W/os2WM71WO2ZLkfO9BoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fq4zn/i+dJ4rlznfg8Q9vGcn4Y+hMRoSx5eYDQSGulHkEhbt5lAR0iQ5ySProAllG
	 hGrABwsW8RDTBxYzh3JXgoICB/in6fXEKolL3vGmdTrpFr/VfAbccVaZPgq/HCg1vK
	 EKa0Tc918gL0lMrmGFUScuBwmRGAUO51gzevisSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+10cd2d1efe8eeb604bee@syzkaller.appspotmail.com,
	syzbot+5ebe7cd17e48b4293660@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0327/1536] ALSA: hda/intel: Add sanity check for BAR0 size
Date: Sat,  7 Nov 2026 08:39:03 -0500
Message-ID: <20261107135006.894700738@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d4e325b785332..48fe74ad34124 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2156,6 +2156,15 @@ static int azx_probe(struct pci_dev *pci,
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



