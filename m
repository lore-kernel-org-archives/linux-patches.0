Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585814;
	b=ypT8OEFM+aDmBa5uaSp9BbJeP31T/8hNz2oPkd3raSwuuWmvYySRdBLzrO3lvHELRVkE
	 5+rCpYxojfGczZX/zGjzRn5hhWXPuhg6G1hvaksXSGo60h55M0a4F0ia+yuscWf9E1Dta
	 JjN8AVPLcKvfPH/rxrphtMf6b4rK4wR9e9J1qtZmpdsseIz6uRhfv36j/4YLhLQP0G6FS
	 +qcpVhVk804Eb8EeAJ9/+1O5CWjFPRu0s90OZHp79HXfaucEmyvg2uUUIYMZswt9+hgef
	 I4dZ9LrO3NTDfdPsAOByTbtSDH95UrZrFEjigXfVtn7903t/RRbGtJvnipFz6JksJGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kWwElwuzDAt4ArVVlF7Lrekz3+Gb24Cr7MiaGAP0SKA=;
	b=qycM6rWODCr/PfvMpA3YG5X+YcHzhmjUeO5EaKCgGMbiQuWtFtDMZM5G3+wjgIheoziD
	 2Ck/znx5AHMwtrHk2bEWQJbXBMrZDqHmb3ECq7ISO65IjA86oXdjz9MDO+FhbysqGKe21
	 717nvqZayGEV0T/C6r3UimtaNwJ7ExSH5dm0ZvPQbpGNRoOXSaVTomHWLoLB+z37ibU5q
	 nnvBDu8cpm/UFvFnlNej/bh/pT1FNnJf01CGdgjdPlwUKRynINzyM43vz0/IsFr1BfCvR
	 aNG7rZpAf45Io2bL5mbtQYVVPQB4G7f+/tBRtZuPAVr2rKtjNy7+sOyZgQM0fQsfNEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x41Jsb3A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7A0606C55A;
	Fri, 13 Nov 2026 16:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x41Jsb3A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBAD1F000C5;
	Fri, 13 Nov 2026 16:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585814;
	bh=kWwElwuzDAt4ArVVlF7Lrekz3+Gb24Cr7MiaGAP0SKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x41Jsb3AWM2UxrTtixPPWm0xciH8O7YASjlAuJVluKuzL+YEEaYyp+D2HcrepgFTm
	 LWBI24EOPHAd6msAqd5WSeNlLRHgxCVXa/yW52FNs7cMJDeNc47WMQsC/7+o28ZMFF
	 u5UP8FRLEzuAyf+iEZl7rNSpv/pTsPeKSFLvDIvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuqiang Sun <izaiahsun@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 396/507] ALSA: usb-audio: qcom: Check the return value of qmi_handle_init()
Date: Fri, 13 Nov 2026 10:51:40 -0500
Message-ID: <20261113153810.170100414@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Yuqiang Sun <izaiahsun@gmail.com>

[ Upstream commit a3cf5ebab5f1db9e6f751e2a08df05a84f37ea57 ]

qc_usb_audio_probe() overwrites the return value of qmi_handle_init()
with that of qmi_add_server() without checking it. When
qmi_handle_init() fails, it has already freed the receive buffer and
destroyed the workqueue, and qmi->sock may hold an error pointer. If
QRTR is not available, qmi_handle_init() returns -EPROBE_DEFER and
qmi->sock is ERR_PTR(-EAFNOSUPPORT), so qmi_add_server() passes it to
kernel_sendmsg():

  BUG: unable to handle page fault for address: ffffffffffffffb7
  RIP: 0010:selinux_socket_sendmsg+0xa0/0x590
  Call Trace:
   security_socket_sendmsg+0x29/0x50
   __sock_sendmsg+0x43/0x150
   kernel_sendmsg+0xd6/0x180
   qmi_send_new_server+0x1b8/0x2b0
   qmi_add_server+0x165/0x200
   qc_usb_audio_probe+0xf4/0x2e0
   really_probe+0x2b4/0x850

Had the probe gone on, the error and remove paths would call
qmi_handle_release() on the half-initialized handle, which destroys the
workqueue and frees the receive buffer a second time.

Return the error from qmi_handle_init(), so that -EPROBE_DEFER defers
the probe, and check qmi_add_server() as well.

The bug was found with kbound, a static analysis prototype for
ownership mismatches at kernel interfaces, on v7.2.12; it is present in
mainline.

Build-tested with x86_64 and arm64 allmodconfig (W=1, sparse): no new
warnings. Run-tested on QEMU (x86_64, KVM) with KASAN and kmemleak, with
the driver built in and a test module that registers the
q6usb.qc-usb-audio-offload auxiliary device. Without QRTR, the probe
crashes as above without this patch; with it the device is deferred and
removing it again reports nothing. With QRTR the probe succeeds, and
removal reports nothing either.

Fixes: 326bbc348298 ("ALSA: usb-audio: qcom: Introduce QC USB SND offloading support")
Cc: stable@vger.kernel.org
Signed-off-by: Yuqiang Sun <izaiahsun@gmail.com>
Link: https://patch.msgid.link/20261102035237.56253-1-izaiahsun@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/qcom/qc_audio_offload.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/usb/qcom/qc_audio_offload.c b/sound/usb/qcom/qc_audio_offload.c
index e4bfd43a2488b..5ee568e0454cb 100644
--- a/sound/usb/qcom/qc_audio_offload.c
+++ b/sound/usb/qcom/qc_audio_offload.c
@@ -1969,8 +1969,13 @@ static int qc_usb_audio_probe(struct auxiliary_device *auxdev,
 			      QMI_UAUDIO_STREAM_REQ_MSG_V01_MAX_MSG_LEN,
 			      &uaudio_svc_ops_options,
 			      &uaudio_stream_req_handlers);
+	if (ret)
+		goto free_qmi_hdl;
+
 	ret = qmi_add_server(svc->uaudio_svc_hdl, UAUDIO_STREAM_SERVICE_ID_V01,
 			     UAUDIO_STREAM_SERVICE_VERS_V01, 0);
+	if (ret)
+		goto release_qmi_hdl;
 
 	uaudio_svc = svc;
 
@@ -1987,7 +1992,9 @@ static int qc_usb_audio_probe(struct auxiliary_device *auxdev,
 
 release_qmi:
 	qc_usb_audio_cleanup_qmi_dev();
+release_qmi_hdl:
 	qmi_handle_release(svc->uaudio_svc_hdl);
+free_qmi_hdl:
 	kfree(svc->uaudio_svc_hdl);
 free_svc:
 	kfree(svc);
-- 
2.53.0



