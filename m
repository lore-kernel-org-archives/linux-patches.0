Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591526;
	b=WTxoyyKkAAvRETny5+R+Ku/RziOT3H6sGUWTNARiPVDNy6cRum1bF1sATulYfOq1wINQ
	 v+7CWQqht3rN9tirVFrwpTTQvqN2G9tc3CzXCMyObIjgAoFB0cnz/F014LydF4uJB4jdC
	 /qCy8is6PrTGz97QUgGD9swuUzH1freuh6JVfKakY+rEc6BPMQbXiTqgd2YoR9Y7scEo7
	 dMGWbQdO5USZZebDnaW2Av39xoU9Mj95mOnKMg4Mzdug+RBhpdNVszYjtgLTAQ1fIIwgA
	 tft3SPftTyNAwBBCbkM//pAr0DFtfBOujxpln9Q7O8IPagD2YwvKdmBc6lkcIn/J61w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591526;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OpYZKo/4h0fwhbJsQ6j38lauiqcmzXGk3eamgLncaEw=;
	b=m3/dX8xSabZDglPeG49oh+Ej1+Ai4inkVVRrXHO5zQW0NmgzTJh6RXyJ+Kpz1SJxnNJr
	 GV5gm1jY1EFOlnX17MRBsAGYkDKejahKYhsTZwXcRFtNxWIzwLPI2I3FcW+h47V5g6Hio
	 2JzYa46blz1z9Q/nv+Quxc0ERbcRfBxtLXoopXskramfhdScbhGR0rlO0utHRaKWRy4go
	 +JjRNuVUbBDojGWkSaZnSOKcXtqA7YWOAfsbZpZtUsCTresV64Hdmg00WPG/wtz0LozoJ
	 5tFWo0A4NewVMKEl25jwMxSNta8dIRsEsAoXOJj6cDuLH8i2jo5oBb1PdJoFZ30QPug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UvSx1FMT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9ED7606D4B1;
	Fri, 13 Nov 2026 17:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UvSx1FMT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663F81F000C4;
	Fri, 13 Nov 2026 17:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591526;
	bh=OpYZKo/4h0fwhbJsQ6j38lauiqcmzXGk3eamgLncaEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UvSx1FMTTIxQTQR8Cb/a9tkTpZMDFYmoWyTIgZdA+7gZccF1WghbrraLYwZQuqwBl
	 x1DIePIqNhQk7Q4UgKB4ynC2VteBMrwDnE66A98R5hFCbCp1cl1AineRd8bBJeY/vg
	 HUKi/uwokLotW3FYttN6Eo2u+EdeCiNBwcH40KRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 584/670] ALSA: hda/hdmi: clamp num_cvts against cvt_nids[] in hdmi_read_pin_conn
Date: Fri, 13 Nov 2026 10:52:28 -0500
Message-ID: <20261113153831.632125766@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit 6cf3ab38b0d53d41f00fe594b2986849bdf994ae ]

hdmi_add_cvt() stores each converter's NID into the fixed-size
spec->cvt_nids[] array (used only by the Intel Haswell pin-connection
fixup), but only when spec->num_cvts is still within
ARRAY_SIZE(cvt_nids); the num_cvts counter itself is incremented
unconditionally regardless of whether the store happened. A codec
that reports more converters than cvt_nids[] can hold therefore ends
up with num_cvts > ARRAY_SIZE(cvt_nids).

hdmi_read_pin_conn(), on the intel_hsw_fixup path, copies num_cvts
elements from cvt_nids[] with memcpy(), so once num_cvts exceeds the
array size this reads past cvt_nids[] and writes the resulting
garbage NIDs into per_pin->mux_nids[].

Clamp the copy length to the actual size of cvt_nids[] instead of
trusting num_cvts, which is also used unbounded as the size of the
separate, dynamically-sized spec->cvts array and must not be
truncated at the source.

Fixes: bce0d2a80e42 ("ALSA: hda - Allow unlimited pins and converters in patch_hdmi.c")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20261008085122.9442-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[ sashal: Applied the unchanged upstream hunk at the HDMI driver's older source location. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 8b68386e1ac94..c097fc844b18b 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1355,7 +1355,8 @@ static int hdmi_read_pin_conn(struct hda_codec *codec, int pin_idx)
 	snd_hda_set_dev_select(codec, pin_nid, dev_id);
 
 	if (spec->intel_hsw_fixup) {
-		conns = spec->num_cvts;
+		/* spec->cvt_nids[] only has ARRAY_SIZE(spec->cvt_nids) slots */
+		conns = min_t(int, spec->num_cvts, ARRAY_SIZE(spec->cvt_nids));
 		memcpy(per_pin->mux_nids, spec->cvt_nids,
 		       sizeof(hda_nid_t) * conns);
 	} else {
-- 
2.53.0



