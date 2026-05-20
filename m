Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A613368968;
	Wed, 20 May 2026 18:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302186; cv=none; b=gaEPEo685lufXRaWNexhsZC3/+4fVAmEHV55CzFmqiQDFpdl/ClW/4E9kTtWzNvVPAumozaioO5sGlkyLC3AqdDzjd4dVWlEYAFCvtU8mrwsXYP203P7Rn4eo86TUKjEPloEqjEsZatD7XHAzQhWV6N8xpsUlCCGCVe/lrSoC3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302186; c=relaxed/simple;
	bh=YUwHsz8ZgdY6QNAxwtobzmW9g6POU2FwElgXFc2t4eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvkKUOSEr+IN0D0qJQe04CZNJf654TquksPoBR22upYK72WVTm8b7fays4ANX7FGkMTIcFIPRbzJzZq5URONJMSmR1REIGehHohoArlEM0zixefCrJ0NaVn1C3WQIjTKu8FOuci+eF4xi606d7NYe/E5t6U8E8dF1HDH2sUKyzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OdWPk7me; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OdWPk7me"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF98D1F00893;
	Wed, 20 May 2026 18:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302185;
	bh=WvQkDc4dwD1eP2isKF2qX0TkfDASQ8VKCrtm5t4eSs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OdWPk7meE6nSkEZVFMHtQlpKOoZUe70Rs2NTSAE1tRyh8VeI9CwW06n5LZms3FJ1D
	 RhmvhtLvioHP66mPPiCxTLMetwhHkcM8VVAvRA0zKTwM3wKULh7N6iTYE5+q2M1RDw
	 guz75KdGjzNx3Uber+ywkIYp4tE+4Hf9oF1oe7I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Huang <huanglei@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/508] ALSA: hda/realtek: fix code style (ERROR: else should follow close brace })
Date: Wed, 20 May 2026 18:19:12 +0200
Message-ID: <20260520162101.423264713@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lei Huang <huanglei@kylinos.cn>

[ Upstream commit d1888bf848ade6a9e71c7ba516fd215aa1bd8d65 ]

Fix checkpatch code style errors:

  ERROR: else should follow close brace '}'
  #2300: FILE: sound/hda/codecs/realtek/alc269.c:2300:
  +       }
  +       else

Fixes: 31278997add6 ("ALSA: hda/realtek - Add headset quirk for Dell DT")
Signed-off-by: Lei Huang <huanglei@kylinos.cn>
Link: https://patch.msgid.link/20260331075405.78148-1-huanglei814@163.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 6ef859f59f8d1..937f3fdbab252 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6043,9 +6043,9 @@ static void alc_fixup_headset_mode_alc255_no_hp_mic(struct hda_codec *codec,
 		struct alc_spec *spec = codec->spec;
 		spec->parse_flags |= HDA_PINCFG_HEADSET_MIC;
 		alc255_set_default_jack_type(codec);
-	}
-	else
+	} else {
 		alc_fixup_headset_mode(codec, fix, action);
+	}
 }
 
 static void alc288_update_headset_jack_cb(struct hda_codec *codec,
-- 
2.53.0



