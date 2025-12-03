Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260D83570CC;
	Wed,  3 Dec 2025 16:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779139; cv=none; b=eS9GAgkeC1i6K5HP1UDzGTSiVZVXAnVXCWUs8IykpjVvb0kV1dL99j5fW2hRoJjhQTPBTEaoyEhUat2jHExj1ZpKcnpRg87MBS2Fn51GiisC8lMTQYAKaxwuJDm+gnfBbysUINklWxcPP4sMUIQCkNI07QBYPvM5e4O2s7iVe6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779139; c=relaxed/simple;
	bh=Wf6l3xJbHA4p49zQlbo+LfnY4UnmOHpNp8GWcNjQcGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppEbirk5R50LTfqOrkLZPt4CovGnRb9lt1VQxmoiCJrHEcbgOAgeaCitOFLhE+T4u9vTUpNC86JYa2V7inCA3r18A0fIJ2YDVjX6x9FQ5RGh/FlGOm4zwWnTSFv5226n8cZY3arjTfJjLL+TlyGqwyiye5FzC/0JOEhqPWa82NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ENYS7+FK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ENYS7+FK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 832A4C4CEF5;
	Wed,  3 Dec 2025 16:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779139;
	bh=Wf6l3xJbHA4p49zQlbo+LfnY4UnmOHpNp8GWcNjQcGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ENYS7+FKdNpQLiXh8b6KyM7NIIv9Dfirgcw0/YYahKn/yNwDaMOLWw2PF8EPlA4e4
	 IyLCHcuVUBwzSu9/b6qbSc8UzSJfzdyk1hwPnkcVav3yJpvWiwWvd+UVBT9LoZaJVV
	 8rhf/gX64hMO5warP484qJuE1uOXdf6uOzg1LByY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 166/568] ALSA: usb-audio: Add validation of UAC2/UAC3 effect units
Date: Wed,  3 Dec 2025 16:22:48 +0100
Message-ID: <20251203152446.803714587@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 2aec0b6a6b5395bca7d6fde9c7e9dc391d329698 ]

Just add fixed struct size validations for UAC2 and UAC3 effect
units.  The descriptor has a variable-length array, so it should be
validated with a proper function later once when the unit is really
parsed and used by the driver (currently only referred partially for
the input terminal parsing).

Link: https://patch.msgid.link/20250821151751.12100-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/validate.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/usb/validate.c b/sound/usb/validate.c
index a0d55b77c9941..4bb4893f6e74f 100644
--- a/sound/usb/validate.c
+++ b/sound/usb/validate.c
@@ -266,7 +266,11 @@ static const struct usb_desc_validator audio_validators[] = {
 	FUNC(UAC_VERSION_2, UAC_MIXER_UNIT, validate_mixer_unit),
 	FUNC(UAC_VERSION_2, UAC_SELECTOR_UNIT, validate_selector_unit),
 	FUNC(UAC_VERSION_2, UAC_FEATURE_UNIT, validate_uac2_feature_unit),
-	/* UAC_VERSION_2, UAC2_EFFECT_UNIT: not implemented yet */
+	/* just a stop-gap, it should be a proper function for the array
+	 * once if the unit is really parsed/used
+	 */
+	FIXED(UAC_VERSION_2, UAC2_EFFECT_UNIT,
+	      struct uac2_effect_unit_descriptor),
 	FUNC(UAC_VERSION_2, UAC2_PROCESSING_UNIT_V2, validate_processing_unit),
 	FUNC(UAC_VERSION_2, UAC2_EXTENSION_UNIT_V2, validate_processing_unit),
 	FIXED(UAC_VERSION_2, UAC2_CLOCK_SOURCE,
@@ -286,7 +290,8 @@ static const struct usb_desc_validator audio_validators[] = {
 	FUNC(UAC_VERSION_3, UAC3_MIXER_UNIT, validate_mixer_unit),
 	FUNC(UAC_VERSION_3, UAC3_SELECTOR_UNIT, validate_selector_unit),
 	FUNC(UAC_VERSION_3, UAC3_FEATURE_UNIT, validate_uac3_feature_unit),
-	/*  UAC_VERSION_3, UAC3_EFFECT_UNIT: not implemented yet */
+	FIXED(UAC_VERSION_3, UAC3_EFFECT_UNIT,
+	      struct uac2_effect_unit_descriptor), /* sharing the same struct */
 	FUNC(UAC_VERSION_3, UAC3_PROCESSING_UNIT, validate_processing_unit),
 	FUNC(UAC_VERSION_3, UAC3_EXTENSION_UNIT, validate_processing_unit),
 	FIXED(UAC_VERSION_3, UAC3_CLOCK_SOURCE,
-- 
2.51.0



