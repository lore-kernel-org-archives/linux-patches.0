Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022581;
	b=2gjio6VJSTZUQS4qVneTSzLGCsZMHHA7/Ss3tX6upIXYHwOZZlTl7FHuJBFJ4EKvCU+F
	 MQEH4c1eSgwGAioLhj1xk3SddJ66higzPXzqYhfQlf+CnR7IFnxPg8xzZywgmw0lq0u9g
	 b+NOfeLAyykS3calGQ8ca59v72J/e52l+UhAPWYw17jhnZf8DsLLk7GOK1HZPrUzDLkls
	 Ptk27n7Fp2PACsG9T3JxXlqz3eb3CjzDnmx4yUF/RiEFEsi3oR8f+BKuiXXPz8oGoX7s3
	 d8zy8oRwUZjgizbWlXOuIU28ZMHW/frNvQj2lTMcdQQJFmk8wv9iRnE6uyjhDhj7ivQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kdSX144JpuOYxe2YlQVIxkPwNUWzZf3FYegDEx2fZx4=;
	b=RVw9TwgpqlQmXz5jtRXjAeKIKU0DRmkGjZvu3s86GKdb4GOtpKrNJC7t0pGVZTq3dl2Z
	 UWlSTD/3RxeICjQoOuYy0WMJ86dTuATEKQB7X8O5+hLElpYAqyJCaVcL/iiZ61okMFdhl
	 p2HX3lJp0midO0Raid1O6oxjmCnw98Rkg7AIJwlXqQBZUHD2J82POxcQy/1HNRe9Ip8HV
	 NdvSqcNFnSrNCsIdeMqGBtxZoNbq3peLvum3LlScLbBXft8Tsa1Y/P/88P84cEZ3RVdMy
	 m1ONOg5+zdoTIFlc04MQv4YEtc5p+ifRaa+e/M+JVgIsnye1UkQp8NkKgmQiVKr66TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yqjFnioC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58147606A32A;
	Wed, 18 Nov 2026 17:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yqjFnioC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFED91F000C4;
	Wed, 18 Nov 2026 17:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022581;
	bh=kdSX144JpuOYxe2YlQVIxkPwNUWzZf3FYegDEx2fZx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yqjFnioCR9mdF+OiqQmwkxkpufC9Vj7/WvKMmsvSnCWwUNZ+LoP1yUWwp856JcUDN
	 +oEOWaAhHYJKDKOH4cwfI7OdkO3REyUk6ajakLmtzCJO6hk3T1JiprPGTfIaUrP6wr
	 ZN26hfUEfPONVA8DPTfJtOMXs1ijDvldl8Lrou1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuqiang Sun <izaiahsun@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0065/2151] ALSA: usb-audio: qcom: Check the return value of qmi_handle_init()
Date: Wed, 18 Nov 2026 15:30:00 +0100
Message-ID: <20261118150124.128256554@linuxfoundation.org>
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
index 62a57b8d171b8..3a0a0d8f4654b 100644
--- a/sound/usb/qcom/qc_audio_offload.c
+++ b/sound/usb/qcom/qc_audio_offload.c
@@ -1975,8 +1975,13 @@ static int qc_usb_audio_probe(struct auxiliary_device *auxdev,
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
 
@@ -1993,7 +1998,9 @@ static int qc_usb_audio_probe(struct auxiliary_device *auxdev,
 
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



