Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051432;
	b=Fw23QJ+zniilj8PIOQSmTTxaZB8nciM3r4IXhnFtOh+GfUExZ2CA+PcL8xYqYPdi0DAA
	 idFWRd0wPg0WcPFa/IDUBL9PGnCHRjr/kqYxbOhD9CyJxHtGHn51AgHtWEKQ58OkE5oNO
	 fLfbZSKdazyXqgITpBFBt0QVGDLErsikq6kGLp2mN16KOBXcx202r8rB4jqcllpHSHii+
	 t1RDu4O0a+Yx677X+shoZxfmuq81vMKC7A1Es2fk6Kbtq9Sqa+61HZT2BIUkOxGLMdWPn
	 FNEqlHcQi238cl/1pqE+6WBnZgMs22wBx9gwLLJGjodlFQJLLPHmQTszfv57xAQsm9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051432;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HZuqSs7thm+NG3C9w2DkZzAYjZvl9XAB71C6EKq5nXo=;
	b=k+fMQ4lMJ1WX4ZQGVCp3Net8dcPKHwHLOrwmYwfeAKe40WjOXLfFvmFO62tSEbkRf6ng
	 I0MsI06vJqNwHyz9o45f53lNVzQ1Lys8q58TyimhOgjyV2xVei6BY5B33MZg3vFaIa9N5
	 xBO9bzPDEDtvJ7LdGwv4I8z+US7NGw1K3bOlN6YjPSQ/0HUXqNSAB6tD+3ddgy7LsLOFJ
	 DjePl09mUMO/B15Ge/c2Lc7cPSuySxs8eLE9S4m8Ig8RaPv/Anq/3l3p5TI65n+2InJQw
	 TBJweIki727ZXDIZ2aOQyeFz9yC8I3fnyh7h4v6l7BFbaF2sJmrp1htcDG2DDAwycmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sPl7RvrP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8CDF606A32A;
	Thu, 19 Nov 2026 01:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sPl7RvrP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14DD61F000C5;
	Thu, 19 Nov 2026 01:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051432;
	bh=HZuqSs7thm+NG3C9w2DkZzAYjZvl9XAB71C6EKq5nXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sPl7RvrPuKcWnOzkKPGrI0GXdtNLOjbHHEKOo/A0slOZDaPz+Zb+OoMYc9fVujxhx
	 d3KxHdBKxnWDncnm11lCQAM6qKtAuHqA/IUb+e3w0+gkgfgg+ICeOq020VTYfdoGgB
	 hn1ZR7fkPUCKIgh+qdcLuOLPTE7SgIvZzwL2y05I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+10cd2d1efe8eeb604bee@syzkaller.appspotmail.com,
	syzbot+5ebe7cd17e48b4293660@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0205/2214] ALSA: hda/intel: Add sanity check for BAR0 size
Date: Wed, 18 Nov 2026 15:31:21 +0100
Message-ID: <20261118150018.411357343@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c69f4e5989d4f..691fc4be1f022 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2125,6 +2125,15 @@ static int azx_probe(struct pci_dev *pci,
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



