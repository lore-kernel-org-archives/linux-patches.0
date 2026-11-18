Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043206;
	b=JIwTm8qF2NQsFUuRQsXTHedeP5e0k6TScXimvFw+PV0GYP5dxP4ZiAbEdFDxdeXeeLf+
	 ndMYa84XN5F1OFTkyer6FDYHyta4p0c+LpYDqfEQuKbovSg3C80LVnF9J9TxJudpvv0jL
	 L6vGlfe22vvagQepEgYD3aMEkKyZeGSt7GuX5H4qs8lUeeL5KJZaUN7yGv0mCZmqF93dK
	 nh/Yt4qG6FCEFLHfsMoDEeqhQrX3AUokfeOa+5c3Q+IJtRUIqQIy4/zwT/jg1rN8CgnmI
	 CUNsHWoBltX1ZGB3jaqhgZuBDz0WYpX+smB16fHBxBpmvrOSMhrrhZjn6jopaFFRlxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043206;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LPHJ1p36yAqRMlSg/xyPCEykGpLAMK1ziofKt2Odxk4=;
	b=rDpyluzbpFEevhSX1aXz6B+KQDlv+pZzrarQE6Yfap6qH0SW/uefHEtjPegeyQs/U2UC
	 nl+wsf8oCzRqM7QXb2Bg/XkPxiw7Dv41+x06HOiCGnRVP9xnwtG3H6ex6WNmP53xYTsQk
	 SVjs1LD8EJRl0FM8x6xtM9sTsxqajbcxvxrmlKF8wv10jZkoCakuYDp5Lg1nNLBGl4YvH
	 t4bSMRuT3HIpu12nxJRqcufcbH/29RBg88OuHGTPDoiOsugNNWv1s52fNLRQhtc8nhIAX
	 j5PdkTXrGwa9yfUvRFrDtebtDv87Gzp2IcHuD7X8Ne0MqAUuRrdGmergP2ZZFiIASMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oBFcHyNy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9313606A31C;
	Wed, 18 Nov 2026 23:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oBFcHyNy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E7261F000C4;
	Wed, 18 Nov 2026 23:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043205;
	bh=LPHJ1p36yAqRMlSg/xyPCEykGpLAMK1ziofKt2Odxk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oBFcHyNyTcFJwDI1G4604xrcofeRhvG08wyZ131pvxcK/q5DyTldgRxbev9fguTuv
	 4CyFwjhsD1enyxjADj7tc05f2SSm9u/202Oytkff2DtUErT8bt3ZTDc7E7yzzzviI2
	 Fgrds7P8N9AEbdi5f28WSmogCmJvf94dYC3EzIeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0128/2857] ALSA: hda: Check snd_hda_power_pm construct error before executing verb
Date: Wed, 18 Nov 2026 15:19:22 +0100
Message-ID: <20261118150205.958662477@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bob Song <songxiebing@kylinos.cn>

[ Upstream commit df27e4dc80c4a30ad206432cb848aab00de22ca7 ]

When userspace writes 1 to /sys/bus/pci/devices/XX/remove to remove
HDA PCI device, the HDA hardware control path is shut down and devres
unmaps the BAR virtual address bus->remap_addr automatically during
driver removal.

If a delayed HDA verb command arrives after the MMIO region is
unmapped, the driver will access invalid virtual addresses and trigger
a page fault splat.

So add an error check right after constructing snd_hda_power_pm.

Signed-off-by: Bob Song <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260717024948.506335-1-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_codec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index b715a6c366a8c..498bc523ba08d 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -38,6 +38,12 @@ static int call_exec_verb(struct hda_bus *bus, struct hda_codec *codec,
 	int err;
 
 	CLASS(snd_hda_power_pm, pm)(codec);
+	if (pm.err < 0 && !bus->core.chip_init) {
+		codec_warn(codec,
+			   "Failed to send cmd 0x%x ret=[%d], hda control stopped\n",
+			   cmd, pm.err);
+		return pm.err;
+	}
 	guard(mutex)(&bus->core.cmd_mutex);
 	if (flags & HDA_RW_NO_RESPONSE_FALLBACK)
 		bus->no_response_fallback = 1;
-- 
2.53.0



