Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057705;
	b=cKEvpqc3yU5MMcpuXtZzE2+X2Jh10SElAFRrY+W/1y5cS8ZneFDqWVXu8F2wUJ62A9GN
	 /bwgTW4y4UQNDoGXag8hV7vj/fHkBnqFwC90PJDJ3t0QiQ6Fz/CkrV6+e9Q2ZWlKyV46+
	 fLqoDqBmVOLaIWy7h5PYqP4Tcifi1kS5iuvvNE3zt2mrrKO2q2TJUxyMVXgEQDtGPReEL
	 B3iHEWtsJPlK2xZdLz7WiPO9FPXWLhz4XOYZfUNNPRRSI+Xb0AG24LooL+Y5qYfwc7k8K
	 EkTCoDhj0acGqvJKBIiCX454Sg8aCunsM3ODGd63DmFmBSL07NasVZwpjuZcPAzr3NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gp1odGEn+f1kXoUhr7mKAU6WEeidyDduLq14DHrqQLY=;
	b=GF22aeQzmS6AWpQbTc+CaCzNQ3liGqRroMEKFW7ufkC5qCIIFDJLlNRrBGuKVZQ2DFgq
	 iZlt71eNJ+XaWV+2gU3rQwnt+c3hdhMD7Gtd0ennMkml3UEWvymGL1NhKOn510i2cWzrV
	 UBOE1kLGBM5+50+dvGbN/py1oJZ1Mo4xvscevrmAE4dr8ovLbyp/gsdivMM+XQIcDdn+B
	 Ux2466dFXpOfMQ2My31/2Ioe5a1CRtpclfec49EOsZHuk8KMLGm8RDPWSezizf/5bh27p
	 kav85z4pt+FcCbSEINuyZSkQhXgP7Vl5zFecJQT2j9mB8vMR98wGo7Z96dw2V070Cog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xZjwKBK8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40EF4606A320;
	Thu, 19 Nov 2026 03:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xZjwKBK8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956A91F000C4;
	Thu, 19 Nov 2026 03:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057705;
	bh=gp1odGEn+f1kXoUhr7mKAU6WEeidyDduLq14DHrqQLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xZjwKBK8v1lE2HdalgTwo0nyqYGIVDaYXdAuR9UVQmxJjHvzUK9SDNXUiZ8cECt4K
	 e5r4A3whMAdATdMEbWO/YdLA2yY3/YoE+fa3X5Za0tLaicI5nMfNGw3RvrZjBqCUTI
	 UMxhpVaZj9aJSzlp/8Ows76tNU6fBf+Wq3NmY99w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+10cd2d1efe8eeb604bee@syzkaller.appspotmail.com,
	syzbot+5ebe7cd17e48b4293660@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0175/1848] ALSA: hda/intel: Add sanity check for BAR0 size
Date: Wed, 18 Nov 2026 15:36:53 +0100
Message-ID: <20261118145918.872385439@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index cb3dccdf3911c..a16c09fcaedec 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2191,6 +2191,15 @@ static int azx_probe(struct pci_dev *pci,
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



