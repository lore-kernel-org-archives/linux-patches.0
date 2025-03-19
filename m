Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8334A1D6DBC;
	Wed, 19 Mar 2025 14:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394923; cv=none; b=M0HJ+OoqCYyEAu9x8Hujl47q0NTtwHyxItqokZoDf+u7jZ2y3gT7jwdaSkVIOlr3t4bwIr/NlPNQc5bQMu7cZHQGiLPTNwgp3TQAhbyu1tRWjfLZmp3XihWiiqTVNZtHQncaV0Pta+TLiFeeudKoUMqncKH7MahiFeCEQCZjxao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394923; c=relaxed/simple;
	bh=yT9VrFJz7rR5fpIilGIl2jKvyk/AW5SAkqfLN87TWdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdzw+Ut56jHH7PdAlbBIdM6px51dDD5Z5Lv84e2CCvq26ZnUbZz5JolLa5jnTolNhRVslO/g3/uQIcyFMq/Mg+PjmbpgKVTMOLGRXv5cE7SXK88bn5MVBp4EOJpgkqtIiUQXJk/dtID7R7ytUcAWMpBDKXERs2oYG071d0cmOrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2GOfVSB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2GOfVSB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58408C4CEE4;
	Wed, 19 Mar 2025 14:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394923;
	bh=yT9VrFJz7rR5fpIilGIl2jKvyk/AW5SAkqfLN87TWdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2GOfVSB60yIhDDUksKdUJUI39B1Y90kZyinE78Z865MwmCPPxQCDwMUd+EPgnoUvl
	 tYMF+e1YnxRuD81bNffFsepMNTLzY1+Iho065aTzVY3Jspr0CHLSHJpk/JrK6qPEGz
	 8vtYlZvYHkzZ2ghYPRnQRiOHCAq3qcdNu3nrkPGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	Hector Martin <marcan@marcan.st>,
	James Calligeros <jcalligeros99@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 135/241] ASoC: tas2764: Fix power control mask
Date: Wed, 19 Mar 2025 07:30:05 -0700
Message-ID: <20250319143031.068563623@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hector Martin <marcan@marcan.st>

[ Upstream commit a3f172359e22b2c11b750d23560481a55bf86af1 ]

Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: James Calligeros <jcalligeros99@gmail.com>
Link: https://patch.msgid.link/20250218-apple-codec-changes-v2-1-932760fd7e07@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2764.h b/sound/soc/codecs/tas2764.h
index 168af772a898f..d13ecae9c9c2f 100644
--- a/sound/soc/codecs/tas2764.h
+++ b/sound/soc/codecs/tas2764.h
@@ -25,7 +25,7 @@
 
 /* Power Control */
 #define TAS2764_PWR_CTRL		TAS2764_REG(0X0, 0x02)
-#define TAS2764_PWR_CTRL_MASK		GENMASK(1, 0)
+#define TAS2764_PWR_CTRL_MASK		GENMASK(2, 0)
 #define TAS2764_PWR_CTRL_ACTIVE		0x0
 #define TAS2764_PWR_CTRL_MUTE		BIT(0)
 #define TAS2764_PWR_CTRL_SHUTDOWN	BIT(1)
-- 
2.39.5



