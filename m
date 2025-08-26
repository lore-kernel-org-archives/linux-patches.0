Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B7D13FD86;
	Tue, 26 Aug 2025 13:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215346; cv=none; b=Ax8o3G1eKYKN/a5tnJNdUAN2ZQU3CzJIPDCn6GQF2kAZ4TN4gBwKvDJQijeK66MvTJCv5yGL+Ya6xASzSnXc4Sk5vRALnpa3gjTDFuV+wTh+VgzimmuJXadDQx6SVz123gCTJtxNvAHDU7D+U8Kjaf86uW6sVhQ9n1i0V0rhsvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215346; c=relaxed/simple;
	bh=BePGml9hq//1sdL/+57hH/dWzyo04arw92lhHseqpTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWPfHdWhk0SyVFUfK5QfRLauxUFR9zJjW/wODSuOtG3mut9gbCW2vocNf3ZTt5Z+4MdyIi+7TLFq8/nahi74d/A9rOJWUtqlURBSs4MTpyf+9JaY0IPW3ARcSJkJAn06znqken95udM3rebCFkXQe3WQcAZsjrvCK/HEilBO3Js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jf2e+jfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jf2e+jfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A93C4CEF1;
	Tue, 26 Aug 2025 13:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215346;
	bh=BePGml9hq//1sdL/+57hH/dWzyo04arw92lhHseqpTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jf2e+jfso22VRBSFdwBshpPsxKqPyEJYnrVj+RUaZRsbbvUCdD+frKtWMhJmcIup6
	 /8goHCeodoojrboWLFRFDy0VYpOEcKvxiy98KwljGn5MTdq+/+190TUaod8LzW/Thj
	 R7/jIuDzFyoRjAUowSvDTUVyWWR+PmHOS2nZzXRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 479/482] ALSA: usb-audio: Use correct sub-type for UAC3 feature unit validation
Date: Tue, 26 Aug 2025 13:12:12 +0200
Message-ID: <20250826110942.649674693@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



