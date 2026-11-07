Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063200;
	b=MOHbwOJnbPeA6TJbHG0QsdyKHzy2duUonslDj9OFyavZRF7bm2Jb5ISYJDJAAYwE6h4B
	 fkb6+ojbzEN6jvp8t19fuyaHhne2PR1Mwwl05Lbv/bYKiJPDeyNO5RDA7Sm34d2aQ3mQ6
	 txQHEssCFbI29EehvlYnXywru7TSzzEBaA15qFAJqSFZWgz1kiySr+HDFjnBK0bEULuAJ
	 qoL0vmPakwX6WKyOSQj8stkOhXocMATWGH4+iDkVXcHAErg+HjQjjFuzus550Eh4kqk0O
	 u832InxfkbypUgm8OIpspH7gJrVOoxrWLJniIrGV2J4KJePK1nUYa6d4ytd0K0PeqAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063200;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U7FhIpXdHFtoJPpGa6tYSLhASlevBXlO7SHig8LdCLk=;
	b=XkfAS+ztOBYzuyWvZivqiUM4dZ9fzDXLFpf64aWkY/eP3AEYmmw/PePw7nH468T2yny1
	 D952v/uGMRbjv1mM9qClOS5eMh1PH4xLmiHIlIR1nTTiVUIyiBzZfPhjUugg8ZcqV7CvG
	 ij0EBd354/7ioggwsO2qQeYrDDwUF2bkIJmI+XItJrJTb1h9W0qV4gOGzxEGDU65uFKKp
	 OUY8V1jm+fIvRN1mnWL6SKE1A1bkcZGECmPHCmuc/pvee1hhyNHcLqXW7s3agKjm1eBYD
	 1LROwAAj6LFiRbxr/QPW4RvGfwzVZtZGBsmF4ChYwo5jsO2AiDGitVF6Biy+dumkzkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P6mwGuII;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFB5606A33B;
	Sat,  7 Nov 2026 14:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P6mwGuII
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0651F008A1;
	Sat,  7 Nov 2026 14:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063199;
	bh=U7FhIpXdHFtoJPpGa6tYSLhASlevBXlO7SHig8LdCLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P6mwGuIIm69tyPw4ppiCWyg6Gwair6Q6KIw8T1OQDeYhQVTAGujAyCWcYMNGK0SaO
	 CS7YVp6OEOH4VCmz2GFS35ceTZi5mHjEOL/znIkPyPENCjrOxUWRXRbkhruCY9oUSF
	 cg2VvZvlVg/sceyDnbOk9slWmt/J4nrUNr1NTHXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 413/869] ALSA: hda/hdmi: clamp num_cvts against cvt_nids[] in hdmi_read_pin_conn
Date: Sat,  7 Nov 2026 08:51:35 -0500
Message-ID: <20261107134907.360857336@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/hdmi/hdmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/hdmi/hdmi.c b/sound/hda/codecs/hdmi/hdmi.c
index 480d1c5f129fd..a30072139f352 100644
--- a/sound/hda/codecs/hdmi/hdmi.c
+++ b/sound/hda/codecs/hdmi/hdmi.c
@@ -983,7 +983,8 @@ static int hdmi_read_pin_conn(struct hda_codec *codec, int pin_idx)
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



