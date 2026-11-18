Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033940;
	b=lWKSSfSsNVbLiXA5QjJtsTIB+WdEd1T1VRtDYaOHio23h2sqswsMAT9WlVcOZt12EK46
	 GfmRhD8HLUZzxmUj2LBWa94uiDYO/tQpZQvZZMnRXLONPVyBgB7+s3i+mR4IaBeOZxD2/
	 T9WGcIMjs+NDBnml2M53KLBGQ2abEDS5WMWxAwMDRKeATpGkciXlEdxD3WvG7uqPUGKD/
	 GckhyzyBLWzNcaVHHsGUeZ60pnR+AqyPjcp37XcQzQYeWEefdY/GD4DOSRoyh5Xr5wYXB
	 +DZ6LZ01/cyihrfuG883eBtavRk3akS9VoH1/WG4wQsRtSXYUReBH/pFi+Km+YSsY7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033940;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HnS9xv/IVGZXUdTqIsANoKG4gLEFJtLtBnvo2XKNv54=;
	b=J7JjTR9hlBWh9hbySN49YBTYORSGWxTpzKBClIUC0zcduiNElSP3Bdb5YiCtxAs0pGR3
	 aln6vSnoSe7bOBXfZE4P5sHxl288K3lNXGZMdtvfqkzkPaBV2lVM4unCrXxqLDrMcL2eJ
	 fzpcZscMuCUgwQSCc9MBBDQy9NqefslhqhfriT36PHXSClInKZbeAawsch+xGzm9JgtXK
	 xb27n/MGVe+pymoCrintkzngck4OQWYAYVuFytvOlbLGSivoQuqzOuerguTh7I5yayYap
	 ZuvrakqUzvlku1E5W4JgvqRDZOKiZ30002+qI3u4hG+2mIwjyQtNEl5WYm8eykCwXWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xsawty/L";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2B9606A31C;
	Wed, 18 Nov 2026 20:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xsawty/L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D86F1F000C4;
	Wed, 18 Nov 2026 20:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033940;
	bh=HnS9xv/IVGZXUdTqIsANoKG4gLEFJtLtBnvo2XKNv54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xsawty/LAswH0yl7rtI2Pww0fXg7ZzPkoXFUg9VSt8LK0BZzZ7hhFn8H+gU56g+mU
	 es5Kf6JYbmp2GCCw7sAnNrixy/uI7hjPF3Wt7cdobYyeADfUNNdJXMRIMdD2yh0Q5a
	 rHHPp0JyztzPMk4is1Pz/rP9XbTtF/eOLIhu5j28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0192/3318] ALSA: hda/realtek: add missing NULL check for codec->bus->pci
Date: Wed, 18 Nov 2026 15:13:34 +0100
Message-ID: <20261118150320.563335105@linuxfoundation.org>
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

From: Bob Song <songxiebing@kylinos.cn>

[ Upstream commit 3b36ac93739e7b119a30affaee9c2dd41f24efbb ]

In alc269_probe(), codec->bus->pci is dereferenced without a NULL check
for the ALC236 vendor ID case. Add the missing check, consistent with
the existing pattern used elsewhere in the same function.

Signed-off-by: Bob Song <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260730015302.253008-2-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index c7f392c0dd73c..6141b813b21ab 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11520,6 +11520,7 @@ static int patch_alc269(struct hda_codec *codec)
 		spec->init_hook = alc256_init;
 		spec->gen.mixer_nid = 0; /* ALC256 does not have any loopback mixer path */
 		if (codec->core.vendor_id == 0x10ec0236 &&
+		    codec->bus->pci &&
 		    codec->bus->pci->vendor != PCI_VENDOR_ID_AMD)
 			spec->en_3kpull_low = false;
 		break;
-- 
2.53.0



