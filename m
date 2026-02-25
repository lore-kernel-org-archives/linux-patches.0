Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2A02BAF7;
	Wed, 25 Feb 2026 01:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983092; cv=none; b=p4kEAKK09c6R4SBkCojjGDECflSBdDpmkOO8umNoMZNwh00Vo/2o9nIb/WaN5XJTn03oQjOEDrovscXNDTOPxdxNKI7C3F87AUGxs0uUujWwEtVtWVVGSnTAn8qOm9hK7BqwAJPpV7fnN6qJDdskHvkoK27z9AEpLY5xAt9lSfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983092; c=relaxed/simple;
	bh=srBqElJWZIXoknxESi8Ii+zfqfWFI/zpnMywVt8rjvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hy7dN8lLsgOiNiL/+GIUOW/TW2VCN4JMk8HwFLOQD+HTm4Yjaf9sqGaWUB8/6WA5W0pNchyrvIpHM4odioPYft0aB1DKpND5fZRveNI8L/6CYF9O3PBrPBEMG2eRK2WcfFEGNeJbiiTnfFoEv3M9DVRIA1Qyj3OF4Ca97PXCVms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gYcos7V3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gYcos7V3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E32AC116D0;
	Wed, 25 Feb 2026 01:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983092;
	bh=srBqElJWZIXoknxESi8Ii+zfqfWFI/zpnMywVt8rjvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYcos7V3ayCKH060LNxOI2ixSqSDIDwY2kKmhhG352nPOca1TWUPJARQzuBwHu3HL
	 4EUe901VY7ir52cGLrRFTZzyRyGifTO42XynIbQ1Y1bUmb64aKYRHZmlX4WYS7wRBW
	 AsbzV+//ZXgy4slU2mISuQXuZbtjW5hnQSiByFOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 251/781] ALSA: hda - fix function names & missing function parameter
Date: Tue, 24 Feb 2026 17:16:00 -0800
Message-ID: <20260225012405.866296070@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit b47ce586300b3c2b6650f4c7ac5c0f59c6bf6f4b ]

Use the correct function names and add a function parameter description
to avoid kernel-doc warnings:

hda_jack.h:97: warning: Function parameter or struct member 'cb' not
 described in 'snd_hda_jack_detect_enable_callback'
hda_jack.h:97: warning: expecting prototype for snd_hda_jack_detect_enable().
 Prototype was for snd_hda_jack_detect_enable_callback() instead
hda_local.h:441: warning: expecting prototype for _snd_hda_set_pin_ctl().
 Prototype was for snd_hda_set_pin_ctl() instead

Fixes: cdd03cedc5b5 ("ALSA: hda - Introduce snd_hda_set_pin_ctl*() helper functions")
Fixes: 5204a05d70d9 ("ALSA: hda - Add DP-MST jack support")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://patch.msgid.link/20260106185951.2179242-1-rdunlap@infradead.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/common/hda_jack.h  | 4 ++--
 sound/hda/common/hda_local.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/hda/common/hda_jack.h b/sound/hda/common/hda_jack.h
index ff7d289c034bf..e9b9970c59ed4 100644
--- a/sound/hda/common/hda_jack.h
+++ b/sound/hda/common/hda_jack.h
@@ -82,10 +82,10 @@ snd_hda_jack_detect_enable_callback_mst(struct hda_codec *codec, hda_nid_t nid,
 					int dev_id, hda_jack_callback_fn func);
 
 /**
- * snd_hda_jack_detect_enable - enable the jack-detection
+ * snd_hda_jack_detect_enable_callback - enable the jack-detection
  * @codec: the HDA codec
  * @nid: pin NID to enable
- * @func: callback function to register
+ * @cb: callback function to register
  *
  * In the case of error, the return value will be a pointer embedded with
  * errno.  Check and handle the return value appropriately with standard
diff --git a/sound/hda/common/hda_local.h b/sound/hda/common/hda_local.h
index a7e53277a0fea..ab423f1cef549 100644
--- a/sound/hda/common/hda_local.h
+++ b/sound/hda/common/hda_local.h
@@ -424,7 +424,7 @@ int _snd_hda_set_pin_ctl(struct hda_codec *codec, hda_nid_t pin,
 			 unsigned int val, bool cached);
 
 /**
- * _snd_hda_set_pin_ctl - Set a pin-control value safely
+ * snd_hda_set_pin_ctl - Set a pin-control value safely
  * @codec: the codec instance
  * @pin: the pin NID to set the control
  * @val: the pin-control value (AC_PINCTL_* bits)
-- 
2.51.0



