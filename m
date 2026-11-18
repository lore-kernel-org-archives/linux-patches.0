Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022578;
	b=j2viRnvK/XMUMVddSRlzzA7ybq27+KQ2nstkSXm5gUyBgbDjI7oapFm+AXIz0+jt4dAP
	 4Jui5jjdGYzLrSua4hb+4nXg+k+TvXk0cufU7/xFF00J4hoRRh+5Sq4UfkSoKyveSO3kf
	 A04acH0lVOd4LlLcMShb3AVwDIbA2HEVENlzkghJGWG2Mn0NCYrYlB/OZvvHzmAzSRU1D
	 dATGwUryYMnB9iourlnQEXZQm6x6kIt7FU3QU4Npb9XPaiVDKKbZC0W+cQMx2q+ZGOdel
	 8aIPOdz2JUkgpZcGzuq/7NLtFJTdLyWh83wgYzsYZ6eB45Y8dWl77tAAPCaaxaNYAyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cm1UuFJnNfz2O9BEpZyTeCiT2wMCvQEVyGawLjFFYMw=;
	b=Wp3C6DPzaGX89fAbBzQ82kQ0GLqL7XtahJ11GvQKaIBK4/46Z/5LwCahQYfMYNK9wu2n
	 ZxIOh7DH2gXvdi/NfArBCWU/kAXOoVzTzlUBuiQc6gd+gB+mRDd7IcMSKPQfy5d1uKyjN
	 07FVoII16Ywet9k34He2XMK18LvCacDRAZunJ1Loli8MDJJbxX6QOzL4JJmEC+P9lYk/2
	 fW6Ef6PZunS6LhIE52NwbiFKFfrHH3Vp/Gpro4c811U3WZ+xrxCJCwrtEEbm14W65vYvA
	 bg+zj/G9dAkTo8WveVNOeKjeWQpUDJBWyJf7i1Cgoeu5Fvs6paFutG3IWmCAxpA15zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HuSoyTbb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98040606A330;
	Wed, 18 Nov 2026 17:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HuSoyTbb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E141F000C4;
	Wed, 18 Nov 2026 17:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022578;
	bh=Cm1UuFJnNfz2O9BEpZyTeCiT2wMCvQEVyGawLjFFYMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HuSoyTbbZW0t7Co8xtsNkA06RDjiF+RUszQpCRyJyJEkd78UEz0rJA5+Me+lvMUtc
	 9f/+3l1j4R0Nt4M+jkvZfABnwSkUv1HE3fJXwwr9qF57LSEzVr/eoldZyBSnEXwNRx
	 AC79aWEJVzTSQd3vSd9Q60Nh+z8EFMSGiX7HFsqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Rao <raoxu@uniontech.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0064/2151] ALSA: usb-audio: qcom: Free QMI handle
Date: Wed, 18 Nov 2026 15:29:59 +0100
Message-ID: <20261118150124.090965623@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Xu Rao <raoxu@uniontech.com>

[ Upstream commit b8ff1f3578f83dedf5feb796d97a3f67c1bea58f ]

qc_usb_audio_probe() allocates svc->uaudio_svc_hdl separately from the
uaudio_qmi_svc object.

qmi_handle_release() releases the resources owned by an initialized QMI
handle, but does not free the memory containing the struct qmi_handle
itself. The probe error path and the remove path currently release the
handle and then free svc, losing the last pointer to the separately
allocated handle.

This leaks one struct qmi_handle on each affected probe unwind and on
each successful probe/remove cycle.

Free the handle after qmi_handle_release() in both paths.

Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/9108EC860F3F87DF+20260623071308.2549182-1-raoxu@uniontech.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: a3cf5ebab5f1 ("ALSA: usb-audio: qcom: Check the return value of qmi_handle_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/qcom/qc_audio_offload.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/qcom/qc_audio_offload.c b/sound/usb/qcom/qc_audio_offload.c
index da2759f2ee866..62a57b8d171b8 100644
--- a/sound/usb/qcom/qc_audio_offload.c
+++ b/sound/usb/qcom/qc_audio_offload.c
@@ -1994,6 +1994,7 @@ static int qc_usb_audio_probe(struct auxiliary_device *auxdev,
 release_qmi:
 	qc_usb_audio_cleanup_qmi_dev();
 	qmi_handle_release(svc->uaudio_svc_hdl);
+	kfree(svc->uaudio_svc_hdl);
 free_svc:
 	kfree(svc);
 
@@ -2018,6 +2019,7 @@ static void qc_usb_audio_remove(struct auxiliary_device *auxdev)
 	qc_usb_audio_cleanup_qmi_dev();
 
 	qmi_handle_release(svc->uaudio_svc_hdl);
+	kfree(svc->uaudio_svc_hdl);
 	kfree(svc);
 	uaudio_svc = NULL;
 }
-- 
2.53.0



