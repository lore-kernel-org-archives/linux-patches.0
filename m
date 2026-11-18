Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053941;
	b=ir1hDVINpy+Z5LVwFQ+8toQRtWQJXYUjr1ErZA04YRdTpNJSfhvyGJWZrc0C3lH8hTkO
	 WYaan7rVeTH4g8EO1NXvratCQIV7LIwQRDcq6UdSyyF/gElqZeR7HqHlQOhSahO+UG7H+
	 Z7Z5rdks9fxk8aTvr258CjS/sC5VX43HdaooSahDlAZS9LHGx3Aq10NRpzcFJhYFLpV3E
	 xvkVQk6GpYE4P9pFpaKdcZ7EVllf7NHYjpbzheFEMJBoiXtQluOhxtB37JwJ1qjKBgT5v
	 z28tucvxwf5TddIoMlxkwSD6eSrhM7dxwApkBf6xKoPUMCE+wTRwCfENPDLugmDJNcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053941;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0R6UtCpkIQ59kVGugFRJtiaW3VE+njqQyOArVhRTEnU=;
	b=zf9piuiq+DpA93yjKku1OvCAi3PRDqabyiNZqB4m+Yu70getA1Lt103ftZXR84wdN1le
	 KyTjH/rRCNJ2cSPuqylWQYvwjQu7CngL0kkj/EwAgbmZGmLmXzlPg5cOszVRv265kKn/O
	 8OryCmZv2RLYGal5pz2IOoxa8XRTN7FQDcXnHwzth73NzDq3Lo3zHbz5tIFE/3Ete86BW
	 IbDjq5IMD9V6qdjkVDXGg/0dBUPEnPcP+ogrnvST8tN1tjSQC382lqU4NWhmint45fH7B
	 teB6ZXDT+rak3zmmKACjvhvjBVSJV0tB6SivCrH4RGf5vRPDCPxbbiu7+wJSLQ1WazA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0UVXrezd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D58E606A325;
	Thu, 19 Nov 2026 02:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0UVXrezd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F921F000C5;
	Thu, 19 Nov 2026 02:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053941;
	bh=0R6UtCpkIQ59kVGugFRJtiaW3VE+njqQyOArVhRTEnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0UVXrezdOcantzzivFuI13ocBGvHbGGhzVnQOBvUzni/x0NjW+846JK6J0Mupq/Sh
	 Ldr0R+5a8HpGRxB7SJZitkAkNEOdaOG/2fLuq9H4IEYyF6ee3dhjx7Jy8qYSZ9qmXq
	 6UkNv+6cznPUuBHRDCsoENrZ5udPSA4H6w+HGng4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1097/2214] ALSA: hda/hdmi: clamp num_cvts against cvt_nids[] in hdmi_read_pin_conn
Date: Wed, 18 Nov 2026 15:46:13 +0100
Message-ID: <20261118150056.087757203@linuxfoundation.org>
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
[ sashal: adjusted the target file to match the older HDMI codec source layout ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 51a22ed7325dc..9e3366d115a18 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1342,7 +1342,8 @@ static int hdmi_read_pin_conn(struct hda_codec *codec, int pin_idx)
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



