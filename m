Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C153376A9;
	Tue, 26 Aug 2025 11:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208160; cv=none; b=FgIG+7Dp0fPeBqbRrqDexLCGNdDQsPDRjwZh3+AsSHWyNv1maaI9+JyU46EgqvvboCTbfldLtRUdwJau1thj46WDVvRu9jHABMPxxPcJmwUeCL7bGPm77UYNErjPmKXvdV0KOdVKhZy8IVCGnol/g9+9Aq4XSEo/6Ci8xmusYBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208160; c=relaxed/simple;
	bh=/n783Cr5t3UTJ7vjNBsmAPgjx/O/gXQCqMkwcrcqmw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HA5+PRCKRtOHDKZdrjHieerzS98klnOeNNIRSmAr5mN9x0SK1b6ORTK1VF8Bb3L1va1+qt5WLBhRB8FE/fdzTgtbf+Ji9empZIzo9KImEHBdy1QHkOQmTnDEHq1DitsxI3zmHmGZ+nFywMBnSq2asdOm90KvNCVxI2wmSk3XnPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AqvT4NA1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AqvT4NA1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0843BC4CEF1;
	Tue, 26 Aug 2025 11:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208160;
	bh=/n783Cr5t3UTJ7vjNBsmAPgjx/O/gXQCqMkwcrcqmw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AqvT4NA1mNyab1TOjZ5+56uYS+t8QOHvzvmMk4P8hqrVXVusl8QToJnHSxzHTif6f
	 rMPJ6yspao6em7r5dv6QAXVe6jLvrXqXtEnq+1ZIxqR2IQee0s4W1kXbiR/JOBVoBp
	 lsQrHj5vTxSEkIE5o+YXOGIiadQUByam6awzh5yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 452/457] ALSA: usb-audio: Use correct sub-type for UAC3 feature unit validation
Date: Tue, 26 Aug 2025 13:12:16 +0200
Message-ID: <20250826110948.455097714@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 8410fe81093ff231e964891e215b624dabb734b0 ]

The entry of the validators table for UAC3 feature unit is defined
with a wrong sub-type UAC_FEATURE (= 0x06) while it should have been
UAC3_FEATURE (= 0x07).  This patch corrects the entry value.

Fixes: 57f8770620e9 ("ALSA: usb-audio: More validations of descriptor units")
Link: https://patch.msgid.link/20250821150835.8894-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/validate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/validate.c b/sound/usb/validate.c
index 4f4e8e87a14c..a0d55b77c994 100644
--- a/sound/usb/validate.c
+++ b/sound/usb/validate.c
@@ -285,7 +285,7 @@ static const struct usb_desc_validator audio_validators[] = {
 	/* UAC_VERSION_3, UAC3_EXTENDED_TERMINAL: not implemented yet */
 	FUNC(UAC_VERSION_3, UAC3_MIXER_UNIT, validate_mixer_unit),
 	FUNC(UAC_VERSION_3, UAC3_SELECTOR_UNIT, validate_selector_unit),
-	FUNC(UAC_VERSION_3, UAC_FEATURE_UNIT, validate_uac3_feature_unit),
+	FUNC(UAC_VERSION_3, UAC3_FEATURE_UNIT, validate_uac3_feature_unit),
 	/*  UAC_VERSION_3, UAC3_EFFECT_UNIT: not implemented yet */
 	FUNC(UAC_VERSION_3, UAC3_PROCESSING_UNIT, validate_processing_unit),
 	FUNC(UAC_VERSION_3, UAC3_EXTENSION_UNIT, validate_processing_unit),
-- 
2.50.1



