Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A18352060;
	Tue, 26 Aug 2025 14:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219487; cv=none; b=I0r4qD1TzT2Miy2M3Mw9Cw2kg05msVzYyB5BGLlAk55PCXMvPSogrQ4uWsTeRbm6Dyy78/3jJzSPWy2BkKKf4kXR3eaOJRryQSalp5AtTbqvVxmzpuDr1sIw2oPk04HI+Hc6ZagMWw/dlwMAiVjXuFMbZ4kmWuTgMezvHPIEiqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219487; c=relaxed/simple;
	bh=RgZGRwIf768te9/qumK4BbVxmPUVtNuSrQzyiVO7Mxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h92qZJylYmwcePMAVIblx9ZiyDuMq5T1CtPOFLA5YybVYeFAS54nM9atHXHl54Rb4f5+8mX1JNIaDRfIazCN8muxtbvZI5Zi6x/JU1hjDnqrsT+zJiXwco0NjE6t0ngb3QasFuRkBpq/cbj6u8r2zJD6IPa9V4r047TtvAb+CaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pIoQrgOf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pIoQrgOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8348C4CEF1;
	Tue, 26 Aug 2025 14:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219487;
	bh=RgZGRwIf768te9/qumK4BbVxmPUVtNuSrQzyiVO7Mxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pIoQrgOfXClsQKQPIKlvJttLAMzl+lPRgDO85TZV+fqkNBsNtw9jNw2EMJJc0PU+y
	 CKSGTv0pHTPpCEBKlxuYHUrafawMtJhxO7yE3fnlqAPOvSK94xnICfHf04rw0MVmr9
	 XCa6ieO85QXv/ARwYa6gXJSAw6azqC1p8yG06YBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 401/403] ALSA: usb-audio: Use correct sub-type for UAC3 feature unit validation
Date: Tue, 26 Aug 2025 13:12:07 +0200
Message-ID: <20250826110918.115186581@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 4ee2a328cb5b..46cf36ab0acd 100644
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



