Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830903;
	b=EF8DZhp07UF7hU6LDnOqkUPqTxGGHpCV+G9LXeMekdeMM/BuYLsI/0+8e76iGtDuyxwZ
	 3HshL8paynjMR5w+1FbXjMJUbRDu7Wqn04nSYFOkTJ//LzQbXQx2T3mDREPHcqc2bJNXg
	 GWzg6c3ox89Bd+Yd5W+Sijo3Qv4Ne6tTV4xtQceCB8RkpykYU2NkNk6l2KNMbKGGCSBEI
	 Z4Td/F1c9FuC/+jBtCyAcXobQ6dR0Q/pd2gjSNALo62OymBecNFrXPMEnzXBEgN5s5I1W
	 gcYEVgZ7ufRS73xwhy/RewB7cI+f4IcPxmEM3GEcgIugVuz92qi0MsHv0fscYpBSHMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XpF8inSQasm1C+o61N6flcnwFC6xFKkqs+1Z2+yIjFQ=;
	b=yJcJ+/z57aB2Q9s6NHwL8IzxFMuKJL2bn0BDH57QEUl+BMa/+eMdRsJ4169SkrhPd28Y
	 MsSEvmXnNhYsxlsICE+J9vNqXBmsqU/IyQbP5+x20FUYBzv0bihPDa4JULEKSAJ09XkXU
	 yVJViWq6+h/sfT234zEmfPFOZ5e+jIVVfbp3EXA9WzKP/JZ12MaaxTQkYct0jhE+WJxD4
	 ehE9Ycg0bKHyKGqxgG2J1Y95CwR9blcGG+hgKwJ53vvI7GW5fQ5Hd7xVWKuS2ibDjpQx+
	 5eBz9LDLyHZGS244Fa5xtLFr5zef8a+OarJnAVLAV6tBq0E4yovXSzIRwiXJg+bcziw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NOuxywyf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A25606EE97;
	Wed,  4 Nov 2026 22:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NOuxywyf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1893F1F00A18;
	Wed,  4 Nov 2026 22:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830902;
	bh=XpF8inSQasm1C+o61N6flcnwFC6xFKkqs+1Z2+yIjFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NOuxywyf7eQBVXbo6uT2siZMquQoTPhvut9x4Uq+9u5btIxTxyBtjRca+M126u645
	 oVpRvY+qEfIER9YT7qZtCg5dHbNLZ/Emla7swRlSuQ6DLypvhmIuIdGgw9wd//c3el
	 VOg/SV3gubkWGj1jt6mCWJvOLGDjUtlL7qeB//m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+10cd2d1efe8eeb604bee@syzkaller.appspotmail.com,
	syzbot+5ebe7cd17e48b4293660@syzkaller.appspotmail.com,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0392/1005] ALSA: hda/intel: Add sanity check for BAR0 size
Date: Wed,  4 Nov 2026 16:02:05 -0500
Message-ID: <20261104211055.060795310@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 sound/hda/controllers/intel.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/sound/hda/controllers/intel.c b/sound/hda/controllers/intel.c
index f07fc5dc5cede..3ed33cba7d83f 100644
--- a/sound/hda/controllers/intel.c
+++ b/sound/hda/controllers/intel.c
@@ -2155,6 +2155,15 @@ static int azx_probe(struct pci_dev *pci,
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



