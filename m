Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064526;
	b=LLMkhcEA5HWMgTuJQRhvXK8jIm6BbgBI8w9D4lCmRtzvnOD9TdHGjV6eKPTV0difCVAp
	 EWH1rWROTlq9jwWTM4DEZu3rV98d7zmwrWib+Vr8ncb18LfbjsTA0eYX7tnlKEQfXQOTn
	 vVecSZj73WXaL5+815D1y6adL6PnE1gNmdWs2zsmOyxYfMgccY6w6Dbf9vBG9zG5N9x6d
	 kTUF4JXo9VmJ4lyiKmgGbPFm2AGSeQ2gp7JdPDEsxXyGnlHKMjMJwOd9uWC2w1JmZY6au
	 rJkZ3KciJzxT24oxMIfWlB2KBtTNNO0Mz7hvUsPyh6YnTgPWsTvKDge6rgljOVJDRrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064526;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wxnBSDXxY8taYYqQKGDItlK0aO8QHKVXaw8ngWuWni4=;
	b=xBn5BM7MAP+KOmfCmdtjlOKDQ2796G8QJEboezBIcG6NabeVAionl4342yVDTN/P42JD
	 EQwhyeuSQeT5cJUZzeLErZk1e6jS19vraDQqZkP8px4ER1jhhl+5We1YYOP58TlVtBk5u
	 erHwYFo7kKmiDWB3YsVaXCau9VtkhOiMlDsujUDGK6zhfDCHcTOlj9h893Hu4s2gZ0ztp
	 2Joxy/m/x0HMmLjoOX2RXkKh8FGLYhr/AtJps4RS3EOwuYaVLvzOvI51mVagL18nDgIbx
	 Zln8AljxIr890j7i9unQxeCjoUqDpbIt7xHztZR6HunuavgDvsGgp5NrN8ndNQg9Lfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GK0WO+ZL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A845B606B89A;
	Sat,  7 Nov 2026 15:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GK0WO+ZL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EB71F0089F;
	Sat,  7 Nov 2026 15:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064525;
	bh=wxnBSDXxY8taYYqQKGDItlK0aO8QHKVXaw8ngWuWni4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GK0WO+ZLAdB00YOzp6zuUwyU5AR5G/Hk45o/XtoHYwXaoD7rcriXBVMJaa64nWySo
	 AG0w9ntCi0blI2o9rIJTjxm/gAOIw+JU/bChW7NFuDGZ7nOp+jEeO72cRUIUOoLKij
	 n2EBtEkJFGdOPsLVUYyRbRRa6+za9+P+UWw1l2TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0556/1257] ALSA: hda/hdmi: clamp num_cvts against cvt_nids[] in hdmi_read_pin_conn
Date: Sat,  7 Nov 2026 08:47:32 -0500
Message-ID: <20261107134954.738154112@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 1e7a05c877331..8020178b62960 100644
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



