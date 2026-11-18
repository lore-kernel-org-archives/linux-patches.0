Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059664;
	b=yQnquckLiw/RWCmfzIf9OFknUZ3DSbGu4o2MeRycz++St5Xw8Aj12WNsKceIO+XmSFXO
	 zqTnJkT30h6KF7KmOpyfiU4vokFW2n4wVRRRcudYyGnnSqu7vN1vdRTLmZta+eSUwQ13Y
	 A38Dec+Sl7nycx/EN/pgXH8ql5g5hGGGG9kX7jlrJbi5L0ceK0l1IKar57D/qE5hdilCh
	 SmA6COoP7F9Wcrt2xxlWImtCuaKDr81QEI6gW3zDRECSqhWtKYls80+IkqVUsut5t9jHX
	 g49sn0IgmH8TiTxWckThOhbo5LSi0xz+t+Ar+BZZN+D6rwQB4tCny2dT55dtTbKnOjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nhfpt4xBTQVRBq1GcKfE2D0XJPRaTu3no0CasqBx8qA=;
	b=OzDHFjQMBbfMKcqp7676UXo87/BxccPoUf0mLWWC08OqfReUWTHHb1LkVJybaqCbSRX5
	 Q94evi8umpO+FYI3V2CCMkfJeMKwvcrQNT0JSB0qEPLrIVeVLbZeqQNSMPjaQgePkhNgi
	 bVuwNorSOUxPgSzMbX3ep0CKa/RMac/VxAeI87pH8FCFMm8XqfMqnTBhG+NkA5Frgq7Gd
	 y3rou/P34UgrGj6/QJWlJVRkXnX2FxfOFHjJfkPMaZX8y2AcBijXtztAR8ciZ+AQEQjsg
	 VzEGlXPetG2ANnccbzEjKjHOJJdR2JCn5skswg0Zo42VU0pWD1LKXtrZ/xaHG5BCf4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oQi75VtZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780F7606A337;
	Thu, 19 Nov 2026 03:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oQi75VtZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE061F000C4;
	Thu, 19 Nov 2026 03:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059664;
	bh=Nhfpt4xBTQVRBq1GcKfE2D0XJPRaTu3no0CasqBx8qA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oQi75VtZSZA1H+TYhYSCl1bSuIM8C9Q8e3GGg4KGorCDaSOScd9yC6HhcKMGUv0aD
	 QC2oeBfCtUZByLDy+tiewRN+hb8N+DqHeXOsJJHOs3Vbk2VBLb+5ImcSB0lF1WjLE0
	 tVBNbcofu5nwP4jIDy3Hd0eek+dPuAKtndfGJAfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0921/1848] ALSA: hda/hdmi: clamp num_cvts against cvt_nids[] in hdmi_read_pin_conn
Date: Wed, 18 Nov 2026 15:49:19 +0100
Message-ID: <20261118145955.380132519@linuxfoundation.org>
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
[ sashal: adapted the patch to the older HDMI codec source location ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 77192df4d95fd..66ac580190024 100644
--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1341,7 +1341,8 @@ static int hdmi_read_pin_conn(struct hda_codec *codec, int pin_idx)
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



