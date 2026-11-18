Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043752;
	b=mUNR9vOWiEeF38+dBcGRf8dgwxsxnxdEqYESykoiMTvz5fYeMvEiYH/X6wb6kKSzQi7u
	 af4j4LFCgqjeFXgQTDjsoQFJkVDMOqeN1U5t2GtEQaZkYjM0X8FdgQl0xhvRwYIBYwYaw
	 nYesWy2kGq85ZfSlp2Me0f8r8QzTl1LZpLpEfiPu8apdh0ZkaYW9PnhcqBVL4vdpJam2Z
	 3znxuZsmHyBiC0NjsTdlrHg3mseBc/ogfrguZIlUgInqf2HNrNANxkpoWeTqNSvU/17mB
	 9fkfo94A5BNRFEdYcNX67GYMp5rvJY8zvcF8wpOrulZYUScBEvKTv+5tV1RBePTkbWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3m68IOnKU8z6Oshzla3r53HGsfb0UHAuVD1mh7EQirI=;
	b=1Lnl8rObfySJtW7krNWMUiLcSod7gFzIbgRtZw8eUvMS5sMlEw5o+eQL+4H9Ne6ot6M7
	 gOFPo2wvm5jkL69S7ibzOUaI6srqBbepUB6FXxR1vJWBUfmAjC3IhUNs6Yicg1ArlhrC3
	 GHevn+O4Dq3ClSKRL+hoCPmQllcVg8EbIwlVhx+My9mvqv02zrKZ28LmNSQ2wUufVuYQy
	 qIDHo4t2RRogy3Eu6qdNNAkaQ4BqLaOdpcZuRnNIW3ig0cYP259UDXWwXr8Sf1VE2N8fN
	 mwBEpe6Z7oz+5Fs1P6ju+a2ynEkiih/8KyjtR5PQDn9R6ntJp4lYzuO2TT5MHr8FQvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tqB+2qwX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066A0606A325;
	Wed, 18 Nov 2026 23:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tqB+2qwX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FB901F000C4;
	Wed, 18 Nov 2026 23:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043751;
	bh=3m68IOnKU8z6Oshzla3r53HGsfb0UHAuVD1mh7EQirI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tqB+2qwXw2YNzs3L7Io/IGoG+ePgiCpchPYIO0J49KEW5y/xaWSYxvn6p1fFZ7zPa
	 Qs6n0xFu3XgruJCVG/4jUSciZX2N5gGQaA44lVf4CP+H87mC7xv3vUzGhzcogl1mkk
	 o3kLoVMwDQY4aavff1IWn2ekX3VGq2+gcRLBbnUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Song <songxiebing@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0281/2857] ALSA: hda/conexant: Always enable the headset-mic pin on plugin
Date: Wed, 18 Nov 2026 15:21:55 +0100
Message-ID: <20261118150211.544475620@linuxfoundation.org>
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

From: Bob Song <songxiebing@kylinos.cn>

[ Upstream commit 9642a5e843758686e02a7f0d1df9eb0f7f96603c ]

Rename the function to cx_process_headset_detect_plug_type() to reflect
that it only reports the detected plug type, and move the pin control
write into cx_update_headset_mic_vref() so that node 0x19 is always set
to enable the headset mic with the 80% VREF whenever the mic is
present, regardless of the type detection result.

Signed-off-by: Bob Song <songxiebing@kylinos.cn>
Link: https://patch.msgid.link/20260826115344.2128835-1-songxiebing@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_conexant.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index f631dc0650e4d..45abed135d3f3 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -213,7 +213,7 @@ static void cx_auto_free(struct hda_codec *codec)
 	snd_hda_gen_free(codec);
 }
 
-static void cx_process_headset_plugin(struct hda_codec *codec)
+static void cx_process_headset_detect_plug_type(struct hda_codec *codec)
 {
 	unsigned int val;
 	unsigned int count = 0;
@@ -249,10 +249,12 @@ static void cx_update_headset_mic_vref(struct hda_codec *codec, struct hda_jack_
 	 * Check hp&mic tag to process headset plugin & plugout.
 	 */
 	mic_present = snd_hda_codec_read(codec, 0x19, 0, AC_VERB_GET_PIN_SENSE, 0x0);
-	if (!(mic_present & AC_PINSENSE_PRESENCE)) /* mic plugout */
+	if (!(mic_present & AC_PINSENSE_PRESENCE)) { /* mic plugout */
 		snd_hda_codec_write(codec, 0x19, 0, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x20);
-	else
-		cx_process_headset_plugin(codec);
+	} else {
+		cx_process_headset_detect_plug_type(codec);
+		snd_hda_codec_write(codec, 0x19, 0, AC_VERB_SET_PIN_WIDGET_CONTROL, 0x24);
+	}
 }
 
 #ifdef CONFIG_PM
-- 
2.53.0



