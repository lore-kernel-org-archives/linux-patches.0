Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618906;
	b=1I60WKqi8dAzWy+Yfg/YzhjACjdPh12dpZu2zqjnbTrXQKHy5MI8hLerpnve63qPFwZX
	 1ffMTDrRddSfFXiSsBbrDvik5vzOJXJ07uPhEpMMM7mF6Z+180Ns8lchMkVEHUT6B4t2P
	 ipxkA3kzDue2Qow8Ez1FkvER7tt0pgS1oqvF9MtOzxl7vfyb6yOitH0EMgNjLOICV5crU
	 i51aZWWPflFkOibSM0Ud+FyzZ+VYX8BnXGWIdvHgicnfAeAE7wYkKyfBAi6YmNja1JHBg
	 PkxwpxcG9wu8azZFFEnDX1/q2TMezAPiavBdhJgIECiwujJ9+tkJvV1Vv0fW8Ghf0Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=igsNaDvVY7y4iHWYovUo5POwKX+bmzsCz1Y/gRGaESo=;
	b=2H0GC8ppPzCL/ubwK8pd2Zmidak6p0BWLRn1QMG+zRoHnFPL4fUkRivZMDVuhMvvOd5h
	 f2orGvhOUc2xkhMhzt/T/MG8K2fErFbcwF0HZwPHDIsc7INhaBgiHqr6quR1lFn7GOvDG
	 VHUNNTjVTVWt34RmThWQfvDtOEz5dAWVMK0tCkBBL/qJcPR6Wt0z4simqnAhE70ItymWV
	 RiYnBsgmqUV6Eog+Yy1LjYLD9pZyS7ZsDuPP7ttF+335e7FyHs/yxCu6PES/lpBL6sktA
	 5faAil5kFO7ZjcwUrYOL9ufa4swrMr4NTtEIIN3lolqqxMokASR7Ut0eHmE/aj3XmMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZjbDo/AS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3744E606A330;
	Wed, 25 Nov 2026 15:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZjbDo/AS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721881F000CA;
	Wed, 25 Nov 2026 15:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618906;
	bh=igsNaDvVY7y4iHWYovUo5POwKX+bmzsCz1Y/gRGaESo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZjbDo/ASED7dTEckFo7eM8A4mRObtI5X30P3XIDvphjTYtphkk5U8iSn5WneeHnZ/
	 2yLWw1oOQqSp6XIp/ka4/oP5Fl9pxQoRTvRqx5vtjVMPvWbyiOefkyi0iN7VbKHvby
	 ftJ3/3vl29n7eGcyWILUUyTEXrdnExesVWY9pmJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zachary Huang <zuzhenhuang365@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0426/1005] ASoC: es9356: fix the capture gain dB scale
Date: Wed, 25 Nov 2026 15:29:24 +0100
Message-ID: <20261125143831.732819771@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Zachary Huang <zuzhenhuang365@gmail.com>

[ Upstream commit 412a061ebf8ce0d4d49fc7352dba8d641257b3a6 ]

The two capture gain controls are declared with a TLV step of 3 (FU33,
analog mic) and 6 (FU11, DMIC).  The TLV step is expressed in 0.01 dB
units, so this advertises 0.03 dB and 0.06 dB per step: with a value
range of 0..10 and 0..3 the whole controls appear to span only 0.30 dB
and 0.18 dB.

The hardware steps are 3 dB and 6 dB, i.e. 0..30 dB and 0..18 dB.
Measured on a MECHREVO WUJIE 14SAH (ES9356 on SoundWire link 0) by
recording the same signal at all four FU11 settings:

    FU11=0   rms  523  (-35.9 dBFS)
    FU11=1   rms 1007  (-30.3 dBFS)
    FU11=2   rms 2011  (-24.2 dBFS)
    FU11=3   rms 3794  (-18.7 dBFS)

That is about +6 dB per step, matching the hardware definition rather
than the advertised 0.06 dB.

Because userspace (alsamixer, PipeWire/WirePlumber) derives the volume
from this TLV, the capture gain currently looks like a control without
any usable range, which is also why the default setting seems impossible
to raise from the desktop.

Fixes: 5d9cb740cd38 ("ASoC: es9356-sdca: Add ES9356 SDCA driver")
Assisted-by: LLM
Signed-off-by: Zachary Huang <zuzhenhuang365@gmail.com>
Link: https://patch.msgid.link/179398129782.44051.2897523393297405157@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/es9356.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/es9356.c b/sound/soc/codecs/es9356.c
index 80db0f2f4aef6..02c0c34c04546 100644
--- a/sound/soc/codecs/es9356.c
+++ b/sound/soc/codecs/es9356.c
@@ -59,8 +59,8 @@ static int es9356_sdw_component_probe(struct snd_soc_component *component)
 }
 
 static const DECLARE_TLV_DB_SCALE(out_vol_tlv, -9600, 12, 0);
-static const DECLARE_TLV_DB_SCALE(amic_gain_tlv, 0, 3, 0);
-static const DECLARE_TLV_DB_SCALE(dmic_gain_tlv, 0, 6, 0);
+static const DECLARE_TLV_DB_SCALE(amic_gain_tlv, 0, 300, 0);
+static const DECLARE_TLV_DB_SCALE(dmic_gain_tlv, 0, 600, 0);
 
 static const struct snd_kcontrol_new es9356_sdca_controls[] = {
 	SDCA_SINGLE_Q78_TLV("FU41 Left Playback Volume",
-- 
2.53.0



