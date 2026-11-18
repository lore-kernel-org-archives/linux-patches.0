Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047040;
	b=i0LXg4oEj9WDgxB09+4yOo2p5ibgr1r18nfsU/E6fC6ONPx9VS0Muz7lN9gIMXVrMet/
	 jvZUOFfjSEp7l1SDgOhKhryqpP2PED+h+FgMfE7tX2OqNTCsoy4b98/4I9sSTMuyXTQNa
	 a71NgINYPifONSh8/fUQ36akaZ92Xpc0VBffLN02l8nn8wfTLNuijMprngNzpiVdo5Gen
	 wpXB2kDSHTrCf4gf0Vtc9r7N5wi7xQKC9vrnTGinoqt0Qzs0Nk473CV5PazLbulKYy3Ou
	 nRjV6c+oujPpJWKH8J/WN5ns/p3/Y2CEGWGr1YrEz96PnR+hiIdGriUe5eSt4PgSrTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/G3ono5uOufR7X7i0im4LI6G2Yqf3lSa0KddFq9NBKk=;
	b=jeV2qJrQO8AF3qm+f23Jf7dOA+yBrGza9RR6Easlv4BL4d+qYsNEBEFBkLoLomqirfYB
	 yCQOhwovHAoCMBV5yvkBEehILwXUOyf3H3UHfy4MAzugKOxap7ZPzmMd9IOnvGzmBzQFv
	 9AhuqMZtWyY5MkgdeLsRlWW/QGhH4/f7C7HGECyJdGGTvU2GXbKwa1M5eV+bivgfd57za
	 W6DfwPXyxYbMnMQjj74a1efX9o1mi5k0IGvSboqignm9ogsnymo8iwPr3BgVVzCQpxtjU
	 7ONDXcPLKe0q9wEdwgcDrGJRfYBLZULsREBmrQr2jUPYTbA2jjokwDyVo04oP4e4E6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OCY5ZvTx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E162606A32F;
	Thu, 19 Nov 2026 00:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OCY5ZvTx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23C41F000C4;
	Thu, 19 Nov 2026 00:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047040;
	bh=/G3ono5uOufR7X7i0im4LI6G2Yqf3lSa0KddFq9NBKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OCY5ZvTxFfcCSpdJi3Xk/DIA+AbwqXEWi7BQZPL3RDfXHKDrINdgN39gUCv6MERvR
	 Eik1Za6u78xQchWHzbis/woUkierlJnk/1Wgn48TVinfE8w2uSU1OZLku5gYfCTduV
	 acox/LIar5fth159Xzc/j2riizig/CNuFHTkEGnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1495/2857] ALSA: hda/hdmi: clamp num_cvts against cvt_nids[] in hdmi_read_pin_conn
Date: Wed, 18 Nov 2026 15:42:09 +0100
Message-ID: <20261118150255.154643191@linuxfoundation.org>
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
[ sashal: adapted the patch to the older HDMI codec source layout ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index 83ba6dfd28c3b..4948a1bf8c0ec 100644
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



