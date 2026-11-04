Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829287;
	b=QJUds2BteFklp//UB9uUJGLWvBbpSuLfHPC3x3AAe6hA9FgPrR4XZASOrucUGads/+jj
	 J04v7upPmVMf55gftxY2opf2GkgWGyQ6ItxPY6n+k8TCJGK0ZVT1NeyAanJjs2DuARi9A
	 1SEQL41IjeUBCT9IcbsWjAqHHsfAtY/O2BiPh8AYqS/Yh/b2vlFEdpT0TOVsB+UJzhX78
	 orE5uqOFJuyrdbfiWV2j4nRvaZGv1NNBS+c3mge6N/f+bSY/JYLEUfHDBTJVFcxIlMjNu
	 bnVW95bcr4siRcERX+x84IuqGDqjfUXRGg9ErUizh2nDVKl1tvIMmBPL8UAWoDCkl1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mWdMP15/+lrEkhAzlpJXiAuZxv2s5kALBgGJilsbbhM=;
	b=m/wUXJP8DDmGKWktSCBmvb3ENyd3tKmMuoxv6kWMUtPKQGKY6XC+38hY6NNpJnZQu91H
	 FdBw7NCxaSBWG5dayRe1g9cwH5ADezVFEkobRwLHeGHYfzUyvyLVIedbAWFESRpcZH1p3
	 XuFvhXh0OY8OJYLeIUnTuRzUDSPhVp/vXB6eedCwFAJSsmvIVRnThMA4USSZUoeAHDTc8
	 4nDdiIJusvvBg6uZEQELVYUtD9FIeG5rvn+WKboIJ+YNrcSu9d67e5PDLwsBrkeUmtQdp
	 Y6YyuyCCasnrdq/hCGMYVAAJbZLQDTrbFgys5/qW3cuoRmVGSXbqImRMf8B9qO2eVfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="huhgS/XB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A606607353F;
	Wed,  4 Nov 2026 21:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=huhgS/XB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0916F1F0093A;
	Wed,  4 Nov 2026 21:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829287;
	bh=mWdMP15/+lrEkhAzlpJXiAuZxv2s5kALBgGJilsbbhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=huhgS/XB3lA78V4ifj5DCJfayiVjfgvjtvbfP+Z5WA/IUNhq+iUTXYxiyHSl/CMNL
	 qNQsQbTsfZ1RnuTCWGDgCDG5olM8sIhI66xkCaWTVvpbuoJ1gyMCVBJNV0jhJ8WLjV
	 PmW/EyZZMaWypn5Kkn96g96RrJlaTXmmoeavcxIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0030/1005] ALSA: hda: Force resume if acomp notified during system suspend
Date: Wed,  4 Nov 2026 15:56:03 -0500
Message-ID: <20261104211044.404546917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit c0933934d5d96fc641e8d0025f9099e554a7b47a ]

Currently if an HDMI cable is connected while the system is suspended,
the HDMI audio jack status stays off after resume.

This is due to the jack state not being synced by the HDA HDMI codec
device's runtime resume, as that never happens if the device was runtime
suspended before the system suspended, or by the acomp notification
triggered from the DRM side if that happens before the HDA HDMI codec
device has resumed.

To fix this, if snd_hda_hdmi_acomp_pin_eld_notify() gets called before
the HDA HDMI codec device has resumed, mark it to be forcefully runtime
resumed at the next PM complete time.

Do this using a separate acomp_requested_resume flag that can be
temporarily set without overwriting forced_resume for drivers that
always want to force resume.

Assisted-by: Copilot:claude-sonnet-4.6
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://patch.msgid.link/20260626-hda-force-resume-eld-notify-v1-1-a92cb01393e0@collabora.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/hda_codec.h    | 1 +
 sound/hda/codecs/hdmi/hdmi.c | 4 +++-
 sound/hda/common/codec.c     | 5 ++++-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/sound/hda_codec.h b/include/sound/hda_codec.h
index 3c9e64dc02524..b801943f0667f 100644
--- a/include/sound/hda_codec.h
+++ b/include/sound/hda_codec.h
@@ -257,6 +257,7 @@ struct hda_codec {
 	unsigned int link_down_at_suspend:1; /* link down at runtime suspend */
 	unsigned int relaxed_resume:1;	/* don't resume forcibly for jack */
 	unsigned int forced_resume:1; /* forced resume for jack */
+	unsigned int acomp_requested_resume:1; /* resume requested by acomp */
 	unsigned int no_stream_clean_at_suspend:1; /* do not clean streams at suspend */
 	unsigned int ctl_dev_id:1; /* old control element id build behaviour */
 	unsigned int eld_jack_detect:1;	/* Machine jack-detection by ELD */
diff --git a/sound/hda/codecs/hdmi/hdmi.c b/sound/hda/codecs/hdmi/hdmi.c
index f427d04176e92..42e4dc0949ec9 100644
--- a/sound/hda/codecs/hdmi/hdmi.c
+++ b/sound/hda/codecs/hdmi/hdmi.c
@@ -2236,8 +2236,10 @@ void snd_hda_hdmi_acomp_pin_eld_notify(void *audio_ptr, int port, int dev_id)
 	/* skip notification during system suspend (but not in runtime PM);
 	 * the state will be updated at resume
 	 */
-	if (codec->core.dev.power.power_state.event == PM_EVENT_SUSPEND)
+	if (codec->core.dev.power.power_state.event == PM_EVENT_SUSPEND) {
+		codec->acomp_requested_resume = 1;
 		return;
+	}
 
 	snd_hda_hdmi_check_presence_and_report(codec, pin_nid, dev_id);
 }
diff --git a/sound/hda/common/codec.c b/sound/hda/common/codec.c
index 164906e2f00f4..8cab932177194 100644
--- a/sound/hda/common/codec.c
+++ b/sound/hda/common/codec.c
@@ -2949,8 +2949,11 @@ static void hda_codec_pm_complete(struct device *dev)
 		dev->power.power_state = PMSG_RESUME;
 
 	if (pm_runtime_suspended(dev) && (codec->jackpoll_interval ||
-	    hda_codec_need_resume(codec) || codec->forced_resume))
+	    hda_codec_need_resume(codec) || codec->forced_resume ||
+	    codec->acomp_requested_resume)) {
+		codec->acomp_requested_resume = 0;
 		pm_request_resume(dev);
+	}
 }
 
 static int hda_codec_pm_suspend(struct device *dev)
-- 
2.53.0



