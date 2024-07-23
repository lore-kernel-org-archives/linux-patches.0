Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A087213D609;
	Tue, 23 Jul 2024 11:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721735553; cv=none; b=LSI8KG+BxECSMaeay/hbJ6SBEFFiLkHvvPyMCwJr22pBBXkXrjfrqwDRYAC8160aUgBAeq34iTT+gx40KJ/4OVpFTc2DXv9WQqDAnnxZBHkJVGqcP9hAbVV2YrQxHcXc5ng+mmWE14QA5Zp/Zm3Ymihk19c0t5yZa0FCCNfj02g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721735553; c=relaxed/simple;
	bh=J0E8oMyKLE7pwTrDxEnXrTWStDtsPpGOVWunZo+U2q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rM/daWF/BDL3ZjF+mGJvuQ0iwj7x8LOJIYXZEnqWvm7+ZjfK2a/Y1srYqSiG4QxR0i9GWBLXZjv2d6z8B4RNkgxODb59q5H+IqqqB0E6sqGi0ZzOJSEyA1qP47a9DBomYG0hxZND3WIh2+u4VND+xfgOu7mD67KKtrbZeKZaGYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qzlZBBw+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qzlZBBw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1BBC4AF09;
	Tue, 23 Jul 2024 11:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721735553;
	bh=J0E8oMyKLE7pwTrDxEnXrTWStDtsPpGOVWunZo+U2q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qzlZBBw+IyV/OE3Ky+0bEvu3Uk2apLW2+fx7hJ7R7115xa0yXpVxnEkJMrkaOWKhY
	 tzI1oHFilncpOvOSsGeNDUUqaCoaTXRvt+VyKhhENl4ixCcrzrXRm/O/ynbJPrTYdb
	 L1OIMVT4VgZS3N9mWFO1l2aVNajDttfrHWEhWT9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.10 8/9] ASoC: cs35l56: Use header defines for Speaker Volume control definition
Date: Tue, 23 Jul 2024 13:52:02 +0200
Message-ID: <20240723114047.577982361@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723114047.281580960@linuxfoundation.org>
References: <20240723114047.281580960@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

commit c66995ae403073212f5ba60d2079003866c6e130 upstream.

The "Speaker Volume" control was being defined using four hardcoded magic
numbers. There are #defines in the cs35l56.h header for these numbers, so
change the code to use the defined constants.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20240703095517.208077-2-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/cs35l56.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -196,7 +196,11 @@ static const struct snd_kcontrol_new cs3
 		       cs35l56_dspwait_get_volsw, cs35l56_dspwait_put_volsw),
 	SOC_SINGLE_S_EXT_TLV("Speaker Volume",
 			     CS35L56_MAIN_RENDER_USER_VOLUME,
-			     6, -400, 400, 9, 0,
+			     CS35L56_MAIN_RENDER_USER_VOLUME_SHIFT,
+			     CS35L56_MAIN_RENDER_USER_VOLUME_MIN,
+			     CS35L56_MAIN_RENDER_USER_VOLUME_MAX,
+			     CS35L56_MAIN_RENDER_USER_VOLUME_SIGNBIT,
+			     0,
 			     cs35l56_dspwait_get_volsw,
 			     cs35l56_dspwait_put_volsw,
 			     vol_tlv),


