Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E7C153510;
	Tue, 20 Feb 2024 21:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463708; cv=none; b=Z1/jRD2EJc4Vp/IoI7TmlKtE6uFCDSN3n0LtVxP96Ld/FTRLFwjG87Ywyog8DQD4NBJCeZF8/z3lkeeaSW7LYyioCDqKBReL6Fd2i8WTqifYY2DKdVxntJWe5JGq+gbvyd6J34xBwVSqJk/UslYmF2tR7qkk2dkJgBnO4xa1gMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463708; c=relaxed/simple;
	bh=8C7SgYSEs0/sB7IqTOGGT5lB2XgbA93Y+t5gOniqPlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M6vBtDWoCa9dQF9pXs1xli200ZANFBZO/x3zaS8E3cZuu43AB+GqhMo+WCwqYOGT167rjz9JaPkKY9q9tAsq3cBZDX+WHXSWXKVTUPMJJKEEhtCBo6LjU2B6sKKeNAgh0qjBjsQoNZv1sQgFgygMs1SdnGzeDVK/55vlYOYDEmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D93JH1Yo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D93JH1Yo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0A2C433C7;
	Tue, 20 Feb 2024 21:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463707;
	bh=8C7SgYSEs0/sB7IqTOGGT5lB2XgbA93Y+t5gOniqPlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D93JH1Yos3KHBoTLD6I2em1zbs96ZLTh3x2kjQ5ABKriFOnTsqzrE+XtVQc0XqsYf
	 7kpdWy4XEnB9hmf6phZ3lZ7cvBRwP7KQQ06aMa8/qkQpHPWJhp+oNEU6/XNr7BClTv
	 sBGD+FeK/rDCWTFSwVhI8QN3ba/g0jBzVoolBmd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jos=C3=A9=20Relvas?= <josemonsantorelvas@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 128/331] ALSA: hda/realtek: Apply headset jack quirk for non-bass alc287 thinkpads
Date: Tue, 20 Feb 2024 21:54:04 +0100
Message-ID: <20240220205641.609554843@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José Relvas <josemonsantorelvas@gmail.com>

commit 2468e8922d2f6da81a6192b73023eff67e3fefdd upstream.

There currently exists two thinkpad headset jack fixups:
ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK
ALC285_FIXUP_THINKPAD_HEADSET_JACK

The latter is applied to alc285 and alc287 thinkpads which contain
bass speakers.
However, the former was only being applied to alc285 thinkpads,
leaving non-bass alc287 thinkpads with no headset button controls.
This patch fixes that by adding ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK
to the alc287 chains, allowing the detection of headset buttons.

Signed-off-by: José Relvas <josemonsantorelvas@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240131113407.34698-3-josemonsantorelvas@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9479,7 +9479,7 @@ static const struct hda_fixup alc269_fix
 		.type = HDA_FIXUP_FUNC,
 		.v.func = cs35l41_fixup_i2c_two,
 		.chained = true,
-		.chain_id = ALC269_FIXUP_THINKPAD_ACPI,
+		.chain_id = ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK,
 	},
 	[ALC287_FIXUP_TAS2781_I2C] = {
 		.type = HDA_FIXUP_FUNC,
@@ -9500,6 +9500,8 @@ static const struct hda_fixup alc269_fix
 	[ALC287_FIXUP_THINKPAD_I2S_SPK] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc287_fixup_bind_dacs,
+		.chained = true,
+		.chain_id = ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK,
 	},
 	[ALC287_FIXUP_MG_RTKC_CSAMP_CS35L41_I2C_THINKPAD] = {
 		.type = HDA_FIXUP_FUNC,


