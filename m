Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52BB33A015;
	Tue, 26 Aug 2025 13:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214086; cv=none; b=fcNvJ7gyE2NjPgLS2zHPdj+p0eLD7UHh4o/C3De+kMVoQo5hCfFC4e93X0UwJUBuIdkedsrJLTzJ2GuPinebB9APIVM8NjDiV29UPQ8EFGwWqruyGMc4HY8vB1V1Zxk8L8UAVa3m7qdqKDKH9BCsMBwfLb7sPJC1jC/WJHXQYvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214086; c=relaxed/simple;
	bh=A+JlO42FZDFZX2MVQ6Gxq6NUBbIq0gG5iemPLm5Mc80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtkxJLoqcxtQYhGpM518Hk76C0GC4HyzWKBGhjJKCsLtKndLy/JmlkNqGTXqul3gigkQKVFFyzAOg9VQOVP3X4GLCnI/qgnYplu/QthBT0PFOQA6HqY05SxfrAe7O2AIRk3Br9mF2ep3Jx9hqxi4e1ruuBInDkvzr7JAUzxaxs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRp2AQen; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRp2AQen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2812BC4CEF1;
	Tue, 26 Aug 2025 13:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214086;
	bh=A+JlO42FZDFZX2MVQ6Gxq6NUBbIq0gG5iemPLm5Mc80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRp2AQenoLyBxvIJdl0B0pKc0iu7+KMG0Q7faU9mh2y8X7CZM/OyknLJ4DxugEHpD
	 iCJZMlbAfBEdzayykLDKc8aDy3g0YNHe/1teCXYtmtQnGFbtfmzYTl9lvXxTuA8F5Z
	 ShHwboRp4uMwP5F076Kcd2cLNrEnrBPAhg5ZbsIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 584/587] ALSA: usb-audio: Use correct sub-type for UAC3 feature unit validation
Date: Tue, 26 Aug 2025 13:12:13 +0200
Message-ID: <20250826111007.891488937@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



