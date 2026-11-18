Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038469;
	b=bZE8MhSjAord56yysqU8P2t1JK+YIP1rYKtod4e1IiFIypBi+CkCPUpVL/C4BgltWEWy
	 Wyn2/Zr36QDx7L1wHTUPQNAXwZpG+6jASZgxnLmjDTXC6wuUTktumW5+nkiQTcbu8cS8j
	 xj8ICu5o+u18zVPxM4Z9ylMC4mm2odFyBw8Gy4RKKNkoumlxoTeFLz4IPZQ1/oGoaacdM
	 0JuRxnwYOW6FGETMqjbzS3fC76UXoXhdRxk8YaFh9ibTYCt4WlrO3Tkupot5hCoVJUpZ0
	 7ZaPbCfonJbMXWjkhr4cWV5CxyFo+6s8M/znjis80SsIs87F6wsPjl9YvxDQKExMVPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Mqg+kDmUfwMKih9EVy2q4fvULXsgHaVEx5byLsyf/xU=;
	b=5sTQAgMsxGIMPzUpWQyzTs6C9SjaDUZnKA3iTd44QhwkpNCZ1QMhgIMwXWEPMDtsnY5Y
	 /ZoqmVWXLDyPlfykWtcByQ/GohsyIylif7OKtqbKo7oVdavempQ659fV+acQA1dy2BwL2
	 VDIApIDpGMrlpNA5wARrOmcpxKI+rq3EldZcQcx9nUM6dUBHBtKQdpXHgosLqjVUINe19
	 ej2DLcE2d7MWyz90OAMwUKIHSGFI09A5MRim3G68VP5YonU5+Twy3RrRcdeVTm1xc/Ft/
	 NMpa7Q6bHQYOHjrTbNGh2piTEM4a3MIoLc23Q7MY1bI6t492DwAJoa53G/zKlcJQYYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DPU4ifpM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30D3606A320;
	Wed, 18 Nov 2026 21:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DPU4ifpM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC6A1F000C8;
	Wed, 18 Nov 2026 21:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038469;
	bh=Mqg+kDmUfwMKih9EVy2q4fvULXsgHaVEx5byLsyf/xU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DPU4ifpM8Tc4oaf7YjP9XGW8z7lkf5qXzCCqGqKRs+1aifXI5N0hd5dI8kNpW8YBd
	 5HXFytASxkIOJ/hUKk6ubaBvdM/EGc5GU0+qt3UVT1v+o+tFQ56a0ls9+ufTAC0Ogr
	 Ii6iD3WTxyVC+qua2dSTRdnVaY91BRUDeULgyMJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1755/3318] ALSA: hda/hdmi: clamp num_cvts against cvt_nids[] in hdmi_read_pin_conn
Date: Wed, 18 Nov 2026 15:39:37 +0100
Message-ID: <20261118150414.507406611@linuxfoundation.org>
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
[ sashal: adapted the patch to the older HDMI driver source layout ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_hdmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_hdmi.c b/sound/pci/hda/patch_hdmi.c
index c2b00b6768ac5..7900cdca0a096 100644
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



