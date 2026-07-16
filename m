Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095653FE357;
	Thu, 16 Jul 2026 13:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210307; cv=none; b=HAYxRSi6xCfz4rub0p8yHDOIFVJJpW+MFnhvM3u2TlXjvZUqkjwr0OZM9yMBu05yCYcSL2zlglTCbX9UHctswU6S8R9O7UriA8h+szV1mVts/wscucqq0TPRrrTdCtyH7Jn9TZaYt88c/+t1LEtT/r06ppe0ziaOVKbUj4vpcFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210307; c=relaxed/simple;
	bh=lbUrvx98TdN8SwgzF4EdM0mS6s494PhIbr16+SBNa+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sq5PuelBvrRCRUw9fQ+0Trw9wKm2VrPM8IBcCoxh5rkyg5dP/Tg6vMFHEu4l/nd2IaaujhzkQJlpDCtFxKW/pbXmFA86wEKRZhjcbrcMXv1SxYI6DgrR6cuKXJYADgB+abXd94TrXEyi5BbR9ec14SI5xzBvSwgy2arXugkG09I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SB4kFo/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SB4kFo/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7005A1F000E9;
	Thu, 16 Jul 2026 13:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210305;
	bh=EdhGIANJNqArmo0NoPVC5xH/Tp6WuSL7Adixf+G3hVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2SB4kFo//HNlkFYnL2Bm8R0lZ/lcVi+xy46QK5Mzj57dsx0bMU8shhseXbh/4hTbw
	 zwZFFhavCXaUVoqUW5VJEgZUZraLGXBAB0Sz+Bfh4n6ucAIE7OutaqiuWv8ba6aEWF
	 VLA2bB9M0kO/8WRjB45Eu7SyCkKNx8jjbpvGoxpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rong Zhang <i@rong.moe>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.1 516/518] ALSA: doc: usb-audio: Add doc for QUIRK_FLAG_IFB_SILENCE_ON_EMPTY
Date: Thu, 16 Jul 2026 15:33:04 +0200
Message-ID: <20260716133059.129888530@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rong Zhang <i@rong.moe>

commit 06363f96e3d6b54ff7b5d2ce85cab95bd5e874b0 upstream.

QUIRK_FLAG_IFB_SILENCE_ON_EMPTY was introduced into usb-audio before
without appropriate documentation, so add it.

Fixes: a23812004228 ("ALSA: usb-audio: add IFB_SILENCE_ON_EMPTY quirk for Behringer Flow 8")
Signed-off-by: Rong Zhang <i@rong.moe>
Link: https://patch.msgid.link/20260527-uac-quirk-get-cur-vol-v1-1-e9362b712e5e@rong.moe
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/sound/alsa-configuration.rst |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/Documentation/sound/alsa-configuration.rst
+++ b/Documentation/sound/alsa-configuration.rst
@@ -2383,6 +2383,12 @@ quirk_flags
           ``V(x) = k * x``; ``dB(x) = 20 * log10(x)``. Overrides bit 24
         * bit 28: ``mixer_capture_linear_vol``
           Similar to bit 27 but for capture streams. Overrides bit 25
+        * bit 29: ``ifb_silence_on_empty``
+          In implicit feedback mode, when an entire capture URB returns with
+          all iso_frame_desc[i].status != 0 (bytes==0), do not silently return
+          from snd_usb_handle_sync_urb. Instead fall through and enqueue a
+          packet_info containing only size-0 packets, so the OUT ring keeps
+          moving (emits silence). Needed by Behringer Flow 8 (1397:050c).
 
 This module supports multiple devices, autoprobe and hotplugging.
 


